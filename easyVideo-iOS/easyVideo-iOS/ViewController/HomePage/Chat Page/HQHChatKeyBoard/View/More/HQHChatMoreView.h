//
//  HQHChatMoreView.h
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HQHChatMoreViewDelegate <NSObject>

- (void)chatMoreViewDidSelectItemWithTitle:(NSString *)title index:(NSInteger)index;

@end

@interface HQHChatMoreView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, weak) id<HQHChatMoreViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
