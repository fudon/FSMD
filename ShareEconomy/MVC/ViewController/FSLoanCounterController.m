//
//  FSLoanCounterController.m
//  ShareEconomy
//
//  Created by fudon on 16/6/1.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSLoanCounterController.h"

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
    NSArray *titles = @[@"贷款总额",@"贷款期数",@"年利率"];
    NSArray *placeholders = @[@"单位：万元",@"月数，如10年填120",@"年利率"];
    for (int x = 0; x < titles.count; x ++) {
        UILabel *label = [FSViewManager labelWithFrame:CGRectMake(0,80 + 50 * x, 70, 40) text:titles[x] textColor:nil backColor:nil font:FONTFC(13) textAlignment:NSTextAlignmentRight];
        [self.view addSubview:label];
        
        UITextField *textField = [FSViewManager textFieldWithFrame:CGRectMake(label.right + 10, label.top, WIDTHFC - 10 - label.width, label.height) placeholder:placeholders[x] textColor:nil];
        textField.tag = TAGTEXTFIELD + x;
        [self.view addSubview:textField];
    }
    
    UIButton *button = [FSViewManager buttonWithFrame:CGRectMake(20, 240, WIDTHFC - 40, 40) title:@"计算" titleColor:[UIColor whiteColor] backColor:FSAPPCOLOR fontInt:0 target:self selector:@selector(countAction)];
    [self.view addSubview:button];
}

- (void)countAction
{
    UITextField *moneyTF = (UITextField *)[self.view viewWithTag:TAGTEXTFIELD];
    if (![FuData isPureFloat:moneyTF.text]) {
        return;
    }
    UITextField *periodTF = (UITextField *)[self.view viewWithTag:TAGTEXTFIELD + 1];
    if (![FuData isPureInt:periodTF.text]) {
        return;
    }
    UITextField *rateTF = (UITextField *)[self.view viewWithTag:TAGTEXTFIELD];
    if (![FuData isPureFloat:rateTF.text]) {
        return;
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
