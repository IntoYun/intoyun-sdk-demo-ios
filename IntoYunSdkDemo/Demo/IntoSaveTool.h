//
//  IntoSaveTool.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/11.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntoSaveTool : NSObject


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


@end
