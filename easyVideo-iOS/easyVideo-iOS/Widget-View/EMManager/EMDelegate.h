//
//  EMDelegate.h
//  HexMeet
//
//  Created by quanhao huang on 2019/12/3.
//  Copyright © 2019 fo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EMDelegate <NSObject>

- (void)onMessageReciveData:(MessageBody *)message;

- (void)onEMError:(EMError *)err;

- (void)onGroupMemberInfo:(EMGroupMemberInfo *)groupMemberInfo;

- (void)onMessageSendSucceed:(MessageState *_Nonnull)messageState;

- (void)onCallEnd;

@end

NS_ASSUME_NONNULL_END