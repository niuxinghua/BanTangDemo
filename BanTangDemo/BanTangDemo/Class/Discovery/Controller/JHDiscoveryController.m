//
//  JHDiscoveryController.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/9/15.
//  Copyright © 2015年 TonyStark106. All rights reserved.
//


#import "JHDiscoveryController.h"
#import "UIViewController+JHSetTabbarItem.h"
#import "JHSegmentedControl.h"
#import "JHLoginContrioller.h"
#import <MJRefresh.h>
#import "JHAFNetworkingTool.h"


@interface JHDiscoveryController ()<UITableViewDataSource, UITableViewDelegate>

/** 标题栏的开关控件 */
@property (nonatomic, weak)JHSegmentedControl *seg;

/** headerView的4个imageView */
@property (nonatomic, strong)NSArray *ivs;

/** tableVi */
@property (nonatomic, weak)UITableView *tableView;

@end

@implementation JHDiscoveryController
- (instancetype)init {
    if (self = [super init]) {
        [self setupTabbarItemWithName:@"发现"];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTitleView];
    [self setupTableView];
    [self setupRefresh];
    [self getNewData];
}

- (void)setupRefresh {
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewData)];
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
}

- (void)getNewData {
    [[JHAFNetworkingTool defaultTool] getDataWithNetworkingType:JHNetworkingTypeDiscoveryGetNew success:^(id respone) {
        NSLog(@"%@", respone);
    } failure:^(NSError *error) {
        
    }];
}

- (void)getMoreData {

}

- (void)setupTableView {
    // headerView
    CGFloat width = self.view.frame.size.width;
    CGFloat height = width * 0.6;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    UIImageView *iv0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height, height)];
    CGFloat iv1Width = width / 3 * 2;
    UIImageView *iv1 = [[UIImageView alloc] initWithFrame:CGRectMake(width, 0, iv1Width, iv1Width)];
    CGFloat iv2Width = width / 3;
    UIImageView *iv2 = [[UIImageView alloc] initWithFrame:CGRectMake(width, iv1Width, iv2Width, iv2Width)];
    UIImageView *iv3 = [[UIImageView alloc] initWithFrame:CGRectMake(width + iv2Width, iv1Width, iv2Width, iv2Width)];
    self.ivs = @[iv0, iv1, iv2, iv3];
    for (UIView *iv in self.ivs) {
        [headerView addSubview:iv];
    }
        
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.tableHeaderView = headerView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
}

- (void)setupTitleView {
    JHSegmentedControl *titleView = [JHSegmentedControl shareMeForTarget:self SEL1:@selector(recommend) andAction2:@selector(follow)];
    self.seg = titleView;
    self.navigationItem.titleView = titleView;
}

// 点击精选的响应事件
- (void)recommend {
}

// 点击关注的响应事件
- (void)follow {
    JHLoginContrioller *loginVC = [JHLoginContrioller loginVC];
    [self presentViewController:loginVC animated:YES completion:^{
        self.seg.selectedSegmentIndex = 0;
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


#pragma mark UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}


@end