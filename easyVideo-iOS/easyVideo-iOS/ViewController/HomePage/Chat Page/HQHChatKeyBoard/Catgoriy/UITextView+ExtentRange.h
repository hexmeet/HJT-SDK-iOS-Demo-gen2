//
//  UITextView+ExtentRange.h
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/7.
//  Copyright © 2020 hqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (ExtentRange)

- (NSRange)selectedRange;

- (void)setSelectedRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
