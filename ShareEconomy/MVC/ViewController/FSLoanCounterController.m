//
//  FSLoanCounterController.m
//  ShareEconomy
//
//  Created by fudon on 16/6/1.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSLoanCounterController.h"
#import "FSLoanResultController.h"

@interface FSLoanCounterController ()

@end

@implementation FSLoanCounterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loanCounterDesignViews];
}

- (void)loanCounterDesignViews
{
    self.title = @"贷款计算器";
    NSArray *titles = @[@"贷款总额",@"贷款期数",@"年利率"];
    NSArray *placeholders = @[@"单位：万元",@"月数，如10年填120",@"如5%，填5"];
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
    
    UIButton *button = [FSViewManager buttonWithFrame:CGRectMake(20, 240, WIDTHFC - 40, 40) title:@"计算" titleColor:[UIColor whiteColor] backColor:FSAPPCOLOR fontInt:0 tag:0 target:self selector:@selector(countAction)];
    [self.view addSubview:button];
    
    UILabel *showLabel = [FSViewManager labelWithFrame:CGRectMake(20, button.bottom + 5, WIDTHFC - 20, 30) text:@"*计算结果只供参考，如有出入,请以专业为准。" textColor:[UIColor lightGrayColor] backColor:nil font:FONTFC(12) textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:showLabel];
}

// http://www.edai.com/jsq/ajfd/

- (void)countAction
{
    UITextField *moneyTF = (UITextField *)[self.view viewWithTag:TAGTEXTFIELD];
    if (![FuData isPureFloat:moneyTF.text]) {
        [self showTitle:@"请填写正确的总金额数字"];
        return;
    }
    UITextField *periodTF = (UITextField *)[self.view viewWithTag:TAGTEXTFIELD + 1];
    if (![FuData isPureInt:periodTF.text]) {
        [self showTitle:@"请填写期数"];
        return;
    }
    UITextField *rateTF = (UITextField *)[self.view viewWithTag:TAGTEXTFIELD + 2];
    if (![FuData isPureFloat:rateTF.text]) {
        [self showTitle:@"请填写正确的年利率数字"];
        return;
    }
    
    CGFloat money = [moneyTF.text floatValue] * 10000;
    CGFloat month = [periodTF.text integerValue];
    CGFloat rate = [rateTF.text doubleValue];
    double R = rate / 1200;
    
    // 等额本息
    double monthPay = (money * R * pow(1 + R, month)) / (pow(1 + R, month) - 1);
    NSMutableArray *bxArray = [[NSMutableArray alloc] initWithCapacity:month];
    for (int x = 1; x <= month; x ++) {
        double mP = (money * R - monthPay) * pow(1 + R, x - 1) + monthPay;
        [bxArray addObject:@(mP)];
    }
    
    // 等额本金
    NSMutableArray *bjArray = [[NSMutableArray alloc] initWithCapacity:month];
    double payMonth = money / month;
    for (int x = 0; x < month; x ++) {
        double mI = (money - x * payMonth) * R;
        [bjArray addObject:@(mI).stringValue];
    }

    FSLoanResultController *resultController = [[FSLoanResultController alloc] init];
    resultController.bxMonthPay = monthPay;
    resultController.bxInterests = bxArray;
    resultController.bjInterests = bjArray;
    resultController.money = money;
    resultController.month = month;
    resultController.bxMonthPay = monthPay;
    resultController.yearRate = rate;
    [self.navigationController pushViewController:resultController animated:YES];
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
