//
//  HQHKeyBoardTextView.h
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HQHTextViewHeightCallBack)(CGFloat height);

@interface HQHKeyBoardTextView : UITextView

@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, strong) UIColor *placeHolderColor;

@end

NS_ASSUME_NONNULL_END
