//
//  WebsocketService.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/8/26.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>

@interface WebSocketService : NSObject


+ (WebSocketService *)sharedInstance;

-(WebSocketService *)initWithAuthName:(NSString *)name token:(NSString *)token;

- (SRWebSocket *)socketConnectHost;

//关闭连接
- (void)SRWebSocketClose;


@end
