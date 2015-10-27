//
//  JHAFNetworkingTool.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/8/24.
//  Copyright (c) 2015年 Tony Stark. All rights reserved.
//

#import "JHAFNetworkingTool.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension.h>
#import <JHBannerView.h>

NSString *const kJHDiscoveryURL = @"http://open3.bantangapp.com/product/list";
NSString *const kJHIndexURL = @"http://open3.bantangapp.com/recommend/index";
NSString *const KJHTopicListURL = @"http://open3.bantangapp.com/topic/list";
NSString *const kJHSubjectURL = @"http://open3.bantangapp.com/topic/info";

static JHAFNetworkingTool *defaultTool;
@interface JHAFNetworkingTool ()<NSCopying, NSMutableCopying>

/** 首页的page */
@property (nonatomic, assign)NSInteger indexPage;

/** 发现的page */
@property (nonatomic, assign)NSInteger discoveryPage;

/** 参数 */
@property (nonatomic, strong)NSMutableDictionary *params;

@end

@implementation JHAFNetworkingTool

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized(self) {
        if (!defaultTool) {
            defaultTool = [super allocWithZone:zone];
        }
        return defaultTool;
    }
    return nil;
}

+ (instancetype)defaultTool {
    @synchronized(self) {
        if (!defaultTool) {
            defaultTool = [[JHAFNetworkingTool alloc] init];
        }
    }
    return defaultTool;
}

- (instancetype)init {
    @synchronized(self) {
        return [super init];
    }
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

- (NSMutableDictionary *)params {
    if (!_params) {
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
        _params = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    return _params;
}

- (NSArray *)requestWithType:(JHNetworkingType)type {
    NSMutableDictionary *params = [self.params mutableCopy];
    switch (type) {
        case JHNetworkingTypeIndexGetNew:
            params[@"page"] = @(0);
            return @[kJHIndexURL, self.params];
        case JHNetworkingTypeIndexGetMore:
            ++self.indexPage;
            params[@"page"] = @(self.indexPage);
            return @[kJHIndexURL, self.params];
        case JHNetworkingTypeDiscoveryGetNew:
            params[@"page"] = @(0);
            return @[kJHDiscoveryURL, self.params];
        case JHNetworkingTypeDiscoveryGetMore:
            ++self.discoveryPage;
            params[@"page"] = @(self.discoveryPage);
            return @[kJHDiscoveryURL, self.params];
        case JHNetworkingTypeTopicList:
            return @[KJHTopicListURL, self.params];
        default:
            NSLog(@"%@", @"输入错误参数");
            return nil;
    }
}

- (void)getDataWithNetworkingType:(JHNetworkingType)type success:(void(^)(id respone))successBlock failure:(void(^)(NSError *error))failureBlock {
    NSArray *request = [self requestWithType:type];
    NSString *urlStr = request.firstObject;
    NSMutableDictionary *params = request.lastObject;
    if (type == JHNetworkingTypeIndexGetNew || type == JHNetworkingTypeIndexGetMore) {
        [[AFHTTPSessionManager manager]GET:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            successBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
                failureBlock(error);
            }];
        }];
    } else {
        params[@"last_time"] = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
        NSLog(@"%@", params[@"last_time"]);
        params[@"pagesize"] = @"10";
        [[AFHTTPSessionManager manager]POST:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            successBlock(responseObject);
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            failureBlock(error);
        }];
    }
    
    
}

- (void)getTopicListDataWithIDS:(NSString *)ids success:(void(^)(id respone))successBlock failure:(void(^)(NSError *error))failureBlock {
    NSArray *request = [self requestWithType:JHNetworkingTypeTopicList];
    NSString *urlStr = request.firstObject;
    NSMutableDictionary *params = request.lastObject;
    params[@"ids"] = ids;
    [[AFHTTPSessionManager manager]GET:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
            failureBlock(error);
        }];
    }];
}

- (void)getSubjectWithID:(NSInteger)ID andType:(NSInteger)type success:(void(^)(id respone))successBlock failure:(void(^)(NSError *error))failureBlock {
    NSMutableDictionary *temp = [self.params mutableCopy];
    temp[@"id"] = @(ID);
    temp[@"statistics_uv"] = @(type);
    [[AFHTTPSessionManager manager]GET:kJHSubjectURL parameters:temp success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}






@end
