//
//  SelectActionViewController.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/28.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "SelectActionViewController.h"
#import "Macros.h"
#import "DataPointTableViewCell.h"
#import "SetActionViewController.h"
#import "DeviceCollectionViewCell.h"
#import "IntoYunUtils.h"
#import "IntoSystemDatapoints.h"
#import "IntoYunFMDBTool.h"
#import "IntoSystemDevice.h"

@interface SelectActionViewController ()<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) UIScrollView *contentScrollView;

@property(nonatomic, weak) UICollectionView *deviceCollectionView;
@property(nonatomic, weak) UITableView *dataPointTableView;

@property(nonatomic, strong) NSMutableArray *deviceArray;
@property(nonatomic, strong) NSMutableArray *dataPointArray;

//选中的trigger device
@property(nonatomic, strong) DeviceModel *selectedDevice;
//选择的数据点
@property(nonatomic, strong) DatapointModel *selectedDatapoint;

@end

@implementation SelectActionViewController


float devicePerPage1 = 6.0f;

- (NSMutableArray *)deviceArray {
    if (!_deviceArray) {
        _deviceArray = [NSMutableArray array];
    }
    return _deviceArray;
}

- (NSMutableArray *)dataPointArray {
    if (!_dataPointArray) {
        _dataPointArray = [NSMutableArray array];
    }
    return _dataPointArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigation];
    [self initData];
    [self initView];
}

- (void)setNavigation {
    self.navigationItem.title = NSLocalizedString(@"select_action", nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nill) style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)initData {
    NSArray *mDeviceArray = [IntoYunFMDBTool getDeviceListArray];
    DeviceModel *systemDevice = (DeviceModel *) [IntoSystemDevice shareSystemDevice];

    [self.deviceArray addObject:systemDevice];
    [self.deviceArray addObjectsFromArray:[IntoYunUtils filterActionDevices:mDeviceArray]];
    self.dataPointArray = [IntoYunUtils filterActionDatapoints:(NSArray *) [IntoSystemDatapoints shareAllDatapoints]];
    self.selectedDevice = systemDevice;
    self.selectedDatapoint = self.dataPointArray[0];
}

- (void)initView {
    self.view.backgroundColor = SetColor(0xf6, 0xf6, 0xf6, 1.0);

    CGRect bounds = self.view.frame;  //获取界面区域
    //界面所有内容scrollview
    UIScrollView *frameScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
    [frameScrollView setContentSize:frameScrollView.frame.size];
    frameScrollView.bounces = NO;

    //选择设备列表collectionview
    //1.初始化layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    UICollectionView *deviceCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, MLScreenW, 200) collectionViewLayout:flowLayout];
    deviceCollectionView.backgroundColor = SetColor(0xeb, 0xeb, 0xeb, 1.0);
    deviceCollectionView.showsHorizontalScrollIndicator = NO;
    [deviceCollectionView registerClass:[DeviceCollectionViewCell class] forCellWithReuseIdentifier:@"deviceCollectionCell"];

    deviceCollectionView.dataSource = self;
    deviceCollectionView.delegate = self;

    [frameScrollView addSubview:deviceCollectionView];
    self.deviceCollectionView = deviceCollectionView;



    //选择触发条件titleview
    //    UIView *titleView = [[UIView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"select_action_title", nil);
    titleLabel.backgroundColor = DividerColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = SetColor(0x23, 0x22, 0x22, 1.0);
    [frameScrollView addSubview:titleLabel];

    //添加tableview
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [frameScrollView addSubview:tableView];
    self.dataPointTableView = tableView;


    [self.view addSubview:frameScrollView];
    self.contentScrollView = frameScrollView;


    [frameScrollView mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.left.mas_equalTo(frameScrollView.superview.mas_left).offset(0);
        maker.right.mas_equalTo(frameScrollView.superview.mas_right).offset(0);
        maker.top.mas_equalTo(frameScrollView.superview.mas_top).offset(0);
        maker.bottom.mas_equalTo(frameScrollView.superview.mas_bottom).offset(0);
    }];

    [deviceCollectionView mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(deviceCollectionView.superview.mas_top);
        maker.height.mas_equalTo(220);
        maker.width.mas_equalTo(self.view.mas_width);
    }];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(deviceCollectionView.mas_bottom).offset(0);
        maker.left.mas_equalTo(titleLabel.superview.mas_left).offset(0);
        maker.right.mas_equalTo(titleLabel.superview.mas_right).offset(0);
        maker.width.mas_equalTo(titleLabel.superview.mas_width);
        maker.height.mas_equalTo(40);
    }];

    [tableView mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(titleLabel.mas_bottom).offset(0);
        maker.bottom.mas_equalTo(self.view.mas_bottom).offset(-10);
        maker.left.mas_equalTo(tableView.superview.mas_left).offset(0);
        maker.right.mas_equalTo(tableView.superview.mas_right).offset(0);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return (int) ceilf(self.deviceArray.count / devicePerPage1);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ((section + 1) < (int) ceilf(self.deviceArray.count / devicePerPage1)) {
        return 6;
    } else {
        int count = self.deviceArray.count % 6;
        if (count == 0) {
            count = 6;
        }
        return count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DeviceCollectionViewCell *deviceCell = [DeviceCollectionViewCell cellWithCollection:collectionView reuseIdentifier:@"deviceCollectionCell" cellForItemAtIndexPath:indexPath];
    deviceCell.deviceModel = self.deviceArray[indexPath.section * 6 + indexPath.row];
    return deviceCell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DeviceModel *device = self.deviceArray[indexPath.section * 6 + indexPath.row];
    if ([device.deviceId isEqualToString:SYSTEM_DEVICE_ID]) {
        self.dataPointArray = [IntoYunUtils filterActionDatapoints:(NSArray *) [IntoSystemDatapoints shareAllDatapoints]];
    } else {
        self.dataPointArray = [IntoYunUtils filterActionDatapoints:(NSArray *) [IntoYunFMDBTool getDatapointListArray:device.pidImp]];
    }
    [self.dataPointTableView reloadData];
    self.selectedDevice = device;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.deviceCollectionView.frame.size.width / 3, self.deviceCollectionView.frame.size.height / 2);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataPointArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DataPointTableViewCell *cell = [DataPointTableViewCell cellWithTable:tableView];
    cell.datapointModel = self.dataPointArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectedDatapoint = self.dataPointArray[indexPath.row];
    [self setActionRecip:self.selectedDevice dataPoint:self.selectedDatapoint];

    SetActionViewController *setActionViewController = [[SetActionViewController alloc] init];
    setActionViewController.createRecipe = self.createRecipe;
    setActionViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setActionViewController animated:YES];

}

