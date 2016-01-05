import UIKit
import WordPressShared

public class WPNUXAbstractCreationViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var dismissButton: WPNUXSecondaryButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textFields: UIStackView!
    @IBOutlet weak var mainButton: WPNUXMainButton!
    @IBOutlet weak var mainHelperButton: WPNUXSecondaryButton!
    var textFieldsArray: [WPWalkthroughTextField] = []

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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textDidChange", name: UITextFieldTextDidChangeNotification, object: nil)
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
    
    @IBAction func mainButtonTapped(sender: AnyObject) {
        
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        let textFieldIndex = textField.tag
        
        if textFieldIndex == lastTextFieldIndex() {
            mainButtonTapped(self)
        } else {
            let nextResponder = textField.superview?.viewWithTag(textFieldIndex + 1) as UIResponder!
            nextResponder?.becomeFirstResponder()
        }
        
        return false
    }
    
    func lastTextFieldIndex() -> Int {
        return textFieldsArray.count - 1
    }
    
    func keyboardDidShow() {
    }
    
    func keyboardWillHide() {
    }
    
    func textDidChange() {
        mainButton.enabled = areFieldsValid()
    }
    
    public func titleLabelString() -> String {
        return String()
    }
    
    public func createNewTextFields() {
        textFieldsArray = [WPWalkthroughTextField]()
    }
    
    public func mainButtonString() -> String {
        return String()
    }
    
    public func mainHelperButtonString() -> String {
        return String()
    }
    
    public func configureTitle() {
        let titleAttributes: [String : AnyObject] = WPNUXUtility.titleAttributesWithColor(UIColor.whiteColor()) as! [String : AnyObject]
        titleLabel.attributedText = NSAttributedString(string: titleLabelString(), attributes: titleAttributes)
    }
    
    public func configureTextFields() {
        createNewTextFields()
        var index = 0
        
        for textField in textFieldsArray {
            textField.tag = index
            textField.heightAnchor.constraintEqualToConstant(44.0).active = true
            textField.widthAnchor.constraintEqualToConstant(320.0).active = true
            textFields.addArrangedSubview(textField)
            index++
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
    
    func areFieldsValid() -> Bool {
        return areAllTextFieldsFilled()
    }
    
    func areAllTextFieldsFilled() -> Bool {
        for textField in textFieldsArray {
            if !textField.hasText() {
                return false
            }
        }
        
        return true
    }
}
