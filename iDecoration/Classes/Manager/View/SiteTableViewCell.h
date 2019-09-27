//
//  SiteTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 17/3/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteModel.h"

@protocol SiteTableViewCellDelegate <NSObject>
-(void)HandleccompleteWith:(NSIndexPath *)path;

-(void)HandleccompleteWith:(NSIndexPath *)path tag:(NSInteger)tag;


-(void)HandFlowerWith:(NSIndexPath *)path;

-(void)HanBannerWith:(NSIndexPath *)path;

-(void)HandPushWith:(NSIndexPath *)path;
// 是否在企业网显示
- (void)didClickIsSelectBtn:(NSIndexPath *)path;

@end

@interface SiteTableViewCell : UITableViewCell

@property (nonatomic, strong) SiteModel *siteModel;


@property (weak, nonatomic) IBOutlet UILabel *houseHoldLabel;
@property (weak, nonatomic) IBOutlet UILabel *signDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *nodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *constructionCompanyLabel;


@property (nonatomic, strong) UIView *lineV;
@property (nonatomic, strong) UIButton *flowerBtn;
@property (nonatomic, strong) UIButton *bannerBtn;
@property (nonatomic, strong) UIButton *pushBtn;
@property (strong, nonatomic) UIView *bottomView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationLabelWidthCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyLabelWidthCon;


@property (nonatomic, strong) NSIndexPath *path;

-(void)configData:(id)data;
@property (nonatomic, copy) void(^finishBlock)(SiteModel *site,UIButton *stateBtn);
@property (nonatomic, weak)id<SiteTableViewCellDelegate>delegate;

@property (strong, nonatomic) SiteModel *cardModel;

@end
