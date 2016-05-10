//
//  FSWebImageView.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/5/8.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

// 需提供清除图片缓存的方法
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FSWebImageViewAction) {
    GZSWebImageViewActionTap,
    GZSWebImageViewActionDelete,
};

@class FSWebImageView;
typedef void(^TapImageBlock)(FSWebImageView *bImageView,FSWebImageViewAction actionType);

@interface FSWebImageView : UIImageView

@property (nonatomic,assign) BOOL           showButton;
@property (nonatomic,copy) TapImageBlock    block;

- (void)setImageWithUrl:(NSString *)url placeholderImageName:(NSString *)name;

@end
