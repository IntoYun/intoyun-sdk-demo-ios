//
//  IntoDatePicker.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/27.
//  Copyright © 2017年 hui he. All rights reserved.
//

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

#import <UIKit/UIKit.h>


@protocol IntoDatePickerDelegate <NSObject>

@optional
//当UIDatePicker值变化时所用到的代理
- (void)picker:(UIDatePicker *)picker ValueChanged:(NSDate *)date;

@end

@interface IntoDatePicker : UIViewController

@property  (weak, nonatomic) id<IntoDatePickerDelegate> delegate;

@property  (strong, nonatomic) UIDatePicker *picker;

- (void)showInView:(UIView *)view withFrame:(CGRect)frame andDatePickerMode:(UIDatePickerMode)mode;

- (void)dismiss;

- (void)valueChanged:(UIDatePicker *)picker;

@end

