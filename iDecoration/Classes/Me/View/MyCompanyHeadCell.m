//
//  MyCompanyHeadCell.m
//  iDecoration
//
//  Created by Apple on 2017/5/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "MyCompanyHeadCell.h"
#import "SearchUnionModel.h"

@interface MyCompanyHeadCell ()




@end

@implementation MyCompanyHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *TextFieldCellID = @"MyCompanyHeadCell";
    MyCompanyHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[MyCompanyHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self addSubview:self.topV];
//        [self addSubview:self.photoImg];
        [self photoImg];
        [self companyName];
        [self sloganL];
        [self editBtn];
//        self.backgroundColor = COLOR_BLACK_CLASS_0;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configWith:(id)data{
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = data;
        [self.photoImg sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"companyLogo"]] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
        self.companyName.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"companyName"]];
        NSString *str = [dict objectForKey:@"companySlogan"];
        if (!str||str.length<=0) {
            str = @"";
        }
        self.sloganL.text = str;
//        NSString *casee = [dict objectForKey:@"caseTotla"];
//        if (!casee||[casee isKindOfClass:[NSNull class]]) {
//            casee = @"";
//        }
//        
//        NSString *address = [dict objectForKey:@"constructionTotal"];
//        if (!address|[address isKindOfClass:[NSNull class]]) {
//            address = @"";
//        }
//        
//        NSString *coment = [dict objectForKey:@"praiseTotal"];
//        if (!coment||[coment isKindOfClass:[NSNull class]]) {
//            coment = @"";
//        }
//        self.caseNumL.text =  [NSString stringWithFormat:@"%@",casee];
//        self.addressNumL.text = [NSString stringWithFormat:@"%@",address];
//        self.commentNumL.text = [NSString stringWithFormat:@"%@",coment];
    }
    if ([data isKindOfClass:[SearchUnionModel class]]) {
        SearchUnionModel *model = data;
        [self.photoImg sd_setImageWithURL:[NSURL URLWithString:model.unionLogo] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        self.companyName.text = [NSString stringWithFormat:@"%@",model.unionName];
        self.sloganL.text = model.unionNumber;
        
    }
}

-(UIImageView *)photoImg{
    if (!_photoImg) {
        _photoImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 110-10*2, 110-10*2)];
        //        _photoImg.backgroundColor = [UIColor redColor];
        _photoImg.image = [UIImage imageNamed:@"defaultCompanyLogo"];
        [self.contentView addSubview:_photoImg];
        [_photoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(60, 60));
            make.top.equalTo(10);
            make.left.equalTo(10);
            make.bottom.equalTo(-10);
        }];
        _photoImg.contentMode = UIViewContentModeScaleAspectFill;
        _photoImg.layer.masksToBounds = YES;
    }
    return _photoImg;
}

-(UILabel *)companyName{
    if (!_companyName) {
        _companyName = [[UILabel alloc]initWithFrame:CGRectMake(self.photoImg.right+10, self.photoImg.top, kSCREEN_WIDTH-self.photoImg.right-10-40, 30)];
        _companyName.textColor = Black_Color;
        _companyName.font = [UIFont systemFontOfSize:20];
        _companyName.textAlignment = NSTextAlignmentLeft;
        _companyName.text = @"";
        [self.contentView addSubview:_companyName];
        [_companyName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.photoImg.mas_right).equalTo(10);
            make.top.equalTo(self.photoImg);
//            make.centerY.equalTo(self.photoImg);
            make.width.equalTo(kSCREEN_WIDTH-self.photoImg.right-10-40);
            make.height.equalTo(30);
        }];
    }
    return _companyName;
}


-(UILabel *)sloganL{
    if (!_sloganL) {
//        _sloganL = [[UILabel alloc]initWithFrame:CGRectMake(self.photoImg.right+10, self.companyName.bottom+10, kSCREEN_WIDTH-self.photoImg.right-10, 20)];
        _sloganL = [[UILabel alloc] init];
        _sloganL.textColor = Black_Color;
        _sloganL.font = [UIFont systemFontOfSize:15];
        _sloganL.textColor = [UIColor darkGrayColor];
        _sloganL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_sloganL];
        [_sloganL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.photoImg.mas_right).equalTo(10);
            make.top.mas_equalTo(self.companyName.mas_bottom).mas_equalTo(5);
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(self.photoImg);
        }];
        _sloganL.numberOfLines = 0;
//        _sloganL.text = @"案例:";
    }
    return _sloganL;
}

-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.frame = CGRectMake(self.companyName.right, 20, 40, 40);
//        [_editBtn setTitle:@"请仔细填写至区县" forState:UIControlStateNormal];
//        _editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [_editBtn setTitleColor:COLOR_BLACK_CLASS_9 forState:UIControlStateNormal];
//        _addressBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        //            _addressBtn.backgroundColor = Red_Color;
        [_editBtn setImage:[UIImage imageNamed:@"bianji-0"] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_editBtn];
        [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.companyName);
            make.left.mas_equalTo(self.companyName.right);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    return _editBtn;
}

-(void)editBtnClick{
    if ([self.delegate respondsToSelector:@selector(editCompanyInfoOrDeleteCompany)]) {
        [self.delegate editCompanyInfoOrDeleteCompany];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
