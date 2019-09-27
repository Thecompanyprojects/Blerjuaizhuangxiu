//
//  MyOrderCell.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"
#import "CompanyIncomeModel.h"

@interface MyOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@property (nonatomic, copy) void(^gotoDetailBlock)();

@property (nonatomic, strong) MyOrderModel *model;

@property (nonatomic, strong) CompanyIncomeModel *companyIncomeModel;

@end
