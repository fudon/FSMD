//
//  FSSameKindController.m
//  ShareEconomy
//
//  Created by fudon on 16/6/22.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSSameKindController.h"
#import "FSWebController.h"

@interface FSSameKindController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FSSameKindController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
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
    NSDictionary *dic = self.datas[indexPath.row];
    
    FSWebController *webController = [[FSWebController alloc] init];
    webController.urlString = [dic objectForKey:Url_String];
    [self.navigationController pushViewController:webController animated:YES];
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
