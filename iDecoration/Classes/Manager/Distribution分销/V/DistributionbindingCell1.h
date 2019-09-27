//
//  DistributionbindingCell1.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaText.h"
#import "Nalabel.h"
//创建一个代理
@protocol myTabVdelegate <NSObject>

-(void)myTabVClick:(UITableViewCell *)cell andtextstr:(NSString *)textstr;

@end
@interface DistributionbindingCell1 : UITableViewCell
//-(void)setdata:(NSString *)tagstr andindex:(NSInteger )index;
-(void)setdata:(NSString *)tagstr andindex:(NSInteger )index andinfodic:(NSDictionary *)infodic;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@property (nonatomic,strong) Nalabel *leftLab;
@property (nonatomic,strong) NaText *contentText;
@end
