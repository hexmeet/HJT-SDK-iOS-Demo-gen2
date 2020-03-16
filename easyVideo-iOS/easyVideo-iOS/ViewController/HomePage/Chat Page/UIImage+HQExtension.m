//
//  UIImage+HQExtension.m
//  EasyVideo
//
//  Created by quanhao huang on 2019/11/19.
//  Copyright © 2019 fo. All rights reserved.
//

#import "UIImage+HQExtension.h"

@implementation UIImage (HQExtension)

+ (UIImage *) resizableImageWith:(NSString *) img
{
    UIImage *iconImage = [UIImage imageNamed:img];
    CGFloat w = iconImage.size.width;
    CGFloat h = iconImage.size.height;
    UIImage *newImage = [iconImage resizableImageWithCapInsets:UIEdgeInsetsMake(h * 0.5, w * 0.5, h * 0.5, w * 0.5) resizingMode:UIImageResizingModeStretch];
    return newImage;
}

@end
