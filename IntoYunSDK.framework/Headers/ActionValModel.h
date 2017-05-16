//
// Created by hui he on 17/4/5.
// Copyright (c) 2017 hui he. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ActionValModel : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) id value;
@property (nonatomic) int dpId;
@property (nonatomic) int dpType;

@end
