//
//  JHSubjectZeroController.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/10/26.
//  Copyright © 2015年 TonyStark106. All rights reserved.
//

#import "JHSubjectZeroController.h"
#import "JHProductZero.h"

@interface JHSubjectZeroController ()

/** 顶端图片 */
@property (nonatomic, weak)UIImageView *imageView;

/** 详文介绍的label */
@property (nonatomic, weak)UILabel *label;

/** collectView */
@property (nonatomic, weak)UICollectionView *collectionView;

/** 半糖精选按钮 */
@property (nonatomic, weak)UIButton *niceBtn;

/** 用户推荐按钮 */
@property (nonatomic, weak)UIButton *userBtn;

@end

@implementation JHSubjectZeroController

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
        [self.view addSubview:imageView];
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] init];
        self.label = label;
        [self.view addSubview:label];
    }
    return _label;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        self.collectionView = collectionView;
        [self.view addSubview:collectionView];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.view.bounds;
    self.imageView.frame = CGRectMake(0, 64, frame.size.width, frame.size.width / 600 * 270);
    
}







@end
