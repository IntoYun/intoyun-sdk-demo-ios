//
//  IntoYunSDKLib.h
//  IntoYunSDKLib
//
//  Created by hui he on 17/4/25.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntoYunSDKManager.h"
#import "IntoYunMQTTManager.h"
#import "IntoYunAPIManager.h"
#import "IntoMQTTSessionManager.h"
#import "IntoYunSDKErrorInfo.h"
#import "DeviceModel.h"
#import "RecipeModel.h"
#import "TriggerValModel.h"
#import "ActionValModel.h"
#import "CrontabModel.h"
#import "DatapointModel.h"
#import "NSString+MLString.h"

#ifndef IntoYunSDK_h
#define IntoYunSDK_h




// 阿里云
#define API_Base_DOMAIN @"www.intoyun.com"

// HTTP请求服务器地址
#define API_Base_URL [NSString stringWithFormat:@"https://%@", API_Base_DOMAIN]

// HTTP 端口号
#define API_Base_PORT 80

// 阿里云
#define MQTT_Base_DOMAIN @"iot.intoyun.com"

// MQTT 端口号
#define MQTT_Base_PORT 1883

#define API_CONFIG(url) [NSString stringWithFormat:@"%@/v1%@", API_Base_URL, url]
#define MQTT_CONFIG(url) [NSString stringWithFormat:@"%@%@", MQTT_Base_DOMAIN, url]

/** 日志输出 */
#ifdef DEBUG // 开发

#define IntoLog(...) NSLog(@"%s %d \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

#else // 发布

#define IntoLog(...)

#endif

#define IntoWeakSelf __weak typeof(self) weakSelf = self;
#endif /* IntoYunSDK_h */
