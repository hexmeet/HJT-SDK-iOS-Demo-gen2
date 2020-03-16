//
//  HLogingView.h
//  EasyVideo
//
//  Created by quanhao huang on 2018/7/13.
//  Copyright © 2018年 fo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GifView.h"

typedef void (^ReloadBtnEvent)(void);
@interface HLogingView : UIView

/** 显示gif图 */
@property (weak, nonatomic) IBOutlet GifView *gifView;

/** 提示文字 */
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

/** 断网显示图片 */
@property (weak, nonatomic) IBOutlet UIImageView *noNetworkImage;

/** 重新加载按钮 */
@property (weak, nonatomic) IBOutlet UIButton *reloadBtn;

@property (nonatomic, copy) ReloadBtnEvent reloadBtnEvent;

/**
 创建loading页面
 
 @param titel 初始化显示文字
 @param reloadEvent 重新加载按钮
 @param showOrhidden 是否显示重新加载文字
 */
+ (HLogingView *)hlogingViewCreateShowTitel:(NSString *)titel reloadEvent:(ReloadBtnEvent)reloadEvent isShowBtn:(BOOL)showOrhidden;

@end
