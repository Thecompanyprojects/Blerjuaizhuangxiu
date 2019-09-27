//
//  NewMyPersonCardSixCell.m
//  iDecoration
//
//  Created by sty on 2018/1/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "NewMyPersonCardSixCell.h"
#import "PersonGoodListModel.h"

@implementation NewMyPersonCardSixCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
    NSString *NewMyPersonCardSixCellID = [NSString stringWithFormat:@"NewMyPersonCardSixCell%ld%ld",path.section,path.row];
    NewMyPersonCardSixCell *cell = [tableView dequeueReusableCellWithIdentifier:NewMyPersonCardSixCellID];
    
    if (cell == nil) {
        cell =[[NewMyPersonCardSixCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewMyPersonCardSixCellID];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        [self addSubview:self.topV];
//        self.backgroundColor = kSepLineColor;
//        [self addSubview:self.firstV];
//        [self.firstV addSubview:self.caseL];
//        [self.firstV addSubview:self.SegmentLeftV];
//        [self.firstV addSubview:self.SegmentRightV];
//
//        [self addSubview:self.secondV];
        
        //        [self.secondV addSubview:self.detailL];
        
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configData:(NSMutableArray *)array{
    if (array.count>0) {
        [self removeAllSubViews];
        CGFloat imgW = (kSCREEN_WIDTH-10*4)/3;
        
        CGFloat imgH = imgW;
        CGFloat topH = 10;
        for (int i = 0; i<array.count; i++) {
            PersonGoodListModel *model = array[i];
            CGFloat row = i/3;
            CGFloat column = i%3;
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10+(imgW+10)*column, 10+(imgH+50)*row, imgW, imgH)];
            imgV.layer.masksToBounds = YES;
            imgV.contentMode = UIViewContentModeScaleAspectFill;
            [imgV sd_setImageWithURL:[NSURL URLWithString:model.faceImg] placeholderImage:[UIImage imageNamed:DefaultIcon]];
            [self addSubview:imgV];
            
            imgV.userInteractionEnabled = YES;
            imgV.tag = i;
            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgVGes:)];
            [imgV addGestureRecognizer:ges];
            
            UILabel *priceL = [[UILabel alloc]initWithFrame:CGRectMake(imgV.left, imgV.bottom+10, imgV.width, 20)];
//            priceL.text = @"联盟LOGO";
            priceL.text = [NSString stringWithFormat:@"¥%@",model.price];
            priceL.textColor = Red_Color;
            priceL.font = NB_FONTSEIZ_SMALL;
            priceL.textAlignment = NSTextAlignmentLeft;
            [self addSubview:priceL];
            
            UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(imgV.left, priceL.bottom, imgV.width, 20)];
//            nameL.text = @"联盟LOGO";
            nameL.text = model.name;
            nameL.textColor = COLOR_BLACK_CLASS_3;
            nameL.font = NB_FONTSEIZ_SMALL;
            nameL.textAlignment = NSTextAlignmentLeft;
            [self addSubview:nameL];
            
            topH = imgV.bottom+50;
        }
        self.cellH = topH;
    }
}

-(void)imgVGes:(UITapGestureRecognizer *)ges{
    NSInteger tag = ges.view.tag;
    if ([self.delegate respondsToSelector:@selector(goGoodsVc:)]) {
        [self.delegate goGoodsVc:tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
