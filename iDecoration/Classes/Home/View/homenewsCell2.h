//
//  homenewsCell2.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class homenewsModel;
@protocol myTabVdelegate <NSObject>
-(void)myTabVClick0:(UITableViewCell *)cell;
-(void)myTabVClick1:(UITableViewCell *)cell;
-(void)myTabVClick2:(UITableViewCell *)cell;
@end
@interface homenewsCell2 : UITableViewCell
@property(assign,nonatomic)id<myTabVdelegate>delegate;
-(void)setdata:(homenewsModel *)model;
@end
