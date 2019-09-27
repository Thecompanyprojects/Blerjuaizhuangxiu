//
//  SiteInfoTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 17/3/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SiteInfoTableViewCell.h"
#import "SiteModel.h"

@implementation SiteInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *TextFieldCellID = @"SiteInfoTableViewCell";
    SiteInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[SiteInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
//    cell.path = path;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.houseHoldName];
        [self addSubview:self.modifyBtn];
        
        [self addSubview:self.leftNumberName];
        [self addSubview:self.numberName];
        [self addSubview:self.locationName];
        [self addSubview:self.siteAddress];
        [self addSubview:self.shareTitle];
        [self addSubview:self.shareRightTitle];
        [self addSubview:self.constructCompany];
        [self addSubview:self.signDate];
        //[self addSubview:self.styleLabel];
        [self addSubview:self.area];
        [self addSubview:self.currentNode];
        [self addSubview:self.contractTime];
        
        [self addSubview:self.timeWarning];

        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}




-(void)configWith:(id)data{
    if ([data isKindOfClass:[SiteModel class]]) {
        SiteModel *siteModel = data;
        
        
        self.houseHoldName.text = [NSString stringWithFormat:@"户        主：%@",siteModel.ccHouseholderName];

        self.leftNumberName.text = @"工单编号：";
        self.numberName.text = [NSString stringWithFormat:@"%@",siteModel.constructionNo];
        self.locationName.text = [NSString stringWithFormat:@"小区名称：%@",siteModel.ccAreaName];
        self.siteAddress.text = [NSString stringWithFormat:@"施工地址：%@",siteModel.ccAddress];
        self.shareTitle.text = @"分享标题: ";
        self.shareRightTitle.text = [NSString stringWithFormat:@"%@",siteModel.ccShareTitle.length>0 ? siteModel.ccShareTitle : @""];
        
        self.constructCompany.text = [NSString stringWithFormat:@"施工单位：%@",siteModel.ccBuilder];
        
        NSString *signDate = siteModel.ccCreateDate;
        if (!signDate||signDate.length<=0) {
            signDate = @"";
        }
        else{
            signDate = [self timeWithTimeIntervalString:signDate];
        }
        self.signDate.text = [NSString stringWithFormat:@"签约日期：%@",signDate];
        
        self.styleLabel.text = [NSString stringWithFormat:@"装修风格：%@",siteModel.style];
        self.area.text = [NSString stringWithFormat:@"房屋面积：%@",siteModel.ccAcreage];
        NSInteger tag = [siteModel.ccConstructionNodeId integerValue];
        if (tag == 2000) {
            self.currentNode.text = @"当前节点：新日志";
        }else{
            self.currentNode.text = [NSString stringWithFormat:@"当前节点：%@",siteModel.crRoleName.length>0 ? siteModel.crRoleName : @""];
        }
        NSInteger syDataInt = [siteModel.syDate integerValue];
        if (syDataInt<0) {
            siteModel.syDate = @"0";
        }
        
        NSString *tempStrOne = @"工期预警：施工第";
        NSString *tempStrTwo = siteModel.yksDate;
        NSString *tempStrThree = @"天，";
        
        NSString *tempStrFour = @"距离完工还有";
        NSString *tempStrFive = siteModel.syDate;
        NSString *tempStrSix = @"天";
        
        NSMutableAttributedString *tempAttrStringOne = [[NSMutableAttributedString alloc] initWithString:tempStrOne attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_3} ];
        
        NSMutableAttributedString *tempAttrStringTwo = [[NSMutableAttributedString alloc] initWithString:tempStrTwo attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName: Red_Color} ];
        [tempAttrStringOne appendAttributedString:tempAttrStringTwo];
        
        NSMutableAttributedString *tempAttrStringThree = [[NSMutableAttributedString alloc] initWithString:tempStrThree attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_3} ];
        [tempAttrStringOne appendAttributedString:tempAttrStringThree];
        
        NSMutableAttributedString *tempAttrStringFour = [[NSMutableAttributedString alloc] initWithString:tempStrFour attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_3} ];
        [tempAttrStringOne appendAttributedString:tempAttrStringFour];
        
        NSMutableAttributedString *tempAttrStringFive = [[NSMutableAttributedString alloc] initWithString:tempStrFive attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName: Red_Color} ];
        [tempAttrStringOne appendAttributedString:tempAttrStringFive];
        
        NSMutableAttributedString *tempAttrStringSix = [[NSMutableAttributedString alloc] initWithString:tempStrSix attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName: COLOR_BLACK_CLASS_3} ];
        [tempAttrStringOne appendAttributedString:tempAttrStringSix];
        
