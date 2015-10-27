//
//  JHTopicView.h
//  BanTangDemo
//
//  Created by Tony Stark on 15/10/19.
//  Copyright © 2015年 TonyStark106. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHTopic;

@interface JHTopicView : UIView

/** topic */
@property (nonatomic, strong)JHTopic *topic;

+ (JHTopicView *)topicViewWithFrame:(CGRect)frame topic:(JHTopic *)topic;

@end
