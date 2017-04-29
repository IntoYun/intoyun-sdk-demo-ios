//
//  IntoSystemDevice.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/26.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import "IntoSystemDevice.h"
#import "DeviceModel.h"

@implementation IntoSystemDevice

+ (instancetype)shareSystemDevice
{
    return [[self alloc] init];
}

static IntoSystemDevice *_instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *widgetPath = [[NSBundle mainBundle] pathForResource:@"SystemDevice.plist" ofType:nil];
        NSDictionary *systemDic = [NSDictionary dictionaryWithContentsOfFile:widgetPath];
        _instance = (id)[DeviceModel mj_objectWithKeyValues:systemDic];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    // 因为copy方法必须通过实例对象调用, 所以可以直接返回_instance
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

@end
