//
//  FSStatistics.m
//  GoodBoy
//
//  Created by fudon on 16/8/11.
//  Copyright © 2016年 guazi. All rights reserved.
//

#import "FSStatistics.h"
#import <UMMobClick/MobClick.h>

NSMutableDictionary *pageRelations;

@implementation FSStatistics

+ (void)startStatisticFunction
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey];

    UMAnalyticsConfig *umConfig = [[UMAnalyticsConfig alloc] init];
    umConfig.appKey = @"57ac27fce0f55adef200048f";
    umConfig.channelId = @"AppStore";
    umConfig.ePolicy = BATCH;
    
    [MobClick setCrashReportEnabled:NO];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:umConfig];
    [MobClick  setLogEnabled:NO];
    
    [self addActionLog:um_start];
    
    // 统计页面时长
    pageRelations = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                     @"成交管理",@"GZSDealManageController",
                     nil];
}

+ (void)addActionLog:(NSString *)acLog
{
    [MobClick event:acLog];
}

+ (void)addActionLog:(NSString *)acLog attributes:(NSDictionary *)attributes
{
    [MobClick event:acLog attributes:attributes];
}

+ (void)startPage:(NSString *)pageName
{
    NSString *page = [pageRelations objectForKey:pageName];
    if (page) {
        [MobClick beginLogPageView:page];
    }
    
}

+ (void)endPage:(NSString *)pageName
{
    NSString *page = [pageRelations objectForKey:pageName];
    if (page) {
        [MobClick endLogPageView:page];
    }
}

@end
