//
//  homenewsCell1.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class homenewsModel;
@protocol singupTabVdelegate <NSObject>
-(void)singupTabbtn:(UITableViewCell *)cell;
@end
@interface homenewsCell1 : UITableViewCell
@property(assign,nonatomic)id<singupTabVdelegate>delegate;
-(void)setdata:(homenewsModel *)model;
@end
