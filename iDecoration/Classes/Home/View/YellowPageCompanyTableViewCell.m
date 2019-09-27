//
//  YellowPageCompanyTableViewCell.m
//  iDecoration
//
//  Created by Apple on 2017/4/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "YellowPageCompanyTableViewCell.h"

@interface YellowPageCompanyTableViewCell ()


@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, strong) UITapGestureRecognizer *phoneNumTapGR;

@end

@implementation YellowPageCompanyTableViewCell

- (void)awakeFromNib {

    [super awakeFromNib];

    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreButtonTapAction:)];
    self.moreBtn.userInteractionEnabled = YES;
    [self.moreBtn addGestureRecognizer:tapGR];


    UITapGestureRecognizer *phoneNumTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneNumTapAction:)];
    self.phoneNumTapGR = phoneNumTapGR;
    self.phoneNumBtn.userInteractionEnabled = YES;
    [self.phoneNumBtn addGestureRecognizer:phoneNumTapGR];

}

- (IBAction)moreBtnClicked:(UIButton *)sender {

}

- (void)phoneNumTapAction:(UITapGestureRecognizer *)tapGR {
    UIButton *sender = (UIButton *)tapGR.view;
    if (!sender.titleLabel.text || [sender.titleLabel.text isEqual:[NSNull null]]) {
        return;
    }
    //NSMutableString *stringM = [NSMutableString stringWithString:sender.titleLabel.text];
    //    if ([stringM containsString:@"(114可查)"]) {
    //
    //        stringM = [NSMutableString stringWithString:[stringM stringByReplacingOccurrencesOfString:@"(114可查)" withString:@""]];
    //    }


    //    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",stringM];
    //    UIWebView *callWebview = [[UIWebView alloc] init];
    //    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    //    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
}

- (void)moreButtonTapAction:(UITapGestureRecognizer *)tapGR {
    UIButton *sender = (UIButton *)tapGR.view;
    if ([self.delegate respondsToSelector:@selector(YellowPageCompanyTableViewCell:moreBtnClicked:)]) {
        sender.tag = self.companyId;
        [self.delegate YellowPageCompanyTableViewCell:self moreBtnClicked:sender];
    }
}

