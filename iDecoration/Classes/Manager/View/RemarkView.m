//
//  RemarkView.m
//  iDecoration
//
//  Created by RealSeven on 17/3/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "RemarkView.h"

@implementation RemarkView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = RGB(242, 242, 242);
        [self addSubview:self.remarkLabel];
    }
    return self;
}

-(UILabel*)remarkLabel{
    
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, kSCREEN_WIDTH-32, 50)];
        _remarkLabel.text = @"* 请正确填写地址以便接单，如填写错误可能无法接到装修订单，从而影响您的使用!";
        _remarkLabel.font = [UIFont systemFontOfSize:14];
        _remarkLabel.textColor = [UIColor darkGrayColor];
        _remarkLabel.numberOfLines = 0;
        _remarkLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    return _remarkLabel;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
