//
//  ChatPageViewController.m
//  EasyVideo
//
//  Created by quanhao huang on 2019/12/2.
//  Copyright © 2019 fo. All rights reserved.
//

#import "ChatPageViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define Font(a) [UIFont fontWithName:@"PingFangSC-Regular" size:a]
@interface ChatPageViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, EMEngineDelegate, EMDelegate>
{
@private
    EmojiKeyboard *emojiKeyboard;
    Extentionkeyboard *extentionkeyboard;
    AppDelegate *appDelegate;
    BOOL navHidden;
}
/**
 消息数组
 */
@property (nonatomic, strong) NSMutableArray *messages;

/**
 自动回复数组
 */
@property (nonatomic, strong) NSDictionary *autoResentDic;

@end

@implementation ChatPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createBackItem];
    
    if (_backBool) {
        [self createRightItemWithImage:[UIImage imageNamed:@"icon_edit"] action:@selector(rightAction:)];
    }
    
    [[EMManager sharedInstance] addEMDelegate:self];
    
    self.title = NSLocalizedString(@"tabbar.chat", @"消息");
    
    appDelegate = APPDELEGATE;
    
    self.userId = [NSString stringWithFormat:@"%llu", [appDelegate.evengine getUserInfo].userId];
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    navHidden = self.navigationController.navigationBar.isHidden;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backVideo" object:nil];
    
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
                            for (EMGroupMemberInfo *user in results) {
             
                                if ([user.emuserId isEqualToString:message.from]) {
                                    message.imagUrl = user.imageUrl;
                                    message.name = user.name;
                                    if ([self->_userId isEqualToString:user.evuserId] && ![user.evuserId isEqualToString:@"0"]) {
                                        message.type = MessageModelTypeMe;
                                    }else {
                                        message.type = MessageModelTypeOther;
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

- (NSDictionary *)autoResentDic
{
    if (_autoResentDic == nil) {
        NSString *strUrl = [[NSBundle mainBundle] pathForResource:@"autoResent.plist" ofType:nil];
        _autoResentDic = [NSDictionary dictionaryWithContentsOfFile:strUrl];
        
    }
    return _autoResentDic;
}


- (void)createUI
{
    self.mainTableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.estimatedRowHeight = 0;
    self.mainTableView.estimatedSectionHeaderHeight = 0;
    self.mainTableView.estimatedSectionFooterHeight = 0;
    self.mainTableView.separatorStyle = NO;
    
    self.inputTextField.delegate = self;
    self.inputTextField.inputAssistantItem.leadingBarButtonGroups = @[];
    self.inputTextField.inputAssistantItem.trailingBarButtonGroups = @[];
    
    if (_backBool) {
        _inputRightConstraint.constant = 44;
        _extentionBtn.hidden = NO;
    }else {
        _inputRightConstraint.constant = 10;
        _extentionBtn.hidden = YES;
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
    
    //表情键盘
    if (!emojiKeyboard) {
        emojiKeyboard = [[NSBundle mainBundle] loadNibNamed:@"EmojiKeyboard" owner:self options:nil][0];
        emojiKeyboard.frame = CGRectMake(0, 0, kScreenWidth, 200);
        emojiKeyboard.emojiBlock = ^(NSString * _Nonnull emojiStr) {
            NSRange range = weakSelf.inputTextField.selectedRange;
            NSUInteger indexCursor = range.location;
            NSMutableString *str = [NSMutableString stringWithString:weakSelf.inputTextField.text];
            [str insertString:[NSString stringWithFormat:@"%@", emojiStr] atIndex:indexCursor];
            weakSelf.inputTextField.text = [NSString stringWithFormat:@"%@%@", weakSelf.inputTextField.text, emojiStr];

            indexCursor++;

            //设置光标位置
            NSRange ra = {indexCursor,0};
            [weakSelf.inputTextField setSelectedRange:ra];
        };
    }
    
    //扩展功能键盘
    if (!extentionkeyboard) {
        extentionkeyboard = [[NSBundle mainBundle] loadNibNamed:@"Extentionkeyboard" owner:self options:nil][0];
        extentionkeyboard.frame = CGRectMake(0, 0, kScreenWidth, 200);
        extentionkeyboard.extentionAudioBlock = ^{
            [weakSelf.inputTextField resignFirstResponder];
        };
        extentionkeyboard.extentionVideoBlock = ^{
            [weakSelf.inputTextField resignFirstResponder];
        };
    }
        
    //注册键盘显示通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backVideo) name:@"backVideo" object:nil];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return YES;
    }
    [self addMessage:textField.text type:MessageModelTypeMe];
    if (self.messages.count != 0) {
        NSIndexPath * path = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
        [self.mainTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    self.inputTextField.text = @"";
    return YES;
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
        message.name = [appDelegate.evengine getDisplayName];
        message.hiddenTime = [message.time isEqualToString:compareM.time];

        MessageBody *body = [[MessageBody alloc] init];
        body.groupId = _groupStr;
        body.seq = 0;
        body.content = content;
        body.from = [appDelegate.emengine getUserInfo].userId;
        body.time = strDate;
        
        [[EMMessageManager sharedInstance] insertNewEntity:body success:^{
            NSLog(@"数据储存成功");
        } fail:^(NSError *error) {
            NSLog(@"失败");
        }];
        
        MessageFrameModel *mf = [[MessageFrameModel alloc] init];
        mf.message = message;
        
        [self.view endEditing:YES];
        
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
                }else {
                    messageModel.type = MessageModelTypeOther;
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

#pragma mark - UIKeyboardNotification
- (void)keyBoardWillShow:(NSNotification *) notification
{
    NSDictionary *dict = notification.userInfo ;
    CGRect beginRect = [[dict objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyBoardFrame =  [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyBoardFrame.origin.y;
    CGFloat translationY = keyboardY - kScreenHeight;
    
    CGFloat time = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if(beginRect.size.height > 0 && (beginRect.origin.y - keyBoardFrame.origin.y > 0)){
        [UIView animateWithDuration:time animations:^{
            self->_tabTopConstraint.constant = translationY;
            self->_backViewBottomConstraint.constant = translationY;
            [self.view layoutIfNeeded];
            
            if (self.messages.count != 0) {
                NSIndexPath * path = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
                [self.mainTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }];
    }
}

- (void)keyBoardWillHide:(NSNotification *) notification
{
    NSDictionary *dict = notification.userInfo;
    CGFloat time = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:time animations:^{
        self->_tabTopConstraint.constant = 0;
        self->_backViewBottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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

#pragma mark ButtonMethod
- (IBAction)buttonAction:(id)sender
{
    if (sender == _emojiBtn) {
///表情按钮
        if (!_emojiBtn.selected) {
            [self.inputTextField resignFirstResponder];
            self.inputTextField.inputView = emojiKeyboard;
            [self.inputTextField reloadInputViews];
            [self.inputTextField becomeFirstResponder];
        }else {
            [self inputViewTapHandle];
        }
        _emojiBtn.selected = !_emojiBtn.selected;
        
    }else if (sender == _extentionBtn) {
///扩展功能按钮
        [self.inputTextField resignFirstResponder];
        self.inputTextField.inputView = extentionkeyboard;
        [self.inputTextField reloadInputViews];
        [self.inputTextField becomeFirstResponder];
    }else {
        
    }
}

- (void)inputViewTapHandle
{
    [self.inputTextField becomeFirstResponder];
    self.inputTextField.inputView = nil;
    [self.inputTextField reloadInputViews];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
