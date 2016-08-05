//
//  FSBlockButton.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/8/5.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSBlockButton.h"

@implementation FSBlockButton

- (void)setFrame:(CGRect)frame
{
    super.frame = frame;
    [self addTarget:self action:@selector(blockAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)blockAction
{
    if (_block) {
        _block(self);
    }
}

@end
