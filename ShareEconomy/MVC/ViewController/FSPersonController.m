//
//  FSPersonController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/7/21.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSPersonController.h"
#import "FuSoft.h"
#import "FSHeadPictureController.h"
#import "FSChangeController.h"
//#import "AboutController.h"
//#import "ChangePwdController.h"
//#import "NickController.h"
//#import "NumberController.h"
//#import "AddressController.h"
//#import "AuthenticationController.h"
//#import "GestureController.h"
//#import "EmailController.h"


@interface FSPersonController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FSPersonController
{
    NSArray         *_asArrayRow;
    UITableView     *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self asConfigSuper];
    [self asHandleDatas];
    [self asDesignViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_tableView reloadData];
}

- (void)asConfigSuper
{
    self.title = @"个人资料";
    _asArrayRow = @[@[@"账号",@"头像"],@[@"手机号",@"邮箱"],@[@"实名认证",@"登录密码",@"手势密码"]];
}

- (void)asHandleDatas
{
    
}

- (void)asDesignViews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _asArrayRow.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = _asArrayRow[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"asCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text = _asArrayRow[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"扶盛来";
        }else if (indexPath.row == 2) {

        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
//            cell.detailTextLabel.text = DEFAULTTEXT([FuSing shareInstance].userModel.phone, @"未设置");
        }else if (indexPath.row == 1){
//            cell.detailTextLabel.text = DEFAULTTEXT([FuSing shareInstance].userModel.email, @"未设置");
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"芝麻分755";
        }else if (indexPath.row == 1){
            
        }
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
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
    
    id  pushVC = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            pushVC = [[FSHeadPictureController alloc] init];
        }else if (indexPath.row == 2){
            FSChangeController *push = [[FSChangeController alloc] init];
            pushVC = push;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            FSChangeController *push = [[FSChangeController alloc] init];
            pushVC = push;
        }else if (indexPath.row == 1){
            FSChangeController *push = [[FSChangeController alloc] init];
            pushVC = push;
        }
            else if (indexPath.row == 2){
//            pushVC = [[AddressController alloc] init];
//        }
//    }else if (indexPath.section == 2){
//        if (indexPath.row == 0) {
//            pushVC = [[AuthenticationController alloc] init];
//        }else if (indexPath.row == 1){
//            pushVC = [[ChangePwdController alloc] init];
//        }else if (indexPath.row == 2){
//            GestureController *push = [[GestureController alloc] init];
//            push.gType = GestureTypeSetCode;
//            pushVC = push;
        }
    }
//
    if (pushVC) {
        [self.navigationController pushViewController:pushVC animated:YES];
    }
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
