import UIKit

public class WPNUXAbstractCreationViewController: UIViewController, UITextFieldDelegate
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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = WPStyleGuide.wordPressBlue()
        configureTitle()
        configureTextFields()
        configureMainButton()
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
    
    public func titleLabelString() -> String {
        return String()
    }
    
    public func allTextFields() -> [WPWalkthroughTextField] {
        return [WPWalkthroughTextField]()
    }
    
    public func mainButtonString() -> String {
        return String()
    }
    
    public func mainHelperButtonString() -> String {
        return String()
    }
    
    func configureTitle() {
        let titleAttributes: [String : AnyObject] = WPNUXUtility.titleAttributesWithColor(UIColor.whiteColor()) as! [String : AnyObject]
        titleLabel.attributedText = NSAttributedString(string: titleLabelString(), attributes: titleAttributes)
    }
    
    public func configureTextFields() {
        let textFieldsArray = allTextFields()
        for textField in textFieldsArray {
            textField.frame = CGRectMake(0.0, 0.0, 320.0, 44.0)
            textFields.addArrangedSubview(textField)
        }
    }
    
    public func configureMainButton() {
        mainButton.setTitle(mainButtonString(), forState: .Normal)
    }
    
    public func configureMainHelperButton() {
        mainHelperButton.setTitle(mainHelperButtonString(), forState: .Normal)
    }
    
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
