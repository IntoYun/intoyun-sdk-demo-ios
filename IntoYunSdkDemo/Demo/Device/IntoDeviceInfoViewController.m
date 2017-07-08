//
//  IntoDeviceInfoViewController.m
//  IntoYunSDKDemo
//
//  Created by 梁惠源 on 16/8/16.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "IntoDeviceInfoViewController.h"
#import "IntoYunSDK.h"
#import "MBProgressHUD+IntoYun.h"
#import "DeviceModel.h"
#import "Macros.h"

@interface IntoDeviceInfoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *deviceAvatar;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@end

@implementation IntoDeviceInfoViewController



- (void)viewWillAppear:(BOOL)animated {

    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];

    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.deviceAvatar.userInteractionEnabled = YES;//打开用户交互
    //初始化一个手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [singleTap setNumberOfTapsRequired:1];
    //为图片添加手势
    [self.deviceAvatar addGestureRecognizer:singleTap];

    self.deviceNameLabel.text = self.deviceDic.name;
    self.deviceDescriptionLabel.text = self.deviceDic.deviceDescription;

    self.navigationItem.title = NSLocalizedString(@"device_info", nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nill) style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id) SetColor(0x12, 0xca, 0xff, 1.0).CGColor, (__bridge id) SetColor(0x15, 0x83, 0xe1, 1.0).CGColor];
    gradientLayer.locations = @[@0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = self.backgroundView.frame;
    [self.backgroundView.layer insertSublayer:gradientLayer atIndex:0];
    [self initDeviceAvatar];
}


-(void)initDeviceAvatar{
    IntoWeakSelf;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_Base_URL, weakSelf.deviceDic.imgSrc]];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.deviceAvatar.frame = CGRectMake(weakSelf.deviceAvatar.frame.origin.x,weakSelf.deviceAvatar.frame.origin.y, 80, 80);
            weakSelf.deviceAvatar.layer.masksToBounds = YES;
            weakSelf.deviceAvatar.layer.cornerRadius = 40;
            if (image) {
                weakSelf.deviceAvatar.image = image;
            } else {
                weakSelf.deviceAvatar.image = [UIImage imageNamed:@"placehold1"];
            }
        });
    });
}


-(IBAction)changeDeviceInfo:(UIButton *)sender{

    IntoWeakSelf;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"change_device_info", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    // 添加按钮
    __weak typeof(alert) weakAlert = alert;
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"点击了确定按钮--%@-%@", [weakAlert.textFields.firstObject text], [weakAlert.textFields.lastObject text]);
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:[weakAlert.textFields.firstObject text] forKey:@"name"];
        [parameters setValue:[weakAlert.textFields.lastObject text] forKey:@"description"];

        [IntoYunSDKManager updateDeviceInfo:weakSelf.deviceDic.deviceId parameters:parameters successBlock:^(id response){
            [MBProgressHUD showSuccess:NSLocalizedString(@"change successful", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } errorBlock:^(NSInteger code, NSString *err){
            [MBProgressHUD showError:err];
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消按钮");
    }]];

    // 添加文本框
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.textColor = [UIColor redColor];
        textField.placeholder = NSLocalizedString(@"device_name", nil);
        textField.text = weakSelf.deviceDic.name;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.textColor = [UIColor redColor];
        textField.placeholder = NSLocalizedString(@"device_description", nil);
        textField.text = weakSelf.deviceDic.deviceDescription;
    }];


    [self presentViewController:alert animated:YES completion:nil];
}


- (void)viewWillDisappear:(BOOL)animated {
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
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
        if (NULLString(weakSelf.deviceDic.imgSrc)) {
            [IntoYunSDKManager uploadAvatar:image
                                       type:@"device"
                                         ID:weakSelf.deviceDic.deviceId
                               successBlock:^(id response) {
                                   [MBProgressHUD hideHUD];
                                   [MBProgressHUD showSuccess:NSLocalizedString(@"change successful", nil)];
                               }
                                 errorBlock:^(NSInteger code, NSString *err) {
                                     [MBProgressHUD hideHUD];
                                     [MBProgressHUD showError:err];
                                 }];
        } else {
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"/v1/avatar/(\\w+)" options:NSRegularExpressionCaseInsensitive error:&error];
            NSTextCheckingResult *result = [regex firstMatchInString:weakSelf.deviceDic.imgSrc options:0 range:NSMakeRange(0, [weakSelf.deviceDic.imgSrc length])];
            if (result) {
                NSLog(@"%@\n", [weakSelf.deviceDic.imgSrc substringWithRange:result.range]);
                NSArray *array =[[weakSelf.deviceDic.imgSrc substringWithRange:result.range] componentsSeparatedByString:@"/"];
                
                [IntoYunSDKManager updateAvatar:image
                                       avatarId:array[3]
                                           type:@"device"
                                   successBlock:^(id response) {
                                       [MBProgressHUD hideHUD];
                                       [MBProgressHUD showSuccess:NSLocalizedString(@"change successful", nil)];
                                   }
                                     errorBlock:^(NSInteger code, NSString *err) {
                                         [MBProgressHUD hideHUD];
                                         [MBProgressHUD showError:err];
                                     }];
            }
        }

    }];
}


/**
 *  修改信息的弹窗
 *
 *  @param title        标题
 *  @param sureHandle   确定按钮点击回调
 *  @param cancelHandle 取消按钮点击回调
 *  @param configHandle 文本框输入
 */
- (UIAlertController *)alertControlWithTitle:(NSString *)title sureActionHandle:(void(^)(UIAlertAction *sureAction))sureHandle cancelActionHandle:(void(^)(UIAlertAction *cancelAction))cancelHandle configHandle:(void(^)(UITextField *textField))configHandle{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:sureHandle];
    [alertController addAction:sureAction];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancelHandle]];
    [alertController addTextFieldWithConfigurationHandler:configHandle];
    return alertController;
}

@end
