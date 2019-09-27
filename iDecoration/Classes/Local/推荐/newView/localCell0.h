//
//  localCell0.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class localconstructionsModel;
//创建一个代理
@protocol myconstructionTabVdelegate <NSObject>
-(void)myconstruction:(localconstructionsModel *)model;
@end
@interface localCell0 : UITableViewCell
@property (nonatomic,strong) UIButton *moreBtn;
-(void)setdata:(NSMutableArray *)array;
@property(assign,nonatomic)id<myconstructionTabVdelegate>delegate;
@end
