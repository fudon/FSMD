//
//  FSZoneHeadView.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/7/20.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSZoneHeadView.h"
#import "FSTapCell.h"

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
    
    WEAKSELF(this);
    FSTapCell *cell = [FSViewManager tapCellWithText:nil textColor:nil detailColor:nil font:nil detailFont:nil block:^(FSTapCell *bCell) {
        if (this.block) {
            this.block(this,0);
        }
    }];
    cell.frame = CGRectMake(0, 0, self.width, 88);
    [self addSubview:cell];
    
    UIImageView *headImageView = [FSViewManager imageViewWithFrame:CGRectMake(20, 19, 50, 50) imageName:@"testdd.jpg"];
    [self addSubview:headImageView];
    
    UIView *lineView = [FSViewManager seprateViewWithFrame:CGRectMake(0, cell.bottom - FS_LineThickness, WIDTHFC, FS_LineThickness)];
    [self addSubview:lineView];
    
    UIView *lineViewV = [FSViewManager seprateViewWithFrame:CGRectMake(self.width / 2, lineView.bottom + 2, FS_LineThickness, 40)];
    [self addSubview:lineViewV];
    
    NSArray *txtArray = @[@"我帮的人",@"帮我的人"];
    NSArray *picArray = @[@"ddxx",@"xfjl"];
    for (int x = 0; x < 2; x ++) {
        UIButton *button = [FSViewManager buttonWithFrame:CGRectMake(x * WIDTHFC / 2, 88, WIDTHFC / 2, 44) title:txtArray[x] titleColor:[UIColor grayColor] backColor:nil fontInt:14 tag:TAGBUTTON + x + 1 target:self selector:@selector(buttonActionInfo:)];
        [self addSubview:button];
        
        UIImageView *picImageView = [FSViewManager imageViewWithFrame:CGRectMake(20, 10, 24, 24) imageName:picArray[x]];
        [button addSubview:picImageView];
    }
    
    UILabel *nameLabel = [FSViewManager labelWithFrame:CGRectMake(headImageView.right + 10, headImageView.top, WIDTHFC / 2 - 20, headImageView.height / 2) text:@"fudon" textColor:nil backColor:nil font:nil textAlignment:NSTextAlignmentLeft];
    [self addSubview:nameLabel];
    
    UILabel *numberLabel = [FSViewManager labelWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, nameLabel.width, nameLabel.height) text:@"18810790738" textColor:[UIColor grayColor] backColor:nil font:FONTFC(14) textAlignment:NSTextAlignmentLeft];
    [self addSubview:numberLabel];
}

- (void)buttonActionInfo:(UIButton *)button
{
    if (_block) {
        _block(self,button.tag - TAGBUTTON);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
