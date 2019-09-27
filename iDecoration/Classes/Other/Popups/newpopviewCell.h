//
//  newpopviewCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdviserList;
@protocol popDelegate <NSObject>

-(void)phoneTabVClick:(UICollectionViewCell *)cell;
-(void)wxTabVClick:(UICollectionViewCell *)cell;
-(void)qqTabVClick:(UICollectionViewCell *)cell;

@end

@interface newpopviewCell : UICollectionViewCell
@property (nonatomic, weak) id<popDelegate> delegate;
@property (nonatomic,strong) UILabel *phoneLab;
@property (nonatomic,strong) UILabel *wxLab;
@property (nonatomic,strong) UILabel *qqLab;
-(void)setdata:(AdviserList *)model;
@end
