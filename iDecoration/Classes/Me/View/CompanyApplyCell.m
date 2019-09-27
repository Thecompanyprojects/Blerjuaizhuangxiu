//
//  CompanyApplyCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/6/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CompanyApplyCell.h"

@implementation CompanyApplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rightBtnCon.constant = kSize(60);
    
    self.iconIV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTapAction)];
    [self.iconIV addGestureRecognizer:tapGR];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)iconTapAction {
    if (self.iconTapBlock) {
        self.iconTapBlock();
    }
}
- (void)setApplyModel:(CompanyApplyModel *)applyModel {
    self.titleLb.font = [UIFont systemFontOfSize:kSize(16)];
    self.subTitleLb.font = [UIFont systemFontOfSize:kSize(14)];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    NSURL *url = [NSURL URLWithString:applyModel.logo];
    [self.iconIV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"construction"]];
    
    self.rightBtn.enabled = NO;
    [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [self.rightBtn setBackgroundColor:self.rightBtn.enabled ? Main_Color : White_Color];
    
    if (applyModel.day > 10) {
        [self.rightBtn setTitle:@"已过期" forState:UIControlStateDisabled];
    } else {
        switch (applyModel.applyStatus) {
            case 0:
            {
                [self.rightBtn setTitle:@"同意" forState:UIControlStateNormal];
                self.rightBtn.backgroundColor = Main_Color;
                [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.rightBtn.layer.cornerRadius = 6;
                self.rightBtn.layer.masksToBounds = YES;
                self.rightBtn.enabled = YES;
                NSDate *date = [NSDate date];
                NSTimeInterval  tenDay = 24*60*60*10;  //10天的长度
                //之后的天数
                NSDate *theDate = [date initWithTimeIntervalSinceNow: tenDay];
            }
                break;
            case 1:
            {
                [self.rightBtn setTitle:@"已通过" forState:UIControlStateDisabled];
            }
                break;
            case 2:
                [self.rightBtn setTitle:@"未通过" forState:UIControlStateDisabled];
                break;
            default:
                break;
        }
        
        
    }
    
    NSString *titleStr = [NSString stringWithFormat:@"%@-----%@", applyModel.agencysName, applyModel.jobName];
    self.titleLb.text = titleStr;
    
    NSString *subTitleStr = [NSString stringWithFormat:@"%@申请加入\"%@\"公司", applyModel.applyName, applyModel.companyName];
    self.subTitleLb.text = subTitleStr;
}
@end
