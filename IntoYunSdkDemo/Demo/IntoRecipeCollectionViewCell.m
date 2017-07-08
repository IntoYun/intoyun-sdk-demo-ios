//
//  IntoRecipeCollectionViewCell.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/10.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import "IntoRecipeCollectionViewCell.h"
#import "RecipeModel.h"
#import "IntoYunSDK.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+IntoYun.h"
#import "MJExtension.h"
#import "Macros.h"
#import "IntoYunFMDBTool.h"

@implementation IntoRecipeCollectionViewCell


+ (instancetype)cellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)reuseIdentifier cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSMutableArray *colorArray = [[NSMutableArray alloc] initWithObjects:MLColor1, MLColor2, MLColor3, MLColor4, MLColor5, MLColor6, nil];

    IntoRecipeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([IntoRecipeCollectionViewCell class]) owner:nil options:nil] lastObject];
    }
    cell.backgroundColor = colorArray[indexPath.row % 6];
    return cell;
}

- (IBAction)runImmediate:(UIButton *)sender {
    IntoWeakSelf;
    [self.runTestButton setBackgroundImage:[UIImage imageNamed:@"play_circle"] forState:UIControlStateNormal];
    [IntoYunAPIManager testRunRecipe:_recipeModel.ID type:_recipeModel.type
                        successBlock:^(id responseObject) {
                            self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                          target:weakSelf
                                                                        selector:@selector(resetCodeButtonTitle)
                                                                        userInfo:nil
                                                                         repeats:YES];
                        }
                          errorBlock:^(NSInteger code, NSString *errorStr) {
                              [MBProgressHUD showError:errorStr];
                          }];
}

- (IBAction)recipeEnabled:(UISwitch *)sender {
    NSLog(@"enable value: %d", sender.isOn);
    NSMutableDictionary *newRecipe = _recipeModel.mj_keyValues;
    [newRecipe setObject:[NSNumber numberWithBool:sender.isOn]  forKey:@"enabled"];

    [IntoYunSDKManager updateRecipe:_recipeModel.ID
                               type:_recipeModel.type
                         recipeInfo:newRecipe
                       successBlock:^(id responseObj) {
                           [MBProgressHUD showSuccess:NSLocalizedString(@"update_success", nil)];
                       }
                         errorBlock:^(NSInteger code, NSString *errorStr) {
                             [MBProgressHUD showError:errorStr];
                         }];
}

- (void)setRecipeModel:(RecipeModel *)recipeModel {
    _recipeModel = recipeModel;
    IntoWeakSelf;

    self.descriptionLabel.text = recipeModel.recipeDescription;
    self.categoryLabel.text = [recipeModel.category isEqualToString:@"period"] ? NSLocalizedString(@"recipe_period", nil) : NSLocalizedString(@"recipe_edge", nil);
    self.enableSwitch.on = recipeModel.enabled;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DeviceModel *triggerDevice = [IntoYunFMDBTool getDeviceWithID:recipeModel.devices[0]];
        DeviceModel *actionDevice = [IntoYunFMDBTool getDeviceWithID:recipeModel.devices[1]];

        NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_Base_URL, triggerDevice.imgSrc]];
        NSData *imageData1 = [NSData dataWithContentsOfURL:url1];
        UIImage *image1 = [UIImage imageWithData:imageData1];

        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_Base_URL, actionDevice.imgSrc]];
        NSData *imageData2 = [NSData dataWithContentsOfURL:url2];
        UIImage *image2 = [UIImage imageWithData:imageData2];

        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.triggerImage.frame = CGRectMake(weakSelf.triggerImage.frame.origin.x, weakSelf.triggerImage.frame.origin.y, 60, 60);
            weakSelf.triggerImage.layer.masksToBounds = YES;
            weakSelf.triggerImage.layer.cornerRadius = 30;

            weakSelf.actionImage.frame = CGRectMake(weakSelf.actionImage.frame.origin.x, weakSelf.actionImage.frame.origin.y, 30, 30);
            weakSelf.actionImage.layer.masksToBounds = YES;
            weakSelf.actionImage.layer.cornerRadius = 15;

            if (image1) {
                weakSelf.triggerImage.image = image1;
            } else {
                weakSelf.triggerImage.image = [UIImage imageNamed:@"placehold1"];
            }
            if (image2) {
                weakSelf.actionImage.image = image2;
            } else {
                weakSelf.actionImage.image = [UIImage imageNamed:@"placehold2"];
            }
        });
    });

}

- (void)resetCodeButtonTitle {
    [self.runTestButton setBackgroundImage:[UIImage imageNamed:@"pause_circle"] forState:UIControlStateNormal];
    [self.timer invalidate];
    self.timer = nil;
}


@end
