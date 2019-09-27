//
//  BLEJGuideVcCollectionViewCell.m
//  iDecoration
//
//  Created by john wall on 2018/9/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "BLEJGuideVcCollectionViewCell.h"

@implementation BLEJGuideVcCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  
   
    
    _IV =[[UIImageView alloc]init];
    _IV.frame=CGRectMake(0, 0, BLEJWidth, BLEJWidth*0.6);
    [self addSubview:_IV];
}


@end
