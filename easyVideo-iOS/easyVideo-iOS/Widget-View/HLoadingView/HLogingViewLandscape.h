//
//  HLogingViewLandscape.h
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/3/2.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GifView.h"

typedef void (^ReloadBtnEvent)(void);
NS_ASSUME_NONNULL_BEGIN

@interface HLogingViewLandscape : UIView

/** 显示gif图 */
@property (weak, nonatomic) IBOutlet GifView *gifView;

/** 提示文字 */
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

/** 断网显示图片 */
@property (weak, nonatomic) IBOutlet UIImageView *noNetworkImage;

/** 重新加载按钮 */
@property (weak, nonatomic) IBOutlet UIButton *reloadBtn;

@property (nonatomic, copy) ReloadBtnEvent reloadBtnEvent;

+ (HLogingViewLandscape *)hlogingViewCreateShowTitel:(NSString *)titel reloadEvent:(ReloadBtnEvent)reloadEvent isShowBtn:(BOOL)showOrhidden;

@end

NS_ASSUME_NONNULL_END
