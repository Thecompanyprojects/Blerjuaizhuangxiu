//
//  chooseimplementCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CompanyPeopleInfoModel;
//创建一个代理
@protocol myTabVdelegate <NSObject>

-(void)myTabVClick:(UITableViewCell *)cell;

@end


@interface chooseimplementCell : UITableViewCell
-(void)setdata:(CompanyPeopleInfoModel *)model;
-(void)setchoose:(NSString *)choosestr;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end
