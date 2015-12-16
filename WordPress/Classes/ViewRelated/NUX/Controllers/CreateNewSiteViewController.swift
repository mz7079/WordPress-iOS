import UIKit
import WordPressShared

class CreateNewSiteViewController: WPNUXAbstractCreationViewController
{
    let sizePadding: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        icon.hidden = true
        mainHelperButton.hidden = true
    }
    
    override func titleLabelString() -> String {
        return NSLocalizedString("Create a new WordPress.com site", comment: "Create a new WordPress.com site title")
    }
    
    override func allTextFields() -> [WPWalkthroughTextField] {
        var textFieldsArray = [WPWalkthroughTextField]()
        
        let siteTitleField = WPWalkthroughTextField(textWithLeftViewImage: UIImage(named: "icon-pencil"), placeholder: NSLocalizedString("Title", comment: "Title field"), returnKeyType: .Next, delegate: self)
        siteTitleField.heightAnchor.constraintEqualToConstant(44.0).active = true
        siteTitleField.widthAnchor.constraintEqualToConstant(320.0).active = true
        
        let siteAddressField = WPWalkthroughTextField(leftViewImage: UIImage(named: "icon-url-field"), rightLabelText: ".wordpress.com", placeholder: NSLocalizedString("Site Address", comment: "Site Address"), returnKeyType: .Done, delegate: self)
        siteAddressField.heightAnchor.constraintEqualToConstant(44.0).active = true
        siteAddressField.widthAnchor.constraintEqualToConstant(320.0).active = true
        
        textFieldsArray.append(siteTitleField)
        textFieldsArray.append(siteAddressField)
        
        return textFieldsArray
    }
    
    override func mainButtonString() -> String {
        return NSLocalizedString("Create Account", comment: "Create account button")
    }
}
