//
//  YellowPageStatisticsViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "YellowPageStatisticsViewController.h"

@interface YellowPageStatisticsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *zeroZeroNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *zeroOneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *zeroTwoNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *oneZeroNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneOneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneTwoNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *twoZeroNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoOneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoTwoNumLabel;


@end

@implementation YellowPageStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.zeroZeroNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.todayDisplay];
    self.zeroOneNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.todayBrowse];
    self.zeroTwoNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.todayColloction];
    self.oneZeroNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.displayNumbers];
    self.oneOneNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.browse];
    self.oneTwoNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.collectionNumbers];
    self.twoZeroNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.todayShare];
    self.twoOneNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.shareNumbers];
    self.twoTwoNumLabel.text = [NSString stringWithFormat:@"%lu", self.sonCompanyDateModel.cscCounts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
