//
//  UIView+CornerRadius.h
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS (NSUInteger, CornerClipType) {
    CornerClipTypeNone = 0,  //不切
    CornerClipTypeTopLeft     = 1 << 0,
    CornerClipTypeTopRight    = 1 << 1,
    CornerClipTypeBottomLeft  = 1 << 2,
    CornerClipTypeBottomRight = 1 << 3,
    CornerClipTypeAllCorners  = 1 << 4
};

@interface UIView (CornerRadius)

/**tip：开启后后清除圆角使用 clipType = CornerClipTypeNone */
@property(nonatomic, assign) BOOL openClip;
/**圆角大小*/
@property(nonatomic, assign) CGFloat radius;
/**圆角类型*/
@property(nonatomic, assign) CornerClipType clipType;

- (void)forceClip;

@end

NS_ASSUME_NONNULL_END
