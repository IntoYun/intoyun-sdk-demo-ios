//
//  ActionBoolView.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/28.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "ActionBoolView.h"
#import "Macros.h"
#import "IntoYunUtils.h"

@interface ActionBoolView()

@property(nonatomic, weak) UILabel *titleLabel;

@property(nonatomic, weak) UIView *titleView;

@property(nonatomic, weak) UILabel *datapointNameLabel;

@property(nonatomic, weak) UISwitch *valueSwitch;

@end

@implementation ActionBoolView

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

        //添加switch
        UISwitch *valueView = [[UISwitch alloc] init];
        if (actionVal.value) {
            [valueView setOn:YES animated:YES];
        } else {
            [valueView setOn:NO animated:YES];
        }
        [self addSubview:valueView];
        self.valueSwitch = valueView;

        [self.valueSwitch addTarget:self action:@selector(onValueChange:) forControlEvents:UIControlEventValueChanged];
    }

    return self;
}

- (void)onValueChange:(id)sender {
    UISwitch *uiSwitch = (UISwitch *) sender;
    BOOL value = uiSwitch.isOn;
    NSLog(@"change value: %@", value ? @"YES" : @"NO");
    self.actionValModel.value = [NSNumber numberWithBool:value];
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
        maker.right.mas_lessThanOrEqualTo(self.valueSwitch.mas_left).offset(-10);
        maker.centerY.mas_equalTo(self.valueSwitch.mas_centerY).offset(0);
        maker.height.mas_equalTo(50);
    }];

    [self.valueSwitch mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.right.mas_equalTo(self.valueSwitch.superview.mas_right).offset(-10);
        maker.width.mas_equalTo(50);
    }];
    [super updateConstraints];
}

@end
