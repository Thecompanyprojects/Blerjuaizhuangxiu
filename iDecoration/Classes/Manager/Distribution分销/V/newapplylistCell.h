//
//  newapplylistCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
//创建一个代理
@protocol myTabVdelegate <NSObject>
-(void)myTabVClick1:(UITableViewCell *)cell;
-(void)myTabVClick2:(UITableViewCell *)cell;
@end
@interface newapplylistCell : UITableViewCell
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end
