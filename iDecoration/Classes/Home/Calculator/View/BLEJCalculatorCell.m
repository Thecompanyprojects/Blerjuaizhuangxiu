//
//  BLEJCalculatorCell.m
//  Calculator
//
//  Created by 赵春浩 on 17/4/27.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import "BLEJCalculatorCell.h"

@interface BLEJCalculatorCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *calcuLabel;




@end

@implementation BLEJCalculatorCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.calcuLabel.layer.borderWidth = 1;
    self.calcuLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.calcuLabel.layer.cornerRadius = 5;
    self.calcuLabel.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.iconView.backgroundColor = kRandomColor;
}

- (void)setCalculatorGetCompanyListModel:(BLEJCalculatorGetCompanyListModel *)calculatorGetCompanyListModel {
    
    if (_calculatorGetCompanyListModel != calculatorGetCompanyListModel) {
        _calculatorGetCompanyListModel = calculatorGetCompanyListModel;
    }
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:calculatorGetCompanyListModel.companyLogo] placeholderImage:[UIImage imageNamed:@"headpicture_default_list"]];
    self.nameLabel.text = calculatorGetCompanyListModel.companyName;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
