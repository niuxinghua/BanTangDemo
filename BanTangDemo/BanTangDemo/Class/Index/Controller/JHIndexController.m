//
//  JHIndexController.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/8/28.
//  Copyright (c) 2015年 Tony Stark. All rights reserved.
//



#import "JHIndexController.h"
#import "JHAFNetworkingTool.h"
#import <JHBannerView.h>
#import "UIViewController+JHSetTabbarItem.h"
#import "JHLoginContrioller.h"
#import "NSString+ExtendTool.h"
#import "JHBanner.h"
#import "JHTopic.h"
#import <MJExtension.h>
#import "JHTopicView.h"
#import "JHEntry.h"
#import "JHCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import <Masonry.h>
#import "JHTopicWebViewController.h"
#import "JHTopicListViewController.h"
#import "JHNiceProductController.h"

@interface JHIndexController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, JHBannerViewDelegate>

/** 轮播图 */
@property (nonatomic, weak)JHBannerView *bannerView;
/** networkTool */
@property (nonatomic, weak)JHAFNetworkingTool *networkTool;
/** banner数组 */
@property (nonatomic, strong)NSArray *banners;
/** topic数组 */
@property (nonatomic, strong)NSMutableArray *topics;
/** entry_list */
@property (nonatomic, strong)NSArray *entrys;

/** tableView */
@property (nonatomic, weak)UITableView *tableView;
/** collectionView */
@property (nonatomic, weak)UICollectionView *collectionView;

/** 记录上一次调用时的Y值 */
@property (nonatomic, assign)CGFloat yy;
/** 顶部粉色背景view */
@property (nonatomic, weak)UIView *pineView;


@end


@implementation JHIndexController
static NSString *cellID = @"cell";

- (NSMutableArray *)topics {
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupTabbarItemWithName:@"首页"];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    [self setupTableView];
    [self getNewData];
    [self setupRefresh];
}

- (void)getNewData {
    [self.tableView.header beginRefreshing];
    [[JHAFNetworkingTool defaultTool]getDataWithNetworkingType:JHNetworkingTypeIndexGetNew success:^(id respone) {
        self.banners = [JHBanner objectArrayWithKeyValuesArray:respone[@"data"][@"banner"]];
        self.entrys = [JHEntry objectArrayWithKeyValuesArray:respone[@"data"][@"entry_list"]];
        if (self.topics.count >= 20) {
            NSArray *newData = [JHTopic objectArrayWithKeyValuesArray:respone[@"data"][@"topic"]];
            for (NSInteger i = 0; i < newData.count; i++) {
                self.topics[i] = newData[i];
            }
        } else {
            self.topics = [JHTopic objectArrayWithKeyValuesArray:respone[@"data"][@"topic"]];
        }
        // 插入额外的活动图片
        NSArray *extDatas = [JHTopic objectArrayWithKeyValuesArray:respone[@"data"][@"firstpage_element"]];
        for (JHTopic *extData in extDatas) {
            JHTopic *topic = self.topics[(extData.index - 1)];
            if (topic.index == 0) {
                [self.topics insertObject:extData atIndex:(extData.index - 1)];
            }
        }
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

- (void)getMoreData {
    [self.tableView.footer beginRefreshing];
    [[JHAFNetworkingTool defaultTool]getDataWithNetworkingType:JHNetworkingTypeIndexGetMore success:^(id respone) {
        // 增加帖子
        NSArray *newData = [JHTopic objectArrayWithKeyValuesArray:respone[@"data"][@"topic"]];
        [self.topics addObjectsFromArray:newData];
        [self.tableView.footer endRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshingWithNoMoreData];
    }];
}

- (void)setupRefresh {
    self.tableView.header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewData)];
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
}

- (void)setupTableView {
    CGRect frame = [UIScreen mainScreen].bounds;
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView addSubview:tableView];
    
    frame.size.height = 20;
    UIView *pineView = [[UIView alloc] initWithFrame:frame];
    [bgView addSubview:pineView];
    pineView.backgroundColor = JHColor(232, 86, 93, 1);
    self.pineView = pineView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pineView.mas_bottom).with.offset(44);
        make.left.equalTo(bgView.mas_left).with.offset(0);
        make.right.equalTo(bgView.mas_right).with.offset(0);
        make.bottom.equalTo(bgView.mas_bottom).with.offset(0);
    }];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