//        self.timeWarning.text = [NSString stringWithFormat:@"工期预警：施工第%@天，距离完工还有%@天",siteModel.yksDate,siteModel.syDate];
        
        if (siteModel.ccComplete==2||siteModel.ccComplete==3) {
            self.timeWarning.text = @"工期预警：已交工";
        }
        else{
            self.timeWarning.attributedText = tempAttrStringOne;
        }
        
        NSString *ccSrartTime = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:siteModel.ccSrartTime];
        NSString *ccCompleteDate = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:siteModel.ccCompleteDate];
        
        self.contractTime.text = [NSString stringWithFormat:@"合同工期：%@ —— %@",ccSrartTime,ccCompleteDate];
        
        
        CGSize size = [self.shareRightTitle sizeThatFits:CGSizeMake(CGRectGetWidth(self.shareRightTitle.frame), CGFLOAT_MAX)];;
        if (size.height<=21) {
            size.height = 21;
        }
        
        self.shareRightTitle.frame = CGRectMake(self.shareTitle.right,self.siteAddress.bottom+8,kSCREEN_WIDTH-self.shareTitle.right-8,21);
//        self.shareTitle.centerY = self.shareRightTitle.centerY;
        
        
        self.constructCompany.frame = CGRectMake(self.houseHoldName.left,self.shareRightTitle.bottom+8,self.houseHoldName.width,self.houseHoldName.height);
        self.signDate.frame = CGRectMake(self.houseHoldName.left,self.constructCompany.bottom+8,self.houseHoldName.width,self.houseHoldName.height);
        //self.styleLabel.frame = CGRectMake(self.houseHoldName.left,self.signDate.bottom+8,self.houseHoldName.width,self.houseHoldName.height);
        self.area.frame = CGRectMake(self.houseHoldName.left,self.signDate.bottom+8,self.houseHoldName.width,self.houseHoldName.height);
        self.currentNode.frame = CGRectMake(self.houseHoldName.left,self.area.bottom+8,self.houseHoldName.width,self.houseHoldName.height);
        self.contractTime.frame = CGRectMake(self.houseHoldName.left,self.currentNode.bottom+8,self.houseHoldName.width,self.houseHoldName.height);
        
        CGSize sizeTwo = [self.timeWarning sizeThatFits:CGSizeMake(CGRectGetWidth(self.timeWarning.frame), CGFLOAT_MAX)];;
        if (sizeTwo.height<=21) {
            sizeTwo.height = 21;
        }
        self.timeWarning.frame = CGRectMake(self.houseHoldName.left,self.contractTime.bottom+8,self.houseHoldName.width,sizeTwo.height);
        
        self.cellH = self.timeWarning.bottom+10;
    }
}

