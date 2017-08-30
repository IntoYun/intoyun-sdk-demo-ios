//
//  TcpService.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/8/24.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

@interface TcpService : NSObject

+(TcpService *)sharedInstance;

@property (nonatomic, strong) GCDAsyncSocket *socket;

- (GCDAsyncSocket *)socketConnectHost;

//设置连接认证信息
- (TcpService *)initWithAuthName:(NSString *)name token:(NSString *)token;

//发送数据到服务器
-(void)writeData:(NSData *)data;


//关闭连接
-(void)socketClose;

@end
