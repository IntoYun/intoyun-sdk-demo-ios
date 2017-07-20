//
//  TriggerNumberView.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/27.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "TriggerNumberView.h"
#import "DatapointModel.h"
#import "TriggerValModel.h"
#import "RecipeSettingDelegate.h"
#import "Macros.h"
#import "IntoYunUtils.h"

@interface TriggerNumberView () <UIActionSheetDelegate>

@property(nonatomic, weak) UILabel *titleLabel;

@property(nonatomic, weak) UIView *titleView;

@property(nonatomic, weak) UILabel *datapointNameLabel;

// logic
@property(nonatomic, weak) UIButton *logicBotton;

// 数据点value
@property(nonatomic, weak) UISlider *datapointSlider;

// 数据点unit
@property(nonatomic, weak) UILabel *datapointUnitLabel;

@property(nonatomic, strong) NSMutableDictionary *logicDic;

@end

@implementation TriggerNumberView


- (instancetype)initWithFrame:(CGRect)frame DataPoint:(DatapointModel *)datapoint triggerVal:(TriggerValModel *)triggerVal {
    self.datapointModel = datapoint;
    self.triggerValModel = triggerVal;
    self.logicDic = [[NSMutableDictionary alloc] initWithCapacity:3];
    [self.logicDic setValue:NSLocalizedString(@"logic_eq", nil) forKey:@"eq"];
    [self.logicDic setValue:NSLocalizedString(@"logic_gt", nil) forKey:@"gt"];
    [self.logicDic setValue:NSLocalizedString(@"logic_lt", nil) forKey:@"lt"];
    if (self = [super initWithFrame:frame]) {
        //添加title
        UILabel *title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:15];
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = PrimaryColor;
        title.text = [NSString stringWithFormat:NSLocalizedString(@"recipe_trigger_title", nil), [IntoYunUtils getDatapointName:datapoint]];


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

        //添加logic button
        UIButton *logicButton = [[UIButton alloc] init];
        [logicButton setTitle:[self.logicDic valueForKey:triggerVal.op] forState:UIControlStateNormal];
        [logicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        logicButton.titleLabel.font = [UIFont systemFontOfSize:15];
        logicButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        logicButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self addSubview:logicButton];
        self.logicBotton = logicButton;
        [self.logicBotton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        // add slider
        UISlider *slider = [[UISlider alloc] init];
        slider.maximumValue = datapoint.min;
        slider.maximumValue = datapoint.max;
        float resultValue = [IntoYunUtils parseData2Float:[triggerVal.value intValue] Datapoint:datapoint];
        
        slider.value = resultValue;

        [self addSubview:slider];
        self.datapointSlider = slider;
        [self.datapointSlider addTarget:self action:@selector(onValueChange:) forControlEvents:UIControlEventValueChanged];

        // add unit
        UILabel *unitLabel = [[UILabel alloc] init];
        unitLabel.textAlignment = NSTextAlignmentRight;
        unitLabel.font = [UIFont systemFontOfSize:14];
        unitLabel.numberOfLines = 1;
        [unitLabel sizeToFit];
        NSString *parseValue = [IntoYunUtils toDecimal:resultValue DataPoint:datapoint];
        unitLabel.text = [NSString stringWithFormat:@"%@%@", parseValue, datapoint.unit ? datapoint.unit: @""];
        [self addSubview:unitLabel];
        self.datapointUnitLabel = unitLabel;
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
    for (NSString *logic in self.logicDic.allValues) {
        [actionSheet addButtonWithTitle:logic];
    }
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    [actionSheet showInView:self];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"action index: %ld", (long) buttonIndex);
    if (buttonIndex < self.logicDic.count) {
        [self.logicBotton setTitle: self.logicDic.allValues[buttonIndex] forState:UIControlStateNormal];
        self.triggerValModel.op = self.logicDic.allKeys[buttonIndex];
        if (self.delegete && [self.delegete respondsToSelector:@selector(onTriggerChanged:)]) {
            [self.delegete onTriggerChanged:self.triggerValModel];
        }
    }
}

- (void)onValueChange:(id)sender {
    UISlider *uiSlider = (UISlider *) sender;
    NSString *parseValue = [IntoYunUtils toDecimal:uiSlider.value DataPoint:self.datapointModel];
    self.datapointUnitLabel.text = [NSString stringWithFormat:@"%@%@", parseValue, self.datapointModel.unit ? self.datapointModel.unit: @""];
    int resultValue = [IntoYunUtils parseData2Int:uiSlider.value Datapoint:self.datapointModel];
    self.triggerValModel.value = [NSNumber numberWithInt:resultValue];
    if (self.delegete && [self.delegete respondsToSelector:@selector(onTriggerChanged:)]) {
        [self.delegete onTriggerChanged:self.triggerValModel];
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
        maker.right.mas_equalTo(self.logicBotton.mas_left).offset(-10);
        maker.height.mas_equalTo(50);
        maker.width.mas_lessThanOrEqualTo(100);
    }];

    [self.logicBotton mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.centerY.mas_equalTo(self.datapointNameLabel.mas_centerY).offset(0);
        maker.right.mas_equalTo(self.datapointSlider.mas_left).offset(-10);
        maker.width.mas_equalTo(40);
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
