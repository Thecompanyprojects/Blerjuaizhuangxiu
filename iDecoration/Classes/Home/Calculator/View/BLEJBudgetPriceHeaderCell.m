//
//  BLEJBudgetPriceHeaderCell.m
//  Calculator
//
//  Created by 赵春浩 on 17/4/28.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import "BLEJBudgetPriceHeaderCell.h"

@interface BLEJBudgetPriceHeaderCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *hallLabel;
@property (weak, nonatomic) IBOutlet UILabel *bedroomLabel;
@property (weak, nonatomic) IBOutlet UILabel *kitchenLabel;
@property (weak, nonatomic) IBOutlet UILabel *bathroomLabel;
@property (weak, nonatomic) IBOutlet UILabel *elseLabel;
@property (weak, nonatomic) IBOutlet UILabel *balconyLabel;
@property (weak, nonatomic) IBOutlet UILabel *manageLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *diningLabel;

@end


@implementation BLEJBudgetPriceHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.borderWidth = 5;
    self.bgView.layer.borderColor = RGB(233, 97, 29).CGColor;
    self.bgView.layer.cornerRadius = 60;
    self.bgView.layer.masksToBounds = YES;
}

- (void)setHallMoney:(NSString *)hallMoney {
    
    if (_hallMoney != hallMoney) {
        _hallMoney = hallMoney;
    }
    
    self.hallLabel.text = [NSString stringWithFormat:@"客厅:¥%@", hallMoney];
}

- (void)setBedroomMoney:(NSString *)bedroomMoney {
    
    if (_bedroomMoney != bedroomMoney) {
        _bedroomMoney = bedroomMoney;
    }
    
    self.bedroomLabel.text = [NSString stringWithFormat:@"卧室:¥%@", bedroomMoney];
}

- (void)setKitchenMoney:(NSString *)kitchenMoney {
    
    if (_kitchenMoney != kitchenMoney) {
        _kitchenMoney = kitchenMoney;
    }
    
    self.kitchenLabel.text = [NSString stringWithFormat:@"厨房:¥%@", kitchenMoney];
}

- (void)setBathroomMoney:(NSString *)bathroomMoney {
    
    if (_bathroomMoney != bathroomMoney) {
        _bathroomMoney = bathroomMoney;
    }
    
    self.bathroomLabel.text = [NSString stringWithFormat:@"卫生间:¥%@", bathroomMoney];
}

- (void)setElseMoney:(NSString *)elseMoney {
    
    if (_elseMoney != elseMoney) {
        _elseMoney = elseMoney;
    }
    
    self.elseLabel.text = [NSString stringWithFormat:@"其他:¥%@", elseMoney];
}

- (void)setBalconyMoney:(NSString *)balconyMoney {
    
    if (_balconyMoney != balconyMoney) {
        _balconyMoney = balconyMoney;
    }
    
    self.balconyLabel.text = [NSString stringWithFormat:@"阳台:¥%@", balconyMoney];
}

- (void)setManageMoney:(NSString *)manageMoney {
    
    if (_manageMoney != manageMoney) {
        _manageMoney = manageMoney;
    }
    
    self.manageLabel.text = [NSString stringWithFormat:@"管理费:¥%@", manageMoney];
}


- (void)setTotalMoney:(NSString *)totalMoney {
    
    if (_totalMoney != totalMoney) {
        _totalMoney = totalMoney;
    }
    
    self.totalLabel.text = [NSString stringWithFormat:@"¥%@", totalMoney];
}

- (void)setDiningMoney:(NSString *)diningMoney {
    
    _diningMoney = diningMoney;
    self.diningLabel.text = [NSString stringWithFormat:@"餐厅:¥%@", diningMoney];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
