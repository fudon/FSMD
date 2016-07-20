//
//  FSZoneHeadView.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/7/20.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSZoneHeadView.h"

@implementation FSZoneHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self zoneHeadDesignViews];
    }
    return self;
}

- (void)zoneHeadDesignViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.frame = CGRectMake(0, 0, self.width, 88);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self addSubview:cell];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 19, 50, 50)];
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    headImageView.image = IMAGENAMED(@"testdd.jpg");

    [self addSubview:headImageView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bottom - FS_LineThickness, WIDTHFC, FS_LineThickness)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
    
    UIView *lineViewV = [[UIView alloc] initWithFrame:CGRectMake(self.width / 2, lineView.bottom + 2, FS_LineThickness, 40)];
    lineViewV.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineViewV];
    
    NSArray *txtArray = @[@"我帮的人",@"帮我的人"];
    NSArray *picArray = @[@"ddxx",@"xfjl"];
    for (int x = 0; x < 2; x ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x * WIDTHFC / 2, 88, WIDTHFC / 2, 44);
        [button setTitle:txtArray[x] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font = FONTFC(14);
        button.tag = TAGBUTTON + x;
        [button addTarget:self action:@selector(buttonActionInfo:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIImageView *picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 24, 24)];
        picImageView.contentMode = UIViewContentModeScaleAspectFit;
        picImageView.image = IMAGENAMED(picArray[x]);
        [button addSubview:picImageView];
    }
    
    UILabel *_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.right + 10, headImageView.top, WIDTHFC / 2 - 20, headImageView.height / 2)];
    _nameLabel.text = @"fudon";
    [self addSubview:_nameLabel];
    
    UILabel *_numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, _nameLabel.width, _nameLabel.height)];
    _numberLabel.font = FONTFC(14);
    _numberLabel.text = @"18810790738";
    _numberLabel.textColor = [UIColor grayColor];
    [self addSubview:_numberLabel];
}

- (void)buttonActionInfo:(UIButton *)button
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
