//
//  ZCHApplyCooperateCell.m
//  iDecoration
//
//  Created by 赵春浩 on 17/10/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHApplyCooperateCell.h"
#import "ZCHCooperateListModel.h"
#import "UnionInviteMessageModel.h"

@interface ZCHApplyCooperateCell ()

@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *extraMsg;
@property (weak, nonatomic) IBOutlet UIButton *applyTypeBtn;

@end

@implementation ZCHApplyCooperateCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickCompanyIcon:)];
    [self.companyLogo addGestureRecognizer:tap];
}

- (void)setModel:(ZCHCooperateListModel *)model {
    
    _model = model;
    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    self.companyName.text = model.companyName;
    self.extraMsg.text = model.typeName;
    
    [self.applyTypeBtn setTitle:@"申请" forState:UIControlStateNormal];
    // kCustomColor(234, 104, 72)
    [self.applyTypeBtn setBackgroundColor:kMainThemeColor];
    
    if ([model.companyId isEqualToString:self.currentCompanyId]) {
        
        self.applyTypeBtn.hidden = YES;
    } else {
        
        self.applyTypeBtn.hidden = NO;
    }
}

- (void)setMsgModel:(ZCHCooperateListModel *)msgModel {
    
    _msgModel = msgModel;
    self.companyLogo.userInteractionEnabled = YES;
    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:msgModel.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    self.companyName.text = msgModel.companyName;
    // benCompanyName @"申请与您成为合作企业"
    self.extraMsg.text = [NSString stringWithFormat:@"申请与%@成为合作企业", msgModel.benCompanyName];
    
    // 申请状态（0.未处理、1.拒绝、2.忽略、3.同意、4.拉黑）
    NSInteger type = [msgModel.applyStatus integerValue];
    switch (type) {
        case 0:
            [self.applyTypeBtn setTitle:@"同意" forState:UIControlStateNormal];
            [self.applyTypeBtn setBackgroundColor:kMainThemeColor];
            self.applyTypeBtn.userInteractionEnabled = YES;
            break;
        case 1:
            [self.applyTypeBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
            [self.applyTypeBtn setBackgroundColor:kCOLOR(191)];
            self.applyTypeBtn.userInteractionEnabled = NO;
            break;
        case 2:
            [self.applyTypeBtn setTitle:@"已忽略" forState:UIControlStateNormal];
            [self.applyTypeBtn setBackgroundColor:kCOLOR(191)];
            self.applyTypeBtn.userInteractionEnabled = NO;
            break;
        case 3:
            [self.applyTypeBtn setTitle:@"已同意" forState:UIControlStateNormal];
            [self.applyTypeBtn setBackgroundColor:kCOLOR(191)];
            self.applyTypeBtn.userInteractionEnabled = NO;
            break;
        case 4:
            [self.applyTypeBtn setTitle:@"已拉黑" forState:UIControlStateNormal];
            [self.applyTypeBtn setBackgroundColor:kCOLOR(191)];
            self.applyTypeBtn.userInteractionEnabled = NO;
            break;
        default:
            break;
    }
}

//- (void)setDetailMsgModel:(ZCHCooperateListModel *)detailMsgModel {
//    
//    _detailMsgModel = detailMsgModel;
//    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:detailMsgModel.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
//    self.companyName.text = detailMsgModel.companyName;
//    self.extraMsg.text = [NSString stringWithFormat:@"申请与%@成为合作企业", detailMsgModel.benCompanyName];
//    
//    self.applyTypeBtn.hidden = YES;
//}

- (void)setApplyMsgModel:(UnionInviteMessageModel *)applyMsgModel {
    
    _applyMsgModel = applyMsgModel;
    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:applyMsgModel.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    self.companyName.text = applyMsgModel.companyName;
    self.extraMsg.text = [NSString stringWithFormat:@"申请加入%@", applyMsgModel.unionName];
    // 状态（0：未处理，1：同意，2：拒绝）
    NSInteger type = [applyMsgModel.applyStatus integerValue];
    switch (type) {
        case 0:
            [self.applyTypeBtn setTitle:@"同意" forState:UIControlStateNormal];
            [self.applyTypeBtn setBackgroundColor:kMainThemeColor];
            self.applyTypeBtn.userInteractionEnabled = YES;
            break;
        case 1:
            [self.applyTypeBtn setTitle:@"已同意" forState:UIControlStateNormal];
            [self.applyTypeBtn setBackgroundColor:kCOLOR(191)];
            self.applyTypeBtn.userInteractionEnabled = NO;
            break;
        case 2:
            [self.applyTypeBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
            [self.applyTypeBtn setBackgroundColor:kCOLOR(191)];
            self.applyTypeBtn.userInteractionEnabled = NO;
            break;
        default:
            break;
    }
}

- (void)setUnionMsgModel:(UnionInviteMessageModel *)unionMsgModel {
    
    _unionMsgModel = unionMsgModel;
    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:unionMsgModel.unionLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    self.companyName.text = unionMsgModel.unionName;
    self.extraMsg.text = [NSString stringWithFormat:@"邀请%@加入该联盟", unionMsgModel.companyName];
    // 状态（0：未处理，1：同意，2：拒绝）
    NSInteger type = [unionMsgModel.invitationStatus integerValue];
    switch (type) {
        case 0:
            [self.applyTypeBtn setTitle:@"同意" forState:UIControlStateNormal];
            [self.applyTypeBtn setBackgroundColor:kMainThemeColor];
            self.applyTypeBtn.userInteractionEnabled = YES;
            break;
        case 1:
            [self.applyTypeBtn setTitle:@"已同意" forState:UIControlStateNormal];
            [self.applyTypeBtn setBackgroundColor:kCOLOR(191)];
            self.applyTypeBtn.userInteractionEnabled = NO;
            break;
        case 2:
            [self.applyTypeBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
            [self.applyTypeBtn setBackgroundColor:kCOLOR(191)];
            self.applyTypeBtn.userInteractionEnabled = NO;
            break;
        default:
            break;
    }
    //    [self.applyTypeBtn setTitle:@"同意" forState:UIControlStateNormal];
    //    // kCustomColor(234, 104, 72)
    //    [self.applyTypeBtn setBackgroundColor:kMainThemeColor];
}


- (IBAction)didClickApplyBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickApplyBtnWithIndexPath:)]) {
        
        [self.delegate didClickApplyBtnWithIndexPath:self.indexPath];
    }
}

- (void)didClickCompanyIcon:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(didClickCompanyLogoIndexPath:)]) {
        
        [self.delegate didClickCompanyLogoIndexPath:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
