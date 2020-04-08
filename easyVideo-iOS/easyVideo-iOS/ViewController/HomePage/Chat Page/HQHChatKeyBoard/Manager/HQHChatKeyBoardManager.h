//
//  HQHChatKeyBoardManager.h
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HQHEmojiModel.h"
#import "HQHChatMoreItem.h"
#import "HQHChatKeyBoardView.h"

NS_ASSUME_NONNULL_BEGIN

@class HQHEmojiModel;

@interface HQHChatKeyBoardManager : NSObject

@property (nonatomic, strong, readonly) NSArray<HQHGroupEmojiModel *> *groupEmojis;
@property (nonatomic, strong, readonly) NSArray<HQHChatMoreItem *> *moreItems;

//单例对象
+ (instancetype)sharedManager;

//销毁单例对象
- (void)tearDown;

//配置表情
- (void)configEmojisData:(NSArray<HQHGroupEmojiModel *> *)emojis;

//配置更多
- (void)configMoreItems:(NSArray<HQHChatMoreItem *> *)moreItems;

@end

NS_ASSUME_NONNULL_END
