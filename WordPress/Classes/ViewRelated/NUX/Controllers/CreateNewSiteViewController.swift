import UIKit

class CreateNewSiteViewController: WPNUXAbstractCreationViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        icon.hidden = true
        let titleAttributes: [String : AnyObject] = WPNUXUtility.titleAttributesWithColor(UIColor.whiteColor()) as! [String : AnyObject]
        titleLabel.attributedText = NSAttributedString(string: NSLocalizedString("Create a new WordPress.com site", comment: "Create a new WordPress.com site title"), attributes: titleAttributes)
        addTextFields()
    }
    
    func addTextFields() {
        let emailField = WPWalkthroughTextField(leftViewImage: UIImage(named: "icon-email-field"))
        emailField.backgroundColor = UIColor.whiteColor()
        textFields.addArrangedSubview(emailField)

    }
}
