//
//  CalculateCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/6/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculateModel.h"
@class CalculateCell;

@protocol CalculateCellDelegate <NSObject>

- (void)calculateCell:(CalculateCell *)cell callButtton:(UIButton *)callBtn phoneNumber:(NSString *)phoneNum;
-(void)myTabVClick:(UITableViewCell *)cell;
@end


@interface CalculateCell : UITableViewCell

// 面积
@property (weak, nonatomic) IBOutlet UILabel *totalAreaLabel;
// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
// 报价名称
@property (weak, nonatomic) IBOutlet UILabel *priceNameLabel;
// 报价
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

// 另一个报价名称
@property (weak, nonatomic) IBOutlet UILabel *secondPriceNameLabel;
// 另一个报价
@property (weak, nonatomic) IBOutlet UILabel *secondPriceLabel;

// 手机号码
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
// 公司名称
@property (weak, nonatomic) IBOutlet UILabel *companyNameLb;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyNameLbTopCon;

// 打电话图片
@property (weak, nonatomic) IBOutlet UIButton *callButton;
// 户型
@property (weak, nonatomic) IBOutlet UILabel *huxingLabel;

//@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UIButton *starImageBtn;

@property (weak, nonatomic) IBOutlet UITextView *beizhuTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beizhuTVHeightCon;

@property (weak, nonatomic) IBOutlet UILabel *isReadFlag;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *isReadFlagWidthCon;


@property (weak,nonatomic)UITableView * tableView;


@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (nonatomic, strong) CalculateModel *model;

@property (nonatomic, weak) id<CalculateCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *workerLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beizhuTopCon;
@property (nonatomic,strong) UIButton *toviewBtn;
@end
