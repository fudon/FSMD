//
//  FSChangeController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/7/21.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSChangeController.h"

@interface FSChangeController ()

@property (nonatomic,strong) UITextField    *textField;

@end

@implementation FSChangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textField = [FSViewManager textFieldWithFrame:CGRectMake(0, 20, WIDTHFC, 40) placeholder:@"请输入" textColor:nil onlyChars:YES];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:_textField];
    
    UIButton *submitButton = [FSViewManager buttonWithFrame:CGRectMake(20, _textField.bottom + 20, WIDTHFC - 40, 40) title:@"修改" titleColor:nil backColor:FSAPPCOLOR fontInt:0 tag:0 target:self selector:@selector(submitButton)];
    [self.scrollView addSubview:submitButton];
}

- (void)submitButton
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
