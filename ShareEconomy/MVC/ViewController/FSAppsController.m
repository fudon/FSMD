//
//  FSAppsController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/9/11.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSAppsController.h"
#import "FSImageLabelView.h"
#import "FSQRController.h"
#import "FSHardwareInfoController.h"
#import "FSLoanCounterController.h"
#import "FSTaxOfIncomeController.h"
#import "FSWebController.h"
#import "FSSameKindController.h"
#import "FSChineseCalendarController.h"
#import "FSFinancesManagerController.h"
#import "FSHTMLController.h"
#import "FSAccessController.h"

@interface FSAppsController ()

@end

@implementation FSAppsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"百宝箱";
    
    NSArray *array = @[@"二维码",@"记账本",@"设备信息",@"导航",@"消费",@"贷款计算器",@"个税计算器",@"流量统计"];
    NSArray *picArray = @[@"saoma_too",@"a_4",@"a_n",@"ae6",@"myintegral",@"my_history",@"tootoodingdan",@"ae6"];
    
    CGFloat width = (WIDTHFC - 100) / 4;
    WEAKSELF(this);
    for (int x = 0; x < array.count; x ++) {
        FSImageLabelView *imageView = [FSImageLabelView imageLabelViewWithFrame:CGRectMake(20 + (x % 4) * (width + 20), 10 + (x / 4) * (width + 45), width, width + 25) imageName:picArray[x] text:array[x]];
        imageView.block = ^ (FSImageLabelView *bImageLabelView){
            [this imageViewAction:bImageLabelView];
        };
        imageView.tag = TAGIMAGEVIEW + x;
        [self.scrollView addSubview:imageView];
    }
}

- (void)imageViewAction:(FSImageLabelView *)imageLabelView
{
    NSInteger index = imageLabelView.tag - TAGIMAGEVIEW;
    switch (index) {
        case 0:
        {
            FSQRController *qrController = [[FSQRController alloc] init];
            [self.navigationController pushViewController:qrController animated:YES];
        }
            break;
        case 1:
        {
            FSFinancesManagerController *moneyListController = [[FSFinancesManagerController alloc] init];
            [self.navigationController pushViewController:moneyListController animated:YES];
        }
            break;
        case 2:
        {
            FSHardwareInfoController *hwController = [[FSHardwareInfoController alloc] init];
            [self.navigationController pushViewController:hwController animated:YES];
        }
            break;
        case 3:
        {
            FSAccessController *access = [[FSAccessController alloc] init];
            access.title = @"分类网站";
            access.datas = @[@{Picture_Name:@"tblogo",Text_Name:@"购物消费",Url_String:@"http://xw.qq.com"},
                               @{Picture_Name:@"jdlogo",Text_Name:@"新闻阅读",Url_String:@"http://3g.163.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"银行服务",Url_String:@"http://www.sina.cn"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"影视娱乐",Url_String:@"http://blog.sina.cn"},
                               ];

            [self.navigationController pushViewController:access animated:YES];
        }
            break;
        case 4:
        {

        }
            break;
        case 5:
        {
            FSLoanCounterController *loanCounter = [[FSLoanCounterController alloc] init];
            [self.navigationController pushViewController:loanCounter animated:YES];
        }
            break;
        case 6:
        {
            FSTaxOfIncomeController *taxController = [[FSTaxOfIncomeController alloc] init];
            [self.navigationController pushViewController:taxController animated:YES];
        }
            break;
        case 7:
        {
            FSHTMLController *flowMetterController = [[FSHTMLController alloc] init];
            NSString *path = [[NSBundle mainBundle] pathForResource:@"FSH5" ofType:@"html"];
            flowMetterController.localUrlString = path;
            [self.navigationController pushViewController:flowMetterController animated:YES];
        }
            break;
        case 8:
        {
            FSChineseCalendarController *ccController = [[FSChineseCalendarController alloc] init];
            [self.navigationController pushViewController:ccController animated:YES];
        }
            break;
        default:
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
