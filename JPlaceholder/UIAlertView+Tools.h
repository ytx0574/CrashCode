//
//  UIAlertView+Tools.h
//  Het
//
//  Created by Johnson on 15/3/25.
//  Copyright (c) 2015年 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Tools)

- (void)showJplaceholderAlertView:(void(^)(NSInteger buttonIndex, UIAlertView *alertView))complete;

@end