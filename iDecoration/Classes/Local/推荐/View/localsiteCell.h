//
//  localsiteCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@class localsiteModel;

//创建一个代理
@protocol myTabVdelegate <NSObject>

-(void)myTabVClick:(UITableViewCell *)cell;

@end

@interface localsiteCell : UITableViewCell
-(void)setdata:(localsiteModel *)model;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end
