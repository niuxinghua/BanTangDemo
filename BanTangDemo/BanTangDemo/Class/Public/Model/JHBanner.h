//
//  JHBanner.h
//  BanTangDemo
//
//  Created by Tony Stark on 15/8/28.
//  Copyright (c) 2015年 Tony Stark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHBanner : NSObject

/** id */
@property (nonatomic, assign)NSInteger ID;

/** title */
@property (nonatomic, copy)NSString *title;

/** typeString */
@property (nonatomic, copy)NSString *type;

/** 图片链接 */
@property (nonatomic, strong)NSString *photo;

/** 活动链接 */
@property (nonatomic, copy)NSString *extend;



@end
