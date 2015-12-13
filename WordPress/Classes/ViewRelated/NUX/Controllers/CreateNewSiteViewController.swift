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
        
        let siteAddressField = WPWalkthroughTextField(leftViewImage: UIImage(named: "icon-url-field"))
        siteTitleField.backgroundColor = UIColor.whiteColor()
        siteTitleField.placeholder = NSLocalizedString("Site Address", comment: "Site Address")
        siteTitleField.font = WPNUXUtility.textFieldFont()
        siteTitleField.adjustsFontSizeToFitWidth = true
        siteTitleField.delegate = self
        siteTitleField.autocorrectionType = .No
        siteTitleField.autocapitalizationType = .None
        siteTitleField.accessibilityLabel = NSLocalizedString("Title", comment: "Title field")
        siteTitleField.returnKeyType = .Done
        siteTitleField.showTopLineSeparator = true
        
        let siteAddressWPComLabel = UILabel()
        siteAddressWPComLabel.text = ".wordpress.com"
        siteAddressWPComLabel.textAlignment = .Center
        siteAddressWPComLabel.font = WPNUXUtility.descriptionTextFont()
        siteAddressWPComLabel.textColor = WPStyleGuide.allTAllShadeGrey()
        siteAddressWPComLabel.sizeToFit()
        
        var siteAddressTextInsets = siteAddressField.textInsets
        siteAddressTextInsets.right += siteAddressWPComLabel.frame.size.width + sizePadding
        siteAddressField.textInsets = siteAddressTextInsets
        siteAddressField.addSubview(siteAddressWPComLabel)

        textFieldsArray.append(siteTitleField)
        textFieldsArray.append(siteAddressField)
        
        return textFieldsArray
    }
    
    override func mainButtonString() -> String {
        return NSLocalizedString("Create Account", comment: "Create account button")
    }
}
