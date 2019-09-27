//
//  SendJinQiTableViewCell.m
//  iDecoration
//
//  Created by john wall on 2018/9/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SendJinQiTableViewCell.h"

@implementation SendJinQiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview: self.SelectBTN];
    self.SelectBTN.frame= CGRectMake(10, 5, 50, 50);
    
    
    [self addSubview:self.LabelM];
    self.LabelM.frame =CGRectMake(10+50+20, 10, BLEJWidth-80, 40) ;
    self.LabelM.textAlignment=NSTextAlignmentCenter;
    
    self.SelectBTN.layer.borderWidth=0.5f;
    self.SelectBTN.layer.borderColor=[UIColor grayColor].CGColor;
    self.SelectBTN.layer.cornerRadius= self.SelectBTN.width/2;
    // Initialization code
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    self =[super initWithFrame:frame];
    
    [self addSubview: self.SelectBTN];
    self.SelectBTN.frame= CGRectMake(10, 5, 50, 50);
    
    
    [self addSubview:self.LabelM];
    self.LabelM.frame =CGRectMake(10+50+20, 10, BLEJWidth-80, 40) ;
    self.LabelM.textAlignment=NSTextAlignmentCenter;
    
    self.SelectBTN.layer.borderWidth=0.5f;
    self.SelectBTN.layer.borderColor=[UIColor grayColor].CGColor;
    self.SelectBTN.layer.cornerRadius= self.SelectBTN.width/2;
    
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
