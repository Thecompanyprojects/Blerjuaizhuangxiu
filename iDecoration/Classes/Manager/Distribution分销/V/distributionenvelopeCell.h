//
//  distributionenvelopeCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RedPacketList;
//创建一个代理
@protocol myTabVdelegate <NSObject>
-(void)myTabVClick:(UITableViewCell *)cell;
@end
@interface distributionenvelopeCell : UITableViewCell
-(void)setdata:(RedPacketList *)model;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end
