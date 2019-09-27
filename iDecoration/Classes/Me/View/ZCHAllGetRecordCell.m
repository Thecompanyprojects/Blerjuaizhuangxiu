//
//  ZCHAllGetRecordCell.m
//  iDecoration
//
//  Created by 赵春浩 on 2018/1/3.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ZCHAllGetRecordCell.h"

@interface ZCHAllGetRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *labelGiftName;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *getTimeLabel;


@end

@implementation ZCHAllGetRecordCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setModel:(ZCHCouponGettingRecordModel *)model {
    
    _model = model;
    self.numberLabel.text = [NSString stringWithFormat:@"兑换码：%@", model.receiveCode];
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@", model.customerName];
    self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@", model.phone];
    self.couponNameLabel.text = [NSString stringWithFormat:@"促销券名称：%@", model.couponName];
    if (![model.type isEqualToString:@"2"]) {
        self.couponTypeLabel.text = [NSString stringWithFormat:@"促销券类型：%@", @"代金券"];
        self.labelGiftNameHeight.constant = 0;
    } else {
        self.couponTypeLabel.text = [NSString stringWithFormat:@"促销券类型：%@", @"礼品券"];
        self.labelGiftName.text = [NSString stringWithFormat:@"礼品名称：%@",model.giftName];
        self.labelGiftNameHeight.constant = 30;
    }
    self.getTimeLabel.text = [NSString stringWithFormat:@"领取时间：%@", [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.receiveTime]];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
