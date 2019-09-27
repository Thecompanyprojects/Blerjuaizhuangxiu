//
//  floorBrickTableViewCell.m
//  iDecoration
//
//  Created by john wall on 2018/8/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "floorBrickTableViewCell.h"

@implementation floorBrickTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLA.font = AdaptedFontSize(15);
    self.rightBtn.titleLabel.font=AdaptedFontSize(14);
     [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     self.nameLA.adjustsFontSizeToFitWidth=YES;
    self.lenthAndWidthlength.adjustsFontSizeToFitWidth=YES;
   
    self.lenthAndWidthlength.textAlignment=NSTextAlignmentRight;
    self.lenthAndWidthlength.font=AdaptedFontSize(16);
    self.lenthAndWidthlength.userInteractionEnabled=YES;

    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 60-1, BLEJWidth, 0.5)];
    line.layer.backgroundColor=[UIColor lightGrayColor].CGColor;
    [self addSubview:line];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
   
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

-(void)setModel:(BLRJCalculatortempletModelAllCalculatorTypes *)model{
    _model =model;
    
}

@end
