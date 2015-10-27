//
//  JHNiceProductController.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/10/26.
//  Copyright © 2015年 TonyStark106. All rights reserved.
//

#import "JHNiceProductController.h"

@interface JHNiceProductController ()<UICollectionViewDataSource, UICollectionViewDelegate>

/** 类型选择 */
@property (nonatomic, weak)UICollectionView *typeCollectionView;

/** 详细内容 */
@property (nonatomic, weak)UICollectionView *detailsCollectionView;

/** 选项 */
@property (nonatomic, strong)NSArray *typeArr;

/** 红色指示器 */
@property (nonatomic, weak)UIView *indView;

@end

static NSString *ID = @"cell";
@implementation JHNiceProductController

- (NSArray *)typeArr {
    if (!_typeArr) {
        _typeArr = [NSArray arrayWithObjects:@"最新", @"创意", @"家具", @"食品", @"美妆", @"杂货", @"穿搭", @"鞋包", @"男士", @"厨具", @"数码", @"办公", @"主题", @"书籍", @"卫浴", @"运动", @"植物", nil];
    }
    return _typeArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"精选好物";
    [self setupTypeCollectionView];
//    [self setupDetailsCollectionView];
}

- (void)setupTypeCollectionView {
    CGFloat width = self.view.bounds.size.width;
    CGRect frame = CGRectMake(0, 64, width, 40);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(width * 0.15, 40);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    collectView.showsHorizontalScrollIndicator = NO;
    collectView.scrollEnabled = YES;
    collectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectView];
    self.typeCollectionView = collectView;
    [collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    collectView.dataSource = self;
    collectView.delegate = self;
    // 指示器
    frame.origin.y = 38;
    frame.size.height = 2;
    frame.size.width = flowLayout.itemSize.width;
    UIView *indView = [[UIView alloc] initWithFrame:frame];
    indView.backgroundColor = JHDefaultBackgroundColor();
    self.indView = indView;
    [collectView addSubview:indView];
}

- (void)setupDetailsCollectionView {
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    CGRect frame = CGRectMake(0, 104, width, height - 104);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    [self.view addSubview:collectView];
    self.detailsCollectionView = collectView;
    collectView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    collectView.dataSource = self;
    collectView.delegate = self;
}

#pragma mark UICollectViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.typeCollectionView) {
        return self.typeArr.count;
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.typeCollectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        UILabel *label = (UILabel *)cell.contentView.subviews.lastObject;
        if (!label) {
            label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
            label.textColor = JHDefaultFontGaryColor();
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
        }
        label.text = self.typeArr[indexPath.item];
        return cell;
    } else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.typeCollectionView) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.indView.frame;
            frame.origin.x = cell.frame.origin.x;
            self.indView.frame = frame;
            // 设置contentOffset
            if (indexPath.item <= 2) {// 靠左
                collectionView.contentOffset = CGPointMake(0, 0);
                return;
            } else if (self.typeArr.count - indexPath.item <= 4) {// 靠右
                collectionView.contentOffset = CGPointMake(collectionView.contentSize.width - self.view.frame.size.width, 0);
                return;
            }
            collectionView.contentOffset = CGPointMake(cell.frame.origin.x - ((UICollectionViewFlowLayout *)collectionView.collectionViewLayout).itemSize.width * 2, 0);
        }];
    }
}




@end