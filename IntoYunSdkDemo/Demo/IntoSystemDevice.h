//
//  IntoSystemDevice.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/26.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntoSystemDevice : NSObject<NSCopying, NSMutableCopying>

+ (instancetype)shareSystemDevice;

@end
