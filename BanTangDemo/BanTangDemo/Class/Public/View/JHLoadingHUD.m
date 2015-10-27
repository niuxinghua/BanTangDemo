//
//  JHLoadingHUD.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/8/25.
//  Copyright (c) 2015年 Tony Stark. All rights reserved.
//

#import "JHLoadingHUD.h"
#import "JHLoadingCircleView.h"

@implementation JHLoadingHUD

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        JHLoadingCircleView *circleView = [JHLoadingCircleView circleViewIsBigger:YES];
        [self addSubview:circleView];
    }
    return self;
}

- (void)stopAnimation {
    [self removeFromSuperview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = self.superview.bounds;
}

@end
