//
//  YellowPageShopTableViewCell.m
//  iDecoration
//
//  Created by Apple on 2017/4/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "YellowPageShopTableViewCell.h"

@interface YellowPageShopTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *phoneNumBtn;

@property (nonatomic, assign) NSInteger shopID;

@property (nonatomic, strong) UITapGestureRecognizer *phoneNumTapGR;
@end

@implementation YellowPageShopTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreButtonTapAction:)];
    self.moreButton.userInteractionEnabled = YES;
    [self.moreButton addGestureRecognizer:tapGR];
    
    UITapGestureRecognizer *phoneNumTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneNumTapAction:)];
    self.phoneNumTapGR = phoneNumTapGR;
    self.phoneNumBtn.userInteractionEnabled = YES;
    [self.phoneNumBtn addGestureRecognizer:phoneNumTapGR];

}

- (void)moreButtonTapAction:(UITapGestureRecognizer *)tapGR {
    UIButton *sender = (UIButton *)tapGR.view;
    if ([self.delegate respondsToSelector:@selector(YellowPageShopTableViewCell:moreBtnClicked:)]) {
        sender.tag = self.shopID;
        [self.delegate YellowPageShopTableViewCell:self moreBtnClicked:sender];
    }
}

- (void)phoneNumTapAction:(UITapGestureRecognizer *)tapGR {
    UIButton *sender = (UIButton *)tapGR.view;
    
    if (!sender.titleLabel.text || [sender.titleLabel.text isEqual:[NSNull null]]) {
        return;
    }
    NSMutableString *stringM = [NSMutableString stringWithString:sender.titleLabel.text];
//    if ([stringM containsString:@"(114可查)"]) {
//        
//        stringM = [NSMutableString stringWithString:[stringM stringByReplacingOccurrencesOfString:@"(114可查)" withString:@""]];
//    }
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",stringM];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];

}


