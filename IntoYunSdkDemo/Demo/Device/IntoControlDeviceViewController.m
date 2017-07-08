//
//  IntoControlDeviceViewController.m
//  IntoYunSDKDemo
//
//  Created by 梁惠源 on 16/8/20.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "IntoControlDeviceViewController.h"
#import "IntoYunSDK.h"
#import "MBProgressHUD+IntoYun.h"
#import "IntoDatapointBoolView.h"
#import "DeviceModel.h"
#import "Macros.h"
#import "IntoDatapointStringView.h"
#import "IntoDatapointNumberView.h"
#import "IntoDatapointEnumView.h"
#import "IntoDatapointExtraView.h"
#import "DTKDropdownMenuView.h"
#import "IntoDeviceInfoViewController.h"

@interface IntoControlDeviceViewController () <IntoYunMQTTManagerDelegate, UITextFieldDelegate, SendDataDelegate, UIActionSheetDelegate>

@property(weak, nonatomic) IBOutlet UIScrollView *contentView;

@property(nonatomic, strong) NSMutableDictionary<NSString *, BaseDatapointView *> *datapointViews;

@end

@implementation IntoControlDeviceViewController

static int ITEM_HEIGHT = 80;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = self.deviceModel.name;
    [self setNavigation];
    [self loadDeviceInfo];

    [[IntoYunMQTTManager shareInstance] subscribeDataFromDeviceWithDeviceModel:self.deviceModel
                                                     datapoints:self.datapointArray
                                                       delegate:self
                                               subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
                                                   [self getDeviceStatus];
                                               }];

    //注册键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)setNavigation {
    IntoWeakSelf;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nill) style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:NSLocalizedString(@"device_info", nil) iconName:nil callBack:^(NSUInteger index, id info) {
        [weakSelf performSegueWithIdentifier:@"deviceInfo" sender:nil];
    }];
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:NSLocalizedString(@"device_delete", nil) iconName:nil callBack:^(NSUInteger index, id info) {
        [weakSelf actionSheet];
    }];

    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 44.f, 2 * 44.f) dropdownItems:@[item0, item1] icon:@"deviceMore"];
    menuView.dropWidth = 130.f;
    menuView.textColor = [UIColor blackColor];
    menuView.cellSeparatorColor = [UIColor grayColor];
    menuView.textFont = [UIFont systemFontOfSize:14.f];
    menuView.animationDuration = 0.1f;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuView];
}


- (BaseDatapointView *)getLastStringView {
    for (uint16_t i = self.datapointArray.count - 1; i >= 0; i--) {
        DatapointModel *datapoint = self.datapointArray[i];
        if ([datapoint.type isEqualToString:STRING_DT]) {
            return [self.datapointViews valueForKey:[NSString stringWithFormat:@"%d", datapoint.dpId]];
        }
    }
    return nil;
}


