//
//  FIBaseEntity.h
//  GZSalesApp
//
//  Created by fudon on 16/1/18.
//  Copyright © 2016年 www.guazi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FIBaseEntity : NSObject<NSCoding>

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;

@end
