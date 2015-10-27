//
//  JHNavigationController.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/8/16.
//  Copyright (c) 2015年 Tony Stark. All rights reserved.
//

#import "JHNavigationController.h"

@implementation JHNavigationController

/** 初始化所有navgationBar的样式 */
+ (void)initialize {
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.barTintColor = JHDefaultBackgroundColor();
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

- (void)setupLeftBtnWithVC:(UIViewController *)vc {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"public_back_btn"] forState:UIControlStateNormal];
    btn.size = btn.imageView.image.size;
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    vc.navigationItem.leftBarButtonItem = leftBarBtn;
}

/** 重写push方法,第二个以后入栈的控制器添加统一的返回按钮 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        [self setupLeftBtnWithVC:viewController];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    [self setupLeftBtnWithVC:viewControllerToPresent];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewControllerToPresent];
    [super presentViewController:nav animated:flag completion:completion];
}

/** 左上角返回按钮点击事件 */
- (void)back {
    if (self.childViewControllers.count > 1) {
        [self popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/** 设置状态栏样式 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
