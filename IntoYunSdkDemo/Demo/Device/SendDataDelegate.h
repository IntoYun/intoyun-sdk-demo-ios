//
// Created by hui he on 17/4/12.
// Copyright (c) 2017 hui he. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SendDataDelegate <NSObject>

-(void)sendData:(id)value datapoint:(DatapointModel *)datapoint;

@end