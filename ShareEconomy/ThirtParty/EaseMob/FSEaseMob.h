//
//  FSEaseMob.h
//  ShareEconomy
//
//  Created by fudon on 16/4/27.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EMSDK.h"
#import "EMError.h"

#define EaseMob_appKey      @"fulion#fusumeixin"

@interface FSEaseMob : NSObject

+(FSEaseMob *)shareInstance;

// 初始化
- (void)initEaseMob:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions;

- (void)applicationDidEnterBackgroundEaseMob:(UIApplication *)application;
- (void)applicationWillEnterForegroundEaseMob:(UIApplication *)application;

// 注册接口
- (void)registerWithAccount:(NSString *)account pwd:(NSString *)pwd success:(void(^)(void))success fail:(void(^)(EMError *bError))fail;

// 登录接口
- (void)loginWithAccount:(NSString *)account pwd:(NSString *)pwd isAutoLogin:(BOOL)isAutoLogin success:(void(^)(void))success fail:(void(^)(EMError *bError))fail;

// 登出
- (void)logout;
@end
