//
//  HQEditImageActionView.h
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/2/19.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@class HQEditImageActionView;
@protocol HQEditImageActionViewDelegate <NSObject>

- (void)action:(HQEditImageActionView *)action didClickButton:(UIButton *)button atIndex:(NSInteger)index;

@end

@interface HQEditImageActionView : UIView

@property (nonatomic, weak) id <HQEditImageActionViewDelegate> delegate;

@property (nonatomic, strong) UIButton *rotateButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *originButton;
@property (nonatomic, strong) UIButton *finishButton;

@end

NS_ASSUME_NONNULL_END
