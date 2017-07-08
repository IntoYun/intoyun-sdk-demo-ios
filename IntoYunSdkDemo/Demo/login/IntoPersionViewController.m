//
//  IntoPersionViewController.m
//  IntoYunSDKDemo
//
//  Created by 梁惠源 on 16/8/16.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "IntoPersionViewController.h"
#import "IntoYunSDK.h"
#import "MBProgressHUD+IntoYun.h"
#import "Macros.h"
#import "AppDelegate.h"

@interface IntoPersionViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property(weak, nonatomic) IBOutlet UIImageView *userAvatar;

@property(weak, nonatomic) IBOutlet UIView *backgroundView;

@property(strong, nonatomic) NSDictionary *userInfo;
/** 用户ID */
@property(nonatomic, copy) NSString *userId;
/** 修改输入框 */
@property(nonatomic, weak) UITextField *changeUserText;

@end

@implementation IntoPersionViewController

- (void)viewWillAppear:(BOOL)animated {

    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];

    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.userAvatar.userInteractionEnabled = YES;//打开用户交互
    //初始化一个手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [singleTap setNumberOfTapsRequired:1];
    //为图片添加手势
    [self.userAvatar addGestureRecognizer:singleTap];


    self.navigationItem.title = NSLocalizedString(@"mine_title", nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nill) style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id) SetColor(0x12, 0xca, 0xff, 1.0).CGColor, (__bridge id) SetColor(0x15, 0x83, 0xe1, 1.0).CGColor];
    gradientLayer.locations = @[@0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = self.backgroundView.frame;
    [self.backgroundView.layer insertSublayer:gradientLayer atIndex:0];
    self.userAvatar.image = [UIImage imageNamed:@"user_default"];


    self.userNameLabel.text = NSLocalizedString(@"nickname", nil);

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userId = [defaults stringForKey:@"uid"];

    IntoWeakSelf;
    [IntoYunSDKManager getUserInfo:^(id responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf setUpViewWith:responseObject];
                });
            }
                        errorBlock:^(NSInteger code, NSString *errorStr) {
                            [MBProgressHUD showError:errorStr];
                        }];

}

- (void)viewWillDisappear:(BOOL)animated {
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}


- (void)setUpViewWith:(NSDictionary *)responseObj {
    IntoWeakSelf;
    self.userInfo = responseObj;
    self.userNameLabel.text = responseObj[@"username"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_Base_URL, responseObj[@"imgSrc"]]];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.userAvatar.frame = CGRectMake(weakSelf.userAvatar.frame.origin.x, weakSelf.userAvatar.frame.origin.y, 80, 80);
            weakSelf.userAvatar.layer.masksToBounds = YES;
            weakSelf.userAvatar.layer.cornerRadius = 40;
            if (image) {
                weakSelf.userAvatar.image = image;
            } else {
                weakSelf.userAvatar.image = [UIImage imageNamed:@"user_default"];
            }
        });
    });

}


- (void)singleTapAction:(UITapGestureRecognizer *)sender {
    IntoWeakSelf;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];

    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        // 跳转到相机页面
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = weakSelf;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;

        [self presentViewController:picker animated:YES completion:NULL];

    }]];

    // 添加按钮 <UIAlertActionStyleDestructive>
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"从手机相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 跳转到相机页面
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = weakSelf;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;

        [self presentViewController:picker animated:YES completion:NULL];

    }];
    [alertController addAction:sure];

    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }]];
    if (DeviceUIIdiom == UIUserInterfaceIdiomPhone) { // iPhone
        // 在当前控制器上面弹出另一个控制器：alertController  显示
        [self presentViewController:alertController animated:YES completion:nil];

    } else if (DeviceUIIdiom == UIUserInterfaceIdiomPad) { //ipad

        // 在当前控制器上面弹出另一个控制器：alertController  显示
        UIPopoverPresentationController *popPresenter = [alertController
                popoverPresentationController];
        popPresenter.sourceView = self.backgroundView;
        popPresenter.sourceRect = self.backgroundView.bounds;
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    IntoWeakSelf;
    UIImage *image = [[UIImage alloc] init];
    image = [info objectForKey:UIImagePickerControllerEditedImage];

    NSURL *imageURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    NSLog(@"path: %@", imageURL);
    [MBProgressHUD showMessage:@"正在上传"];
    [picker dismissViewControllerAnimated:YES completion:^{
        if (NULLString([weakSelf.userInfo valueForKey:@"imgSrc"])) {
            [IntoYunSDKManager uploadAvatar:image
                                       type:@"user"
                                         ID:[weakSelf.userInfo valueForKey:@"uid"]
                               successBlock:^(id response) {
                                   [MBProgressHUD hideHUD];
                                   [MBProgressHUD showSuccess:NSLocalizedString(@"change successful", nil)];
                               }
                                 errorBlock:^(NSInteger code, NSString *err) {
                                     [MBProgressHUD hideHUD];
                                     [MBProgressHUD showError:err];
                                 }];
        } else {
            [IntoYunSDKManager updateAvatar:image
                                   avatarId:[weakSelf.userInfo valueForKey:@"uid"]
                                       type:@"user"
                               successBlock:^(id response) {
                                   [MBProgressHUD hideHUD];
                                   [MBProgressHUD showSuccess:NSLocalizedString(@"change successful", nil)];
                               }
                                 errorBlock:^(NSInteger code, NSString *err) {
                                     [MBProgressHUD hideHUD];
                                     [MBProgressHUD showError:err];
                                 }];
        }

    }];
}

/**
 *  退出登录
 */
- (IBAction)loginOut:(UIButton *)sender {

    [IntoYunSDKManager userLogout:^(id responseObject) {
                [MBProgressHUD showSuccess:@"退出成功"];
                [(AppDelegate *) AppDelegateInstance setupLoginViewController];

            }
                       errorBlock:^(NSInteger code, NSString *errorStr) {
                           [MBProgressHUD showError:errorStr];
                       }];
}

/**
 *  修改用户名
 */
- (IBAction)chengeUserName:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改用户名称" message:nil preferredStyle:UIAlertControllerStyleAlert];

    // 添加按钮
    IntoWeakSelf;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSString *newName = weakSelf.changeUserText.text;
        parameters[@"username"] = newName;
    }];
    [alertController addAction:sure];

    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }]];

    // 还可以添加文本框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {

        textField.placeholder = @"请输入用户名";
        weakSelf.changeUserText = textField;
    }];

    // 在当前控制器上面弹出另一个控制器：alertController
    [self presentViewController:alertController animated:YES completion:nil];

}


@end
