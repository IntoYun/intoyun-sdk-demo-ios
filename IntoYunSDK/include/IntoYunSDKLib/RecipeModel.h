//
// Created by hui he on 17/4/5.
// Copyright (c) 2017 hui he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionValModel.h"
#import "TriggerValModel.h"
#import "CrontabModel.h"

@interface RecipeModel : NSObject

@property (nonatomic, strong) TriggerValModel *triggerVal;
@property (nonatomic, strong) CrontabModel *crontab;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *recipeDescription;
@property (nonatomic, strong) NSArray *devices;
@property (nonatomic, strong) NSArray *dpIds;
@property (nonatomic, strong) NSArray *prdIds;
@property (nonatomic, strong) NSArray *actionVal;

@end
