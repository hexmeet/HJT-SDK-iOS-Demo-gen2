//
//  RippleAnimationView.h
//  EasyVideo
//
//  Created by quanhao huang on 2018/7/16.
//  Copyright © 2018年 fo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ColorWithAlpha(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
typedef NS_ENUM(NSInteger, AnimationType) {
    AnimationTypeWithBackground,
    AnimationTypeWithoutBackground
};

@interface RippleAnimationView : UIView

/**
 设置扩散倍数。默认1.423倍
 */
@property (nonatomic, assign) CGFloat multiple;

- (instancetype)initWithFrame:(CGRect)frame animationType:(AnimationType)animationType;

@end
