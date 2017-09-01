//
//  UserphotoSelectView.h
//  WinTour
//
//  Created by Garen on 8/6/16.
//  Copyright © 2016年 huaying. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QiniuImageUploadType) {
	defaultToken = 1,
	chatToken = 2
};

@class PhotoSelectManager;
@protocol SinglePhotoSelectViewDelegate <NSObject>

@optional
- (void)didFinishChoiseImage:(UIImage *_Nonnull)image fromSelectView:(PhotoSelectManager *  _Nonnull) manager;

@end

@interface PhotoSelectManager : UITableView

@property (nonatomic, weak, nullable) UIViewController *superViewController;
@property (nonatomic, weak, nullable) id<SinglePhotoSelectViewDelegate>selectImageDelegate;

@property (nonatomic, copy, nullable) void (^didFinishChoiseImage)(UIImage * _Nonnull);

- (void)showInController:(UIViewController * _Nullable)controller allowEdit:(BOOL)isAllow;

- (void)takePhoto;
+ (nullable UIImage *)reSizeImage:(UIImage * _Nonnull)image toSize:(CGSize)targetSize;
@end