-(void)editClick{
    if ([self.delegate respondsToSelector:@selector(modifyConInfo)]) {
        [self.delegate modifyConInfo];
    }
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


#pragma mark - lazy

-(UILabel *)houseHoldName{
    if (!_houseHoldName) {
        _houseHoldName = [[UILabel alloc]initWithFrame:CGRectMake(8, 20, kSCREEN_WIDTH-16, 21)];
        _houseHoldName.textColor = COLOR_BLACK_CLASS_3;
        _houseHoldName.font = [UIFont systemFontOfSize
                               :16];
//        _houseHoldName.text = @"户       主:";
        //        companyJob.backgroundColor = Red_Color;
        _houseHoldName.textAlignment = NSTextAlignmentLeft;
    }
    return _houseHoldName;
}

-(UIButton *)modifyBtn{
    if (!_modifyBtn) {
        _modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _modifyBtn.frame = CGRectMake(kSCREEN_WIDTH-25-5, self.houseHoldName.top, 25, 25);
        [_modifyBtn setImage:[UIImage imageNamed:@"editDiary"] forState:UIControlStateNormal];
        [_modifyBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modifyBtn;
}

-(UILabel *)leftNumberName{
    if (!_leftNumberName) {
        _leftNumberName = [[UILabel alloc]initWithFrame:CGRectMake(self.houseHoldName.left,self.houseHoldName.bottom+8,85,self.houseHoldName.height)];
        _leftNumberName.textColor = COLOR_BLACK_CLASS_3;
        _leftNumberName.font = [UIFont systemFontOfSize
                            :16];
        //        _locationName.text = @"小区名称:";
        //        companyJob.backgroundColor = Red_Color;
        _leftNumberName.textAlignment = NSTextAlignmentLeft;
    }
    return _leftNumberName;
}

-(UILabel *)numberName{
    if (!_numberName) {
//        _numberName = [[UILabel alloc]initWithFrame:CGRectMake(self.houseHoldName.left,self.houseHoldName.bottom+8,self.houseHoldName.width,self.houseHoldName.height)];
        _numberName = [[copyLabel alloc]initWithFrame:CGRectMake(self.leftNumberName.right,self.houseHoldName.bottom+8,kSCREEN_WIDTH-_leftNumberName.right-8,self.houseHoldName.height)];
        _numberName.textColor = COLOR_BLACK_CLASS_3;
        _numberName.font = [UIFont systemFontOfSize
                              :16];
        //        _locationName.text = @"小区名称:";
        //        companyJob.backgroundColor = Red_Color;
        _numberName.textAlignment = NSTextAlignmentLeft;
    }
    return _numberName;
}

-(UILabel *)locationName{
    if (!_locationName) {
        _locationName = [[UILabel alloc]initWithFrame:CGRectMake(self.houseHoldName.left,self.numberName.bottom+8,self.houseHoldName.width,self.houseHoldName.height)];
        _locationName.textColor = COLOR_BLACK_CLASS_3;
        _locationName.font = [UIFont systemFontOfSize
                               :16];
//        _locationName.text = @"小区名称:";
        //        companyJob.backgroundColor = Red_Color;
        _locationName.textAlignment = NSTextAlignmentLeft;
    }
    return _locationName;
}

-(UILabel *)siteAddress{
    if (!_siteAddress) {
        _siteAddress = [[UILabel alloc]initWithFrame:CGRectMake(self.houseHoldName.left,self.locationName.bottom+8,self.houseHoldName.width,self.houseHoldName.height)];
        _siteAddress.textColor = COLOR_BLACK_CLASS_3;
        _siteAddress.font = [UIFont systemFontOfSize
                              :16];
//        _siteAddress.text = @"施工地址:";
        //        companyJob.backgroundColor = Red_Color;
        _siteAddress.textAlignment = NSTextAlignmentLeft;
    }
    return _siteAddress;
}

-(UILabel *)shareTitle{
    if (!_shareTitle) {
        _shareTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.houseHoldName.left,self.siteAddress.bottom+8,82,21)];
        _shareTitle.textColor = COLOR_BLACK_CLASS_3;
        _shareTitle.font = [UIFont systemFontOfSize
                             :16];
//        _shareTitle.text = @"分享标题: ";
        //        companyJob.backgroundColor = Red_Color;
        _shareTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _shareTitle;
}

-(UILabel *)shareRightTitle{
    if (!_shareRightTitle) {
        _shareRightTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.shareTitle.right,self.shareTitle.top,kSCREEN_WIDTH-self.shareTitle.right-8,self.shareTitle.height)];
        _shareRightTitle.textColor = COLOR_BLACK_CLASS_3;
        _shareRightTitle.font = [UIFont systemFontOfSize
                            :16];
        _shareRightTitle.numberOfLines = 0;
//        _shareRightTitle.text = @"分享标题:";
        //        companyJob.backgroundColor = Red_Color;
        _shareRightTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _shareRightTitle;
}

-(UILabel *)constructCompany{
    if (!_constructCompany) {
        _constructCompany = [[UILabel alloc]initWithFrame:CGRectMake(self.houseHoldName.left,self.shareRightTitle.bottom+8,self.houseHoldName.width,self.houseHoldName.height)];
        _constructCompany.textColor = COLOR_BLACK_CLASS_3;
        _constructCompany.font = [UIFont systemFontOfSize
                             :16];
//        _constructCompany.text = @"施工单位:";
        //        companyJob.backgroundColor = Red_Color;
        _constructCompany.textAlignment = NSTextAlignmentLeft;
    }
    return _constructCompany;
}


-(UILabel *)signDate{
    if (!_signDate) {
        _signDate = [[UILabel alloc]initWithFrame:CGRectMake(self.houseHoldName.left,self.constructCompany.bottom+8,self.houseHoldName.width,self.houseHoldName.height)];
        _signDate.textColor = COLOR_BLACK_CLASS_3;
        _signDate.font = [UIFont systemFontOfSize
                                  :16];
//        _signDate.text = @"签约日期:";
        //        companyJob.backgroundColor = Red_Color;
        _signDate.textAlignment = NSTextAlignmentLeft;
    }
    return _signDate;
}

-(UILabel *)styleLabel{
    if (!_styleLabel) {
        _styleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.houseHoldName.left,self.signDate.bottom+8,self.houseHoldName.width,self.houseHoldName.height)];
        _styleLabel.textColor = COLOR_BLACK_CLASS_3;
        _styleLabel.font = [UIFont systemFontOfSize
                          :16];

        _styleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _styleLabel;
}

