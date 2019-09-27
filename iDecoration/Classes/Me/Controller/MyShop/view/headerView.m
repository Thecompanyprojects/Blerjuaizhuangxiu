//
//  headerView.m
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "headerView.h"

@implementation headerView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setView];
    }
    
    return self;
}



-(void)setView{
  
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height/6)];
    titleLabel.font = NB_FONTSEIZ_NOR;
    titleLabel.text = @"上传封面";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    
    self.addImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), self.width, self.height - CGRectGetHeight(titleLabel.frame))];
    [self.addImageBtn addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addImageBtn];
    
    
    self.headImage = [[UIImageView alloc]init];
    self.headImage.frame = self.addImageBtn.frame;
//    self.headImage.contentMode = UIViewContentModeScaleAspectFit;
    self.headImage.image = [UIImage imageNamed:@"jia-kong"];
    
    [self addSubview:self.headImage];
}





#pragma mark 添加图片
-(void)addImageAction:(UIButton *)sender{

    if ( self.delegate && [self.delegate respondsToSelector:@selector(updataimage)]) {
        [self.delegate updataimage];
    }


}
@end
