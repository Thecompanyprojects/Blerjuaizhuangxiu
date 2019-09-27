//
//  ZCHShopperManageCell.m
//  iDecoration
//
//  Created by 赵春浩 on 17/5/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHShopperManageCell.h"
#import "ZCHShopperManageModel.h"

@interface ZCHShopperManageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hadExpiredLabel;
@property (weak, nonatomic) IBOutlet UIButton *continuePayBtn;

@end

@implementation ZCHShopperManageCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.continuePayBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.continuePayBtn.layer.borderWidth = 1;
    self.continuePayBtn.layer.cornerRadius = 3;
    self.continuePayBtn.layer.masksToBounds = YES;
}



- (void)setModel:(ZCHShopperManageModel *)model {
    
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.merchantLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    self.nameLabel.text = model.merchantName;
    self.typeLabel.text = model.typeName;
    self.timeLabel.text = [self timeWithTimeIntervalString:model.endTime];
    
    // 会员结束天数（天数>=0时禁止删除）
    if ([model.times integerValue] >= 5) {
        
        self.hadExpiredLabel.hidden = YES;
    } else if ([model.times integerValue] >= 0 && [model.times integerValue] <= 5) {
        
        self.hadExpiredLabel.hidden = NO;
        self.hadExpiredLabel.text = @"即将过期";
    } else {
        
        self.hadExpiredLabel.hidden = NO;
        self.hadExpiredLabel.text = @"已过期";
    }
}

- (IBAction)didClickContinuePayBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickContinueBtn:andIndexPath:)]) {
        
        [self.delegate didClickContinueBtn:sender andIndexPath:self.indexPath];
    }
}


- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    // 毫秒值转化为秒
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
