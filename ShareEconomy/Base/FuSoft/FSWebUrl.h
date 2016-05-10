//
//  FSWebUrl.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/24.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#ifndef FSWebUrl_h
#define FSWebUrl_h

//#define HostUrlString               @"https://106.2.175.178:5228/"
#define HostUrlString               @"http://192.168.81.102:8080/fudon/"

#define FSWebUrl_FindMsgCode        @"msgCode/findMSGCodeIsUsed"        // 获取所有未验证的注册验证码
#define FSWebUrl_UpdateMsg          @"msgCode/updateMSGCode"            // 更新短信验证码

#define FSWebUrl_Login              @"user/login"                       // 登陆
#define FSWebUrl_MsgCode            @"msgCode/registerCode"             // 获取注册验证码

#define FSWebUrl_CheckCode          @"user/checkcode"
#define FSWebUrl_Register           @"user/reg"
#define FSWebUrl_RegisterInfo       @"user/info"

#endif /* FSWebUrl_h */
