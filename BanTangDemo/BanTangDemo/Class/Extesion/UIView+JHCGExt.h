//
//  UIView+JHCGExt.h
//  百思不得姐Demo
//
//  Created by Tony Stark on 15/7/22.
//  Copyright (c) 2015年 Tony Stark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JHCGExt)
@property (nonatomic, assign)CGSize size;
@property (nonatomic, assign)CGFloat x;
@property (nonatomic, assign)CGFloat y;
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)CGFloat centerX;
@property (nonatomic, assign)CGFloat centerY;

CGRect JHRectCenterFromFrame(CGRect frame, CGRect subframe, CGFloat radio);

@end
