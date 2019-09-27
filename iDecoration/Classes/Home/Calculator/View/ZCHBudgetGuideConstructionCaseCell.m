//
//  ZCHBudgetGuideConstructionCaseCell.m
//  iDecoration
//
//  Created by 赵春浩 on 17/5/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHBudgetGuideConstructionCaseCell.h"
#import "ZCHBudgetGuideConstructionCaseModel.h"

@interface ZCHBudgetGuideConstructionCaseCell ()



@end


@implementation ZCHBudgetGuideConstructionCaseCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}




- (void)setModel:(ZCHBudgetGuideConstructionCaseModel *)model {
    
    if (_model != model) {
        _model = model;
    }
    
    NSString *url = model.picUrl ? model.picUrl : model.coverMap;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_icon"]];
    self.contentLabel.text = model.ccShareTitle;
    self.areaNameLabel.text = model.ccAreaName;
    self.displayCountLabel.text = model.displayNumbers;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
