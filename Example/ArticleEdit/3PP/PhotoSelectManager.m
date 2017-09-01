//
//  UserphotoSelectView.m
//  WinTour
//
//  Created by Garen on 8/6/16.
//  Copyright © 2016年 huaying. All rights reserved.
//

#import "PhotoSelectManager.h"
//#import "Football-Swift.h"
//#import <CommonLib/CommonLib.h>

#define QNImageQuality  0.9

@interface PhotoSelectManager ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, assign) BOOL allowEdit;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) BOOL needResize;

@end

@implementation PhotoSelectManager

- (instancetype)init {
    if (self = [super init]) {
        self.imageSize = CGSizeMake(600, 600);
    }
    return self;
}

- (void)showInController:(UIViewController *)controller allowEdit:(BOOL)isAllow {
    
    self.superViewController = controller;
//    if ([controller conformsToProtocol: @protocol(SinglePhotoSelectViewDelegate)]) {
//        self.selectImageDelegate = controller;
//    }
    self.allowEdit = isAllow;
	
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) bself = self;
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [bself localPhoto];
    }]];
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [bself takePhoto];
    }]];
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self.superViewController presentViewController:alertCtr animated:YES completion:nil];
}

#pragma mark - 图片选择

- (void)takePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        picker.allowsEditing = self.allowEdit;
        [self.superViewController presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"无法打开相机，请检查手机设置");
    }
}

- (void)localPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = self.allowEdit;
    [self.superViewController presentViewController:picker animated:YES completion:nil];
}


#pragma mark -  UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.superViewController dismissViewControllerAnimated:YES completion:nil];
}

//确定选择
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    //选择编辑后的图片 只有在picker.allowsEditing = YES时，UIImagePickerControllerEditedImage才有图片数据
    UIImage *selectedImage = self.allowEdit ? [info objectForKey:@"UIImagePickerControllerEditedImage"] : [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (selectedImage == nil) {
        NSLog(@"选择照片出错，请重试");
    }
    
    //如果选择的图片size超出指定的图片size，则按照size压缩
    if (self.needResize) {
        if (selectedImage.size.width > self.imageSize.width || selectedImage.size.height > self.imageSize.height) {
            selectedImage = [self.class reSizeImage:selectedImage toSize:self.imageSize];
        }
    }
        
    [self.superViewController dismissViewControllerAnimated:YES completion:^{
        if (selectedImage != nil) {
            if ([self.selectImageDelegate respondsToSelector:@selector(didFinishChoiseImage:fromSelectView:)]) {
				[self.selectImageDelegate didFinishChoiseImage:selectedImage fromSelectView:self];
            }
            if (self.didFinishChoiseImage) {
                self.didFinishChoiseImage(selectedImage);
            }
        }
    }];
}


/**
 *  通过size来压缩图片
 *
 *  @param image  输入图片
 *  @param targetSize 输入size
 *
 *  @return 压缩后的图片
 */
+ (nullable UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = image.size;
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
    
    //	UIGraphicsBeginImageContext(targetSize); // this will crop
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, image.scale);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [image drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil) {
        NSLog(@"could not scale image");
        return image;
    }
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

@end

