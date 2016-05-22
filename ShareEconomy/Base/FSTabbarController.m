//
//  FSTabbarController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSTabbarController.h"
#import "FSHomeController.h"
#import "FSMoneyController.h"
#import "FSZoneController.h"
#import "FSNavigationController.h"
#import "FSCommuniteController.h"
#import "FSChatListController.h"

@interface FSTabbarController ()

@end

@implementation FSTabbarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    FSHomeController *home = [[FSHomeController alloc] init];
    FSChatListController *communicate = [[FSChatListController alloc] init];
    FSMoneyController *money = [[FSMoneyController alloc] init];
    FSZoneController *zone = [[FSZoneController alloc] init];
    NSArray *vcs = @[home,communicate,money,zone];
    NSMutableArray *vcNavs = [[NSMutableArray alloc] init];
    for (int x = 0; x < vcs.count; x ++) {
        UIViewController *vc = vcs[x];
        FSNavigationController *nav = [[FSNavigationController alloc] initWithRootViewController:vc];
        [vcNavs addObject:nav];
    }
    self.viewControllers = vcNavs;    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
