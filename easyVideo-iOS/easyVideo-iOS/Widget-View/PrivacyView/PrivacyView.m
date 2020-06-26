//
//  PrivacyView.m
//  easyVideo-iOS
//
//  Created by frk on 2020/5/8.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import "PrivacyView.h"
#import <Masonry.h>

#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

@interface PrivacyView ()<UITextViewDelegate>

@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, strong) UIButton *disagreeBtn;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UITextView *contentText;


@end

@implementation PrivacyView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
      
        [self createUI];
    }
    return self;
}


-(void)createUI{
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor =[UIColor whiteColor];
    [self addSubview:whiteView];
    whiteView.layer.cornerRadius = 10;
    whiteView.layer.masksToBounds = YES;
  
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(320*(IS_PAD?2:1), 400));
    }];
    
    UILabel *titleLbl = [[UILabel alloc]init];
    titleLbl.backgroundColor = [UIColor UIColorFormHexString:@"#F7F7F7"];
    [whiteView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.width.equalTo(whiteView);
        make.height.mas_equalTo(60);
    }];
    titleLbl.openClip = YES;
    titleLbl.clipType = CornerClipTypeTopRight | CornerClipTypeTopLeft;
    titleLbl.radius = 10;
   
    UILabel *titleContent = [[UILabel alloc]init];
    titleContent.text = @"会捷通隐私政策";
    titleContent.textColor = [UIColor grayColor];
    [titleLbl addSubview:titleContent];
    [titleContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(titleLbl).offset(22);
        make.centerY.equalTo(titleLbl.mas_centerY);
    }];
    self.titleLbl = titleContent;
    
    
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    agreeBtn.backgroundColor = [UIColor UIColorFormHexString:@"#5A82EF"];
    agreeBtn.layer.cornerRadius = 6;
    agreeBtn.clipsToBounds = YES;
    [whiteView addSubview:agreeBtn];
    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(whiteView.mas_bottom).offset(-10);
        make.trailing.equalTo(whiteView.mas_trailing).offset(-30);
        make.size.mas_equalTo(CGSizeMake(120*(IS_PAD?2:1), 40));
    }];
    self.agreeBtn = agreeBtn;
    [self.agreeBtn addTarget:self action:@selector(agree) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *disagreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [disagreeBtn setTitle:@"暂不使用" forState:UIControlStateNormal];
    [disagreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    disagreeBtn.backgroundColor = [UIColor whiteColor];
    disagreeBtn.layer.cornerRadius = 6;
    disagreeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    disagreeBtn.layer.borderWidth = 0.5;
    disagreeBtn.clipsToBounds = YES;
    [whiteView addSubview:disagreeBtn];
    [disagreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(agreeBtn.mas_centerY);
       make.leading.equalTo(whiteView.mas_leading).offset(30);
       make.size.mas_equalTo(CGSizeMake(120*(IS_PAD?2:1), 40));
    }];
    self.disagreeBtn = disagreeBtn;
    [self.disagreeBtn addTarget:self action:@selector(disagree) forControlEvents:UIControlEventTouchUpInside];
    
    //富文本
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSLocalizedString(@"conf.pravicy", nil) stringByReplacingOccurrencesOfString:@"${CFBundleDisplayName}" withString:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleDisplayName"]]];
    
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, attStr.length)];

    
    [attStr addAttribute:NSLinkAttributeName value:@"Pravicy://" range:[[attStr string] rangeOfString:@"《隐私政策》"]];
    [attStr addAttribute:NSLinkAttributeName value:@"TermsServic://" range:[[attStr string] rangeOfString:@"《软件许可及服务协议》"]];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[[attStr string] rangeOfString:@"如您同意，请点击“同意”并开始使用我们的产品和服务"]];

    
    UITextView *contentText = [[UITextView alloc]init];
    contentText.delegate = self;
    contentText.editable = NO;
    contentText.selectable = YES;
    contentText.attributedText = attStr;
    [self addSubview:contentText];
    [contentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLbl.mas_bottom);
        make.leading.equalTo(whiteView).offset(20);
        make.trailing.equalTo(whiteView).offset(-20);
        make.bottom.equalTo(agreeBtn.mas_top).offset(-10);
    }];
    
    
}

-(void)disagree{
    exit(0);

}


-(void)agree{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[PlistUtils loadPlistFilewithFileName:@"UserPlist"]];
    
    [userInfo setValue:@"pravicy" forKey:@"pravicy"];
    [PlistUtils savePlistFile:userInfo withFileName:@"UserPlist"];
    [self removeFromSuperview];
}




-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0)){

    BaseViewController  *vc = (BaseViewController *)[UIViewControllerCJHelper findCurrentShowingViewController];
    TermsServiceVC *Servc = [TermsServiceVC new];
    Servc.hidesBottomBarWhenPushed = YES;
    Servc.isPravicy = [URL.scheme isEqualToString:@"TermsServic"]?false:true;
    [vc.navigationController pushViewController:Servc animated:YES];

    return YES;
    
}

@end
