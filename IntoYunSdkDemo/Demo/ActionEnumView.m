//
//  ActionEnumView.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/28.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "ActionEnumView.h"
#import "Macros.h"
#import "IntoYunUtils.h"

@interface ActionEnumView() <UIActionSheetDelegate>

@property(nonatomic, weak) UILabel *titleLabel;

@property(nonatomic, weak) UIView *titleView;

@property(nonatomic, weak) UILabel *datapointNameLabel;

// 数据点unit
@property(nonatomic, weak) UIButton *datapointValueButton;

@end

@implementation ActionEnumView


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


        // add value
        UIButton *valueButton = [[UIButton alloc] init];
        NSString *value = (NSString *)datapoint.datapointEnum[[actionVal.value intValue]];
        [valueButton setTitle:value forState:UIControlStateNormal];
        valueButton.titleLabel.textAlignment = NSTextAlignmentRight;
        valueButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [valueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:valueButton];
        self.datapointValueButton = valueButton;
        [self.datapointValueButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)onButtonClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
            initWithTitle:nil
                 delegate:self
        cancelButtonTitle:nil
   destructiveButtonTitle:nil
        otherButtonTitles:nil];
    for (NSString *item in self.datapointModel.datapointEnum) {
        [actionSheet addButtonWithTitle:item];
    }
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    [actionSheet showInView:self];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"action index: %ld", (long) buttonIndex);
    if (buttonIndex < self.datapointModel.datapointEnum.count) {
        [self.datapointValueButton setTitle:self.datapointModel.datapointEnum[buttonIndex] forState:UIControlStateNormal];
        self.actionValModel.value = [NSNumber numberWithLong:buttonIndex];
        if (self.delegete && [self.delegete respondsToSelector:@selector(onActionChanged:)]) {
            [self.delegete onActionChanged:self.actionValModel];
        }
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
        maker.right.mas_lessThanOrEqualTo(self.datapointValueButton.mas_left).offset(-10);
        maker.height.mas_equalTo(50);
        maker.width.mas_lessThanOrEqualTo(100);
    }];


    [self.datapointValueButton mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.centerY.mas_equalTo(self.datapointNameLabel.mas_centerY).offset(0);
        maker.right.mas_equalTo(self.datapointValueButton.superview.mas_right).offset(-10);
        maker.height.mas_equalTo(30);
        maker.width.mas_equalTo(50);
    }];

    [super updateConstraints];
}

@end
