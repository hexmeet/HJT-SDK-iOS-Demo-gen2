//
//  Manager.m
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/8.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import "Manager.h"

static Manager *manager = nil;
static NSObject *g_lock = nil;
@implementation Manager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[Manager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegates = (GCDMulticastDelegate<ManagerDelegate> *)[[GCDMulticastDelegate alloc] init];
        g_lock = [[NSObject alloc] init];
    }
    return self;
}

- (void)addDelegate:(id<ManagerDelegate>)delegate
{
    @synchronized(g_lock) {
        [_delegates addDelegate:delegate delegateQueue:dispatch_get_main_queue()];
    }
}

- (void)removeDelegate:(id<ManagerDelegate>)delegate
{
    if (!delegate) {
        return;
    }
    @synchronized(g_lock) {
        [_delegates removeDelegate:delegate];
    }
}

@end
