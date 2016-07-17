//
//  FSFlowMeterController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/7/16.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSFlowMeterController.h"
#import "FlowMeter.h"

@interface FSFlowMeterController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FSFlowMeterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Web流量监控";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [FlowMeter shareInstance].webArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"flowMeterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    NSDictionary *dic = [[FlowMeter shareInstance].webArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:Swizzle_Name];
    NSNumber *read = [dic objectForKey:Swizzle_Read];
    cell.detailTextLabel.text = [FuData kMGTUnit:[read integerValue]];
    return cell;
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
