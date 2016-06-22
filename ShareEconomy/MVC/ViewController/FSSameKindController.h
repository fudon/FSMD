//
//  FSSameKindController.h
//  ShareEconomy
//
//  Created by fudon on 16/6/22.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSBaseController.h"

#define Picture_Name    @"Picture_Name"
#define Text_Name       @"Text_Name"
#define Url_String      @"Url_String"

@interface FSSameKindController : FSBaseController

@property (nonatomic,strong) NSArray        *datas; // 存储字典，@{@"":@"",@"":@"",@"":@""};

@end
