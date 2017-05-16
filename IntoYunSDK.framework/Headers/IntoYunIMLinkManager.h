//
//  IntoYunIMLinkManager.h
//  IntoYunSDKDemo
//
//  Created by 梁惠源 on 16/8/12.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"


@protocol ImLinkDelegate <NSObject>

-(void)configSuccess:(id)response;

-(void)configError:(NSString *) errorStr;

@end


@interface IntoYunIMLinkManager : NSObject


/**********************************************/
/**************    ImLink接口      ***************/
/**********************************************/

@property (nonatomic, weak) id <ImLinkDelegate> delegete;

/**
 * 获取wifi ssid
 * @return  ssid
 */
- (NSString *)getSSID;

/**
 *  创建设备（IMLink）
 *
 *  @param wifiSSID     WiFi SSID
 *  @param wifiPassword      WiFi密码
 */
- (void)startImLinkConfig:(NSString *)wifiSSID
             wifiPassword:(NSString *)wifiPassword;


/**
 * 中断配置
 */
- (void)stopImLinkConfig:(BOOL)force;

@end
