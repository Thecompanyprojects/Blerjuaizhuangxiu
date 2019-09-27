//
//  localCell2.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
//创建一个代理
@class localgoodModel;
@protocol mygoodsTabVdelegate <NSObject>
-(void)mygoods:(localgoodModel *)model;
@end
@interface localCell2 : UITableViewCell
@property (nonatomic,strong) UIButton *moreBtn;
-(void)setdata:(NSMutableArray *)arr;
@property(assign,nonatomic)id<mygoodsTabVdelegate>delegate;
@end
