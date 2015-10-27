//
//  JHCollectionViewCell.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/10/22.
//  Copyright © 2015年 TonyStark106. All rights reserved.
//

#import "JHCollectionViewCell.h"

@interface JHCollectionViewCell ()



@end

@implementation JHCollectionViewCell

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *iv = [[UIImageView alloc] init];
        _imageView = iv;
        [self.contentView addSubview:iv];
    }
    return _imageView;
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}


@end
