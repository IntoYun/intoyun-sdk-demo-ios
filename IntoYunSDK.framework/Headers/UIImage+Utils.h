//
//  UIImage+Utils.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/20.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

// 生成指定大小的图片
- (UIImage *)scaleToSize:(CGSize)newsize;

// 给图片重新绘制一个颜色
- (UIImage *)imageWithOverlayColor:(UIColor *)color;

// 生成一张指定颜色的图片
+ (UIImage *)imageWithColor:(UIColor *)color;

//添加背景图片合并
- (UIImage *)mergeImageWithBGImage:(UIImage *)BGImage;

//改变图片颜色
- (UIImage *)imageWithColor:(UIColor *)color;

// 压缩图片
- (NSData *)imageData;

@end
