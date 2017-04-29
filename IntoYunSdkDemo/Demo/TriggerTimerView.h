//
//  TriggerTimerView.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/27.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatapointModel;
@class TriggerValModel;
@protocol RecipeSettingDelegate;
@class CrontabModel;

@interface TriggerTimerView : UIView

@property (nonatomic, weak) DatapointModel *datapointModel;

@property (nonatomic, weak) CrontabModel *crontabModel;


@property (nonatomic, weak) id <RecipeSettingDelegate> delegete;


-(instancetype)initWithFrame:(CGRect)frame DataPoint:(DatapointModel *)datapoint crontab:(CrontabModel *)crontab;

@end
