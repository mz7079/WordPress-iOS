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
        siteTitleField.heightAnchor.constraintEqualToConstant(44.0).active = true
        siteTitleField.widthAnchor.constraintEqualToConstant(320.0).active = true
        
        let siteAddressField = WPWalkthroughTextField(leftViewImage: UIImage(named: "icon-url-field"))
        siteAddressField.backgroundColor = UIColor.whiteColor()
        siteAddressField.placeholder = NSLocalizedString("Site Address", comment: "Site Address")
        siteAddressField.font = WPNUXUtility.textFieldFont()
        siteAddressField.adjustsFontSizeToFitWidth = true
        siteAddressField.delegate = self
        siteAddressField.autocorrectionType = .No
        siteAddressField.autocapitalizationType = .None
        siteAddressField.accessibilityLabel = NSLocalizedString("Title", comment: "Title field")
        siteAddressField.returnKeyType = .Done
        siteAddressField.showTopLineSeparator = true
        siteAddressField.heightAnchor.constraintEqualToConstant(44.0).active = true
        siteAddressField.widthAnchor.constraintEqualToConstant(320.0).active = true
        
//        let siteAddressWPComLabel = UILabel()
//        siteAddressWPComLabel.text = ".wordpress.com"
//        siteAddressWPComLabel.textAlignment = .Center
//        siteAddressWPComLabel.font = WPNUXUtility.descriptionTextFont()
//        siteAddressWPComLabel.textColor = WPStyleGuide.allTAllShadeGrey()
//        siteAddressWPComLabel.sizeToFit()
//        
//        var siteAddressTextInsets = siteAddressField.textInsets
//        siteAddressTextInsets.right += siteAddressWPComLabel.frame.size.width + sizePadding
//        siteAddressField.textInsets = siteAddressTextInsets
//        siteAddressWPComLabel.heightAnchor.constraintEqualToConstant(siteAddressField.frame.height - 10).active = true
//        siteAddressWPComLabel.widthAnchor.constraintEqualToConstant(siteAddressWPComLabel.frame.width + 10).active = true
//        siteAddressWPComLabel.rightAnchor.constraintEqualToAnchor(siteAddressField.heightAnchor).active = true
//        siteAddressField.addSubview(siteAddressWPComLabel)

        textFieldsArray.append(siteTitleField)
        textFieldsArray.append(siteAddressField)
        
        return textFieldsArray
    }
    
    override func mainButtonString() -> String {
        return NSLocalizedString("Create Account", comment: "Create account button")
    }
}
