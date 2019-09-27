//
//  BLEJBudgetPriceCell.m
//  Calculator
//
//  Created by 赵春浩 on 17/4/28.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import "BLEJBudgetPriceCell.h"

@interface BLEJBudgetPriceCell ()
// 名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 面积
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
// 单价
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
// 总价
@property (weak, nonatomic) IBOutlet UILabel *sumPriceLabel;
// 右侧的图片
@property (weak, nonatomic) IBOutlet UIButton *arrowOrDeleteBtn;

@end

@implementation BLEJBudgetPriceCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

//- (void)setModel:(BLEJCalculatorBudgetPriceCellModel *)model {
//    
//    if (_model != model) {
//        _model = model;
//    }
//    self.nameLabel.text = model.name;
//    
//    if ([model.type isEqualToString:@"1"]) {
//        
//        self.areaLabel.text = [NSString stringWithFormat:@"面积:%@㎡", model.area];
//        self.unitPriceLabel.text = [NSString stringWithFormat:@"单价:¥%@", model.price];
//        self.sumPriceLabel.text = [NSString stringWithFormat:@"¥%@", model.totalPrice];
//    }
//    
//    if ([model.type isEqualToString:@"2"]) {
//        if (!model.unitName) {
//            model.unitName = @"";
//        }
//        self.areaLabel.text = [NSString stringWithFormat:@"数量:%@%@", model.area, model.unitName];
//        self.unitPriceLabel.text = [NSString stringWithFormat:@"单价:¥%@", model.price];
//        self.sumPriceLabel.text = [NSString stringWithFormat:@"¥%@", model.totalPrice];
//    }
//    
//    if ([model.type isEqualToString:@"3"]) {
//        
//        
//        self.areaLabel.text = [NSString stringWithFormat:@"直接:%@", model.area];
//        self.unitPriceLabel.text = [NSString stringWithFormat:@"单价:%.2lf%%", [model.price doubleValue] * 100];
//        self.sumPriceLabel.text = [NSString stringWithFormat:@"¥%@", model.totalPrice];
//    }
//    
//    if ([model.type isEqualToString:@"4"]) {
//        
//        self.areaLabel.text = [NSString stringWithFormat:@"金额:%@", model.area];
//        self.unitPriceLabel.text = [NSString stringWithFormat:@"单价:%.2lf%%", [model.price doubleValue] * 100];
//        self.sumPriceLabel.text = [NSString stringWithFormat:@"¥%@", model.totalPrice];
//    }
//    
//}


- (void)setItemModel:(BLRJCalculatortempletModelAllCalculatorTypes *)itemModel {
    
    if (_itemModel != itemModel) {
        _itemModel = itemModel;
    }
    self.nameLabel.text = itemModel.supplementName;

    self.sumPriceLabel.text = [NSString stringWithFormat:@"%.2ld", (long)itemModel.sumMoney];
    
    if ([@[@"2021", @"2022", @"2023", @"2024"] containsObject:@(itemModel.templeteTypeNo).stringValue]) {
        
        self.unitPriceLabel.text = [NSString stringWithFormat:@"单价:%.2f%%", [itemModel.supplementPrice doubleValue] * 100];
    } else {
        
        self.unitPriceLabel.text = [NSString stringWithFormat:@"单价:¥%.2f", [itemModel.supplementPrice doubleValue]];
    }
    
    if ([@[@"2021", @"2022", @"2023", @"2024"] containsObject:@(itemModel.templeteTypeNo).stringValue]) {
        if ([itemModel.supplementName isEqualToString:@"其他费用"] || [itemModel.supplementName isEqualToString:@"直接费用"]) {
            
            self.areaLabel.text = [NSString stringWithFormat:@"金额:%.2ld", itemModel.number];
        } else {
            
            self.areaLabel.text = [NSString stringWithFormat:@"直接:%.2ld", itemModel.number];
        }
    } else if (itemModel.templeteTypeNo == 2016) {
        
        self.areaLabel.text = [NSString stringWithFormat:@"数量:%.2ld%@", (long)itemModel.number, itemModel.supplementUnit];
    } else if (itemModel.templeteTypeNo == 2030) {
        
        self.areaLabel.text = [NSString stringWithFormat:@"长度:%.2ldm", (long)itemModel.number];
    } else if (itemModel.templeteTypeNo > 0) {
        
        self.areaLabel.text = [NSString stringWithFormat:@"面积:%.2ld㎡", (long)itemModel.number];
    } else {
        
        self.areaLabel.text = [NSString stringWithFormat:@"数量:%.2ld%@", (long)itemModel.number, itemModel.supplementUnit];
    }
}


- (void)setIsShowMinus:(BOOL)isShowMinus {
    
    if (_isShowMinus != isShowMinus) {
        _isShowMinus = isShowMinus;
    }
    
    self.arrowOrDeleteBtn.userInteractionEnabled = isShowMinus;
    [self.arrowOrDeleteBtn setImage:[UIImage imageNamed:isShowMinus ? @"delete-0" : @"btn_next"] forState:UIControlStateNormal];
}



- (IBAction)didClickDeleteBtn:(UIButton *)sender {
    
    if ([self.budgetPriceCellDelegate respondsToSelector:@selector(didClickDeleteBtn:)]) {
        
        [self.budgetPriceCellDelegate didClickDeleteBtn:self.indexPath];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
