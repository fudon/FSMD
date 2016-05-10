//
//  FSHomeCell.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/14.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSHomeCell.h"
#import "FuSoft.h"
#import "FSViewManager.h"

@implementation FSHomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self homeCellDesignViews];
    }
    return self;
}

- (void)homeCellDesignViews
{
    UILabel *moneyLabel = [FSViewManager labelWithFrame:CGRectMake(10, 40, 90, 40) text:@"1000" textColor:[UIColor redColor] backColor:nil textAlignment:NSTextAlignmentLeft];
    moneyLabel.font = FONTFC(20);
    [moneyLabel sizeToFit];
    [self addSubview:moneyLabel];
    
    UILabel *eventLabel = [FSViewManager labelWithFrame:CGRectMake(10, 0, WIDTHFC - 10, 40) text:@"帮我送一件东西到中关村地铁站" textColor:nil backColor:nil textAlignment:NSTextAlignmentLeft];
    [self addSubview:eventLabel];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
