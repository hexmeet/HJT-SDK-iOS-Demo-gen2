//
//  Utils.h
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/19.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^AlertBtnActionBlock)(BOOL flag);
@interface Utils : NSObject

/** 设置远端视频 */
+ (void)setRemoteVideo:(NSArray *)arr;

//获取string size
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font;

/** Color */
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 判断是否含有特殊字符（有返回Mac 没有则返回全部 可以包含空格）
 
 @param content 传入判断字符串
 @return 返回新字符串
 */
+ (NSString *)judgeString:(NSString *)content;

/// 解析web转换为字典
/// @param url URL
+ (NSMutableDictionary *)getURLParameters:(NSString *)url;

+ (void)backToRootViewcontroller;

//检查耳机状态
+ (BOOL)isHeadSetPlugging;

+ (void)setSpeaker;

+ (void)setReceiver;

//显示退出Alert
+ (void)showAlert:(NSString *)title oneBtn:(NSString *)btnTitle1 twoBtn:(NSString *)btnTitle2 block:(AlertBtnActionBlock)block;

//显示拍照Alert
+ (void)showCameraAlert:(NSString *)btnTitle1 twoBtn:(NSString *)btnTitle2 threeBtn:(NSString *)btnTitle3 block:(AlertBtnActionBlock)block;

/** 渐变色 */
+ (CAGradientLayer *)addgradientLayer:(UIColor *)startColor withEndColor:(UIColor *)endColor view:(UIView *)view;

/** 获取emoji */
+ (NSMutableArray *)defaultEmoticons;

+ (NSDictionary*)getObjectData:(id)obj;

//聊天界面时间显示内容
+ (NSString *)getDateDisplayString:(long long)miliSeconds;

//解析RFC3339
+ (NSString *)userVisibleDateTimeStringForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString;

+ (EVContactInfo *)getContactInfo:(NSString *)evuserId;

+ (UINavigationController *)currentNC;

@end

NS_ASSUME_NONNULL_END
