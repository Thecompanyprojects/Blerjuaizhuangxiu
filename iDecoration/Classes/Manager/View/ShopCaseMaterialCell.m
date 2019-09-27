//
//  ShopCaseMaterialCell.m
//  iDecoration
//
//  Created by sty on 2017/12/20.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ShopCaseMaterialCell.h"

@implementation ShopCaseMaterialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path
{
    NSString *TextFieldCellID = [NSString stringWithFormat:@"ShopCaseMaterialCell%ld%ld",path.section,path.row];
    ShopCaseMaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFieldCellID];
    
    if (cell == nil) {
        cell =[[ShopCaseMaterialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCellID];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        [self addSubview:self.topV];
        [self addSubview:self.logo];
        [self addSubview:self.nameAndJob];
        [self addSubview:self.date];
//        [self addSubview:self.lookDetailInfoBtn];
        [self addSubview:self.stateImage];
        [self addSubview:self.stateLabel];
        
        [self addSubview:self.zanNumberLabel];
        [self addSubview:self.dianzan];

        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)configData:(id)data isComplete:(NSInteger)isComplete{
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = data;
        
        NSArray *merchArray = [dict objectForKey:@"merchandiesList"];
        NSDictionary *lastDict = merchArray.lastObject;
        
        
        
        [self removeAllSubViews];
        
        [self addSubview:self.logo];
        [self addSubview:self.nameAndJob];
        [self addSubview:self.date];
        //        [self addSubview:self.lookDetailInfoBtn];
        [self addSubview:self.stateImage];
        [self addSubview:self.stateLabel];
        
        [self addSubview:self.zanNumberLabel];
        [self addSubview:self.dianzan];
        
        
        [self.logo sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"photo"]] placeholderImage:[UIImage imageNamed:DefaultManPic]];
        self.nameAndJob.text = [NSString stringWithFormat:@"%@-%@",[dict objectForKey:@"jobTypeName"],[dict objectForKey:@"trueName"]];
        NSString *timeStr = [NSString stringWithFormat:@"%@",[lastDict objectForKey:@"addTime"]];
        self.date.text = [self timeWithTimeIntervalString:timeStr];
        self.stateLabel.text = @"本案材料";
        
        
        CGFloat logoBottom = self.logo.bottom;
        for (int i = 0; i<merchArray.count; i++) {
            NSDictionary *merhchDict = merchArray[i];
            UIView *shopV = [[UIView alloc]initWithFrame:CGRectMake(0, logoBottom, kSCREEN_WIDTH, 120)];
            
            shopV.backgroundColor = White_Color;
            shopV.userInteractionEnabled = YES;
            [self addSubview:shopV];
            
            shopV.tag = i;
            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shopVTag:)];
            [shopV addGestureRecognizer:ges];
            
            UIImageView *shopImgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, shopV.height-20, shopV.height-20)];
            shopImgV.layer.masksToBounds = YES;
            shopImgV.contentMode = UIViewContentModeScaleAspectFill;
            
            [shopImgV sd_setImageWithURL:[NSURL URLWithString:[merhchDict objectForKey:@"faceImg"]] placeholderImage:[UIImage imageNamed:DefaultIcon]];
            [shopV addSubview:shopImgV];
            
            UILabel *desrptionL = [[UILabel alloc]initWithFrame:CGRectMake(shopImgV.right+10, shopImgV.top, shopV.width-shopImgV.right-10-10, 40)];
            
            desrptionL.text = [merhchDict objectForKey:@"name"];
            desrptionL.numberOfLines = 0;
            desrptionL.textColor = COLOR_BLACK_CLASS_3;
            desrptionL.font = NB_FONTSEIZ_SMALL;
            desrptionL.textAlignment = NSTextAlignmentLeft;
            
            
            CGSize desSize = [desrptionL.text boundingRectWithSize:CGSizeMake(shopV.width-shopImgV.right-10-10, 40) withFont:NB_FONTSEIZ_SMALL];
            
            desrptionL.frame = CGRectMake(shopImgV.right+10, shopImgV.top, shopV.width-shopImgV.right-10-10, desSize.height);
            
            [shopV addSubview:desrptionL];
            
            //满减
            NSArray *activityArray = [merhchDict objectForKey:@"merchandiesActivity"];
            if (activityArray.count>0) {
                if (activityArray.count<=3) {
                    CGFloat leftX = desrptionL.left;
                    for (int i = 0; i<activityArray.count; i++) {
                        UILabel *activityL = [[UILabel alloc]initWithFrame:CGRectMake(leftX, desrptionL.bottom+20, 75, 25)];
                            
                        NSDictionary *dict = activityArray[i];
                        activityL.text = dict[@"activityType"];
//                        activityL.text = @"手机刷机啊";
                        activityL.textColor = Red_Color;
                        activityL.font = NB_FONTSEIZ_NOR;
                        activityL.textAlignment = NSTextAlignmentCenter;
                        activityL.layer.masksToBounds = YES;
                        activityL.layer.borderWidth = 1.0;
                        activityL.layer.cornerRadius = 5;
                        activityL.layer.borderColor = Red_Color.CGColor;
                        [shopV addSubview:activityL];
                        if (kSCREEN_WIDTH<=350) {
                            leftX = leftX+75+1;
                        }
                        else{
                            leftX = leftX+75+10;
                        }
                        
                    }
                }
                else{
                    CGFloat leftX = desrptionL.left;
                    for (int i = 0; i<3; i++) {
                        UILabel *activityL = [[UILabel alloc]initWithFrame:CGRectMake(leftX, desrptionL.bottom+20, 75, 25)];
                        NSDictionary *dict = activityArray[i];
                        activityL.text = dict[@"activityType"];
                        //                        activityL.text = @"手机刷机";
                        activityL.textColor = Red_Color;
                        activityL.font = NB_FONTSEIZ_NOR;
                        activityL.textAlignment = NSTextAlignmentCenter;
                        activityL.layer.masksToBounds = YES;
                        activityL.layer.borderWidth = 1.0;
                        activityL.layer.cornerRadius = 5;
                        activityL.layer.borderColor = Red_Color.CGColor;
                        [shopV addSubview:activityL];
                        if (kSCREEN_WIDTH<=350) {
                            leftX = leftX+75+1;
                        }
                        else{
                            leftX = leftX+75+5;
                        }
                    }
                }
                
            }
            
            
            UILabel *priceL = [[UILabel alloc]initWithFrame:CGRectMake(desrptionL.left,shopImgV.bottom-25,80,25)];
            CGFloat priceStr = [[merhchDict objectForKey:@"price"] floatValue];
            priceL.text = [NSString stringWithFormat:@"%.2f",priceStr];
            priceL.textColor = Red_Color;
            priceL.font = NB_FONTSEIZ_NOR;
            priceL.textAlignment = NSTextAlignmentLeft;
            [shopV addSubview:priceL];
            
            UILabel *browerL = [[UILabel alloc]initWithFrame:CGRectMake(shopV.width-10-60,shopImgV.bottom-20,60,20)];
            browerL.text = [NSString stringWithFormat:@"%@",[merhchDict objectForKey:@"collecttionNum"]];
            browerL.textColor = COLOR_BLACK_CLASS_3;
            browerL.font = NB_FONTSEIZ_SMALL;
            browerL.textAlignment = NSTextAlignmentRight;
            [shopV addSubview:browerL];
            
            //先隐藏收藏
            browerL.hidden = YES;
            
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.frame = CGRectMake(shopImgV.left,shopImgV.bottom+5,60,20);
//            deleteBtn.backgroundColor = Main_Color;
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [deleteBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
            deleteBtn.titleLabel.font = NB_FONTSEIZ_NOR;
            deleteBtn.tag = i;
            [deleteBtn addTarget:self action:@selector(deleteTagWith:) forControlEvents:UIControlEventTouchUpInside];
            
            [shopV addSubview:deleteBtn];
            
            //自己只能删自己的商品
            NSInteger agencyId = [[dict objectForKey:@"agencysId"] integerValue];
            UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
            //已交工，也不能删除
            if ((user.agencyId != agencyId)||(isComplete==2||isComplete==3)) {
                deleteBtn.hidden = YES;
                deleteBtn.frame = CGRectMake(shopImgV.left,shopImgV.bottom+5,60,0);
            }
            else{
                deleteBtn.hidden = NO;
                deleteBtn.frame = CGRectMake(shopImgV.left,shopImgV.bottom+5,60,20);
            }
            
            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(deleteBtn.left, deleteBtn.bottom+5, kSCREEN_WIDTH-deleteBtn.left, 0.5)];
            lineV.backgroundColor = kSepLineColor;
            [shopV addSubview:lineV];
            
            
            if ((user.agencyId != agencyId)||(isComplete==2||isComplete==3)) {
                logoBottom = logoBottom+120;
            }
            else{
                logoBottom = logoBottom+120+16;
            }
            
        }
        self.zanNumberLabel.frame = CGRectMake(kSCREEN_WIDTH-40-15, logoBottom+5, 40, 15);
        self.zanNumberLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"likeNum"]];
        self.dianzan.frame = CGRectMake(self.zanNumberLabel.left-5-10, self.zanNumberLabel.top-3, 22, 22);
        //当前人员是否点过赞 isHaveZan：0当前人员没点赞   不为0：点过赞
        NSInteger isHaveZan = [[dict objectForKey:@"dzAgencysId"] integerValue];
        if (!isHaveZan) {
            [self.dianzan setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
        }
        else{
            [self.dianzan setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
        }
        self.cellH = self.dianzan.bottom+5;
    }
    
    
    
}

