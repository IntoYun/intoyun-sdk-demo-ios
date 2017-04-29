//
//  DeviceCollectionViewCell.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/26.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DeviceModel;

@interface DeviceCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) DeviceModel *deviceModel;

+ (instancetype)cellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)reuseIdentifier cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@end
