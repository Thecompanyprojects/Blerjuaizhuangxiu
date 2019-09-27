//
//  shopDetailView.m
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/13.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "shopDetailView.h"

@implementation shopDetailView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupView];
        
    }

    return self;
}


-(void)setupView{
   
    self.backgroundColor = [UIColor whiteColor];
    //图片
    self.bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, self.width - 50, self.width - 50)];
    self.bgImage.contentMode = UIViewContentModeScaleAspectFit;

    [self addSubview:self.bgImage];
    
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.bgImage.frame) + 10, self.width - 20, 20) ];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = NB_FONTSEIZ_SMALL;
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    


    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [self addGestureRecognizer:tap];

}


-(void)tapAction:(UITapGestureRecognizer *)tap{

    if (self.delegate && [self.delegate  respondsToSelector:@selector(shopDetailActions:)]) {
        
        [self.delegate shopDetailActions:self.shopTag];
    }


}
@end
