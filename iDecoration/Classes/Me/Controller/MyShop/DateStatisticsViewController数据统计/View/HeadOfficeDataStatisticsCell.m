//
//  HeadOfficeDataStatisticsCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/11/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "HeadOfficeDataStatisticsCell.h"

@implementation HeadOfficeDataStatisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)headOfficeDataStatisticsCellWith:(UITableView *)tableView selectedIndex:(NSInteger)selectedIndex {
    NSString *identifier = @"";
    
    NSInteger index = 0;
    switch (selectedIndex) {
        case 0: // 企业
        {
            identifier = @"HeadOfficeDataStatisticsCellFirst";
            index = 0;
        }
            break;
        case 1: // 工地
        case 2: // 计算器
        case 5: // 活动
        {
            identifier = @"HeadOfficeDataStatisticsCellSecond";
            index = 1;
        }
            break;
        case 3: // 量房/预约
        case 4: // 商品
        {
            identifier = @"HeadOfficeDataStatisticsCellThird";
            index = 2;
        }
            break;
        default:
            break;
    }
    HeadOfficeDataStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HeadOfficeDataStatisticsCell" owner:self options:nil][index];
    }
    return cell;
}
- (void)setModel:(DateStatisticsModel *)model type:(NSInteger)type {
    // 企业
    if (type == 0) {
        self.zeroZeroNumLabel.text = [NSString stringWithFormat:@"%lu", model.todayDisplay];
        self.zeroOneNumLabel.text = [NSString stringWithFormat:@"%lu", model.todayBrowse];
        self.zeroTwoNumLabel.text = [NSString stringWithFormat:@"%lu", model.todayColloction];
        self.oneZeroNumLabel.text = [NSString stringWithFormat:@"%lu", model.displayNumbers];
        self.oneOneNumLabel.text = [NSString stringWithFormat:@"%lu", model.browse];
        self.oneTwoNumLabel.text = [NSString stringWithFormat:@"%lu", model.collectionNumbers];
        self.twoZeroNumLabel.text = [NSString stringWithFormat:@"%lu", model.todayShare];
        self.twoOneNumLabel.text = [NSString stringWithFormat:@"%lu", model.shareNumbers];
        self.twoTwoNumLabel.text = [NSString stringWithFormat:@"%lu", model.cscCounts];
        
    }
    // 工地
    if (type == 1) {
        self.zeroZeroNumLabel.text = [NSString stringWithFormat:@"%lu", model.cconTodayShare];
        self.zeroOneNumLabel.text = [NSString stringWithFormat:@"%lu", model.cconTodayScan];
        self.zeroTwoNumLabel.text = [NSString stringWithFormat:@"%lu", model.cconTodayLike];
        self.oneZeroNumLabel.text = [NSString stringWithFormat:@"%lu", model.cconShareNumbers];
        self.oneOneNumLabel.text = [NSString stringWithFormat:@"%lu", model.cconScanCount];
        self.oneTwoNumLabel.text = [NSString stringWithFormat:@"%lu", model.cconLikeNumbers];
    }
    // 计算器
    if (type == 2) {
        self.ZeroZeroLabel.text = @"今日手机号";
        self.ZeroOneLabel.text = @"今日计算量";
        self.ZeroTwoLabel.text = @"今日浏览量";
        self.OneZeroLabel.text = @"总手机号";
        self.OneOneLabel.text = @"总计算量";
        self.OneTwoLabel.text = @"总浏览量";
        
        self.zeroZeroNumLabel.text = [NSString stringWithFormat:@"%lu", model.todayCustomer];
        self.zeroOneNumLabel.text = [NSString stringWithFormat:@"%lu", model.ccbtTodayCal];
        self.zeroTwoNumLabel.text = [NSString stringWithFormat:@"%lu", model.ccbtTodayBrowse];
        self.oneZeroNumLabel.text = [NSString stringWithFormat:@"%lu", model.totalCustomer];
        self.oneOneNumLabel.text = [NSString stringWithFormat:@"%lu", model.ccbtCalTimes];
        self.oneTwoNumLabel.text = [NSString stringWithFormat:@"%lu", model.ccbtBrowse];
    }
    // 喊装修
    if (type == 3) {
        
        if ([model.companyType isEqualToString:@"1018"] || [model.companyType isEqualToString:@"1065"] || [model.companyType isEqualToString:@"1064"]) {
            // 公司的
            self.ZeroZeroLabel.text = @"今日量房";
            self.ZeroOneLabel.text = @"总量房";
            self.ZeroTwoLabel.text = @"今日浏览量";
            self.OneZeroLabel.text = @"总浏览量";
        } else {
            // 公司的
            self.ZeroZeroLabel.text = @"今日预约";
            self.ZeroOneLabel.text = @"总预约";
            self.ZeroTwoLabel.text = @"今日浏览量";
            self.OneZeroLabel.text = @"总浏览量";
        }
        self.zeroZeroNumLabel.text = [NSString stringWithFormat:@"%lu", model.todayCallDecor];
        self.zeroOneNumLabel.text = [NSString stringWithFormat:@"%lu", model.totalCallDecor];
        self.zeroTwoNumLabel.text = [NSString stringWithFormat:@"%lu", model.todayCallBrowse];
        self.oneZeroNumLabel.text = [NSString stringWithFormat:@"%lu", model.callBrowse];
    }
    // 商品
    if (type == 4) {
        self.ZeroZeroLabel.text = @"今日分享";
        self.ZeroOneLabel.text = @"总分享";
        self.ZeroTwoLabel.text = @"今日浏览量";
        self.OneZeroLabel.text = @"总浏览量";
        
        self.zeroZeroNumLabel.text = [NSString stringWithFormat:@"%lu", model.cmTodayShare];
        self.zeroOneNumLabel.text = [NSString stringWithFormat:@"%lu", model.cmShareNumbers];
        self.zeroTwoNumLabel.text = [NSString stringWithFormat:@"%lu", model.cmTodayBrowse];
        self.oneZeroNumLabel.text = [NSString stringWithFormat:@"%lu", model.cmBrowse];
    }
    // 计算器
    if (type == 2) {
        self.ZeroZeroLabel.text = @"今日浏览量";
        self.ZeroOneLabel.text = @"今日分享";
        self.ZeroTwoLabel.text = @"今日报名";
        self.OneZeroLabel.text = @"总浏览量";
        self.OneOneLabel.text = @"总分享";
        self.OneTwoLabel.text = @"总报名";
        
        // 数据待定
    }
}
@end
