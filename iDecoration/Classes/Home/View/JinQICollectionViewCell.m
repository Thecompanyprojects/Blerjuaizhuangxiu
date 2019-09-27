//
//  JinQICollectionViewCell.m
//  iDecoration
//
//  Created by john wall on 2018/9/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "JinQICollectionViewCell.h"

@implementation JinQICollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
  //   self.backgroundColor =[UIColor lightGrayColor];
//     self.imageV.frame =self.frame;
//     [self addSubview:self.imageV];
    
   
   
    
    self.imageV.userInteractionEnabled=YES;
    self.imageV.contentMode=UIViewContentModeScaleAspectFill;
}



-(instancetype)initWithFrame:(CGRect)frame{
    
    
    self =[super initWithFrame:frame];
  
    
    
    return self;
    
}
@end
