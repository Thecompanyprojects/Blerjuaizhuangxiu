//
//  MyOrderCell.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "MyOrderCell.h"

@implementation MyOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.detailBtn.layer.cornerRadius = 5;
    self.detailBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)detailBtnAction:(id)sender {
    if (self.gotoDetailBlock) {
        self.gotoDetailBlock();
    }
}


- (void)setModel:(MyOrderModel *)model {
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.coverMap]];
    self.titleLabel.text = model.designTitle;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.money];
    // （0：未支付，1：待确认，2：已确认）
    if (self.model.status.integerValue == 1) {
        self.stateLabel.text = @"待确认";
    }
    if (self.model.status.integerValue == 2) {
        self.stateLabel.text = @"已确认";
    }
    if (self.model.status.integerValue == 0) {
        self.stateLabel.text = @"未支付";
    }
   
}

- (void)setCompanyIncomeModel:(CompanyIncomeModel *)companyIncomeModel {
    _companyIncomeModel = companyIncomeModel;
    self.stateLabel.hidden = YES;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:companyIncomeModel.coverMap]];
    self.titleLabel.text = companyIncomeModel.costName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",companyIncomeModel.money];
}

@end
