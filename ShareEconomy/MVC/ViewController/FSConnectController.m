//
//  FSConnectController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/8/4.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSConnectController.h"

@interface FSConnectController ()

@end

@implementation FSConnectController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self connectDesignViews];
}

- (void)connectDesignViews
{
    self.title = @"联系方式";
    
    NSArray *array = @[@"手机号",@"邮箱",@"QQ",@"微信",@"支付宝"];
    for (int x = 0; x < array.count; x ++) {
        UILabel *label = [FSViewManager labelWithFrame:CGRectMake(10, 20 + 40 * x, 70, 40) text:array[x] textColor:FS_TextColor_Normal backColor:nil font:FS_Font_Normal textAlignment:NSTextAlignmentRight];
        [self.scrollView addSubview:label];
        
        UITextField *textField = [FSViewManager textFieldWithFrame:CGRectMake(label.right + 10, label.top, WIDTHFC - 80 - 20, label.height - FS_LineThickness) placeholder:[[NSString alloc] initWithFormat:@"请输入%@",array[x]] textColor:FS_TextColor_Normal backColor:nil];
        [self.scrollView addSubview:textField];
    }
    
    UIButton *button = [FSViewManager submitButtonWithTop:240 tag:0 target:self selector:@selector(buttonAction)];
    [self.scrollView addSubview:button];
}

- (void)buttonAction
{
    
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
