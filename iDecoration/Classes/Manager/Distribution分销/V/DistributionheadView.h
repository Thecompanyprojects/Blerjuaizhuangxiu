//
//  DistributionheadView.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistributionheadView : UICollectionReusableView
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *codelab;
@property (nonatomic,strong) UILabel *moneylab0;
@property (nonatomic,strong) UILabel *moneylab1;
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *isLevelLab;
@property (nonatomic,strong) UIImageView *img;

@property (nonatomic,strong) UILabel *moneylab2;
@property (nonatomic,strong) UIButton *submitbtn;

@property (nonatomic,strong) UIButton *moreBtn;

-(void)setdata:(NSMutableArray *)arr;
@end
