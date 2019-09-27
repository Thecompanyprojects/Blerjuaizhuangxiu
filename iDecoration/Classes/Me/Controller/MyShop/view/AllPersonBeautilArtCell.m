//
//  AllPersonBeautilArtCell.m
//  iDecoration
//
//  Created by sty on 2018/1/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "AllPersonBeautilArtCell.h"
#import "BeautifulArtCardModel.h"

@implementation AllPersonBeautilArtCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
    NSString *AllPersonBeautilArtCellID = [NSString stringWithFormat:@"AllPersonBeautilArtCell%ld%ld",(long)path.section,path.row];
    AllPersonBeautilArtCell *cell = [tableView dequeueReusableCellWithIdentifier:AllPersonBeautilArtCellID];
    cell.path = path;
    if (cell == nil) {
        cell =[[AllPersonBeautilArtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AllPersonBeautilArtCellID];
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
        [self addSubview:self.titleL];
        
        [self addSubview:self.numL];
        [self addSubview:self.browerImgV];
        
        [self addSubview:self.lineV];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configData:(id)data isSelect:(BOOL)isSelect isHavePower:(BOOL)isHavePower{
    if ([data isKindOfClass:[BeautifulArtCardModel class]]) {
        BeautifulArtCardModel *model = data;
        
        
        
        
        if ((!model.isDisplay)&&(!model.flag)) {
            [self.circleBtn setImage:[UIImage imageNamed:@"water_Circle"] forState:UIControlStateNormal];
        }
        else{
            [self.circleBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
        }
        
        
        [self.midV sd_setImageWithURL:[NSURL URLWithString:model.coverMap] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        
        self.titleL.text = model.designTitle;
        self.numL.text = [NSString stringWithFormat:@"%ld",model.readNum];
        
        
        if (isHavePower) {
            self.circleBtn.hidden = NO;
            self.circleBtn.frame = CGRectMake(15,(100-24)/2,24,24);
            self.midV.frame = CGRectMake(kSCREEN_WIDTH-80-10, 10, 80, 80);
            CGSize titleSize = [model.designTitle boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-self.circleBtn.right-5-90, 100-10-10-20) withFont:[UIFont systemFontOfSize:16]];
            if (titleSize.height<15) {
                titleSize.height = 21;
            }
            self.titleL.frame = CGRectMake(self.circleBtn.right+5, 10, titleSize.width, titleSize.height);
            self.numL.frame = CGRectMake(self.midV.left-30, self.midV.bottom-21, 30, 21);
            
            self.browerImgV.frame = CGRectMake(self.numL.left-25, self.numL.top+(self.numL.height-10)/2, 20, 10);
            self.lineV.frame = CGRectMake(0, self.midV.bottom+1, kSCREEN_WIDTH, 0.5);
        }
        else{
            self.circleBtn.hidden = YES;
//            self.circleBtn.frame = CGRectMake(15,(100-24)/2,24,24);
            self.midV.frame = CGRectMake(kSCREEN_WIDTH-80-10, 10, 80, 80);
            CGSize titleSize = [model.designTitle boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-15-5-90, 100-10-10-20) withFont:[UIFont systemFontOfSize:16]];
            if (titleSize.height<15) {
                titleSize.height = 21;
            }
            self.titleL.frame = CGRectMake(15, 10, titleSize.width, titleSize.height);
            self.numL.frame = CGRectMake(self.midV.left-30, self.midV.bottom-21, 30, 21);
            
            self.browerImgV.frame = CGRectMake(self.numL.left-25, self.numL.top+(self.numL.height-10)/2, 20, 10);
            self.lineV.frame = CGRectMake(0, self.midV.bottom+1, kSCREEN_WIDTH, 0.5);
        }
        
    }else{
        /////////////////bys 全部文章cell
        NSDictionary *recommendDic = data;
        
        
//        if (!model.isDisplay) {
            [self.circleBtn setImage:[UIImage imageNamed:@"water_Circle"] forState:UIControlStateNormal];
//        }
//        else{
//            [self.circleBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
//        }
        
        
        [self.midV sd_setImageWithURL:[NSURL URLWithString:[recommendDic objectForKey:@"coverMap"]] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        
        self.titleL.text = [recommendDic objectForKey:@"designTitle"];
        self.numL.text = [[recommendDic objectForKey:@"readNum"] stringValue];
        
        
        if (isHavePower) {
            self.circleBtn.hidden = NO;
            self.circleBtn.frame = CGRectMake(15,(100-24)/2,24,24);
            self.midV.frame = CGRectMake(kSCREEN_WIDTH-80-10, 10, 80, 80);
            CGSize titleSize = [[recommendDic objectForKey:@"designTitle"] boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-self.circleBtn.right-5-90, 100-10-10-20) withFont:[UIFont systemFontOfSize:16]];
            if (titleSize.height<15) {
                titleSize.height = 21;
            }
            self.titleL.frame = CGRectMake(self.circleBtn.right+5, 10, titleSize.width, titleSize.height);
            self.numL.frame = CGRectMake(self.midV.left-30, self.midV.bottom-21, 30, 21);
            
            self.browerImgV.frame = CGRectMake(self.numL.left-25, self.numL.top+(self.numL.height-10)/2, 20, 10);
            self.lineV.frame = CGRectMake(0, self.midV.bottom+1, kSCREEN_WIDTH, 0.5);
        }
        else{
            self.circleBtn.hidden = YES;
            //            self.circleBtn.frame = CGRectMake(15,(100-24)/2,24,24);
            self.midV.frame = CGRectMake(kSCREEN_WIDTH-80-10, 10, 80, 80);
            CGSize titleSize = [[recommendDic objectForKey:@"designTitle"] boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-15-5-90, 100-10-10-20) withFont:[UIFont systemFontOfSize:16]];
            if (titleSize.height<15) {
                titleSize.height = 21;
            }
            self.titleL.frame = CGRectMake(15, 10, titleSize.width, titleSize.height);
            self.numL.frame = CGRectMake(self.midV.left-30, self.midV.bottom-21, 30, 21);
            
            self.browerImgV.frame = CGRectMake(self.numL.left-25, self.numL.top+(self.numL.height-10)/2, 20, 10);
            self.lineV.frame = CGRectMake(0, self.midV.bottom+1, kSCREEN_WIDTH, 0.5);
        }
        
        
    }
}

-(UIButton *)circleBtn{
    if (!_circleBtn) {
        _circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _circleBtn.frame = CGRectMake(15,(100-24)/2,24,24);
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
        _midV = [[UIImageView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-5-100, 5, 100, 70)];
        _midV.layer.masksToBounds = YES;
        _midV.contentMode = UIViewContentModeScaleAspectFill;
        //        _midV.backgroundColor = White_Color;
    }
    return _midV;
}

-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
//        _titleL.text = @"咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身";
        _titleL.textColor = COLOR_BLACK_CLASS_3;
        _titleL.font = [UIFont systemFontOfSize:16];
        _titleL.numberOfLines = 0;
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}





-(UILabel *)numL{
    if (!_numL) {
        _numL = [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-40-10, self.midV.bottom, 40, 20)];
        //        _numL.text = @"7524";
        _numL.textColor = Blue_Color;
        _numL.font = NB_FONTSEIZ_SMALL;
        _numL.textAlignment = NSTextAlignmentLeft;
    }
    return _numL;
}

-(UIImageView *)browerImgV{
    if (!_browerImgV) {
        _browerImgV = [[UIImageView alloc]initWithFrame:CGRectMake(self.numL.left-40, self.numL.top, 20, 10)];
        _browerImgV.image = [UIImage imageNamed:@"skimming"];
    }
    return _browerImgV;
}

-(UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]initWithFrame:CGRectMake(0, self.imageView.bottom+1, kSCREEN_WIDTH, 0.5)];
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
