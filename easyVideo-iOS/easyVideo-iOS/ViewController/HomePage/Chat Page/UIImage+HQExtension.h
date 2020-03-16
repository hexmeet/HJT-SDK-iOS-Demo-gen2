//
//  UIImage+HQExtension.h
//  EasyVideo
//
//  Created by quanhao huang on 2019/11/19.
//  Copyright © 2019 fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HQExtension)


/**
 传入图片返回可拉伸图片
 */
+ (UIImage *) resizableImageWith:(NSString *) img;

@end
