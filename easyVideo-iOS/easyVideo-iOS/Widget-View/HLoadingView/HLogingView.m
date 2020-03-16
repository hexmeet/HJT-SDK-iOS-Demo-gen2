//
//  HLogingView.m
//  HexMeet
//
//  Created by quanhao huang on 2018/7/13.
//  Copyright © 2018年 fo. All rights reserved.
//

#import "HLogingView.h"

/**屏幕高度*/
#define KVIEW_H [UIScreen mainScreen].bounds.size.height

/**屏幕宽度*/
#define KVIEW_W [UIScreen mainScreen].bounds.size.width
@implementation HLogingView

+ (HLogingView *)hlogingViewCreateShowTitel:(NSString *)titel reloadEvent:(ReloadBtnEvent)reloadEvent isShowBtn:(BOOL)showOrhidden
{
    HLogingView *logingView = [[NSBundle mainBundle]loadNibNamed:@"HLogingView" owner:nil options:nil][0];
    logingView.frame = CGRectMake(0, 0, KVIEW_W, KVIEW_H);
    
    if (showOrhidden) {
        logingView.reloadBtn.hidden = NO;
    }else {
        logingView.reloadBtn.hidden = YES;
    }
    logingView.promptLabel.text = titel;
    
    //添加gif
    NSString *path = [[NSBundle mainBundle] pathForResource:@"loading@2x" ofType:@"gif"];
    [logingView.gifView loadImagefilePath:path];
    
    logingView.reloadBtnEvent = reloadEvent;
    
    return logingView;
}

/**
 刷新当前视图

 @param sender reloadBtn
 */
- (IBAction)reloadAction:(id)sender
{
    if (_reloadBtnEvent) {
        _reloadBtnEvent();
    }
}

@end
