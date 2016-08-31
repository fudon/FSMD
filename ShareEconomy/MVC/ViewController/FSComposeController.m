//
//  FSComposeController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/5/29.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSComposeController.h"
#import "FSDatePickerView.h"

@interface FSComposeController ()

@end

@implementation FSComposeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(bbiAction)];
    self.navigationItem.rightBarButtonItem = bbi;
    
    // Do any additional setup after loading the view.
}

- (void)bbiAction
{
    FSDatePickerView *datePickerView = [[FSDatePickerView alloc] initWithFrame:self.navigationController.view.bounds];
    [self.navigationController.view addSubview:datePickerView];
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
