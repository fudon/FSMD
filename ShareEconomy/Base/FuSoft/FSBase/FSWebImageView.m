//
//  FSWebImageView.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/5/8.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSWebImageView.h"
#import "FuSoft.h"
#import "UIImageView+WebCache.h"

@interface FSWebImageView ()

@property (nonatomic,strong) UIButton   *deleteButton;

@end

@implementation FSWebImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self tapImageViewDesignViews];
    }
    return self;
}

- (void)tapImageViewDesignViews
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction)];
    [self addGestureRecognizer:tap];
}

- (void)imageTapAction
{
    if (_block) {
        _block(self,GZSWebImageViewActionTap);
    }
}

- (void)setImageWithUrl:(NSString *)url placeholderImageName:(NSString *)name;
{
    [self setImageWithURL:[NSURL URLWithString:url] placeholderImage:IMAGENAMED(name)];

//    NSString *fileName = [FuData md5:url];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData *imageData = [[NSData alloc] initWithContentsOfFile:[FuData temporaryDirectoryFile:fileName]];
//        if (imageData) {
//            UIImage *image = [[UIImage alloc] initWithData:imageData];
//            if (image) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.image = image;
//                    return;
//                });
//            }
//        }
//    });
//    
//    if (name.length != 0) {
//        UIImage *placeImage = [UIImage imageNamed:name];
//        if (placeImage) {
//            self.image = placeImage;
//        }
//    }
//    
//    WEAKSELF(this);
//    [FuWeb pictureUrl:url successBlock:^(id dic) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSString *filePath = [FuData temporaryDirectoryFile:fileName];
//            if ([dic isKindOfClass:[NSData class]]) {
//                NSData *data = dic;
//                UIImage *image = [UIImage imageWithData:data];
//                if (image) {
//                    BOOL success = [data writeToFile:filePath atomically:YES];
//                    if (success) {
//                    }
//                    [this configImageAction:[[UIImage alloc] initWithData:dic]];
//                }
//            }
//        });
//        
//    } failBlock:^(NSString *msg) {
//        NSLog(@"PIC-ERROR");
//    }];
}

//- (void)configImageAction:(UIImage *)image
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.image = image;
//    });
//}

- (void)setShowButton:(BOOL)showButton       //此方法必须在superView已经有frame时调用
{
    _showButton = showButton;
    if (showButton) {
        if (_deleteButton) {
            _deleteButton.hidden = NO;
        }else{
            _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _deleteButton.frame = CGRectMake(self.width - 27, 2, 25, 25);
            [_deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
            _deleteButton.layer.cornerRadius = _deleteButton.width / 2;
            _deleteButton.layer.borderColor = [UIColor whiteColor].CGColor;
            _deleteButton.layer.borderWidth = 1.5;
            _deleteButton.backgroundColor = [UIColor blackColor];
            _deleteButton.alpha = .5;
            [_deleteButton setTitle:@"X" forState:UIControlStateNormal];
            _deleteButton.titleLabel.font = FONTFC(12);
            [self addSubview:_deleteButton];
        }
    }else{
        _deleteButton.hidden = YES;
    }
}

- (void)deleteAction
{
    if (_block) {
        _block(self,GZSWebImageViewActionDelete);
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
