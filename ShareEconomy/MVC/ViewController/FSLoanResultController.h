//
//  FSLoanResultController.h
//  ShareEconomy
//
//  Created by fudon on 16/6/1.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSBaseController.h"

@interface FSLoanResultController : FSBaseController

// 月均还款、支付利息、还款总额   【期数、每期利息、每期本金、档期月供、】
@property (nonatomic,assign) double     bxMonthPay;
@property (nonatomic,strong) NSArray    *bxInterests;

@end
