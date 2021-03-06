

#import "UIAlertView+WeChatLiveTools.h"
#import <objc/runtime.h>

@interface UIAlertView () <UIAlertViewDelegate>
@property (nonatomic, copy) void(^complete)(NSInteger buttonIndex, UIAlertView *alertView);
@end

@implementation UIAlertView (WeChatLiveTools)

static char showJplaceholderAlertViewKey;

#pragma mark - Methods
- (void)showJplaceholderAlertView:(void(^)(NSInteger buttonIndex, UIAlertView *alertView))complete
{
    self.delegate = self;
    self.complete = complete;
    [self show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    self.complete ? self.complete(buttonIndex, alertView) : nil;
}

#pragma mark - SetMethods
- (void)setComplete:(void (^)(NSInteger buttonIndex, UIAlertView *alertView))complete
{
    objc_setAssociatedObject(self, &showJplaceholderAlertViewKey, complete, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - GetMethods
- (void(^)(NSInteger buttonIndex, UIAlertView *alertView))complete
{
    return objc_getAssociatedObject(self, &showJplaceholderAlertViewKey);
}

@end