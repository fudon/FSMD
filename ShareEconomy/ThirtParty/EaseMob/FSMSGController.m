//
//  FSMSGController.m
//  ShareEconomy
//
//  Created by fudon on 16/5/3.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSMSGController.h"
#import "FSEaseMob.h"
#import "FSChatView.h"
#import "FSChatCell.h"
#import "FSEMMessage.h"
#import "FSSendCell.h"
#import "MJRefresh.h"

@interface FSMSGController ()<UITableViewDelegate,UITableViewDataSource,EMClientDelegate,EMChatManagerDelegate>

@property (nonatomic,strong) NSArray            *chatArray;
@property (nonatomic,strong) UITableView        *tableView;
@property (nonatomic,strong) FSChatView         *chatView;
@property (nonatomic,assign) NSInteger          count;

@property (nonatomic,assign) BOOL               canHiddenKeyboard;

@end

@implementation FSMSGController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    [[EMClient sharedClient].chatManager removeDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [self msgHandleDatas];
}

- (void)msgHandleDatas
{
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:_chatToWho type:EMConversationTypeChat createIfNotExist:YES];
    if (_count == 0) {
        _count = conversation.unreadMessagesCount;
        if (_count < 10) {
            _count = 10;
        }
    }else{
        [_tableView.mj_header endRefreshing];
    }
    self.chatArray = [conversation loadMoreMessagesFromId:@"" limit:(int)self.count direction:EMMessageSearchDirectionUp];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [conversation markAllMessagesAsRead];
    });
    
    if (self.chatView) {
        [self.tableView reloadData];
    }else{
        [self msgDesignViews];
    }
}

- (void)msgDesignViews
{
    self.title = _chatToWho;
    self.view.height = HEIGHTFC + FSChatViewHeight;
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearChatRecord)];
    self.navigationItem.rightBarButtonItem = bbi;
    
    _chatView = [[FSChatView alloc] initWithFrame:CGRectMake(0, HEIGHTFC - 88, WIDTHFC, FSChatViewHeight)];
    _chatView.backgroundColor = RGBCOLOR(240, 240, 240, 1);
    [self.view addSubview:_chatView];
    WEAKSELF(this);
    _chatView.changeHeightBlock = ^ (FSChatView *bChatView,CGFloat delta){
        this.tableView.height = HEIGHTFC - 152 - delta;
    };
    _chatView.sendBlock = ^ (NSString *bText){
        if (![FuData cleanString:bText].length) {
            return;
        }
        this.canHiddenKeyboard = NO;
        
        EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:bText];
        NSString *from = [[EMClient sharedClient] currentUsername];
        EMMessage *message = [[EMMessage alloc] initWithConversationID:this.chatToWho from:from to:this.chatToWho body:body ext:@{}];
        message.chatType = EMChatTypeChat;
        
        NSMutableArray *chatArray = [[NSMutableArray alloc] initWithArray:this.chatArray];
        [chatArray addObject:message];
        this.chatArray = chatArray;
        [this.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:this.chatArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [this makeNewsVisible];
        [this asyncSendMessage:message progress:^(int progress) {
        } completion:^(EMMessage *bMmessage, EMError *bError) {
            if (bError) {
                [FuData showMessage:@"错错错错错错错错"];
            }
        }];
    };
    
    _chatView.selectImageBlock = ^ (FSChatView *bChatView,UIImage *bImage){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *data = UIImagePNGRepresentation(bImage);
            EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithData:data displayName:@"image.png"];
            body.size = bImage.size;
            body.compressRatio = 1.0;
            NSString *from = [[EMClient sharedClient] currentUsername];
            
            FSEMMessage *fsEM = [[FSEMMessage alloc] initWithConversationID:this.chatToWho from:from to:this.chatToWho body:body ext:nil];
            fsEM.chatType = EMChatTypeChat;
            fsEM.localImage = bImage;
            fsEM.index = this.chatArray.count;
            fsEM.isSending = YES;
            
            NSMutableArray *chatArray = [[NSMutableArray alloc] initWithArray:this.chatArray];
            [chatArray addObject:fsEM];
            dispatch_async(dispatch_get_main_queue(), ^{
                this.chatArray = chatArray;
                [this.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:this.chatArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [this makeNewsVisible];
                
                [[EMClient sharedClient].chatManager asyncSendMessage:fsEM progress:^(int progress) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:FSSEND_PROGRESS object:@(progress)];
                } completion:^(EMMessage *bMmessage, EMError *bError) {
                    if (bError) {
                        FSLog(@"XXXX");
                    }else{
                        if (bMmessage == fsEM) {
                            FSEMMessage *message = (FSEMMessage *)bMmessage;
                            NSInteger index = message.index;
                            if ((this.chatArray.count > index)) {
                                message.isSending = NO;
                                NSMutableArray *replaceArray = [[NSMutableArray alloc] initWithArray:this.chatArray];
                                [replaceArray replaceObjectAtIndex:index withObject:message];
                                this.chatArray = replaceArray;
                                [this.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                            }
                        }
                    }
                }];
            });
        });
    };
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 152) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (this.chatArray.count < this.count) {
            [FuData showMessage:@"没有更多聊天数据"];
            [this.tableView.mj_header endRefreshing];
            return;
        }
        this.count += 5;
        [this msgHandleDatas];
    }];
    [self makeNewsVisible];
}

