//
//  JHTabbarController.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/9/15.
//  Copyright © 2015年 TonyStark106. All rights reserved.
//

#import "JHTabbarController.h"
#import "JHNavigationController.h"
#import "JHImagePickerController.h"
#import "JHLoginContrioller.h"

@interface JHTabbarController ()<UITabBarControllerDelegate>

/** 标示是否已添加中间的发布按钮 */
@property (nonatomic, assign)BOOL isAddPublishVC;

@end

@implementation JHTabbarController


- (void)viewDidLoad {
    self.delegate = self;
    self.isAddPublishVC = NO;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController.tabBarItem.title isEqualToString:@"publish"]) {
        // 弹出发布控制器
        JHImagePickerController *imageVC = [JHImagePickerController shareImagePickerVC];
        [self presentViewController:imageVC animated:YES completion:nil];
        return NO;
    }
    if ([viewController.tabBarItem.title isEqualToString:@"我"]) {
        // 弹出登录控制器
        JHLoginContrioller *loginVC = [JHLoginContrioller loginVC];
        [self presentViewController:loginVC animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (void)addChildViewController:(UIViewController *)childController {
    // 拦截，添加发布控制器
    if (self.childViewControllers.count == 2 && !self.isAddPublishVC) {
        self.isAddPublishVC = YES;
        [self createPublishVC];
    }
    [super addChildViewController:childController];
}

/** “发布”占位控制器 */
- (void)createPublishVC {
    // 将图像渲染修改为原生
    UIViewController *publishVC = [[UIViewController alloc] init];
    UIImage *image = [UIImage imageNamed:@"tab_publish_add"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage = [UIImage imageNamed:@"tab_publish_add"];
    selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 添加控制器
    publishVC.tabBarItem.image = image;
    publishVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_publish_add_pressed"];
    publishVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    publishVC.tabBarItem.title = @"publish";
    publishVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 10);
    [self addChildViewController:publishVC];
}


@end
