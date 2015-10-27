//
//  JHTopicBannerViewController.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/10/25.
//  Copyright © 2015年 TonyStark106. All rights reserved.
//



#import "JHTopicListViewController.h"
#import "JHAFNetworkingTool.h"
#import "UIViewController+JHSetTabbarItem.h"
#import "JHTopic.h"
#import <MJExtension.h>
#import "JHTopicView.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import <Masonry.h>
#import "JHTopicWebViewController.h"

@interface JHTopicListViewController () <UITableViewDataSource, UITableViewDelegate>

/** networkTool */
@property (nonatomic, weak)JHAFNetworkingTool *networkTool;
/** topic枚举字符串 */
@property (nonatomic, strong)NSString *ids;

/** topic数组 */
@property (nonatomic, strong)NSArray *topics;

/** tableView */
@property (nonatomic, weak)UITableView *tableView;

/** 记录上一次调用时的Y值 */
@property (nonatomic, assign)CGFloat yy;
/** 顶部粉色背景view */
@property (nonatomic, weak)UIView *pineView;


@end


@implementation JHTopicListViewController
static NSString *cellID = @"cell";

+ (instancetype)TopicList:(NSString *)topics andTitle:(NSString *)title {
    JHTopicListViewController *topicVC = [[JHTopicListViewController alloc] init];
    topicVC.navigationItem.title = title;
    topicVC.ids = topics;
    return topicVC;
}

- (instancetype)init {
    if (self = [super init]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
    [self getNewData];
    [self setupRefresh];
}

- (void)getNewData {
    [self.tableView.header beginRefreshing];
    [[JHAFNetworkingTool defaultTool]getTopicListDataWithIDS:self.ids success:^(id respone) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.topics = [JHTopic objectArrayWithKeyValuesArray:respone[@"data"][@"topic"]];
            NSLog(@"%@", respone);
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.header endRefreshing];
        });
    }];
}

- (void)setupRefresh {
    self.tableView.header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewData)];
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

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topics.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHTopic *topic = self.topics[indexPath.row];
    if ([topic.type isEqualToString:@"0"]) {

    }
//    if ([topic.type isEqualToString:@"1"]) {
//        
//    }
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







@end
