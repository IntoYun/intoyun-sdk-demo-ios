//
//  TriggerNumberView.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/27.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatapointModel;
@class TriggerValModel;
@protocol RecipeSettingDelegate;

@interface TriggerNumberView : UIView

@property (nonatomic, weak) DatapointModel *datapointModel;

@property (nonatomic, weak) TriggerValModel *triggerValModel;


@property (nonatomic, weak) id <RecipeSettingDelegate> delegete;


-(instancetype)initWithFrame:(CGRect)frame DataPoint:(DatapointModel *)datapoint triggerVal:(TriggerValModel *)triggerVal;

@end
