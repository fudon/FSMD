//
//  FSCentShellController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/8/4.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSCentShellController.h"

@interface FSCentShellController ()

@end

@implementation FSCentShellController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self centShellDesignViews];
}

- (void)centShellDesignViews
{
    self.title = @"分贝";
    // 有介绍分贝的用途
    
    UITextField *textField = [FSViewManager textFieldWithFrame:CGRectMake(0, 20, WIDTHFC, 44) placeholder:@"请输入整数" textColor:FS_TextColor_Normal backColor:[UIColor whiteColor]];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollView addSubview:textField];
    
    UIButton *button = [FSViewManager submitButtonWithTop:textField.bottom + 20 block:^(FSBlockButton *bButton) {
        NSLog(@"dff");
    }];
    [self.scrollView addSubview:button];
    
    UILabel *label = [FSViewManager labelWithFrame:CGRectMake(20, button.bottom + 10, WIDTHFC - 40, 60) text:@"*分贝值是指非好友联系你时须要支付给你的虚拟积分，时效为一个月。" textColor:FS_TextColor_Light backColor:nil font:FS_Font_Small textAlignment:NSTextAlignmentLeft];
    label.numberOfLines = 0;
    [self.scrollView addSubview:label];
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
