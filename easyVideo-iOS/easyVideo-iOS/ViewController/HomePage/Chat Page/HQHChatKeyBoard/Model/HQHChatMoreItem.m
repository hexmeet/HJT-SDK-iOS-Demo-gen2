//
//  HQHChatMoreItem.m
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import "HQHChatMoreItem.h"

@implementation HQHChatMoreItem

+ (instancetype)initWithNormalImage:(NSString *)normalImage highlightedImage:(nullable NSString *)highlightedImage title:(NSString *)title font:(NSInteger)font {
    
    HQHChatMoreItem *item = [HQHChatMoreItem new];
    item.normalImage = normalImage;
    item.highlightedImage = highlightedImage;
    item.title = title;
    item.font = font;
    
    return item;
}

@end
