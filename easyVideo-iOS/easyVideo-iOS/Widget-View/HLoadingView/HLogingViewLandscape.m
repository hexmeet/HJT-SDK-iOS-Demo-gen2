//
//  HLogingViewLandscape.m
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/3/2.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import "HLogingViewLandscape.h"

#define KVIEW_H [UIScreen mainScreen].bounds.size.height
#define KVIEW_W [UIScreen mainScreen].bounds.size.width
@implementation HLogingViewLandscape

+ (HLogingViewLandscape *)hlogingViewCreateShowTitel:(NSString *)titel reloadEvent:(ReloadBtnEvent)reloadEvent isShowBtn:(BOOL)showOrhidden
{
    HLogingViewLandscape *logingView = [[NSBundle mainBundle]loadNibNamed:@"HLogingViewLandscape" owner:nil options:nil][0];
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
