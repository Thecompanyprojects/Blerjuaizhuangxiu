//
//  NewMyPersonCardThreeCell.m
//  iDecoration
//
//  Created by sty on 2018/1/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "NewMyPersonCardThreeCell.h"

@implementation NewMyPersonCardThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
    NSString *NewMyPersonCardThreeCellID = [NSString stringWithFormat:@"NewMyPersonCardThreeCell%ld%ld",path.section,path.row];
    NewMyPersonCardThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:NewMyPersonCardThreeCellID];
    
    if (cell == nil) {
        cell =[[NewMyPersonCardThreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewMyPersonCardThreeCellID];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        [self addSubview:self.topV];
        self.backgroundColor = kSepLineColor;
        [self addSubview:self.firstV];
        [self.firstV addSubview:self.personL];
        [self.firstV addSubview:self.SegmentLeftV];
        [self.firstV addSubview:self.SegmentRightV];
        
        [self addSubview:self.secondV];
        
        [self.secondV addSubview:self.detailL];
        
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configWith:(NSString *)indu{
    self.detailL.text = indu;
    if (!indu||indu.length<=0) {
        self.cellH = 50 + 52;
        self.secondV.frame = CGRectMake(6, self.firstV.bottom+6, kSCREEN_WIDTH-12, 50);
        self.detailL.frame = CGRectMake(10, 0, self.secondV.width-20, self.secondV.height);
    }
    else{
        CGSize size = [indu boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-20, CGFLOAT_MAX) withFont:NB_FONTSEIZ_NOR];
        self.cellH = size.height+20+52;
        
        self.secondV.frame = CGRectMake(6, self.firstV.bottom+6, kSCREEN_WIDTH-12, size.height+20);
        self.detailL.frame = CGRectMake(10, 10, self.secondV.width-20, self.secondV.height-20);
    }
}

-(UIView *)firstV{
    if (!_firstV) {
        _firstV = [[UIView alloc]initWithFrame:CGRectMake(0, 6, kSCREEN_WIDTH, 40)];
        _firstV.backgroundColor = White_Color;
    }
    return _firstV;
}

-(UILabel *)personL{
    if (!_personL) {
        _personL = [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-(70/2), 0, 70, self.firstV.height)];
        _personL.text = @"个人简介";
        _personL.textColor = COLOR_BLACK_CLASS_3;
        _personL.font = NB_FONTSEIZ_NOR;
        _personL.textAlignment = NSTextAlignmentCenter;
    }
    return _personL;
}

-(UIView *)SegmentLeftV{
    if (!_SegmentLeftV) {
        _SegmentLeftV = [[UIView alloc]initWithFrame:CGRectMake(self.personL.left-self.personL.width/2, self.firstV.height/2-0.5, self.personL.width/2, 1)];
        _SegmentLeftV.backgroundColor = kSepLineColor;
    }
    return _SegmentLeftV;
}

-(UIView *)SegmentRightV{
    if (!_SegmentRightV) {
        _SegmentRightV = [[UIView alloc]initWithFrame:CGRectMake(self.personL.right, self.firstV.height/2-0.5, self.personL.width/2, 1)];
        _SegmentRightV.backgroundColor = kSepLineColor;
    }
    return _SegmentRightV;
}

-(UIView *)secondV{
    if (!_secondV) {
        _secondV = [[UIView alloc]initWithFrame:CGRectMake(6, self.firstV.bottom+6, kSCREEN_WIDTH-12, 148)];
        _secondV.backgroundColor = White_Color;
    }
    return _secondV;
}

-(UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, self.secondV.width-20, self.secondV.height-20-10)];
//        _detailL.text = @"咸鱼翻身";
        _detailL.textColor = COLOR_BLACK_CLASS_3;
        _detailL.font = NB_FONTSEIZ_NOR;
        _detailL.numberOfLines = 0;
        _personL.textAlignment = NSTextAlignmentCenter;
    }
    return _detailL;
}

@end
