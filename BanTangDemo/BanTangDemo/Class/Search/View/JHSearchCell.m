//
//  JHSearchCell.m
//  
//
//  Created by Tony Stark on 15/9/20.
//
//


#import "JHSearchCell.h"
#import "JHSearchModel.h"

@interface JHSearchCell ()


@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *labelCN;
@property (weak, nonatomic) IBOutlet UILabel *labelEN;

@end

@implementation JHSearchCell


- (void)setModel:(JHSearchModel *)model {
    _model = model;
    self.labelCN.text = model.nameCN;
    self.labelEN.text = model.nameEN;
}

@end
