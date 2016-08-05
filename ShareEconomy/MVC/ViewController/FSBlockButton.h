//
//  FSBlockButton.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/8/5.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSBlockButton;
typedef void(^FSButtonBlock)(FSBlockButton *bButton);

@interface FSBlockButton : UIButton

@property (nonatomic,copy) FSButtonBlock    block;

@end
