//
//  localnotesCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class localnotesModel;

//创建一个代理
@protocol myTabVdelegate <NSObject>

-(void)myTabVClick0:(UITableViewCell *)cell;
-(void)myTabVClick1:(UITableViewCell *)cell;
-(void)myTabVClick2:(UITableViewCell *)cell;
@end

@interface localnotesCell : UITableViewCell
@property(assign,nonatomic)id<myTabVdelegate>delegate;
-(void)setdata:(localnotesModel *)model;
@end
