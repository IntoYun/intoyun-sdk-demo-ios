//
//  IntoDatapointExtraView.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/12.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import "IntoDatapointExtraView.h"

@interface IntoDatapointExtraView ()

// 数据点名称
@property(nonatomic, weak) UILabel *datapointTitleLabel;

// 数据点value
@property(nonatomic, weak) UILabel *datapointValue;

//边框
@property(nonatomic, weak) UIView *boardView;

@end

@implementation IntoDatapointExtraView


- (instancetype)initWithFrame:(CGRect)frame datapoint:(DatapointModel *)datapointModel {
    if (self = [super initWithFrame:frame]) {
        _datapointModel = datapointModel;
        //边框
        UIView *boardView = [[UIView alloc] init];
        self.boardView = boardView;
        [self addSubview:boardView];

        //title
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.numberOfLines = 1;
        [titleLabel sizeToFit];
        self.datapointTitleLabel = titleLabel;
        [self addSubview:titleLabel];

        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.text = @"接收数据";
        [contentLabel sizeToFit];
        self.datapointValue = contentLabel;
        [self addSubview:contentLabel];

        [self setDatapointModel:datapointModel];
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
        maker.top.mas_equalTo(self.datapointTitleLabel.superview).offset(15);
        maker.left.mas_equalTo(self.datapointTitleLabel.superview.mas_left).offset(10);
    }];

    [self.datapointValue mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(self.datapointTitleLabel.mas_bottom).offset(5);
        maker.left.mas_equalTo(self.datapointValue.superview.mas_left).offset(10);
        maker.right.mas_equalTo(self.datapointValue.superview.mas_right).offset(-10);
    }];

    [super updateConstraints];
}


- (void)setDatapointModel:(DatapointModel *)datapointModel {
    self.datapointTitleLabel.text = datapointModel.nameCn;
    //设置边框
    self.boardView.layer.borderWidth = 1;
    self.boardView.layer.borderColor = [DividerColor CGColor];

    //设置圆角
    self.boardView.layer.cornerRadius = 3;
    self.boardView.layer.masksToBounds = YES;
}

- (void)receiveData:(id)data {
    NSString *value = [NSString stringWithFormat:@"%@", data];
    self.datapointValue.text = value;

}

- (void)onValueChanged:(id)sender {
    NSString *value = self.datapointValue.text;
    NSLog(@"change value: %@", value);
    if (self.delegete && [self.delegete respondsToSelector:@selector(sendData:datapoint:)]) {
        [self.delegete sendData:value datapoint:self.datapointModel];
    }
}


@end
