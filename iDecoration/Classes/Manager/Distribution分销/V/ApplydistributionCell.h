//
//  ApplydistributionCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaText.h"
//创建一个代理
@protocol myTabVdelegate <NSObject>

-(void)myTabVClick:(UITableViewCell *)cell andtextstr:(NSString *)textstr;

@end
@interface ApplydistributionCell : UITableViewCell
-(void)setdata:(NSInteger )index;
@property (nonatomic,strong) NaText *applyText;
@property (nonatomic,strong) UILabel *leftLab;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@property (nonatomic,strong) UILabel *contentLab;
@end
