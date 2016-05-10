//
//  FSBaseController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSBaseController.h"

@interface FSBaseController ()

@property (nonatomic,strong) UIView             *baseNetView;
@property (nonatomic,strong) UIView             *baseNetBlackView;
@property (nonatomic,strong) UIView             *baseDelayView;
@property (nonatomic,strong) UILabel            *baseDelayLabel;
@property (nonatomic,assign) NSTimeInterval     baseTimeDelay;

@end

@implementation FSBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(250, 250, 250, 1);
    
    UIView *backView = [FSViewManager viewWithFrame:self.view.bounds backColor:nil];
    [self.view insertSubview:backView atIndex:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionBase)];
    [backView addGestureRecognizer:tap];
    
    self.navigationController.navigationBar.barTintColor = FSAPPCOLOR;
    if (self.navigationController.viewControllers.count > 1) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 20, WIDTHFC / 4, 44);
        [backButton addTarget:self action:@selector(popActionBase) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        
        UIImageView *btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 12, 20, 20)];
        btnImage.image = IMAGENAMED(@"back-100");
        [backButton addSubview:btnImage];
        
        UIViewController *frontVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
        if (frontVC.title) {
            UILabel *txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 2 * backButton.width - 20, backButton.height)];
            txtLabel.font = FONTFC(14);
            txtLabel.textColor = [UIColor whiteColor];
            [backButton addSubview:txtLabel];
            NSString *text = frontVC.title;
            if (text.length >= 5) {
                text = @"返回";
            }
            txtLabel.text = text;
        }
        
        UIBarButtonItem *leftBBI = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = leftBBI;
    }
}

- (void)tapActionBase
{
    [self.view endEditing:YES];
}

- (void)popActionBase
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setLetStatusBarWhite:(BOOL)letStatusBarWhite
{
    _letStatusBarWhite = letStatusBarWhite;
    if (letStatusBarWhite) {
        if (IOS7FC) {
            [self.navigationController.navigationBar setTranslucent:YES];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        } else {
            self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:130/255.0 blue:200/255.0 alpha:1];
        }
    }else{
        if (IOS7FC) {
            [self.navigationController.navigationBar setTranslucent:YES];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        } else {
            self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:130/255.0 blue:200/255.0 alpha:1];
        }
    }
}

- (void)showWaitView:(BOOL)show
{
    if (show) {
        if (_baseNetView) {
            [self.view bringSubviewToFront:_baseNetView];
            _baseNetView.left = 0;
        }else{
            _baseNetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTHFC, HEIGHTFC)];
            [self.view insertSubview:_baseNetView atIndex:self.view.subviews.count];
            
            _baseNetBlackView = [[UIView alloc] initWithFrame:CGRectMake(WIDTHFC/2 - WIDTHFC / 10, HEIGHTFC/ 2 - WIDTHFC / 10 - 50, WIDTHFC / 5, WIDTHFC / 5)];
            _baseNetBlackView.alpha = .7;
            _baseNetBlackView.backgroundColor = [UIColor blackColor];
            _baseNetBlackView.layer.cornerRadius = 6;
            [_baseNetView addSubview:_baseNetBlackView];
            
            UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            active.frame = CGRectMake(0, 0, _baseNetBlackView.width, _baseNetBlackView.height);
            [active startAnimating];
            [_baseNetBlackView addSubview:active];
        }
    }else{
        _baseNetView.right = - WIDTHFC;
    }
}

- (void)showTitle:(NSString *)title
{
    [self showWithTitle:title withDelay:2];
}

- (void)showWithTitle: (NSString *)title withDelay:(NSInteger)delay
{
    if (!title.description.length) {
        title = @"提示为空";
    }
    self.baseTimeDelay = [[NSDate date] timeIntervalSince1970];
    
    if (!_baseDelayView) {
        _baseDelayView = [[UIView alloc] initWithFrame:CGRectMake(30, HEIGHTFC / 2, WIDTHFC - 60, 30)];
        _baseDelayView.backgroundColor = [UIColor blackColor];
        _baseDelayView.alpha = .7;
        _baseDelayView.layer.cornerRadius = 3;
        
        _baseDelayLabel = [[UILabel alloc] initWithFrame:_baseDelayView.bounds];
        _baseDelayLabel.textAlignment = NSTextAlignmentCenter;
        _baseDelayLabel.numberOfLines = 0;
        _baseDelayLabel.textColor = [UIColor whiteColor];
        _baseDelayLabel.font = FONTBOLD(14);
        _baseDelayLabel.layer.masksToBounds = YES;
        [_baseDelayView addSubview:_baseDelayLabel];
        [self.view addSubview:_baseDelayView];
    }
    
    CGFloat height = MAX(30,[FuData textHeight:title fontInt:14 labelWidth:WIDTHFC - 60]);
    _baseDelayView.height = height;
    _baseDelayLabel.height = height;
    _baseDelayView.left = 30;
    _baseDelayLabel.text = title;
    [self.view bringSubviewToFront:_baseDelayView];
    [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(hiddenShowHidden) userInfo:nil repeats:NO];
}

- (void)hiddenShowHidden
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval chae = time - self.baseTimeDelay;
    if (chae >= 2) {
        [UIView animateWithDuration:.5 animations:^{
            _baseDelayView.alpha = 0;
        } completion:^(BOOL finished) {
            _baseDelayView.alpha = 1;
            _baseDelayView.right = - WIDTHFC;
        }];
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
