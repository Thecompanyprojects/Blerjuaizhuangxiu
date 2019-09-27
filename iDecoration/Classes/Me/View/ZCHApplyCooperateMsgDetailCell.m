//
//  ZCHApplyCooperateMsgDetailCell.m
//  iDecoration
//
//  Created by 赵春浩 on 17/10/23.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHApplyCooperateMsgDetailCell.h"
#import "ZCHCooperateListModel.h"

@interface ZCHApplyCooperateMsgDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *extraMsg;

@end

@implementation ZCHApplyCooperateMsgDetailCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setDetailMsgModel:(ZCHCooperateListModel *)detailMsgModel {
    
    _detailMsgModel = detailMsgModel;
    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:detailMsgModel.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    self.companyName.text = detailMsgModel.companyName;
    self.extraMsg.text = [NSString stringWithFormat:@"申请与%@成为合作企业", detailMsgModel.benCompanyName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
