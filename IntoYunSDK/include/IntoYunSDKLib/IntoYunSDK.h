//
//  Constants.h
//  IntoYunSDKDemo
//
//  Created by 梁惠源 on 16/8/10.
//  Copyright © 2016年 MOLMC. All rights reserved.
//


#ifndef IntoYunSDK_h
#define IntoYunSDK_h



#import "IntoYunSDKManager.h"
#import "IntoYunMQTTManager.h"


/** 日志输出 */
#ifdef DEBUG // 开发

#define IntoLog(...) NSLog(@"%s %d \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

#else // 发布

#define IntoLog(...)

#endif


#define IntoWeakSelf __weak typeof(self) weakSelf = self;

#endif /* IntoYunSDK_h */
