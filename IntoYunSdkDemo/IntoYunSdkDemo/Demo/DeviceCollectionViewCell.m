//
//  DeviceCollectionViewCell.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/26.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import "DeviceCollectionViewCell.h"
#import "DeviceModel.h"
#import "View+MASAdditions.h"
#import "IntoYunSDK.h"
#import "Macros.h"

@interface DeviceCollectionViewCell ()

//设备头像
@property(nonatomic, weak) UIImageView *deviceAvatarImageView;
//设备名称
@property(nonatomic, weak) UILabel *deviceNameLabel;

@end


@implementation DeviceCollectionViewCell


CGFloat height = 60;

- (instancetype)init {
    if (self = [super init]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        self.deviceAvatarImageView = imageView;

        UILabel *uiLabel = [[UILabel alloc] init];
        uiLabel.font = [UIFont systemFontOfSize:12];
        uiLabel.textColor = [UIColor whiteColor];
        uiLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:uiLabel];
        self.deviceNameLabel = uiLabel;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self  = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        self.deviceAvatarImageView = imageView;
        
        UILabel *uiLabel = [[UILabel alloc] init];
        uiLabel.font = [UIFont systemFontOfSize:12];
        uiLabel.textColor = [UIColor whiteColor];
        uiLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:uiLabel];
        self.deviceNameLabel = uiLabel;
    }
    return self;
}

+ (instancetype)cellWithCollection:(UICollectionView *)collectionView reuseIdentifier:(NSString *)reuseIdentifier cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *colorArray = [[NSMutableArray alloc] initWithObjects:MLColor1, MLColor2, MLColor3, MLColor4, MLColor5, MLColor6, nil];
    
    DeviceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DeviceCollectionViewCell class]) owner:nil options:nil] lastObject];
    }
    cell.backgroundColor = colorArray[indexPath.row % 6];
    return cell;
}

-(void)setDeviceModel:(DeviceModel *)deviceModel{
    _deviceModel = deviceModel;
    IntoWeakSelf;
    self.deviceNameLabel.text = deviceModel.name;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_Base_URL, deviceModel.imgSrc]];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.deviceAvatarImageView.frame = CGRectMake(weakSelf.deviceAvatarImageView.frame.origin.x,weakSelf.deviceAvatarImageView.frame.origin.y, height, height);
            weakSelf.deviceAvatarImageView.layer.masksToBounds = YES;
            weakSelf.deviceAvatarImageView.layer.cornerRadius = height/2;
            if (image) {
                weakSelf.deviceAvatarImageView.image = image;
            } else {
                weakSelf.deviceAvatarImageView.image = [UIImage imageNamed:@"placehold1"];
            }
        });
    });
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    // Configure the view for the selected state
    
    if(selected){
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.5];
    } else {
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:1.0];
    }
}

+(BOOL)requiresConstraintBasedLayout {
    return YES;
}


-(void)updateConstraints {
    [self.deviceAvatarImageView mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.height.mas_equalTo(height);
        maker.width.mas_equalTo(height);
        maker.centerX.mas_equalTo(self.deviceNameLabel.mas_centerX).offset(0);
        maker.centerX.mas_equalTo(self.mas_centerX).offset(0);
        maker.top.mas_equalTo(self.mas_top).offset(10);
    }];
    [self.deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_greaterThanOrEqualTo(self.deviceAvatarImageView.mas_bottom).offset(5);
        maker.bottom.mas_equalTo(self.mas_bottom).offset(-5);
        maker.left.mas_equalTo(self.mas_left).offset(10);
        maker.right.mas_equalTo(self.mas_right).offset(-10);
        maker.height.mas_equalTo(20);
    }];
    [super updateConstraints];
}



@end
