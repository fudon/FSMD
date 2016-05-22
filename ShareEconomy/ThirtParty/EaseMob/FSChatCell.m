//
//  FSChatCell.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/5/7.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSChatCell.h"
#import "FSMacro.h"
#import "FSViewManager.h"
#import "FSEMMessage.h"

@implementation FSChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self chatDesignViews];
    }
    return self;
}

- (void)chatDesignViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _headImageView = [FSViewManager imageViewWithFrame:CGRectMake(10, 15, 50, 50) imageName:@"testdd.jpg"];
    [self addSubview:_headImageView];
    
    _timeLabel = [FSViewManager labelWithFrame:CGRectMake(WIDTHFC / 2 - 50, 10, 100, 20) text:@"" textColor:[UIColor grayColor] backColor:nil textAlignment:NSTextAlignmentCenter];
    _timeLabel.font = FONTFC(12);
    [self addSubview:_timeLabel];
    
    _contentLabel = [FSViewManager labelWithFrame:CGRectMake(_headImageView.right + 10, 30, WIDTHFC - 80, 40) text:@"" textColor:nil backColor:nil textAlignment:NSTextAlignmentLeft];
    _contentLabel.font = FONTFC(14);
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
    
    _pictureImageView = [[FSWebImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _pictureImageView.block = ^ (FSWebImageView *bImageView,FSWebImageViewAction actionType){
        if (bImageView.image) {
            [FuData showFullScreenImage:bImageView];
        }
    };
    [self addSubview:_pictureImageView];
}

- (void)configMessage:(EMMessage *)message from:(NSString *)from
{
    BOOL isLeft = YES;
    if ([from isEqualToString:message.from]) {
        _headImageView.left = 10;
    }else{
        isLeft = NO;
        _headImageView.left = WIDTHFC - 60;
    }
    NSTimeInterval timeInterval = message.timestamp / 1000;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval];
    NSDateComponents *components = [FuData yearMonthDayFromDate:date];
    _timeLabel.text = [self monthDayStringByNumber:components];
    
    EMMessageBodyType type = message.body.type;
    if (type == EMMessageBodyTypeText) {
        if (isLeft) {
            _contentLabel.left = _headImageView.right + 10;
            _contentLabel.textAlignment = NSTextAlignmentLeft;
        }else{
            _contentLabel.left = 10;
            _contentLabel.textAlignment = NSTextAlignmentRight;
        }
        self.pictureImageView.hidden = YES;
        self.contentLabel.hidden = NO;
        
        EMTextMessageBody *textMessageBody = (EMTextMessageBody *)message.body;
        NSString *text = textMessageBody.text;
        if (text) {
            CGFloat height = [FuData textHeight:text fontInt:14 labelWidth:WIDTHFC - 80];
            _contentLabel.height = MAX(40, height);
            _contentLabel.text = text;
        }
    }else if (type == EMMessageBodyTypeImage){
        self.contentLabel.hidden = YES;
        self.pictureImageView.hidden = NO;
        
        EMImageMessageBody *body = ((EMImageMessageBody *)message.body);
        [self.pictureImageView setImageWithUrl:body.remotePath placeholderImageName:body.thumbnailRemotePath];
        self.pictureImageView.frame = CGRectMake(isLeft?(70):(WIDTHFC - 170), 40, 100, body.size.height * 100 / body.size.width);
    }
}

- (NSString *)monthDayStringByNumber:(NSDateComponents *)comp
{
    NSString *month = nil;
    if (comp.month < 10) {
        month = [[NSString alloc] initWithFormat:@"0%@",@(comp.month)];
    }else{
        month = [[NSString alloc] initWithFormat:@"%@",@(comp.month)];
    }
    
    NSString *day = nil;
    if (comp.day < 10) {
        day = [[NSString alloc] initWithFormat:@"0%@",@(comp.day)];
    }else{
        day = [[NSString alloc] initWithFormat:@"%@",@(comp.day)];
    }
    return [[NSString alloc] initWithFormat:@"%@-%@ %@:%@",month,day,@(comp.hour),@(comp.minute)];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
