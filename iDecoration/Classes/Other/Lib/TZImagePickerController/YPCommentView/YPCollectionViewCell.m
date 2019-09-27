//
//  YPCollectionViewCell.m
//  YPCommentDemo
//
//  Created by 朋 on 16/7/21.
//  Copyright © 2016年 杨朋. All rights reserved.
//

#import "YPCollectionViewCell.h"
#define KScreen_Size  [UIScreen mainScreen].bounds.size
#define KH_Gap 16.0
#define KImage_Width (KScreen_Size.width-2*KH_Gap)/3

#define KW (KScreen_Size.width - 8*4)/3
@implementation YPCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
 
    self =[super initWithFrame:frame] ;
    if (self) {
        
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KW , KW)];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
        _imageView.userInteractionEnabled = YES ;
         _btn = [UIButton buttonWithType:0];
        [_btn setBackgroundImage:[UIImage imageNamed:@"del02"] forState:0];
//        [_btn setBackgroundImage:[UIImage imageNamed:@"close_btn_highlighted"] forState:UIControlStateSelected];
         _btn.frame = CGRectMake(CGRectGetMaxX(_imageView.frame), 0, 20, 20);
        [_imageView addSubview:_btn];
        _btn.hidden = NO ;
        
    }
    return self ;
}

- (void)setCellWithImage:(UIImage *)img  IsFirstOrLastObjectHiddenBtn:(BOOL)hidden{
   
    _imageView.image = img ;
    CGRect ImageViewrect = _imageView.frame;
    ImageViewrect.size.height = [self imageHeightWithImage:img];
    ImageViewrect.size.width = KW;
    ImageViewrect.origin.x = 0;
    _imageView.frame = ImageViewrect;
    
    _btn.frame = CGRectMake(CGRectGetMaxX(_imageView.frame)-20, 0, 20, 20);
    _btn.hidden = hidden ;
    CGRect rect = self.contentView.frame;
    rect.size.height = [self imageHeightWithImage:img];
    self.contentView.frame = rect;
    
//    CGFloat cellHeight = self.contentView.frame.size.height;
//    img.size.height = cellHeight ;
    
    
}

- (void)setCellWithImageUrl:(id)imgUrl  IsFirstOrLastObjectHiddenBtn:(BOOL)hidden{
    if ([imgUrl isKindOfClass:[NSString class]]) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:DefaultIcon]];
    }
    if ([imgUrl isKindOfClass:[UIImage class]]) {
        UIImage *img = imgUrl;
        _imageView.image = img;
    }
    
    CGRect ImageViewrect = _imageView.frame;
    ImageViewrect.size.height = KW;
    ImageViewrect.size.width = KW;
    ImageViewrect.origin.x = 0;
    _imageView.frame = ImageViewrect;
    
    _btn.frame = CGRectMake(CGRectGetMaxX(_imageView.frame)-20, 0, 20, 20);
    _btn.hidden = hidden ;
    CGRect rect = self.contentView.frame;
    rect.size.height = KW;
    self.contentView.frame = rect;
}



- (CGFloat)imageHeightWithImage:(UIImage *)img
{
//    CGFloat heigth = img.size.height;
//    CGFloat width = img.size.width;
//    return heigth*KImage_Width/width;
    
//    CGFloat height = SCREEN_WIDTH/3;
//    CGFloat width = SCREEN_WIDTH/3;
      return KW;
    
}


@end
