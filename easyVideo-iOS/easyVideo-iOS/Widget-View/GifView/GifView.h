//
//  GifView.h
//  EasyVideo
//
//  Created by quanhao huang on 2018/7/7.
//  Copyright © 2018年 fo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>

@interface GifView : UIView

{
    CGImageSourceRef gif;
    NSDictionary *gifProperties;
    size_t index;
    size_t count;
    NSTimer *timer;
}

- (id)initWithFrame:(CGRect)frame filePath:(NSString *)_filePath;
- (id)initWithFrame:(CGRect)frame data:(NSData *)_data;
- (void)loadImagefilePath:(NSString *)_filePath;

@end
