//
//  FSHomeController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSChatListController.h"
#import "FSHomeCell.h"
#import "FSLoginController.h"
#import "FSMSGController.h"
#import "FSEaseMob.h"
#import "MJRefresh.h"

#define  UserDefaultsKey_UserPwd        @"USERPWD_EASEMOB"      // 用户名、密码

@interface FSChatListController ()<UITableViewDelegate,UITableViewDataSource,EMClientDelegate>

@property (nonatomic,strong) NSArray            *chatToWhos;
@property (nonatomic,strong) UITableView        *tableView;

@end

@implementation FSChatListController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshConversations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self homeHandleDatas];
}

- (void)homeHandleDatas
{
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    NSArray *userPwd = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsKey_UserPwd];
    userPwd = @[@"22",@"22"];
    if (userPwd) {
        WEAKSELF(this);
        [self showWaitView:YES];
        [[FSEaseMob shareInstance] loginWithAccount:userPwd[0] pwd:userPwd[1] isAutoLogin:YES success:^{
            [this showWaitView:NO];
            this.title = [[EMClient sharedClient] currentUsername];
            [this refreshConversations];
        } fail:^(EMError *bError) {
            [this showWaitView:NO];
            [this showTitle:bError.errorDescription];
        }];
    }else{
        FSLoginController *login = [[FSLoginController alloc] init];
        FSNavigationController *navigationController = [[FSNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:navigationController animated:YES completion:nil];
        [self homeDesignViews];
    }
}

- (void)homeDesignViews
{
    UIBarButtonItem *rightBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(chatToWhoAction)];
    self.navigationItem.rightBarButtonItem = rightBBI;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 113) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    WEAKSELF(this);
    _tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [this refreshConversations];
    }];
}

- (void)chatToWhoAction
{
    FSMSGController *msg = [[FSMSGController alloc] init];
    msg.chatToWho = @"11";
    [self.navigationController pushViewController:msg animated:YES];
}

- (void)refreshConversations
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *whos = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.chatToWhos = whos;
            if (self.tableView) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
            }else{
                [self homeDesignViews];
            }
        });
    });
}

#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _chatToWhos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"homeCell";
    FSHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FSHomeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    EMConversation *conversation = [_chatToWhos objectAtIndex:indexPath.row];
    cell.conversation = conversation;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:@"11" conversationType:EMConversationTypeChat];
    //    [self.navigationController pushViewController:chatController animated:YES];
    
    EMConversation *conversation = [_chatToWhos objectAtIndex:indexPath.row];
    EMMessage *message = conversation.latestMessage;
    if (message.from.length) {
        NSArray *userPwds = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsKey_UserPwd];
        
        FSMSGController *msg = [[FSMSGController alloc] init];
        EMMessage *message = conversation.latestMessage;
        if ([message.from isEqualToString:userPwds[0]]) {
            msg.chatToWho = message.to;
        }else{
            msg.chatToWho = message.from;
        }
        if ([msg.chatToWho isEqualToString:userPwds[0]]) {
            [self showTitle:@"不能发给自己"];
            return;
        }
        if (msg.chatToWho.length == 0) {
            [self showTitle:@"该账号已被服务器删除"];
            return;
        }
        [self.navigationController pushViewController:msg animated:YES];
    }else{
        [self showTitle:@"假数据"];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMConversation *conversation = [_chatToWhos objectAtIndex:indexPath.row];
    EMMessage *message = conversation.latestMessage;
    [self showWaitView:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[EMClient sharedClient].chatManager deleteConversation:message.from deleteMessages:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showWaitView:NO];
            [self refreshConversations];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*!
 *  自动登陆返回结果
 *
 *  @param aError 错误信息
 */
- (void)didAutoLoginWithError:(EMError *)aError
{
    NSLog(@"%s",__FUNCTION__);
}

/*!
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况, 会引起该方法的调用:
 *  1. 登录成功后, 手机无法上网时, 会调用该回调
 *  2. 登录成功后, 网络状态变化时, 会调用该回调
 *
 *  @param aConnectionState 当前状态
 */
- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState
{
    NSLog(@"%s\n\n%d",__FUNCTION__,aConnectionState);
}

/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)didLoginFromOtherDevice
{
    NSLog(@"%s",__FUNCTION__);
}

/*!
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)didRemovedFromServer
{
    NSLog(@"%s",__FUNCTION__);
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
