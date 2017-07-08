//
//  IntoDatapointNumberView.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/12.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "IntoDatapointNumberView.h"
#import "Macros.h"
#import "IntoYunUtils.h"

@interface IntoDatapointNumberView ()

// 数据点名称
@property(nonatomic, weak) UILabel *datapointTitleLabel;

// 数据点value
@property(nonatomic, weak) UISlider *datapointSlider;

// 数据点unit
@property(nonatomic, weak) UILabel *datapointUnitLabel;

@property(nonatomic, weak) UIView *boardView;

@end

@implementation IntoDatapointNumberView


- (instancetype)initWithFrame:(CGRect)frame datapoint:(DatapointModel *)datapointModel {
    if (self = [super initWithFrame:frame]) {
        _datapointModel = datapointModel;

        UIView *boardView = [[UIView alloc] init];
        self.boardView = boardView;
        [self addSubview:boardView];

        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.numberOfLines = 1;
        [titleLabel sizeToFit];
        self.datapointTitleLabel = titleLabel;
        [self addSubview:titleLabel];


        UISlider *valueSlider = [[UISlider alloc] init];
        self.datapointSlider = valueSlider;
        [self addSubview:valueSlider];


        UILabel *unitLabel = [[UILabel alloc] init];
        unitLabel.textAlignment = NSTextAlignmentRight;
        unitLabel.font = [UIFont systemFontOfSize:14];
        unitLabel.numberOfLines = 1;
        [unitLabel sizeToFit];

        self.datapointUnitLabel = unitLabel;
        [self addSubview:unitLabel];

        [self setDatapointModel:datapointModel];
        [self.datapointSlider addTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [self.boardView mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.edges.mas_offset(UIEdgeInsetsMake(5, 0, 5, 0));
        maker.center.mas_equalTo(self.boardView.superview);
    }];

    [self.datapointTitleLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.centerY.mas_equalTo(self.datapointTitleLabel.superview);
        maker.left.mas_equalTo(self.datapointTitleLabel.superview.mas_left).offset(10);
    }];

    [self.datapointSlider mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.centerY.mas_equalTo(self.datapointSlider.superview);
        maker.left.mas_equalTo(self.datapointTitleLabel.mas_right).offset(10);
    }];

    [self.datapointUnitLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.centerY.mas_equalTo(self.datapointUnitLabel.superview);
        maker.right.mas_equalTo(self.datapointUnitLabel.superview.mas_right).offset(-10);
        maker.left.mas_equalTo(self.datapointSlider.mas_right).offset(10);
    }];

    [super updateConstraints];
}

- (void)setDatapointModel:(DatapointModel *)datapointModel {
    self.datapointTitleLabel.text = datapointModel.nameCn;
    int minVal = datapointModel.min;
    [self setUnitLabel:minVal];

    self.datapointSlider.maximumValue = datapointModel.min;
    self.datapointSlider.maximumValue = datapointModel.max;
    self.datapointSlider.value = datapointModel.min;

    if (self.datapointModel.direction == DIRECTION_DATA) {
        [self.datapointSlider setEnabled:NO];
    } else {
        [self.datapointSlider setEnabled:YES];
    }
    //设置边框
    self.boardView.layer.borderWidth = 1;
    self.boardView.layer.borderColor = [DividerColor CGColor];

    //设置圆角
    self.boardView.layer.cornerRadius = 3;
    self.boardView.layer.masksToBounds = YES;
}

- (void)receiveData:(id)data {
    NSString *value = [NSString stringWithFormat:@"%@", data];
    [self.datapointSlider setValue:[value floatValue]];
    [self setUnitLabel:[value floatValue]];
}

- (void)onValueChanged:(id)sender {
    UISlider *uiSlider = (UISlider *) sender;
    [self setUnitLabel:uiSlider.value];
    if (self.delegete && [self.delegete respondsToSelector:@selector(sendData:datapoint:)]) {
        NSString *parseValue = [IntoYunUtils toDecimal:uiSlider.value DataPoint:_datapointModel];
        [self.delegete sendData:[NSNumber numberWithFloat:[parseValue floatValue]] datapoint:self.datapointModel];
    }
}

- (void)setUnitLabel:(float)value {
    NSString *parseValue = [IntoYunUtils toDecimal:value DataPoint:_datapointModel];
    NSLog(@"%@", parseValue);
    if (_datapointModel.unit) {
        self.datapointUnitLabel.text = [NSString stringWithFormat:@"%@%@", parseValue, _datapointModel.unit];
    } else {
        self.datapointUnitLabel.text = parseValue;
    }
}

@end
