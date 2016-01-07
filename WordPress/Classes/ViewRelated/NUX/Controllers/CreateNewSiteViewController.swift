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
    
    override func mainButtonTapped(sender: AnyObject) {
        createUserAndSite()
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
        return NSLocalizedString("Create Site", comment: "Create site button")
    }
    
    func toggleAuthenticating(authenticating: Bool) {
        isAuthenticating = authenticating
        mainButton.enabled = !authenticating
        mainButton.showActivityIndicator(authenticating)
    }
    
    func siteAddressWithoutWordPressDotCom() -> String {
        let siteAddressTextField = textFieldsArray[siteAddressIndex]
        let dotComRegularExpression = NSRegularExpression(pattern: "\\.wordpress\\.com/?$", options: .CaseInsensitive)
        
        return dotComRegularExpression.stringByReplacingMatchesInString(siteAddressTextField.text, options: .RawValue, range: siteAddressTextField.text.length, withTemplate: "")
    }
    
    func displayRemoteError(error: NSError) {
        let errorMessage = error.userInfo[WordPressComApiErrorMessageKey] as! String
        showError(errorMessage)
    }
    
    func showError(message: String) {
        let overlayView = WPWalkthroughOverlayView(frame: view.bounds)
        overlayView.overlayTitle = NSLocalizedString("Error", comment: "Error")
        overlayView.overlayDescription = message
        overlayView.dismissCompletionBlock = {(overlayView: WPWalkthroughOverlayView!) -> Void in
            overlayView.dismiss()
        }
        
        view.addSubview(overlayView)
    }
    
    func createUserAndSite() {
        guard !isAuthenticating else {
            return
        }
        
        toggleAuthenticating(true)
        
        let blogCreation = WPAsyncBlockOperation.operationWithBlock({(operation: WPAsyncBlockOperation!) -> Void in
            let createBlogSuccess = {(responseDictionary: NSDictionary!) -> Void in
                operation.didSucceed()
                
                let blogOptions: NSMutableDictionary = (responseDictionary["blog_details"]?.mutableCopy())! as! NSMutableDictionary
                
                let context = ContextManager.sharedInstance().mainContext
                let accountService = AccountService(managedObjectContext: context)
                let blogService = BlogService(managedObjectContext: context)
                let defaultAccount = accountService.defaultWordPressComAccount()
                
                var blog = blogService.findBlogWithXmlrpc(nil, inAccount: defaultAccount)
                if blog == nil {
                    blog = blogService.createBlogWithAccount(defaultAccount)
                    blog.xmlrpc = blogOptions["xmlrpc"] as! String
                }
                blog.blogID = blogOptions["blogid"] as! NSNumber
                blog.url = blogOptions["url"] as! String
                blog.settings.name = blogOptions["blogname"]!.stringByDecodingXMLCharacters()
            }
            
            let createBlogFailure: WordPressComServiceFailureBlock = {(error: NSError!) -> Void in
                self.toggleAuthenticating(false)
                operation.didFail()
                self.displayRemoteError(error)
            }
            
            NSLog("\(createBlogSuccess)")
            NSLog("\(createBlogFailure)")
        }) as! WPAsyncBlockOperation
        
        let operationQueue = NSOperationQueue()
        operationQueue.addOperation(blogCreation)
    }
}
