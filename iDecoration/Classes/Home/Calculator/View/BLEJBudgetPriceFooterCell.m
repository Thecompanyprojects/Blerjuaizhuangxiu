//
//  BLEJBudgetPriceFooterCell.m
//  Calculator
//
//  Created by 赵春浩 on 17/5/2.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import "BLEJBudgetPriceFooterCell.h"

@interface BLEJBudgetPriceFooterCell ()

@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;

@end

@implementation BLEJBudgetPriceFooterCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)setTotalMoney:(NSString *)totalMoney {
    
    if (_totalMoney != totalMoney) {
        _totalMoney = totalMoney;
    }
    
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"预算总计:¥%@", totalMoney];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
