//
//  IntoMessageModel.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/8.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import "IntoMessageModel.h"

@implementation IntoMessageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID": @"_id"
             };
}

@end
