//
//  UIScrollView+UITouch.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/15.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import "UIScrollView+UITouch.h"

@implementation UIScrollView (UITouch)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 选其一即可
    [super touchesBegan:touches withEvent:event];
    //    [[self nextResponder] touchesBegan:touches withEvent:event];
}

@end
