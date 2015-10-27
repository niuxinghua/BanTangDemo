//
//  JHLoginContrioller.m
//  BanTangDemo
//
//  Created by Tony Stark on 15/10/19.
//  Copyright © 2015年 TonyStark106. All rights reserved.
//

#import "JHLoginContrioller.h"

@interface JHLoginContrioller ()

@end


@implementation JHLoginContrioller

+ (instancetype)loginVC {
    return [[JHLoginContrioller alloc] initWithNibName:@"JHLoginContrioller" bundle:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)close:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
