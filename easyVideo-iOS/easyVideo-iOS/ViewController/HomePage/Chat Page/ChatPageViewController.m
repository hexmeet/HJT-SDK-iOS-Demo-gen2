//
//  ChatPageViewController.m
//  EasyVideo
//
//  Created by quanhao huang on 2019/12/2.
//  Copyright © 2019 fo. All rights reserved.
//

#import "ChatPageViewController.h"
#import <Masonry.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define Font(a) [UIFont fontWithName:@"PingFangSC-Regular" size:a]
@interface ChatPageViewController ()<UITableViewDataSource, UITableViewDelegate, EMEngineDelegate, EMDelegate, HQHChatKeyBoardViewDelegate>
{
@private
    AppDelegate *appDelegate;
    BOOL navHidden;
}
/**
 消息数组
 */
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) HQHChatKeyBoardView *keyBoardView;
@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation ChatPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createBackItem];
    
    self.navigationController.navigationBar.translucent = NO;
    
    if (_backBool) {
        [self createRightItemWithImage:[UIImage imageNamed:@"icon_edit"] action:@selector(rightAction:)];
    }
    
    [[EMManager sharedInstance] addEMDelegate:self];
    
    self.title = NSLocalizedString(@"tabbar.chat", @"消息");
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    appDelegate = APPDELEGATE;
    
    [self createUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view endEditing:YES];
    
    if (self.messages.count != 0) {
        NSIndexPath * path = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
        [self.mainTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    navHidden = self.navigationController.navigationBar.isHidden;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.navigationController.navigationBarHidden = navHidden;
    self.tabBarController.tabBar.hidden = navHidden;
}

- (void)createBackItem
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 42, 40)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"btn_back"];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
    imageview.frame = [UIDevice currentDevice].systemVersion.doubleValue>=11.0?CGRectMake(0, 10, 18, 18):CGRectMake(0, 10, 18, 18);
    //[button setImage:imageview forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 42, 40);
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [view addSubview:imageview];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [space setWidth:-17];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space,backButtonItem, nil];
}

- (void)goBack
{
    [[EMManager sharedInstance] removeEMDelegate:self];
    if (_backBool) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        ShowVideoWindow block = self.showVideoWindow;
        if (block) {
            block();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)rightAction:(UIButton *)sender
{
    
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        [_mainTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_mainTableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    }
    return _mainTableView;
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [self.keyBoardView hideBottomView];
}

- (HQHChatKeyBoardView *)keyBoardView {
    if (!_keyBoardView) {
        _keyBoardView = [[HQHChatKeyBoardView alloc] initWithNavigationBarTranslucent:NO];
        _keyBoardView.delegate = self;
        _keyBoardView.showMore = NO;
        _keyBoardView.showVoice = NO;
    }
    return _keyBoardView;
}

- (NSMutableArray *)messages
{
    if (_messages == nil) {

        [[EMMessageManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray *results)            {
            NSMutableArray *models = [NSMutableArray arrayWithCapacity:results.count];
            MessageModel *previousModel = nil;
            for (MessageBody *user in results) {
                if ([[self->appDelegate.evengine getIMGroupID] isEqualToString:user.groupId]) {
                    MessageModelType modelType = MessageModelTypeMe;
                    self->_groupStr = user.groupId;
           
                    NSDictionary * dict = @{@"groupId":user.groupId,
                                            @"seq":[NSString stringWithFormat:@"%llu", user.seq],
                                            @"content":user.content,
                                            @"from":user.from,
                                            @"time":user.time,
                                            @"type":@(modelType)};
                    MessageFrameModel *frameM = [[MessageFrameModel alloc] init];
                    
                    MessageModel *message = [MessageModel messageModelWithDict:dict];
                    message.name = @"";
                    message.imagUrl = @"";
                    [[EVUserIdManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray * _Nonnull results) {
                            for (EMGroupMemberInfo *info in results) {
             
                                if ([info.emuserId isEqualToString:message.from]) {
                                    message.imagUrl = info.imageUrl;
                                    message.name = info.name;
                                    if ([self->_userId isEqualToString:info.evuserId] && ![info.evuserId isEqualToString:@"0"]) {
                                        message.type = MessageModelTypeMe;
                                        //刷新新名字
                                        message.name = self->_meName;
                                    }else {
                                        if (user.isMe) {
                                            message.type = MessageModelTypeMe;
                                            //刷新新名字
                                            message.name = self->_meName;
                                        }else {
                                            message.type = MessageModelTypeOther;
                                        }
                                    }
                                }
                            }
                    } fail:nil];
                    
                    //判断是否显示时间
                    message.hiddenTime =  [message.time isEqualToString:previousModel.time];
                    
                    frameM.message = message;
                    
                    [models addObject:frameM];
                    
                    previousModel = message;
                }
            }
            self.messages = [models mutableCopy];
        } fail:^(NSError *error) {

        }];
        
    }
    return _messages;
}

- (void)createUI
{
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.keyBoardView];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.keyBoardView.mas_top);
    }];
    
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    __weak typeof(self)  weakSelf = self;
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [weakSelf.mainTableView.mj_header endRefreshing];
            [self->_mainTableView reloadData];
        });
    }];
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [weakSelf.mainTableView.mj_footer endRefreshing];
        });
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backVideo) name:@"backVideo" object:nil];
}

