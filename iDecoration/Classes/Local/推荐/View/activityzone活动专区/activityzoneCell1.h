//
//  activityzoneCell1.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/15.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SingupTabVdelegate <NSObject>
-(void)singupTabbtn:(UITableViewCell *)cell;
@end

@class activityzoneModel;
@class homenewsModel;
@interface activityzoneCell1 : UITableViewCell
-(void)setdata:(activityzoneModel *)model;
-(void)setdata2:(homenewsModel *)model;
@property(assign,nonatomic)id<SingupTabVdelegate>delegate;
@end
