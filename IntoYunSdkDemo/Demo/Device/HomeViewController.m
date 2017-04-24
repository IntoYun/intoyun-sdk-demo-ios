//
//  HomeViewController.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/7.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import "HomeViewController.h"
#import "IntoYunMQTTManager.h"

@interface HomeViewController () <IntoYunMQTTManagerDelegate, UITabBarControllerDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UITabBar appearance].translucent = NO;

    [[IntoYunMQTTManager shareInstance] subscribeMessages:self subscribeHandler:nil];

    int count = 0;
    id countValue = [[NSUserDefaults standardUserDefaults] valueForKey:@"intoyun_badge"];
    if (countValue) {
        count = [countValue intValue];
    }
    if (count > 0) {
        [self.tabBar items][1].badgeValue = [NSString stringWithFormat:@"%d", count];
    }
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)messageTopic:(NSString *)topic data:(NSData *)dic {
    // 收到的数据
    if (dic) {
        NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:dic options:NSJSONReadingMutableLeaves error:nil];
        if (result) {
            int count = 0;
            id countValue = [[NSUserDefaults standardUserDefaults] valueForKey:@"intoyun_badge"];
            if (countValue) {
                count = [countValue intValue];
            }
            if (count >= 0) {
                count++;
                [self.tabBar items][1].badgeValue = [NSString stringWithFormat:@"%d", count];
            }
            [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"intoyun_badge"];
            [[IntoYunMQTTManager shareInstance] cleanMessage];
        }
    }
}

#pragma mark -设置tabBarItem字体属性

- (void)setupItemTitle {
    // 默认模式
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    NSMutableDictionary *attriDict = [NSMutableDictionary dictionary];
    attriDict[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    attriDict[NSForegroundColorAttributeName] = [UIColor grayColor];
    [tabBarItem setTitleTextAttributes:attriDict forState:UIControlStateNormal];

    // 选中模式
    NSMutableDictionary *attriSelDict = [NSMutableDictionary dictionary];
    attriSelDict[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.0 green:0xc6 / 255.0 blue:1.0 alpha:1.0];
    [tabBarItem setTitleTextAttributes:attriSelDict forState:UIControlStateSelected];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)addAllSubViewController {
    IntoDeviceViewController *deviceTableViewController = [[IntoDeviceViewController alloc] init];
    deviceTableViewController.userData = self.userData;
    [self addSubViewController:deviceTableViewController
                   tabBarImage:[UIImage imageNamed:@"tab_device"]
           tabBarSelectedImage:[UIImage imageNamed:@"tab_device_selected"]
                         title:NSLocalizedString(@"tab_device_title", nil)];
    RecipeCollectionViewController *recipeTableViewController = [[RecipeCollectionViewController alloc] init];
    [self addSubViewController:recipeTableViewController
                   tabBarImage:[UIImage imageNamed:@"tab_recipe"]
           tabBarSelectedImage:[UIImage imageNamed:@"tab_recipe_selected"]
                         title:NSLocalizedString(@"tab_recipe_title", nil)];

    IntoMessageTableViewController *messageTableViewController = [[IntoMessageTableViewController alloc] init];
    [self addSubViewController:messageTableViewController
                   tabBarImage:[UIImage imageNamed:@"tab_message"]
           tabBarSelectedImage:[UIImage imageNamed:@"tab_message_selected"]
                         title:NSLocalizedString(@"message_title", nil)];

    IntoPersionViewController *mineViewController = [[IntoPersionViewController alloc] init];
    [self addSubViewController:mineViewController
                   tabBarImage:[UIImage imageNamed:@"tab_mine"]
           tabBarSelectedImage:[UIImage imageNamed:@"tab_mine_selected"]
                         title:NSLocalizedString(@"mine_title", nil)];
}


//添加子视图
- (void)addSubViewController:(UIViewController *)viewController tabBarImage:(UIImage *)image tabBarSelectedImage:(UIImage *)selectedImage title:(NSString *)title {
    viewController.tabBarItem.image = image;
    viewController.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.title = title;

    viewController.title = title;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self addChildViewController:navigationController];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSInteger index = tabBarController.selectedIndex;
    if (index == 1){
        [[self.tabBar items][1] setBadgeValue:nil];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"intoyun_badge"];
    }
}


@end
