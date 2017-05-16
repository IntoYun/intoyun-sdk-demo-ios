//
//  ActionNumberView.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/28.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "ActionNumberView.h"
#import "Macros.h"
#import "IntoYunUtils.h"

@interface ActionNumberView ()

@property(nonatomic, weak) UILabel *titleLabel;

@property(nonatomic, weak) UIView *titleView;

@property(nonatomic, weak) UILabel *datapointNameLabel;

// 数据点value
@property(nonatomic, weak) UISlider *datapointSlider;

// 数据点unit
@property(nonatomic, weak) UILabel *datapointUnitLabel;

@end

@implementation ActionNumberView

- (instancetype)initWithFrame:(CGRect)frame DataPoint:(DatapointModel *)datapoint actionVal:(ActionValModel *)actionVal {
    self.datapointModel = datapoint;
    self.actionValModel = actionVal;
    if (self = [super initWithFrame:frame]) {
        //添加title
        UILabel *title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:15];
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = PrimaryColor;
        title.text = [NSString stringWithFormat:NSLocalizedString(@"recipe_action_title", nil), [IntoYunUtils getDatapointName:datapoint]];


        UIView *titleView = [[UIView alloc] init];
        titleView.backgroundColor = DividerColor;
        [titleView addSubview:title];
        self.titleLabel = title;

        [self addSubview:titleView];
        self.titleView = titleView;

        //添加name
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:15];
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = [UIColor blackColor];
        name.text = [IntoYunUtils getDatapointName:datapoint];
        [self addSubview:name];
        self.datapointNameLabel = name;

        // add slider
        UISlider *slider = [[UISlider alloc] init];
        slider.maximumValue = datapoint.min;
        slider.maximumValue = datapoint.max;
        slider.value = [actionVal.value floatValue];

        [self addSubview:slider];
        self.datapointSlider = slider;
        [self.datapointSlider addTarget:self action:@selector(onValueChange:) forControlEvents:UIControlEventValueChanged];

        // add unit
        UILabel *unitLabel = [[UILabel alloc] init];
        unitLabel.textAlignment = NSTextAlignmentRight;
        unitLabel.font = [UIFont systemFontOfSize:14];
        unitLabel.numberOfLines = 1;
        [unitLabel sizeToFit];
        unitLabel.text = [NSString stringWithFormat:@"%.2f%@", slider.value, datapoint.unit ? datapoint.unit: @""];
        [self addSubview:unitLabel];
        self.datapointUnitLabel = unitLabel;
    }
    return self;
}


- (void)onValueChange:(id)sender {
    UISlider *uiSlider = (UISlider *) sender;
    self.datapointUnitLabel.text = [NSString stringWithFormat:@"%.2f%@", uiSlider.value, _datapointModel.unit ? _datapointModel.unit: @""];
    self.actionValModel.value = [NSNumber numberWithFloat:uiSlider.value];
    if (self.delegete && [self.delegete respondsToSelector:@selector(onActionChanged:)]) {
        [self.delegete onActionChanged:self.actionValModel];
    }
}


+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}


- (void)updateConstraints {

    [self.titleView mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(self.titleView.superview.mas_top).offset(0);
        maker.left.mas_equalTo(self.titleView.superview.mas_left).offset(0);
        maker.right.mas_equalTo(self.titleView.superview.mas_right).offset(0);
        maker.height.mas_equalTo(30);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.left.mas_equalTo(self.titleLabel.superview.mas_left).offset(10);
        maker.centerY.mas_equalTo(self.titleLabel.superview.mas_centerY).offset(0);
    }];

    [self.datapointNameLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        maker.left.mas_equalTo(self.datapointNameLabel.superview.mas_left).offset(10);
        maker.right.mas_equalTo(self.datapointSlider.mas_left).offset(-10);
        maker.height.mas_equalTo(50);
        maker.width.mas_lessThanOrEqualTo(100);
    }];


    [self.datapointSlider mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.centerY.mas_equalTo(self.datapointNameLabel.mas_centerY).offset(0);
        maker.right.mas_equalTo(self.datapointUnitLabel.mas_left).offset(-10);
        maker.height.mas_equalTo(30);
    }];

    [self.datapointUnitLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.centerY.mas_equalTo(self.datapointNameLabel.mas_centerY).offset(0);
        maker.right.mas_equalTo(self.datapointUnitLabel.superview.mas_right).offset(-10);
    }];

    [super updateConstraints];
}

@end
