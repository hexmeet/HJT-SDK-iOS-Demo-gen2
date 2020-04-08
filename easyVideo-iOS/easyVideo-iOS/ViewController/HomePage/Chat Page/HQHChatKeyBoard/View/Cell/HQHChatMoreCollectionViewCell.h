//
//  HQHChatMoreCollectionViewCell.h
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * _Nonnull const kHQHChatMoreCollectionViewCellId;

NS_ASSUME_NONNULL_BEGIN

@class HQHChatMoreItem;

@interface HQHChatMoreCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) HQHChatMoreItem *moreItem;

@end

NS_ASSUME_NONNULL_END
