//
//  DDLogWrapper.m
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/7.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import "DDLogWrapper.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <CocoaLumberjack/DDTTYLogger.h>

// Definition of the current log level
static const int ddLogLevel = DDLogLevelVerbose;

@implementation DDLogWrapper

+ (void)logVerbose:(NSString *)message {
    NSString *str = [NSString stringWithFormat:@"%@ %@", @"[Verbose]", message];
    DDLogVerbose(str);
}

+ (void)logError:(NSString *)message {
    NSString *str = [NSString stringWithFormat:@"%@ %@", @"[Error]", message];
    DDLogError(str);
}

+ (void)logInfo:(NSString *)message {
    NSString *str = [NSString stringWithFormat:@"%@ %@", @"[Info]", message];
    DDLogInfo(str);
}

@end
