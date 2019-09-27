//
//  BLEJBudgetTemplateCell.m
//  Calculator
//
//  Created by 赵春浩 on 17/4/28.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import "BLEJBudgetTemplateCell.h"

@interface BLEJBudgetTemplateCell ()
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowOrDeleteBtn;


@end

@implementation BLEJBudgetTemplateCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


-(void)setModel:(BLRJCalculatortempletModelAllCalculatorTypes *)model{
    _model = model;
    self.nameLabel.text = model.supplementName?:@"";
    if ([self.cellType isEqualToString:@"0"]) {
        
        self.unitPriceLabel.text = [NSString stringWithFormat:@"单价:¥%.2lf",   [model.supplementPrice doubleValue] ];
    } else if ([self.cellType isEqualToString:@"1"]){
      
    
        self.unitPriceLabel.text = [NSString stringWithFormat:@"单价:¥%.2f%%",   [model.supplementPrice doubleValue]*100 ];
    } else {
        
        self.unitPriceLabel.text = [NSString stringWithFormat:@"单价:¥%.2lf",   [model.supplementPrice doubleValue] ];
    }
}

    

    
    
    



- (IBAction)didClickDeleteBtn:(UIButton *)sender {
    
    NSLog(@"delete");
    if ([self.budgetTemplateCellDelegate respondsToSelector:@selector(didClickDeleteBtn:)]) {
        
        [self.budgetTemplateCellDelegate didClickDeleteBtn:self.indexPath];
    }
    
}

- (void)setIsShowMinus:(BOOL)isShowMinus {
    
    if (_isShowMinus != isShowMinus) {
        _isShowMinus = isShowMinus;
    }
    
    self.arrowOrDeleteBtn.userInteractionEnabled = isShowMinus;
    [self.arrowOrDeleteBtn setImage:[UIImage imageNamed:isShowMinus ? @"delete-0" : @"btn_next"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
