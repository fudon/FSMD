//
//  FSLoanResultController.m
//  ShareEconomy
//
//  Created by fudon on 16/6/1.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSLoanResultController.h"

@interface FSLoanResultController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView       *tableView;
@property (nonatomic,strong) UIView            *headView;
@property (nonatomic,assign) BOOL              isDEBJ;
@property (nonatomic,assign) double            bjAll;

@property (nonatomic,strong) NSArray           *bxHeadArray;
@property (nonatomic,strong) NSArray           *bjHeadArray;

@end

@implementation FSLoanResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:@[@"等额本息",@"等额本金"]];
    segControl.selectedSegmentIndex = 0;
    segControl.tintColor = [UIColor whiteColor];
    [segControl addTarget:self action:@selector(segControlAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segControl;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)segControlAction:(UISegmentedControl *)segControl
{
    BOOL isDEBJ = segControl.selectedSegmentIndex?YES:NO;
    if (_isDEBJ != isDEBJ) {
        _isDEBJ = isDEBJ;
        [_tableView reloadData];
        [self refreshHeadView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bjInterests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"loanCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        CGFloat xPoint = 0;
        for (int x = 0; x < 5; x ++) {
            UILabel *label = [FSViewManager labelWithFrame:CGRectMake(xPoint, 0, (x == 0)?30:((WIDTHFC - 30)/ 4), 44) text:@"" textColor:nil backColor:nil font:FONTFC(13) textAlignment:NSTextAlignmentCenter];
            label.tag = TAGLABEL + x;
            label.adjustsFontSizeToFitWidth = YES;
            [cell addSubview:label];
            xPoint += label.width;
        }
    }
    NSArray *array = nil;
    if (_isDEBJ) {
        double monthPay = _money / _month;
        array = @[@(indexPath.row + 1),@([self.bjInterests[indexPath.row] doubleValue] + monthPay),@(monthPay),@([self.bjInterests[indexPath.row] doubleValue]),@(_money - monthPay * (indexPath.row + 1))];
    }else{
        double perInterest = [self.bxInterests[indexPath.row] doubleValue];
        array = @[@(indexPath.row + 1),@(_bxMonthPay),@(_bxMonthPay - perInterest),@(perInterest),@(_money - [self havePaybackMoney:indexPath.row])];
    }
    for (int x = 0; x < array.count; x ++) {
        UILabel *label = (UILabel *)[cell viewWithTag:TAGLABEL + x];
        label.text = (x == 0?[array[x] stringValue]:[[NSString alloc] initWithFormat:@"%.2f",[array[x] doubleValue]]);
    }
    return cell;
}

- (double)havePaybackMoney:(NSInteger)row
{
    double havePayback = 0;
    for (int x = 0; x < row + 1; x ++) {
        havePayback += (_bxMonthPay - [self.bxInterests[x] doubleValue]);
    }
    return havePayback;
}

- (double)thesumForBjInterests
{
    if (_bjAll < 0.1) {
        double sum = 0;
        for (int x = 0; x < _bjInterests.count; x ++) {
            sum += ([_bjInterests[x] doubleValue] + _money / _month);
        }
        _bjAll = sum;
    }
    return _bjAll;
}

- (void)refreshHeadView
{
    NSArray *array = nil;
    if (_isDEBJ) {
        if (_bjHeadArray) {
            array = _bjHeadArray;
        }else{
            double all = [self thesumForBjInterests];
            array = @[[[NSString alloc] initWithFormat:@"%@ 元",@(_money)],[[NSString alloc] initWithFormat:@"%@ 月",@(_month)],[[NSString alloc] initWithFormat:@"%.2f 元",all],[[NSString alloc] initWithFormat:@"%@ %@",@(_yearRate),@"%"],[[NSString alloc] initWithFormat:@"%.2f 元",all - _money]];
            _bjHeadArray = array;
        }
    }else{
        if (_bxHeadArray) {
            array = _bxHeadArray;
        }else{
            double all = _bxMonthPay * _month;
            array = @[[[NSString alloc] initWithFormat:@"%@ 元",@(_money)],[[NSString alloc] initWithFormat:@"%@ 月",@(_month)],[[NSString alloc] initWithFormat:@"%.2f 元",all],[[NSString alloc] initWithFormat:@"%@ %@",@(_yearRate),@"%"],[[NSString alloc] initWithFormat:@"%.2f 元",all - _money]];
            _bxHeadArray = array;
        }
    }
    for (int x = 0; x < 5; x ++) {
        UILabel *label = (UILabel *)[_headView viewWithTag:TAGLABEL + x];
        label.text = array[x];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTHFC, 115)];
        _headView.backgroundColor = [UIColor whiteColor];
        NSArray *titles = @[@"贷款总额",@"期数",@"还款总额",@"年利率",@"利息总额"];
        for (int x = 0; x < titles.count; x ++) {
            UILabel *textLabel = [FSViewManager labelWithFrame:CGRectMake((x % 2) * (WIDTHFC - 90), 5 + (x / 2) * 30, 60 - 20 * (x % 2), 25) text:titles[x] textColor:nil backColor:nil font:FONTFC(13) textAlignment:NSTextAlignmentRight];
            [_headView addSubview:textLabel];
            
            UILabel *contentLabel = [FSViewManager labelWithFrame:CGRectMake(textLabel.right + 5, textLabel.top, WIDTHFC - 155 - (x % 2) * 120, textLabel.height) text:titles[x] textColor:FSAPPCOLOR backColor:nil font:FONTFC(13) textAlignment:NSTextAlignmentLeft];
            contentLabel.tag = TAGLABEL + x;
            [_headView addSubview:contentLabel];
        }
        
        NSArray *perTitles = @[@"期数",@"偿还本息",@"偿还本金",@"偿还利息",@"剩余本金"];
        CGFloat xPoint = 0;
        for (int x = 0; x < perTitles.count; x ++) {
            UILabel *label = [FSViewManager labelWithFrame:CGRectMake(xPoint, 95, (x == 0)?30:((WIDTHFC - 30)/ 4), 25) text:perTitles[x] textColor:[UIColor whiteColor] backColor:FSAPPCOLOR font:FONTFC(13) textAlignment:NSTextAlignmentCenter];
            [_headView addSubview:label];
            xPoint += label.width;
        }
    }
    [self refreshHeadView];
    return _headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 115;
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
