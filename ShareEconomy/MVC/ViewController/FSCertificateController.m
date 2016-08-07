//
//  FSCertificateController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/8/5.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSCertificateController.h"

@interface FSCertificateController ()

@end

@implementation FSCertificateController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self certificateDesignViews];
}

- (void)certificateDesignViews
{
    self.title = @"认证";
    [self addKeyboardNotificationWithBaseOn:290];
    
    NSArray *array = @[@"姓名",@"身份证",@"芝麻信用分",@"京东小白信用"];
    for (int x = 0; x < array.count; x ++) {
        UILabel *label = [FSViewManager labelWithFrame:CGRectMake(10, 20 + 40 * x, 100, 40) text:array[x] textColor:FS_TextColor_Normal backColor:nil font:FS_Font_Normal textAlignment:NSTextAlignmentRight];
        [self.scrollView addSubview:label];
        
        UITextField *textField = [FSViewManager textFieldWithFrame:CGRectMake(label.right + 15, label.top, WIDTHFC - 145, label.height - FS_LineThickness) placeholder:[[NSString alloc] initWithFormat:@"请输入%@",array[x]] textColor:FS_TextColor_Normal backColor:nil];
        [textField addSubview:[FSViewManager seprateViewWithFrame:CGRectMake(0, textField.height - FS_LineThickness, textField.width, FS_LineThickness)]];
        [self.scrollView addSubview:textField];
    }
    
    UIButton *button = [FSViewManager submitButtonWithTop:220 block:^(FSBlockButton *bButton) {
    }];
    [self.scrollView addSubview:button];
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
