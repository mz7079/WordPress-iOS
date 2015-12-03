import UIKit

class CreateNewSiteViewController: WPNUXAbstractCreationViewController
{
    override func viewDidLoad() {
        icon.hidden = true
        mainHelperButton.hidden = true
    }
    
    override func titleLabelString() -> String {
        return NSLocalizedString("Create a new WordPress.com site", comment: "Create a new WordPress.com site title")
    }
    
    override func allTextFields() -> [WPWalkthroughTextField] {
        var textFieldsArray = [WPWalkthroughTextField]()
        
        let siteTitleField = WPWalkthroughTextField(leftViewImage: UIImage(named: "icon-pencil"))
        siteTitleField.backgroundColor = UIColor.whiteColor()
        siteTitleField.placeholder = NSLocalizedString("Title", comment: "Title field")
        siteTitleField.font = WPNUXUtility.textFieldFont()
        siteTitleField.adjustsFontSizeToFitWidth = true
        siteTitleField.delegate = self
        siteTitleField.autocorrectionType = .No
        siteTitleField.autocapitalizationType = .None
        siteTitleField.accessibilityLabel = NSLocalizedString("Title", comment: "Title field")
        siteTitleField.returnKeyType = .Next
        
        textFieldsArray.append(siteTitleField)
        
        return textFieldsArray
    }
    
    override func mainButtonString() -> String {
        return NSLocalizedString("Create Account", comment: "Create account button")
    }
}
