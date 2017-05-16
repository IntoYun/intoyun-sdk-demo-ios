//
//  IntoRecipeCollectionViewCell.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/10.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecipeModel;

@interface IntoRecipeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) RecipeModel *recipeModel;

@property (nonatomic, weak) IBOutlet UIImageView *triggerImage;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *categoryLabel;
@property (nonatomic, weak) IBOutlet UIImageView *actionImage;
@property (nonatomic, weak) IBOutlet UISwitch *enableSwitch;
@property (nonatomic, weak) IBOutlet UIButton *runTestButton;
@property (nonatomic, weak) NSTimer *timer;



+ (instancetype)cellWithCollection:(UICollectionView *)collectionView  reuseIdentifier:(NSString *)reuseIdentifier cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (IBAction)runImmediate:(UIButton *)sender;

- (IBAction)recipeEnabled:(UISwitch *)sender;

@end
