//
//  activityzoneCell2.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/15.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol myTabVdelegate <NSObject>
-(void)myTabVClick0:(UITableViewCell *)cell;
-(void)myTabVClick1:(UITableViewCell *)cell;
-(void)myTabVClick2:(UITableViewCell *)cell;
@end
@class activityzoneModel;
@interface activityzoneCell2 : UITableViewCell
-(void)setdata:(activityzoneModel *)model;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end
