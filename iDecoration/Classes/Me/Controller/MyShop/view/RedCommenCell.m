//
//  RedCommenCell.m
//  iDecoration
//
//  Created by sty on 2018/3/6.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "RedCommenCell.h"
#import "ZCHCouponModel.h"

@implementation RedCommenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
    NSString *RedCommenCellID = [NSString stringWithFormat:@"RedCommenCell%ld%ld",path.section,path.row];
    RedCommenCell *cell = [tableView dequeueReusableCellWithIdentifier:RedCommenCellID];
    //    cell.path = path;
    if (cell == nil) {
        cell =[[RedCommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RedCommenCellID];
    }
    
    return cell;
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        [self addSubview:self.topV];
        //        self.backgroundColor = kSepLineColor;
        
        self.backgroundColor = RGB(241, 242, 245);
        
        [self addSubview:self.redView];
        
        [self.redView addSubview:self.addRedL];
        [self.redView addSubview:self.imgV];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configArray:(NSMutableArray *)array isHaveRed:(BOOL)isHaveRed{
    [self.redView removeAllSubViews];
    if (!isHaveRed) {
        [self.redView addSubview:self.addRedL];
        [self.redView addSubview:self.imgV];
        self.redView.frame = CGRectMake(5, 0, kSCREEN_WIDTH-10, 50);
        _redView.backgroundColor = White_Color;
        
        _redView.layer.masksToBounds = YES;
        _redView.layer.cornerRadius = 10;
    }
    else{
        _redView.layer.masksToBounds = NO;
        CGFloat topY = 0;
        for (int i = 0; i<array.count; i++) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, topY, kSCREEN_WIDTH-10, 125)];
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 10;
            view.backgroundColor = White_Color;
            
            ZCHCouponModel *model = array[i];
            
            UIButton *redDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            redDeleteBtn.frame = CGRectMake(5, 5, 15, 15);
            [redDeleteBtn setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
            redDeleteBtn.tag = i;
            [redDeleteBtn addTarget:self action:@selector(removeRedCupon:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:redDeleteBtn];
            
            CGFloat width = view.height-redDeleteBtn.bottom*2;
            UIImageView *companyLogoV = [[UIImageView alloc]initWithFrame:CGRectMake(redDeleteBtn.right, redDeleteBtn.bottom, width, width)];
            [companyLogoV sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:DefaultIcon]];
            companyLogoV.userInteractionEnabled = YES;
            companyLogoV.layer.masksToBounds = YES;
            companyLogoV.contentMode = UIViewContentModeScaleAspectFill;
            [view addSubview:companyLogoV];
            
            
            UILabel *redNameL = [[UILabel alloc]initWithFrame:CGRectMake(companyLogoV.right+5,companyLogoV.top,view.width-companyLogoV.right-5-5,companyLogoV.height/2)];
            redNameL.textColor = COLOR_BLACK_CLASS_3;
            redNameL.font = NB_FONTSEIZ_BIG;
            redNameL.text = model.couponName;
            redNameL.textAlignment = NSTextAlignmentLeft;
            [view addSubview:redNameL];
            
            UILabel *redTimeL = [[UILabel alloc]initWithFrame:CGRectMake(redNameL.left,redNameL.bottom,redNameL.width,redNameL.height)];
            redTimeL.textColor = COLOR_BLACK_CLASS_3;
            redTimeL.font = NB_FONTSEIZ_NOR;
            
            NSString *temStart = [self getDateFormatStrFromTimeStamp:model.startDate];
            NSString *temEnd = [self getDateFormatStrFromTimeStamp:model.endDate];
            redTimeL.text = [NSString stringWithFormat:@"有效时间：%@-%@",temStart,temEnd];
            //        companyJob.backgroundColor = Red_Color;
            redTimeL.textAlignment = NSTextAlignmentLeft;
            [view addSubview:redTimeL];
            
            
            topY = topY + 125 + 10;
            [self.redView addSubview:view];
        }
        self.redView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, topY-10);
        _redView.backgroundColor = RGB(241, 242, 245);
    }
    self.cellH = self.redView.bottom;
}

-(void)removeRedCupon:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(deleteRedWith:)]) {
        [self.delegate deleteRedWith:btn.tag];
    }
}

-(UIView *)redView{
    if (!_redView) {
        _redView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, kSCREEN_WIDTH-10, 50)];
//        _redView.layer.masksToBounds = YES;
//        _redView.layer.cornerRadius = 10;
        //        _backView.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
        //        _backView.layer.borderWidth = 1.0f;
        //        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(VRGes:)];
        //        //        ges.numberOfTouches = 1;
        //        _VRview.userInteractionEnabled = YES;
        //        [_VRview addGestureRecognizer:ges];
//        _redView.backgroundColor = White_Color;
        
    }
    return _redView;
}

-(UILabel *)addRedL{
    if (!_addRedL) {
        _addRedL = [[UILabel alloc]initWithFrame:CGRectMake(self.redView.width/2-20, 0, 80, 50)];
        _addRedL.textColor = RGB(211, 192, 185);
        _addRedL.font = NB_FONTSEIZ_BIG;
        _addRedL.text = @"添加红包";
        
        //        companyJob.backgroundColor = Red_Color;
        _addRedL.textAlignment = NSTextAlignmentLeft;
    }
    return _addRedL;
}

-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]initWithFrame:CGRectMake(self.addRedL.left-17-8,self.redView.height/2-8.5,17,17)];
        _imgV.image = [UIImage imageNamed:@"poster_add"];
    }
    return _imgV;
}

#pragma mark --通过时间戳得到日期字符串
-(NSString*)getDateFormatStrFromTimeStamp:(NSString*)timeStamp{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/ 1000.0];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
