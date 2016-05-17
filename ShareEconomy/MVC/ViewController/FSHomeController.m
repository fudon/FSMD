//
//  FSHomeController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSHomeController.h"
#import "FSHomeCell.h"
#import "FSLoginController.h"

@interface FSHomeController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FSHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"爱";
    
    FSLog(@"%@",[FuData textFromBase64String:[FuData base64StringForText:@"你好，欢迎光临老罗的缤纷天地！"]]);
    
    NSString *version = [FuData appVersionNumber];
    UIButton *rightButton = [FSViewManager buttonWithFrame:CGRectMake(0, 0, 60, 40) title:version titleColor:[UIColor redColor] backColor:nil fontInt:0 target:self selector:@selector(rightBtnClick)];
    UIBarButtonItem *bbi = [FSViewManager barButtonItemWithCustomButton:rightButton];
    self.navigationItem.rightBarButtonItem = bbi;

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 113) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

- (void)rightBtnClick
{
    [self checkIsLogined];
}

- (void)checkIsLogined
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *key = [ud objectForKey:@""];
    if (!key.length) {
        FSLoginController *login = [[FSLoginController alloc] init];
        FSNavigationController *navigationController = [[FSNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"homeCell";
    FSHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FSHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
