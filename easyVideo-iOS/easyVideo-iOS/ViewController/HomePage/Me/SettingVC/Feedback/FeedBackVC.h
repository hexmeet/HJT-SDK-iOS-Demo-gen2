//
//  FeedBackVC.h
//  ss
//
//  Created by quanhao huang on 2020/3/1.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^UploadBlock)(BOOL flag);
@interface FeedBackVC : UIViewController

@property (nonatomic, copy) UploadBlock uploadBlock;

@end

NS_ASSUME_NONNULL_END
