//
//  IntoControlDeviceViewController.h
//  IntoYunSDKDemo
//
//  Created by 梁惠源 on 16/8/20.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntoYunSDK.h"

@class DeviceModel;
@class DatapointModel;

@interface IntoControlDeviceViewController : UIViewController
/** 设备 */
@property (nonatomic, strong) DeviceModel *deviceModel;
/** datapoint */
@property (nonatomic, strong) NSArray *datapointArray;
/** 用户信息 */
@property (nonatomic, strong) NSDictionary *userData;

@end