- (void)setModel:(HomeDefaultModel *)model{
    _model = model;
    // 显示钻石
    if ([model.recommendVip isEqualToString:@"1"]) {
        self.recommendVipIV.hidden = NO;
        self.vipIVLeftMarginCon.constant = 25;
    } else {
        self.recommendVipIV.hidden = YES;
        self.vipIVLeftMarginCon.constant = 5;
    }
    
    if ([model.status isEqualToString:@"2"]) {
        self.certificateStatusIV.hidden = NO;
    } else {
        self.certificateStatusIV.hidden = YES;
    }
    self.shopID = model.shopID.integerValue;
    
    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:model.typeLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    self.companyNameLabel.text = model.typeName;
    if (!_model.landline||_model.landline.length<=0) {
        _model.landline = @"";
    }
    [self.phoneNumBtn setTitle:model.landline forState:UIControlStateNormal];
    [self.phoneNumBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    self.label3.hidden = NO;
    self.label4.hidden = NO;
    self.browseNumberLabel.hidden = NO;
    self.collectNumberLabel.hidden = NO;
    self.labelDetail1.text = model.companyIntroduction;
    self.labelDetail2.text = [NSString stringWithFormat:@"[%@]%@",model.locationStr,model.companyAddress?:@" "];
    // 案例
    self.goodsNumberLabel.text = model.caseTotla;
    // 施工中
    self.showNumberLabel.text = model.constructionTotal;
    // 商品
    self.browseNumberLabel.text = model.total;
    // 展现量
    self.collectNumberLabel.text = model.displayNumbers;
    
    self.locationLabel.text = [NSString stringWithFormat:@"[%@]", model.locationStr];
    if (![model.vipState isEqualToString:@"0"]) {
        self.vipImage.hidden = NO;
        //self.detailButton.hidden = NO;
        self.moreImage.hidden = YES;
        self.moreButton.hidden = YES;
        [self.phoneNumBtn addGestureRecognizer:self.phoneNumTapGR];
        
    }else{
        self.vipImage.hidden = YES;
        //self.detailButton.hidden = YES;
        self.moreButton.hidden = NO;
        self.moreImage.hidden = NO;
        [self.phoneNumBtn removeGestureRecognizer:self.phoneNumTapGR];
    }
    self.detailButton.layer.borderColor = [[UIColor redColor] CGColor];
    
    // 显示钻石
    if ([model.recommendVip isEqualToString:@"1"]) {
        self.recommendVipIV.hidden = NO;
        self.vipIVLeftMarginCon.constant = 25;
    } else {
        self.recommendVipIV.hidden = YES;
        self.vipIVLeftMarginCon.constant = 5;
    }
    self.detailButton.hidden = true;
}

- (void)setShopListModel:(ShopListModel *)shopListModel {
    _shopListModel = shopListModel;
    // 显示钻石
    self.labelDetail1.text = [NSString stringWithFormat:@"[简介]%@",shopListModel.companyIntroduction];
    self.labelDetail2.text = shopListModel.address?:@" ";
    if ([shopListModel.recommendVip isEqualToString:@"1"]) {
        self.recommendVipIV.hidden = NO;
        self.vipIVLeftMarginCon.constant = 25;
    } else {
        self.recommendVipIV.hidden = YES;
        self.vipIVLeftMarginCon.constant = 5;
    }
    if ([shopListModel.status isEqualToString:@"2"]) {
        self.certificateStatusIV.hidden = NO;
    } else {
        self.certificateStatusIV.hidden = YES;
    }
    self.shopID = shopListModel.merchantId.integerValue;
    
    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:shopListModel.merchantLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    self.companyNameLabel.text = shopListModel.merchantName;
    [self.phoneNumBtn setTitle:shopListModel.merchantLandline forState:UIControlStateNormal];
    [self.phoneNumBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

    
//    self.goodsNumberLabel.text = shopListModel.total;
//    self.showNumberLabel.text = shopListModel.displayNumbers;

    // 案例
    self.goodsNumberLabel.text = _shopListModel.caseTotla;
    // 施工中
    self.showNumberLabel.text = _shopListModel.constructionTotal;
    // 商品
    self.browseNumberLabel.text = _shopListModel.total;
    // 展现量
    self.collectNumberLabel.text = _shopListModel.displayNumbers;
    
    self.locationLabel.text = [NSString stringWithFormat:@"[%@]", shopListModel.countyName];
    if (![shopListModel.vipState isEqualToString:@"0"]) {
        self.vipImage.hidden = NO;
        //self.detailButton.hidden = NO;
        self.moreImage.hidden = YES;
        self.moreButton.hidden = YES;
        [self.phoneNumBtn addGestureRecognizer:self.phoneNumTapGR];
        
    }else{
        self.vipImage.hidden = YES;
        //self.detailButton.hidden = YES;
        self.moreButton.hidden = NO;
        self.moreImage.hidden = NO;
        [self.phoneNumBtn removeGestureRecognizer:self.phoneNumTapGR];
    }
    self.detailButton.layer.borderColor = [[UIColor redColor] CGColor];
}

- (void)setCollectionModel:(CollectionModel *)collectionModel {
    _collectionModel = collectionModel;
    // 显示钻石
    if ([collectionModel.recommendVip isEqualToString:@"1"]) {
        self.recommendVipIV.hidden = NO;
        self.vipIVLeftMarginCon.constant = 25;
    } else {
        self.recommendVipIV.hidden = YES;
        self.vipIVLeftMarginCon.constant = 5;
    }
    if ([collectionModel.status isEqualToString:@"2"]) {
        self.certificateStatusIV.hidden = NO;
    } else {
        self.certificateStatusIV.hidden = YES;
    }
//    self.shopID = collectionModel.merchantId.integerValue;
    
    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:collectionModel.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    self.shopID = collectionModel.companyId;
    self.companyNameLabel.text = collectionModel.companyName;
    [self.phoneNumBtn setTitle:collectionModel.companyLandLine forState:UIControlStateNormal];
    [self.phoneNumBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    // 案例
    self.goodsNumberLabel.text = _collectionModel.caseTotal;
    // 施工中
    self.showNumberLabel.text = [NSString stringWithFormat:@"%ld", _collectionModel.constructionNum];
    // 商品
    self.browseNumberLabel.text = [NSString stringWithFormat:@"%ld", _collectionModel.goodsNum];
    // 展现量
    self.collectNumberLabel.text = _collectionModel.displayNumbers;
    
    
    self.locationLabel.text = [NSString stringWithFormat:@"[%@]", collectionModel.address];
    if (collectionModel.time > 0) {
        self.vipImage.hidden = NO;
        //self.detailButton.hidden = NO;
        self.moreImage.hidden = YES;
        self.moreButton.hidden = YES;
        [self.phoneNumBtn addGestureRecognizer:self.phoneNumTapGR];
    }else{
        self.vipImage.hidden = YES;
        //self.detailButton.hidden = YES;
        self.moreButton.hidden = NO;
        self.moreImage.hidden = NO;
        [self.phoneNumBtn removeGestureRecognizer:self.phoneNumTapGR];
        
    }
    self.detailButton.layer.borderColor = [[UIColor redColor] CGColor];
}

- (void)setCooperateModel:(ZCHCooperateListModel *)cooperateModel {
    
    _cooperateModel = cooperateModel;
    // 显示钻石
    if ([cooperateModel.recommendVip isEqualToString:@"1"]) {
        self.recommendVipIV.hidden = NO;
        self.vipIVLeftMarginCon.constant = 25;
    } else {
        self.recommendVipIV.hidden = YES;
        self.vipIVLeftMarginCon.constant = 5;
    }
    if ([cooperateModel.status isEqualToString:@"2"]) {
        self.certificateStatusIV.hidden = NO;
    } else {
        self.certificateStatusIV.hidden = YES;
    }
    self.shopID = cooperateModel.companyId.integerValue;
    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:cooperateModel.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    self.companyNameLabel.text = cooperateModel.companyName;
    if (!cooperateModel.companyLandline||cooperateModel.companyLandline.length <= 0) {
        cooperateModel.companyLandline = @"";
    }
    
    [self.phoneNumBtn setTitle:cooperateModel.companyLandline forState:UIControlStateNormal];
    [self.phoneNumBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
//    self.label1.text = @"商品";
//    self.label2.text = @"展现量";
//    self.goodsNumberLabel.text = cooperateModel.merchandiesCount;
//    self.showNumberLabel.text = cooperateModel.displayNumbers;
    
    // 案例
    self.goodsNumberLabel.text = _cooperateModel.caseTotla;
    // 施工中
    self.showNumberLabel.text = _cooperateModel.supervisorTotal;
    // 商品
    self.browseNumberLabel.text = _cooperateModel.merchandiesCount;
    // 展现量
    self.collectNumberLabel.text = _cooperateModel.displayNumbers;
    
    self.locationLabel.text = [NSString stringWithFormat:@"[%@]", cooperateModel.companyAddress];
    if (![cooperateModel.appVip isEqualToString:@"0"]) {
        self.vipImage.hidden = NO;
        //self.detailButton.hidden = YES;
        self.moreButton.hidden = YES;
        self.moreImage.hidden = YES;
        [self.phoneNumBtn addGestureRecognizer:self.phoneNumTapGR];
        
    }else{
        self.vipImage.hidden = YES;
        //self.detailButton.hidden = YES;
        self.moreButton.hidden = YES;
        self.moreImage.hidden = YES;
        [self.phoneNumBtn removeGestureRecognizer:self.phoneNumTapGR];
    }
    self.detailButton.layer.borderColor = [[UIColor redColor] CGColor];

    self.labelDetail1.text = @" ";
    self.labelDetail2.text = [NSString stringWithFormat:@"[%@]",cooperateModel.companyAddress];
}




- (IBAction)didClickPhoneNumBtn:(UIButton *)sender {
    
//    if (!sender.titleLabel.text || [sender.titleLabel.text isEqual:[NSNull null]]) {
//        return;
//    }
//    
//    NSMutableString *stringM = [NSMutableString stringWithString:sender.titleLabel.text];
//    if ([stringM containsString:@"(114可查)"]) {
//        
//        stringM = [NSMutableString stringWithString:[stringM stringByReplacingOccurrencesOfString:@"(114可查)" withString:@""]];
//    }
//    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",stringM];
//    UIWebView *callWebview = [[UIWebView alloc] init];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

- (IBAction)moreButtonClicked:(UIButton *)sender {
//    if ([self.delegate respondsToSelector:@selector(YellowPageShopTableViewCell:moreBtnClicked:)]) {
//        sender.tag = self.shopID;
//        [self.delegate YellowPageShopTableViewCell:self moreBtnClicked:sender];
//    }
}

- (void)hiddenMoreBtn {
    
    self.moreImage.hidden = YES;
    self.moreButton.hidden = YES;
}

@end
