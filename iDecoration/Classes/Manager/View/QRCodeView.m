//
//  QRCodeView.m
//  iDecoration
//
//  Created by RealSeven on 2017/3/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "QRCodeView.h"

@implementation QRCodeView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
     
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.QRCodeImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideView:)];
        tap.delegate = self;
        tap.numberOfTapsRequired = 1;
        
        [self.bottomView addGestureRecognizer:tap];
    }
    return self;
}

-(UIView*)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _bottomView.backgroundColor = White_Color;
    }
    return _bottomView;
}

-(UIImageView*)QRCodeImageView{
    
    if (!_QRCodeImageView) {
        _QRCodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kSCREEN_WIDTH-200)/2, (kSCREEN_HEIGHT-200)/2, 200, 200)];
        _QRCodeImageView.backgroundColor = Main_Color;
    }
    return _QRCodeImageView;
}

-(void)hideView:(UITapGestureRecognizer*)sender{
    
    if (self.hideBlock) {
        self.hideBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
