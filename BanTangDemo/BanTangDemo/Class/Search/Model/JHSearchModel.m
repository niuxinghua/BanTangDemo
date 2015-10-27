//
//  JHSearchModel.m
//  
//
//  Created by Tony Stark on 15/9/20.
//
//

#import "JHSearchModel.h"

@implementation JHSearchModel

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"ID" : @"id",
             @"nameCN" : @"name",
             @"nameEN" : @"en_name"
             };
}

@end
