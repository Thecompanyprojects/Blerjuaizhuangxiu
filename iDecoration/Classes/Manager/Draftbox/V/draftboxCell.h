//
//  draftboxCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class draftboxModel;

@protocol myTabVdelegate <NSObject>

-(void)myTabVClick:(UITableViewCell *)cell;

@end

@interface draftboxCell : UITableViewCell
-(void)setdata:(draftboxModel *)model;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end
