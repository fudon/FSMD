//
//  FuSing.h
//  DataClass
//
//  Created by HYYT on 14-5-15.
//  Copyright (c) 2014年 hyw_fdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FuSing : NSObject

@property (nonatomic, strong) NSString      *accPhone;
@property (nonatomic, strong) NSDictionary  *priceDic;
@property (nonatomic, strong) NSNumber      *timeLimit;

@property (nonatomic, copy)   NSString      *accountID;
@property (nonatomic, copy)   NSString      *capitalId;
@property (nonatomic, copy)   NSString      *name;
@property (nonatomic, copy)   NSString      *uuidStr;

+(FuSing *)shareInstance;
-(void)saveConfig;

@end
