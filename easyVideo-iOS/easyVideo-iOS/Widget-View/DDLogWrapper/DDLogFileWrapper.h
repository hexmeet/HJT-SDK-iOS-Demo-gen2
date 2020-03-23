//
//  DDLogFileWrapper.h
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/3/18.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import "DDFileLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDLogFileWrapper : DDLogFileManagerDefault

- (instancetype)initWithLogsDirectory:(NSString *)logsDirectory fileName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
