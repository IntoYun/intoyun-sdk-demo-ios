//
//  ActionStringView.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/28.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "ActionStringView.h"
#import "Macros.h"
#import "IntoYunUtils.h"

@interface ActionStringView()

@property(nonatomic, weak) UILabel *titleLabel;

@property(nonatomic, weak) UIView *titleView;

@property(nonatomic, weak) UILabel *datapointNameLabel;

@property(nonatomic, weak) UITextField *textField;

@property (nonatomic, weak) UIView *divider;

@end

@implementation ActionStringView

- (instancetype)initWithFrame:(CGRect)frame DataPoint:(DatapointModel *)datapoint actionVal:(ActionValModel *)actionVal {
    self.datapointModel = datapoint;
    self.actionValModel = actionVal;
    if (self = [super initWithFrame:frame]) {
        //添加title
        UILabel *title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:15];
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = PrimaryColor;
        title.text = [NSString stringWithFormat:NSLocalizedString(@"recipe_send_message", nil), [IntoYunUtils getDatapointName:datapoint]];


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
        name.text = NSLocalizedString(@"recipe_send_message_title", nil);
        [self addSubview:name];
        self.datapointNameLabel = name;

        //添加switch
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = NSLocalizedString(@"recipe_send_content_placeholder", nil);
        textField.text = actionVal.value ? actionVal.value : @"";
        [self addSubview:textField];
        self.textField = textField;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = DividerColor;
        [self addSubview:divider];
        self.divider = divider;
    }

    return self;
}

- (void)textFieldDidChange:(UITextField *)textField{
    self.actionValModel.value = textField.text;
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
        maker.right.mas_lessThanOrEqualTo(self.datapointNameLabel.superview.mas_right).offset(-10);
        maker.height.mas_equalTo(50);
    }];

    [self.textField mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(self.datapointNameLabel.mas_bottom).offset(0);
        maker.left.mas_equalTo(self.textField.superview.mas_left).offset(10);
        maker.right.mas_equalTo(self.textField.superview.mas_right).offset(-10);
        maker.width.mas_greaterThanOrEqualTo(50);
    }];

    [self.divider mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.top.mas_equalTo(self.textField.mas_bottom).offset(2);
        maker.left.mas_equalTo(self.divider.superview.mas_left).offset(8);
        maker.right.mas_equalTo(self.divider.superview.mas_right).offset(-8);
        maker.height.mas_equalTo(0.5);
    }];
    [super updateConstraints];
}

@end
