//
//  NSString+ExtendTool.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/10/19.
//  Copyright © 2015年 TonyStark106. All rights reserved.
//

#import "NSString+ExtendTool.h"

@implementation NSString (ExtendTool)

- (NSString *)extendNumber {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < self.length; i++) {
        NSString *str = [self substringWithRange:NSMakeRange(i, 1)];
        if ([str isEqualToString:@","]) {
            [arr addObject:@(i)];
        }
    }
    NSInteger k = 0;
    for (NSInteger i = 0; i < arr.count; i++) {
        NSInteger t = ((NSNumber *)arr[i]).intValue;
        NSString *str = [self substringWithRange:NSMakeRange(k + 1, t - k - 1)];
        arr[i] = [NSNumber numberWithInteger:[str integerValue]];
        k = t;
    }
    arr[arr.count] = [NSNumber numberWithInteger:[self substringWithRange:NSMakeRange(k + 1, self.length - k - 1)].integerValue];
    NSMutableString *temp = [NSMutableString string];
    for (NSInteger i = 0; i < arr.count; i++) {
        [temp appendFormat:@"%@,", arr[i]];
    }
    NSString *str = [NSString stringWithString:[temp substringToIndex:temp.length - 1]];
    return str;
}

@end
