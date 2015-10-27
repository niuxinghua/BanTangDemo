//
//  JHIndexController.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/8/28.
//  Copyright (c) 2015年 Tony Stark. All rights reserved.
//

#import "JHSearchController.h"
#import "UIViewController+JHSetTabbarItem.h"
#import "JHCollectionViewLayout.h"
#import <MJExtension.h>
#import "JHSearchModel.h"
#import "JHSearchCell.h"
#import "JHSearchImageCell.h"


@interface JHSearchController ()<UISearchBarDelegate, UISearchControllerDelegate, UICollectionViewDataSource>

/** 搜索栏 */
@property (nonatomic, weak)UISearchBar *searchBar;

/** cell模型数组 */
@property (nonatomic, strong)NSArray *cellData;


@end
static NSString *reuseCellID = @"cellID";
@implementation JHSearchController

- (NSArray *)cellData {
    if (!_cellData) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"class.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *json = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *dataArr = json[@"data"];
        _cellData = [JHSearchModel objectArrayWithKeyValuesArray:dataArr];
    }
    return _cellData;
}

- (JHCollectionViewLayout *)setupFlowLayout {
    JHCollectionViewLayout *layout = [[JHCollectionViewLayout alloc] init];
    return layout;
}

- (instancetype)init {
    if (self = [super initWithCollectionViewLayout:[self setupFlowLayout]]) {
        [self setupTabbarItemWithName:@"搜索"];
        self.collectionView.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self setupNavTextFiled];
//    UINib *nib = [UINib nibWithNibName:@"JHSearchCell" bundle:[NSBundle mainBundle]];
//    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseCellID];
    [self.collectionView registerClass:[JHSearchImageCell class] forCellWithReuseIdentifier:reuseCellID];
}



- (void)setupNavTextFiled {
    // 设置textFiled外型
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 40;
    CGRect rect = CGRectMake(0, 0, width, 30);
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:rect];
    [self changeCancelButtonAttr:searchBar];
    self.searchBar = searchBar;
    searchBar.placeholder = @"搜索感兴趣的专题或单品";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}

/** 修改取消按钮的颜色 */
- (void)changeCancelButtonAttr:(UISearchBar *)searchBar {
    UIView *subView = searchBar.subviews[0];
    for (UIButton *btn in subView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark UICollectViewDataSocure
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellData.count;
}

#define theModel ((JHSearchModel *)(self.cellData[indexPath.item]))
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    JHSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCellID forIndexPath:indexPath];
//    cell.model = theModel;
    JHSearchImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCellID forIndexPath:indexPath];
    [cell setImage:[UIImage imageNamed:theModel.nameCN]];
    return cell;
}

#pragma mark UISearchBarDelegate
/** 准备编辑 */
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    [self changeCancelButtonAttr:searchBar];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
}

/** 结束编辑 */
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}





@end
