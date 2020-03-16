//
//  MessageModel.h
//  HexMeet
//
//  Created by quanhao huang on 2019/11/19.
//  Copyright © 2019 fo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

typedef enum
{
    MessageModelTypeMe = 0,
    MessageModelTypeOther
} MessageModelType;

@interface MessageModel : NSObject
/**
 正文
 */
@property (nonatomic, copy) NSString *content;

/**
 时间
 */
@property (nonatomic, copy) NSString *time;

/**
 消息类型
 */
@property (nonatomic, assign) MessageModelType type;

/**
 seq
 */
@property (nonatomic, copy) NSString *seq;

/**
 来自
 */
@property (nonatomic, copy) NSString *from;

/**
 群ID
 */
@property (nonatomic, copy) NSString *groupId;

/**
 名字
 */
@property (nonatomic, copy) NSString *name;

/**
 头像
 */
@property (nonatomic, copy) NSString *imagUrl;

/**
 是否显示时间
 */
@property (nonatomic, assign) BOOL hiddenTime;

HQInitH(messageModel)

@end
