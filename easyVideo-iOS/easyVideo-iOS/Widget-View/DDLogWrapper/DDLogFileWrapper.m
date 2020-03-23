//
//  DDLogFileWrapper.m
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/3/18.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import "DDLogFileWrapper.h"

@interface DDLogFileWrapper()

@property (nonatomic, copy) NSString *fileName;

@end

@implementation DDLogFileWrapper

- (instancetype)initWithLogsDirectory:(NSString *)logsDirectory
                             fileName:(NSString *)name
{
    self = [super initWithLogsDirectory:logsDirectory];
    if (self) {
        self.fileName = name;
    }
    return self;
}

- (NSString *)newLogFileName
{
    return [NSString stringWithFormat:@"%@", self.fileName];
}

- (BOOL)isLogFile:(NSString *)fileName
{
    return [fileName isEqualToString:self.fileName];
}

@end
