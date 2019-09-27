//
//  myinfoeadView.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myinfoeadView : UIView
-(void)setdata:(NSDictionary *)dic;
@property (nonatomic,strong) UILabel *topLab;
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UIImageView *rightImg;

@end
