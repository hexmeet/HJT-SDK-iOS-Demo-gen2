//
//  MessageCell.h
//  EasyVideo
//
//  Created by quanhao huang on 2019/11/19.
//  Copyright © 2019 fo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "MessageFrameModel.h"
#import "UIImage+HQExtension.h"


@interface MessageCell : UITableViewCell


@property (nonatomic, strong) MessageFrameModel *messageFrame;

+(instancetype) cellWithTableView:(UITableView *) tableview;

@end
