//
//  recommendrankingView.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface recommendrankingView : UIButton
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UIButton *companyNamelab;
@property (nonatomic,strong) UILabel *numberlab;
-(void)setdatacontent:(NSString *)contentstr andnumber:(NSString *)numberstr;
@end
