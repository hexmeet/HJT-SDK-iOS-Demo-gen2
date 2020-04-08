//
//  ChatPageViewController.h
//  EasyVideo
//
//  Created by quanhao huang on 2019/12/2.
//  Copyright © 2019 fo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "MessageFrameModel.h"
#import "MessageCell.h"
#import "UIView+custom.h"
#import "UITextField+ExtentRange.h"
#import "UIViewController+custom.h"

typedef void (^ShowVideoWindow)(void);
NS_ASSUME_NONNULL_BEGIN

@interface ChatPageViewController : UIViewController

@property (nonatomic, assign) BOOL backBool;
@property (nonatomic, copy) NSString *meName;
@property (nonatomic, copy) ShowVideoWindow showVideoWindow;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *groupStr;

@end

NS_ASSUME_NONNULL_END
