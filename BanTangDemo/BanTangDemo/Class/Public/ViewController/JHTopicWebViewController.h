//
//  JHTopicWebViewController.h
//  BanTangDemo
//
//  Created by Tony Stark on 15/10/25.
//  Copyright © 2015年 TonyStark106. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHTopicWebViewController : UIViewController

/** url */
@property (nonatomic, copy)NSString *url;

/** 是否隐藏移动浏览器的导航栏 */
@property (nonatomic, assign)BOOL isHiddenNav;

+ (instancetype)topicWithURL:(NSString *)url andTitle:(NSString *)title;

+ (instancetype)topicWithURL:(NSString *)url andTitle:(NSString *)title hidden:(BOOL)hidden;

@end
