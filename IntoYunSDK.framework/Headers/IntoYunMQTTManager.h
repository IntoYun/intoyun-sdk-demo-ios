//
//  IntoYunMQTTManager.h
//  IntoYunSDKDemo
//
//  Created by 梁惠源 on 16/8/13.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import <MQTTClient/MQTTSession.h>
#import "Constants.h"
#import "MJExtension.h"
#import "IntoMQTTSessionManager.h"
#import "DatapointModel.h"
#import "DeviceModel.h"
#import "IntoYunProtocol.h"
#import "NSString+MLString.h"

@class DatapointModel;

@protocol IntoYunMQTTManagerDelegate <NSObject>

@optional
/**
 连接状态返回

 @param status 错误码和错误info
 */
- (void)didMQTTReceiveServerStatus:(id)status;

/**
 服务器推送消息返回

 @param topic 消息主题
 @param dic 消息内容，JSON转字典
 */
- (void)messageTopic:(NSString *)topic data:(NSData *)dic;

@optional
/**
 服务器推送消息返回

 @param topic 消息主题
 @param jsonStr 消息内容，JSON字符串
 */
- (void)messageTopic:(NSString *)topic jsonStr:(NSString *)jsonStr;

@optional
/**
 *  pub消息成功时回调，只有当 qos 为1或者2
 *
 *  @param msgID msgID
 */
- (void)messageDelivered:(UInt16)msgID;

@end


@interface IntoYunMQTTManager : NSObject

/**
 * the delegate receiving incoming messages
 */
@property(nonatomic, strong) NSMutableDictionary<NSString *, id <IntoYunMQTTManagerDelegate>> *delegateDictionary;

/**
 单例
 @return self
 */
+ (instancetype)shareInstance;


/**
 * 连接服务器
 * @param userName  登录用户名
 * @param password  登录密码
 */
- (void)connectToServer:(NSString *)userName password:(NSString *)password;


/**
 * 订阅系统消息
 *
 * @param delegate  接收回调
 */
- (void)subscribeMessages:(id <IntoYunMQTTManagerDelegate>)delegate subscribeHandler:(MQTTSubscribeHandler)subscribeHandler;


/**
 * 清掉retain数据
 */
- (void)cleanMessage;


/**
 * 取消订阅系统消息
 */
-(void)unSubscribeMessages;

/**
 * 获取设备状态，
 * 包括设备发布固件信息和在线状态信息
 *
 * @param deviceId      设备Id
 * @param delegate      接收回调
 */
- (void)subscribeDeviceInfo:(NSString *)deviceId delegate:(id <IntoYunMQTTManagerDelegate>)delegate;


/**
 * 取消订阅设备消息在线状态信息
 * @param deviceId  设备id
 */
-(void)unSubscribeDeviceInfo:(NSString *)deviceId;


/**
 * 接收来自设备的实时数据
 *
 * @param deviceId      设备Id
 * @param datapoints    设备数据点
 * @param delegate      接收回到代理
 * @param subscribeHandler  订阅成功回调
 */
-(void)subscribeDataFromDevice:(NSString *)deviceId
                    datapoints:(NSArray *)datapoints
                      delegate:(id <IntoYunMQTTManagerDelegate>)delegate
              subscribeHandler:(MQTTSubscribeHandler)subscribeHandler;


/**
 * 取消订阅设备实时数据
 * @param deviceId  设备id
 */
-(void)unSubscribeDataFromDevice:(NSString *)deviceId;


/**
 * 获取设备的状态
 *
 * @param deviceId   设备Id
 * @param delegate      发送成功回调
 */
-(void)getDeviceStatus:(NSString *)deviceId
              delegate:(id <IntoYunMQTTManagerDelegate>)delegate;



 /**
  * 发送数据或指令到设备
  * @param device      设备模型
  * @param datapoint    数据点模型
  * @param value        发送的值
  * @param mProtocol    数据协议 protocol{json: "josn", binary: "binary:}
  * @param delegate     代理协议
  */
//- (void)sendDataToDevice:(DeviceModel *)device
//               datapoint:(DatapointModel *)datapoint
//                   value:(id)value
//            dataProtocol:(NSString *)mProtocol
//                delegate:(id <IntoYunMQTTManagerDelegate>)delegate;

/**
 * 发送数据或指令到设备
 * @param device      设备模型
 * @param datapoint    数据点模型
 * @param value        发送的值
 * @param delegate     代理协议
 */
- (void)sendDataToDevice:(DeviceModel *)device
               datapoint:(DatapointModel *)datapoint
                   value:(id)value
                delegate:(id <IntoYunMQTTManagerDelegate>)delegate;

/**
 断开连接，清空数据
 */
- (void)disconnect;



@end
