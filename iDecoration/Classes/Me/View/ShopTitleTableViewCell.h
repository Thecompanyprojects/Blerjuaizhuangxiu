//
//  ShopTitleTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 2017/4/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopTitleTableViewCellDelegat <NSObject>
// 企业网会员会员
-(void)goOpenVipVC;
// 云管理会员
-(void)goVipDetailVC;
// 计算器模板
- (void)goCalculateVipVC;
// 线上通道会员
- (void)goOnLineVIPVC;

// 如何提高排名
- (void)raiseTheRankAction;
@optional
// 去认证
- (void)gotoCertificateAction;

@end

@interface ShopTitleTableViewCell : UITableViewCell

// 头部icon
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *shopLogoImageView;
// 公司名称
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
// 公司介绍
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

// 企业网会员icon
@property (weak, nonatomic) IBOutlet UIImageView *yellowImageView;
// 企业网会员到期
@property (weak, nonatomic) IBOutlet UILabel *yellowTimeLabel;
// 企业网会员按钮
@property (weak, nonatomic) IBOutlet UIButton *yellowButton;
// 云管理会员icon
@property (weak, nonatomic) IBOutlet UIImageView *dailyImageView;
// 云管理会员到期
@property (weak, nonatomic) IBOutlet UILabel *dailyTimeLabel;
// 云管理会员按钮
@property (weak, nonatomic) IBOutlet UIButton *dailyButton;
// 计算器会员icon
@property (weak, nonatomic) IBOutlet UIImageView *calculateImageView;
// 计算器会员到期
@property (weak, nonatomic) IBOutlet UILabel *calculateTimeLabel;
// 计算器会员按钮
@property (weak, nonatomic) IBOutlet UIButton *calculateButton;


// 线上通道icon
@property (weak, nonatomic) IBOutlet UIImageView *onLineImageView;
// 线上通道到期
@property (weak, nonatomic) IBOutlet UILabel *onLineTimeLabel;
// 线上通道按钮
@property (weak, nonatomic) IBOutlet UIButton *onLineButton;


@property (weak, nonatomic) IBOutlet UILabel *yellowMoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyMoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *calculateMoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *onLineMoreLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentWidthCon;


@property (nonatomic,strong) UILabel *companyIdlab;
@property (weak, nonatomic) IBOutlet UIView *questionBtn;

@property (weak, nonatomic) IBOutlet UIButton *certificateBtn;
@property (weak, nonatomic) IBOutlet UIImageView *certificateStateImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLabelTarilingCon; // 有按钮是82 没按钮是10






@property (copy, nonatomic) NSString *jobId;
@property (nonatomic, weak) id<ShopTitleTableViewCellDelegat>delegate;
-(void)configData:(id)data;
@end