#pragma mark - action

-(void)deleteTagWith:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(deleteShopCaseWithRow:tag:)]) {
        [self.delegate deleteShopCaseWithRow:self.path.row tag:btn.tag];
    }
}

-(void)dianzanClick{
    if ([self.delegate respondsToSelector:@selector(zanShopCaseWith:)]) {
        [self.delegate zanShopCaseWith:self.path];
    }
}

-(void)shopVTag:(UITapGestureRecognizer *)ges{
    NSInteger tag = ges.view.tag;
    if ([self.delegate respondsToSelector:@selector(goGoodsDetailWithRow:tag:)]) {
        [self.delegate goGoodsDetailWithRow:self.path.row tag:tag];
    }
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

#pragma mark - setter

-(UIImageView *)logo{
    if (!_logo) {
        _logo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        _logo.layer.masksToBounds = YES;
        _logo.layer.cornerRadius = 20;
        
    }
    return _logo;
}

-(UILabel *)nameAndJob{
    if (!_nameAndJob) {
        _nameAndJob = [[UILabel alloc]initWithFrame:CGRectMake(self.logo.right+10, 10, 200, 20)];
        _nameAndJob.textColor = COLOR_BLACK_CLASS_3;
        _nameAndJob.font = [UIFont systemFontOfSize
                            :14];
        //        companyJob.backgroundColor = Red_Color;
        _nameAndJob.textAlignment = NSTextAlignmentLeft;
    }
    return _nameAndJob;
}


-(UILabel *)date{
    if (!_date) {
        _date = [[UILabel alloc]initWithFrame:CGRectMake(self.nameAndJob.left, self.nameAndJob.bottom, 100, 20)];
        _date.textColor = COLOR_BLACK_CLASS_3;
        _date.font = [UIFont systemFontOfSize
                      :12];
        //        companyJob.backgroundColor = Red_Color;
        _date.textAlignment = NSTextAlignmentLeft;
    }
    return _date;
}

//-(UIButton *)lookDetailInfoBtn{
//    if (!_lookDetailInfoBtn) {
//        _lookDetailInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _lookDetailInfoBtn.frame = CGRectMake(self.logo.left, self.logo.top, self.date.right, self.date.bottom);
//        [_lookDetailInfoBtn addTarget:self action:@selector(lookDetailInfoBtnClik:) forControlEvents:UIControlEventTouchUpInside];
//        _lookDetailInfoBtn.backgroundColor = Clear_Color;
//    }
//    return _lookDetailInfoBtn;
//}

-(UIImageView *)stateImage{
    if (!_stateImage) {
        _stateImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.date.right, self.date.top+5, 10, 10)];
        _stateImage.image = [UIImage imageNamed:@"ty_red"];
    }
    return _stateImage;
}

