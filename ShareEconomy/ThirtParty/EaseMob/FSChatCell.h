//
//  FSChatCell.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/5/7.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMSDK.h"
#import "FSWebImageView.h"

@interface FSChatCell : UITableViewCell

@property (nonatomic,strong) UIImageView        *headImageView;
@property (nonatomic,strong) FSWebImageView     *pictureImageView;
@property (nonatomic,strong) UILabel            *timeLabel;
@property (nonatomic,strong) UILabel            *contentLabel;

- (void)configMessage:(EMMessage *)message from:(NSString *)from;

@end
