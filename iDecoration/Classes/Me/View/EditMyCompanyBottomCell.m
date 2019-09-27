//
//  EditMyCompanyBottomCell.m
//  iDecoration
//
//  Created by Apple on 2017/5/24.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "EditMyCompanyBottomCell.h"

@interface EditMyCompanyBottomCell ()<UITextViewDelegate>

@end

@implementation EditMyCompanyBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *TextFieldCellID = @"EditMyCompanyBottomCell";
    EditMyCompanyBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[EditMyCompanyBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        [self addSubview:self.topV];
//        [self addSubview:self.headV];
        [self headV];
        [self.headV addSubview:self.companySlognL];
//        [self addSubview:self.companySlognV];
        [self companySlognV];
        
        
        //        self.backgroundColor = COLOR_BLACK_CLASS_0;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(UIView *)headV{
    if (!_headV) {
        _headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
        _headV.backgroundColor = COLOR_BLACK_CLASS_0;
        [self.contentView addSubview:_headV];
        [_headV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(0);
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH, 44));
        }];
    }
    return _headV;
}

-(UILabel *)companySlognL{
    if (!_companySlognL) {
        _companySlognL = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, self.headV.height)];
        _companySlognL.textColor = COLOR_BLACK_CLASS_3;
        _companySlognL.font = [UIFont systemFontOfSize
                         :14];
        //        companyJob.backgroundColor = Red_Color;
        _companySlognL.textAlignment = NSTextAlignmentLeft;
        _companySlognL.text = @"公司标语";
    }
    return _companySlognL;
}

-(UITextView *)companySlognV{
    if (!_companySlognV) {
        _companySlognV = [[UITextView alloc]initWithFrame:CGRectMake(15, self.headV.bottom+10, kSCREEN_WIDTH-30, 96)];
        _companySlognV.backgroundColor = White_Color;
        _companySlognV.font = NB_FONTSEIZ_NOR;
        [self.contentView addSubview:_companySlognV];
        [_companySlognV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.right.equalTo(-15);
            make.top.equalTo(self.headV.mas_bottom).equalTo(10);
            make.height.equalTo(96);
            make.bottom.equalTo(-10);
        }];
    }
    return _companySlognV;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
