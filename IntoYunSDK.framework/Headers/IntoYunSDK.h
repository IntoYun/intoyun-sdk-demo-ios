//
//  IntoYunSDK.h
//  IntoYunSDK
//
//  Created by hui he on 17/4/24.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IntoYunSDK/IntoYunSDKManager.h>
#import <IntoYunSDK/IntoYunMQTTManager.h>
#import <IntoYunSDK/DeviceModel.h>
#import <IntoYunSDK/RecipeModel.h>
#import <IntoYunSDK/DatapointModel.h>

//! Project version number for IntoYunSDK.
FOUNDATION_EXPORT double IntoYunSDKVersionNumber;

//! Project version string for IntoYunSDK.
FOUNDATION_EXPORT const unsigned char IntoYunSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <IntoYunSDK/PublicHeader.h>



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
