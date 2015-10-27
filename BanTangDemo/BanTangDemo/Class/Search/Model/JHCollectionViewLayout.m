//
//  JHCollectionViewLayout.m
//  
//
//  Created by Tony Stark on 15/9/17.
//
//

#import "JHCollectionViewLayout.h"

@interface JHCollectionViewLayout ()


@end

@implementation JHCollectionViewLayout


- (CGSize)collectionViewContentSize {
    CGSize size = [UIScreen mainScreen].bounds.size;
    // 除去导航栏和tabBar的高度
    CGSize contentSize = CGSizeMake(size.width , size.height - 64 - 49);
    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attrs = [NSMutableArray array];
    CGSize contentSize = [self collectionViewContentSize];
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat height = contentSize.height / (cellCount * 0.5);
    CGFloat width = contentSize.width * 0.5;
    CGFloat x;
    CGFloat y;
    CGRect cellRect;
    for (NSInteger i = 0; i < cellCount; i++) {
        x = i % 2 * width;
        y = i / 2 * height;
        cellRect = CGRectMake(x, y, width, height);
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attr.frame = cellRect;
        [attrs addObject:attr];
    }
    return attrs;
}



@end
