//
//  IntoYunProtocol.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/19.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DatapointModel;

@interface IntoYunProtocol : NSObject

/**
 * 编码mqtt发送数据
 * @param datapoint     数据点model
 * @param value         发送的数据值
 * @param mProtocol     传输协议(json: json, binary: binary)；
 * @return              返回编码后的数据
 */
+ (NSString *) dataEncode:(DatapointModel *) datapoint value:(id)value dataProtocol:(NSString *)mProtocol;

+ (NSData *)dataDecode:(NSArray *)dataPoints resuleData:(NSData *)data;

@end
