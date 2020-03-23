//
//  DDLogWrapper.h
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/7.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDLogWrapper : NSObject

+ (void)logVerbose:(NSString *)message;
+ (void)logError:(NSString *)message;
+ (void)logInfo:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
