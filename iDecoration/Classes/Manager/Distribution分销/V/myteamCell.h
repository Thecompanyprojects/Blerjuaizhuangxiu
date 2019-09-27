//
//  myteamCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

//创建一个代理
@protocol myTabVdelegate <NSObject>
-(void)myTabVClick1:(UITableViewCell *)cell;
-(void)myTabVClick2:(UITableViewCell *)cell;
-(void)myTabVClick3:(UITableViewCell *)cell;
@end

@interface myteamCell : UITableViewCell
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *nameLab;
//
@property (nonatomic,strong) UIButton *btn0;
@property (nonatomic,strong) UIButton *btn1;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@property (nonatomic,strong) UILabel *typelab;
@end
