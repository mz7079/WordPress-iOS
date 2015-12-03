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
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    @IBAction func scrollViewTapped(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func dismissButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func helpButtonTapped(sender: AnyObject) {
        let supportViewController = SupportViewController()
        let supportNavigationController = UINavigationController(rootViewController: supportViewController)
        supportNavigationController.navigationBar.translucent = false
        supportNavigationController.modalPresentationStyle = .FormSheet
        self.navigationController?.presentViewController(supportNavigationController, animated: true, completion: nil)
    }
    
    func keyboardDidShow(notification: NSNotification) {
    }
    
    func keyboardWillHide(notification: NSNotification) {
    }
}
