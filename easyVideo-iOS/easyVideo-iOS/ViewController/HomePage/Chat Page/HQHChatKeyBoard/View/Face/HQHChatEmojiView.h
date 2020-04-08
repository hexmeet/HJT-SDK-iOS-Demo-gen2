//
//  HQHChatEmojiView.h
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HQHEmojiModel;

@protocol HQHChatEmojiViewDelegate <NSObject>

@required

- (void)chatEmojiViewDidSelectEmojiWithContent:(HQHEmojiModel *)content;

- (void)chatEmojiViewDidSelectFaceWithContent:(HQHFaceModel *)content;

- (void)chatEmojiViewClickSendButton:(UIButton *)sender;

@end

@interface HQHChatEmojiBottomView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *sendButton;

@end

@interface HQHChatEmojiView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) HQHChatEmojiBottomView *bottomView;
@property (nonatomic, weak) id<HQHChatEmojiViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
