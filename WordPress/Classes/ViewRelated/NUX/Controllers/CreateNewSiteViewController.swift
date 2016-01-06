import UIKit
import WordPressShared

class CreateNewSiteViewController: WPNUXAbstractCreationViewController
{
    let sizePadding: CGFloat = 10
    let siteTitleIndex = 0
    let siteAddressIndex = 1
    var isAuthenticating: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        icon.hidden = true
        mainHelperButton.hidden = true
    }
    
    override func titleLabelString() -> String {
        return NSLocalizedString("Create a new WordPress.com site", comment: "Create a new WordPress.com site title")
    }
    
    override internal func createNewTextFields() {
        let siteTitleField = WPWalkthroughTextField(textWithLeftViewImage: UIImage(named: "icon-pencil"), placeholder: NSLocalizedString("Title", comment: "Title field"), returnKeyType: .Next, delegate: self)
        
        let siteAddressField = WPWalkthroughTextField(leftViewImage: UIImage(named: "icon-url-field"), rightLabelText: ".wordpress.com", placeholder: NSLocalizedString("Site Address", comment: "Site Address"), returnKeyType: .Done, delegate: self)
        
        textFieldsArray.append(siteTitleField)
        textFieldsArray.append(siteAddressField)
    }
    
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        let textFieldIndex = textField.tag
        let siteAddressTextField = textFieldsArray[siteAddressIndex]
        if textFieldIndex == siteTitleIndex && !siteAddressTextField.hasText() {
            let lowerCaseNoSpaceTitle = textField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).lowercaseString
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
}
