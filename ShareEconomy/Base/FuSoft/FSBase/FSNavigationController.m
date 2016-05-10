//
//  FSNavigationController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSNavigationController.h"
#import "FSMacro.h"

@interface FSNavigationController ()<UINavigationControllerDelegate>

@end

@implementation FSNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    if (IOS7FC) {
        [self.navigationBar setTranslucent:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    } else {
        self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.navigationBar.tintColor = [UIColor colorWithRed:0 green:130/255.0 blue:200/255.0 alpha:1];
    }
    self.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = (navigationController.viewControllers.count > 1);
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
