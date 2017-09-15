//
//  Constants.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/5/10.
//  Copyright © 2017年 hui he. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#ifdef DEBUG
// test 阿里云
#define API_Base_DOMAIN @"ghgylopenapi.intoyun.com"

// 设备下载地址
#define API_Download_DOMAIN @"ghgylwww.intoyun.com"

// HTTP请求服务器地址
#define API_Base_URL [NSString stringWithFormat:@"http://%@", API_Base_DOMAIN]

// 阿里云
#define MQTT_Base_DOMAIN @"ghgyliot.intoyun.com"

// 阿里云tcp
#define TCP_Base_DOMAIN @"ghgyliot.intoyun.com"

// 阿里云websocket
#define WS_Base_DOMAIN @"wss://ghgyliot.intoyun.com:8095/sub"

// test debug
#define LOG_DEBUG YES

#else

// 阿里云
#define API_Base_DOMAIN @"openapi.intoyun.com"

// 设备下载地址
#define API_Download_DOMAIN @"www.intoyun.com"

// HTTP请求服务器地址
#define API_Base_URL [NSString stringWithFormat:@"https://%@", API_Base_DOMAIN]
// 阿里云
#define MQTT_Base_DOMAIN @"iot.intoyun.com"

// 阿里云tcp
#define TCP_Base_DOMAIN @"iot.intoyun.com"

// 阿里云websocket
#define WS_Base_DOMAIN @"wss://iot.intoyun.com:8095/sub"

// test debug
#define LOG_DEBUG NO

#endif


// HTTP 端口号80
#define API_Base_PORT 80

// MQTT 端口号
#define MQTT_Base_PORT 1883

// MQTTS 端口号
#define MQTTS_Base_PORT 8883

// TCP 端口号
#define TCP_Base_PORT 8080

// TLS 端口号
#define TLS_Base_PORT 8085

// WS 端口号
#define WS_Base_PORT 8090

// WSS 端口号
#define WSS_Base_PORT 8095

#define API_CONFIG(url) [NSString stringWithFormat:@"%@/v1%@", API_Base_URL, url]
#define MQTT_CONFIG(url) [NSString stringWithFormat:@"%@%@", MQTT_Base_DOMAIN, url]


#define PROTO_MQTT          0  //mqtt
#define PROTO_TCP           1  //tcp
#define PROTO_WS            2  //websocket
#define PROTO_MQTT_TCP      3  //mqtt|tcp
#define PROTO_MQTT_WS       4  //mqtt|ws

//receive open
#define TCP_WS_CLIENT_OPEN  @"iSocketDidOpen"
//receive sms
#define TCP_WS_RECEIVE_SMS  @"iSocketDidReceiveSMS"
//receive meta
#define TCP_WS_RECEIVE_META  @"iSocketDidReceiveMETA"

#define dispatch_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }


/** 日志输出 */
#ifdef DEBUG // 开发

#define IntoLog(...) NSLog(@"%s %d \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

#else // 发布

#define IntoLog(...)

#endif

#endif /* Constants_h */
