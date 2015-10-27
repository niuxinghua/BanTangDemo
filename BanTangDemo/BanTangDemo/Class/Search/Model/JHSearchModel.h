//
//  JHSearchModel.h
//  
//
//  Created by Tony Stark on 15/9/20.
//
//

#import <Foundation/Foundation.h>

@interface JHSearchModel : NSObject

/** id */
@property (nonatomic, copy)NSString *ID;
/** 中文名 */
@property (nonatomic, copy)NSString *nameCN;
/** 英文名 */
@property (nonatomic, copy)NSString *nameEN;

@end
