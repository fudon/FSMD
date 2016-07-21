//
//  FSZoneHeadView.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/7/20.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSBaseView.h"


@class FSZoneHeadView;
typedef void(^ZoneHeadBlock)(FSZoneHeadView *bView,NSInteger bIndex);

@interface FSZoneHeadView : FSBaseView

@property (nonatomic,copy) ZoneHeadBlock        block;

@end
