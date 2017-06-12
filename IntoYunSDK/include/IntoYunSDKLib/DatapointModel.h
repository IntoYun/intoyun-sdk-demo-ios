//
//  DatapointModel.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/11.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatapointModel : NSObject

@property (nonatomic, assign) int dpId;
@property (nonatomic, assign) int max;
@property (nonatomic, assign) int min;
@property (nonatomic, assign) int direction;
@property (nonatomic, assign) int maxLength;
@property (nonatomic, assign) int resolution;
@property (nonatomic, copy) NSString *nameCn;
@property (nonatomic, copy) NSString *nameEn;
@property (nonatomic, copy) NSString *datapointDescription;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSArray *datapointEnum;
@property (nonatomic, copy) NSString *type;


@end
