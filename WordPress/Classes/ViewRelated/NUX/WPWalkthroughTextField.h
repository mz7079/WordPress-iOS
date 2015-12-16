#import <UIKit/UIKit.h>

@interface WPWalkthroughTextField : UITextField

@property (nonatomic) UIEdgeInsets textInsets;
@property (nonatomic) UIOffset rightViewPadding;
@property (nonatomic) BOOL showTopLineSeparator;
@property (nonatomic) BOOL showSecureTextEntryToggle;

- (instancetype)initWithLeftViewImage:(UIImage *)image;

- (instancetype)initWithLeftViewImage:(UIImage *)image
                       rightLabelText:(NSString *)rightLabelText
                          placeholder:(NSString *)placeholder
                        returnKeyType:(UIReturnKeyType)type
                             delegate:(id<UITextFieldDelegate>)delegate;

- (instancetype)initTextWithLeftViewImage:(UIImage *)image
                              placeholder:(NSString *)placeholder
                            returnKeyType:(UIReturnKeyType)type
                                 delegate:(id<UITextFieldDelegate>)delegate;

- (instancetype)initPasswordWithLeftViewImage:(UIImage *)image
                                  placeholder:(NSString *)placeholder
                                returnKeyType:(UIReturnKeyType)type
                                     delegate:(id<UITextFieldDelegate>)delegate;

@end
