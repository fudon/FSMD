//
//  FSAddressController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/7/19.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSAddressController.h"

@interface FSAddressController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FSAddressController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addressDesignViews];
}

- (void)addressDesignViews
{
    self.title = @"选择地点";
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self addressArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"addressCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dic = [[self addressArray] objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"name"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSArray *)addressArray
{
    return @[@{
                 @"simple":@"G",
                 @"id":@"1",
                 @"name":@"北京"
                },
             @{
                 @"simple":@"S",
                 @"id":@"2",
                 @"name":@"上海"
                },
             @{
                @"simple":@"G",
                @"id":@"3",
                @"name":@"广州",
                },
             @{
                @"simple":@"S",
                @"id":@"4",
                @"name":@"深圳",
                },
             @{
                @"simple":@"C",
                @"id":@"5",
                @"name":@"重庆",
                },
             @{
                @"simple":@"T",
                @"id":@"6",
                @"name":@"天津",
                },
             @{
                @"simple":@"Z",
                @"id":@"7",
                @"name":@"浙江",
                },
             @{
                @"simple":@"H",
                @"id":@"8",
                @"name":@"湖南",
                },
             ];
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
