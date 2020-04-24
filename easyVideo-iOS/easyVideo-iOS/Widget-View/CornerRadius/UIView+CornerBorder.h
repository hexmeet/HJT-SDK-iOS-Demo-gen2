//
//  UIView+CornerBorder.h
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS (NSUInteger, CornerBorderType) {
    BorderTypeNone = 0,
    BorderTypeTopLeft     = 1 << 0,
    BorderTypeTopRight    = 1 << 1,
    BorderTypeBottomLeft  = 1 << 2,
    BorderTypeBottomRight = 1 << 3,
    BorderTypeAllCorners  = 1 << 4
};

@interface UIView (CornerBorder)

/**是否启动加边框 defualt NO*/
@property(nonatomic, assign) BOOL openBorder;
/**边框圆角大小 */
@property(nonatomic, assign) CGFloat borderRadius;
/**边框圆角颜色 */
@property(nonatomic, strong) UIColor *borderColor;
/**填充颜色 */
@property(nonatomic, strong) UIColor *borderFillColor;
/**边框宽度 */
@property(nonatomic, assign) CGFloat borderWidth;
/**边框圆角类型 */
@property(nonatomic, assign) CornerBorderType borderType;

/**此分类重写view的layoutsubviews，进行切割圆角
 当视图显示出来后，如果视图frame没有变化或者没有添加子视图等，不触发layoutsubviews方法，
 所以后续再进行的圆角设置会不起作用（复用cell除外，复用时会再次调用layoutsubviews），
 此时为了生效可调用forceClip;
 */
- (void)forceReLayout;

@end

NS_ASSUME_NONNULL_END
