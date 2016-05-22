//
//  FSHomeCell.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/14.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMSDK.h"

@interface FSHomeCell : UITableViewCell

@property (nonatomic,strong) UIImageView    *headImageView;
@property (nonatomic,strong) UILabel        *nameLabel;
@property (nonatomic,strong) UILabel        *messageLabel;
@property (nonatomic,strong) UILabel        *timeLabel;
@property (nonatomic,strong) UILabel        *numberLabel;

@property (nonatomic,strong) EMConversation *conversation;

@end
