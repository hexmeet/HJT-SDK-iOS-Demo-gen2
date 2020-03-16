//
//  HQEditImageCaptureView.h
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/2/19.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQEditImageCaptureView : UIView

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIView *captureView;

@property (nonatomic, assign) NSInteger rotateTimes;


/**
 截取View获取图片

 @return View中的图片
 */
- (UIImage *)captureImage;


/**
 截取框对应原图片

 @return 原图片
 */
- (UIImage *)captureOriginalImage;

@end

NS_ASSUME_NONNULL_END
