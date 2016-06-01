//
//  FSMoneyController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSMoneyController.h"
#import "FSImageLabelView.h"
#import "FSQRController.h"
#import "FSHardwareInfoController.h"
#import "FSLoanCounterController.h"

@interface FSMoneyController ()

@end

@implementation FSMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"百宝箱";
    
    NSArray *array = @[@"二维码",@"记账本",@"设备信息",@"蓝牙",@"利息计算器",@"贷款计算器",@"个税计算器"];
    NSArray *picArray = @[@"saoma_too",@"a_4",@"a_n",@"ae6",@"myintegral",@"my_history",@"tootoodingdan"];
    
    CGFloat width = (WIDTHFC - 100) / 4;
    WEAKSELF(this);
    for (int x = 0; x < array.count; x ++) {
        FSImageLabelView *imageView = [FSImageLabelView imageLabelViewWithFrame:CGRectMake(20 + (x % 4) * (width + 20), 74 + (x / 4) * (width + 45), width, width + 25) imageName:picArray[x] text:array[x]];
        imageView.block = ^ (FSImageLabelView *bImageLabelView){
            [this imageViewAction:bImageLabelView];
        };
        imageView.tag = TAGIMAGEVIEW + x;
        [self.view addSubview:imageView];
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
        {}
            break;
            case 2:
        {
            FSHardwareInfoController *hwController = [[FSHardwareInfoController alloc] init];
            [self.navigationController pushViewController:hwController animated:YES];
        }
            break;
            case 3:
        {}
            break;
            case 4:
        {}
            break;
            case 5:
        {
            FSLoanCounterController *loanCounter = [[FSLoanCounterController alloc] init];
            [self.navigationController pushViewController:loanCounter animated:YES];
        }
            break;
            case 6:
        {}
            break;
            case 7:
        {}
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
