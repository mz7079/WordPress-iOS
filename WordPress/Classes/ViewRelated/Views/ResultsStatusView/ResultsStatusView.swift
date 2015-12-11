import UIKit
import WordPressShared

/**
 *  @brief  Called when a ResultStatusView's button is tapped
 */
@objc public protocol ResultsStatusViewDelegate
{
    optional func didTapResultsStatusView(sender: ResultsStatusView)
}

/**
 *  @brief      Displays informational string with possible adornments
 *	@details    Intended to embed in a contentless container with an
 *              explanation (fetching, empty, no connection...)
 */
public class ResultsStatusView: UIStackView
{
    // MARK: - Public Properties

    public var titleText: String? {
        get {
            return titleLabel.text
        }
        set {
            guard titleText != newValue else {
                return
            }
            let title = newValue ?? ""
            titleLabel.hidden = title.isEmpty
            titleLabel.attributedText = Style.attributedTitle(title)
            setNeedsUpdateConstraints()
        }
    }

    public var messageText: String? {
        get {
            return messageLabel.text
        }
        set {
            guard messageText != newValue else {
                return
            }
            let message = newValue ?? ""
            messageLabel.hidden = message.isEmpty
            messageLabel.text = message
            setNeedsUpdateConstraints()
        }
    }
    
    public var buttonTitle: String? {
        get {
            return button.titleForState(.Normal)
        }
        set {
            guard buttonTitle != newValue else {
                return
            }
            let title = newValue ?? ""
            button.hidden = title.isEmpty
            button.setTitle(title, forState: .Normal)
            button.sizeToFit()
            setNeedsUpdateConstraints()
        }
    }
   
    public var accessoryView: UIView? {
        didSet {
            if let remove = oldValue where remove != accessoryView {
                remove.removeFromSuperview()
            }
            guard let add = accessoryView  else {
                return
            }
            insertArrangedSubview(add, atIndex: 0)
        }
    }

    public weak var delegate:ResultsStatusViewDelegate?
    
    // MARK - Private Properties

    private typealias Style = WPStyleGuide.ResultsStatusView

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.hidden = true
        label.numberOfLines = 0
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.hidden = true
        label.numberOfLines = 0
        Style.applyMessageStyle(label)
        return label
    }()

    private let button: UIButton = {
        let button = UIButton(type: .Custom)
        button.hidden = true
        Style.applyButtonStyle(button)
        return button
    }()

    // MARK: - Initialization
    
    public class func resultsStatusViewWithTitle(title: String?, message:String? = nil, accessoryView: UIView? = nil, buttonTitle: String? = nil) -> ResultsStatusView {
        let resultsStatusView = ResultsStatusView()
    
        resultsStatusView.accessoryView = accessoryView
        resultsStatusView.titleText = title
        resultsStatusView.messageText = message
        resultsStatusView.buttonTitle = buttonTitle
        
        return resultsStatusView
    }

    public convenience init() {
        self.init(frame: CGRectZero)
    }

    required override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }

    private func setupView() {
        axis = .Vertical
        alignment = .Center
        spacing = 0
        translatesAutoresizingMaskIntoConstraints = false
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(messageLabel)
        addArrangedSubview(button)

        widthAnchor.constraintEqualToConstant(Style.width).active = true
        titleLabel.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true
        messageLabel.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true

        button.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
    }
    
    // MARK: - Layout Methods
    
    public func showInView(view: UIView, animated: Bool = false) {
        guard view != superview else {
            return
        }
        
        if superview != nil {
            removeFromSuperview()
        }
        view.addSubview(self)
        view.bringSubviewToFront(self)
        
        if animated {
            view.fadeInWithAnimation()
        }
    }

    public override func didMoveToSuperview() {
        centerInSuperview()
    }
    
    private func centerInSuperview() {
        guard let margins = superview?.layoutMarginsGuide else {
            return
        }
        
        centerXAnchor.constraintEqualToAnchor(margins.centerXAnchor).active = true
        centerYAnchor.constraintEqualToAnchor(margins.centerYAnchor).active = true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }

    public override func updateConstraints() {
      super.updateConstraints()
    }
    
    // MARK: - Actions
    
    func didTapButton(sender: UIButton) {
        delegate?.didTapResultsStatusView?(self)
    }

}
