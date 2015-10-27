//
//  JHTopic.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/10/19.
//  Copyright © 2015年 TonyStark106. All rights reserved.
//

#import "JHTopic.h"

@implementation JHTopic


+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

- (void)setPhoto:(NSString *)photo {
    self.pic = photo;
}

- (NSString *)photo {
    return self.pic;
}

@end