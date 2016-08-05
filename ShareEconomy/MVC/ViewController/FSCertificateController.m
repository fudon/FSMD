//
//  FSCertificateController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/8/5.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSCertificateController.h"

@interface FSCertificateController ()

@end

@implementation FSCertificateController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self certificateDesignViews];
}

- (void)certificateDesignViews
{
    self.title = @"认证";
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
