//
//  IntoDatapointBoolView.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/11.
//  Copyright © 2017年 hui he. All rights reserved.
//

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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.boardView.frame = CGRectMake(0, (CGRectGetHeight(self.frame) - self.frame.size.height)/2 + 5, self.frame.size.width, self.frame.size.height - 10);
    //设置边框
    self.boardView.layer.borderWidth = 1;
    self.boardView.layer.borderColor = [DividerColor CGColor];
    
    //设置圆角
    self.boardView.layer.cornerRadius = 3;
    self.boardView.layer.masksToBounds = YES;
    
    self.datapointTitleLabel.frame = CGRectMake(10, CGRectGetHeight(self.frame)/2 - 15, 100, 30);
    self.datapointStatusSwitch.frame = CGRectMake(self.bounds.origin.x + CGRectGetWidth(self.bounds) - 50 - 10, CGRectGetHeight(self.frame)/2 -15, 50, 30);
}

-(void)setDatapointModel:(DatapointModel *)datapointModel {
    self.datapointTitleLabel.text = datapointModel.nameCn;
    if (datapointModel.direction == DIRECTION_DATA){
        [self.datapointStatusSwitch setEnabled:NO];
    } else {
        [self.datapointStatusSwitch setEnabled:YES];
    }
    [self.datapointStatusSwitch addTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventValueChanged];
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
