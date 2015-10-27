//
//  JHTopic.h
//  BanTangDemo
//
//  Created by Tony Stark on 15/10/19.
//  Copyright © 2015年 TonyStark106. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHTopic : NSObject

//id = 1306;
//islike = 0;
//likes = 1025;
//pic = "http://bt.img.17gwx.com/topic/0/13/c1JeYg/620x280";
//title = "\U3010\U53cc11\U9884\U552e\U3011\U54c1\U724c\U5973\U88c5\U62a2\U5148\U901b";
//type = 0;
//"update_time" = 1445389201;

/** id */
@property (nonatomic, assign)NSInteger ID;

/** 标题 */
@property (nonatomic, copy)NSString *title;

/** 图片url */
@property (nonatomic, copy)NSString *pic;

/** 点赞数 */
@property (nonatomic, assign)NSInteger likes;

/** 更新时间 */
@property (nonatomic, assign)NSInteger update_time;

/** 类型 */
@property (nonatomic, copy)NSString *type;

/** 额外topic的顺序 */
@property (nonatomic, assign)NSInteger index;

/** 额外的图片地址 */
@property (nonatomic, weak)NSString *photo;

/** 额外的活动网址 */
@property (nonatomic, copy)NSString *extend;

@end