- (void)actionSheet {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"device_delete_tip", nil)
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                         destructiveButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    IntoWeakSelf;
    if (buttonIndex == 0) {
        [IntoYunSDKManager deleteDeviceById:self.deviceModel.deviceId successBlock:^(id response) {
            [MBProgressHUD showSuccess:NSLocalizedString(@"delete_success", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }                        errorBlock:^(NSInteger code, NSString *err) {
            [MBProgressHUD showError:err];
        }];
    }
}

//键盘弹出后将视图向上移动
- (void)keyboardWillShow:(NSNotification *)note {
    BaseDatapointView *lastTextField = [self getLastStringView];
    if (lastTextField == nil) {
        return;
    }
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //目标视图UITextField
    CGRect frame = lastTextField.frame;
    int y = frame.origin.y + frame.size.height - (self.view.frame.size.height - keyboardSize.height);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if (y > 0) {
        self.view.frame = CGRectMake(0, -y, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}

//键盘隐藏后将视图恢复到原始状态
- (void)keyboardWillHide:(NSNotification *)note {
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}


- (void)getDeviceStatus {
    [[IntoYunMQTTManager shareInstance] getDeviceStatusWithDeviceModel:self.deviceModel delegate:self];
}

- (void)loadDeviceInfo {
    self.datapointViews = [[NSMutableDictionary alloc] init];
    int count = 0;
    for (DatapointModel *datapointModel in self.datapointArray) {
        CGRect cgRect = CGRectMake(10, 5 + count * ITEM_HEIGHT, self.view.bounds.size.width - 20, ITEM_HEIGHT);
        if ([datapointModel.type isEqualToString:BOOL_DT]) {
            IntoDatapointBoolView *boolView = [[IntoDatapointBoolView alloc] initWithFrame:cgRect datapoint:datapointModel];
            boolView.delegete = self;
            [self.contentView addSubview:boolView];
            [self.datapointViews setObject:boolView forKey:[NSString stringWithFormat:@"%d", datapointModel.dpId]];
            count++;
        } else if ([datapointModel.type isEqualToString:NUMBER_DT]) {
            IntoDatapointNumberView *numberView = [[IntoDatapointNumberView alloc] initWithFrame:cgRect datapoint:datapointModel];
            numberView.delegete = self;
            [self.contentView addSubview:numberView];
            [self.datapointViews setObject:numberView forKey:[NSString stringWithFormat:@"%d", datapointModel.dpId]];
            count++;
        } else if ([datapointModel.type isEqualToString:STRING_DT]) {
            IntoDatapointStringView *stringView = [[IntoDatapointStringView alloc] initWithFrame:cgRect datapoint:datapointModel];
            stringView.delegete = self;
            [self.contentView addSubview:stringView];
            [self.datapointViews setObject:stringView forKey:[NSString stringWithFormat:@"%d", datapointModel.dpId]];
            count++;
        } else if ([datapointModel.type isEqualToString:ENUM_DT]) {
            IntoDatapointEnumView *enumView = [[IntoDatapointEnumView alloc] initWithFrame:cgRect datapoint:datapointModel];
            enumView.delegete = self;
            [self.contentView addSubview:enumView];
            [self.datapointViews setObject:enumView forKey:[NSString stringWithFormat:@"%d", datapointModel.dpId]];
            count++;
        } else if ([datapointModel.type isEqualToString:EXTRA_DT]) {
            IntoDatapointExtraView *extraView = [[IntoDatapointExtraView alloc] initWithFrame:cgRect datapoint:datapointModel];
            extraView.delegete = self;
            [self.contentView addSubview:extraView];
            [self.datapointViews setObject:extraView forKey:[NSString stringWithFormat:@"%d", datapointModel.dpId]];
            count++;
        }
    }
    self.contentView.bounces = YES;
    self.contentView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.contentView.contentSize = CGSizeMake(self.view.bounds.size.width, ITEM_HEIGHT * count);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


/**
 *   跳转之前的准备
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"deviceInfo"]) {
//        IntoWeakSelf;
        IntoDeviceInfoViewController *deviceInfoVC = segue.destinationViewController;
        deviceInfoVC.deviceDic = self.deviceModel;
    } else if ([segue.identifier isEqualToString:@"controlDevice"]) {
//        IntoControlDeviceViewController *controlDeviceVC = segue.destinationViewController;
    }
}


- (void)messageTopic:(NSString *)topic data:(NSData *)dic {
    // 收到的数据
    NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:dic options:NSJSONReadingMutableLeaves error:nil];
    for (NSString *dpid in result) {
        [[self.datapointViews valueForKey:dpid] receiveData:[result valueForKey:dpid]];
    }
}

- (void)messageDelivered:(UInt16)msgID {
    NSLog(@"send data: %d", msgID);
}

- (void)sendData:(id)value datapoint:(DatapointModel *)datapoint {
    NSLog(@"send data: %@", value);
    [[IntoYunMQTTManager shareInstance] sendDataToDevice:self.deviceModel datapoint:datapoint value:value delegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[IntoYunMQTTManager shareInstance] unSubscribeDataFromDeviceWithDeviceModel:self.deviceModel];
}

@end
