//
//  FSViewManager.h
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FS_LineThickness        0.8

@interface FSViewManager : UIView

+ (UIView *)viewWithFrame:(CGRect)frame backColor:(UIColor *)color;

+ (UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;

+ (UIView *)seprateViewWithFrame:(CGRect)frame;

+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title
                   titleColor:(UIColor *)color
                    backColor:(UIColor *)backColor
                      fontInt:(NSInteger)fontInt
                       target:(id)target
                     selector:(SEL)selector;

+ (UIBarButtonItem *)barButtonItemWithCustomButton:(UIButton *)button;

+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
                  backColor:(UIColor *)backColor
              textAlignment:(NSTextAlignment)textAlignment;

+ (UITextField *)textFieldWithFrame:(CGRect)frame
                        placeholder:(NSString *)holder
                          textColor:(UIColor *)textColor;

+ (UITextField *)textFieldWithFrame:(CGRect)frame
                        placeholder:(NSString *)holder
                          textColor:(UIColor *)textColor
                          onlyChars:(BOOL)only;

@end
