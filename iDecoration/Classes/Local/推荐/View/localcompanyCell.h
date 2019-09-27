//
//  localcompanyCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class localcompanyModel;

@protocol myTabVdelegate <NSObject>

-(void)myphoneVClick:(UITableViewCell *)cell;

@end

@interface localcompanyCell : UITableViewCell
-(void)setdata:(localcompanyModel *)model;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end
