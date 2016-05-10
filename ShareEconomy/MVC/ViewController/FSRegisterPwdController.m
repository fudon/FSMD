//
//  FSRegisterPwdController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/24.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSRegisterPwdController.h"

@interface FSRegisterPwdController ()

@end

@implementation FSRegisterPwdController
{
    NSInteger       _waitCodeTimes;
    NSTimer         *_timer;
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置密码";
    _waitCodeTimes = 60;
    
    [self registerHandleDatas];
}

- (void)registerHandleDatas
{
    WEAKSELF(this);
    [self showWaitView:YES];
    [FuWeb requestWithUrl:FSWebUrl_MsgCode params:@{@"account":_phone} successBlock:^(id dic) {
        [this showWaitView:NO];
        [this registerDesignViews];
    } failBlock:^(NSString *msg) {
        [this showWaitView:NO];
        [this showTitle:msg];
    }];
}

- (void)registerDesignViews
{
    UILabel *showLabel = [FSViewManager labelWithFrame:CGRectMake(10, 64, WIDTHFC - 20, 42) text:@"您的手机号18810790738将会收到一条短信验证码,如果超时未收到，请点重新发送" textColor:FS_TextColor_Light backColor:nil textAlignment:NSTextAlignmentLeft];
    showLabel.numberOfLines = 2;
    showLabel.font = FONTFC(13);
    [self.view addSubview:showLabel];
    
    NSArray *array = @[@"验证码",@"设置密码"];
    CGFloat yPoint = 108;
    for (int x = 0; x < 2; x ++) {
        UILabel *label = [FSViewManager labelWithFrame:CGRectMake(0, yPoint + x * 40.7, 79, 40) text:array[x] textColor:FS_TextColor_Normal backColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        [self.view addSubview:label];
        
        UITextField *textField = [FSViewManager textFieldWithFrame:CGRectMake(label.right, label.top, WIDTHFC - label.width - 70 + x * 70, label.height) placeholder:[[NSString alloc] initWithFormat:@"请输入%@",array[x]] textColor:FS_TextColor_Normal onlyChars:YES];
        textField.backgroundColor = [UIColor whiteColor];
        textField.tag = TAGTEXTFIELD + x;
        if (x == 0) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        }
        [self.view addSubview:textField];
        if (x == 0) {
            UIButton *reSendButton = [FSViewManager buttonWithFrame:CGRectMake(textField.right, textField.top, 70, textField.height) title:@"重新发送" titleColor:[UIColor lightGrayColor] backColor:[UIColor whiteColor] fontInt:0 target:self selector:@selector(buttonClickInRegisterPwd:)];
            reSendButton.tag = TAGBUTTON + 1;
            reSendButton.enabled = NO;
            [self.view addSubview:reSendButton];
        }
    }
    
    UIButton *registerBtn = [FSViewManager buttonWithFrame:CGRectMake(20, yPoint + 100, WIDTHFC - 40, 40) title:@"注册" titleColor:nil backColor:FS_RedColor fontInt:0 target:self selector:@selector(buttonClickInRegisterPwd:)];
    registerBtn.layer.cornerRadius = 3;
    [self.view addSubview:registerBtn];
    
    [self handleRequestCheckCode];
}

- (void)buttonClickInRegisterPwd:(UIButton *)button
{
    if (button.tag) {
        if (button.enabled) {
            button.enabled = NO;
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self handleRequestCheckCode];
        }
    }else{
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
        
        UITextField *pwd = [self.view viewWithTag:TAGTEXTFIELD + 1];
        NSLog(@"%@",pwd.text);
        
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)textFieldAction:(UITextField *)textField
{
    if (textField.text.length > 6) {
        textField.text = [textField.text substringToIndex:6];
    }
}

- (void)handleRequestCheckCode
{
    UIButton *resendButton = [self.view viewWithTag:TAGBUTTON + 1];
    [resendButton setTitle:@(_waitCodeTimes --).stringValue forState:UIControlStateNormal];
    if (_waitCodeTimes <= 0) {
        _waitCodeTimes = 60;
        resendButton.enabled = YES;
        [resendButton setTitleColor:FSAPPCOLOR forState:UIControlStateNormal];
        [resendButton setTitle:@"重新发送" forState:UIControlStateNormal];
        [_timer invalidate];
        _timer = nil;
    }else{
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleRequestCheckCode) userInfo:nil repeats:YES];
        }
    }
}

- (void)popActionBase
{
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    [super popActionBase];
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
