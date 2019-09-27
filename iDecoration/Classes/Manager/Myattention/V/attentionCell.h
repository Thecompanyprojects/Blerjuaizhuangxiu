//
//  attentionCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class focusModel0;
@class focusModel1;
@class focusModel2;

@protocol myTabVdelegate <NSObject>

-(void)myTabVClick0:(UITableViewCell *)cell;
-(void)myTabVClick1:(UITableViewCell *)cell;
-(void)myTabVClick2:(UITableViewCell *)cell;

@end

@interface attentionCell : UITableViewCell
-(void)setdata0:(focusModel0 *)model;
-(void)setdata1:(focusModel1 *)model;
-(void)setdata2:(focusModel2 *)model;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end
