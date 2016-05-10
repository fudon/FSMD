//
//  FSViewManager.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/4/13.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSViewManager.h"
#import "FSMacro.h"

@implementation FSViewManager

+ (UIView *)viewWithFrame:(CGRect)frame backColor:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    if (color) {
        view.backgroundColor = color;
    }
    return view;
}

+ (UIView *)seprateViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = RGBCOLOR(250, 250, 250, 1);
    return view;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)color backColor:(UIColor *)backColor fontInt:(NSInteger)fontInt target:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (color) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    if (backColor) {
        button.backgroundColor = backColor;
    }
    if (target && selector) {
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    if (fontInt) {
        button.titleLabel.font = FONTFC(fontInt);
    }
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    return button;
}

+ (UIBarButtonItem *)barButtonItemWithCustomButton:(UIButton *)button
{
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:button];
    return bbi;
}

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor backColor:(UIColor *)backColor textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if (text) {
        label.text = text;
    }
    if (textColor) {
        label.textColor = textColor;
    }
    if (backColor) {
        label.backgroundColor = backColor;
    }
    label.textAlignment = textAlignment;
    return label;
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)holder textColor:(UIColor *)textColor
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    if (holder) {
        textField.placeholder = holder;
    }
    if (textColor) {
        textField.textColor = textColor;
    }
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    return textField;
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)holder textColor:(UIColor *)textColor onlyChars:(BOOL)only
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    if (holder) {
        textField.placeholder = holder;
    }
    if (textColor) {
        textField.textColor = textColor;
    }
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    if (only) {
        textField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return textField;
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    if (imageName) {
        UIImage *image = IMAGENAMED(imageName);
        if (image) {
            imageView.image = image;
        }
    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
