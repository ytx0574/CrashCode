//
//  JPlaceholderTextView.m
//  JPlaceholderTextView
//
//  Created by Johnson on 10/13/15.
//  Copyright (c) 2015 成都红帽法律. All rights reserved.
//

#import "JPlaceholderTextView.h"
#import "NSObject+WeChatLiveTools.h"

#define PKEY_WINDOW                      [[UIApplication sharedApplication] keyWindow]

#define PSCREEN_WIDTH                              [[UIScreen mainScreen] bounds].size.width
#define PSCREEN_HEIGHT                             [[UIScreen mainScreen] bounds].size.height

#define PiOS_SYSTEM_LATER(version)   (([[[UIDevice currentDevice] systemVersion] floatValue] >= version) ? YES : NO)
#define PiOS7_AND_LATER       (PiOS_SYSTEM_LATER(7) ? YES : NO)

#define PSTRING_WITH_SIZE_AND_DEFAULT_HEIGHT(string, font, width) (PiOS7_AND_LATER ? [string boundingRectWithSize:CGSizeMake(width, NSIntegerMax) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size : [string sizeWithFont:font constrainedToSize:CGSizeMake(width, NSIntegerMax)])

@interface JPlaceholderTextView ()
{
    CGRect _frame;
}
@property (nonatomic, strong) UILabel *labelPlaceholder;
@property (nonatomic, strong) void(^frameChangedComplete)(CGFloat height, CGFloat keyboardAnimationTime);
@end

@implementation JPlaceholderTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - Methods
- (void)setUp
{
    _frame = self.frame;
    [self insertSubview:self.labelPlaceholder atIndex:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextViewValueChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)overlapHeight:(void(^)(CGFloat height, CGFloat keyboardAnimationTime))frameChangedComplete;
{
    self.frameChangedComplete = frameChangedComplete;
}

#pragma mark - SetMethods
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.labelPlaceholder.text = self.text.length > 0 ? nil : self.placeholder;
    CGRect rect = self.labelPlaceholder.frame;
    
    rect.size = PSTRING_WITH_SIZE_AND_DEFAULT_HEIGHT(self.labelPlaceholder.text, self.labelPlaceholder.font, self.labelPlaceholder.bounds.size.width);
    
    self.labelPlaceholder.frame = rect;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.labelPlaceholder.font = font;
}

#pragma mark - GetMethods
- (UILabel *)labelPlaceholder
{
    if (!_labelPlaceholder) {
        UIView *view = self.subviews.firstObject;
        _labelPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.origin.x + 3, view.frame.origin.y + 8, self.bounds.size.width, self.bounds.size.height)];
        _labelPlaceholder.numberOfLines = 100;
        _labelPlaceholder.textColor = [UIColor lightGrayColor];
        _labelPlaceholder.text = _placeholder;
    }
    return _labelPlaceholder;
}

#pragma mark - Noti
- (void)TextViewValueChanged:(NSNotification *)noti
{
    self.labelPlaceholder.text = self.text.length > 0 ? nil : self.placeholder;
}

- (void)keyboardFrameChange:(NSNotification *)noti
{
    NSValue *value = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = value.CGRectValue;
    CGRect rect = [self.superview convertRect:_frame toView:PKEY_WINDOW];
    
    self.frameChangedComplete ? self.frameChangedComplete((PSCREEN_HEIGHT - keyboardFrame.size.height) - (rect.size.height + rect.origin.y), [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue]) : nil;
}

@end
