//
//  IntoResetPWViewController.m
//  IntoYunSDKDemo
//
//  Created by 梁惠源 on 16/8/15.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "IntoResetPWViewController.h"
#import "IntoYunSDK.h"
#import "MBProgressHUD+IntoYun.h"
#import "NSString+MLString.h"

// 账号类型
typedef NS_ENUM(NSInteger, IntoResertPWType) {
    IntoResetPWTypePhone,      // 手机账号
    IntoResetPWTypeEmail,      // 邮箱账号
};

@interface IntoResetPWViewController () {
    int currentCounting;//当前计数
}

@property(weak, nonatomic) IBOutlet UITextField *PhoneNumTextField;
@property(weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property(weak, nonatomic) IBOutlet UITextField *codeTextField;

@property(weak, nonatomic) IBOutlet UIButton *codeButton;
@property(weak, nonatomic) IBOutlet UIButton *sureButton;

@property(nonatomic, strong) NSTimer *timer;
/** 账号类型 */
@property(nonatomic, assign) IntoResertPWType accoutType;

@end

@implementation IntoResetPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)requestCodeToResetPW:(UIButton *)sender {

    /**
     *  获取验证码
     */

    IntoWeakSelf;
    if (!_PhoneNumTextField.hasText) {
        [MBProgressHUD showError:NSLocalizedString(@"please input phone number", nil)];
        return;
    } else if ([_PhoneNumTextField.text isMobileNumber] && ![_PhoneNumTextField.text isValidateEmail]) { // 手机号
        self.accoutType = IntoResetPWTypePhone;
        [IntoYunSDKManager getVerifyCode:self.PhoneNumTextField.text successBlock:^(id responseObject) {
            [weakSelf codeGetSuccess];
        }                     errorBlock:^(NSInteger code, NSString *errorStr) {
            [MBProgressHUD showError:errorStr];
        }];
    } else {
        [MBProgressHUD showError:NSLocalizedString(@"the phone number is incorrect", nil)];
        return;
    }
}


- (void)codeGetSuccess {
    currentCounting = 0;
    self.codeButton.enabled = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(resetCodeButtonTitle)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)resetCodeButtonTitle {
    if (currentCounting == 60) {
        [self.codeButton setTitle:NSLocalizedString(@"Get verification code", nil) forState:UIControlStateNormal];
        [self.codeButton setTitle:NSLocalizedString(@"Get verification code", nil) forState:UIControlStateDisabled];
        self.codeButton.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    self.sureButton.enabled = YES;
    [self.codeButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"verification code count time", nil), 60 - currentCounting] forState:UIControlStateDisabled];
    currentCounting++;
}

- (IBAction)commitButtonClick:(UIButton *)sender {
    IntoWeakSelf;
    [IntoYunSDKManager resetPassword:self.PhoneNumTextField.text
                            password:self.passwordTextField.text
                             vldCode:self.codeTextField.text
                        SuccessBlock:^(id responseObject) {
                            [MBProgressHUD showSuccess:NSLocalizedString(@"change successful", nil)];
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }
                          errorBlock:^(NSInteger code, NSString *errorStr) {

                              [MBProgressHUD showError:errorStr];
                          }];
}

@end
