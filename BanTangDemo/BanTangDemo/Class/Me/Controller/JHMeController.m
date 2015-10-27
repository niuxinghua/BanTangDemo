//
//  JHIndexController.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/8/28.
//  Copyright (c) 2015年 Tony Stark. All rights reserved.
//

#import "JHMeController.h"
#import "UIViewController+JHSetTabbarItem.h"


@implementation JHMeController

- (instancetype)init {
    if (self = [super init]) {
        [self setupTabbarItemWithName:@"我"];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}



@end
