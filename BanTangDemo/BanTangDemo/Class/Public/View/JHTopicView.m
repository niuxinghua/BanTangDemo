//
//  JHTopicView.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/10/19.
//  Copyright © 2015年 TonyStark106. All rights reserved.
//

#import "JHTopicView.h"
#import "JHTopic.h"
#import <UIImageView+WebCache.h>

@interface JHTopicView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UIView *likeLabelBG;


@end

@implementation JHTopicView

+ (JHTopicView *)topicViewWithFrame:(CGRect)frame topic:(JHTopic *)topic {
    JHTopicView *topicView = [[NSBundle mainBundle]loadNibNamed:@"JHTopicView" owner:nil options:nil].lastObject;
    topicView.frame = frame;
    topicView.topic = topic;
    topicView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    topicView.imageView.layer.cornerRadius = 4;
    topicView.imageView.layer.masksToBounds = YES;
    return topicView;
}

- (UIImageView *)imageView {
    [self insertSubview:_imageView atIndex:0];
    return _imageView;
}

- (void)setTopic:(JHTopic *)topic {
    _topic = topic;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", topic.likes];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.pic]];
    if (topic.index > 0) {
        self.logoView.hidden = YES;
        self.likeLabelBG.hidden = YES;
    } else {
        self.logoView.hidden = NO;
        self.likeLabelBG.hidden = NO;
    }
}


@end
