//
//  RecipeDetailViewController.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/28.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecipeModel;

@interface RecipeDetailViewController : UIViewController

@property(nonatomic, strong) RecipeModel *createRecipe;

@property (nonatomic, assign) BOOL isCreate;

@end
