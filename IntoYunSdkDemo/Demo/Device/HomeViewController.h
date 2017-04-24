//
//  HomeViewController.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/7.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntoDeviceViewController.h"
#import "RecipeCollectionViewController.h"
#import "IntoMessageTableViewController.h"
#import "IntoPersionViewController.h"


@interface HomeViewController : UITabBarController
/** 用户信息 */
@property (nonatomic,strong) NSDictionary *userData;

@end
