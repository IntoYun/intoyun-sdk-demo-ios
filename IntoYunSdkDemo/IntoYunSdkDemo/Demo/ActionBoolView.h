//
//  ActionBoolView.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/28.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeSettingDelegate.h"
#import "DatapointModel.h"



@interface ActionBoolView : UIView

@property (nonatomic, weak) DatapointModel *datapointModel;

@property (nonatomic, weak) ActionValModel *actionValModel;


@property (nonatomic, weak) id <RecipeSettingDelegate> delegete;


-(instancetype)initWithFrame:(CGRect)frame DataPoint:(DatapointModel *)datapoint actionVal:(ActionValModel *)actionVal;

@end
