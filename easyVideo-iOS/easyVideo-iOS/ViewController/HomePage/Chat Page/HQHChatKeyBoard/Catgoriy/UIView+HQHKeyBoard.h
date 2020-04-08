//
//  UIView+HQHKeyBoard.h
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HQHKeyBoard)

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
//@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
//@property (nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
//@property (nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
//@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
//@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
//@property (nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
//@property (nonatomic) CGSize  size;        ///< Shortcut for frame.size.

@end

NS_ASSUME_NONNULL_END
