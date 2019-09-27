//
//  incomedetailsCell1.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class incomelistModel;
@class CashList;
@interface incomedetailsCell1 : UITableViewCell
-(void)settixian:(CashList *)model;
-(void)setdata:(incomelistModel *)model andwithcelltype:(NSString *)type;
@end
