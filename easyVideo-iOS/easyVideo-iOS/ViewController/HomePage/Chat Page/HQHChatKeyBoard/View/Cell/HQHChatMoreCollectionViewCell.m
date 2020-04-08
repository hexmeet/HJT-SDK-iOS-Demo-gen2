//
//  HQHChatMoreCollectionViewCell.m
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import "HQHChatMoreCollectionViewCell.h"

NSString *const kHQHChatMoreCollectionViewCellId = @"kHQHChatMoreCollectionViewCellId";

@implementation HQHChatMoreCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _button = [UIButton new];
        [self.contentView addSubview:_button];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.button.frame = self.contentView.bounds;
    [self.button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:kVerticalSpace];
}

- (void)setMoreItem:(HQHChatMoreItem *)moreItem {
    _moreItem = moreItem;
    
    [self.button setImage:[UIImage imageNamed:moreItem.normalImage] forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:moreItem.highlightedImage] forState:UIControlStateHighlighted];
    [self.button setTitleColor:[UIColor colorWithRGB:0x333333] forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithRGB:0x666666] forState:UIControlStateHighlighted];
    [self.button setTitle:moreItem.title forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont systemFontOfSize:moreItem.font];
}

@end
