//
//  HQHAudioRecorder.h
//  聊天Demo
//
//  Created by quanhao huang on 2020/4/2.
//  Copyright © 2020 hqh. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString * _Nonnull const kHQHAudioRecorderNotification;

NS_ASSUME_NONNULL_BEGIN

@interface HQHAudioRecorder : NSObject

//单例对象
+ (instancetype)shared;

//开始录音
- (BOOL)startRecord;

//结束录音，返回录音文件完整路径及时长
- (NSDictionary *)stopRecord;

//是否正在录音中
- (BOOL)isRecording;

//取消录音
- (void)cancelRecording;

//根据路径播放网络上的MP3文件，不能播放本地
- (void)playRecordWithURL:(NSString *)url;

//根据路径播放本地MP3文件，不能播放网络MP3
- (void)playLocalRecordWithURL:(NSString *)url;

//删除相关路径的MP3文件
- (BOOL)deleteRecordWithURL:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
