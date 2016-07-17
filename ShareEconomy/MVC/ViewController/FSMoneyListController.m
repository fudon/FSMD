//
//  FSMoneyListController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/7/11.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSMoneyListController.h"

@interface FSMoneyListController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FSMoneyListController
{
    NSArray     *_textArrays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记一笔";
    
    _textArrays = @[@"收入",@"成本",@"应收账款",@"现金",@"投资",@"存货",@"摊销资产",@"负债"];
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(bbiActionMoneyList)];
    bbi.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = bbi;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTHFC, 110)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [FSViewManager labelWithFrame:CGRectMake(0, 20, 50, 40) text:@"金 额" textColor:nil backColor:nil font:FONTFC(13) textAlignment:NSTextAlignmentRight];
    [headView addSubview:label];
    
    UITextField *textField = [FSViewManager textFieldWithFrame:CGRectMake(60, 20, WIDTHFC - 80, 40) placeholder:@"单位：元" textColor:nil backColor:RGBCOLOR(240, 240, 240, 1)];
    [headView addSubview:textField];
    
    UILabel *textLabel = [FSViewManager labelWithFrame:CGRectMake(15, textField.bottom + 20, 70, 30) text:@"应用场景" textColor:nil backColor:nil font:FONTFC(13) textAlignment:NSTextAlignmentLeft];
    [headView addSubview:textLabel];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    tableView.tableHeaderView = headView;
    tableView.tableFooterView = [[UIView alloc] init];
}

- (void)bbiActionMoneyList
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _textArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"moneyListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.font = FONTFC(13);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = _textArrays[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
