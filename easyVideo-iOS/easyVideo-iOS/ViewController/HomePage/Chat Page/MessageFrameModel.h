//
//  MessageFrameModel.h
//  EasyVideo
//
//  Created by quanhao huang on 2019/11/19.
//  Copyright © 2019 fo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MessageModel.h"

#define HQTextFont [UIFont systemFontOfSize:16]
#define HQEdgeInsets 20

@interface MessageFrameModel : NSObject

/**
 数据模型
 */
@property (nonatomic, strong) MessageModel *message;

/**
 时间frame
 */
@property (nonatomic, assign) CGRect timeF;

/**
 头像frame
 */
@property (nonatomic, assign) CGRect iconF;

/**
 正文frame
 */
@property (nonatomic, assign) CGRect textF;

/**
 姓名frame
 */
@property (nonatomic, assign) CGRect nameF;

/**
 cell的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
