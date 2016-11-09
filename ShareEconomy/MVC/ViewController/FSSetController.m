//
//  FSSetController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/7/20.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSSetController.h"
#import "FSCacheManager.h"

@interface FSSetController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView    *tableView;
@property (nonatomic,strong) NSArray        *array;
@property (nonatomic,strong) NSArray        *values;

@end

@implementation FSSetController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    _array = @[@"清除缓存",@"意见反馈"];
    _values = @[@"计算缓存中...",@"请告知您的宝贵提议"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [self sdWebCacheSize];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"infoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text = [_array objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [_values objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)sdWebCacheSize
{
    WEAKSELF(this);
    [FSCacheManager allCacheSize:^(NSUInteger bResult) {
        NSString *cache = [FuData kMGTUnit:bResult];
        UITableViewCell *cell = [this.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.detailTextLabel.text = cache;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WEAKSELF(this);
    [self showWaitView:YES];
    [FSCacheManager clearAllCache:^{
        [this showWaitView:NO];
        [FuData showMessage:@"清除成功"];
        UITableViewCell *cell = [this.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.detailTextLabel.text = @"";
    }];
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
