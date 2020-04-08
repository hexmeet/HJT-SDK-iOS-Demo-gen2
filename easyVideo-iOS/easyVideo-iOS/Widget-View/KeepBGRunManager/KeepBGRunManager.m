//
//  KeepBGRunManager.m
//  PairContentUI
//
//  Created by quanhao huang on 2019/11/21.
//  Copyright © 2019 quanhao huang. All rights reserved.
//

#import "KeepBGRunManager.h"

static NSInteger _circulaDuration = 60;
static KeepBGRunManager *_sharedManger;
@interface KeepBGRunManager ()

@property (nonatomic, assign) UIBackgroundTaskIdentifier task;
@property (nonatomic, strong) AVAudioPlayer *playerBack;
@property (nonatomic, strong) NSTimer *timerAD;
@property (nonatomic, strong) NSTimer *timerLog;
@property (nonatomic, assign) NSInteger count;

@end

@implementation KeepBGRunManager{
    CFRunLoopRef _runloopRef;
    dispatch_queue_t _queue;
}

+ (KeepBGRunManager *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedManger) {
            _sharedManger = [[KeepBGRunManager alloc] init];
        }
    });
    return _sharedManger;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupAudioSession];
        _queue = dispatch_queue_create("com.audio.inBackground", NULL);
        //静音文件
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ringtone" ofType:@"wav"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
        self.playerBack = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        [self.playerBack prepareToPlay];
        // 0.0~1.0,默认为1.0
        self.playerBack.volume = 0.0;
        // 循环播放
        self.playerBack.numberOfLoops = -1;
    }
    return self;
}

- (void)setupAudioSession {
    // 新建AudioSession会话
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    // 设置后台播放
    NSError *error = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
    if (error) {
        NSLog(@"Error setCategory AVAudioSession: %@", error);
    }
    NSLog(@"%d", audioSession.isOtherAudioPlaying);
    NSError *activeSetError = nil;
    // 启动AudioSession，如果一个前台app正在播放音频则可能会启动失败
    [audioSession setActive:YES error:&activeSetError];
    if (activeSetError) {
        NSLog(@"Error activating AVAudioSession: %@", activeSetError);
    }
}

- (void)startBGRun{
    [self.playerBack play];
    [self applyforBackgroundTask];
    ///确保两个定时器同时进行
    dispatch_async(_queue, ^{
        self.timerLog = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1 target:self selector:@selector(log) userInfo:nil repeats:YES];
        self.timerAD = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:_circulaDuration target:self selector:@selector(startAudioPlay) userInfo:nil repeats:YES];
        self->_runloopRef = CFRunLoopGetCurrent();
        [[NSRunLoop currentRunLoop] addTimer:self.timerAD forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] addTimer:self.timerLog forMode:NSDefaultRunLoopMode];
        CFRunLoopRun();
    });
}

- (void)applyforBackgroundTask{
    _task =[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] endBackgroundTask:self->_task];
            self->_task = UIBackgroundTaskInvalid;
        });
    }];
}

- (void)log{
    _count = _count + 1;
    //NSLog(@"_count = %ld",_count);
}

- (void)startAudioPlay{
    _count = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] backgroundTimeRemaining] < 61.0) {
            NSLog(@"杀死");
            [self.playerBack play];
            [self applyforBackgroundTask];
        }
        else{
            NSLog(@"活跃");
        }
        //[self.playerBack stop];
    });
}

- (void)stopBGRun{
    if (self.timerAD) {
        CFRunLoopStop(_runloopRef);
        [self.timerLog invalidate];
        self.timerLog = nil;
        // 关闭定时器即可
        [self.timerAD invalidate];
        self.timerAD = nil;
        [self.playerBack stop];
    }
    if (_task) {
        [[UIApplication sharedApplication] endBackgroundTask:_task];
        _task = UIBackgroundTaskInvalid;
    }
}

@end
