//
//  casedesignCell2.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class newdesignModel;
@protocol myTabVdelegate <NSObject>
-(void)shareTabVClick0:(UITableViewCell *)cell;
-(void)commentsTabVClick1:(UITableViewCell *)cell;
-(void)zanTabVClick2:(UITableViewCell *)cell;
@end
@interface casedesignCell2 : UITableViewCell
-(void)setdata:(newdesignModel *)model;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end
