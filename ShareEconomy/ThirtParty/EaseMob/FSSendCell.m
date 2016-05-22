//
//  FSSendCell.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/5/14.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSSendCell.h"
#import "FuSoft.h"
#import "FSViewManager.h"

@interface FSSendCell ()

@property (nonatomic,strong) UILabel            *timeLabel;
@property (nonatomic,strong) UIImageView        *headImageView;

@end

@implementation FSSendCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self sendCellDesignViews];
    }
    return self;
}

- (void)sendCellDesignViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleProgressAction:) name:FSSEND_PROGRESS object:nil];
    
    _headImageView = [FSViewManager imageViewWithFrame:CGRectMake(WIDTHFC - 60, 15, 50, 50) imageName:@"testdd.jpg"];
    [self addSubview:_headImageView];

    _timeLabel = [FSViewManager labelWithFrame:CGRectMake(WIDTHFC / 2 - 50, 10, 100, 20) text:@"" textColor:[UIColor grayColor] backColor:nil textAlignment:NSTextAlignmentCenter];
    _timeLabel.font = FONTFC(12);
    [self addSubview:_timeLabel];
    
    _sendImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:_sendImageView];
    
    _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _progressLabel.backgroundColor = [UIColor grayColor];
    _progressLabel.alpha = .6;
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    _progressLabel.textColor = [UIColor whiteColor];
    [self addSubview:_progressLabel];
}

- (void)setMessage:(FSEMMessage *)message
{
    if (_message != message) {
        _message = message;
        
        NSTimeInterval timeInterval = message.timestamp / 1000;
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval];
        NSDateComponents *components = [FuData yearMonthDayFromDate:date];
        _timeLabel.text = [self monthDayStringByNumber:components];

        _sendImageView.image = _message.localImage;
        _sendImageView.frame = CGRectMake(WIDTHFC - 170, 40, 100, _message.localImage.size.height * 100 / _message.localImage.size.width);
        _progressLabel.frame = _sendImageView.frame;
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

- (void)handleProgressAction:(NSNotification *)notification
{
    NSString *progress = [notification.object stringValue];
    _progressLabel.text = progress;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
