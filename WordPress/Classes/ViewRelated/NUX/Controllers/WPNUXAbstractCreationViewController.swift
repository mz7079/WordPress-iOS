import UIKit

class WPNUXAbstractCreationViewController: UIViewController
{
    @IBOutlet weak var dismissButton: WPNUXSecondaryButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textFields: UIStackView!
    @IBOutlet weak var mainButton: WPNUXMainButton!
    @IBOutlet weak var mainHelperButton: WPNUXSecondaryButton!

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = WPStyleGuide.wordPressBlue()
        addTapGestureRecognizer()
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "backgroundTapGestureAction")
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        let keyboardHeight = info.objectForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue().size.height
        
        self.view.contentInset.bottom = keyboardHeight!
        self.view.scrollIndicatorInsets.bottom = keyboardHeight!
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInsets = postTextView.contentInset
        self.view.contentInset = UIEdgeInsetsMake(contentInsets.top, contentInsets.left, zeroPadding, contentInsets.right)
    }
    
    func backgroundTapGestureAction() {
        
    }
}
