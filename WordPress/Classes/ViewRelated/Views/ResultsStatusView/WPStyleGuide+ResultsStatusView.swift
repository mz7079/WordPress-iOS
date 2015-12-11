import Foundation
import WordPressShared

extension WPStyleGuide
{
    public struct ResultsStatusView
    {
        // MARK: Metrics

        public static let width = CGFloat(250)

        public static let titleLeading = CGFloat(10)
        public static let messageLeading = CGFloat(8)
        public static let buttonLeading = CGFloat(17)

        public static let buttonEdge = CGFloat(20)

        // MARK: Colors

        public static let titleColor = WPStyleGuide.whisperGrey()

        public static let messageColor = WPStyleGuide.grey()

        public static let buttonColor = WPStyleGuide.grey()

        // MARK: Typography
        
        public static let titleAttributes = WPNUXUtility.titleAttributesWithColor(titleColor)

        public static let messageFont = WPFontManager.openSansRegularFontOfSize(14)
        
        public static let buttonFont = WPStyleGuide.regularTextFont()

        // MARK: Conveniences
        
        public static func spacingView(height: CGFloat) -> UIView {
            let view = UIView()
            view.hidden = true
            let constraint = view.heightAnchor.constraintEqualToConstant(height)
            constraint.priority = UILayoutPriorityDefaultLow
            NSLayoutConstraint.activateConstraints([constraint])
            return view
        }

        public static func attributedTitle(title: String) -> NSAttributedString {
            return NSAttributedString(string: title, attributes: titleAttributes as? [String : AnyObject])
        }

        public static func applyMessageStyle(label: UILabel) {
            label.font = messageFont
            label.textColor = messageColor
            label.textAlignment = .Center
        }

        public static func applyButtonStyle(button: UIButton) {
            button.titleLabel?.font = buttonFont
            button.setTitleColor(buttonColor, forState: .Normal)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: buttonEdge, bottom: 0, right: buttonEdge)
            button.setBackgroundImage(buttonBackgroundImage(), forState: .Normal)
        }

        private static func buttonBackgroundImage() -> UIImage {
            let fillRect = CGRect(x: 0, y: 0, width: 11, height: 36)
            let capInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            
            UIGraphicsBeginImageContextWithOptions(fillRect.size, false, UIScreen.mainScreen().scale)
            let context = UIGraphicsGetCurrentContext()
        
            CGContextSetStrokeColorWithColor(context, buttonColor.CGColor)
            CGContextAddPath(context, UIBezierPath(roundedRect: CGRectInset(fillRect, 1, 1), cornerRadius: 2).CGPath)
            CGContextStrokePath(context)
        
            let mainImage = UIGraphicsGetImageFromCurrentImageContext()
        
            UIGraphicsEndImageContext()
        
            return mainImage.resizableImageWithCapInsets(capInsets)
        }

    }
    
}
