//
//  HQHEmojiCollectionViewCell.m
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import "HQHEmojiCollectionViewCell.h"

NSString *const kHQHEmojiCollectionViewCellId = @"kHQHEmojiCollectionViewCellId";

@interface HQHEmojiCollectionViewCell ()

@end

@implementation HQHEmojiCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.font = [UIFont systemFontOfSize:20];
        _button.backgroundColor = [UIColor colorWithRGB:0xf5f5f5];
        _button.userInteractionEnabled = NO;
        [self.contentView addSubview:_button];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.button.frame = self.contentView.bounds;
}

- (void)setEmojiModel:(HQHEmojiModel *)emojiModel {
    _emojiModel = emojiModel;
    
    if (emojiModel.title && !emojiModel.image) {
        [self.button setTitle:emojiModel.title forState:UIControlStateNormal];
        [self.button setImage:nil forState:UIControlStateNormal];
    }else if (emojiModel.image) {
        [self.button setImage:[UIImage imageNamed:emojiModel.image] forState:UIControlStateNormal];
        [self.button setTitle:@"" forState:UIControlStateNormal];
    }else {
        [self.button setTitle:@"" forState:UIControlStateNormal];
        [self.button setImage:nil forState:UIControlStateNormal];
    }
}

- (void)setFaceModel:(HQHFaceModel *)faceModel {
    _faceModel = faceModel;

    [self.button setImage:[UIImage imageNamed:faceModel.image] forState:UIControlStateNormal];
    [self.button setTitle:@"" forState:UIControlStateNormal];
}

@end
