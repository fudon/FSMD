//
//  FuWeb.h
//  Daiyida
//
//  Created by fudon on 14-10-17.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSWebUrl.h"

typedef void(^SuccessBlock)(id dic);
typedef void(^FailBlock)(NSString *msg);

typedef enum{
    FCReturnTypeDictionary = 0,
    FCReturnTypeArray
}FCReturnType;

typedef enum{
    FCRequestTypeAsync = 0,
    FCRequestTypeSync
}FCRequestType;

@interface FuWeb : NSObject

@property (nonatomic, strong) id            syncObject;
@property (nonatomic, assign) FCRequestType requestType;
@property (nonatomic,assign) FCReturnType returnType;
@property (nonatomic, copy) SuccessBlock successBlock;
@property (nonatomic, copy) FailBlock    failBlock;

+ (void)requestWithUrl:(NSString *)url params:(NSDictionary *)bDic successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock;
+ (void)requestWithUrl:(NSString *)url params:(NSDictionary *)bDic fileName:(NSString *)fileName imageData:(NSData *)imageData successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock;
+ (void)pictureUrl:(NSString *)urlString successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock;

@end
