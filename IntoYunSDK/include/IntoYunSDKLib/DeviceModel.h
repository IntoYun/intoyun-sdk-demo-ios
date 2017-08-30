//
//  DeviceModel.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/10.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceModel : NSObject

@property (nonatomic,copy) NSString *deviceDescription;
@property (nonatomic,copy) NSString *deviceId;
@property (nonatomic,assign) long long bindAt;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *pidImp;
@property (nonatomic,copy) NSString *accessMode;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *bindUser;
@property (nonatomic,copy) NSString *board;
@property (nonatomic,copy) NSString *imgSrc;
@property (nonatomic,copy) NSString *proto;


@property (nonatomic,assign) bool online;

//在线状态，本地使用
@property (nonatomic, assign) bool status;

@end
