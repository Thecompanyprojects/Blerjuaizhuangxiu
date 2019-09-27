//
//  MyCompanyMidCell.m
//  iDecoration
//
//  Created by Apple on 2017/5/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "MyCompanyMidCell.h"
#import "SubsidiaryModel.h"
#import "JoinCompanyModel.h"

@implementation MyCompanyMidCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger m = indexPath.section;
    NSInteger n = indexPath.row;
    NSString *TextFieldCellID = [NSString stringWithFormat:@"MyCompanyMidCell%ld%ld",(long)m,(long)n];
    MyCompanyMidCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[MyCompanyMidCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    cell.path = indexPath;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self leftImg];
        [self selectBtn];
        [self contentL];
        
        [self rightRow];
        [self lineV];
//        [self addSubview:self.companySign];
        [self companySign];
        [self deleteBtn];
        
//        [self addSubview:self.textF];
        [self textF];
        
        self.companySign.hidden = YES;
        self.deleteBtn.hidden = YES;
        self.textF.hidden = YES;
        self.selectBtn.hidden = YES;
        //        self.backgroundColor = COLOR_BLACK_CLASS_0;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configWith:(id)data{
    if ([data isKindOfClass:[SubsidiaryModel class]]) {
        SubsidiaryModel *model = data;
//        [self.leftImg sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"photo"]] placeholderImage:[UIImage imageNamed:@"carousel"]];
//        self.companyName.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
//                NSString *casee = [dict objectForKey:@"caseTotla"];
//                if (!casee||[casee isKindOfClass:[NSNull class]]) {
//                    casee = @"";
//                }
//        
//                NSString *address = [dict objectForKey:@"constructionTotal"];
//                if (!address|[address isKindOfClass:[NSNull class]]) {
//                    address = @"";
//                }
        self.contentL.text = model.companyName;
        //        NSString *coment = [dict objectForKey:@"praiseTotal"];
        //        if (!coment||[coment isKindOfClass:[NSNull class]]) {
        //            coment = @"";
        //        }
        //        self.caseNumL.text =  [NSString stringWithFormat:@"%@",casee];
        //        self.addressNumL.text = [NSString stringWithFormat:@"%@",address];
        //        self.commentNumL.text = [NSString stringWithFormat:@"%@",coment];
        
    }
    
    if ([data isKindOfClass:[JoinCompanyModel class]]){
        JoinCompanyModel *model = data;
        self.contentL.text = model.companyName;
//        [self.contentL sizeToFit];
        [self.contentL mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(0);
            make.left.equalTo(self.leftImg.mas_right).equalTo(15);
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH-self.leftImg.right-15-28, 50));
        }];
    }
}

-(UIImageView *)leftImg{
    if (!_leftImg) {
        _leftImg = [[UIImageView alloc]init];
        //        _photoImg.backgroundColor = [UIColor redColor];
        _leftImg.image = [UIImage imageNamed:DefaultIcon];
        [self.contentView addSubview:_leftImg];
        [_leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.centerY.equalTo(0);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
    }
    return _leftImg;
}

-(UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(self.leftImg.right-15, 30/2, 30, 30);
//        [_selectBtn setTitle:@"删除" forState:UIControlStateNormal];
//        _selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        [_deleteBtn setTitleColor:White_Color forState:UIControlStateNormal];
//        _deleteBtn.titleLabel.font = NB_FONTSEIZ_NOR;
//        //        _deleteBtn.layer.cornerRadius = 5;
//        //        _deleteBtn.layer.masksToBounds = YES;
//        _deleteBtn.backgroundColor = Red_Color;
        [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"meixuanzhong"] forState:UIControlStateNormal];
        [self.contentView addSubview:_selectBtn];
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(self.leftImg.mas_right).equalTo(-15);
            make.size.equalTo(CGSizeMake(30, 30));
        }];
    }
    return _selectBtn;
}

-(UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel alloc]initWithFrame:CGRectMake(self.leftImg.right+15, 0, kSCREEN_WIDTH-self.leftImg.right-15-28, 50)];
        _contentL.textColor = Black_Color;
        _contentL.font = [UIFont systemFontOfSize:16];
        _contentL.textAlignment = NSTextAlignmentLeft;
        _contentL.text = @"";
        _contentL.numberOfLines = 0;
        
        [self.contentView addSubview:_contentL];
        [_contentL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftImg.mas_right).equalTo(15);
//            make.centerY.equalTo(0);
//            make.width.mas_equalTo(kSCREEN_WIDTH-self.leftImg.right-15-28);
            make.right.mas_equalTo(self.deleteBtn.mas_left).equalTo(-5);
            make.height.greaterThanOrEqualTo(20);
            make.top.equalTo(20);
            make.bottom.equalTo(-20);
        }];
    }
    return _contentL;
}

-(UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc]initWithFrame:CGRectMake(self.leftImg.right+15, 0, kSCREEN_WIDTH-self.leftImg.right-15-28, 50)];
        _textF.textColor = Black_Color;
        _textF.font = [UIFont systemFontOfSize:16];;
        _textF.textAlignment = NSTextAlignmentLeft;
        _textF.text = @"";
        
        [self.contentView addSubview:_textF];
        [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(140);
            make.right.equalTo(self.deleteBtn.mas_left).equalTo(-5);
        }];
    }
    return _textF;
}


-(UIImageView *)rightRow{
    if (!_rightRow) {
        _rightRow = [[UIImageView alloc]init];
        //        _photoImg.backgroundColor = [UIColor redColor];
        _rightRow.image = [UIImage imageNamed:@"common_arrow_btn"];
        [self.contentView addSubview:_rightRow];
        [_rightRow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.centerY.equalTo(0);
            make.size.equalTo(CGSizeMake(8, 15));
        }];
    }
    return _rightRow;
}

-(UILabel *)companySign{
    if (!_companySign) {
        _companySign = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, kSCREEN_WIDTH-10-100, 50)];
        _companySign.textColor = COLOR_BLACK_CLASS_3;
        _companySign.font = [UIFont systemFontOfSize
                            :16];
        //        companyJob.backgroundColor = Red_Color;
        _companySign.textAlignment = NSTextAlignmentRight;
        
        
        [self.contentView addSubview:_companySign];
        [_companySign mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(-20);
        }];
    }
    return _companySign;
}

-(UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]init];
        _lineV.backgroundColor = COLOR_BLACK_CLASS_0;
        [self.contentView addSubview:_lineV];
        [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentL);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.equalTo(0.5);
        }];
    }
    return  _lineV;
}

-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(kSCREEN_WIDTH-50, 0, 50, 50);
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_deleteBtn setTitleColor:White_Color forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        //        _deleteBtn.layer.cornerRadius = 5;
        //        _deleteBtn.layer.masksToBounds = YES;
        _deleteBtn.backgroundColor = Red_Color;
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //                [_addressBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
        [self.contentView addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(0);
            make.width.equalTo(50);
        }];
    }
    return _deleteBtn;
}

-(void)selectBtnClick{
    if ([self.delegate respondsToSelector:@selector(selectCompanyWith:)]) {
        [self.delegate selectCompanyWith:self.path];
    }
}

-(void)deleteBtnClick{
    if ([self.delegate respondsToSelector:@selector(deleteCompanyWith:)]) {
        [self.delegate deleteCompanyWith:self.path];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
