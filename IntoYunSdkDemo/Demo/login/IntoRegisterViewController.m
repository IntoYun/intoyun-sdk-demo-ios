//
//  IntoRegisterViewController.m
//  IntoYunSDKDemo
//
//  Created by 梁惠源 on 16/8/15.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "IntoRegisterViewController.h"
#import "IntoYunSDK.h"
#import "MBProgressHUD+IntoYun.h"


// 注册类型
typedef NS_ENUM(NSInteger, IntoRegisterType) {
    IntoRegisterTypePhone,      // 手机注册
    IntoRegisterTypeEmail,      // 邮箱注册
};

@interface IntoRegisterViewController () {
    int currentCounting;//当前计数
}

@property(weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property(weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property(weak, nonatomic) IBOutlet UITextField *codeTextField;
@property(weak, nonatomic) IBOutlet UIButton *codeButton;
/** 邮箱注册或者手机注册 */
@property(nonatomic, assign) IntoRegisterType registerType;
@property(nonatomic, strong) NSTimer *timer;
@property(weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation IntoRegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/**
 *  获取验证码
 */
- (void) getVldCode {

    IntoWeakSelf;
    if ([_phoneNumTextField.text isMobileNumber]) { // 手机号
        self.registerType = IntoRegisterTypePhone;
        [IntoYunSDKManager getVerifyCode:self.phoneNumTextField.text
                            successBlock:^(id responseObject) {
                                [weakSelf codeGetSuccess];
                            }
                              errorBlock:^(NSInteger code, NSString *errorStr) {
                                  [MBProgressHUD showError:errorStr];
                              }];
    } else {
        [MBProgressHUD showError:NSLocalizedString(@"the phone number is incorrect", nil)];
        return;
    }
}

- (IBAction)checkAccountRegistered:(UIButton *)sender {
    IntoWeakSelf;
    if ([_phoneNumTextField.text isMobileNumber]) { // 手机号
        self.registerType = IntoRegisterTypePhone;
        [IntoYunSDKManager checkAccountRegistered:_phoneNumTextField.text
                                      accountType:PHONE
                                     successBlock:^(id responseObject){
                                         // 获取短信验证码
                                         [weakSelf getVldCode];
                                     }
                                       errorBlock:^(NSInteger code, NSString *errorStr) {
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
    self.registerButton.enabled = YES;
    [self.codeButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"verification code count time", nil), 60 - currentCounting] forState:UIControlStateDisabled];
    currentCounting++;
}

// 提交
- (IBAction)commitData:(UIButton *)sender {
    IntoWeakSelf;

    [IntoYunSDKManager registerAccount:self.phoneNumTextField.text
                              password:self.passwordTextField.text
                               vldCode:self.codeTextField.text
                          successBlock:^(id responseObject) {
                              [weakSelf.navigationController popViewControllerAnimated:YES];
                              [MBProgressHUD showSuccess:NSLocalizedString(@"Register successful", nil)];
                          }
                            errorBlock:^(NSInteger code, NSString *errorStr) {
                                [MBProgressHUD showError:errorStr];
                            }];
}

@end
