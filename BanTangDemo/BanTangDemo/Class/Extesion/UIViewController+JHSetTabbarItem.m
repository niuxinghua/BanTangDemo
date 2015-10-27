//
//  UIViewController+JHSetTabbarItem.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/9/15.
//  Copyright © 2015年 TonyStark106. All rights reserved.
//

#import "UIViewController+JHSetTabbarItem.h"

@implementation UIViewController (JHSetTabbarItem)


- (void)setupTabbarItemWithName:(NSString *)name {
    // 设置logo
    UIImage *tabBarItemImage = [UIImage imageNamed:[NSString stringWithFormat:@"tab_%@", name]];
    UIImage *tabBarItemSelectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tab_%@_pressed", name]];
    tabBarItemImage = [tabBarItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItemSelectedImage = [tabBarItemSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabbarItem = [[UITabBarItem alloc] initWithTitle:name image:tabBarItemImage selectedImage:tabBarItemSelectedImage];
    
    // 设置title
    NSDictionary *textNormalAttrs = @{NSForegroundColorAttributeName : JHDefaultFontGaryColor()};
    NSDictionary *textSelectedAttrs = @{NSForegroundColorAttributeName : JHDefaultSelectedColor()};
    [tabbarItem setTitleTextAttributes:textNormalAttrs forState:UIControlStateNormal];
    [tabbarItem setTitleTextAttributes:textSelectedAttrs forState:UIControlStateSelected];
    
    self.tabBarItem = tabbarItem;
}

@end
