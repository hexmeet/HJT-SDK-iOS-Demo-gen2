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

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, assign) BOOL backBool;
@property (nonatomic, copy) ShowVideoWindow showVideoWindow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewBottomConstraint;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *groupStr;

//backView
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *extentionBtn;
@property (weak, nonatomic) IBOutlet UIButton *emojiBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputRightConstraint;

@end

NS_ASSUME_NONNULL_END
