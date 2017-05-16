//
//  IntoMessageTableViewController.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/7.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefreshNormalHeader.h>
#import "IntoMessageTableViewController.h"
#import "IntoYunSDK.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+IntoYun.h"
#import "IntoMessageCell.h"

@interface IntoMessageTableViewController ()<UIActionSheetDelegate>

//消息数组
@property(nonatomic, strong) NSMutableArray *messageArray;
//选中message数据
@property(nonatomic, strong) NSDictionary *selectedMessage;

@end

@implementation IntoMessageTableViewController


- (NSMutableArray *)messageArray {
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self loadMessageData];



    // Set the callback（Once you enter the refresh status，then call the action of target，that is call [self loadNewData]）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMessageData)];

    // Enter the refresh status immediately
    [self.tableView.mj_header beginRefreshing];

}

- (void)setNavigation {
    self.navigationItem.title = NSLocalizedString(@"message_title", nil);
    self.tabBarItem.badgeValue = @"2";
    self.tableView.tableFooterView = [[UIView alloc] init];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }

    
    // clear
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.frame = CGRectMake(0, 0, 40, 40);
    scanButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    scanButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [scanButton setTitle:NSLocalizedString(@"clear", nil) forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(onClickClearButton) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *rightMaxBt = [[UIBarButtonItem alloc] initWithCustomView:scanButton];

    
    NSArray *buttonItem = @[rightMaxBt];
    self.navigationItem.rightBarButtonItems = buttonItem;
    
}

- (void)loadMessageData {
    IntoWeakSelf;
    [IntoYunSDKManager getMessages:@"1"
                      successBlock:^(id responseObject) {
                          [weakSelf.tableView.mj_header endRefreshing];
                          weakSelf.messageArray = [IntoMessageModel mj_objectArrayWithKeyValuesArray:responseObject];
                          [weakSelf.tableView reloadData];
                      }
                        errorBlock:^(NSInteger code, NSString *errorStr) {
                            [weakSelf.tableView.mj_header endRefreshing];
                            [MBProgressHUD showError:errorStr];
                        }];
}

-(void) onClickClearButton{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"message_delete_tip", nil)
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                         destructiveButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        IntoWeakSelf;
        // 时间戳转时间
        long timestamp = (long) [[NSDate date] timeIntervalSince1970];
        [IntoYunSDKManager deleteMessages:timestamp successBlock:^(id responseObject){
            [weakSelf.messageArray removeAllObjects];
            [weakSelf.tableView reloadData];
        } errorBlock:^(NSInteger errCode, NSString *errorStr){
            [MBProgressHUD showError:errorStr];
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IntoMessageCell *cell = [IntoMessageCell cellWithTable:tableView Style:UITableViewCellStyleDefault reuseIdentifier:@"messageCell"];

    // Configure the cell...
    cell.messageModel = self.messageArray[indexPath.row];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedMessage = self.messageArray[indexPath.row];
    NSLog(@"selected row: %ld", (long) indexPath.row);
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    IntoMessageModel *messageModel = self.messageArray[indexPath.row];
    IntoWeakSelf;

    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [IntoYunSDKManager deleteMessageById:messageModel.ID
                                successBlock:^(id responseObject) {
                                    [weakSelf.messageArray removeObjectAtIndex:indexPath.row];
                                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                    [MBProgressHUD showSuccess:@"删除成功"];
                                }
                                  errorBlock:^(NSInteger code, NSString *errorStr) {
                                      [MBProgressHUD showError:errorStr];
                                  }];
    }];

    return @[action1];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


@end
