//
//  FSChatView.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/5/7.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSBaseView.h"

#define FSChatViewHeight    308

@class FSChatView;
typedef void(^FSChatChangeHeightBlock)(FSChatView *bChatView,CGFloat delta);
typedef void(^FSChatSendBlock)(NSString *bText);
typedef void(^FSChatSelectImageBlock)(FSChatView *bChatView,UIImage *bImage);

@interface FSChatView : FSBaseView

@property (nonatomic,copy) FSChatChangeHeightBlock      changeHeightBlock;
@property (nonatomic,copy) FSChatSendBlock              sendBlock;
@property (nonatomic,copy) FSChatSelectImageBlock       selectImageBlock;
@property (nonatomic,strong) UIView                     *otherView;

@end
