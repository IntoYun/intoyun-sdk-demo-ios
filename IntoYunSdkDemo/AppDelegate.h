//
//  AppDelegate.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/3/24.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "IntoLoginViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//登录页面
-(void)setupLoginViewController;
//跳转到首页
-(void)setupHomeViewController:(NSDictionary *)userData;
@end

