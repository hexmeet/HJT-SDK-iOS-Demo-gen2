//
//  HQHVoiceAnimationView.h
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HQHVoiceState) {
    HQHVoiceNormal,
    HQHVoiceWillCancel,
    HQHVoiceCancel,
    HQHVoiceFinished
};

@interface HQHVoiceAnimationView : UIView

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *cancelImageView;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, assign) HQHVoiceState state;

@end

NS_ASSUME_NONNULL_END
