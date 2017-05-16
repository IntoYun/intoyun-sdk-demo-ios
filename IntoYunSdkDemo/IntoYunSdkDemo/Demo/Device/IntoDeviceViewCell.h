//
//  IntoDeviceViewCell.h
//  IntoYunSDKDemo
//
//  Created by 梁惠源 on 16/8/17.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceModel.h"

@interface IntoDeviceViewCell : UICollectionViewCell



@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *accessModeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;


+ (instancetype)cellWithCollection:(UICollectionView *)collectionView  reuseIdentifier:(NSString *)reuseIdentifier cellForItemAtIndexPath:(NSIndexPath *)indexPath;

/** 设备字典数据 */
@property (nonatomic,strong) DeviceModel *deviceModel;

@end