- (void)setModel:(id)model {
    ////0:距离,-1好评,-2信用,2浏览,1:案例,5:商品
    if ([model isKindOfClass:[HomeDefaultModel class]]) {
        _model = (HomeDefaultModel *)model;
        if ([_model.status isEqualToString:@"2"]) {
            self.certificateStatusView.hidden = NO;
        } else {
            self.certificateStatusView.hidden = YES;
        }
        //    [myTest1.layer addAnimation:[self opacityForever_Animation:0.5] forKey:nil];

        self.companyId = _model.shopID.integerValue ?:_model.merchantId.integerValue;
        [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:_model.typeLogo ?:_model.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
        self.companyNameLabel.text = _model.typeName?:_model.merchantName;
        if (!_model.landline||_model.landline.length <= 0) {
            _model.landline = @"";
        }

        [self.phoneNumBtn setTitle:_model.landline forState:UIControlStateNormal];
        [self.phoneNumBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

        self.label3.hidden = NO;
        self.label4.hidden = NO;
        self.gongzhangNumberLabel.hidden = NO;
        self.supervisorNumberLabel.hidden = NO;

        // 案例
        self.caseNmuberLabel.text = _model.caseTotla;
        // 施工中
        self.designerNumberLabel.text = _model.constructionTotal;
        // 商品
        self.gongzhangNumberLabel.text = _model.total;
        // 展现量
        self.supervisorNumberLabel.text = _model.displayNumbers;

        self.locationLabel.text = [NSString stringWithFormat:@"[%@]", _model.locationStr];
        if ([_model.vipState isEqualToString:@"1"]) {
            self.vipImage.hidden = NO;
            //self.detailButton.hidden = NO;
            self.moreBtn.hidden = YES;
            self.moreImage.hidden = YES;
            [self.phoneNumBtn addGestureRecognizer:self.phoneNumTapGR];
        }else{
            self.vipImage.hidden = YES;
            //self.detailButton.hidden = YES;
            self.moreBtn.hidden = NO;
            self.moreImage.hidden = NO;
            [self.phoneNumBtn removeGestureRecognizer:self.phoneNumTapGR];
        }
        self.detailButton.layer.borderColor = [[UIColor redColor] CGColor];

        // 显示钻石
        if ([_model.recommendVip isEqualToString:@"1"]) {
            self.recommendVipIV.hidden = NO;
            self.vipIVLeftMarginCon.constant = 25;
        } else {
            self.recommendVipIV.hidden = YES;
            self.vipIVLeftMarginCon.constant = 5;
        }
    }
    if ([model isKindOfClass:[CompanyListModel class]]) {
        CompanyListModel *modelty = (CompanyListModel *)model;
        // 显示钻石
        if ([modelty.recommendVip isEqualToString:@"1"]) {
            self.recommendVipIV.hidden = NO;
            self.vipIVLeftMarginCon.constant = 25;
        } else {
            self.recommendVipIV.hidden = YES;
            self.vipIVLeftMarginCon.constant = 5;
        }
        if ([modelty.status isEqualToString:@"2"]) {
            self.certificateStatusView.hidden = NO;
        } else {
            self.certificateStatusView.hidden = YES;
        }
        self.companyId = modelty.companyId;
        [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:modelty.merchantLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
        self.companyNameLabel.text = modelty.companyName?:modelty.merchantName;
        if (!modelty.landline || modelty.landline.length <= 0) {
            modelty.landline = @"";
        }

        [self.phoneNumBtn setTitle:modelty.landline.length?modelty.landline:modelty.merchantLandline forState:UIControlStateNormal];
        [self.phoneNumBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

        // 案例
        self.caseNmuberLabel.text = modelty.caseTotla;
        // 施工中
        self.designerNumberLabel.text = modelty.constructionTotal;
        // 商品
        self.gongzhangNumberLabel.text = modelty.total;
        //        self.designerNumberLabel.text= @"99";
        //        self.gongzhangNumberLabel.text = @"88";
        // 展现量
        self.supervisorNumberLabel.text = modelty.displayNumbers;



        self.locationLabel.text = [NSString stringWithFormat:@"[%@]", modelty.countyName];//merchantLandline
        BOOL isVIP;
        long long cha = modelty.appVipEndTime - modelty.appVipStartTime;
        isVIP = false;
        if ([modelty.vipState isEqualToString:@"1"]) {
            isVIP = true;
        }
        if (cha > 0) {
            isVIP = true;
        }

        self.vipImage.hidden = !isVIP;
        //self.detailButton.hidden = !isVIP;
        self.moreBtn.hidden = isVIP;
        self.moreImage.hidden = isVIP;
        [self.phoneNumBtn addGestureRecognizer:self.phoneNumTapGR];
        self.detailButton.layer.borderColor = [[UIColor redColor] CGColor];
    }
    [self setTypeWithModel:model];
}

- (void)setTypeWithModel:(HomeBaseModel *)model {
    self.buttonRight.hidden = false;
    self.labelDetail3.hidden = false;
    self.labelDetail1.text = [NSString stringWithFormat:@"简介:%@",model.companyIntroduction];
    self.labelDetail2.text = [NSString stringWithFormat:@"[%@]%@",model.locationStr?:model.countyName,model.companyAddress?:@" "];
    [self.buttonRight setImage:nil forState:(UIControlStateNormal)];
    [self.buttonRight setTitleColor:basicColor forState:(UIControlStateNormal)];
    [self.buttonRight setTitle:@"" forState:(UIControlStateNormal)];
    self.viewAboutUs.hidden = true;
    switch (self.cellType) {
        case YellowPageCompanyTableViewCellTypeDistance:
            [self.buttonRight setImage:[UIImage imageNamed:@"icon_dingwei_nol"] forState:(UIControlStateNormal)];
         
            self.labelDetail3.text = model.distance;
            break;
        case YellowPageCompanyTableViewCellTypeLike:
            self.labelDetail3.text = model.flower;
            [self.buttonRight setTitle:@"好评数" forState:(UIControlStateNormal)];
            break;
        case YellowPageCompanyTableViewCellTypeCredit:
            self.labelDetail3.text = model.banner;
            [self.buttonRight setTitle:@"信用值" forState:(UIControlStateNormal)];
            break;
        case YellowPageCompanyTableViewCellTypeBrowse:
            self.labelDetail3.text = model.browse;
            [self.buttonRight setTitle:@"浏览量" forState:(UIControlStateNormal)];
            break;
        case YellowPageCompanyTableViewCellTypeCase:
            self.labelDetail3.text = model.caseTotla;
            [self.buttonRight setTitle:@"案例数" forState:(UIControlStateNormal)];
            break;
        case YellowPageCompanyTableViewCellTypeGoods:
            self.labelDetail3.text = model.praiseTotal;
            [self.buttonRight setTitle:@"商品数" forState:(UIControlStateNormal)];
            break;
        case YellowPageCompanyTableViewCellTypeAboutUs:
            self.viewAboutUs.hidden = false;
            self.labelDetail1.text = [NSString stringWithFormat:@"[%@]电话:%@",model.region?:@"", model.companyLandline?:@""];//[区]电话:
            self.labelDetail4.text = model.total?:@"0";//工地
            self.labelDetail5.text = model.displayNumbers?:@"0";//展现量
            [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
            self.companyNameLabel.text = model.companyName;
            break;
        case YellowPageCompanyTableViewCellTypeDefault:
            self.buttonRight.hidden = true;
            self.labelDetail3.hidden = true;
            [self.buttonRight setImage:nil forState:(UIControlStateNormal)];
            [self.buttonRight setTitleColor:basicColor forState:(UIControlStateNormal)];
            [self.buttonRight setTitle:@"" forState:(UIControlStateNormal)];
            [self cellTypeIsDefault:true];
            break;
        default:
            self.buttonRight.hidden = true;
            self.labelDetail3.hidden = true;
            [self.buttonRight setImage:nil forState:(UIControlStateNormal)];
            [self.buttonRight setTitleColor:basicColor forState:(UIControlStateNormal)];
            [self.buttonRight setTitle:@"" forState:(UIControlStateNormal)];
            [self cellTypeIsDefault:true];
            break;
    }
}

- (void)setCollecitonModel:(CollectionModel *)collecitonModel {
    CollectionModel *modelty = (CollectionModel *)collecitonModel;
    // 显示钻石
    self.labelDetail1.text = modelty.companyIntroduction;
    self.labelDetail2.text = [NSString stringWithFormat:@"[%@]%@",modelty.address,modelty.companyAddress?:@" "];
    if ([modelty.recommendVip isEqualToString:@"1"]) {
        self.recommendVipIV.hidden = NO;
        self.vipIVLeftMarginCon.constant = 25;
    } else {
        self.recommendVipIV.hidden = YES;
        self.vipIVLeftMarginCon.constant = 5;
    }
    //        self.companyId = modelty.companyId;
    if ([modelty.status isEqualToString:@"2"]) {
        self.certificateStatusView.hidden = NO;
    } else {
        self.certificateStatusView.hidden = YES;
    }
    self.companyId = modelty.companyId;
    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:modelty.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    self.companyNameLabel.text = modelty.companyName;

    if (!modelty.companyLandLine || modelty.companyLandLine.length <= 0) {
        modelty.companyLandLine = @"";
    }

    [self.phoneNumBtn setTitle:modelty.companyLandLine forState:UIControlStateNormal];
    [self.phoneNumBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

    // 案例
    self.caseNmuberLabel.text = modelty.caseTotal;
    // 施工中
    self.designerNumberLabel.text = [NSString stringWithFormat:@"%ld", modelty.constructionNum];
    // 商品
    self.gongzhangNumberLabel.text = [NSString stringWithFormat:@"%ld", modelty.goodsNum];
    // 展现量
    self.supervisorNumberLabel.text = modelty.displayNumbers;


    self.locationLabel.text = [NSString stringWithFormat:@"[%@]", modelty.address];

    if (modelty.time > 0) {
        self.vipImage.hidden = NO;
        //self.detailButton.hidden = NO;
        self.moreBtn.hidden = YES;
        self.moreImage.hidden = YES;
        [self.phoneNumBtn addGestureRecognizer:self.phoneNumTapGR];
    }else{
        self.vipImage.hidden = YES;
        //self.detailButton.hidden = YES;
        self.moreBtn.hidden = NO;
        self.moreImage.hidden = NO;
        [self.phoneNumBtn removeGestureRecognizer:self.phoneNumTapGR];
    }
    self.detailButton.layer.borderColor = [[UIColor redColor] CGColor];
}

- (void)setCooperateModel:(ZCHCooperateListModel *)cooperateModel {

    _cooperateModel = cooperateModel;
    // 显示钻石
    if ([_cooperateModel.recommendVip isEqualToString:@"1"]) {
        self.recommendVipIV.hidden = NO;
        self.vipIVLeftMarginCon.constant = 25;
    } else {
        self.recommendVipIV.hidden = YES;
        self.vipIVLeftMarginCon.constant = 5;
    }

    if ([cooperateModel.status isEqualToString:@"2"]) {
        self.certificateStatusView.hidden = NO;
    } else {
        self.certificateStatusView.hidden = YES;
    }
    self.companyId = cooperateModel.companyId.integerValue;
    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:cooperateModel.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    self.companyNameLabel.text = cooperateModel.companyName;
    if (!cooperateModel.companyLandline||cooperateModel.companyLandline.length <= 0) {
        cooperateModel.companyLandline = @"";
    }

    [self.phoneNumBtn setTitle:cooperateModel.companyLandline forState:UIControlStateNormal];
    [self.phoneNumBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];


    // 案例
    self.caseNmuberLabel.text = cooperateModel.caseTotla;
    // 施工中
    self.designerNumberLabel.text = cooperateModel.constructionTotal;
    // 商品
    self.gongzhangNumberLabel.text = cooperateModel.merchandiesCount;
    // 展现量
    self.supervisorNumberLabel.text = cooperateModel.displayNumbers;

    self.locationLabel.text = [NSString stringWithFormat:@"[%@]", cooperateModel.companyAddress?:@" "];
    if (![cooperateModel.appVip isEqualToString:@"0"]) {
        self.vipImage.hidden = NO;
        //self.detailButton.hidden = YES;
        self.moreBtn.hidden = YES;
        self.moreImage.hidden = YES;
        [self.phoneNumBtn addGestureRecognizer:self.phoneNumTapGR];
    }else{
        self.vipImage.hidden = YES;
        //self.detailButton.hidden = YES;
        self.moreBtn.hidden = YES;
        self.moreImage.hidden = YES;
        [self.phoneNumBtn removeGestureRecognizer:self.phoneNumTapGR];
    }
    self.detailButton.layer.borderColor = [[UIColor redColor] CGColor];
}

- (void)cellTypeIsDefault:(BOOL)isDefault {
    if (isDefault) {
        self.labelDetail1Less.priority = 998;
        self.labelDetail1More.priority = 999;
        self.labelDetail2Less.priority = 998;
        self.labelDetail2More.priority = 999;
    }else{
        self.labelDetail1Less.priority = 999;
        self.labelDetail1More.priority = 998;
        self.labelDetail2Less.priority = 999;
        self.labelDetail2More.priority = 998;
    }
}

- (IBAction)didClickPhoneNumBtn:(UIButton *)sender {

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
}


-(void)hiddenMoreBtn{
    self.moreImage.hidden = YES;
    self.moreBtn.hidden = YES;
}
@end
