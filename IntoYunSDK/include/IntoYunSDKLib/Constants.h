//
//  Constants.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/5/10.
//  Copyright © 2017年 hui he. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

// 阿里云
#define API_Base_DOMAIN @"openapi.intoyun.com"

// 设备下载地址
#define API_Download_DOMAIN @"www.intoyun.com"

// HTTP请求服务器地址
#define API_Base_URL [NSString stringWithFormat:@"https://%@", API_Base_DOMAIN]
// 阿里云
#define MQTT_Base_DOMAIN @"iot.intoyun.com"

//// test 阿里云
//#define API_Base_DOMAIN @"ghgylopenapi.intorobot.com"

// 设备下载地址
//#define API_Download_DOMAIN @"ghgylyun.intorobot.com"

//// HTTP请求服务器地址
//#define API_Base_URL [NSString stringWithFormat:@"http://%@", API_Base_DOMAIN]
//
//// 阿里云
//#define MQTT_Base_DOMAIN @"ghgylyuniot.intorobot.com"


// HTTP 端口号8088
#define API_Base_PORT 80

// MQTT 端口号
#define MQTT_Base_PORT 1883

#define API_CONFIG(url) [NSString stringWithFormat:@"%@/v1%@", API_Base_URL, url]
#define MQTT_CONFIG(url) [NSString stringWithFormat:@"%@%@", MQTT_Base_DOMAIN, url]


#endif /* Constants_h */
