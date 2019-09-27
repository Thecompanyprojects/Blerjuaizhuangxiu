//
//  YellowPageCompanyTableViewCell.h
//  iDecoration
//
//  Created by Apple on 2017/4/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDefaultModel.h"
#import "CompanyListModel.h"
#import "CollectionModel.h"
#import "ZCHCooperateListModel.h"


@class YellowPageCompanyTableViewCell;

@protocol YellowPageCompanyTableViewCellDelegate <NSObject>

- (void)YellowPageCompanyTableViewCell:(YellowPageCompanyTableViewCell *)cell moreBtnClicked:(UIButton *)btn;

@end

@interface YellowPageCompanyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelDetail2More;
//labelDetail2Less
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelDetail2Less;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelDetail1Less;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelDetail1More;

enum YellowPageCompanyTableViewCellType {//0:距离,-1好评,-2信用,2浏览,1:案例,5:商品
    YellowPageCompanyTableViewCellTypeDistance = 0,//距离
    YellowPageCompanyTableViewCellTypeLike = -1,//好评
    YellowPageCompanyTableViewCellTypeCredit = -2,//信用
    YellowPageCompanyTableViewCellTypeBrowse = 2,//浏览
    YellowPageCompanyTableViewCellTypeCase = 1,//案例
    YellowPageCompanyTableViewCellTypeGoods = 5,//商品
    YellowPageCompanyTableViewCellTypeAboutUs = 666,//关于我们
    YellowPageCompanyTableViewCellTypeDefault = 999,//商品
};
@property (nonatomic, strong) HomeDefaultModel *model;
@property (nonatomic, strong) CollectionModel *collecitonModel;

// 合作企业
@property (strong, nonatomic) ZCHCooperateListModel *cooperateModel;
@property (weak, nonatomic) IBOutlet UIView *viewAboutUs;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *caseNmuberLabel;
@property (weak, nonatomic) IBOutlet UILabel *supervisorNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *designerNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *gongzhangNumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *buttonRight;
@property (weak, nonatomic) IBOutlet UILabel *labelDetail1;
@property (weak, nonatomic) IBOutlet UILabel *labelDetail2;
@property (weak, nonatomic) IBOutlet UILabel *labelDetail3;
@property (weak, nonatomic) IBOutlet UILabel *labelDetail4;
@property (weak, nonatomic) IBOutlet UILabel *labelDetail5;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;





@property (weak, nonatomic) IBOutlet UILabel *detailButton;
@property (weak, nonatomic) IBOutlet UIImageView *vipImage;
// 三个点
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIImageView *moreImage;

@property (nonatomic, weak) id<YellowPageCompanyTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *phoneNumBtn;

// 电话名称
@property (weak, nonatomic) IBOutlet UILabel *phoneTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *recommendVipIV;

// 不是钻石会员是5 如果是钻石会员在设置
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipIVLeftMarginCon;

@property (weak, nonatomic) IBOutlet UIImageView *certificateStatusView;

@property (assign, nonatomic) enum YellowPageCompanyTableViewCellType cellType;


-(void)hiddenMoreBtn;
@end
