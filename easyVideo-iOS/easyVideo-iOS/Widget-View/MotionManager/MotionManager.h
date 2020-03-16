//
//  MotionManager.h
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/14.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

typedef enum _DeviceMotionType
{
    PortraitUpsideDown = 0,
    Portrait = 1,
    LandscapeLeft = 2,
    LandscapeRight = 3
} DeviceMotionType;

typedef void (^DeviceMotionTypeBlock)(DeviceMotionType motionType);

NS_ASSUME_NONNULL_BEGIN

@interface MotionManager : NSObject

+ (MotionManager *)shareManager;

@property (nonatomic, strong) CMMotionManager *cmmotionManager;
@property (nonatomic, copy) DeviceMotionTypeBlock deviceMotionTypeBlock;

- (void)startMotionManager:(DeviceMotionTypeBlock)deviceMotionTypeBlock;

@end

NS_ASSUME_NONNULL_END
