//
//  BuildCaseCell.m
//  iDecoration
//
//  Created by Apple on 2017/5/3.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "BuildCaseCell.h"
#import "BulidCaseModel.h"

@interface BuildCaseCell()
@property (nonatomic, strong) UIView *backV;
@property (nonatomic, strong)UIImageView *photoImg;
@property (nonatomic, strong)UILabel *titleL;
@property (nonatomic, strong)UILabel *styleL;
@property (nonatomic, strong)UILabel *addressL;

@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic, strong) UIButton *goodBtn;
@property (nonatomic, strong) UILabel *goodCountL;
@end

@implementation BuildCaseCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *TextFieldCellID = @"BuildCaseCell";
    BuildCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    if (cell == nil) {
        cell =[[BuildCaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.backV];
        [self.backV addSubview:self.photoImg];
        [self.backV addSubview:self.titleL];
        [self.backV addSubview:self.styleL];
        [self.backV addSubview:self.addressL];
        [self.backV addSubview:self.goodCountL];
        [self.backV addSubview:self.goodBtn];
        [self.backV addSubview:self.commentCountL];
        [self.backV addSubview:self.commentBtn];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)configWith:(id)data {
    
    if ([data isKindOfClass:[BulidCaseModel class]]) {
        BulidCaseModel *model = data;
        
        if (model.cdPicture && ![model.cdPicture isEqualToString:@""]) {
            
            self.photoImg.hidden = NO;
            [self.photoImg sd_setImageWithURL:[NSURL URLWithString:model.cdPicture] placeholderImage:[UIImage imageNamed:@"carousel"]];
            _backV.frame = CGRectMake(5, 5, kSCREEN_WIDTH-10, 270);
            _titleL.frame = CGRectMake(self.photoImg.left, self.photoImg.bottom, self.photoImg.width, 30);
            _styleL.frame = CGRectMake(self.titleL.left, self.titleL.bottom, self.titleL.width, 20);
            _addressL.frame = CGRectMake(self.titleL.left, self.styleL.bottom, self.titleL.width - 120, 20);
            _goodCountL.frame = CGRectMake(kSCREEN_WIDTH-40,self.addressL.top,30,30);
            _goodBtn.frame = CGRectMake(self.goodCountL.left-30, self.goodCountL.top, 30, 30);
            _commentCountL.frame = CGRectMake(self.goodBtn.left-30,self.addressL.top,30,30);
            _commentBtn.frame = CGRectMake(self.commentCountL.left-30, self.goodCountL.top, 30, 30);
        } else {
            
            self.photoImg.hidden = YES;
            _backV.frame = CGRectMake(5, 5, kSCREEN_WIDTH-10, 90);
            _titleL.frame = CGRectMake(5, 5, kSCREEN_WIDTH-10, 30);
            _styleL.frame = CGRectMake(self.titleL.left, self.titleL.bottom, self.titleL.width, 20);
            _addressL.frame = CGRectMake(self.titleL.left, self.styleL.bottom, self.titleL.width - 120, 20);
            _goodCountL.frame = CGRectMake(kSCREEN_WIDTH-40,self.addressL.top,30,30);
            _goodBtn.frame = CGRectMake(self.goodCountL.left-30, self.goodCountL.top, 30, 30);
            _commentCountL.frame = CGRectMake(self.goodBtn.left-30,self.addressL.top,30,30);
            _commentBtn.frame = CGRectMake(self.commentCountL.left-30, self.goodCountL.top, 30, 30);
        }
        
        self.titleL.text = model.ccShareTitle;
        self.addressL.text =[NSString stringWithFormat:@"%@ %@",model.ccAreaName,model.ccHouseholderName];
        self.goodCountL.text = model.likeNumber;
        self.commentCountL.text = model.scanCount;
        
        if (!model.ccAcreage || [model.ccAcreage isEqualToString:@""]) {
            model.ccAcreage = @"0";
        }
        
        if (!model.style || [model.style isEqualToString:@""]) {
            model.style = @"";
        }
        if ([model.style isEqualToString:@""]) {
            self.styleL.text = [NSString stringWithFormat:@"%@㎡",model.ccAcreage];
        } else{
            self.styleL.text = [NSString stringWithFormat:@"%@㎡/%@",model.ccAcreage,model.style];
        }
        
    }
}

#pragma mark - setter

- (UIView *)backV {
    if (!_backV) {
        _backV = [[UIView alloc]initWithFrame:CGRectMake(5, 5, kSCREEN_WIDTH-10, 270)];
        _backV.backgroundColor = kBackgroundColor;
    }
    return _backV;
}

- (UIImageView *)photoImg {
    if (!_photoImg) {
        _photoImg = [[UIImageView alloc]initWithFrame:CGRectMake(5,5, self.backV.width-10, 180)];
        _photoImg.contentMode = UIViewContentModeScaleAspectFill;
        _photoImg.layer.masksToBounds = YES;
    }
    return _photoImg;
}

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(self.photoImg.left, self.photoImg.bottom, self.photoImg.width, 30)];
        _titleL.textColor = COLOR_BLACK_CLASS_3;
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.font = NB_FONTSEIZ_BIG;
    }
    return _titleL;
}

