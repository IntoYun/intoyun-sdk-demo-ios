//
//  TriggerTimerView.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/27.
//  Copyright © 2017年 hui he. All rights reserved.
//
#import <Masonry/View+MASAdditions.h>
#import "TriggerTimerView.h"
#import "DatapointModel.h"
#import "TriggerValModel.h"
#import "RecipeSettingDelegate.h"
#import "Macros.h"
#import "IntoYunUtils.h"
#import "CrontabModel.h"
#import "IntoDatePicker.h"

@interface TriggerTimerView()<UIActionSheetDelegate, IntoDatePickerDelegate>

@property(nonatomic, weak) UILabel *titleLabel;

@property(nonatomic, weak) UIView *titleView;

@property(nonatomic, weak) UIButton *datapointNameButton;

// logic
@property(nonatomic, weak) UILabel *repeatLabel;

// 数据点unit
@property(nonatomic, weak) UIButton *datapointValueButton;

@property (nonatomic, weak) UIDatePicker *datePicker;

@property (nonatomic, strong) NSMutableArray *weekArray;

@end

@implementation TriggerTimerView


- (instancetype)initWithFrame:(CGRect)frame DataPoint:(DatapointModel *)datapoint crontab:(CrontabModel *)crontab {
    self.datapointModel = datapoint;
    self.crontabModel = crontab;
    NSMutableArray *weekArray = [[NSMutableArray alloc] init];
    [weekArray addObject:NSLocalizedString(@"Sunday", nil)];
    [weekArray addObject:NSLocalizedString(@"Monday", nil)];
    [weekArray addObject:NSLocalizedString(@"Tuesday", nil)];
    [weekArray addObject:NSLocalizedString(@"Wednesday", nil)];
    [weekArray addObject:NSLocalizedString(@"Thursday", nil)];
    [weekArray addObject:NSLocalizedString(@"Friday", nil)];
    [weekArray addObject:NSLocalizedString(@"Saturday", nil)];
    [weekArray addObject:NSLocalizedString(@"everyday", nil)];
    self.weekArray = weekArray;
    if (self = [super initWithFrame:frame]) {
        //添加title
        UILabel *title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:15];
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = PrimaryColor;
        title.text = [IntoYunUtils getDatapointName:datapoint];

        UIView *titleView = [[UIView alloc] init];
        titleView.backgroundColor = DividerColor;
        [titleView addSubview:title];
        self.titleLabel = title;

        [self addSubview:titleView];
        self.titleView = titleView;

        //添加name
        UIButton *name = [[UIButton alloc] init];
        name.titleLabel.font = [UIFont systemFontOfSize:15];
        name.titleLabel.textAlignment = NSTextAlignmentLeft;
        name.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [name setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSString *timeText = [crontab.hour isEqualToString:@"*"] ? [IntoYunUtils getCurrentTime] : [NSString stringWithFormat:@"%@:%@", [IntoYunUtils getTheCorrectNum:crontab.hour], [IntoYunUtils getTheCorrectNum:crontab.minute]];
        [name setTitle:timeText forState:UIControlStateNormal];
        [self addSubview:name];
        self.datapointNameButton = name;
        self.datapointNameButton.tag = 1;
        [self.datapointNameButton addTarget:self action:@selector(setTimeClick:) forControlEvents:UIControlEventTouchUpInside];

        //添加repeat label
        UILabel *repeatLabel = [[UILabel alloc] init];
        repeatLabel.font = [UIFont systemFontOfSize:15];
        repeatLabel.textAlignment = NSTextAlignmentCenter;
        repeatLabel.textColor = [UIColor blackColor];
        repeatLabel.text = NSLocalizedString(@"recipe_timer_repeat", nil);
        [self addSubview:repeatLabel];
        self.repeatLabel = repeatLabel;

        // add value
        UIButton *valueButton = [[UIButton alloc] init];
        NSString *value = [crontab.day_of_week isEqualToString:@"*"] ? [weekArray lastObject] : weekArray[[crontab.day_of_week intValue]];
        [valueButton setTitle:value forState:UIControlStateNormal];
        valueButton.titleLabel.textAlignment = NSTextAlignmentRight;
        valueButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [valueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:valueButton];
        self.datapointValueButton = valueButton;
        self.datapointNameButton.tag = 2;
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
    for (NSString *item in self.weekArray) {
        [actionSheet addButtonWithTitle:item];
    }
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    [actionSheet showInView:self];
    
}

-(void)setTimeClick:(id)sender{
    IntoDatePicker *datePicker = [[IntoDatePicker alloc] init];
    datePicker.delegate = self;
    datePicker.definesPresentationContext = YES;
    datePicker.modalPresentationStyle = UIModalPresentationCustom;
    datePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [[self viewController] presentViewController:datePicker animated:YES completion:^{ }];
}

- (void)picker:(UIDatePicker *)picker ValueChanged:(NSDate *)date{
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    fm.dateFormat = @"HH:mm";
    [self.datapointNameButton setTitle:[fm stringFromDate:date] forState:UIControlStateNormal];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    self.crontabModel.minute = [NSString stringWithFormat:@"%d", (int)[dateComponent minute]];
    self.crontabModel.hour = [NSString stringWithFormat:@"%d", (int)[dateComponent hour]];
    if (self.delegete && [self.delegete respondsToSelector:@selector(onCrontabChanged:)]) {
        [self.delegete onCrontabChanged:self.crontabModel];
    }
}


//获取view的controller
- (UIViewController *)viewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"action index: %ld", (long) buttonIndex);
    if (buttonIndex < self.weekArray.count) {
        [self.datapointValueButton setTitle:self.weekArray[buttonIndex] forState:UIControlStateNormal];
        if (buttonIndex == self.weekArray.count - 1){
            self.crontabModel.day_of_week = @"*";
        }else{
            self.crontabModel.day_of_week = [NSString stringWithFormat:@"%ld", buttonIndex];
        }
        if (self.delegete && [self.delegete respondsToSelector:@selector(onCrontabChanged:)]) {
            [self.delegete onCrontabChanged:self.crontabModel];
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

    [self.datapointNameButton mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        maker.left.mas_equalTo(self.datapointNameButton.superview.mas_left).offset(10);
        maker.right.mas_lessThanOrEqualTo(self.repeatLabel.mas_left).offset(-10);
        maker.height.mas_equalTo(50);
    }];

    [self.repeatLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.centerY.mas_equalTo(self.datapointNameButton.mas_centerY).offset(0);
        maker.centerX.mas_equalTo(self.repeatLabel.superview.mas_centerX).offset(0);
        maker.width.mas_equalTo(40);
    }];

    [self.datapointValueButton mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.centerY.mas_equalTo(self.datapointNameButton.mas_centerY).offset(0);
        maker.right.mas_equalTo(self.datapointValueButton.superview.mas_right).offset(-10);
        maker.height.mas_equalTo(30);
        maker.width.mas_equalTo(50);
    }];

    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.top.mas_equalTo(self.datapointNameButton.mas_bottom).offset(10);
        maker.left.mas_equalTo(self.datePicker.superview.mas_left).offset(0);
        maker.right.mas_equalTo(self.datePicker.superview.mas_right).offset(0);
    }];

    [super updateConstraints];
}

@end
