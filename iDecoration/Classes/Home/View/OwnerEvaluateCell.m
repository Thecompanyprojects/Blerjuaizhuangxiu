//
//  OwnerEvaluateCell.m
//  iDecoration
//
//  Created by Apple on 2017/5/3.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "OwnerEvaluateCell.h"
#import "OwnerEvaluateModel.h"

@interface OwnerEvaluateCell ()

@property (nonatomic, strong)UIView *backV;
@property (nonatomic, strong)UIImageView *ownerPhoto;
@property (nonatomic, strong)UILabel *ownerNameL;
@property (nonatomic, strong)UILabel *addressL;
@property (nonatomic, strong)UILabel *evaluateL;
@property (nonatomic, strong)UILabel *contentL;
@property (nonatomic, strong)UIImageView *frontPhoto;
@property (nonatomic, strong)UILabel *shareTitlelL;

@end

@implementation OwnerEvaluateCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *TextFieldCellID = @"OwnerEvaluateCell";
    OwnerEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[OwnerEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.backV];
        [self.backV addSubview:self.ownerPhoto];
        [self.backV addSubview:self.ownerNameL];
        [self.backV addSubview:self.addressL];
        [self.backV addSubview:self.evaluateL];
        [self.backV addSubview:self.contentL];
        [self.backV addSubview:self.frontPhoto];
        [self.backV addSubview:self.shareTitlelL];
        self.backgroundColor = kBackgroundColor;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)configWith:(OwnerEvaluateModel *)model {
    
    [self.ownerPhoto sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:DefaultIcon]];
    self.ownerNameL.text = model.trueName;
    self.addressL.text = model.areaName;
    self.evaluateL.text = model.sumGrade;
    self.contentL.text = model.content;
    if ([model.content isEqualToString:@""]) {
        
        _backV.frame = CGRectMake(10, 10, kSCREEN_WIDTH-20, 140);
        self.contentL.frame = CGRectMake(self.ownerPhoto.left,self.ownerPhoto.bottom+10,self.backV.width-10,10);
        self.frontPhoto.frame = CGRectMake(5,self.contentL.bottom+5, 60,60);
        self.shareTitlelL.frame = CGRectMake(self.frontPhoto.right+10,self.frontPhoto.top+5,self.backV.width-self.frontPhoto.right-10-10,50);
        
        if ([self.delegate respondsToSelector:@selector(getCellHeight:andIndex:)]) {
            
            [self.delegate getCellHeight:155 andIndex:self.indexPath];
        }
    } else {
        
        CGSize size = [model.content boundingRectWithSize:CGSizeMake(self.backV.width-10, MAXFLOAT) withFont:NB_FONTSEIZ_NOR];
        _backV.frame = CGRectMake(10, 10, kSCREEN_WIDTH-20, 140 + size.height);
        self.contentL.frame = CGRectMake(self.ownerPhoto.left,self.ownerPhoto.bottom+10,self.backV.width-10,size.height + 10);
        self.frontPhoto.frame = CGRectMake(5,self.contentL.bottom+5, 60,60);
        self.shareTitlelL.frame = CGRectMake(self.frontPhoto.right+10,self.frontPhoto.top+5,self.backV.width-self.frontPhoto.right-10-10,50);
        if ([self.delegate respondsToSelector:@selector(getCellHeight:andIndex:)]) {
            
            [self.delegate getCellHeight:155 + size.height andIndex:self.indexPath];
        }
    }
    
    if ([model.frontPage isEqualToString:@""] || model.frontPage == nil) {
        
        self.frontPhoto.hidden = YES;
        self.shareTitlelL.frame = CGRectMake(5, self.contentL.bottom+5, self.backV.width - 15, 60);
    } else {
        self.frontPhoto.hidden = NO;
        self.shareTitlelL.frame = CGRectMake(75,self.contentL.bottom+5,self.backV.width - 85,60);
        [self.frontPhoto sd_setImageWithURL:[NSURL URLWithString:model.frontPage] placeholderImage:[UIImage imageNamed:@"carousel"]];
    }
    
    
    self.shareTitlelL.text = model.shareTitle;
}

#pragma mark - setter
- (UIView *)backV {
    
    if (!_backV) {
        _backV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kSCREEN_WIDTH-20, 230)];
        _backV.backgroundColor = White_Color;
    }
    return _backV;
}

- (UIImageView *)ownerPhoto {
    
    if (!_ownerPhoto) {
        
        _ownerPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(5,10, 40,40)];
        _ownerPhoto.layer.cornerRadius = 20;
        _ownerPhoto.layer.masksToBounds = YES;
    }
    return _ownerPhoto;
}

- (UILabel *)ownerNameL {
    
    if (!_ownerNameL) {
        
        _ownerNameL = [[UILabel alloc]initWithFrame:CGRectMake(self.ownerPhoto.right+10, self.ownerPhoto.top, self.backV.width - 55 - 120, 20)];
        _ownerNameL.textColor = COLOR_BLACK_CLASS_3;
        _ownerNameL.textAlignment = NSTextAlignmentLeft;
        _ownerNameL.font = NB_FONTSEIZ_BIG;
    }
    return _ownerNameL;
}

- (UILabel *)addressL {
    
    if (!_addressL) {
        
        _addressL = [[UILabel alloc]initWithFrame:CGRectMake(self.ownerPhoto.right+10, self.ownerNameL.bottom, self.ownerNameL.width, 20)];
        _addressL.textColor = COLOR_BLACK_CLASS_9;
        _addressL.textAlignment = NSTextAlignmentLeft;
        _addressL.font = NB_FONTSEIZ_SMALL;
    }
    return _addressL;
}

- (UILabel *)evaluateL {
    
    if (!_evaluateL) {
        
        _evaluateL = [[UILabel alloc]initWithFrame:CGRectMake(self.backV.width-50,5,30,30)];
        _evaluateL.textColor = Green_Color;
        _evaluateL.textAlignment = NSTextAlignmentCenter;
        _evaluateL.font = NB_FONTSEIZ_BIG;
    }
    return _evaluateL;
}

- (UILabel *)contentL {
    
    if (!_contentL) {
        
        _contentL = [[UILabel alloc]initWithFrame:CGRectMake(self.ownerPhoto.left,self.ownerPhoto.bottom+10,self.backV.width-10,100)];
        _contentL.textColor = [UIColor darkGrayColor];
        _contentL.textAlignment = NSTextAlignmentLeft;
        _contentL.numberOfLines = 0;
        _contentL.font = NB_FONTSEIZ_NOR;
    }
    return _contentL;
}

- (UIImageView *)frontPhoto {
    
    if (!_frontPhoto) {
        
        _frontPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(5,self.contentL.bottom+5, 60,60)];
    }
    return _frontPhoto;
}

- (UILabel *)shareTitlelL {
    
    if (!_shareTitlelL) {
        
        _shareTitlelL = [[UILabel alloc]initWithFrame:CGRectMake(75,self.contentL.bottom+5,self.backV.width - 85,60)];
        _shareTitlelL.textColor = COLOR_BLACK_CLASS_3;
        _shareTitlelL.textAlignment = NSTextAlignmentLeft;
        _shareTitlelL.numberOfLines = 0;
        _shareTitlelL.font = NB_FONTSEIZ_BIG;
    }
    return _shareTitlelL;
}


@end
