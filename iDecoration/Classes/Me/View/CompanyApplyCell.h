//
//  CompanyApplyCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/6/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

// 消息中心 公司申请 view
#import <UIKit/UIKit.h>
#import "CompanyApplyModel.h"

@interface CompanyApplyCell : UITableViewCell

@property (nonatomic, strong) CompanyApplyModel *applyModel;

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLb;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtnCon;

@property (nonatomic, copy) void (^iconTapBlock)();

@end
