import UIKit

class WPNUXAbstractCreationViewController: UIViewController
{
    var leftBarButton: WPNUXSecondaryButton
    var helpBadgeLabel: WPNUXHelpBadgeLabel
    var icon: UIImageView
    var titleLabel: UILabel
    var textFields: [WPWalkthroughTextField]
    var mainButton: WPNUXMainButton
    var mainHelperButton: WPNUXSecondaryButton

    required init?(coder aDecoder: NSCoder) {
        leftBarButton = WPNUXSecondaryButton()
        helpBadgeLabel = WPNUXHelpBadgeLabel(frame:CGRectMake(0, 0, 12, 10))
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
        self.registerForKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
    }
}
