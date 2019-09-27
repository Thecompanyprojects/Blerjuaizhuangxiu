//
//  GetConstructsTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 17/3/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HanZXModel.h"

@interface GetConstructsTableViewCell : UITableViewCell

@property (nonatomic, strong) HanZXModel *hanModel;
@property (nonatomic, strong) NSMutableArray *phoneArray;

@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *requirementTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;


@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;


@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *flagLabel;

@property (nonatomic, copy) void(^contactBlock)(NSMutableArray *phoneArr);
@property (nonatomic, copy) void(^toviewBlock)(NSString *companyId);
@property (weak, nonatomic) IBOutlet UILabel *fromLab;
@property (nonatomic,strong) UIButton *toviewBtn;
@end
