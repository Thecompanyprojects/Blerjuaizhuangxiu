//
//  ProdcutDetailInfoCell.m
//  iDecoration
//
//  Created by sty on 2018/3/14.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ProdcutDetailInfoCell.h"

@implementation ProdcutDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
    NSString *ProdcutDetailInfoCellID = [NSString stringWithFormat:@"ProdcutDetailInfoCell%ld%ld",path.section,path.row];
    ProdcutDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ProdcutDetailInfoCellID];
    
    if (cell == nil) {
        cell =[[ProdcutDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProdcutDetailInfoCellID];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        [self addSubview:self.topV];
        [self addSubview:self.contentL];
        [self addSubview:self.imgV];
        [self addSubview:self.lineV];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configDataWith:(NSString *)centenStr imgStr:(NSString *)imgStr{
    self.contentL.text = centenStr;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:DefaultIcon]];
    
    if (centenStr.length>0&&imgStr.length>0) {
        
        self.contentL.frame = CGRectMake(15, 10, kSCREEN_WIDTH-30, 40);
        self.imgV.frame = CGRectMake(0, self.contentL.bottom, kSCREEN_WIDTH, 200);
        
        self.lineV.frame = CGRectMake(0, self.imgV.bottom+10, kSCREEN_WIDTH, 1);
        self.cellH = self.lineV.bottom;
    }
    else if (centenStr.length>0&&imgStr.length<=0) {
        self.contentL.frame = CGRectMake(15, 10, kSCREEN_WIDTH-30, 40);
        self.imgV.frame = CGRectMake(0, self.contentL.bottom, kSCREEN_WIDTH, 0);
        
        self.lineV.frame = CGRectMake(0, self.imgV.bottom+10, kSCREEN_WIDTH, 1);
        self.cellH = self.lineV.bottom;
    }
    else if (centenStr.length<=0&&imgStr.length>0) {
        self.contentL.frame = CGRectMake(15, 10, kSCREEN_WIDTH-30, 0);
        self.imgV.frame = CGRectMake(0, self.contentL.bottom, kSCREEN_WIDTH, 200);
        
        self.lineV.frame = CGRectMake(0, self.imgV.bottom+10, kSCREEN_WIDTH, 1);
        self.cellH = self.lineV.bottom;
    }
    else{
        
        self.contentL.frame = CGRectMake(15, 0, kSCREEN_WIDTH-30, 0);
        self.imgV.frame = CGRectMake(0, self.contentL.bottom, kSCREEN_WIDTH, 0);
        
        self.lineV.frame = CGRectMake(0, self.imgV.bottom, kSCREEN_WIDTH, 0);
        self.cellH = 0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kSCREEN_WIDTH-30, 40)];
//        _contentL.text = @"联盟LOGO";
        _contentL.textColor = COLOR_BLACK_CLASS_3;
        _contentL.font = NB_FONTSEIZ_NOR;
        _contentL.textAlignment = NSTextAlignmentLeft;
    }
    return _contentL;
}

-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.contentL.bottom, kSCREEN_WIDTH, 200)];
        _imgV.layer.masksToBounds = YES;
        _imgV.userInteractionEnabled = YES;
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgV;
}

-(UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]initWithFrame:CGRectMake(0, self.imgV.bottom+10, kSCREEN_WIDTH, 1)];
        _lineV.backgroundColor = kSepLineColor;
    }
    return _lineV;
}

@end
