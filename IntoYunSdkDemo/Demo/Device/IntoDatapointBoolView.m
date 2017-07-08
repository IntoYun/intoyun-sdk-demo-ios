//
//  IntoDatapointBoolView.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/11.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import "IntoDatapointBoolView.h"
#import "Macros.h"

@interface IntoDatapointBoolView()

// 数据点名称
@property (nonatomic, weak) UILabel *datapointTitleLabel;

// 数据点value
@property (nonatomic, weak) UISwitch *datapointStatusSwitch;


@property (nonatomic, weak) UIView *boardView;

@end

@implementation IntoDatapointBoolView


- (instancetype)initWithFrame:(CGRect)frame datapoint:(DatapointModel *)datapointModel{
    if (self = [super initWithFrame:frame]){
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


        UISwitch *statusSwitch = [[UISwitch alloc] init];
        statusSwitch.on = NO;
        self.datapointStatusSwitch = statusSwitch;
        [self addSubview:statusSwitch];

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
        maker.centerY.mas_equalTo(self.datapointTitleLabel.superview);
        maker.left.mas_equalTo(self.datapointTitleLabel.superview.mas_left).offset(10);
    }];

    [self.datapointStatusSwitch mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.centerY.mas_equalTo(self.datapointStatusSwitch.superview);
        maker.right.mas_equalTo(self.datapointStatusSwitch.superview).offset(-10);
    }];
    [super updateConstraints];
}


-(void)setDatapointModel:(DatapointModel *)datapointModel {
    self.datapointTitleLabel.text = datapointModel.nameCn;
    if (datapointModel.direction == DIRECTION_DATA){
        [self.datapointStatusSwitch setEnabled:NO];
    } else {
        [self.datapointStatusSwitch setEnabled:YES];
    }
    [self.datapointStatusSwitch addTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventValueChanged];
    //设置边框
    self.boardView.layer.borderWidth = 1;
    self.boardView.layer.borderColor = [DividerColor CGColor];
    
    //设置圆角
    self.boardView.layer.cornerRadius = 3;
    self.boardView.layer.masksToBounds = YES;
}

-(void)receiveData:(id)data{
    [self.datapointStatusSwitch setOn:[data boolValue]];
}

-(void)onValueChanged:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSLog(@"change value: %@", isButtonOn?@"YES": @"NO");
    if (self.delegete && [self.delegete respondsToSelector:@selector(sendData:datapoint:)]){
        [self.delegete sendData:[NSNumber numberWithBool:isButtonOn] datapoint:self.datapointModel];
    }
}


@end
