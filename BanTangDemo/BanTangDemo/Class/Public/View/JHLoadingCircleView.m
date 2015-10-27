//
//  JHLoadingCircleView.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/8/25.
//  Copyright (c) 2015年 Tony Stark. All rights reserved.
//

#import "JHLoadingCircleView.h"

@implementation JHLoadingCircleView

+ (instancetype)circleViewIsBigger:(BOOL)isBigger {
    UIImage *image;
    if (isBigger) {
        image = [UIImage imageNamed:@"loading"];
    } else {
        image = [UIImage imageNamed:@"loading_small"];
    }
    JHLoadingCircleView *circle = [[JHLoadingCircleView alloc] initWithImage:image];
    circle.size = circle.image.size;
    // 设置读取菊花的动画
    CABasicAnimation *rotationAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAni.fromValue = @0;
    rotationAni.toValue = @(M_PI * 2);
    rotationAni.repeatCount = NSIntegerMax;
    rotationAni.duration = 0.5;
    [circle.layer addAnimation:rotationAni forKey:nil];
    
    return circle;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 保持居中
    self.center = self.superview.center;
    self.center = [self.superview.superview convertPoint:self.superview.center toView:self.superview];
}

@end
