import UIKit
import WordPressShared

class CreateAccountAndSiteViewController: WPNUXAbstractCreationViewController
{
    let usernameIndex = 1
    let passwordIndex = 2
    let siteAddressIndex = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        icon.hidden = true
    }
    
    override func titleLabelString() -> String {
        return NSLocalizedString("Create an account on WordPress.com", comment: "Create an account on WordPress.com")
    }
    
    override internal func createNewTextFields() {
        let emailField = WPWalkthroughTextField(textWithLeftViewImage: UIImage(named: "icon-email-field"), placeholder: NSLocalizedString("Email Address", comment: "Email Address field"), returnKeyType: .Next, delegate: self)
        
        let usernameField = WPWalkthroughTextField(textWithLeftViewImage: UIImage(named: "icon-username-field"), placeholder: NSLocalizedString("Username", comment: "Username field"), returnKeyType: .Next, delegate: self)
        
        let passwordField = WPWalkthroughTextField(textWithLeftViewImage: UIImage(named: "icon-password-field"), placeholder: NSLocalizedString("Password", comment: "Password field"), returnKeyType: .Next, delegate: self)
        
        let siteAddressField = WPWalkthroughTextField(textWithLeftViewImage: UIImage(named: "icon-url-field"), placeholder: NSLocalizedString("Site Address (URL)", comment: "Site Address (URL) field"), returnKeyType: .Done, delegate: self)
        
        textFieldsArray.append(emailField)
        textFieldsArray.append(usernameField)
        textFieldsArray.append(passwordField)
        textFieldsArray.append(siteAddressField)
    }
    
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        let textFieldIndex = textField.tag
        let usernameTextField = textFieldsArray[usernameIndex]
        let passwordTextField = textFieldsArray[passwordIndex]
        let siteAddressTextField = textFieldsArray[siteAddressIndex]
        if textFieldIndex == passwordTextField && !siteAddressTextField.hasText() {
            let lowerCaseNoSpaceTitle = usernameTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).lowercaseString
            siteAddressTextField.text = lowerCaseNoSpaceTitle
            
            let nextResponder = textField.superview?.viewWithTag(textFieldIndex + 1) as UIResponder!
            nextResponder?.becomeFirstResponder()
            
            return false
        } else {
            return super.textFieldShouldReturn(textField)
        }
    }
    
    override func mainButtonString() -> String {
        return NSLocalizedString("Create Account", comment: "Create account button")
    }
    
    override func mainHelperButtonString() -> String {
        return ""
    }
}
