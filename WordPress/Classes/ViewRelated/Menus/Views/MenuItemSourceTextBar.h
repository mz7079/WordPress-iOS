#import <UIKit/UIKit.h>

@protocol MenuItemSourceTextBarDelegate;

@interface MenuItemSourceTextBar : UIView

@property (nonatomic, weak) id <MenuItemSourceTextBarDelegate> delegate;
@property (nonatomic, strong, readonly) UIImageView *iconView;

- (id)initAsSearchBar;

@end

@protocol MenuItemSourceTextBarDelegate <NSObject>

- (void)sourceTextBarDidBeginEditing:(MenuItemSourceTextBar *)textBar;
- (void)sourceTextBar:(MenuItemSourceTextBar *)textBar didUpdateWithText:(NSString *)text;
- (void)sourceTextBarDidEndEditing:(MenuItemSourceTextBar *)textBar;

@end