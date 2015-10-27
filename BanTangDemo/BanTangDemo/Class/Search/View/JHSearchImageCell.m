//
//  JHSearchImageCell.m
//  
//
//  Created by Tony Stark on 15/9/21.
//
//

#import "JHSearchImageCell.h"

@interface JHSearchImageCell ()

/** imageView */
@property (nonatomic, weak)UIImageView *iv;

@end

@implementation JHSearchImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *iv = [[UIImageView alloc] init];
        self.iv = iv;
        [self.contentView addSubview:iv];
        iv.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:self.iv];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    self.iv.image = image;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    bounds.size.width -= 20;
    bounds.origin.x += 20;
    self.iv.frame = bounds;
}

@end
