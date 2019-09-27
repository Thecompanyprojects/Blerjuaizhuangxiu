//
//  BLEJBudgetPriceGroupHeaderCell.m
//  Calculator
//
//  Created by 赵春浩 on 17/4/28.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import "BLEJBudgetPriceGroupHeaderCell.h"

@interface BLEJBudgetPriceGroupHeaderCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;

@end

@implementation BLEJBudgetPriceGroupHeaderCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.contentView.backgroundColor = kBackgroundColor;
}

- (void)setTitleName:(NSString *)titleName {
    
    if (_titleName != titleName) {
        _titleName = titleName;
    }
    
    if ([titleName isEqualToString:@"预算总计"]) {
        
        self.titleLabel.textColor = [UIColor redColor];
        self.titleLabel.text = @"预算总计:";
    } else {
        
        self.titleLabel.textColor = Black_Color;
        self.titleLabel.text = titleName;
    }
}

- (void)setSumPrice:(NSString *)sumPrice {
    
    if (_sumPrice != sumPrice) {
        _sumPrice = sumPrice;
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@", sumPrice];
}

- (void)setIsRotate:(BOOL)isRotate {
    
    self.minusBtn.transform = CGAffineTransformIdentity;
    if (_isRotate != isRotate) {
        
        _isRotate = isRotate;
    }
    self.minusBtn.selected = isRotate;
    if (isRotate) {
        
        self.minusBtn.transform = CGAffineTransformRotate(self.minusBtn.transform, -M_PI_2);
    } else {
        
        self.minusBtn.transform = CGAffineTransformIdentity;
    }
}

- (void)setIsShowPlusAndMinusBtn:(BOOL)isShowPlusAndMinusBtn {
    
    if (_isShowPlusAndMinusBtn != isShowPlusAndMinusBtn) {
        
        _isShowPlusAndMinusBtn = isShowPlusAndMinusBtn;
    }
    self.plusBtn.hidden = !isShowPlusAndMinusBtn;
    self.minusBtn.hidden = !isShowPlusAndMinusBtn;
}

- (IBAction)didClickMinusBtn:(UIButton *)sender {
    
    if ([self.budgetPriceGroupHeaderCellDelegate respondsToSelector:@selector(didClickMinusBtnWithSection:andIsSelected:)]) {
        
        [self.budgetPriceGroupHeaderCellDelegate didClickMinusBtnWithSection:self.sectionIndex andIsSelected:!sender.selected];
    }
}

- (IBAction)didClickPlusBtn:(UIButton *)sender {
    
    if ([self.budgetPriceGroupHeaderCellDelegate respondsToSelector:@selector(didClickPlusBtnWithSection:)]) {
        
        [self.budgetPriceGroupHeaderCellDelegate didClickPlusBtnWithSection:self.sectionIndex];
    }   
}




@end
