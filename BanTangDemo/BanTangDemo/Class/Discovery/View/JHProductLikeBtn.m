//
//  JHProductBtn.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/8/18.
//  Copyright (c) 2015年 Tony Stark. All rights reserved.
//

#import "JHProductLikeBtn.h"
#define separtorWidth 1
#define aniDuration 0.6
#define separtorColor JHColor(217, 217, 217, 1)

@interface JHProductLikeBtn ()
/** 分割线 */
@property (nonatomic, weak)UIView *separator;
@end

@implementation JHProductLikeBtn

- (void)awakeFromNib {
    [self addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self setImage:[UIImage imageNamed:@"hot_product_likeicon"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"hot_product_likeRedicon"] forState:UIControlStateSelected];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    
    // 分割线
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = separtorColor;
    self.separator = separator;
    [self addSubview:separator];
}

static CAAnimationGroup *_likeBtnAniGroup;
- (CAAnimationGroup *)likeBtnAniGroup {// 在这里感觉添加线程锁也是浪费资源
    if (!_likeBtnAniGroup) {
        // 变大动画
        CABasicAnimation *_likeBtnScaleAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        _likeBtnScaleAni.fromValue = @1.0;
        _likeBtnScaleAni.toValue = @5;
        _likeBtnScaleAni.duration = aniDuration;
        // 透明动画
        CABasicAnimation *_likeBtnOpacityAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _likeBtnOpacityAni.fromValue = @1;
        _likeBtnOpacityAni.toValue = @0;
        _likeBtnOpacityAni.duration = aniDuration;
        
        _likeBtnAniGroup = [CAAnimationGroup animation];
        _likeBtnAniGroup.animations = @[_likeBtnScaleAni, _likeBtnOpacityAni];
    }
    return _likeBtnAniGroup;
}

static NSString *const likeBombAnimationKey = @"bomb";
- (void)btnClicked {
    self.selected = !self.selected;
    if (self.selected) {
        [self.imageView.layer addAnimation:[self likeBtnAniGroup] forKey:likeBombAnimationKey];
        [self stringOperationWithInteger:1];
    } else {
        [self stringOperationWithInteger:-1];
    }
}

/** 点赞数处理 */
- (void)stringOperationWithInteger:(NSInteger)num {
    NSInteger newValue = ((NSNumber *)self.titleLabel.text).integerValue + num;
    NSString *newText = [NSNumber numberWithInteger:newValue].stringValue;
    [self setTitle:newText forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 锁定分割线位置,因为分割线的frame要根据superView,所以只能放在这
    CGFloat height = self.height;
    self.separator.frame = CGRectMake(self.width - separtorWidth, height * 0.25, separtorWidth, height * 0.5);
    CGRect imageViewRect = CGRectZero;
    imageViewRect.size = self.imageView.image.size;
    self.imageView.frame = JHRectCenterFromFrame(self.bounds, imageViewRect, 0.15);
}







@end
