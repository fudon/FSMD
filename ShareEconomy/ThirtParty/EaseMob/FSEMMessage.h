//
//  FSEMMessage.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/5/8.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "EMMessage.h"
#import <UIKit/UIKit.h>

@interface FSEMMessage : EMMessage

@property (nonatomic,strong) UIImage        *localImage;
@property (nonatomic,assign) NSInteger      index;
@property (nonatomic,assign) BOOL           isSending;

@end
