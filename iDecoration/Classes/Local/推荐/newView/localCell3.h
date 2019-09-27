//
//  localCell3.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class localexecellentModel;
@protocol myexecellentTabVdelegate <NSObject>
-(void)myexecellent:(localexecellentModel *)model;
@end
@interface localCell3 : UITableViewCell
@property (nonatomic,strong) UIButton *moreBtn;
-(void)setdata:(NSMutableArray *)arr;
@property(assign,nonatomic)id<myexecellentTabVdelegate>delegate;
@end
