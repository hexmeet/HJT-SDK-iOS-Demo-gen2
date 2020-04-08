//
//  KeepBGRunManager.h
//  PairContentUI
//
//  Created by quanhao huang on 2019/11/21.
//  Copyright © 2019 quanhao huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeepBGRunManager : NSObject

+ (KeepBGRunManager *)shareManager;

- (void)startBGRun;
- (void)stopBGRun;

@end

NS_ASSUME_NONNULL_END