-(UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.stateImage.right,self.date.top,100,20)];
        _stateLabel.textColor = Red_Color;
        _stateLabel.font = [UIFont systemFontOfSize
                            :12];
        //                companyJob.backgroundColor = Red_Color;
        _stateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _stateLabel;
}

-(UILabel *)zanNumberLabel{
    if (!_zanNumberLabel) {
        _zanNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.logo.left, 100, 40, 15)];
        _zanNumberLabel.textColor = COLOR_BLACK_CLASS_3;
        _zanNumberLabel.font = [UIFont systemFontOfSize
                                :14];
        //        companyJob.backgroundColor = Red_Color;
        _zanNumberLabel.textAlignment = NSTextAlignmentRight;
    }
    return _zanNumberLabel;
}

-(UIButton *)dianzan{
    if (!_dianzan) {
        _dianzan = [UIButton buttonWithType:UIButtonTypeCustom];
        _dianzan.frame = CGRectMake(self.zanNumberLabel.left-10-22, self.zanNumberLabel.top-3, 22, 22);
        //            _addressBtn.backgroundColor = Red_Color;
        [_dianzan setImage:[UIImage imageNamed:@"nosupport"] forState:UIControlStateNormal];
        [_dianzan addTarget:self action:@selector(dianzanClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dianzan;
}

@end
