//
//  GoodsStatisticsViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsStatisticsViewController.h"

@interface GoodsStatisticsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *zeroZeroLabel;
@property (weak, nonatomic) IBOutlet UILabel *zeroOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *zeroTwoLabel;

@property (weak, nonatomic) IBOutlet UILabel *oneZeroLabel;


@property (weak, nonatomic) IBOutlet UILabel *zeroZeroNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *zeroOneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *zeroTwoNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *oneZeroNumLabel;

@end

@implementation GoodsStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.controllerType == 99) {
        // 公司量房
        self.zeroZeroLabel.text = @"今日量房";
        self.zeroOneLabel.text = @"总量房";
        self.zeroTwoLabel.text = @"今日浏览量";
        self.oneZeroLabel.text = @"总浏览量";
        
        self.zeroZeroNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.todayCallDecor];
        self.zeroOneNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.totalCallDecor];
        self.zeroTwoNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.todayCallBrowse];
        self.oneZeroNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.callBrowse];
    }
    if (self.controllerType == 999) {
        // 店铺预约
        self.zeroZeroLabel.text = @"今日预约";
        self.zeroOneLabel.text = @"总预约";
        self.zeroTwoLabel.text = @"今日浏览量";
        self.oneZeroLabel.text = @"总浏览量";
        self.zeroZeroNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.todayCallDecor];
        self.zeroOneNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.totalCallDecor];
        self.zeroTwoNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.todayCallBrowse];
        self.oneZeroNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.callBrowse];
        
    } else {
        // 商品
        self.zeroZeroNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.cmTodayShare];
        self.zeroOneNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.cmShareNumbers];
        self.zeroTwoNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.cmTodayBrowse];
        self.oneZeroNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.cmBrowse];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


























