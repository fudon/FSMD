//
//  FSZoneController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSZoneController.h"
#import "FSSetController.h"
#import "FSZoneHeadView.h"
#import "FSPersonController.h"

@interface FSZoneController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView    *tableView;
@property (nonatomic,strong) NSArray        *array;

@end

@implementation FSZoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行";
    _array = @[@"美盾",@"支持优雅"];
    
    self.navigationItem.rightBarButtonItem = [FSViewManager barButtonItemWithTitle:@"设置" target:self selector:@selector(configAction) tintColor:nil];
    
    WEAKSELF(this);
    FSZoneHeadView *headView = [[FSZoneHeadView alloc] initWithFrame:CGRectMake(0, 0, WIDTHFC, 132)];
    headView.block = ^ (FSZoneHeadView *bView,NSInteger bIndex){
        if (bIndex == 0) {
            FSPersonController *personController = [[FSPersonController alloc] init];
            [this.navigationController pushViewController:personController animated:YES];
        }
    };
    
    _tableView = [FSViewManager tableViewWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 64) delegate:self style:UITableViewStyleGrouped footerView:[UIView new]];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = headView;
    [self.view addSubview:_tableView];
}

- (void)configAction
{
    FSSetController *setController = [[FSSetController alloc] init];
    [self.navigationController pushViewController:setController animated:YES];
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
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = @"1000";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
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
