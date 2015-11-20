import UIKit

class WPNUXAbstractCreationViewController: UIViewController
{
    let siteLeftButtonInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 7.0, bottom: 0.0, right: 15.0)
    let siteTopButtonPaddingPad: UIEdgeInsets = UIEdgeInsets(top: 1.0, left: 0.0, bottom: 0.0, right: 20.0)
    let siteTopButtonPadding: UIEdgeInsets = UIEdgeInsets(top: 1.0, left: 0.0, bottom: 0.0, right: 13.0)
    let siteStatusBarOffset: CGFloat = 20.0
    
    var leftBarButton: WPNUXSecondaryButton
    var helpButton: UIButton
    var icon: UIImageView
    var titleLabel: UILabel
    var textFields: [WPWalkthroughTextField]
    var mainButton: WPNUXMainButton
    var mainHelperButton: WPNUXSecondaryButton
    
    init() {
        leftBarButton = WPNUXSecondaryButton()
        helpButton = UIButton(type: .Custom)
        icon = UIImageView(image: UIImage(named:"icon-wp"))
        titleLabel = UILabel()
        textFields = [WPWalkthroughTextField]()
        mainButton = WPNUXMainButton()
        mainHelperButton = WPNUXSecondaryButton()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        leftBarButton = WPNUXSecondaryButton()
        helpButton = UIButton(type: .Custom)
        icon = UIImageView(image: UIImage(named:"icon-wp"))
        titleLabel = UILabel()
        textFields = [WPWalkthroughTextField]()
        mainButton = WPNUXMainButton()
        mainHelperButton = WPNUXSecondaryButton()
        super.init(coder: aDecoder)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        configureViews()
        layoutViews()
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func configureViews() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = WPStyleGuide.wordPressBlue()
        addTapGestureRecognizer()
        configureAndAddHelpButton()
        configureAndAddLeftBarButton()
    }
    
    func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "backgroundTapGestureAction")
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func configureAndAddHelpButton() {
        let helpButtonImage = UIImage(named: "btn-help")
        helpButton.accessibilityLabel = NSLocalizedString("Help", comment: "Help button")
        helpButton.setImage(helpButtonImage, forState: .Normal)
        helpButton.frame = CGRectMake(15.0, 15.0, helpButtonImage!.size.width, helpButtonImage!.size.height)
        helpButton.autoresizingMask = [.FlexibleRightMargin, .FlexibleLeftMargin]
        helpButton.addTarget(self, action: "helpButtonTapped", forControlEvents: .TouchUpInside)
        helpButton.sizeToFit()
        helpButton.exclusiveTouch = true
        
        view.addSubview(helpButton)
    }
    
    func configureAndAddLeftBarButton() {
        leftBarButton.setTitle(NSLocalizedString("Cancel", comment: "Cancel button"), forState: .Normal)
        leftBarButton.addTarget(self, action: "leftBarButtonTapped", forControlEvents: .TouchUpInside)
        leftBarButton.exclusiveTouch = true
        leftBarButton.titleEdgeInsets = siteLeftButtonInsets
        leftBarButton.sizeToFit()
        leftBarButton.autoresizingMask = .FlexibleRightMargin
        
        view.addSubview(leftBarButton)
    }
    
    func layoutViews() {
        var x: CGFloat
        var y: CGFloat
        
        let viewWidth = CGRectGetWidth(self.view.bounds)
        let viewHeight = CGRectGetHeight(UIScreen.mainScreen().bounds)
        
        let topButtonPadding = UIDevice.isPad() ? siteTopButtonPaddingPad : siteTopButtonPadding
        
        x = viewWidth - helpButton.frame.size.width - topButtonPadding.right
        y = siteStatusBarOffset + topButtonPadding.top
        helpButton.frame = CGRectMake(x, y, helpButton.frame.width, helpButton.frame.height)
        
        x = topButtonPadding.left
        y = siteStatusBarOffset + siteTopButtonPadding.top
        leftBarButton.frame = CGRectMake(x, y, leftBarButton.frame.width, leftBarButton.frame.height)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
    }
    
    func backgroundTapGestureAction() {
        
    }
    
    func helpButtonTapped() {
        
    }
    
    func leftBarButtonTapped() {
        
    }
}
