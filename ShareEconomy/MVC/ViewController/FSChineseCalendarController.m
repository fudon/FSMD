//
//  FSChineseCalendarController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/8/7.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSChineseCalendarController.h"
#import "ChineseCalendarView.h"

@interface FSChineseCalendarController ()

@end

@implementation FSChineseCalendarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"国历";
//    self.backTitle = [FuData appName];
    
    ChineseCalendarView *ccView = [[ChineseCalendarView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 64)];
    ccView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:ccView];
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
