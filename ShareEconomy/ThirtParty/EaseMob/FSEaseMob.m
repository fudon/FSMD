//
//  FSEaseMob.m
//  ShareEconomy
//
//  Created by fudon on 16/4/27.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSEaseMob.h"

@interface FSEaseMob ()<EMClientDelegate>

@end

@implementation FSEaseMob

static FSEaseMob *instance = nil;

+(FSEaseMob *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FSEaseMob alloc] init];
    });
    return instance;
}

// 初始化
- (void)initEaseMob:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        EMOptions *options = [EMOptions optionsWithAppkey:EaseMob_appKey];
        options.apnsCertName = @"istore_dev";
        EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
        if (error) {
            NSLog(@"%s",__FUNCTION__);
        }
    });
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [[EaseSDKHelper shareHelper] easemobApplication:application
//                          didFinishLaunchingWithOptions:launchOptions
//                                                 appkey:EaseMob_appKey
//                                           apnsCertName:@"istore_dev"
//                                            otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
//    });
}

- (void)applicationDidEnterBackgroundEaseMob:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForegroundEaseMob:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)registerWithAccount:(NSString *)account pwd:(NSString *)pwd success:(void(^)(void))success fail:(void(^)(EMError *bError))fail
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        EMError *error = [[EMClient sharedClient] registerWithUsername:account password:pwd];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                if (success) {
                    success();
                }
            }else{
                if (fail) {
                    fail(error);
                }
            }
        });
    });
}

- (void)loginWithAccount:(NSString *)account pwd:(NSString *)pwd isAutoLogin:(BOOL)isAutoLogin success:(void (^)(void))success fail:(void (^)(EMError *))fail
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
        if (isAutoLogin) {
            if (success) {
                success();
            }
        }
        EMError *error = [[EMClient sharedClient] loginWithUsername:account password:pwd];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [[EMClient sharedClient].options setIsAutoLogin:isAutoLogin];
                if (success) {
                    success();
                }
            }else{
                if (fail) {
                    fail(error);
                }
            }
        });
    });
}

- (void)logout
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        EMError *error = [[EMClient sharedClient] logout:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSLog(@"退出成功");
            }
        });
    });
}

@end
