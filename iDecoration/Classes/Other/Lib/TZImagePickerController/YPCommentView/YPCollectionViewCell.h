//
//  YPCollectionViewCell.h
//  YPCommentDemo
//
//  Created by 朋 on 16/7/21.
//  Copyright © 2016年 杨朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIButton *btn ;


- (void)setCellWithImage:(UIImage *)img  IsFirstOrLastObjectHiddenBtn:(BOOL)hidden;
- (void)setCellWithImageUrl:(id)imgUrl  IsFirstOrLastObjectHiddenBtn:(BOOL)hidden;
@end
