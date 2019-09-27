//
//  ShopTitleTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 2017/4/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ShopTitleTableViewCell.h"
#import "SubsidiaryModel.h"

@interface ShopTitleTableViewCell()

@end

@implementation ShopTitleTableViewCell
// 只有总经理和经理可以点进去其他人点击没反应

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.dailyMoreLabel.backgroundColor = kMainThemeColor;
    self.yellowMoreLabel.backgroundColor = kMainThemeColor;
    self.calculateMoreLabel.backgroundColor = kMainThemeColor;
    self.onLineMoreLabel.backgroundColor = kMainThemeColor;
    self.scrollViewContentWidthCon.constant = kSCREEN_WIDTH * 2;
    [self.contentView addSubview:self.companyIdlab];
    self.companyIdlab.frame = CGRectMake(kSCREEN_WIDTH-120, 74, 100, 20);
    
    self.certificateBtn.layer.cornerRadius = 5;
    self.certificateBtn.layer.borderWidth = 1;
    self.certificateBtn.layer.borderColor = kCustomColor(242, 168, 113).CGColor;
    [self.certificateBtn setTitleColor:kCustomColor(242, 168, 113) forState:UIControlStateNormal];
}

-(UILabel *)companyIdlab
{
    if(!_companyIdlab)
    {
        _companyIdlab = [[UILabel alloc] init];
        _companyIdlab.font = [UIFont systemFontOfSize:12];
        _companyIdlab.textAlignment = NSTextAlignmentRight;
    }
    return _companyIdlab;
}

// 企业网会员按钮响应
- (IBAction)yellowBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goOpenVipVC)]) {
        [self.delegate goOpenVipVC];
    }
}

// 云管理会员按钮响应
- (IBAction)dailyBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goVipDetailVC)]) {
        [self.delegate goVipDetailVC];
    }
}
// 计算器模板会员按钮响应
- (IBAction)calculateBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goCalculateVipVC)]) {
        [self.delegate goCalculateVipVC];
    }
}


- (IBAction)questionAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(raiseTheRankAction)]) {
        [self.delegate raiseTheRankAction];
    }
}

- (IBAction)onLineAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goOnLineVIPVC)]) {
        [self.delegate goOnLineVIPVC];
    }
}

- (IBAction)certificateBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoCertificateAction)]) {
        [self.delegate gotoCertificateAction];
    }
}



