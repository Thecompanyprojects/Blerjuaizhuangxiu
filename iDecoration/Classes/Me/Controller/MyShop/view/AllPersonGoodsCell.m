//
//  AllPersonGoodsCell.m
//  iDecoration
//
//  Created by sty on 2018/1/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "AllPersonGoodsCell.h"
#import "PersonGoodListModel.h"

@implementation AllPersonGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
    NSString *AllPersonGoodsCellID = [NSString stringWithFormat:@"AllPersonGoodsCell%ld%ld",path.section,path.row];
    AllPersonGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:AllPersonGoodsCellID];
    //    cell.path = path;
    if (cell == nil) {
        cell =[[AllPersonGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AllPersonGoodsCellID];
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
        
        [self addSubview:self.priceL];
        [self addSubview:self.nameL];
//        [self addSubview:self.styleL];
        
        [self addSubview:self.lineV];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configData:(id)data{
    if ([data isKindOfClass:[PersonGoodListModel class]]) {
        PersonGoodListModel *model = data;
        
        //        self.circleBtn.frame = CGRectMake(15,(100-24)/2,24,24);
        
        
        if (!model.isCardDisPlay) {
            [self.circleBtn setImage:[UIImage imageNamed:@"water_Circle"] forState:UIControlStateNormal];
        }
        else{
            [self.circleBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
        }
        
        [self.midV sd_setImageWithURL:[NSURL URLWithString:model.faceImg] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        //        self.midV.frame = CGRectMake(kSCREEN_WIDTH-80-10, 10, 80, 80);
        self.priceL.text = [NSString stringWithFormat:@"%@㎡",model.price];
        self.nameL.text = model.name;
        
        //        CGSize titleSize = [model.designTitle boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-self.circleBtn.right-5-90, 100-10-10-20) withFont:[UIFont systemFontOfSize:16]];
        //        if (titleSize.height<15) {
        //            titleSize.height = 21;
        //        }
        //        self.titleL.frame = CGRectMake(self.circleBtn.right+5, 10, titleSize.width, titleSize.height);
        //        self.numL.frame = CGRectMake(self.midV.left-30, self.midV.bottom-21, 30, 21);
        
        //        self.browerImgV.frame = CGRectMake(self.numL.left-25, self.numL.top+(self.numL.height-10)/2, 20, 10);
        //        self.lineV.frame = CGRectMake(0, self.midV.bottom+1, kSCREEN_WIDTH, 0.5);
    }
}

-(UIButton *)circleBtn{
    if (!_circleBtn) {
        _circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _circleBtn.frame = CGRectMake(15,(160-24)/2,24,24);
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
//        _midV = [[UIImageView alloc]initWithFrame:CGRectMake(self.circleBtn.right+10, 5, kSCREEN_WIDTH-self.circleBtn.right-10-10, 100)];
        _midV = [[UIImageView alloc]initWithFrame:CGRectMake(self.circleBtn.right+10, 5, 100, 100)];
        _midV.layer.masksToBounds = YES;
        _midV.contentMode = UIViewContentModeScaleAspectFill;
        //        _midV.backgroundColor = White_Color;
    }
    return _midV;
}

-(UILabel *)priceL{
    if (!_priceL) {
        _priceL = [[UILabel alloc]initWithFrame:CGRectMake(self.midV.left, self.midV.bottom+10, self.midV.width, 20)];
        //        _titleL.text = @"咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身";
        _priceL.textColor = COLOR_BLACK_CLASS_3;
        _priceL.font = NB_FONTSEIZ_NOR;
        _priceL.numberOfLines = 0;
        _priceL.textAlignment = NSTextAlignmentLeft;
    }
    return _priceL;
}

-(UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]initWithFrame:CGRectMake(self.midV.left, self.priceL.bottom, self.midV.width, 20)];
        //        _titleL.text = @"咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身";
        _nameL.textColor = COLOR_BLACK_CLASS_3;
        _nameL.font = NB_FONTSEIZ_SMALL;
        _nameL.numberOfLines = 0;
        _nameL.textAlignment = NSTextAlignmentLeft;
    }
    return _nameL;
}


-(UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]initWithFrame:CGRectMake(0, self.nameL.bottom+7, kSCREEN_WIDTH, 0.5)];
        _lineV.backgroundColor = kSepLineColor;
    }
    return _lineV;
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
