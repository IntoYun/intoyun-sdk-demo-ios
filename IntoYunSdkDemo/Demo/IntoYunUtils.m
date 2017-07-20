//
//  IntoYunUtils.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/11.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import "IntoYunUtils.h"
#import "DeviceModel.h"
#import "DatapointModel.h"
#import "Macros.h"
#import "IntoYunFMDBTool.h"

@implementation IntoYunUtils

// 读取数据
+ (id)objectForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

// 存储数据
+ (void)setObject:(id)value forKey:(NSString *)defaultName {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];

    // 强制写入
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)cacheDirPathWithFilePath:(NSString *)filePath {
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [dir stringByAppendingPathComponent:[filePath lastPathComponent]];
}

+ (NSString *)documentDirPathWithFilePath:(NSString *)filePath {
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [dir stringByAppendingPathComponent:[filePath lastPathComponent]];
}

+ (NSString *)tempDirPathWithFilePath:(NSString *)filePath {
    NSString *dir = NSTemporaryDirectory();
    return [dir stringByAppendingPathComponent:[filePath lastPathComponent]];
}


+ (NSMutableArray *)filterTriggerDevices:(NSArray *)devices {
    NSMutableArray *filter = [NSMutableArray array];
    NSMutableDictionary *boardInfoDic =  [NSMutableDictionary dictionaryWithDictionary:[IntoYunUtils objectForKey:BOARD_INFO]];
    for (DeviceModel *deviceModel in devices) {
        NSString *accessMode = [[boardInfoDic objectForKey:deviceModel.board] objectForKey:@"accessMode"];
        if ([deviceModel.deviceId isEqualToString:SYSTEM_DEVICE_ID]) {
            [filter addObject:deviceModel];
        } else if (![accessMode isEqualToString:@"LoRa"] && [self filterTriggerDatapoints:[IntoYunFMDBTool getDatapointListArray:deviceModel.pidImp]].count > 0) {
            [filter addObject:deviceModel];
        }
    }
    return filter;
}

+ (NSMutableArray *)filterTriggerDatapoints:(NSArray *)datapoints {
    NSMutableArray *filter = [NSMutableArray array];
    for (DatapointModel *datapointModel in datapoints) {
        if (datapointModel.direction != DIRECTION_CMD &&
                ([datapointModel.type isEqualToString:NUMBER_DT] ||
                        [datapointModel.type isEqualToString:BOOL_DT] ||
                        [datapointModel.type isEqualToString:ENUM_DT] ||
                        [datapointModel.type isEqualToString:TIMER_DT])) {
            [filter addObject:datapointModel];
        }
    }
    return filter;
}


+ (NSMutableArray *)filterActionDevices:(NSArray *)devices {
    NSMutableArray *filter = [NSMutableArray array];
    NSMutableDictionary *boardInfoDic = [NSMutableDictionary dictionaryWithDictionary:[IntoYunUtils objectForKey:BOARD_INFO]];
    for (DeviceModel *deviceModel in devices) {
        NSString *accessMode = [[boardInfoDic objectForKey:deviceModel.board] objectForKey:@"accessMode"];
        if ([deviceModel.deviceId isEqualToString:SYSTEM_DEVICE_ID]) {
            [filter addObject:deviceModel];
        } else if (![accessMode isEqualToString:@"LoRa"] && [self filterActionDatapoints:[IntoYunFMDBTool getDatapointListArray:deviceModel.pidImp]].count > 0) {
            [filter addObject:deviceModel];
        }
    }
    return filter;
}

+ (NSMutableArray *)filterActionDatapoints:(NSArray *)datapoints {
    NSMutableArray *filter = [NSMutableArray array];
    for (DatapointModel *datapointModel in datapoints) {
        if (datapointModel.direction != DIRECTION_DATA &&
                ([datapointModel.type isEqualToString:NUMBER_DT] ||
                        [datapointModel.type isEqualToString:BOOL_DT] ||
                        [datapointModel.type isEqualToString:ENUM_DT] ||
                        [datapointModel.type isEqualToString:EMAIL_DT] ||
                        [datapointModel.type isEqualToString:MESSAGE_DT] ||
                        [datapointModel.type isEqualToString:STRING_DT])) {
            [filter addObject:datapointModel];
        }
    }
    return filter;
}

+ (NSString *)getDatapointName:(DatapointModel *)datapointModel {
    if ([[self getCurrentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
            [[self getCurrentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        // lang = zh;
        return datapointModel.nameCn;
    } else {
        // lang = en;
        return datapointModel.nameEn;
    }
}


+ (NSString *)getCurrentLanguage {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

+ (NSString *)getCurrentTime {
    // 获取系统当前时间
    NSDate *date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate *currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];

    //设置时间输出格式：
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm:ss"];
    NSString *na = [df stringFromDate:currentDate];
    return na;
}

+(int)getTimeZone{
    NSDate *date = [NSDate date];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSTimeInterval time = [timeZone secondsFromGMTForDate:date];
    int zone = time / 3600;
    return zone;
}

+(NSString *)getTheCorrectNum:(NSString *)time{
    NSLog(@"leng: %d", (int)[time length]);
    if ([time length]==1){
        return [NSString stringWithFormat:@"0%@",time];
    } else if([time length] <= 0){
        return @"00";
    }
    return time;
}

+(NSString *)toDecimal:(float) value DataPoint:(DatapointModel *)datapointModel{
    NSString* format = [NSString stringWithFormat:@"%%.%df", datapointModel.resolution];
    return [NSString stringWithFormat:format, value];
}

+(NSInteger) parseDataPointType:(DatapointModel*) datapointModel{
    if ([datapointModel.type isEqualToString:BOOL_DT]) {
        return 0;
    } else if ([datapointModel.type isEqualToString:NUMBER_DT]) {
        return 1;
    } else if ([datapointModel.type isEqualToString:ENUM_DT]) {
        return 2;
    } else if ([datapointModel.type isEqualToString:STRING_DT]) {
        return 3;
    } else if ([datapointModel.type isEqualToString:EXTRA_DT]) {
        return 4;
    }
    return 0;
}

//将数值型数据装换成服务器的整形数据
+(int) parseData2Int:(float)data Datapoint:(DatapointModel *)datapointModel{
    return (data - datapointModel.min) * pow(10, datapointModel.resolution);
}


//将服务器的整形数据装换回数值类型数据
+(float) parseData2Float:(int)data Datapoint:(DatapointModel *)datapointModel{
    return data/pow(10, datapointModel.resolution) + datapointModel.min;
}

@end
