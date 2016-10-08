//
//  FSHouseLoanController.m
//  ShareEconomy
//
//  Created by fudon on 2016/10/8.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSHouseLoanController.h"

@interface FSHouseLoanController ()

@end

@implementation FSHouseLoanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首付计算器";
    
    NSArray *titles = @[@"房价",@"面积",@"税费评估价",@"银行评估价"];
    NSArray *placeholders = @[@"单位：万元",@"单位：平方米",@"单位：元",@"单位：元"];
    for (int x = 0; x < titles.count; x ++) {
        UILabel *label = [FSViewManager labelWithFrame:CGRectMake(0,80 + 50 * x, 70, 40) text:titles[x] textColor:nil backColor:nil font:FONTFC(13) textAlignment:NSTextAlignmentRight];
        [self.view addSubview:label];
        
        UITextField *textField = [FSViewManager textFieldWithFrame:CGRectMake(label.right + 10, label.top, WIDTHFC - 30 - label.width, label.height) placeholder:placeholders[x] textColor:nil backColor:RGBCOLOR(240, 240, 240, 1)];
        textField.tag = TAGTEXTFIELD + x;
        if (x == 1) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }else{
            textField.keyboardType = UIKeyboardTypeDecimalPad;
        }
        [self.view addSubview:textField];
    }
    
    UIButton *button = [FSViewManager buttonWithFrame:CGRectMake(20, 290, WIDTHFC - 40, 40) title:@"计算" titleColor:[UIColor whiteColor] backColor:FSAPPCOLOR fontInt:0 tag:0 target:self selector:@selector(countAction)];
    [self.view addSubview:button];
    
    UILabel *showLabel = [FSViewManager labelWithFrame:CGRectMake(20, button.bottom + 5, WIDTHFC - 20, 30) text:@"*计算结果只供参考，如有出入,请以专业为准。" textColor:[UIColor lightGrayColor] backColor:nil font:FONTFC(12) textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:showLabel];
}

- (void)countAction
{
    UITextField *moneyTF = (UITextField *)[self.view viewWithTag:TAGTEXTFIELD];
    if (![FuData isPureFloat:moneyTF.text]) {
        [self showTitle:@"请填写正确的房价"];
        return;
    }
    UITextField *sizeTF = (UITextField *)[self.view viewWithTag:TAGTEXTFIELD + 1];
    if (![FuData isPureInt:sizeTF.text]) {
        [self showTitle:@"请填写面积"];
        return;
    }
    UITextField *taxTF = (UITextField *)[self.view viewWithTag:TAGTEXTFIELD + 2];
    if (![FuData isPureFloat:taxTF.text]) {
        [self showTitle:@"请填写税费评估价"];
        return;
    }
    UITextField *bankTF = (UITextField *)[self.view viewWithTag:TAGTEXTFIELD + 3];
    if (![FuData isPureFloat:bankTF.text]) {
        [self showTitle:@"请填写银行评估价"];
        return;
    }
    
    CGFloat money = [moneyTF.text floatValue] * 10000;
    CGFloat size = [sizeTF.text floatValue];
    CGFloat taxPrice = [taxTF.text floatValue];
    CGFloat bank = [bankTF.text floatValue];
    
    CGFloat deedTax = taxPrice * size * (1.5 / 100 + 1.0 / 100);    // 契税
    CGFloat bankPrice = bank * size * 0.8;                          // 银行评估价
    CGFloat downPay = money - bankPrice;                            // 首付
    CGFloat valuationFee = 500;                                     // 评估费
    CGFloat tradeFee = size * 4;                                    // 交易手续费
    CGFloat loanFee = bankPrice * 3 / 100.0;                        // 按揭服务费
    CGFloat agencyFee = money * 2 / 100.0;                          // 中介费
    CGFloat changeFee = 71;                                         // 工本费
    
    CGFloat allPay = deedTax + downPay + valuationFee + tradeFee + loanFee + agencyFee + changeFee;
    [FuData showAlertViewWithTitile:[[NSString alloc] initWithFormat:@"银行评估价:%.2f万元\n\n契税:%.2f万元\n评估费:%.2f元\n交易手续费:%.2f元\n按揭服务费:%.2f万元\n中介费:%.2f万元\n工本费:%.2f元\n首付:%.2f万元\n\n总支出：%.2f万元",bankPrice / 10000,deedTax / 10000,valuationFee,tradeFee,loanFee / 10000,agencyFee / 10000,changeFee,downPay / 10000,allPay / 10000]];
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
