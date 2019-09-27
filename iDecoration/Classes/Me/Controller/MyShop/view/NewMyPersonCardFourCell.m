//
//  NewMyPersonCardFourCell.m
//  iDecoration
//
//  Created by sty on 2018/1/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "NewMyPersonCardFourCell.h"
#import "PersonConListModel.h"

@implementation NewMyPersonCardFourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
    NSString *NewMyPersonCardFourCellID = [NSString stringWithFormat:@"NewMyPersonCardFourCell%ld%ld",path.section,path.row];
    NewMyPersonCardFourCell *cell = [tableView dequeueReusableCellWithIdentifier:NewMyPersonCardFourCellID];
    
    if (cell == nil) {
        cell =[[NewMyPersonCardFourCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewMyPersonCardFourCellID];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        [self addSubview:self.topV];
        self.backgroundColor = kSepLineColor;
        [self addSubview:self.firstV];
        [self.firstV addSubview:self.caseL];
        [self.firstV addSubview:self.SegmentLeftV];
        [self.firstV addSubview:self.SegmentRightV];
        [self.firstV addSubview:self.allCaseBtn];
        
        [self addSubview:self.secondV];
        
//        [self.secondV addSubview:self.detailL];
        
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configData:(NSMutableArray *)array{
    [self.secondV removeAllSubViews];
    CGFloat imgW = (self.secondV.width-10*3)/2;
    CGFloat imgH = 80;
    CGFloat topH = 0;
    for (int i = 0; i<array.count; i++) {
        
//        NSDictionary *dict = array[i];
        PersonConListModel *model = array[i];
        CGFloat row = i/2;
        CGFloat column = i%2;
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10+(imgW+10)*column, 10+(imgH+30)*row, imgW, imgH)];
        imgV.layer.masksToBounds = YES;
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        
        imgV.userInteractionEnabled = YES;
        imgV.tag = i;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgVClick:)];
        [imgV addGestureRecognizer:ges];
        
//        if (i==0) {
//            imgV.backgroundColor = Red_Color;
//        }
//        if (i==2) {
//            imgV.backgroundColor = Green_Color;
//        }
//        if (i==1) {
//            imgV.backgroundColor = Blue_Color;
//        }
//        if (i==3) {
//            imgV.backgroundColor = Black_Color;
//        }
//        imgV.backgroundColor = Red_Color;
        
        
        
        
        [self.secondV addSubview:imgV];
        [imgV sd_setImageWithURL:[NSURL URLWithString:model.coverMap?model.coverMap:@""] placeholderImage:nil];
        
        UIView *shadowV = [[UIView alloc]initWithFrame:CGRectMake(imgV.left, imgV.top+(imgV.height-20), imgV.width, 20)];
        shadowV.backgroundColor = Black_Color;
        shadowV.alpha = 0.4;
        [self.secondV addSubview:shadowV];
        
        
        
        //小区名称
        UILabel *leftL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, shadowV.width/3, shadowV.height)];
        NSString *ccAreaName = model.ccAreaName;
//        leftL.text = ccAreaName;
        leftL.textColor = White_Color;
        leftL.font = NB_FONTSEIZ_SMALL;
        leftL.textAlignment = NSTextAlignmentCenter;
        [shadowV addSubview:leftL];
        
        
        
        //面积
        UILabel *centerL = [[UILabel alloc]initWithFrame:CGRectMake(leftL.right, 0, shadowV.width/3, shadowV.height)];
        NSString *centerStr = [NSString stringWithFormat:@"%@",model.ccAcreage];
//        centerL.text = centerStr;
        centerL.textColor = White_Color;
        centerL.font = NB_FONTSEIZ_SMALL;
        centerL.textAlignment = NSTextAlignmentCenter;
        centerL.numberOfLines = 0;
        [shadowV addSubview:centerL];
        
        //装修风格
        UILabel *rightL = [[UILabel alloc]initWithFrame:CGRectMake(centerL.right, 0, shadowV.width/3, shadowV.height)];
        NSString *style = model.style;
//        rightL.text = style;
        rightL.textColor = White_Color;
        rightL.font = NB_FONTSEIZ_SMALL;
        rightL.textAlignment = NSTextAlignmentCenter;
        [shadowV addSubview:rightL];
        
        //主材日志不显示面积和风格，并且小区名称居中
        if ([model.companyType integerValue]==1018 || [model.companyType integerValue]==1064 ||[model.companyType integerValue]==1065) {
//            leftL.hidden = NO;
//            centerL.hidden = NO;
//            shadowV.hidden = NO;
            
            leftL.text = ccAreaName;
            centerL.text = centerStr;
            rightL.text = style;
        }
        else{
//            leftL.hidden = YES;
//            centerL.hidden = NO;
//            shadowV.hidden = YES;
//            leftL.hidden = NO;
//            centerL.hidden = NO;
//            shadowV.hidden = NO;
            centerL.text = ccAreaName;
            centerL.frame = CGRectMake(0, 0, shadowV.width, shadowV.height);
//            centerL.backgroundColor = Red_Color;
        }
        
        UILabel *numberL = [[UILabel alloc]initWithFrame:CGRectMake(imgV.right-20, imgV.bottom, 20, 30)];
        numberL.text = [NSString stringWithFormat:@"%@",model.displayNumbers];
        numberL.textColor = Blue_Color;
        numberL.font = NB_FONTSEIZ_SMALL;
        numberL.textAlignment = NSTextAlignmentRight;
        [self.secondV addSubview:numberL];
        CGSize disSize = [model.displayNumbers boundingRectWithSize:CGSizeMake(60, 30) withFont:NB_FONTSEIZ_SMALL];
