//
//  FSSendCell.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/5/14.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSEMMessage.h"

#define FSSEND_PROGRESS     @"FSSEND_PROGRESS"

@interface FSSendCell : UITableViewCell

@property (nonatomic,strong) UIImageView        *sendImageView;
@property (nonatomic,strong) UILabel            *progressLabel;

@property (nonatomic,strong) FSEMMessage        *message;

@end
