//
//  ZCHSimpleSettingHeaderDetailCell.m
//  iDecoration
//
//  Created by 赵春浩 on 17/7/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHSimpleSettingHeaderDetailCell.h"
#import "ZCHSimpleSettingMessageModel.h"

@implementation ZCHSimpleSettingHeaderDetailCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setModel:(ZCHSimpleSettingMessageModel *)model {
    
    _model = model;
    self.designSwitch.on = [model.hasDesign boolValue];
    self.detailPriceSwitch.on = [model.showDetail boolValue];
    self.TaxSwith.on=[model.tax boolValue];
}

- (IBAction)didClickSwitch:(UISwitch *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickSwitchBtn:andType:)]) {
        
        if (sender == self.designSwitch) {// 设计费
            
            [self.delegate didClickSwitchBtn:sender andType:@"1"];
        } else if(sender == self.detailPriceSwitch) {// 详细报价
            
            [self.delegate didClickSwitchBtn:sender andType:@"2"];
        }else if(sender == self.TaxSwith){//收取税费
            
            [self.delegate didClickSwitchBtn:sender andType:@"3"];
        }
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
