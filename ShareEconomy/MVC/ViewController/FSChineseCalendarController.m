//
//  FSChineseCalendarController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/8/7.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSChineseCalendarController.h"
#import "ChineseCalendarView.h"
#import "FSSegmentControl.h"
#import "FSDatePickerView.h"

@interface FSChineseCalendarController ()

@property (nonatomic,strong) ChineseCalendarView *ccView;

@end

@implementation FSChineseCalendarController

- (void)dealloc
{
    FSLog(@"");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(bbiAction)];
    bbi.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = bbi;
    
    FSSegmentControl *control = [[FSSegmentControl alloc] initWithFrame:CGRectMake(0, 7, 100, 30)];
    self.navigationItem.titleView = control;
    WEAKSELF(this);
    control.block = ^(FSSegmentControl   *bControl,NSInteger bSelectedIndex){
        if (bSelectedIndex == 0) {
            this.ccView.thisYearDelta --;
        }else{
            this.ccView.thisYearDelta ++;
        }
    };
    _ccView = [[ChineseCalendarView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 64)];
    [self.view addSubview:_ccView];
}

- (void)bbiAction
{
    WEAKSELF(this);
    FSDatePickerView *picker = [[FSDatePickerView alloc] initWithFrame:CGRectMake(0, 0, WIDTHFC, HEIGHTFC)];
    [self.view.window addSubview:picker];
    picker.block = ^ (NSDate *bDate){
        this.ccView.date = bDate;
    };
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
