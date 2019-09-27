//
//  DistributionbindingCell0.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
//创建一个代理
@protocol distriVdelegate <NSObject>

-(void)myTabVClick:(UITableViewCell *)cell andtagstr:(NSString *)str;

@end
@interface DistributionbindingCell0 : UITableViewCell
@property(assign,nonatomic)id<distriVdelegate>delegate;
@property (nonatomic,strong) UILabel *contentLab;
@end
