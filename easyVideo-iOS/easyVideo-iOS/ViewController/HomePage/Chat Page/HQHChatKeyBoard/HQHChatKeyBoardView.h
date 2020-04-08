//
//  HQHChatKeyBoardView.h
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQHChatEmojiView.h"
#import "HQHChatMoreView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HQHKeyBoardState) {
    HQHKeyBoardStateNormal,         //初始状态
    HQHKeyBoardStateVoice,          //录音状态
    HQHKeyBoardStateFace,           //表情状态
    HQHKeyBoardStateMore,           //更多状态
    HQHKeyBoardStateKeyBoard,       //系统键盘弹起状态
};

@protocol HQHChatKeyBoardViewDelegate <NSObject>

//发送文本，考虑到表情（🙂&[微笑]）上传时需要将原文传给服务器，展示的时候才是显示转换后的文字
- (void)chatKeyBoardViewSendTextMessage:(NSMutableAttributedString *)text originText:(NSString *)originText;

//发送大表情图片
- (void)chatKeyBoardViewSendPhotoMessage:(NSString *)photo;

//发送录音，这里是完整的音频路径
- (void)chatKeyBoardViewSendVoiceMessage:(NSDictionary *)voiceInfo;

//点击更多
- (void)chatKeyBoardViewSelectMoreImteTitle:(NSString *)title index:(NSInteger)index;

@end

@class HQHChatEmojiView;

@interface HQHChatKeyBoardView : UIView

@property (nonatomic, weak) id<HQHChatKeyBoardViewDelegate> delegate;

//是否使用录音，默认显示
@property (nonatomic, assign) BOOL showVoice;
//是否使用表情，默认显示
@property (nonatomic, assign) BOOL showFace;
//是否使用更多，默认显示
@property (nonatomic, assign) BOOL showMore;

//textViewPlaceHolder
@property (nonatomic, copy) NSString *textViewPlaceHolder;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/**
 初始化方法

 @param translucent navigationBar的truanslucent属性，如果没有navigationBar设置为YES
 @return 当前对象
 */
- (instancetype)initWithNavigationBarTranslucent:(BOOL)translucent;

//收起键盘
- (void)hideBottomView;

@end

NS_ASSUME_NONNULL_END
