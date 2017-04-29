//
//  RecipeSettingDelegate.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/27.
//  Copyright © 2017年 hui he. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "TriggerValModel.h"
#import "ActionValModel.h"
#import "CrontabModel.h"

@protocol RecipeSettingDelegate <NSObject>

@optional
-(void)onTriggerChanged:(TriggerValModel *)triggerVal;

@optional
-(void)onActionChanged:(ActionValModel *)actionVal;

@optional
-(void)onCrontabChanged:(CrontabModel *)crontab;

@end
