//
//  ConstructionSiteStatisticsViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ConstructionSiteStatisticsViewController.h"

@interface ConstructionSiteStatisticsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *zeroZeroLabel;
@property (weak, nonatomic) IBOutlet UILabel *zeroOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *zeroTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneZeroLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneTwoLabel;

@property (weak, nonatomic) IBOutlet UILabel *zeroZeroNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *zeroOneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *zeroTwoNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneZeroNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneOneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneTwoNumLabel;

@end

@implementation ConstructionSiteStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.controllerType == 98) {
        // 活动
        self.zeroZeroLabel.text = @"今日浏览量";
        self.zeroOneLabel.text = @"今日分享";
        self.zeroTwoLabel.text = @"今日报名";
        self.oneZeroLabel.text = @"总浏览量";
        self.oneOneLabel.text = @"总分享";
        self.oneTwoLabel.text = @"总报名";
        
        // 数据待定
        
    }else if (self.controllerType == 99) {
        // 计算器
        self.zeroZeroLabel.text = @"今日手机号";
        self.zeroOneLabel.text = @"今日计算量";
        self.zeroTwoLabel.text = @"今日浏览量";
        self.oneZeroLabel.text = @"总手机号";
        self.oneOneLabel.text = @"总计算量";
        self.oneTwoLabel.text = @"总浏览量";
        
        self.zeroZeroNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.todayCustomer];
        self.zeroOneNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.ccbtTodayCal];
        self.zeroTwoNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.ccbtTodayBrowse];
        self.oneZeroNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.totalCustomer];
        self.oneOneNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.ccbtCalTimes];
        self.oneTwoNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.ccbtBrowse];
        
    } else {
        // 工地
        self.zeroZeroNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.cconTodayShare];
        self.zeroOneNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.cconTodayScan];
        self.zeroTwoNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.cconTodayLike];
        self.oneZeroNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.cconShareNumbers];
        self.oneOneNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.cconScanCount];
        self.oneTwoNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.cconLikeNumbers];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
