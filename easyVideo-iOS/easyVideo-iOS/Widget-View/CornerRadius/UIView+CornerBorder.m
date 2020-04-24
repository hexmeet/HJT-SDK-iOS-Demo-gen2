//
//  UIView+CornerBorder.m
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/4/17.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import "UIView+CornerBorder.h"
#import <objc/runtime.h>

@interface UIView ()
// 私有使用
@property(nonatomic, strong) CAShapeLayer *subBorderLayer;
/**边框状态是否变化*/
@property(nonatomic, assign) BOOL borderStatusChange;

@end

@implementation UIView (CornerBorder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class targetClass = [self class];
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(sy_borderlayoutSubviews);
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

- (void)forceReLayout {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)sy_borderlayoutSubviews {
    [self sy_borderlayoutSubviews];
    if (self.openBorder) {
//        if (self.borderStatusChange == NO) return;
        self.borderStatusChange = NO;
        if (self.openBorder == BorderTypeNone) {
            [self.subBorderLayer removeFromSuperlayer];
        } else {
            UIRectCorner rectCorner = [self getRectCornerForBorder];
            if (self.subBorderLayer == nil) {
                self.subBorderLayer = [[CAShapeLayer alloc] init];
            }
            UIBezierPath *maskPath;
            maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width -  self.borderWidth, self.frame.size.height - self.borderWidth) byRoundingCorners:rectCorner cornerRadii:CGSizeMake(self.borderRadius, self.borderRadius)];
            self.subBorderLayer.frame = CGRectMake(self.borderWidth / 2, self.borderWidth / 2,self.frame.size.width - self.borderWidth,self.frame.size.height - self.borderWidth);
            self.subBorderLayer.path = maskPath.CGPath;
            self.subBorderLayer.fillColor = self.borderFillColor.CGColor;
            self.subBorderLayer.strokeColor = self.borderColor.CGColor;
            self.subBorderLayer.lineWidth = self.borderWidth;
            
            if (!self.subBorderLayer.superlayer) {
                [self.layer addSublayer:self.subBorderLayer];
            }
        }
    }
}

- (UIRectCorner)getRectCornerForBorder {
    UIRectCorner rectCorner = 0;
    if (self.borderType & BorderTypeAllCorners) {
        rectCorner = UIRectCornerAllCorners;
    } else {
        if (self.borderType & BorderTypeTopLeft) {
            rectCorner = rectCorner | UIRectCornerTopLeft;
        }
        if (self.borderType & BorderTypeTopRight) {
            rectCorner = rectCorner | UIRectCornerTopRight;
        }
        if (self.borderType & BorderTypeBottomLeft) {
            rectCorner = rectCorner | UIRectCornerBottomLeft;
        }
        if (self.borderType & BorderTypeBottomRight) {
            rectCorner = rectCorner | UIRectCornerBottomRight;
        }
    }
    return rectCorner;
}

#pragma mark - 添加属性
static const char *cornerRadius_openKey_border = "cornerRadius_openKey_border";
- (void)setOpenBorder:(BOOL)openBorder {
    objc_setAssociatedObject(self, cornerRadius_openKey_border, @(openBorder), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)openBorder {
    return [objc_getAssociatedObject(self, cornerRadius_openKey_border) boolValue];
}

static const char *cornerRadius_radiusKey_border = "cornerRadius_radiusKey_border";
- (void)setBorderRadius:(CGFloat)borderRadius {
    if (borderRadius == self.borderRadius) {
    } else {
        self.borderStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadius_radiusKey_border, @(borderRadius), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)borderRadius {
    return [objc_getAssociatedObject(self, cornerRadius_radiusKey_border) floatValue];
}

static const char *cornerRadiusWidth_radiusKey_border = "cornerRadiusWidth_radiusKey_border";
- (void)setBorderWidth:(CGFloat)borderWidth{
    if (borderWidth == self.borderWidth) {
    } else {
        self.borderStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadiusWidth_radiusKey_border, @(borderWidth), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)borderWidth {
    return [objc_getAssociatedObject(self, cornerRadiusWidth_radiusKey_border) floatValue];
}

static const char *cornerRadius_TypeKey_b = "cornerRadius_TypeKey_b";
- (void)setBorderType:(CornerBorderType)borderType {
    if (borderType == self.borderType) {
    } else {
        self.borderStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadius_TypeKey_b, @(borderType), OBJC_ASSOCIATION_RETAIN);
}

- (CornerBorderType)borderType {
    return [objc_getAssociatedObject(self, cornerRadius_TypeKey_b) unsignedIntegerValue];
}

static const char *cornerRadiusColor_LayerKey_border = "cornerRadiusColor_LayerKey_border";
- (void)setBorderColor:(UIColor *)borderColor {
    if ([borderColor isEqual:self.borderColor]) {
    } else {
        self.borderStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadiusColor_LayerKey_border, borderColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)borderColor {
    return objc_getAssociatedObject(self, cornerRadiusColor_LayerKey_border);
}

static const char *cornerRadiusColor_LayerKey_borderfill = "cornerRadius_ColColor";
- (void)setBorderFillColor:(UIColor *)borderfillColor {
    if ([borderfillColor isEqual:self.borderFillColor]) {
    } else {
        self.borderStatusChange = YES;
    }
    objc_setAssociatedObject(self, cornerRadiusColor_LayerKey_borderfill, borderfillColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)borderFillColor {
    return objc_getAssociatedObject(self, cornerRadiusColor_LayerKey_borderfill);
}


static const char *cornerRadius_LayerKey_border = "cornerRadius_LayerKey_border";
- (void)setSubBorderLayer:(CAShapeLayer *)subBorderLayer {
    objc_setAssociatedObject(self, cornerRadius_LayerKey_border, subBorderLayer, OBJC_ASSOCIATION_RETAIN);
}

- (CAShapeLayer *)subBorderLayer {
    return objc_getAssociatedObject(self, cornerRadius_LayerKey_border);
}

static const char *cornerRadius_StatusKey_border = "cornerRadius_StatusKey_border";
- (void)setBorderStatusChange:(BOOL)borderStatusChange {
    objc_setAssociatedObject(self, cornerRadius_StatusKey_border, @(borderStatusChange), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)borderStatusChange {
    return [objc_getAssociatedObject(self, cornerRadius_StatusKey_border) boolValue];
}

@end
