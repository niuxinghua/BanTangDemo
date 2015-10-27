//
//  JHSegmentedControl.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/10/18.
//  Copyright © 2015年 TonyStark106. All rights reserved.
//

#import "JHSegmentedControl.h"

@interface JHSegmentedControl ()

/** target */
@property (nonatomic, weak)id target;

/** action1 */
@property (nonatomic, assign)SEL action1;

/** action2 */
@property (nonatomic, assign)SEL action2;

@end

@implementation JHSegmentedControl
+ (instancetype)shareMeForTarget:(id)target SEL1:(SEL)action1 andAction2:(SEL)action2 {
    
    JHSegmentedControl *segmentedView = [[JHSegmentedControl alloc] initWithItems:@[@"精选", @"|", @"关注"]];
    segmentedView.tintColor = [UIColor clearColor];
    NSDictionary *selectedTextAttributes = @{
                                             NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName : [UIColor whiteColor]};
    NSDictionary *unselectedTextAttributes = @{
                                               NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
                                               NSForegroundColorAttributeName : [UIColor lightTextColor]};
    [segmentedView setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    [segmentedView setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    [segmentedView setSelectedSegmentIndex:0];
    [segmentedView setContentOffset:CGSizeMake(15, 0) forSegmentAtIndex:0];
    [segmentedView setContentOffset:CGSizeMake(-15, 0) forSegmentAtIndex:2];
    segmentedView.selectedSegmentIndex = 0;
    
    segmentedView.target = target;
    segmentedView.action1 = action1;
    segmentedView.action2 = action2;
    
    return segmentedView;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (point.x < self.frame.size.width * 0.5) {
        self.selectedSegmentIndex = 0;
        if (self.target && self.action1) {
            [self.target performSelector:self.action1 withObject:nil];
        }
    } else {
        self.selectedSegmentIndex = 2;
        if (self.target && self.action2) {
            [self.target performSelector:self.action2 withObject:nil];
        }
    }
}






@end
