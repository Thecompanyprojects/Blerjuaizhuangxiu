//
//  YellowPageShopTableViewCell.h
//  iDecoration
//
//  Created by Apple on 2017/4/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDefaultModel.h"
#import "ShopListModel.h"
#import "CollectionModel.h"
#import "ZCHCooperateListModel.h"


@class YellowPageShopTableViewCell;

@protocol YellowPageShopTableViewCellDelegate <NSObject>

- (void)YellowPageShopTableViewCell:(YellowPageShopTableViewCell *)cell moreBtnClicked:(UIButton *)btn;

@end


@interface YellowPageShopTableViewCell : UITableViewCell
@property (nonatomic, strong) HomeDefaultModel *model;
@property (nonatomic, strong) ShopListModel *shopListModel;
@property (nonatomic, strong) CollectionModel *collectionModel;

// 合作企业
@property (strong, nonatomic) ZCHCooperateListModel *cooperateModel;

@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@property (weak, nonatomic) IBOutlet UILabel *goodsNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *showNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *browseNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectNumberLabel;


@property (weak, nonatomic) IBOutlet UILabel *detailButton;
@property (weak, nonatomic) IBOutlet UIImageView *vipImage;


@property (weak, nonatomic) IBOutlet UIImageView *moreImage;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet UIImageView *recommendVipIV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipIVLeftMarginCon;
@property (weak, nonatomic) IBOutlet UIImageView *certificateStatusIV;


@property (weak, nonatomic) IBOutlet UILabel *labelDetail1;
@property (weak, nonatomic) IBOutlet UILabel *labelDetail2;
@property (weak, nonatomic) IBOutlet UILabel *labelDetail3;

@property (nonatomic, weak) id<YellowPageShopTableViewCellDelegate> delegate;

-(void)hiddenMoreBtn;
@end
