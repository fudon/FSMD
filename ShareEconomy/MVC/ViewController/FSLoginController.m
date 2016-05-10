//
//  FSLoginController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/18.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSLoginController.h"
#import "FSRegisterController.h"
#import "FuWeb.h"

@interface FSLoginController ()

@property (nonatomic,assign) BOOL   isNavigationBarHidden;

@end

@implementation FSLoginController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isNavigationBarHidden = self.navigationController.navigationBar.hidden;
    self.navigationController.navigationBar.hidden = YES;
    self.letStatusBarWhite = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = self.isNavigationBarHidden;
    self.letStatusBarWhite = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView = [FSViewManager imageViewWithFrame:CGRectMake(WIDTHFC / 2 - 35, 60, 70, 70) imageName:@"testdd.jpg"];
    [self.view addSubview:imageView];
    
    UIButton *findPwdButton = [FSViewManager buttonWithFrame:CGRectMake(WIDTHFC  - 100, self.view.center.y + 10, 80, 30) title:@"找回密码?" titleColor:[UIColor lightGrayColor] backColor:nil fontInt:13  target:self selector:@selector(buttonClickLogin:)];
    findPwdButton.tag = TAGBUTTON + 2;
    [self.view addSubview:findPwdButton];
    
    NSArray *tfTitles = @[@"用户名/手机号",@"密码"];
    NSArray *buttonTitles = @[@"登录",@"注册"];
    NSArray *buttonColors = @[FS_GreenColor,FSAPPCOLOR];
    for (int x = 0; x < 2; x ++) {
        UITextField *textField = [FSViewManager textFieldWithFrame:CGRectMake(0, self.view.center.y - 80 + x * 40, WIDTHFC, 40) placeholder:tfTitles[x] textColor:nil onlyChars:YES];
        if (x) {
            textField.secureTextEntry = YES;
        }
        textField.tag = TAGTEXTFIELD + x;
        textField.backgroundColor = [UIColor whiteColor];
        textField.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:textField];
        if (x == 0) {
            [self.view addSubview:[FSViewManager seprateViewWithFrame:CGRectMake(0, textField.bottom - FS_LineThickness, WIDTHFC, FS_LineThickness)]];
        }
        
        UIButton *button = [FSViewManager buttonWithFrame:CGRectMake(WIDTHFC / 2 * x, HEIGHTFC - 50, WIDTHFC / 2, 50) title:buttonTitles[x] titleColor:[UIColor whiteColor] backColor:buttonColors[x] fontInt:0 target:self selector:@selector(buttonClickLogin:)];
        button.tag = TAGBUTTON + x;
        [self.view addSubview:button];
    }
}

- (void)buttonClickLogin:(UIButton *)button
{
    NSInteger tag = button.tag - TAGBUTTON;
    switch (tag) {
        case 0:
        {
            UITextField *userNameTF = [self.view viewWithTag:TAGTEXTFIELD];
            if (![FuData checkTextFieldHasValidInput:userNameTF]) {
                [self showTitle:@"请输入账号"];
                return;
                
            }
            UITextField *passwordTF = [self.view viewWithTag:TAGTEXTFIELD + 1];
            if (![FuData checkTextFieldHasValidInput:passwordTF]) {
                [self showTitle:@"请输入密码"];
                return;
            }
            
            NSDictionary *dic = @{@"name":[FuData cleanString:userNameTF.text],@"password":[FuData cleanString:passwordTF.text]};
            WEAKSELF(this);
            [self showWaitView:YES];
            [FuWeb requestWithUrl:FSWebUrl_Login params:dic successBlock:^(id dic) {
                [this showWaitView:NO];
                [this.navigationController dismissViewControllerAnimated:YES completion:^{
                }];
            } failBlock:^(NSString *msg) {
                [this showWaitView:NO];
                [this showTitle:msg];
            }];
        }
            break;
          case 1:
        {
            FSRegisterController *registerVC = [[FSRegisterController alloc] init];
            [self.navigationController pushViewController:registerVC animated:YES];
        }
            break;
        default:
        {
            
        }
            break;
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
