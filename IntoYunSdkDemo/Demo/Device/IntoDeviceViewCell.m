//
//  IntoDeviceViewCell.m
//  IntoYunSDKDemo
//
//  Created by 梁惠源 on 16/8/17.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "IntoDeviceViewCell.h"
#import "MBProgressHUD+IntoYun.h"
#import "Macros.h"
#import "IntoYunFMDBTool.h"
#import "IntoYunSDK.h"

@implementation IntoDeviceViewCell

+ (instancetype)cellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)reuseIdentifier cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSMutableArray *colorArray = [[NSMutableArray alloc] initWithObjects:MLColor1, MLColor2, MLColor3, MLColor4, MLColor5, MLColor6, nil];

    IntoDeviceViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([IntoDeviceViewCell class]) owner:nil options:nil] lastObject];
    }
    cell.backgroundColor = colorArray[indexPath.row % 6];

    return cell;
}

- (void)setDeviceModel:(DeviceModel *)deviceModel {
    _deviceModel = deviceModel;
    IntoWeakSelf;

    self.nameLabel.text = deviceModel.name;
    self.statusLabel.text = deviceModel.online ? NSLocalizedString(@"device_online", nil) : NSLocalizedString(@"device_offline", nil);
    self.accessModeLabel.text = deviceModel.accessMode;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_Base_URL, deviceModel.imgSrc]];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.deviceImageView.frame = CGRectMake(weakSelf.deviceImageView.frame.origin.x,weakSelf.deviceImageView.frame.origin.y, 60, 60);
            weakSelf.deviceImageView.layer.masksToBounds = YES;
            weakSelf.deviceImageView.layer.cornerRadius = 30;
            if (image) {
                weakSelf.deviceImageView.image = image;
            } else {
                weakSelf.deviceImageView.image = [UIImage imageNamed:@"placehold1"];
            }
        });
    });
}

@end
