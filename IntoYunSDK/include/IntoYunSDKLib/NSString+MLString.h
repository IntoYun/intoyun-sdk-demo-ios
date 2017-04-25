//
//  NSString+MLString.h
//  IntoYunSDKDemo
//
//  Created by 梁惠源 on 16/8/10.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MLString)
#pragma mark -加密
//md5加密（16位）
- (NSString *)md5;

// 加密算法
@property (readonly) NSString *md5String;
@property (readonly) NSString *sha1String;
@property (readonly) NSString *sha256String;
@property (readonly) NSString *sha512String;

- (NSString *)hmacMD5StringWithKey:(NSString *)key;
- (NSString *)hmacSHA1StringWithKey:(NSString *)key;
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

/* 获取时间戳秒 */
+ (NSString *)getTimeStamp;

/* 毫秒时间戳 例如 1443066826371 */
+ (NSString *)UUIDTimestamp;

/** 取得格式化时间 */
-(NSString *)getDateTimeString;

/** json字符串转为字典格式 */
-(NSDictionary *) dictionaryValue;
/** 手机号有效性 */
- (BOOL)isMobileNumber;
/** 邮箱有效性 */
-(BOOL)isValidateEmail;

- (BOOL)isEmpty;
/**
 *  随机多少位字符串
 *
 *  @param num 多少位
 *
 *  @return 随机字符串
 */
+ (NSString *)randomStrWithLength:(int)num;
@end