- (void)setActionRecip:(DeviceModel *)selectedDevice dataPoint:(DatapointModel *)selectedDatapoint {
    //add device id
    NSMutableArray *devices = [NSMutableArray arrayWithCapacity:2];
    [devices addObject:self.createRecipe.devices.firstObject];
    [devices addObject:selectedDevice.deviceId];
    self.createRecipe.devices = devices;

    //add product id
    NSMutableArray *products = [NSMutableArray arrayWithCapacity:2];
    [products addObject:self.createRecipe.prdIds.firstObject];
    [products addObject:selectedDevice.pidImp];
    self.createRecipe.prdIds = products;

    //add datapoint id
    NSMutableArray *datapoints = [NSMutableArray arrayWithCapacity:2];
    [datapoints addObject:self.createRecipe.dpIds.firstObject];
    [datapoints addObject:[NSNumber numberWithInt:selectedDatapoint.dpId]];
    self.createRecipe.dpIds = datapoints;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ActionValModel *actionValModel = [[ActionValModel alloc] init];
    if ([selectedDatapoint.type isEqualToString:RECIPE_ACTION_EMAIL]){
        actionValModel.type = RECIPE_ACTION_EMAIL;
        actionValModel.to = [defaults valueForKey:@"email"];
    } else if ([selectedDatapoint.type isEqualToString:RECIPE_ACTION_MSGBOX]){
        NSString *to = [NSString stringWithFormat:@"v2/user/%@/rx", [defaults valueForKey:@"uid"]];
        actionValModel.type = RECIPE_ACTION_MSGBOX;
        actionValModel.to = to;
    } else {
        NSString *to;
        if ([IntoYunSDKManager isLoRaNode:selectedDevice.board]){
            to = [NSString stringWithFormat:@"v2/lora/%@/tx", selectedDevice.deviceId];
        } else {
            to = [NSString stringWithFormat:@"v2/device/%@/tx", selectedDevice.deviceId];
        }
        actionValModel.type = RECIPE_ACTION_MQTT;
        actionValModel.to = to;
    }
    actionValModel.dpId = selectedDatapoint.dpId;
    actionValModel.dpType = (int)[IntoYunUtils parseDataPointType:selectedDatapoint];
    NSMutableArray *actionValArray = [NSMutableArray array];
    [actionValArray addObject:actionValModel];
    self.createRecipe.actionVal = actionValArray;
}

@end
