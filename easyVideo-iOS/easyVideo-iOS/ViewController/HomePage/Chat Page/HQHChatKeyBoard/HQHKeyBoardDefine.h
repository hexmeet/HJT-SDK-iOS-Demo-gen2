//
//  HQHKeyBoardDefine.h
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#ifndef HQHKeyBoardDefine_h
#define HQHKeyBoardDefine_h

#ifndef SCREEN_Height
#define SCREEN_Height [[UIScreen mainScreen] bounds].size.height
#endif

#ifndef SCREEN_Width
#define SCREEN_Width  [[UIScreen mainScreen] bounds].size.width
#endif

#define kDefaultTableHeaderView [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.01f)]

#define kStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define kIsIPhoneX (kStatusBarHeight == 20.f ? NO : YES)
#define kNavigationBarHeight (kIsIPhoneX ? 88.f : 64.f)
#define kTabBarHeight (kIsIPhoneX ? 83.f : 49.f)
#define kHomeIndecatorHeight (kIsIPhoneX ? 34.f : 0.f)

#define kToolBarHeight           49.f //工具条高度
#define kButtonHeight            30.f //按钮高度
#define kHorizenSpace            10.f //水平间隔
#define kVerticalSpace           9.5f //垂直间隔
#define kBottomViewHeight        310.f //底部视图高度
#define kTextViewWidth           (SCREEN_Width-(5*kHorizenSpace)-(3*kButtonHeight)) //输入框宽度
#define kTextViewMaxHeight        100.f //输入框最大高度
#define kLineColor  [UIColor colorWithRGB:0xc8c8c8] //边框色

#define kSmallEmojiRow            4 //表情行数
#define kSmallEmojiCol            7 //表情列数

#define kBigEmojiRow              2 //表情行数
#define kBigEmojiCol              4 //表情列数

#define kSendButtonWidth          60.f
#define kPageControlHeight        10.f
#define kEmojiBottomHeight        40.f

#define kEmojiGroupButtonWidth    50.f
#define kEmojiGroupButtonHeight   40.f

#define kMoreItemWidth            80.f
#define kMoreItemHeight           80.f

#import "UIView+HQHKeyBoard.h"
#import "UIButton+HQHKeyBoard.h"
#import "UIColor+HQHKeyBoard.h"
#import "NSString+HQHKeyBoard.h"
#import "UIImage+HQHKeyBoard.h"
#import "UIScrollView+HQHKeyBoard.h"

#import "HQHEmojiModel.h"
#import "HQHChatMoreItem.h"
#import "HQHChatKeyBoardManager.h"
#import "HQHKeyBoardTextView.h"
#import "HQHChatMoreView.h"
#import "HQHVoiceAnimationView.h"
#import "HQHAudioRecorder.h"
#import "lame.h"
#import "HQHChatMoreCollectionViewCell.h"
#import "HQHEmojiCollectionViewCell.h"
#import "HQHEmojiFlowLayout.h"

#endif /* HQHKeyBoardDefine_h */
