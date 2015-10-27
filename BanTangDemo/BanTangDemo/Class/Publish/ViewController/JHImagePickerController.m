//
//  JHImagePickerController.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/9/15.
//  Copyright © 2015年 TonyStark106. All rights reserved.
//

#import "JHImagePickerController.h"

@interface JHImagePickerController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation JHImagePickerController

+ (instancetype)shareImagePickerVC {
    JHImagePickerController *imageVC = [[JHImagePickerController alloc] init];
    imageVC.delegate = imageVC;
    return imageVC;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 拦截左边的按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:kNilOptions target:self action:@selector(dismissImageVC)];
    NSDictionary *textAttr = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    // 标题
    viewController.navigationItem.title = @"相机胶卷";
    [leftItem setTitleTextAttributes:textAttr forState:UIControlStateNormal];
    viewController.navigationItem.leftBarButtonItem = leftItem;
    // 过滤右边的按钮
    viewController.navigationItem.rightBarButtonItem = nil;
}


- (void)dismissImageVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
