//
//  ZCHcouponCashCell.m
//  iDecoration
//
//  Created by 赵春浩 on 2017/12/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHcouponCashCell.h"

@interface ZCHcouponCashCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;



@end



@implementation ZCHcouponCashCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.contentView.backgroundColor = kBackgroundColor;
    
    self.typeBtn.layer.cornerRadius = 10;
    self.typeBtn.layer.masksToBounds = YES;
    self.typeBtn.layer.borderWidth = 1;
    self.typeBtn.layer.borderColor = kCustomColor(252, 232, 176).CGColor;
    
    self.iconView.layer.masksToBounds = YES;
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setModel:(ZCHCouponModel *)model {
    
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultLogo"]];
    self.companyNameLabel.text = model.companyName;
    NSString *beginTime = [[[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.startDate] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endTime = [[[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.endDate] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    if ([model.expired integerValue]==0) {
        self.timeLabel.text = @"已过期";
    }
    else{
        self.timeLabel.text = [NSString stringWithFormat:@"有效时间：%@-%@",beginTime, endTime];
    }
    
    
    if (![model.type isEqualToString:@"2"]) {
        
        [self.typeBtn setTitle:@"代金券" forState:UIControlStateNormal];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
        self.couponTypeLabel.text = model.couponName;
    } else {
        
        [self.typeBtn setTitle:@"礼品券" forState:UIControlStateNormal];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
        self.couponTypeLabel.text = model.couponName;
    }
}

- (void)setMyModel:(ZCHCouponModel *)myModel {
    
    _myModel = myModel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:myModel.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultLogo"]];
    self.companyNameLabel.text = myModel.companyName;
    NSString *beginTime = [myModel.startDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endTime = [myModel.endDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
//    self.timeLabel.text = [NSString stringWithFormat:@"有效时间：%@-%@",beginTime, endTime];
    
    if ([_myModel.expired integerValue]==0) {
        self.timeLabel.text = @"已过期";
    }
    else{
        self.timeLabel.text = [NSString stringWithFormat:@"有效时间：%@-%@",beginTime, endTime];
    }
    
    if (![myModel.type isEqualToString:@"2"]) {
        
        [self.typeBtn setTitle:@"代金券" forState:UIControlStateNormal];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:myModel.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
        self.couponTypeLabel.text = myModel.couponName;
    } else {
        
        [self.typeBtn setTitle:@"礼品券" forState:UIControlStateNormal];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:myModel.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
        self.couponTypeLabel.text = myModel.couponName;
    }
}


-(void)configData:(id)data{
    if ([data isKindOfClass:[ZCHCouponModel class]]) {
        ZCHCouponModel *model = data;
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultLogo"]];
        self.companyNameLabel.text = model.companyName;
//        NSString *beginTime = [[[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.startDate] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
//        NSString *endTime = [[[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.endDate] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            self.timeLabel.text = [NSString stringWithFormat:@"有效时间：%@-%@",model.startDate, model.endDate];
        
        
        if (![model.type isEqualToString:@"2"]) {
            
            [self.typeBtn setTitle:@"代金券" forState:UIControlStateNormal];
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
            self.couponTypeLabel.text = model.couponName;
        } else {
            
            [self.typeBtn setTitle:@"礼品券" forState:UIControlStateNormal];
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
            self.couponTypeLabel.text = model.couponName;
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
