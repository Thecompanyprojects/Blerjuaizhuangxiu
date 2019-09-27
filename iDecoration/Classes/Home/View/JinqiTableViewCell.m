//
//  JinqiTableViewCell.m
//  iDecoration
//
//  Created by john wall on 2018/9/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "JinqiTableViewCell.h"

@implementation JinqiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
//    self.imageV.layer.masksToBounds = YES;
//     self.imageV.layer.borderWidth=0.7;
//    self.imageV.layer.borderColor=[UIColor grayColor].CGColor;
    
    [self.contentView addSubview: self.SelectBtn];
    self.SelectBtn.frame= CGRectMake(10, 5, 50, 50);
    
    
    [self.contentView addSubview:self.LabelMoney];
    self.LabelMoney.frame =CGRectMake(10+50+20, 10, BLEJWidth-80, 40) ;
    self.LabelMoney.textAlignment=NSTextAlignmentCenter;
    
   
    
   
    
    
   
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    
//    self.SelectBtn .layer.borderWidth=0.5f;
//    self.SelectBtn .layer.borderColor=[UIColor grayColor].CGColor;
//    self.SelectBtn .layer.cornerRadius= self.SelectBtn .width/2;
//    
//    self.LabelMoney.layer.borderWidth=0.5f;
//    self.LabelMoney.layer.borderColor=[UIColor grayColor].CGColor;
    return self;
}



-(instancetype)init{
    
    self =[super init];
    
    self.SelectBtn .layer.borderWidth=0.5f;
    self.SelectBtn .layer.borderColor=[UIColor grayColor].CGColor;
    self.SelectBtn .layer.cornerRadius= self.SelectBtn .width/2;
    
    self.LabelMoney.layer.borderWidth=0.5f;
    self.LabelMoney.layer.borderColor=[UIColor grayColor].CGColor;
    
    
    return self;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
