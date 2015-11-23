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
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
    }
    
    func backgroundTapGestureAction() {
        
    }
}
