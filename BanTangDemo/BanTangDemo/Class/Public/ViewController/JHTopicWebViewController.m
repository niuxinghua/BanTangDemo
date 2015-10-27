//
//  JHTopicWebViewController.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/10/25.
//  Copyright © 2015年 TonyStark106. All rights reserved.
//

#import "JHTopicWebViewController.h"
#import <WebKit/WebKit.h>

@interface JHTopicWebViewController ()
/** webView */
@property (nonatomic, weak)WKWebView *webView;

/** 标题 */
@property (nonatomic, copy)NSString *navTitle;

/** 参数 */
@property (nonatomic, strong)NSURLRequest *request;

@end

@implementation JHTopicWebViewController

- (NSURLRequest *)request {
    if (!_request) {
        NSDictionary *dict = @{
                        //  @"app_installtime" : @"",
                        @"app_versions" : @"4.2.2",
                        @"channel_name" : @"appStore",
                        @"client_id" : @"bt_app_ios",
                        @"client_secret" : @"9c1e6634ce1c5098e056628cd66a17a5",
                        // @"os_versions" : @"8.4",
                        
                        //              @"page" : @(page),
                        
                        @"pagesize" : @"20",
                        // @"screensize" : @"640",
                        // @"track_device_info" : @"iPhone",
                        // @"track_deviceid" : @"",
                        @"v" : @"7"
                        };
        NSURL *URL = [NSURL URLWithString:self.url];
        NSURLRequest *req = [NSURLRequest requestWithURL:URL];
        NSMutableURLRequest *mreq = [req mutableCopy];
        for (NSString *key in dict.allKeys) {
            [mreq setValue:dict[key] forHTTPHeaderField:key];
        }
        _request = [mreq copy];
    }
    return _request;
}

+ (instancetype)topicWithURL:(NSString *)url andTitle:(NSString *)title {
    JHTopicWebViewController *topicVC = [[JHTopicWebViewController alloc] init];
    topicVC.url = url;
    topicVC.navTitle = title;
    return topicVC;
}

+ (instancetype)topicWithURL:(NSString *)url andTitle:(NSString *)title hidden:(BOOL)hidden {
    JHTopicWebViewController *topicVC = [self topicWithURL:url andTitle:title];
    topicVC.isHiddenNav = hidden;
    return topicVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = self.view.frame;
    frame.origin.y -= 45;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:frame];
    [self.view addSubview:webView];
    self.navigationItem.title = self.navTitle;
    NSLog(@"%@", self.request.allHTTPHeaderFields);
    [webView loadRequest:self.request];
}


@end
