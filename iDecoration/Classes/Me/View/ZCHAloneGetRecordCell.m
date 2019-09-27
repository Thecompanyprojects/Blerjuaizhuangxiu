//
//  ZCHAloneGetRecordCell.m
//  iDecoration
//
//  Created by 赵春浩 on 2018/1/3.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ZCHAloneGetRecordCell.h"

@interface ZCHAloneGetRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *labelGiftName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelGiftNameHeight;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *getTimeLabel;


@end

@implementation ZCHAloneGetRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(ZCHCouponGettingRecordModel *)model {
    _model = model;
    self.numberLabel.text = [NSString stringWithFormat:@"编号：%@", model.couponNo];
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@", model.customerName];
    self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@", model.phone];
    self.getTimeLabel.text = [NSString stringWithFormat:@"领取时间：%@", [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.receiveTime]];
    self.labelGiftName.text = [NSString stringWithFormat:@"礼品名称：%@", model.giftName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
