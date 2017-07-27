//
//  AppDelegate.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/3/24.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import "AppDelegate.h"
#import "IntoYunSDK.h"
#import "Macros.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //test intoyun
//    [IntoYunSDKManager initWithAppID:@"94574c9fb4e8d4a74471c988c788eabf" appSecret:@"ba1b4c6e14c94d3c57d8e298ff6a7ca6" debugLog:YES];
    
    // yanglan test
//    [IntoYunSDKManager initWithAppID:@"faf1ebb1a0b053b9e5712b234e72a7c2" appSecret:@"7815d5c1aaa63d302f4881d745cfb82d" debugLog:YES];
    
    //intoyun
    [IntoYunSDKManager initWithAppID:@"36c125683434195b8c1ce306887daf3c" appSecret:@"e3b0b621301b4e0d2e60f5f1bba2b410" debugLog:YES];

    [IntoYunSDKManager getAppToken:^(id responseObject) {

    }
                        errorBlock:^(NSInteger code, NSString *errorStr) {
                            NSLog(@"%@", errorStr);

    }];


    //设置NavigationBar背景颜色
    [[UINavigationBar appearance] setBarTintColor:PrimaryColor];
    //@{}代表Dictionary
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    return YES;
}

#pragma mark 自定义跳转不同的页面

//登录页面
- (void)setupLoginViewController {
//    IntoLoginViewController *logInVc = [[IntoLoginViewController alloc] init];
//    self.window.rootViewController = logInVc;
    
    //通过storyboard加载页面
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.window.rootViewController = [storyBoard instantiateInitialViewController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

//首页
- (void)setupHomeViewController:(NSDictionary *)userData {
//    HomeViewController *tabBarController = [[HomeViewController alloc] init];
//    tabBarController.userData = userData;
//    [self.window setRootViewController:tabBarController];
    
    //通过storyboard加载页面
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"DeviceList" bundle:nil];
    self.window.rootViewController = [storyBoard instantiateInitialViewController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
