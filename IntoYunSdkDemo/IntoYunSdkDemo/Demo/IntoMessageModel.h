//
//  IntoMessageModel.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/8.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntoMessageModel : NSObject

@property (nonatomic, copy)NSString *ID;
@property (nonatomic, assign)long long timestamp;
@property (nonatomic, copy)NSString *content;

@end