- (void)addMessage:(NSString *)content type:(MessageModelType) type
{
    MessageModel *compareM = [[MessageModel alloc] init];
    if (self.messages.count != 0) {
        compareM = (MessageModel *)[[self.messages lastObject] message];
    }else {
        compareM.time = @"111";
    }
    if ([appDelegate.emengine sendMessage:_groupStr content:content].length == 0 || [appDelegate.emengine sendMessage:@""content:content] == nil) {
        //发送失败
    }else {
        //当前用户发送时间
        NSDate * date = [NSDate date];
        long long timeSp = [date timeIntervalSince1970]*1000;
        NSString *strDate = [Utils getDateDisplayString:timeSp];
        
        //修改模型并且将模型保存数组
        MessageModel * message = [[MessageModel alloc] init];
        message.type = type;
        message.content = content;
        message.time = strDate;
        message.from = [appDelegate.emengine getUserInfo].userId;
        message.name = _meName;
        message.hiddenTime = [message.time isEqualToString:compareM.time];

        MessageBody *body = [[MessageBody alloc] init];
        body.groupId = _groupStr;
        body.seq = 0;
        body.content = content;
        body.from = [appDelegate.emengine getUserInfo].userId;
        body.time = strDate;
        body.isMe = YES;
        body.seq = [message.content intValue];
        
        [[EMMessageManager sharedInstance] insertNewEntity:body success:^{
            NSLog(@"数据储存成功");
        } fail:^(NSError *error) {
            NSLog(@"失败");
        }];
        
        MessageFrameModel *mf = [[MessageFrameModel alloc] init];
        mf.message = message;
        
        [self.messages addObject:mf];
        //刷新表格
        [self.mainTableView reloadData];
        
    }
}

#pragma mark - EMDelegate
- (void)onMessageReciveData:(MessageBody *)message
{
    NSDictionary * dict = @{@"groupId":message.groupId,
                            @"seq":[NSString stringWithFormat:@"%llu", message.seq],
                            @"content":message.content,
                            @"from":message.from,
                            @"time":message.time,
                            @"type":@(MessageModelTypeOther)};
    MessageFrameModel *frameM = [[MessageFrameModel alloc] init];
    
    MessageModel *messageModel = [MessageModel messageModelWithDict:dict];
    messageModel.name = @"";
    messageModel.imagUrl = @"";
    //判断是否显示时间
    messageModel.hiddenTime =  NO;
    
    [[EVUserIdManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray * _Nonnull results) {
        for (EMGroupMemberInfo *user in results) {
   
            if ([user.emuserId isEqualToString:message.from]) {
                messageModel.imagUrl = user.imageUrl;
                messageModel.name = user.name;
                
                if ([self->_userId isEqualToString:user.evuserId] && ![user.evuserId isEqualToString:@"0"]) {
                    messageModel.type = MessageModelTypeMe;
                    messageModel.name = self->_meName;
                }else {
                    if (message.isMe) {
                        messageModel.type = MessageModelTypeMe;
                        messageModel.name = self->_meName;
                    }else {
                        messageModel.type = MessageModelTypeOther;
                    }
                }
            }
            
        }
    } fail:nil];
    
    messageModel.from = message.from;
    
    frameM.message = messageModel;
    
    if ([message.groupId isEqualToString:_groupStr]) {
        [self.messages addObject:frameM];
        //刷新表格
        [self.mainTableView reloadData];
        
        NSIndexPath * path = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
        [self.mainTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)onGroupMemberInfo:(EMGroupMemberInfo *)groupMemberInfo
{
    for (MessageFrameModel *model in self.messages) {
        
        if (model.message.name.length == 0 || model.message.imagUrl.length == 0) {
            //重新刷新消息
            [[EVUserIdManager sharedInstance] selectEntity:nil ascending:YES filterString:nil success:^(NSArray * _Nonnull results) {
                for (EMGroupMemberInfo *user in results) {
                    if ([user.emuserId isEqualToString:model.message.from]) {
                        
                        model.message.imagUrl = user.imageUrl;
                        model.message.name = user.name;
                        
                    }
                    
                }
            } fail:nil];
            //Fix 重新排版
            [model setMessage:model.message];
        }
    }
    [self->_mainTableView reloadData];
}

- (void)onEMError:(EMError *)err {
    
}

- (void)onMessageSendSucceed:(MessageState *_Nonnull)messageState
{
    
}

- (void)onCallEnd
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backVideo
{
    if (_backBool) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        ShowVideoWindow block = self.showVideoWindow;
        if (block) {
            block();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.messageFrame = self.messages[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageFrameModel *fm = [self.messages objectAtIndex:indexPath.row];
    return fm.cellHeight;
}

#pragma mark - HQHChatKeyBoardViewDelegate
//发送文本，考虑到表情（🙂&[微笑]）上传时需要将原文传给服务器，展示的时候才是显示转换后的文字
- (void)chatKeyBoardViewSendTextMessage:(NSMutableAttributedString *)text originText:(NSString *)originText
{
    if (originText.length == 0) {
        return;
    }
    [self addMessage:originText type:MessageModelTypeMe];
    if (self.messages.count != 0) {
        NSIndexPath * path = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
        [self.mainTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

//发送大表情图片
- (void)chatKeyBoardViewSendPhotoMessage:(NSString *)photo
{
    
}

//发送录音，这里是完整的音频路径
- (void)chatKeyBoardViewSendVoiceMessage:(NSString *)voicePath
{
    
}

//点击更多
- (void)chatKeyBoardViewSelectMoreImteTitle:(NSString *)title index:(NSInteger)index
{
    
}

@end