- (void)clearChatRecord
{
    WEAKSELF(this);
    [FuData alertViewAtController:self title:@"清除聊天记录?" message:@"" cancelTitle:@"取消" handler:nil okTitle:@"确定" handler:^(UIAlertAction *action) {
        [[EMClient sharedClient].chatManager deleteConversation:this.chatToWho deleteMessages:YES];
        [this msgHandleDatas];
    } completion:nil];
}

#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMMessage *message = [self.chatArray objectAtIndex:indexPath.row];
    if ([message isKindOfClass:[FSEMMessage class]]) {
        FSEMMessage *fsEM = (FSEMMessage *)message;
        if (fsEM.isSending) {
            return [self cellWithTableView:tableView message:message type:0];
//            static NSString *identifier = @"sendCell";
//            FSSendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            if (!cell) {
//                cell = [[FSSendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//            }
//            cell.message = (FSEMMessage *)message;
//            return cell;
        }else{
            return [self cellWithTableView:tableView message:message type:1];
        }
    }else{
        return [self cellWithTableView:tableView message:message type:1];
//        static NSString *identifier = @"homeCell";
//        FSChatCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if (!cell) {
//            cell = [[FSChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        }
//        [cell configMessage:message from:_chatToWho];
//        return cell;
    }
}

- (UITableViewCell *)cellWithTableView:(UITableView *)tableView message:(EMMessage *)message type:(NSInteger)type
{
    if (type == 0) {
        static NSString *identifier = @"sendCell";
        FSSendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[FSSendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.message = (FSEMMessage *)message;
        return cell;
    }else{
        static NSString *identifier = @"homeCell";
        FSChatCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[FSChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell configMessage:message from:_chatToWho];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMMessage *message = [self.chatArray objectAtIndex:indexPath.row];
    
    if ([message isKindOfClass:[FSEMMessage class]]) {
        FSEMMessage *fsMessage = (FSEMMessage *)message;
        return fsMessage.localImage.size.height * 100 / fsMessage.localImage.size.width + 50;
    }else{
        EMMessageBodyType type = message.body.type;
        if (type == EMMessageBodyTypeText) {
            EMTextMessageBody *textMessageBody = (EMTextMessageBody *)message.body;
            NSString *text = textMessageBody.text;
            CGFloat height = MAX(40, [FuData textHeight:text fontInt:14 labelWidth:WIDTHFC - 80]);
            return height + 50;
        }else if (type == EMMessageBodyTypeImage){
            EMImageMessageBody *body = ((EMImageMessageBody *)message.body);
            return body.size.height * 100 / body.size.width + 50;
        }
    }
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_canHiddenKeyboard) {
        [self.view endEditing:YES];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _canHiddenKeyboard = YES;
}

- (void)makeNewsVisible
{
    if (self.chatArray.count) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:self.chatArray.count - 1 inSection:0];
        [_tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

// 发送消息:异步方法
- (void)asyncSendMessage:(EMMessage *)aMessage
                progress:(void (^)(int progress))aProgress
              completion:(void (^)(EMMessage *message,
                                   EMError *error))aProgressCompletion
{
    [[EMClient sharedClient].chatManager asyncSendMessage:aMessage progress:aProgress completion:aProgressCompletion];
}

/*!
 @method
 @brief 接收到一条及以上非cmd消息
 */
- (void)didReceiveMessages:(NSArray *)aMessages
{
    for (EMMessage *message in aMessages) {
        EMMessageBody *msgBody = message.body;
        switch (msgBody.type) {
            case EMMessageBodyTypeText:
            {
                EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                NSString *txt = textBody.text;
                NSLog(@"收到的文字是 txt -- %@",txt);
                if (txt) {
                    NSMutableArray *chatArray = [[NSMutableArray alloc] initWithArray:self.chatArray];
                    [chatArray addObject:message];
                    self.chatArray = chatArray;
                    [self.tableView reloadData];
                    [[EMClient sharedClient].chatManager asyncSendReadAckForMessage:message];
                    [self makeNewsVisible];
                }
            }
                break;
            case EMMessageBodyTypeImage:
            {
                NSLog(@"\n收到图片\n");
//                EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
                NSMutableArray *chatArray = [[NSMutableArray alloc] initWithArray:self.chatArray];
                [chatArray addObject:message];
                self.chatArray = chatArray;
                [self.tableView reloadData];
                [[EMClient sharedClient].chatManager asyncSendReadAckForMessage:message];
                [self makeNewsVisible];
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
                NSLog(@"纬度-- %f",body.latitude);
                NSLog(@"经度-- %f",body.longitude);
                NSLog(@"地址-- %@",body.address);
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                // 音频sdk会自动下载
                EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
                NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
                NSLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在（音频会自动调用）
                NSLog(@"音频的secret -- %@"        ,body.secretKey);
                NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"音频文件的下载状态 -- %@"   ,@(body.downloadStatus));
                NSLog(@"音频的时间长度 -- %@"      ,@(body.duration));
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
                
                NSLog(@"视频remote路径 -- %@"      ,body.remotePath);
                NSLog(@"视频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"视频的secret -- %@"        ,body.secretKey);
                NSLog(@"视频文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"视频文件的下载状态 -- %@"   ,@(body.downloadStatus));
                NSLog(@"视频的时间长度 -- %@"      ,@(body.duration));
                NSLog(@"视频的W -- %f ,视频的H -- %f", body.thumbnailSize.width, body.thumbnailSize.height);
                
                // 缩略图sdk会自动下载
                NSLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
                NSLog(@"缩略图的local路径 -- %@"      ,body.thumbnailLocalPath);
                NSLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
                NSLog(@"缩略图的下载状态 -- %@"      ,@(body.thumbnailDownloadStatus));
            }
                break;
            case EMMessageBodyTypeFile:
            {
                EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
                NSLog(@"文件remote路径 -- %@"      ,body.remotePath);
                NSLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"文件的secret -- %@"        ,body.secretKey);
                NSLog(@"文件文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"文件文件的下载状态 -- %@"   ,@(body.downloadStatus));
            }
                break;
            default:
                break;
        }
    }
}

/*!
 @method
 @brief 接收到一条及以上cmd消息
 */
- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages
{
    for (EMMessage *message in aCmdMessages) {
        EMCmdMessageBody *body = (EMCmdMessageBody *)message.body;
        NSLog(@"收到的action是 -- %@",body.action);
    }
}

/*!
 @method
 @brief 接收到一条及以上已送达回执
 */
- (void)didReceiveHasDeliveredAcks:(NSArray *)aMessages
{
    FSLog(@"对方已收到:%@",aMessages);
}

/*!
 *  接收到一条及以上已读回执
 *
 *  @param aMessages  消息列表<EMMessage>
 已读回执需要开发者主动调用的。当用户读取消息后，由开发者主动调用方法
 
 发送已读回执
 // 发送已读回执.在这里写只是为了演示发送，在app中具体在哪里发送需要开发者自己决定。
 [[EMClient sharedClient].chatManager asyncSendReadAckForMessage:message];
 */
- (void)didReceiveHasReadAcks:(NSArray *)aMessages
{
    FSLog(@"");
    for (int x = 0; x < aMessages.count; x ++) {

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
