//
//  IntoYunSDKErrorInfo.h
//  IntoYunSDKDemo
//
//  Created by 梁惠源 on 16/8/10.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntoYunSDKErrorInfo : NSObject


+ (NSMutableDictionary *)httpStatusError:(NSError *)error;


@end
