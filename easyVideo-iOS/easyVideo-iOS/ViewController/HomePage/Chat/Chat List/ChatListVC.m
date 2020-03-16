//
//  ChatListVC.m
//  HexMeet
//
//  Created by quanhao huang on 2019/11/8.
//  Copyright © 2019 fo. All rights reserved.
//

#import "ChatListVC.h"

@interface ChatListVC ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ChatListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createRightItemWithImage:[UIImage imageNamed:@"icon_new"] action:@selector(rightAction:)];
    
    __weak typeof(self)  weakSelf = self;
    self.chatListTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [weakSelf.chatListTab.mj_header endRefreshing];
        });
    }];
}

- (void)rightAction:(UIButton *)sender
{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatListCell *cell = [ChatListCell cellWithTableView:tableView];
    if (indexPath.row % 2) {
        cell.reminderImg.hidden = YES;
        cell.reminderBg.hidden = YES;
        cell.unreadMessageBg.hidden = NO;
    }else {
        cell.reminderImg.hidden = NO;
        cell.reminderBg.hidden = NO;
        cell.unreadMessageBg.hidden = YES;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatPageViewController *chat = [[ChatPageViewController alloc] init];
    chat.hidesBottomBarWhenPushed = YES;
    chat.backBool = YES;
    [self.navigationController pushViewController:chat animated:YES];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
