//
//  FSRegisterController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/23.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSRegisterController.h"
#import "FSRegisterPwdController.h"

@interface FSRegisterController ()

@property (nonatomic,strong) UITextField    *textField;

@end

@implementation FSRegisterController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
    UILabel *label = [FSViewManager labelWithFrame:CGRectMake(0, 90, 70, 40) text:@"手机号" textColor:FS_TextColor_Normal backColor:[UIColor whiteColor] font:nil textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
    
    _textField = [FSViewManager textFieldWithFrame:CGRectMake(label.right, label.top, WIDTHFC - label.width, label.height) placeholder:@"请输入手机号" textColor:FS_TextColor_Normal backColor:nil];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_textField];
    
    UIButton *registerBtn = [FSViewManager buttonWithFrame:CGRectMake(20, _textField.bottom + 20, WIDTHFC - 40, 40) title:@"下一步" titleColor:nil backColor:FS_RedColor fontInt:0 tag:0 target:self selector:@selector(buttonClickInRegister:)];
    registerBtn.layer.cornerRadius = 3;
    [self.view addSubview:registerBtn];
}

- (void)textFieldChanged:(UITextField *)textField
{
    NSString *cleanString = [FuData cleanString:textField.text];
    textField.text = cleanString;
    if (cleanString.length > 11) {
        textField.text = [cleanString substringToIndex:11];
    }
}

- (void)buttonClickInRegister:(UIButton *)button
{
    if (![FuData checkTextFieldHasValidInput:_textField]) {
        [FuData showMessage:@"请输入手机号"];
        return;
    }
    FSRegisterPwdController *pwd = [[FSRegisterPwdController alloc] init];
    pwd.phone = _textField.text;
    [self.navigationController pushViewController:pwd animated:YES];
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
