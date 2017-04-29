//
//  IntoYunUtils.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/11.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DatapointModel;

@interface IntoYunUtils : NSObject


// 读取数据
+ (id)objectForKey:(NSString *)defaultName;

// 存储数据
+ (void)setObject:(id)value forKey:(NSString *)defaultName;

/**
 *  生成缓存目录全路径
 */
+ (NSString *)cacheDirPathWithFilePath:(NSString *)filePath;
/**
 *  生成文档目录全路径
 */
+ (NSString *)documentDirPathWithFilePath:(NSString *)filePath;
/**
 *  生成临时目录全路径
 */
+ (NSString *)tempDirPathWithFilePath:(NSString *)filePath;

// 过滤出triggerdevice
+(NSMutableArray *)filterTriggerDevices:(NSArray *)devices;

// 过滤出trigger datapoint
+(NSMutableArray *)filterTriggerDatapoints:(NSArray *)datapoints;

// 过滤出action device
+(NSMutableArray *)filterActionDevices:(NSArray *)devices;

// 过滤出action datapoint
+(NSMutableArray *)filterActionDatapoints:(NSArray *)datapoints;

// 获取datapoint名称
+(NSString *)getDatapointName:(DatapointModel *)datapointModel;

// 获取当前系统语言
+ (NSString *)getCurrentLanguage;

// 获取当前时间的时分
+ (NSString *)getCurrentTime;

// 获取时区
+(int)getTimeZone;

// 获取两位数字
+(NSString *)getTheCorrectNum:(NSString *)time;
@end