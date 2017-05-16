//
//  IntoDatePicker.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/27.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "IntoDatePicker.h"

@implementation IntoDatePicker

-(void)viewDidLoad{

    self.view.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.0];

    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];


    if(!self.picker){
        self.picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 46, self.view.frame.size.width, 300)];
    }
    self.picker.datePickerMode = UIDatePickerModeTime;
    [self.picker addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:self.picker];
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnDone setTitle:NSLocalizedString(@"done", nil) forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(pickDone) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnDone];

    [self.view addSubview:contentView];

    [self.picker mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.bottom.mas_equalTo(self.picker.superview.mas_bottom).offset(0);
        maker.left.mas_equalTo(self.picker.superview.mas_left).offset(0);
        maker.right.mas_equalTo(self.picker.superview.mas_right).offset(0);
        maker.height.mas_equalTo(200);
    }];

    [btnDone mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.bottom.mas_equalTo(self.picker.mas_top).offset(0);
        maker.right.mas_equalTo(btnDone.superview.mas_right).offset(-10);
        maker.height.mas_equalTo(40);
    }];

    [contentView mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        maker.left.mas_equalTo(self.view.mas_left).offset(0);
        maker.right.mas_equalTo(self.view.mas_right).offset(0);
        maker.height.mas_equalTo(240);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

- (void)showInView:(UIView *)view withFrame:(CGRect)frame andDatePickerMode:(UIDatePickerMode)mode{
}

-(void)valueChanged:(UIDatePicker *)picker{
    
}

- (void)pickDone{
    if (![self.picker respondsToSelector:@selector(picker:ValueChanged:)]) {
        [self.delegate picker:self.picker ValueChanged:self.picker.date];
    }
    [self dismiss];
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
