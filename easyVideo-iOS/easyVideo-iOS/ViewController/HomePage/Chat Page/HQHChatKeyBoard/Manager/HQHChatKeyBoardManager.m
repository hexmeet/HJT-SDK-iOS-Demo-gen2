//
//  HQHChatKeyBoardManager.m
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import "HQHChatKeyBoardManager.h"
#import "HQHKeyBoardDefine.h"

@implementation HQHChatKeyBoardManager

static HQHChatKeyBoardManager *_manager = nil;
static dispatch_once_t onceToken;

- (instancetype)init {
    if (self = [super init]) {
        [self confgiChatKeyBoardData];
    }
    return self;
}

+ (instancetype)sharedManager {
    
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            _manager = [[self alloc] init];
        }
    });
    return _manager;
}

- (void)tearDown {
    
    _manager = nil;
    
    onceToken = 0l;
}

//设置默认的表情包及更多功能
- (void)confgiChatKeyBoardData {
    
    HQHGroupEmojiModel *group1 = [HQHGroupEmojiModel initEmojiWithPlist:@"chatEmojis.plist" image:@"icon_emoji_group1"];
//    HQHGroupEmojiModel *group2 = [HQHGroupEmojiModel initFaceWithFileName:@"panda" count:10 image:@"icon_emoji_group2"];
//    HQHGroupEmojiModel *group3 = [HQHGroupEmojiModel initEmojiWithPlist:@"emotion_icons.plist" fileName:@"Expression_" image:@"icon_emoji_group1"];
    
    [self configEmojisData:@[group1]];
    
//    HQHChatMoreItem *item1 = [HQHChatMoreItem initWithNormalImage:@"aio_icons_freeaudio" highlightedImage:nil title:@"电话" font:15];
//    HQHChatMoreItem *item2 = [HQHChatMoreItem initWithNormalImage:@"aio_icons_video" highlightedImage:nil title:@"视频" font:15];
//    HQHChatMoreItem *item3 = [HQHChatMoreItem initWithNormalImage:@"aio_icons_pacamera" highlightedImage:nil title:@"相机" font:15];
//    HQHChatMoreItem *item4 = [HQHChatMoreItem initWithNormalImage:@"aio_icons_activity" highlightedImage:nil title:@"图片" font:15];
//    HQHChatMoreItem *item5 = [HQHChatMoreItem initWithNormalImage:@"aio_icons_folder" highlightedImage:nil title:@"文件" font:15];
//    HQHChatMoreItem *item6 = [HQHChatMoreItem initWithNormalImage:@"aio_icons_red_pack" highlightedImage:nil title:@"红包" font:15];
//    HQHChatMoreItem *item7 = [HQHChatMoreItem initWithNormalImage:@"aio_icons_music" highlightedImage:nil title:@"音乐" font:15];
//    HQHChatMoreItem *item8 = [HQHChatMoreItem initWithNormalImage:@"aio_icons_location" highlightedImage:nil title:@"定位" font:15];
//    HQHChatMoreItem *item9 = [HQHChatMoreItem initWithNormalImage:@"aio_icons_activity" highlightedImage:nil title:@"游戏" font:15];
//
//    [self configMoreItems:@[item1, item2, item3, item4, item5, item6, item7, item8, item9]];
}

- (void)configEmojisData:(NSArray *)emojis {
    self->_groupEmojis = emojis;
}

- (void)configMoreItems:(NSArray<HQHChatMoreItem *> *)moreItems {
    self->_moreItems = moreItems;
}

- (void)dealloc {
    NSLog(@"HQHChatKeyBoardManager单例销毁了~~~~~~~");
}

@end
