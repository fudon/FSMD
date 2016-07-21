//
//  FSChatView.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/5/7.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSChatView.h"
#import "FSMacro.h"
#import "HPGrowingTextView.h"

@interface FSChatView()<HPGrowingTextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,assign) BOOL                   otherButtonsClick;
@property (nonatomic,strong) HPGrowingTextView      *textView;

@end

@implementation FSChatView

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self chatDesignViews];
    }
    return self;
}

- (void)chatDesignViews
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardReactionInBaseController:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardReactionInBaseController:) name:UIKeyboardWillHideNotification object:nil];
    
    _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 6.5, WIDTHFC - 20, 31)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.layer.cornerRadius = 5;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.delegate = self;
    [self addSubview:_textView];
    
    NSArray *pictureNames = @[@"ade",@"afl",@"ade",@"ade"];
    for (int x = 0; x < 4; x ++) {
        UIButton *button = [FSViewManager buttonWithFrame:CGRectMake(WIDTHFC / 4 * x, 49, WIDTHFC / 4, 30) title:nil titleColor:nil backColor:nil fontInt:0 tag:TAGBUTTON + x target:self selector:@selector(btnClickInChatView:)];
        [self addSubview:button];
        
        UIImageView *imageView = [FSViewManager imageViewWithFrame:CGRectMake(WIDTHFC / 8 - 15, 0, 30, 30) imageName:pictureNames[x]];
        [button addSubview:imageView];
    }
    
    _otherView = [[UIView alloc] initWithFrame:CGRectMake(0, 89, WIDTHFC, self.height - 89)];
    _otherView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_otherView];
}

- (void)btnClickInChatView:(UIButton *)button
{
    [_textView resignFirstResponder];

    if (button.tag == (TAGBUTTON + 1)) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册选择", nil];
        [actionSheet showInView:self.viewController.view];
    }else{
        _otherButtonsClick = YES;
        [self.viewController showTitle:@"正在开发中，敬请期待!"];
    }
}

- (void)keyboardReactionInBaseController:(NSNotification *)notification
{
    UIViewController *viewController = self.viewController;
    
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat transformY = keyboardFrame.origin.y - viewController.view.frame.size.height;
    self.otherView.height = keyboardFrame.size.height;
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        _otherButtonsClick = NO;
        [UIView animateWithDuration:duration animations:^{
            viewController.view.transform = CGAffineTransformMakeTranslation(0, transformY);
        }];
    }else if ([notification.name isEqualToString:UIKeyboardWillHideNotification]){
        if (!_otherButtonsClick) {
            [UIView animateWithDuration:duration animations:^{
                viewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            }];
        }
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    return YES;
}

- (BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView
{
    return YES;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float delta = height - 31;
    self.height = FSChatViewHeight + delta;
    self.top = HEIGHTFC - 88 -  delta;
    for (int x = 0; x < 4; x ++) {
        UIButton *button = (UIButton *)[self viewWithTag:TAGBUTTON + x];
        button.top = 49 + delta;
    }
    _otherView.top = 89 + delta;
    if (_changeHeightBlock) {
        _changeHeightBlock(self,delta);
    }
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    if (self.sendBlock) {
        _sendBlock(growingTextView.text);
        growingTextView.text = @"";
    }
    return YES;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else {
            [self.viewController showTitle:@"无摄像头"];
            return;
        }
    }else if (buttonIndex == 1){
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self.viewController presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    WEAKSELF(this);
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    if (this.selectImageBlock) {
        UIImage *handledImage = [FuData imageCompressForWidth:image targetWidth:WIDTHFC];
        this.selectImageBlock(this,handledImage);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
