//
//  ZCHSelectCouponCell.m
//  iDecoration
//
//  Created by 赵春浩 on 2018/1/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ZCHSelectCouponCell.h"

@interface ZCHSelectCouponCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation ZCHSelectCouponCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.contentView.backgroundColor = kBackgroundColor;
    
    self.typeBtn.layer.cornerRadius = 10;
    self.typeBtn.layer.masksToBounds = YES;
    self.typeBtn.layer.borderWidth = 1;
    self.typeBtn.layer.borderColor = kCustomColor(252, 232, 176).CGColor;
}

- (IBAction)didClickSelectBtn:(UIButton *)sender {
    
    sender.selected = YES;
    if ([self.delegate respondsToSelector:@selector(didClickSelectWithIndexPath:)]) {
        
        [self.delegate didClickSelectWithIndexPath:self.indexPath];
    }
}

- (void)setModel:(ZCHCouponModel *)model {
    
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultLogo"]];
    self.companyNameLabel.text = model.companyName;
    NSString *beginTime = [[[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.startDate] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *endTime = [[[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.endDate] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.timeLabel.text = [NSString stringWithFormat:@"有效时间：%@-%@",beginTime, endTime];
    
    if ([model.type isEqualToString:@"0"]||[model.type isEqualToString:@"1"]) {
        
        [self.typeBtn setTitle:@"代金券" forState:UIControlStateNormal];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
        self.couponTypeLabel.text = model.couponName;
    } else {
        
        [self.typeBtn setTitle:@"礼品券" forState:UIControlStateNormal];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
        self.couponTypeLabel.text = model.couponName;
    }
    self.selectBtn.selected = model.isSelect;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
