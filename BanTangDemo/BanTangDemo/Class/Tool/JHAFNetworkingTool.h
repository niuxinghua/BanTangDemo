//
//  JHAFNetworkingTool.h
//  BanTangDemo
//
//  Created by Tony Stark on 15/8/24.
//  Copyright (c) 2015年 Tony Stark. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    JHNetworkingTypeIndexGetNew,
    JHNetworkingTypeIndexGetMore,
    JHNetworkingTypeDiscoveryGetNew,
    JHNetworkingTypeDiscoveryGetMore,
    JHNetworkingTypeTopicList
} JHNetworkingType;

@interface JHAFNetworkingTool : NSObject

+ (instancetype)defaultTool;

- (void)getDataWithNetworkingType:(JHNetworkingType)type success:(void(^)(id respone))successBlock failure:(void(^)(NSError *error))failureBlock;

- (void)getTopicListDataWithIDS:(NSString *)ids success:(void(^)(id respone))successBlock failure:(void(^)(NSError *error))failureBlock;

@end