- (UILabel *)styleL {
    if (!_styleL) {
        _styleL = [[UILabel alloc]initWithFrame:CGRectMake(self.titleL.left, self.titleL.bottom, self.titleL.width, 20)];
        _styleL.textColor = COLOR_BLACK_CLASS_9;
        _styleL.textAlignment = NSTextAlignmentLeft;
        _styleL.font = NB_FONTSEIZ_NOR;
    }
    return _styleL;
}

- (UILabel *)addressL {
    if (!_addressL) {
        _addressL = [[UILabel alloc]initWithFrame:CGRectMake(self.titleL.left, self.styleL.bottom, self.titleL.width - 120, 20)];
        _addressL.textColor = COLOR_BLACK_CLASS_9;
        _addressL.textAlignment = NSTextAlignmentLeft;
        _addressL.font = NB_FONTSEIZ_NOR;
    }
    return _addressL;
}

- (UILabel *)goodCountL {
    if (!_goodCountL) {
        _goodCountL = [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-40,self.addressL.top,30,30)];
        _goodCountL.textColor = COLOR_BLACK_CLASS_9;
        _goodCountL.textAlignment = NSTextAlignmentLeft;
        _goodCountL.font = NB_FONTSEIZ_SMALL;
    }
    return _goodCountL;

}

- (UIButton *)goodBtn {
    if (!_goodBtn) {
        _goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goodBtn.frame = CGRectMake(self.goodCountL.left-30, self.goodCountL.top, 30, 30);
        [_goodBtn setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
        [_goodBtn setImage:[UIImage imageNamed:@"support"] forState:UIControlStateSelected];
        [_goodBtn addTarget:self action:@selector(didClickSupportBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goodBtn;
}

- (UILabel *)commentCountL {
    if (!_commentCountL) {
        _commentCountL = [[UILabel alloc]initWithFrame:CGRectMake(self.goodBtn.left-30,self.addressL.top,30,30)];
        _commentCountL.textColor = COLOR_BLACK_CLASS_9;
        _commentCountL.textAlignment = NSTextAlignmentLeft;
        _commentCountL.font = NB_FONTSEIZ_SMALL;
        
    }
    return _commentCountL;
    
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.frame = CGRectMake(self.commentCountL.left-30, self.goodCountL.top, 30, 30);
        [_commentBtn setImage:[UIImage imageNamed:@"skimming"] forState:UIControlStateNormal];
    }
    return _commentBtn;
}

- (void)setIndex:(NSInteger)index {
    
    if (_index != index) {
        _index = index;
    }
    self.goodBtn.tag = index;
}

- (void)setBeSelected:(BOOL)beSelected {
    
    _beSelected = beSelected;
    self.goodBtn.selected = beSelected;
}


#pragma mark - 点赞按钮的点击事件
- (void)didClickSupportBtn:(UIButton *)btn {
    
    if (btn.selected == NO) {
        self.goodCountL.text = [NSString stringWithFormat:@"%d", [self.goodCountL.text intValue] + 1];
        btn.selected = YES;
        if ([self.buildCaseCellDelegate respondsToSelector:@selector(didClickSupportBtn:withIndex:)]) {
            
            [self.buildCaseCellDelegate didClickSupportBtn:btn withIndex:btn.tag];
        }
    }
    
}



@end
