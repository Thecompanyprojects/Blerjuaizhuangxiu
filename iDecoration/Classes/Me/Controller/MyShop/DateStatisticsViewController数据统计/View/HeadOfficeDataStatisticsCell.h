//
//  HeadOfficeDataStatisticsCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/11/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateStatisticsModel.h"

@interface HeadOfficeDataStatisticsCell : UITableViewCell
// 第一个cell
@property (weak, nonatomic) IBOutlet UILabel *zeroZeroNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *zeroOneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *zeroTwoNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneZeroNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneOneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneTwoNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoZeroNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoOneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoTwoNumLabel;


// 第二个cell
@property (weak, nonatomic) IBOutlet UILabel *ZeroZeroLabel;
@property (weak, nonatomic) IBOutlet UILabel *ZeroOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *ZeroTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *OneZeroLabel;
@property (weak, nonatomic) IBOutlet UILabel *OneOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *OneTwoLabel;




+ (instancetype)headOfficeDataStatisticsCellWith:(UITableView *)tableView selectedIndex:(NSInteger)selectedIndex;

/**
 设置cell数据

 @param model 数据模型
 @param type 需要设置的数据类型 type 0 企业    1 工地     2 计算器   3喊装修    4商品
 */
- (void)setModel:(DateStatisticsModel *)model type:(NSInteger)type;








@end
