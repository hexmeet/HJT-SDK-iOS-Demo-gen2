//
//  NSString+HQHKeyBoard.h
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HQHKeyBoard)

//判断字符串的尾部是否是emoji表情
+ (BOOL)stringFromTrailIsEmoji:(NSString *)string;

//判断字符串里面是否包含emoji表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

//删除[微笑]类的标签，判断是否为系统删除按钮
+ (void)deleteEmtionString:(UITextView *)textView isSystem:(BOOL)isSystem;

//将文字里面的包含的[微笑]类表情转换成attributedString返回
+ (NSMutableAttributedString *)emotionImgsWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
