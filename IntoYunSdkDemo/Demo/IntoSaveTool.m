//
//  IntoSaveTool.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/11.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import "IntoSaveTool.h"

@implementation IntoSaveTool

// 读取数据
+ (id)objectForKey:(NSString *)defaultName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}

// 存储数据
+ (void)setObject:(id)value forKey:(NSString *)defaultName{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];

    // 强制写入
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)cacheDirPathWithFilePath:(NSString *)filePath
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [dir stringByAppendingPathComponent:[filePath lastPathComponent]];
}
+ (NSString *)documentDirPathWithFilePath:(NSString *)filePath
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [dir stringByAppendingPathComponent:[filePath lastPathComponent]];
}

+ (NSString *)tempDirPathWithFilePath:(NSString *)filePath
{
    NSString *dir = NSTemporaryDirectory();
    return [dir stringByAppendingPathComponent:[filePath lastPathComponent]];
}

@end
