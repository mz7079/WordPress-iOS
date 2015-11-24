import UIKit

class CreateNewSiteViewController: WPNUXAbstractCreationViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        icon.hidden = true
        titleLabel.attributedText = NSAttributedString(string: NSLocalizedString("Create a new WordPress.com site", comment: "Create a new WordPress.com site title"), attributes: WPNUXUtility.titleAttributesWithColor(UIColor.whiteColor()) as! [String: AnyObject])
    }
}
