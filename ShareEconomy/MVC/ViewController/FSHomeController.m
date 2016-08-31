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
#import "FSComposeController.h"
#import "FSAddressController.h"

@interface FSHomeController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL               hasHiddenNavigationBar;
@property (nonatomic,strong) UITableView        *tableView;

@end

@implementation FSHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    NSString *version = @"北京";
    UIButton *rightButton = [FSViewManager buttonWithFrame:CGRectMake(0, 0, 60, 40) title:version titleColor:[UIColor whiteColor] backColor:nil fontInt:0 tag:0 target:self selector:@selector(rightBtnClick)];
    UIBarButtonItem *bbi = [FSViewManager barButtonItemWithCustomButton:rightButton];
    self.navigationItem.leftBarButtonItem = bbi;
    
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:@[@"我要",@"帮人"]];
    segControl.tintColor = [UIColor whiteColor];
    segControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segControl;
    
    UIBarButtonItem *addBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addActionHome)];
    addBBI.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = addBBI;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 113) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)addActionHome
{
    NSString *nilString = nil;
    NSArray *array = @[@"a",nilString,@"b"];
    NSLog(@"%@",array);
    FSComposeController *composeController = [[FSComposeController alloc] init];
    [self.navigationController pushViewController:composeController animated:YES];
}

- (void)rightBtnClick
{
    FSAddressController *addressController = [[FSAddressController alloc] init];
    [self.navigationController pushViewController:addressController animated:YES];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((scrollView.contentOffset.y > HEIGHTFC)) {
        if (!self.hasHiddenNavigationBar) {
            WEAKSELF(this);
            [UIView animateWithDuration:.3 animations:^{
                this.navigationController.navigationBar.bottom = 0;
            } completion:^(BOOL finished) {
                this.tableView.frame = CGRectMake(0, 0, WIDTHFC, HEIGHTFC - 49);
            }];
            self.hasHiddenNavigationBar = YES;
        }
    }else{
        if (self.hasHiddenNavigationBar) {
            WEAKSELF(this);
            [UIView animateWithDuration:.3 animations:^{
                this.navigationController.navigationBar.bottom = 64;
            } completion:^(BOOL finished) {
                this.tableView.frame = CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 113);
            }];
            self.hasHiddenNavigationBar = NO;
        }
    }
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
