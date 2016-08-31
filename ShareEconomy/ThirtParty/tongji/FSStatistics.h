//
//  FSStatistics.h
//  GoodBoy
//
//  Created by fudon on 16/8/11.
//  Copyright © 2016年 guazi. All rights reserved.
//

/*
 1.添加友盟SDK方法：
    * 直接把这个目录放到工程的目录下（工程内），工程配置中的Framework Path自动会有path链接。Framework不需要自己配path。
    * Link Binary with Libraries中添加Frmework和依赖库
 
    * NOTE：Git拉取工程后报错，无法找到UM，删除Framework，Clear工程再重新执行前面两步骤。
 
    对比：.a静态库文件需要配置 Library Search Path.
 */

#import <Foundation/Foundation.h>
#import "FSStatisticsKeys.h"

@interface FSStatistics : NSObject

+ (void)startStatisticFunction;

+ (void)addActionLog:(NSString *)acLog;

+ (void)addActionLog:(NSString *)acLog attributes:(NSDictionary *)attributes;

+ (void)startPage:(NSString *)pageName;

+ (void)endPage:(NSString *)pageName;

@end
