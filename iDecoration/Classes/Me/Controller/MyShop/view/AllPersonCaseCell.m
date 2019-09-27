//
//  AllPersonCaseCell.m
//  iDecoration
//
//  Created by sty on 2018/1/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "AllPersonCaseCell.h"
#import "PersonConListModel.h"

@implementation AllPersonCaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
    NSString *AllPersonCaseCellID = [NSString stringWithFormat:@"AllPersonCaseCell%ld%ld",path.section,path.row];
    AllPersonCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:AllPersonCaseCellID];
//    cell.path = path;
    if (cell == nil) {
        cell =[[AllPersonCaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AllPersonCaseCellID];
    }
    
    return cell;
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        [self addSubview:self.topV];
        //        self.backgroundColor = kSepLineColor;
        [self addSubview:self.circleBtn];
        [self addSubview:self.midV];
        [self addSubview:self.villageL];
        [self addSubview:self.areaNumL];
        [self addSubview:self.styleL];
        
        [self addSubview:self.numL];
        [self addSubview:self.browerImgV];
        
        [self addSubview:self.lineV];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configData:(id)data isHavePower:(BOOL)isHavePower{
    if ([data isKindOfClass:[PersonConListModel class]]) {
        PersonConListModel *model = data;
        
//        self.circleBtn.frame = CGRectMake(15,(100-24)/2,24,24);
        
        
        if (![model.isDisplay integerValue]) {
            [self.circleBtn setImage:[UIImage imageNamed:@"water_Circle"] forState:UIControlStateNormal];
        }
        else{
            [self.circleBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
        }
        
        [self.midV sd_setImageWithURL:[NSURL URLWithString:model.coverMap] placeholderImage:[UIImage imageNamed:DefaultIcon]];
//        self.midV.frame = CGRectMake(kSCREEN_WIDTH-80-10, 10, 80, 80);
        self.villageL.text = model.ccAreaName;
        self.areaNumL.text = [NSString stringWithFormat:@"%@㎡",model.ccAcreage];
        self.styleL.text = model.style;
        self.numL.text = model.scanCount;
        
        
        if (isHavePower) {
            self.circleBtn.hidden = NO;
            self.circleBtn.frame = CGRectMake(15,(160-24)/2,24,24);
            self.midV.frame = CGRectMake(self.circleBtn.right+10, 5, kSCREEN_WIDTH-self.circleBtn.right-10-10, 150);
            self.villageL.frame = CGRectMake(self.midV.left, self.midV.bottom+5, self.midV.width, 20);
            self.areaNumL.frame = CGRectMake(self.midV.left, self.villageL.bottom, self.midV.width, 20);
            self.styleL.frame = CGRectMake(self.midV.left, self.areaNumL.bottom, self.midV.width, 20);
            self.numL.frame = CGRectMake(kSCREEN_WIDTH-25-10, self.styleL.top, 25, 20);
            self.browerImgV.frame = CGRectMake(self.numL.left-25, self.numL.top+(self.numL.height-10)/2, 20, 10);
            self.lineV.frame = CGRectMake(0, self.browerImgV.bottom+7, kSCREEN_WIDTH, 0.5);
        }
        else{
            self.circleBtn.hidden = YES;
            
            self.midV.frame = CGRectMake(10, 5, kSCREEN_WIDTH-10-10, 150);
            self.villageL.frame = CGRectMake(self.midV.left, self.midV.bottom+5, self.midV.width, 20);
            self.areaNumL.frame = CGRectMake(self.midV.left, self.villageL.bottom, self.midV.width, 20);
            self.styleL.frame = CGRectMake(self.midV.left, self.areaNumL.bottom, self.midV.width, 20);
            self.numL.frame = CGRectMake(kSCREEN_WIDTH-25-10, self.styleL.top, 25, 20);
            self.browerImgV.frame = CGRectMake(self.numL.left-25, self.numL.top+(self.numL.height-10)/2, 20, 10);
            self.lineV.frame = CGRectMake(0, self.browerImgV.bottom+7, kSCREEN_WIDTH, 0.5);
        }
        
    }
}


-(UIButton *)circleBtn{
    if (!_circleBtn) {
        _circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _circleBtn.frame = CGRectMake(15,(200-24)/2,24,24);
        //        successBtn.backgroundColor = Main_Color;
        //        [successBtn setTitle:@"完  成" forState:UIControlStateNormal];
        //        successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        //        [successBtn setTitleColor:White_Color forState:UIControlStateNormal];
        //        successBtn.titleLabel.font = NB_FONTSEIZ_BIG;
        //        successBtn.layer.masksToBounds = YES;
        //        successBtn.layer.cornerRadius = 5;
        [_circleBtn setImage:[UIImage imageNamed:@"water_Circle"] forState:UIControlStateNormal];
        [_circleBtn addTarget:self action:@selector(circleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _circleBtn;
}

-(UIImageView *)midV{
    if (!_midV) {
        _midV = [[UIImageView alloc]initWithFrame:CGRectMake(self.circleBtn.right+10, 5, kSCREEN_WIDTH-self.circleBtn.right-10-10, 150)];
        _midV.layer.masksToBounds = YES;
        _midV.contentMode = UIViewContentModeScaleAspectFill;
        
        _midV.userInteractionEnabled = YES;
//        imgV.tag = i;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgVClick:)];
        [_midV addGestureRecognizer:ges];
        //        _midV.backgroundColor = White_Color;
    }
    return _midV;
}

-(UILabel *)villageL{
    if (!_villageL) {
        _villageL = [[UILabel alloc]initWithFrame:CGRectMake(self.midV.left, self.midV.bottom+5, self.midV.width, 20)];
        //        _titleL.text = @"咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身";
        _villageL.textColor = COLOR_BLACK_CLASS_3;
        _villageL.font = NB_FONTSEIZ_NOR;
        _villageL.numberOfLines = 0;
        _villageL.textAlignment = NSTextAlignmentLeft;
    }
    return _villageL;
}

-(UILabel *)areaNumL{
    if (!_areaNumL) {
        _areaNumL = [[UILabel alloc]initWithFrame:CGRectMake(self.midV.left, self.villageL.bottom, self.midV.width, 20)];
        //        _titleL.text = @"咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身";
        _areaNumL.textColor = COLOR_BLACK_CLASS_3;
        _areaNumL.font = NB_FONTSEIZ_SMALL;
        _areaNumL.numberOfLines = 0;
        _areaNumL.textAlignment = NSTextAlignmentLeft;
    }
    return _areaNumL;
}

-(UILabel *)styleL{
    if (!_styleL) {
        _styleL = [[UILabel alloc]initWithFrame:CGRectMake(self.midV.left, self.areaNumL.bottom, self.midV.width, 20)];
        //        _titleL.text = @"咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身";
        _styleL.textColor = COLOR_BLACK_CLASS_3;
        _styleL.font = NB_FONTSEIZ_SMALL;
        _styleL.numberOfLines = 0;
        _styleL.textAlignment = NSTextAlignmentLeft;
    }
    return _styleL;
}


-(UILabel *)numL{
    if (!_numL) {
        _numL = [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-25-10, self.styleL.top, 25, 20)];
        //        _numL.text = @"7524";
        _numL.textColor = Blue_Color;
        _numL.font = NB_FONTSEIZ_SMALL;
        _numL.textAlignment = NSTextAlignmentLeft;
    }
    return _numL;
}

-(UIImageView *)browerImgV{
    if (!_browerImgV) {
        _browerImgV = [[UIImageView alloc]initWithFrame:CGRectMake(self.numL.left-25, self.numL.top+(self.numL.height-10)/2, 20, 10)];
        _browerImgV.image = [UIImage imageNamed:@"skimming"];
    }
    return _browerImgV;
}

-(UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]initWithFrame:CGRectMake(0, self.browerImgV.bottom+7, kSCREEN_WIDTH, 0.5)];
        _lineV.backgroundColor = kSepLineColor;
    }
    return _lineV;
}

-(void)imgVClick:(UITapGestureRecognizer *)ges{
    
    NSInteger tag = ges.view.tag;
    
    if ([self.delegate respondsToSelector:@selector(goToDiayVC:)]) {
        [self.delegate goToDiayVC:tag];
    }
}

-(void)circleBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(circleBtnDo:)]) {
        [self.delegate circleBtnDo:btn.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
