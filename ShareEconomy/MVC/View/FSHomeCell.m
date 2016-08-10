//
//  FSHomeCell.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/14.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSHomeCell.h"
#import "FSMacro.h"
#import "FSViewManager.h"

#define  UserDefaultsKey_UserPwd        @"USERPWD_EASEMOB"      // 用户名、密码

@implementation FSHomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self chatCellDesignViews];
    }
    return self;
}

- (void)chatCellDesignViews
{
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    [self addSubview:_headImageView];
    
    _nameLabel = [FSViewManager labelWithFrame:CGRectMake(_headImageView.right + 10, 5, WIDTHFC - 100, 30) text:@"" textColor:nil backColor:nil font:nil textAlignment:NSTextAlignmentLeft];
    [self addSubview:_nameLabel];
    
    _messageLabel = [FSViewManager labelWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, _nameLabel.width, 20) text:@"" textColor:[UIColor grayColor] backColor:nil font:nil textAlignment:NSTextAlignmentLeft];
    _messageLabel.font = FONTFC(12);
    [self addSubview:_messageLabel];
    
    _timeLabel = [FSViewManager labelWithFrame:CGRectMake(WIDTHFC - 40, 5, 40, 20) text:@"" textColor:[UIColor grayColor] backColor:nil font:nil textAlignment:NSTextAlignmentLeft];
    _timeLabel.font = FONTFC(12);
    [self addSubview:_timeLabel];
    
    _numberLabel = [FSViewManager labelWithFrame:CGRectMake(WIDTHFC - 40, _timeLabel.bottom + 5, 20, 20) text:@"" textColor:[UIColor whiteColor] backColor:FS_RedColor font:nil textAlignment:NSTextAlignmentCenter];
    _numberLabel.layer.cornerRadius = _numberLabel.width / 2;
    _numberLabel.layer.masksToBounds = YES;
    _numberLabel.font = FONTFC(12);
    [self addSubview:_numberLabel];
}

- (void)setConversation:(EMConversation *)conversation
{
    if (_conversation != conversation) {
        _conversation = conversation;
        
        _headImageView.image = ROUNDIMAGE(@"testdd.jpg", 0);
        
        NSArray *userPwds = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsKey_UserPwd];

        EMMessage *message = conversation.latestMessage;
        _nameLabel.text = conversation.conversationId;
        
        EMMessageBodyType type = message.body.type;
        if (type == EMMessageBodyTypeText) {
            EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
            _messageLabel.text = textBody.text;
        }else if (type == EMMessageBodyTypeImage){
            _messageLabel.text = @"[图片信息]";
        }
        
        NSTimeInterval timeInterval = message.timestamp;
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        if (now - timeInterval > 24 * 3600) {
            _timeLabel.text = @"以前";
        }else{
            _timeLabel.text = @"今天";
        }
        
        int count = conversation.unreadMessagesCount;
        _numberLabel.hidden = count?NO:YES;
        if (count) {
            _numberLabel.text = @(conversation.unreadMessagesCount).stringValue;
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
