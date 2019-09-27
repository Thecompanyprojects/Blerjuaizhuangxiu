//
//  ZCHBudgetGuideConstructionCaseCell.h
//  iDecoration
//
//  Created by 赵春浩 on 17/5/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZCHBudgetGuideConstructionCaseModel;


@interface ZCHBudgetGuideConstructionCaseCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayCountLabel;


@property (strong, nonatomic) ZCHBudgetGuideConstructionCaseModel *model;

@end
