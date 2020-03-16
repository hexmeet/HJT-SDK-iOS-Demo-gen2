//
//  UITextField+ExtentRange.h
//  EasyVideo
//
//  Created by quanhao huang on 2018/7/7.
//  Copyright © 2018年 fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)

- (NSRange)selectedRange;

- (void)setSelectedRange:(NSRange)range;

@end
