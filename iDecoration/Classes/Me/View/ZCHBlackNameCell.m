//
//  ZCHBlackNameCell.m
//  iDecoration
//
//  Created by 赵春浩 on 17/10/13.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHBlackNameCell.h"
#import "ZCHCooperateListModel.h"

@interface ZCHBlackNameCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ZCHBlackNameCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setModel:(ZCHCooperateListModel *)model {
    
    _model = model;
    [self.logo sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    self.nameLabel.text = model.companyName;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
