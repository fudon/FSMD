//
//  FSHeadPictureController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/7/21.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSHeadPictureController.h"
#import "ClipPictureController.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface FSHeadPictureController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,ClipPictureControllerDelegate>

@end

@implementation FSHeadPictureController
{
    FSWebImageView *_tapImageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hiHandleDatas];
    [self hiDeisignViews];
}

- (void)hiHandleDatas
{
    self.title = @"设置头像";
}

- (void)hiDeisignViews
{
    UIScrollView   *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 64)];
    scrollView.contentSize = CGSizeMake(WIDTHFC, scrollView.height + 1);
    scrollView.backgroundColor = RGBCOLOR(245, 245, 245, 1);
    [self.view addSubview:scrollView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTHFC, 198)];
    [scrollView addSubview:headView];
    
    _tapImageView = [[FSWebImageView alloc] initWithFrame:CGRectMake((WIDTHFC - 120)/2, 40, 120, 120)];
    _tapImageView.contentMode = UIViewContentModeScaleAspectFit;
    [headView addSubview:_tapImageView];
    _tapImageView.block = ^ (FSWebImageView *bImageView,FSWebImageViewAction bActionType){
        if (bActionType == FSWebImageViewActionTap) {
            if (bImageView.image) {
                [FuData showFullScreenImage:bImageView];
            }
        }
    };
    
    NSString *fileName = [FuData documentsPath:@"testdd.jpg"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:fileName];
    if (isExist) {
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:fileName];
        UIImage *keepImage = [[UIImage alloc] initWithData:imageData];
        if (keepImage) {
            _tapImageView.image = keepImage;
        }
    }else{
        _tapImageView.image = IMAGENAMED(@"testdd.jpg");
    }
    
    WEAKSELF(this);
    for (int x = 0; x < 2; x ++) {
        FSTapCell *cell = [[FSTapCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.frame = CGRectMake(0, headView.bottom + 45 * x, WIDTHFC, 44);
        cell.tag = TAGTABLEVIEW + x;
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @[@"从相册中选择",@"拍一张"][x];
        [scrollView addSubview:cell];
        cell.block = ^ (FSTapCell *bCell){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = this;
            if (bCell.tag == TAGTABLEVIEW) {
                
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    //                picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
                    
                }else{
                    [FuData showAlertViewWithTitle:@"此设备没有相册功能"];
                    return;
                }
            }else{
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                }else{
                    [FuData showAlertViewWithTitle:@"您的设备不支持摄像头拍照"];
                    return;
                }
            }
            
            [self presentViewController:picker animated:YES completion:^{
                if (IOS7FC) {
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                }
            }];
        };
    }
}

#pragma mark 相机
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self handlePicture:image fileName:@"abc.jpg"];
    [picker dismissViewControllerAnimated:YES completion:^{
        if (IOS7FC) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        if (IOS7FC) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    }];
}

- (void)handlePicture:(UIImage *)portraitImg fileName:(NSString *)fileName
{
    portraitImg = [self imageByScalingToMaxSize:portraitImg];
    // 裁剪
    ClipPictureController *imgEditorVC = [[ClipPictureController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
    imgEditorVC.delegate = self;
    [self.navigationController pushViewController:imgEditorVC animated:YES];
//    [self presentViewController:imgEditorVC animated:YES completion:^{
//        // TO DO
//    }];
}

- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage
{
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark ClipPictureControllerDelegate
- (void)imageCropper:(ClipPictureController *)cropperViewController didFinished:(UIImage *)editedImage
{
    _tapImageView.image = editedImage;
    [cropperViewController.navigationController popViewControllerAnimated:YES];
//    [cropperViewController dismissViewControllerAnimated:YES completion:^{
//
//    }];
}

- (void)imageCropperDidCancel:(ClipPictureController *)cropperViewController {
    [cropperViewController.navigationController popViewControllerAnimated:YES];
//    [cropperViewController dismissViewControllerAnimated:YES completion:^{
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
