//
//  ViewController.m
//  IntoYunSDKDemo
//
//  Created by 梁惠源 on 16/8/12.
//  Copyright © 2016年 MOLMC. All rights reserved.
//
#import "AppDelegate.h"
#import "IntoYunSDK.h"
#import "MBProgressHUD+IntoYun.h"
#import "Macros.h"

@interface ViewController () <UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UITextField *accountText;
@property(weak, nonatomic) IBOutlet UITextField *passwordText;
@property(weak, nonatomic) IBOutlet UIButton *loginButton;
/** 用户模型 */
@property(nonatomic, strong) NSDictionary *userData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    if (_accountText.hasText && _passwordText.hasText) {
        self.loginButton.enabled = YES;
    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nill) style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)loginButton:(UIButton *)sender {
    IntoWeakSelf;
    
    [MBProgressHUD showMessage:NSLocalizedString(@"Login loading", nil)];
    [IntoYunSDKManager userLogin:self.accountText.text
                        password:self.passwordText.text
                    successBlock:^(id responseObject) {
                        weakSelf.userData = responseObject;
                        [MBProgressHUD hideHUD];
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:responseObject[@"uid"] forKey:@"uid"];
                        [defaults setObject:responseObject[@"token"] forKey:@"userToken"];
                        [defaults setObject:responseObject[@"email"] forKey:@"email"];

                        //登录成功后跳转到首页
                        [(AppDelegate *)AppDelegateInstance setupHomeViewController:weakSelf.userData];

                    }
                      errorBlock:^(NSInteger code, NSString *errorStr) {
                          [MBProgressHUD hideHUD];
                          [MBProgressHUD showError:errorStr];
                      }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginToDevice"]) {
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_accountText.hasText && _passwordText.hasText) {
        self.loginButton.enabled = YES;
    } else {
        self.loginButton.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self loginButton:nil];
    return YES;
}
@end
