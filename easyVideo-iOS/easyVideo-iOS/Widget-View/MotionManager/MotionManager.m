//
//  MotionManager.m
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/14.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import "MotionManager.h"

static MotionManager *_sharedManger;
@implementation MotionManager

+ (MotionManager *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedManger) {
            _sharedManger = [[MotionManager alloc] init];
        }
    });
    return _sharedManger;
}

- (void)startMotionManager:(DeviceMotionTypeBlock)deviceMotionTypeBlock {
    if (_cmmotionManager == nil) {
        _cmmotionManager = [[CMMotionManager alloc] init];
    }
    _cmmotionManager.deviceMotionUpdateInterval = 0.5;
    if (_cmmotionManager.deviceMotionAvailable) {

        [_cmmotionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            double x = motion.gravity.x;
            double y = motion.gravity.y;
            if (fabs(y) >= fabs(x))
            {
                if (y >= 0){
                    if(deviceMotionTypeBlock){
                        deviceMotionTypeBlock(PortraitUpsideDown);
                    }
                }
                else{
                    if(deviceMotionTypeBlock){
                        deviceMotionTypeBlock(Portrait);
                    }
                }
            }
            else
            {
                if (x >= 0){
                    if(deviceMotionTypeBlock){
                        deviceMotionTypeBlock(LandscapeLeft);
                    }
                }
                else{
                    if(deviceMotionTypeBlock){
                        deviceMotionTypeBlock(LandscapeRight);
                    }
                }
            }
            
        }];
}}

@end
