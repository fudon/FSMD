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
#import "FSTaxOfIncomeController.h"
#import "FSWebController.h"
#import "FSSameKindController.h"
#import "FSMoneyListController.h"
#import "FSFlowMeterController.h"
#import "FSChineseCalendarController.h"

@interface FSMoneyController ()

@end

@implementation FSMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"百宝箱";
    
    NSArray *array = @[@"二维码",@"记账本",@"设备信息",@"信息",@"消费",@"贷款计算器",@"个税计算器",@"流量统计",@"国历"];
    NSArray *picArray = @[@"saoma_too",@"a_4",@"a_n",@"ae6",@"myintegral",@"my_history",@"tootoodingdan",@"ae6",@"ae6"];
    
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
            FSMoneyListController *moneyListController = [[FSMoneyListController alloc] init];
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
            FSSameKindController *sameKind = [[FSSameKindController alloc] init];
            sameKind.title = @"新闻阅读";
            sameKind.datas = @[@{Picture_Name:@"tblogo",Text_Name:@"腾讯新闻",Url_String:@"http://xw.qq.com"},
                               @{Picture_Name:@"jdlogo",Text_Name:@"网易",Url_String:@"http://3g.163.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"新浪新闻",Url_String:@"http://www.sina.cn"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"新浪博客",Url_String:@"http://blog.sina.cn"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"新浪微博",Url_String:@"http://www.weibo.com"},
                               @{Picture_Name:@"gmlogo.jpg",Text_Name:@"搜狐",Url_String:@"http://www.sohu.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"凤凰",Url_String:@"http://i.ifeng.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"简书",Url_String:@"http://www.jianshu.com"},
                               ];
            [self.navigationController pushViewController:sameKind animated:YES];
        }
            break;
            case 4:
        {
            FSSameKindController *sameKind = [[FSSameKindController alloc] init];
            sameKind.title = @"购物消费";
            sameKind.datas = @[
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"天猫",Url_String:@"https://m.tmall.com"},
                               @{Picture_Name:@"tblogo",Text_Name:@"淘宝",Url_String:@"https://m.taobao.com"},
                               @{Picture_Name:@"jdlogo",Text_Name:@"京东商城",Url_String:@"http://m.jd.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"1688",Url_String:@"http://m.1688.com"},
                               @{Picture_Name:@"gmlogo.jpg",Text_Name:@"国美电器",Url_String:@"http://m.gome.com.cn"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"苏宁易购",Url_String:@"http://m.suning.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"亚马逊",Url_String:@"https://www.amazon.cn"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"美团",Url_String:@"http://i.meituan.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"大众点评",Url_String:@"http://m.dianping.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"一号店",Url_String:@"http://m.yhd.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"百度糯米",Url_String:@"https://m.nuomi.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"唯品会",Url_String:@"http://m.vip.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"蘑菇街",Url_String:@"http://m.mogujie.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"聚美优品",Url_String:@"http://m.jumei.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"酒仙网",Url_String:@"http://m.jiuxian.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"58同城",Url_String:@"http://m.58.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"小米官网",Url_String:@"http://m.mi.com"},
                               ];
            [self.navigationController pushViewController:sameKind animated:YES];
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
            FSFlowMeterController *flowMetterController = [[FSFlowMeterController alloc] init];
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
