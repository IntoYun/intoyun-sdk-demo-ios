//
//  ActionEmailView.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/28.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "ActionEmailView.h"
#import "Macros.h"
#import "IntoYunUtils.h"

@interface ActionEmailView()

@property(nonatomic, weak) UILabel *titleLabel;

@property(nonatomic, weak) UIView *titleView;

@property(nonatomic, weak) UITextField *emailTextField;

@property(nonatomic, weak) UITextField *contentTextField;

@property (nonatomic, weak) UIView *divider;

@property (nonatomic, weak) UIView *divider1;
@end

@implementation ActionEmailView

- (instancetype)initWithFrame:(CGRect)frame DataPoint:(DatapointModel *)datapoint actionVal:(ActionValModel *)actionVal {
    self.datapointModel = datapoint;
    self.actionValModel = actionVal;
    if (self = [super initWithFrame:frame]) {
        //添加title
        UILabel *title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:15];
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = PrimaryColor;
        title.text = [NSString stringWithFormat:NSLocalizedString(@"recipe_send_email", nil), [IntoYunUtils getDatapointName:datapoint]];


        UIView *titleView = [[UIView alloc] init];
        titleView.backgroundColor = DividerColor;
        [titleView addSubview:title];
        self.titleLabel = title;

        [self addSubview:titleView];
        self.titleView = titleView;

        //添加 email address
        UITextField *emailAddr = [[UITextField alloc] init];
        emailAddr.placeholder = NSLocalizedString(@"recipe_send_email_title_placeholder", nil);
        emailAddr.text = actionVal.to ? actionVal.to : @"";
        emailAddr.keyboardType = UIKeyboardTypeEmailAddress;
        [self addSubview:emailAddr];
        self.emailTextField = emailAddr;
        [emailAddr addTarget:self action:@selector(emailAddrDidChange:) forControlEvents:UIControlEventEditingChanged];

        //添加switch
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = NSLocalizedString(@"recipe_send_content_placeholder", nil);
        textField.text = actionVal.value ? actionVal.value : @"";
        [self addSubview:textField];
        self.contentTextField = textField;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = DividerColor;
        [self addSubview:divider];
        self.divider = divider;

        UIView *divider1 = [[UIView alloc] init];
        divider1.backgroundColor = DividerColor;
        [self addSubview:divider1];
        self.divider1 = divider1;
    }

    return self;
}

- (void)emailAddrDidChange:(UITextField *)textField{
    self.actionValModel.to = textField.text;
    if (self.delegete && [self.delegete respondsToSelector:@selector(onActionChanged:)]) {
        [self.delegete onActionChanged:self.actionValModel];
    }
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

    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(self.titleLabel.mas_bottom).offset(30);
        maker.left.mas_equalTo(self.emailTextField.superview.mas_left).offset(10);
        maker.right.mas_lessThanOrEqualTo(self.emailTextField.superview.mas_right).offset(-10);
    }];

    [self.divider1 mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.top.mas_equalTo(self.emailTextField.mas_bottom).offset(2);
        maker.left.mas_equalTo(self.divider1.superview.mas_left).offset(8);
        maker.right.mas_equalTo(self.divider1.superview.mas_right).offset(-8);
        maker.height.mas_equalTo(0.5);
    }];

    [self.contentTextField mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(self.divider1.mas_bottom).offset(30);
        maker.left.mas_equalTo(self.contentTextField.superview.mas_left).offset(10);
        maker.right.mas_equalTo(self.contentTextField.superview.mas_right).offset(-10);
        maker.width.mas_greaterThanOrEqualTo(50);
    }];

    [self.divider mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.top.mas_equalTo(self.contentTextField.mas_bottom).offset(2);
        maker.left.mas_equalTo(self.divider.superview.mas_left).offset(8);
        maker.right.mas_equalTo(self.divider.superview.mas_right).offset(-8);
        maker.height.mas_equalTo(0.5);
    }];
    [super updateConstraints];
}

@end
