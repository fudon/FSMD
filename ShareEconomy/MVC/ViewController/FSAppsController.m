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
#import "FSAccountDoorController.h"

@interface FSAppsController ()

@end

@implementation FSAppsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"百宝箱";
    
    NSArray *array = @[@"二维码",@"设备信息",@"导航",@"计算器",@"流量统计"];
    NSArray *picArray = @[@"saoma_too",@"a_n",@"ae6",@"myintegral",@"ae6"];
    
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
            FSHardwareInfoController *hwController = [[FSHardwareInfoController alloc] init];
            [self.navigationController pushViewController:hwController animated:YES];
        }
            break;
        case 2:
        {
            FSAccessController *access = [[FSAccessController alloc] init];
            access.title = @"分类网站";
            access.datas = @[@{Picture_Name:@"tblogo",Text_Name:@"购物消费",Url_String:@"http://xw.qq.com"},
                             @{Picture_Name:@"jdlogo",Text_Name:@"生活服务",Url_String:@"http://3g.163.com"},
                             @{Picture_Name:@"jdlogo",Text_Name:@"新闻阅读",Url_String:@"http://3g.163.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"影视娱乐",Url_String:@"http://blog.sina.cn"},
                             @{Picture_Name:@"snlogo.jpg",Text_Name:@"导航搜索",Url_String:@"http://www.sina.cn"},
                             @{Picture_Name:@"snlogo.jpg",Text_Name:@"银行服务",Url_String:@"http://www.sina.cn"},
                               ];
            WEAKSELF(this);
            access.selectBlock = ^ (FSAccessController *bController,NSIndexPath *bIndexPath){
                FSSameKindController *sameKind = [[FSSameKindController alloc] init];
                sameKind.title = [bController.datas[bIndexPath.row] objectForKey:Text_Name];
                sameKind.datas = [this configDatasWithIndex:bIndexPath.row];
                [bController.navigationController pushViewController:sameKind animated:YES];
            };
            [self.navigationController pushViewController:access animated:YES];
        }
            break;
        case 3:
        {
            FSAccessController *access = [[FSAccessController alloc] init];
            access.title = @"计算工具";
            access.datas = @[@{Picture_Name:@"a_4",Text_Name:@"记账本",Url_String:@"http://xw.qq.com"},
                             @{Picture_Name:@"my_history",Text_Name:@"贷款计算器",Url_String:@"http://3g.163.com"},
                             @{Picture_Name:@"tootoodingdan",Text_Name:@"个税计算器",Url_String:@"http://3g.163.com"},
                             @{Picture_Name:@"tootoodingdan",Text_Name:@"首付计算器",Url_String:@"http://3g.163.com"},
                             ];
            WEAKSELF(this);
            access.selectBlock = ^ (FSAccessController *bController,NSIndexPath *bIndexPath){
                NSArray *classArray = @[@"FSAccountDoorController",@"FSLoanCounterController",@"FSTaxOfIncomeController",@"FSHouseLoanController"];
                Class ControllerClass = NSClassFromString(classArray[bIndexPath.row % classArray.count]);
                if (ControllerClass) {
                    [this.navigationController pushViewController:[[ControllerClass alloc] init] animated:YES];
                }
            };
            [self.navigationController pushViewController:access animated:YES];
        }
            break;
        case 4:
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

- (NSArray *)configDatasWithIndex:(NSInteger)index
{
    NSArray *confitDatas = @[
                             @[
                                 // 购物消费
                                 @{Picture_Name:@"snlogo.jpg",Text_Name:@"天猫",Url_String:@"https://m.tmall.com"},
                                 @{Picture_Name:@"jdlogo",Text_Name:@"京东商城",Url_String:@"http://m.jd.com"},
                                 @{Picture_Name:@"tblogo",Text_Name:@"淘宝",Url_String:@"https://m.taobao.com"},
                                 @{Picture_Name:@"snlogo.jpg",Text_Name:@"亚马逊",Url_String:@"https://www.amazon.cn"},
                                 @{Picture_Name:@"gmlogo.jpg",Text_Name:@"国美电器",Url_String:@"http://m.gome.com.cn"},
                                 @{Picture_Name:@"snlogo.jpg",Text_Name:@"苏宁易购",Url_String:@"http://m.suning.com"},
                                 @{Picture_Name:@"snlogo.jpg",Text_Name:@"唯品会",Url_String:@"http://m.vip.com"},
                                 @{Picture_Name:@"snlogo.jpg",Text_Name:@"1688",Url_String:@"http://m.1688.com"},
                                 @{Picture_Name:@"snlogo.jpg",Text_Name:@"聚美优品",Url_String:@"http://m.jumei.com"},
                                 @{Picture_Name:@"snlogo.jpg",Text_Name:@"一号店",Url_String:@"http://m.yhd.com"},
                                 @{Picture_Name:@"snlogo.jpg",Text_Name:@"蘑菇街",Url_String:@"http://m.mogujie.com"},
                                 @{Picture_Name:@"snlogo.jpg",Text_Name:@"酒仙网",Url_String:@"http://m.jiuxian.com"},
                                 @{Picture_Name:@"snlogo.jpg",Text_Name:@"小米官网",Url_String:@"http://m.mi.com"},
                                 ],
                             
                             @[
                                 // 生活服务
                                 @{Picture_Name:@"snlogo.jpg",Text_Name:@"美团",Url_String:@"http://i.meituan.com"},
                                 @{Picture_Name:@"snlogo.jpg",Text_Name:@"百度外卖",Url_String:@"http://waimai.baidu.com"},
                                 @{Picture_Name:@"snlogo.jpg",Text_Name:@"饿了么",Url_String:@"http://m.ele.me"},
                                 @{Picture_Name:@"snlogo.jpg",Text_Name:@"百度糯米",Url_String:@"https://m.nuomi.com"},
                                 @{Picture_Name:@"snlogo.jpg",Text_Name:@"大众点评",Url_String:@"http://m.dianping.com"},
                                 @{Picture_Name:@"snlogo.jpg",Text_Name:@"58同城",Url_String:@"http://m.58.com"},
                                 @{Picture_Name:@"snlogo.jpg",Text_Name:@"赶集网",Url_String:@"http://m.ganji.com"},
                                 ],

                             // 新闻信息
                             @[@{Picture_Name:@"tblogo",Text_Name:@"腾讯新闻",Url_String:@"http://xw.qq.com"},
                               @{Picture_Name:@"jdlogo",Text_Name:@"网易",Url_String:@"http://3g.163.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"新浪新闻",Url_String:@"http://www.sina.cn"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"新浪博客",Url_String:@"http://blog.sina.cn"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"新浪微博",Url_String:@"http://www.weibo.com"},
                               @{Picture_Name:@"gmlogo.jpg",Text_Name:@"搜狐",Url_String:@"http://www.sohu.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"凤凰",Url_String:@"http://i.ifeng.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"简书",Url_String:@"http://www.jianshu.com"},
                               ],
                             // 影视娱乐
                             @[@{Picture_Name:@"tblogo",Text_Name:@"优酷",Url_String:@"http://www.youku.com"},
                               @{Picture_Name:@"jdlogo",Text_Name:@"爱奇艺",Url_String:@"http://m.iqiyi.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"腾讯视频",Url_String:@"http://m.v.qq.com"},
                               @{Picture_Name:@"snlogo.jpg",Text_Name:@"乐视视频",Url_String:@"http://m.le.com"},
                               ],
                             // 搜索引擎
                             @[@{Picture_Name:@"tblogo",Text_Name:@"hao123",Url_String:@"https://www.hao123.com"},
                               @{Picture_Name:@"jdlogo",Text_Name:@"百度",Url_String:@"https://www.baidu.com"},
                               ]
                             ];
    return confitDatas[index % confitDatas.count];
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
