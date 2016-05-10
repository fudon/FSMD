//
//  FuSing.m
//  DataClass
//
//  Created by HYYT on 14-5-15.
//  Copyright (c) 2014年 hyw_fdd. All rights reserved.
//

#import "FuSing.h"

#define SYSTEMCONFIGFC  @"ksystCnfg"
#define KPHONENO        @"KPHONENO"
#define KPRICEDIC       @"KPRICEDIC"
#define KTIMELIMT       @"KTIMELIMIT"
#define KACCOUNTID      @"KACCOUNTID"
#define KNAMEDYD        @"KNAMEDYD"
#define KCAPITALID      @"KCAPITALD"
#define KUUIDSTR        @"KUUIDSTR"

@implementation FuSing

static FuSing *instance = nil;

+(FuSing *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FuSing alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSMutableDictionary *tempDic = [[NSUserDefaults standardUserDefaults] objectForKey:SYSTEMCONFIGFC];
        if (tempDic) {
            _accPhone = [tempDic objectForKey:KPHONENO];
            _priceDic = [tempDic objectForKey:KPRICEDIC];
            _timeLimit = [tempDic objectForKey:KTIMELIMT];
            _accountID = [tempDic objectForKey:KACCOUNTID];
            _capitalId = [tempDic objectForKey:KCAPITALID];
            _name  = [tempDic objectForKey:KNAMEDYD];
            _uuidStr = [tempDic objectForKey:KUUIDSTR];
        }else{
            _accPhone = @"";
            _priceDic = [[NSDictionary alloc] init];
            _timeLimit = [[NSNumber alloc] initWithInteger:1];
            _name = @"";
            _capitalId = @"";
            _uuidStr = @"";
        }
    }
    return self;
}

-(void)saveConfig
{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    [tempDic setObject:_accPhone forKey:KPHONENO];
    [tempDic setObject:_timeLimit forKey:KTIMELIMT];
    [tempDic setObject:_accountID forKey:KACCOUNTID];
    [tempDic setObject:_name forKey:KNAMEDYD];
    [tempDic setObject:_capitalId forKey:KCAPITALID];
    [tempDic setObject:_uuidStr forKey:KUUIDSTR];
    
    [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:SYSTEMCONFIGFC];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
