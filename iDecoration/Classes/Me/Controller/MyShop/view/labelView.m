//
//  labelView.m
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "labelView.h"

@implementation labelView


-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self setView];
    }
    
    return self;
}



-(void)setView{

    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width/4, self.height)];
    self.titleLabel.font = NB_FONTSEIZ_NOR;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    

    
    
    self.detailTextField = [[PlaceHolderTextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 3, self.width *3/4, self.height - 6)];
    self.detailTextField.font = NB_FONTSEIZ_NOR;
    [self addSubview:self.detailTextField];

}


@end
