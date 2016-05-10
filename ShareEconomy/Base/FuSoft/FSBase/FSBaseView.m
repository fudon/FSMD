//
//  FSBaseView.m
//  ShareEconomy
//
//  Created by fudon on 16/5/4.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSBaseView.h"

@implementation FSBaseView

- (FSBaseController *)viewController;
{
    UIResponder *next = self.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass:[FSBaseController class]]) {
            __weak FSBaseController *vc = (FSBaseController *)next;   // 会使ViewController释放
            return vc;
        }
        next = next.nextResponder;
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
