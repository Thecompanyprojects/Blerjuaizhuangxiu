//
//  SiteInfoTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 17/3/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteModel.h"
#import "copyLabel.h"

@protocol SiteInfoTableViewCellDelegate <NSObject>

-(void)modifyConInfo;

@end

@interface SiteInfoTableViewCell : UITableViewCell

//@property (nonatomic, strong) SiteModel *siteModel;

@property (strong, nonatomic) UIButton *modifyBtn;
@property (strong, nonatomic) UILabel *houseHoldName;
@property (strong, nonatomic) UILabel *leftNumberName;
@property (strong, nonatomic) copyLabel *numberName;//工单编号
@property (strong, nonatomic) UILabel *locationName;
@property (strong, nonatomic) UILabel *siteAddress;
@property (strong, nonatomic) UILabel *shareTitle;
@property (strong, nonatomic) UILabel *shareRightTitle;

@property (strong, nonatomic) UILabel *constructCompany;
@property (strong, nonatomic) UILabel *signDate;
@property (strong, nonatomic) UILabel *styleLabel;
@property (strong, nonatomic) UILabel *area;
@property (strong, nonatomic) UILabel *currentNode;
@property (strong, nonatomic) UILabel *contractTime;
@property (strong, nonatomic) UILabel *timeWarning;


@property (nonatomic, assign) CGFloat cellH;
-(void)configWith:(id)data;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, weak)id<SiteInfoTableViewCellDelegate>delegate;
@end
