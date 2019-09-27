//
//  NewMyPersonCardFiveCell.m
//  iDecoration
//
//  Created by sty on 2018/1/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "NewMyPersonCardFiveCell.h"

@implementation NewMyPersonCardFiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
    NSString *NewMyPersonCardFiveCellID = [NSString stringWithFormat:@"NewMyPersonCardFiveCell%ld%ld",path.section,path.row];
    NewMyPersonCardFiveCell *cell = [tableView dequeueReusableCellWithIdentifier:NewMyPersonCardFiveCellID];
    
    if (cell == nil) {
        cell =[[NewMyPersonCardFiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewMyPersonCardFiveCellID];
    }
    
    return cell;
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        [self addSubview:self.topV];
//        self.backgroundColor = kSepLineColor;
        [self addSubview:self.midV];
        [self addSubview:self.titleL];
        
        [self addSubview:self.numL];
        [self addSubview:self.browerImgV];
        
        [self addSubview:self.lineV];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}
-(void)configData:(id)data{
    if ([data isKindOfClass:[BeautifulArtCardModel class]]) {
        BeautifulArtCardModel *model = data;
        [self.midV sd_setImageWithURL:[NSURL URLWithString:model.coverMap] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        self.titleL.text = model.designTitle;
        
        CGSize titleSize = [model.designTitle boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-10-100-5-5, 80-5-5-20) withFont:[UIFont systemFontOfSize:16]];
        if (titleSize.height<15) {
            titleSize.height = 21;
        }
        self.titleL.frame = CGRectMake(10, 10, titleSize.width, titleSize.height);
        self.numL.frame = CGRectMake(self.midV.left-30, self.midV.bottom-21, 30, 21);
        self.numL.text = [NSString stringWithFormat:@"%ld",model.readNum];
        self.browerImgV.frame = CGRectMake(self.numL.left-25, self.numL.top+(self.numL.height-10)/2, 20, 10);
        self.lineV.frame = CGRectMake(0, self.imageView.bottom+1, kSCREEN_WIDTH, 0.5);
    }
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
        _titleL.text = @"咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身咸鱼翻身";
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

//-(UILabel *)browerL{
//    if (!_browerL) {
//        _browerL = [[UILabel alloc]initWithFrame:CGRectMake(self.numL.left-60, self.numL.top, 60, 30)];
//        _browerL.text = @"展现量";
//        _browerL.textColor = COLOR_BLACK_CLASS_3;
//        _browerL.font = NB_FONTSEIZ_SMALL;
//        _browerL.textAlignment = NSTextAlignmentRight;
//    }
//    return _browerL;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
