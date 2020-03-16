//
//  NSString+HQExtension.h
//  EasyVideo
//
//  Created by quanhao huang on 2019/11/19.
//  Copyright © 2019 fo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (HQExtension)


/**
 返回文本高度

 @param font 字体及大小
 @param maxSize 最大宽度
 @return cgsize
 */
-(CGSize) sizeWithFont:(UIFont *) font maxSize:(CGSize) maxSize;

@end
