//
//  dockingchooseCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class dockingModel;

//创建一个代理
@protocol myTabVdelegate <NSObject>

-(void)myTabVchooseClick:(UITableViewCell *)cell;

@end
@interface dockingchooseCell : UITableViewCell
-(void)setdata:(dockingModel *)model;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end
