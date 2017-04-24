//
// Created by hui he on 17/4/5.
// Copyright (c) 2017 hui he. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CrontabModel : NSObject

@property (nonatomic, copy) NSString *day_of_week;
@property (nonatomic, copy) NSString *hour;
@property (nonatomic, copy) NSString *minute;
@property (nonatomic, copy) NSString *day_of_month;
@property (nonatomic, copy) NSString *month_of_year;

@end