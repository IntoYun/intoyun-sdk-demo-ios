//
//  IntoYunProtocol.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/19.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DatapointModel;

typedef enum {
    AUTH = 0,
    AUTH_REPLY,
    HEARTBEAT,
    HEARTBEAT_REPLY,
    SEND_SMS,
    SEND_SMS_REPLY,
    TCPWS_ACTION,
    TCPWS_ACTION_REPLY,
    DEV_DBG,
    DEV_DBG_REPLY,
    SEND_META,
    SEND_META_REPLY,
    RAW

}TCPWS_TYPE;

@interface IntoYunProtocol : NSObject


/**
 * 编码mqtt发送数据
 * @param datapoint     数据点model
 * @param value         发送的数据值
 * @param mProtocol     传输协议(json: json, binary: binary)；
 * @return              返回编码后的数据
 */
+ (NSData *)dataEncode:(DatapointModel *)datapoint value:(id)value dataProtocol:(NSString *)mProtocol;

+ (NSData *)dataDecode:(NSArray *)dataPoints resuleData:(NSData *)data;

/**
 * tcp/ws 数据编码，发送数据
 * @param payload
 * @param type
 * @return
 */
+ (NSData *)tcpwsEncode:(NSData *)payload protoType:(NSInteger)type;

/**
 * tcp/ws 数据界面，接收数据
 * @param payload
 * @return
 */
+ (NSDictionary *)tcpwsDecode:(NSData *)payload;

@end
