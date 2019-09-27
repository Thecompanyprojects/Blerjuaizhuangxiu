//
//  bottomView.m
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "bottomView.h"

@implementation bottomView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }

    return self;
}


-(void)setUpView{

    self.backgroundColor = [UIColor whiteColor];
    //打电话button
    self.callButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.width/4, self.height)];
    self.callButton.titleLabel.font = NB_FONTSEIZ_NOR;

    [self.callButton  setTitleColor:[UIColor colorWithRed:134/255.0 green:193/255.0 blue:36/255.0 alpha:1] forState:UIControlStateNormal];
   
    [self addSubview:self.callButton];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(self.width/4, 3, 1, self.height - 6)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
    
//预约
    self.idecorationButton = [[UIButton alloc]initWithFrame:CGRectMake((self.width/4) + 5, 3, (self.width * 3/4) - 10, self.height - 6)];
    self.idecorationButton.backgroundColor = [UIColor colorWithRed:134/255.0 green:193/255.0 blue:36/255.0 alpha:1];
    self.idecorationButton.layer.masksToBounds = YES;
    self.idecorationButton.layer.cornerRadius = 4;
    self.idecorationButton.titleLabel.font = NB_FONTSEIZ_NOR;
    [self addSubview:self.idecorationButton];
}
@end
