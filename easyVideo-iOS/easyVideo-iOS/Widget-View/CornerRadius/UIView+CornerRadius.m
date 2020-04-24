//
//  UIView+CornerRadius.m
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import "UIView+CornerRadius.h"
#import <objc/runtime.h>

@interface UIView ()
// 私有使用
@property(nonatomic, strong) CAShapeLayer *maskLayer;
/**圆角状态是否变化*/
@property(nonatomic, assign) BOOL radiusStatusChange;
@end

@implementation UIView (CornerRadius)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class targetClass = [self class];
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(sy_layoutSubviews);
        [self swizzleMethod:targetClass orgSel:originalSelector swizzSel:swizzledSelector];
    });
}

+ (void)swizzleMethod:(Class)class orgSel:(SEL)originalSelector swizzSel:(SEL)swizzledSelector {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    IMP swizzledImp = method_getImplementation(swizzledMethod);
    char *swizzledTypes = (char *)method_getTypeEncoding(swizzledMethod);
    
    IMP originalImp = method_getImplementation(originalMethod);
    char *originalTypes = (char *)method_getTypeEncoding(originalMethod);
    
    BOOL success = class_addMethod(class, originalSelector, swizzledImp, swizzledTypes);
    if (success) {
        class_replaceMethod(class, swizzledSelector, originalImp, originalTypes);
    }else {
        // 添加失败，表明已经有这个方法，直接交换
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


- (void)forceClip {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)sy_layoutSubviews {
    [self sy_layoutSubviews];
    if (self.openClip) {
//        if (self.radiusStatusChange == NO) return;
        self.radiusStatusChange = NO;
        if (self.clipType == CornerClipTypeNone) {
            self.layer.mask = nil;
        } else {
            UIRectCorner rectCorner = [self getRectCorner];
            if (self.maskLayer == nil) {
                self.maskLayer = [[CAShapeLayer alloc] init];
            }
            
            UIBezierPath *maskPath;
            maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(self.radius, self.radius)];
            self.maskLayer.frame = self.bounds;
            self.maskLayer.path = maskPath.CGPath;
            self.layer.mask = self.maskLayer;
        }
    }
}

- (UIRectCorner)getRectCorner {
    UIRectCorner rectCorner = 0;
    if (self.clipType & CornerClipTypeAllCorners) {
        rectCorner = UIRectCornerAllCorners;
    } else {
        if (self.clipType & CornerClipTypeTopLeft) {
            rectCorner = rectCorner | UIRectCornerTopLeft;
        }
        if (self.clipType & CornerClipTypeTopRight) {
            rectCorner = rectCorner | UIRectCornerTopRight;
        }
        if (self.clipType & CornerClipTypeBottomLeft) {
            rectCorner = rectCorner | UIRectCornerBottomLeft;
        }
        if (self.clipType & CornerClipTypeBottomRight) {
            rectCorner = rectCorner | UIRectCornerBottomRight;
        }
    }
    return rectCorner;
}

#pragma mark - 添加属性
static const char *cornerRadius_openKey = "cornerRadius_openKey";
- (void)setOpenClip:(BOOL)openClip {
    objc_setAssociatedObject(self, cornerRadius_openKey, @(openClip), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)openClip {
    return [objc_getAssociatedObject(self, cornerRadius_openKey) boolValue];
}

static const char *cornerRadius_radiusKey = "CornerRadius_radius";
- (void)setRadius:(CGFloat)radius {
    if (radius == self.radius) {
    } else {
        self.radiusStatusChange = YES;
    }
     objc_setAssociatedObject(self, cornerRadius_radiusKey, @(radius), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)radius {
      return [objc_getAssociatedObject(self, cornerRadius_radiusKey) floatValue];
}

static const char *cornerRadius_TypeKey = "cornerRadius_TypeKey";
- (void)setClipType:(CornerClipType)clipType {
    if (clipType == self.clipType) {
    } else {
        self.radiusStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadius_TypeKey, @(clipType), OBJC_ASSOCIATION_RETAIN);
}

- (CornerClipType)clipType {
    return [objc_getAssociatedObject(self, cornerRadius_TypeKey) unsignedIntegerValue];
}

static const char *cornerRadius_maskLayerKey = "cornerRadius_maskLayerKey";
- (void)setMaskLayer:(CAShapeLayer *)maskLayer {
    objc_setAssociatedObject(self, cornerRadius_maskLayerKey, maskLayer, OBJC_ASSOCIATION_RETAIN);
}

- (CAShapeLayer *)maskLayer {
    return objc_getAssociatedObject(self, cornerRadius_maskLayerKey);
}

static const char *cornerRadius_StatusKey = "cornerRadius_StatusKey";
- (void)setRadiusStatusChange:(BOOL)radiusStatusChange {
    objc_setAssociatedObject(self, cornerRadius_StatusKey, @(radiusStatusChange), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)radiusStatusChange {
    return [objc_getAssociatedObject(self, cornerRadius_StatusKey) boolValue];
}

@end
