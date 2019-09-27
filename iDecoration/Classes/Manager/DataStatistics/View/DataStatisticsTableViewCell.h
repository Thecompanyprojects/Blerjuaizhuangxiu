//
//  DataStatisticsTableViewCell.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStatisticsModel.h"
#import "PGBarChart.h"

@interface DataStatisticsTableViewCell : UITableViewCell<PGBarChartDelegate, PGBarChartDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *viewBg;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBGHeight;
@property (nonatomic, strong) PGBarChart *barChart;
@property (nonatomic, strong) PGBox *box;

/**
 data
 */
@property (strong, nonatomic) NSMutableArray *arrayData;
//@property (strong, nonatomic) UIScrollView *scrollView;
- (void)setModel:(DataStatisticsModel *)model WithScroll:(BOOL)isScroll;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
