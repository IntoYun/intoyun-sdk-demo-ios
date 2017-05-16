//
//  IntoDeviceInfoViewController.h
//  IntoYunSDKDemo
//
//  Created by 梁惠源 on 16/8/16.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeviceModel;

typedef void(^changeSuccessBlock) ();
@interface IntoDeviceInfoViewController : UIViewController
/** 设备数据 */
@property (nonatomic,strong) DeviceModel *deviceDic;

/** 修改成功的回调 */
@property (nonatomic,copy) changeSuccessBlock changeSuccess;

@end
