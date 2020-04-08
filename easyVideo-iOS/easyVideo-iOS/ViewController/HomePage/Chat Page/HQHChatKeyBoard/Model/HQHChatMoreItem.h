//
//  HQHChatMoreItem.h
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQHChatMoreItem : NSObject

@property (nonatomic, copy) NSString *normalImage;
@property (nonatomic, copy) NSString *highlightedImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger font;

+ (instancetype)initWithNormalImage:(NSString *)normalImage highlightedImage:(nullable NSString *)highlightedImage title:(NSString *)title font:(NSInteger)font;

@end

NS_ASSUME_NONNULL_END
