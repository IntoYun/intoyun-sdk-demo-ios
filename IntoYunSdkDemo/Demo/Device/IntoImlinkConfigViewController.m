//
//  IntoImlinkConfigViewController.m
//  IntoYunSDKDemo
//
//  Created by 梁惠源 on 16/8/16.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "IntoImlinkConfigViewController.h"
#import "MBProgressHUD+IntoYun.h"

@interface IntoImlinkConfigViewController () <UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UITextField *wifiSSID;
@property(weak, nonatomic) IBOutlet UITextField *wifiPassword;
@property(weak, nonatomic) IBOutlet UILabel *buttonLabel;
@property(weak, nonatomic) IBOutlet UIButton *startButton;
@property(assign, nonatomic) BOOL startConfig;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(strong, nonatomic) IntoYunIMLinkManager *imLinkManager;

@end

@implementation IntoImlinkConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"imlink_config", nil);
    self.wifiSSID.delegate = self;
    self.startConfig = NO;
    self.imLinkManager = [[IntoYunIMLinkManager alloc] init];
    self.imLinkManager.delegete = self;

    [self initGifImageView];

    //注册键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //增加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneInForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

}


- (void)viewWillAppear:(BOOL)animated {
    //获取wifi SSID并显示到界面的wifiSSID UITextField中
    self.wifiSSID.text = [self.imLinkManager getSSID];
}

-(void)appHasGoneInForeground {
    //获取wifi SSID并显示到界面的wifiSSID UITextField中
    self.wifiSSID.text = [self.imLinkManager getSSID];
}


//键盘弹出后将视图向上移动
- (void)keyboardWillShow:(NSNotification *)note {
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //目标视图UITextField
    CGRect frame = self.wifiPassword.frame;
    int y = frame.origin.y + frame.size.height - (self.view.frame.size.height - keyboardSize.height);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if (y > 0) {
        self.view.frame = CGRectMake(0, -y, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}

//键盘隐藏后将视图恢复到原始状态
- (void)keyboardWillHide:(NSNotification *)note {
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)initGifImageView {
    self.startButton.imageView.animationImages = [self animationImages]; //获取Gif图片列表
    self.startButton.imageView.animationDuration = 2;     //执行一次完整动画所需的时长
    self.startButton.imageView.animationRepeatCount = 0;  //动画重复次数

}

- (NSArray *)animationImages {
    NSMutableArray *imagesArr = [NSMutableArray array];
    for (int i = 1; i < 10; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"config_button0%d", i]];
        if (image) {
            [imagesArr addObject:image];
        }
    }
    return imagesArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createDevice:(UIButton *)sender {
    if (self.startConfig) {
        [self.startButton.imageView stopAnimating];
        self.buttonLabel.text = NSLocalizedString(@"start", nil);
        [self.imLinkManager stopImLinkConfig:YES];
    } else {
        [self.startButton.imageView startAnimating];
        self.buttonLabel.text = NSLocalizedString(@"starting", nil);
        [self.imLinkManager startImLinkConfig:_wifiSSID.text wifiPassword:_wifiPassword.text];
    }
    self.startConfig = !self.startConfig;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_wifiSSID.hasText) {
        self.startButton.enabled = YES;
    } else {
        self.startButton.enabled = NO;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self createDevice:nil];
    return YES;
}

- (void)configSuccess:(id)response {
    NSLog(@"config success");
    [self.startButton.imageView stopAnimating];
    self.buttonLabel.text = NSLocalizedString(@"start", nil);
}

- (void)configError:(NSString *)errorStr {
    NSLog(@"config error: %@", errorStr);
    [MBProgressHUD showError:errorStr];
    [self.startButton.imageView stopAnimating];
    self.buttonLabel.text = NSLocalizedString(@"start", nil);
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.startButton.imageView stopAnimating];
    [self.imLinkManager stopImLinkConfig:YES];
    //别忘了删除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