- (void)setupNav {
    // 标题栏
    UIImageView *navIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nar_logo"]];
    navIconView.size = navIconView.image.size;
    self.navigationItem.titleView = navIconView;
    
    // 左边按钮
    UIImage *leftImage = [UIImage imageNamed:@"subscribe_icon"];
    leftImage = [leftImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStyleDone target:self action:@selector(leftBtnClicked)];
    leftItem.imageInsets = UIEdgeInsetsMake(0, -barButtonOffset, 0, 0);
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 右边按钮
    UIImage *rightImage = [UIImage imageNamed:@"sign_bar_icon"];
    rightImage = [rightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClicked)];
    rightItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupHeader {
    if (!self.tableView.tableHeaderView) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGRect frame = CGRectMake(0, 0, width, 0.5 * width);
        // bannerView
        JHBannerView *bannerView = [[JHBannerView alloc] initWithFrame:frame];
        self.bannerView = bannerView;
        bannerView.delegate = self;
        
        // collectionView
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        frame.origin.y = frame.size.height;
        frame.size.height = 120;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[JHCollectionViewCell class] forCellWithReuseIdentifier:cellID];
        flowLayout.itemSize = CGSizeMake(100, 100);
        self.collectionView = collectionView;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        collectionView.showsHorizontalScrollIndicator = NO;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        frame.size.height += frame.origin.y;
        frame.origin.y = 0;
        UIView *view = [[UIView alloc] initWithFrame:frame];
        [view addSubview:bannerView];
        [view addSubview:collectionView];
        self.tableView.tableHeaderView = view;
    }
}

- (void)setBanners:(NSArray *)banners {
    _banners = banners;
    NSMutableArray *allPicURLStrings = [NSMutableArray array];
    for (JHBanner *banner in self.banners) {
        [allPicURLStrings addObject:banner.photo];
    }
    self.bannerView.images = allPicURLStrings;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)setEntrys:(NSArray *)entrys {
    _entrys = entrys;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.entrys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[self.entrys[indexPath.item] pic1]]];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        JHNiceProductController *niceVC = [[JHNiceProductController alloc] init];
        [self.navigationController pushViewController:niceVC animated:YES];
        return;
    }
    JHEntry *entry = self.entrys[indexPath.item];
    JHTopicWebViewController *topicVC = [JHTopicWebViewController topicWithURL:entry.share_url andTitle:entry.title];
    [self.navigationController pushViewController:topicVC animated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self setupHeader];
    return self.topics.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHTopic *topic = self.topics[indexPath.row];
    if ([topic.type isEqualToString:@"webview"]) {
        JHTopicWebViewController *topicVC = [JHTopicWebViewController topicWithURL:topic.extend andTitle:topic.title];
        [self.navigationController pushViewController:topicVC animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JHTopicView *topicView = (JHTopicView *)cell.subviews.firstObject.subviews.firstObject;
    if (!topicView) {
        topicView = [JHTopicView topicViewWithFrame:CGRectMake(0, 0, tableView.size.width, 150) topic:nil];
        [cell.contentView addSubview:topicView];
    }
    topicView.topic = self.topics[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIView *navBar = self.navigationController.navigationBar;
    CGRect frame = navBar.frame;
    CGFloat offestY = scrollView.contentOffset.y;
    BOOL isDowning = self.yy < offestY;
    BOOL isTop = offestY < 200;
    self.yy = offestY;
    BOOL isNavBarHidden = frame.origin.y < -43;
    BOOL isBottom = scrollView.contentSize.height - offestY < scrollView.size.height;
    if (isDowning && !isTop && !isNavBarHidden) {// 向下滑
        frame.origin.y = -44;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pineView.mas_bottom).with.offset(0);
        }];
    }
    if ((!isDowning || isTop) && isNavBarHidden && !isBottom) {// 向上滑和最顶时显示
        frame.origin.y = 20;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pineView.mas_bottom).with.offset(44);
        }];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBar.frame = frame;
    }];
}

#pragma mark JHBannerViewDelegate
- (void)bannerView:(JHBannerView *)bannerView didPictureClickedAtIndex:(NSInteger)index {
    JHBanner *banner = self.banners[index];
    if ([banner.type isEqualToString:@"topic_list"]) {
        NSString *ids = [banner.extend extendNumber];
        JHTopicListViewController *topicListVC = [JHTopicListViewController TopicList:ids andTitle:banner.title];
        [self.navigationController pushViewController:topicListVC animated:YES];
        return;
    }
    if ([banner.type isEqualToString:@"webview"]) {
        JHTopicWebViewController *wv = [JHTopicWebViewController topicWithURL:banner.extend andTitle:banner.title];
        [self.navigationController pushViewController:wv animated:YES];
        return;
    }
}

#pragma mark 事件响应
- (void)leftBtnClicked {
    JHLoginContrioller *lc = [JHLoginContrioller loginVC];
    [self presentViewController:lc animated:YES completion:nil];
}

- (void)rightBtnClicked {
    JHLoginContrioller *lc = [JHLoginContrioller loginVC];
    [self presentViewController:lc animated:YES completion:nil];
}






@end
