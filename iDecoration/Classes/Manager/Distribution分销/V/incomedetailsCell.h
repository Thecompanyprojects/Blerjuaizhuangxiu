//
//  incomedetailsCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class incomelistModel;
@class CashList;

//创建一个代理
@protocol myTabVdelegate <NSObject>
-(void)myTabVClick:(UITableViewCell *)cell;

@end

@interface incomedetailsCell : UITableViewCell
-(void)settixian:(CashList *)model;
-(void)setdata:(incomelistModel *)model andwithcelltype:(NSString *)type andwithvctype:(NSString *)vctype;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end
