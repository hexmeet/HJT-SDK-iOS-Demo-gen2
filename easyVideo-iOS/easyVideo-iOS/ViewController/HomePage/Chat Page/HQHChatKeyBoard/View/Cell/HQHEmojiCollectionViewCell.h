//
//  HQHEmojiCollectionViewCell.h
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * _Nonnull const kHQHEmojiCollectionViewCellId;

@class HQHEmojiModel;

NS_ASSUME_NONNULL_BEGIN

@interface HQHEmojiCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) HQHEmojiModel *emojiModel;
@property (nonatomic, strong) HQHFaceModel *faceModel;

@end

NS_ASSUME_NONNULL_END
