//
//  ConstructsDetailViewController.h
//  iDecoration
//
//  Created by RealSeven on 17/3/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "HanZXModel.h"

@interface ConstructsDetailViewController : SNViewController

@property (nonatomic, strong) HanZXModel *hanModel;
@property (weak, nonatomic) IBOutlet UILabel *houseHoldNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;//面积
@property (weak, nonatomic) IBOutlet UILabel *budgetLabel;//预算
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;

@end