-(UILabel *)area{
    if (!_area) {
        _area = [[UILabel alloc]initWithFrame:CGRectMake(self.houseHoldName.left,self.styleLabel.bottom+8,self.houseHoldName.width,self.houseHoldName.height)];
        _area.textColor = COLOR_BLACK_CLASS_3;
        _area.font = [UIFont systemFontOfSize
                            :16];

        _area.textAlignment = NSTextAlignmentLeft;
    }
    return _area;
}

-(UILabel *)currentNode{
    if (!_currentNode) {
        _currentNode = [[UILabel alloc]initWithFrame:CGRectMake(self.houseHoldName.left,self.area.bottom+8,self.houseHoldName.width,self.houseHoldName.height)];
        _currentNode.textColor = COLOR_BLACK_CLASS_3;
        _currentNode.font = [UIFont systemFontOfSize
                      :16];
//        _currentNode.text = @"当前节点:";
        //        companyJob.backgroundColor = Red_Color;
        _currentNode.textAlignment = NSTextAlignmentLeft;
    }
    return _currentNode;
}

-(UILabel *)contractTime{
    if (!_contractTime) {
        _contractTime = [[UILabel alloc]initWithFrame:CGRectMake(self.houseHoldName.left,self.currentNode.bottom+8,self.houseHoldName.width,self.houseHoldName.height)];
        _contractTime.textColor = COLOR_BLACK_CLASS_3;
        _contractTime.font = [UIFont systemFontOfSize
                             :16];
//        _contractTime.text = @"合同工期:";
        //        companyJob.backgroundColor = Red_Color;
        _contractTime.textAlignment = NSTextAlignmentLeft;
    }
    return _contractTime;
}

-(UILabel *)timeWarning{
    if (!_timeWarning) {
        _timeWarning = [[UILabel alloc]initWithFrame:CGRectMake(self.houseHoldName.left,self.contractTime.bottom+8,self.houseHoldName.width,self.houseHoldName.height)];
        _timeWarning.textColor = COLOR_BLACK_CLASS_3;
        _timeWarning.font = [UIFont systemFontOfSize
                              :16];
        _timeWarning.numberOfLines = 0;
//        _timeWarning.text = @"工期预警:";
        //        companyJob.backgroundColor = Red_Color;
        _timeWarning.textAlignment = NSTextAlignmentLeft;
    }
    return _timeWarning;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