- (void)configData:(id)data {
    
    if ([data isKindOfClass:[SubsidiaryModel class]]) {
        SubsidiaryModel *model = data;
        [self.shopLogoImageView sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
        self.titleLabel.text = model.companyName;
//        self.areaLabel.text = [NSString stringWithFormat:@"%@ %@",model.companyAddress,model.detailedAddress];
        model.detailedAddress = [model.detailedAddress ew_removeSpacesAndLineBreaks];
        model.detailedAddress = [model.detailedAddress ew_removeSpaces];
        self.areaLabel.text = [NSString stringWithFormat:@"%@", model.detailedAddress];
        
//        NSDate *nowDate = [NSDate date];
//        NSString *nowStr = [self date2Str:nowDate format:@"YYYY-MM-dd HH:mm:ss"];
        
        
        // 是否为总经理和经理
        if ([self.jobId integerValue] == 1002 || [self.jobId integerValue] == 1003) {
            self.yellowButton.enabled = YES;
            self.dailyButton.enabled = YES;
            self.calculateButton.enabled = YES;
        } else {
            self.yellowButton.enabled = NO;
            self.dailyButton.enabled = NO;
            self.calculateButton.enabled = NO;
        }
        

        
        if ([model.appVip isEqualToString:@"1"]) {
            
            //企业网会员未过期 vip
            self.yellowImageView.image = [UIImage imageNamed:@"hunyuan1"];
            // 到期
            NSDate *date = [self dateFromString:model.appVipEndTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateStr = [self date2Str:date format:@"yyyy-MM-dd"];
            self.yellowTimeLabel.text = [NSString stringWithFormat:@"%@到期", dateStr];
            
        } else {// Vip_gray
            if (model.appVipEndTime.length > 0) {
                // 过期
                self.yellowTimeLabel.text = @"已到期";
                self.yellowImageView.image = [UIImage imageNamed:@"hunyuan"];
            } else {
                //未开通企业网会员
                self.yellowTimeLabel.text = @"未开通";
                self.yellowImageView.image = [UIImage imageNamed:@"hunyuan"];
            }
        }


        
        if (model.svip) {//9800
            //是云管理会员
            //云管理会员未过期 viprz
            self.dailyImageView.image = [UIImage imageNamed:@"duanxin"];
//            NSDate *date = [self dateFromString:model.vipEndTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSString *dateStr = [self date2Str:date format:@"yyyy-MM-dd"];
            NSDate *date = [self dateFromString:model.svipEnd withFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateStr = [self date2Str:date format:@"yyyy-MM-dd"];
            self.dailyTimeLabel.text = [NSString stringWithFormat:@"%@到期", dateStr];
        } else {
            if (model.vipEndTime.length > 0) {// viprz_gray
                // 云管理会员过期
                self.dailyImageView.image = [UIImage imageNamed:@"duanxin1"];
                self.dailyTimeLabel.text = @"已到期";
            } else {
                //未开通云管理会员
                self.dailyImageView.image= [UIImage imageNamed:@"duanxin1"];
                self.dailyTimeLabel.text = @"未开通";
            }
        }

        //短信通知
        if ([model.smsVip isEqualToString:@"1"]) {
            //是云管理会员 calculate_vip
            self.calculateImageView.image = [UIImage imageNamed:@"note1"];
//            NSDate *date = [self dateFromString:model.smsEnd withFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSString *dateStr = [self date2Str:date format:@"yyyy-MM-dd"];
            NSDate *date = [self dateFromString:model.smsEnd withFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateStr = [self date2Str:date format:@"yyyy-MM-dd"];
            self.calculateTimeLabel.text = [NSString stringWithFormat:@"%@到期", dateStr];
        } else {
            if (model.smsEnd.length > 0) {
                // 云管理会员过期 calculate_vip_gray
                self.calculateImageView.image = [UIImage imageNamed:@"note"];
                self.calculateTimeLabel.text = @"已到期";
            } else {
                //未开通云管理会员
                self.calculateImageView.image = [UIImage imageNamed:@"note"];
                self.calculateTimeLabel.text = @"未开通";
            }
        }
        
        if ([model.recommendVip isEqualToString:@"1"]) {
            // 是成长计划会员
            self.onLineImageView.image = [UIImage imageNamed:@"onLineVip"];
            NSDate *date = [self dateFromString:model.recommendVipEndTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateStr = [self date2Str:date format:@"yyyy-MM-dd"];
            self.onLineTimeLabel.text = [NSString stringWithFormat:@"%@到期", dateStr];
        } else {
            if (model.recommendVipEndTime.length > 0) {
                // 云管理会员过期 calculate_vip_gray
                self.onLineImageView.image = [UIImage imageNamed:@"onLineVip_gray"];
                self.onLineTimeLabel.text = @"已到期";
            } else {
                //未开通云管理会员
                self.onLineImageView.image = [UIImage imageNamed:@"onLineVip_gray"];
                self.onLineTimeLabel.text = @"未开通";
            }
        }
        
        
    }
}

// 比较日期前后
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02 formatter:(NSString *)formatter{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //    [df setDateFormat:@"YYYY-MM-dd HH:mm"];
    [df setDateFormat:formatter];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

//NSDate转NSString
- (NSString *)date2Str:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
    formattor.dateFormat = format;
    NSTimeZone* GTMzone = [NSTimeZone localTimeZone];
    [formattor setTimeZone:GTMzone];
    return [formattor stringFromDate:date];
}
// 字符串转NSDate
- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    NSDate *date = [formatter dateFromString:string];
    return date;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
