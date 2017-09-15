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



/** 日志输出 */
#ifdef DEBUG // 开发

#define IntoLog(...) NSLog(@"%s %d \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

#else // 发布

#define IntoLog(...)

#endif

#define IntoWeakSelf __weak typeof(self) weakSelf = self;
#endif /* IntoYunSDK_h */