//        if (disSize.width<15) {
//            disSize.width = 15;
//        }
        numberL.frame = CGRectMake(imgV.right-disSize.width, imgV.bottom, disSize.width, 30);
        
//        UILabel *browerL = [[UILabel alloc]initWithFrame:CGRectMake(numberL.left-45, imgV.bottom, 45, 30)];
//        browerL.text = @"展现量";
//        browerL.textColor = COLOR_BLACK_CLASS_3;
//        browerL.font = NB_FONTSEIZ_SMALL;
//        browerL.textAlignment = NSTextAlignmentRight;
//        [self.secondV addSubview:browerL];
        UIImageView *browerImgV = [[UIImageView alloc]initWithFrame:CGRectMake(numberL.left-20-5, numberL.top, 20, 10)];
        browerImgV.centerY = numberL.centerY;
        browerImgV.image = [UIImage imageNamed:@"skimming"];
        [self.secondV addSubview:browerImgV];
        
        topH = imgV.bottom+30;
    }
    //52+180
    
    
    self.secondV.frame = CGRectMake(6, self.firstV.bottom+6, kSCREEN_WIDTH-12, topH);
    self.cellH = self.secondV.bottom;
}

-(UIView *)firstV{
    if (!_firstV) {
        _firstV = [[UIView alloc]initWithFrame:CGRectMake(0, 6, kSCREEN_WIDTH, 40)];
        _firstV.backgroundColor = White_Color;
    }
    return _firstV;
}

-(UILabel *)caseL{
    if (!_caseL) {
        _caseL = [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-(70/2), 0, 70, self.firstV.height)];
        _caseL.text = @"我的案例";
        _caseL.textColor = COLOR_BLACK_CLASS_3;
        _caseL.font = NB_FONTSEIZ_NOR;
        _caseL.textAlignment = NSTextAlignmentCenter;
    }
    return _caseL;
}

-(UIView *)SegmentLeftV{
    if (!_SegmentLeftV) {
        _SegmentLeftV = [[UIView alloc]initWithFrame:CGRectMake(self.caseL.left-self.caseL.width/2, self.firstV.height/2-0.5, self.caseL.width/2, 1)];
        _SegmentLeftV.backgroundColor = kSepLineColor;
    }
    return _SegmentLeftV;
}

-(UIView *)SegmentRightV{
    if (!_SegmentRightV) {
        _SegmentRightV = [[UIView alloc]initWithFrame:CGRectMake(self.caseL.right, self.firstV.height/2-0.5, self.caseL.width/2, 1)];
        _SegmentRightV.backgroundColor = kSepLineColor;
    }
    return _SegmentRightV;
}

-(UIButton *)allCaseBtn{
    if (!_allCaseBtn) {
        _allCaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allCaseBtn.frame = CGRectMake(self.firstV.width-80,0,80,self.firstV.height);
        //        successBtn.backgroundColor = Main_Color;
        
        //        successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_allCaseBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        _allCaseBtn.titleLabel.font = NB_FONTSEIZ_NOR;
//        [_allCaseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
//        [_allCaseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, -60)];
//        [_allCaseBtn setTitle:@"全部案例" forState:UIControlStateNormal];
//        [_allCaseBtn setImage:[UIImage imageNamed:@"common_arrow_btn"] forState:UIControlStateNormal];
        [_allCaseBtn addTarget:self action:@selector(allCaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
//        [firstV addSubview:allArticBtn];
    }
    return _allCaseBtn;
}

-(UIView *)secondV{
    if (!_secondV) {
        _secondV = [[UIView alloc]initWithFrame:CGRectMake(6, self.firstV.bottom+6, kSCREEN_WIDTH-12, 130)];
        _secondV.backgroundColor = White_Color;
    }
    return _secondV;
}

-(void)imgVClick:(UITapGestureRecognizer *)ges{
    
    NSInteger tag = ges.view.tag;
    
    if ([self.delegate respondsToSelector:@selector(goToDiayVC:)]) {
        [self.delegate goToDiayVC:tag];
    }
}

-(void)allCaseBtnClick:(UIButton*)btn{
    if ([self.delegate respondsToSelector:@selector(goAllCase)]) {
        [self.delegate goAllCase];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
