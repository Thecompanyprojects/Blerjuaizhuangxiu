//
//  JinQiGiftTableViewCell.m
//  iDecoration
//
//  Created by john wall on 2018/9/27.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "JinQiGiftTableViewCell.h"

@implementation JinQiGiftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.fuckBtn =[[UIButton alloc]init];
     [self.contentView addSubview:self.fuckBtn];
    self.fuckBtn.frame= CGRectMake(BLEJWidth-60, 25, 30, 30);

    self.labelMoney =[[UILabel alloc]init];
    [self.contentView addSubview:self.labelMoney];
    
    self.labelMoney.frame =CGRectMake(BLEJWidth-140, 30, 60, 20) ;
    self.labelMoney.textAlignment=NSTextAlignmentRight;
    self.imageV=[[UIImageView alloc]init];
    
    [self.contentView addSubview:self.imageV];
    self.imageV.frame =CGRectMake(20, 10, 45, 45) ;
    self.imageV.userInteractionEnabled=YES;
    
 
//    [self.fuckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView).offset(-20);
//        make.top.equalTo(self.contentView).offset(20);
//        make.width.equalTo(30);
//        make.height.equalTo(30);
//    }];
//
   
   
  
    


   
    
     self.fuckBtn.layer.borderWidth=0.5f;
     self.fuckBtn.layer.borderColor=[UIColor grayColor].CGColor;
     self.fuckBtn.layer.cornerRadius=self.fuckBtn.width/2;
   
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
