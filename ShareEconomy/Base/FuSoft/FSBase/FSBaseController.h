//
//  FSBaseController.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

/*
 afjeofoefoejfo
 */

#import <UIKit/UIKit.h>
#import "FSMacro.h"
#import "FSNavigationController.h"

@interface FSBaseController : UIViewController

@property (nonatomic,assign) BOOL   letStatusBarWhite;

- (void)showWaitView:(BOOL)show;
- (void)showTitle:(NSString *)title;
- (void)popActionBase;

@end
