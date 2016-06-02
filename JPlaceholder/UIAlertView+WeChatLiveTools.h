

#import <UIKit/UIKit.h>

@interface UIAlertView (WeChatLiveTools)

- (void)showJplaceholderAlertView:(void(^)(NSInteger buttonIndex, UIAlertView *alertView))complete;

@end