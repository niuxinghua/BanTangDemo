//
//  AppDelegate.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/8/16.
//  Copyright (c) 2015年 Tony Stark. All rights reserved.
//

#import "AppDelegate.h"
#import "JHTabbarController.h"
#import "JHNavigationController.h"
#import "JHIndexController.h"
#import "JHDiscoveryController.h"
#import "JHSearchController.h"
#import "JHMeController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 创建主窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // tabBar控制器
    JHTabbarController *tabBarVC = [[JHTabbarController alloc] init];
    // 首页控制器
    JHIndexController *indexVC = [[JHIndexController alloc] init];
    JHNavigationController *indexNav = [[JHNavigationController alloc] initWithRootViewController:indexVC];
    
    // 发现控制器
    JHDiscoveryController *discVC = [[JHDiscoveryController alloc] init];
    JHNavigationController *discNav = [[JHNavigationController alloc] initWithRootViewController:discVC];
    
    // 搜索控制器
    JHSearchController *searchVC = [[JHSearchController alloc] init];
    JHNavigationController *searchNav = [[JHNavigationController alloc] initWithRootViewController:searchVC];
    
    // "我"控制器
    JHMeController *meVC = [[JHMeController alloc] init];
    
    [tabBarVC addChildViewController:indexNav];
    [tabBarVC addChildViewController:discNav];
    [tabBarVC addChildViewController:searchNav];
    [tabBarVC addChildViewController:meVC];
    self.window.rootViewController = tabBarVC;
    
    // 设置窗口的根控制器
    [self.window makeKeyAndVisible];
    
    return YES;
}





@end
