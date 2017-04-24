//
//  IntoDatapointNumberView.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/12.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import "IntoDatapointNumberView.h"
#import "Macros.h"
#import "IntoYunSDK.h"

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
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.boardView.frame = CGRectMake(0, (CGRectGetHeight(self.frame) - self.frame.size.height) / 2 + 5, self.frame.size.width, self.frame.size.height - 10);
    //设置边框
    self.boardView.layer.borderWidth = 1;
    self.boardView.layer.borderColor = [DividerColor CGColor];

    //设置圆角
    self.boardView.layer.cornerRadius = 3;
    self.boardView.layer.masksToBounds = YES;

    self.datapointTitleLabel.frame = CGRectMake(10, CGRectGetHeight(self.frame) / 2 - 15, 100, 30);

    self.datapointSlider.frame = CGRectMake(self.bounds.origin.x + 110, CGRectGetHeight(self.frame) / 2 - 15, CGRectGetWidth(self.frame) - 110 - 50 - 20, 30);
    self.datapointUnitLabel.frame = CGRectMake(self.bounds.origin.x + CGRectGetWidth(self.frame) - 50 - 20, CGRectGetHeight(self.frame) / 2 - 15, 50, 30);
    [self.datapointSlider addTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventTouchUpInside];
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
}

- (void)receiveData:(id)data {
    NSString *value = [NSString stringWithFormat:@"%@", data];
    [self.datapointSlider setValue:[value floatValue]];
    [self setUnitLabel:[value floatValue]];
}

- (void)onValueChanged:(id)sender {
    UISlider *uiSlider = (UISlider *) sender;
    self.datapointUnitLabel.text = [NSString stringWithFormat:@"%.2f%@", uiSlider.value, _datapointModel.unit];
    [self setUnitLabel:uiSlider.value];
    if (self.delegete && [self.delegete respondsToSelector:@selector(sendData:datapoint:)]) {
        [self.delegete sendData:[NSNumber numberWithFloat:uiSlider.value] datapoint:self.datapointModel];
    }
}

-(void)setUnitLabel:(float)value{
    if (_datapointModel.unit) {
        self.datapointUnitLabel.text = [NSString stringWithFormat:@"%.2f%@", value, _datapointModel.unit];
    } else {
        self.datapointUnitLabel.text = [NSString stringWithFormat:@"%.2f", value];
    }

}

@end
