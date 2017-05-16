//
//  IntoChangePasswordViewController.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/20.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import "IntoChangePasswordViewController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+IntoYun.h"
#import "IntoYunSDKManager.h"

@interface IntoChangePasswordViewController () <UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UITextField *oldPassword;
@property(weak, nonatomic) IBOutlet UITextField *anewPassword1;
@property(weak, nonatomic) IBOutlet UITextField *anewPassword2;
@property(weak, nonatomic) IBOutlet UIButton *btnSubmmit;

@end

@implementation IntoChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"change_password", nil);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_oldPassword.hasText && _anewPassword1.hasText && _anewPassword2.hasText) {
        self.btnSubmmit.enabled = YES;
    } else {
        self.btnSubmmit.enabled = NO;
    }
}

- (IBAction)submmit:(UIButton *)sender {
    if (![_anewPassword1.text isEqualToString:_anewPassword2.text]) {
        [MBProgressHUD showError:NSLocalizedString(@"new_password_diff", nil)];
        return;
    }

    [IntoYunSDKManager changePassword:_oldPassword.text
                          newPassword:_anewPassword2.text
                         successBlock:^(id responseObj) {
                             [MBProgressHUD showSuccess:NSLocalizedString(@"change successful", nil)];
                             [self.navigationController popViewControllerAnimated:YES];
                         }
                           errorBlock:^(NSInteger code, NSString *err) {
                               [MBProgressHUD showError:err];
                           }];
}
@end
