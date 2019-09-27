//
//  CommonHeadCell.m
//  iDecoration
//
//  Created by Apple on 2017/5/4.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CommonHeadCell.h"

@interface CommonHeadCell ()
@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UIImageView *photoImg;
@property (nonatomic, strong) UILabel *companyName;
@property (nonatomic, strong) UILabel *commentNum;
@property (nonatomic, strong) UILabel *commentNumL;
@property (nonatomic, strong) UILabel *caseNum;
@property (nonatomic, strong) UILabel *caseNumL;
@property (nonatomic, strong) UILabel *addressNum;
@property (nonatomic, strong) UILabel *addressNumL;
@end

@implementation CommonHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *TextFieldCellID = @"commonHeadCell";
    CommonHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[CommonHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.topV];
        [self.topV addSubview:self.photoImg];
        [self.topV addSubview:self.companyName];
        [self.topV addSubview:self.caseNum];
        [self.topV addSubview:self.caseNumL];
        [self.topV addSubview:self.addressNum];
        [self.topV addSubview:self.addressNumL];
        [self.topV addSubview:self.commentNum];
        [self.topV addSubview:self.commentNumL];
        self.backgroundColor = kBackgroundColor;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)configWith:(id)data {
    if ([data isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary *dict = data;
        [self.photoImg sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"photo"]] placeholderImage:[UIImage imageNamed:@"carousel"]];
        NSString *name = [dict objectForKey:@"name"];
        if (!name||[name isKindOfClass:[NSNull class]]) {
            name = @"";
        }
        self.companyName.text = [NSString stringWithFormat:@"%@",name];
        NSString *casee = [dict objectForKey:@"caseTotla"];
        if (!casee||[casee isKindOfClass:[NSNull class]]) {
            casee = @"";
        }
        
        NSString *address = [dict objectForKey:@"constructionTotal"];
        if (!address|[address isKindOfClass:[NSNull class]]) {
            address = @"";
        }
        
        NSString *coment = [dict objectForKey:@"praiseTotal"];
        if (!coment||[coment isKindOfClass:[NSNull class]]) {
            coment = @"";
        }
        self.caseNumL.text =  [NSString stringWithFormat:@"%@",casee];
        self.addressNumL.text = [NSString stringWithFormat:@"%@",address];
        self.commentNumL.text = [NSString stringWithFormat:@"%@",coment];
    }
}

- (UIView *)topV {
    if (!_topV) {
        _topV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kSCREEN_WIDTH-20, 120)];
        _topV.backgroundColor = White_Color;
    }
    return _topV;
}

-(UIImageView *)photoImg{
    if (!_photoImg) {
        _photoImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.topV.height-10*2, self.topV.height-10*2)];
        //        _photoImg.backgroundColor = [UIColor redColor];
        _photoImg.image = [UIImage imageNamed:@"carousel"];
    }
    return _photoImg;
}

-(UILabel *)companyName{
    if (!_companyName) {
        _companyName = [[UILabel alloc]initWithFrame:CGRectMake(self.photoImg.right+10, self.photoImg.top, 200, 30)];
        _companyName.textColor = Black_Color;
        _companyName.font = [UIFont systemFontOfSize:20];
        _companyName.textAlignment = NSTextAlignmentLeft;
        _companyName.text = @"";
    }
    return _companyName;
}


-(UILabel *)caseNum{
    if (!_caseNum) {
        _caseNum = [[UILabel alloc]initWithFrame:CGRectMake(self.photoImg.right+10, self.photoImg.bottom-20, 40, 20)];
        _caseNum.textColor = Black_Color;
        _caseNum.font = [UIFont systemFontOfSize:14];
        _caseNum.textAlignment = NSTextAlignmentLeft;
        _caseNum.text = @"案例:";
    }
    return _caseNum;
}

-(UILabel *)caseNumL{
    if (!_caseNumL) {
        _caseNumL = [[UILabel alloc]initWithFrame:CGRectMake(self.commentNum.right+5, self.caseNum.top, 50, 20)];
        _caseNumL.textColor = [UIColor redColor];
        _caseNumL.font = [UIFont systemFontOfSize
                          :14];
        _caseNumL.textAlignment = NSTextAlignmentLeft;
        _caseNumL.text = @"";
    }
    return _caseNumL;
}

-(UILabel *)addressNum{
    if (!_addressNum) {
        _addressNum = [[UILabel alloc]initWithFrame:CGRectMake(self.caseNumL.right, self.caseNumL.top, 40, 20)];
        _addressNum.textColor = Black_Color;
        _addressNum.font = [UIFont systemFontOfSize:14];
        _addressNum.textAlignment = NSTextAlignmentLeft;
        _addressNum.text = @"工地:";
    }
    return _addressNum;
}

-(UILabel *)addressNumL{
    if (!_addressNumL) {
        _addressNumL = [[UILabel alloc]initWithFrame:CGRectMake(self.addressNum.right+5, self.addressNum.top, 50, 20)];
        _addressNumL.textColor = [UIColor redColor];
        _addressNumL.font = [UIFont systemFontOfSize
                             :14];
        _addressNumL.textAlignment = NSTextAlignmentLeft;
        _addressNumL.text = @"";
    }
    return _addressNumL;
}

-(UILabel *)commentNum{
    if (!_commentNum) {
        _commentNum = [[UILabel alloc]initWithFrame:CGRectMake(self.photoImg.right+10, self.caseNum.top-20-10, 40, 20)];
        _commentNum.textColor = Black_Color;
        _commentNum.font = [UIFont systemFontOfSize:14];
        _commentNum.textAlignment = NSTextAlignmentLeft;
        _commentNum.text = @"好评:";
    }
    return _commentNum;
}

-(UILabel *)commentNumL{
    if (!_commentNumL) {
        _commentNumL = [[UILabel alloc]initWithFrame:CGRectMake(self.commentNum.right + 5, self.commentNum.top, 50, 20)];
        _commentNumL.textColor = [UIColor redColor];
        _commentNumL.font = [UIFont systemFontOfSize
                             :14];
        _commentNumL.textAlignment = NSTextAlignmentLeft;
        _commentNumL.text = @"";
    }
    return _commentNumL;
}


@end
