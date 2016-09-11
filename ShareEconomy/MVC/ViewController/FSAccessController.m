//
//  FSAccessController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/9/11.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSAccessController.h"
#import "FSSameKindController.h"

@interface FSAccessController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) NSInteger      selectedIndex;
@property (nonatomic,assign) NSInteger      selectedSection;
@property (nonatomic,strong) UITableView    *tableView;

@end

@implementation FSAccessController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_selectedIndex > -1) {
        [_tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:_selectedSection] animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedIndex = -1;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"sameKindCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dic = self.datas[indexPath.row];
    cell.imageView.image = IMAGENAMED([dic objectForKey:Picture_Name]);
    cell.textLabel.text = [dic objectForKey:Text_Name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
    _selectedSection = indexPath.section;
    
    FSSameKindController *sameKind = [[FSSameKindController alloc] init];
    sameKind.title = [self.datas[indexPath.row] objectForKey:Text_Name];
    sameKind.datas = [self configDatasWithIndex:indexPath.row];
    [self.navigationController pushViewController:sameKind animated:YES];
}

- (NSArray *)configDatasWithIndex:(NSInteger)index
{
    NSArray *confitDatas = @[
             @[
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
                 ],
             
             @[@{Picture_Name:@"tblogo",Text_Name:@"腾讯新闻",Url_String:@"http://xw.qq.com"},
               @{Picture_Name:@"jdlogo",Text_Name:@"网易",Url_String:@"http://3g.163.com"},
               @{Picture_Name:@"snlogo.jpg",Text_Name:@"新浪新闻",Url_String:@"http://www.sina.cn"},
               @{Picture_Name:@"snlogo.jpg",Text_Name:@"新浪博客",Url_String:@"http://blog.sina.cn"},
               @{Picture_Name:@"snlogo.jpg",Text_Name:@"新浪微博",Url_String:@"http://www.weibo.com"},
               @{Picture_Name:@"gmlogo.jpg",Text_Name:@"搜狐",Url_String:@"http://www.sohu.com"},
               @{Picture_Name:@"snlogo.jpg",Text_Name:@"凤凰",Url_String:@"http://i.ifeng.com"},
               @{Picture_Name:@"snlogo.jpg",Text_Name:@"简书",Url_String:@"http://www.jianshu.com"},
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
