//
//  disbroadcastCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SpreadNewsList;

//创建一个代理
@protocol myTabVdelegate <NSObject>
-(void)myTabVClick:(UITableViewCell *)cell;
@end

@interface disbroadcastCell : UITableViewCell
-(void)setdata:(SpreadNewsList *)model;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end
