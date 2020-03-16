//
//  ChatListVC.h
//  HexMeet
//
//  Created by quanhao huang on 2019/11/8.
//  Copyright © 2019 fo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatPageViewController.h"
#import "UIView+custom.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatListVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *chatListTab;

@end

NS_ASSUME_NONNULL_END
