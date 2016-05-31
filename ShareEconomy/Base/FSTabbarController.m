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

    NSArray *titles = @[@"首页",@"联系",@"百宝箱",@"我"];
    NSArray *picArray = @[@"huodongp",@"shebaoUse",@"shopcari",@"ct24"];
         for(int i = 0; i < self.tabBar.items.count; i++) {
         UITabBarItem *item = [self.tabBar.items objectAtIndex:i];
         item.title = titles[i];
         item.image = IMAGENAMED(picArray[i]);
         
         NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName, nil];
         NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:RGBCOLOR(42, 121, 252, 1),NSForegroundColorAttributeName,nil];
         [item setTitleTextAttributes:dict forState:UIControlStateNormal];
         [item setTitleTextAttributes:dict2 forState:UIControlStateSelected];
     }
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
