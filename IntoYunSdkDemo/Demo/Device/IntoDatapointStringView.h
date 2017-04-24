//
//  IntoDatapointStringView.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/12.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatapointModel.h"
#import "SendDataDelegate.h"
#import "BaseDatapointView.h"

@interface IntoDatapointStringView : BaseDatapointView

@property (nonatomic, weak) DatapointModel *datapointModel;

@property (nonatomic, weak) id <SendDataDelegate> delegete;

- (instancetype)initWithFrame:(CGRect)frame datapoint:(DatapointModel *)datapointModel;

@end
