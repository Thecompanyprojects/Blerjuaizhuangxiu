//
//  ZCHCooperateAndUnionCell.m
//  iDecoration
//
//  Created by 赵春浩 on 2017/11/23.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCooperateAndUnionCell.h"
#import "ZCHCooperateListModel.h"

@interface ZCHCooperateAndUnionCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipTagView;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet UILabel *landlineLabel;

@end


@implementation ZCHCooperateAndUnionCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer *phoneNumTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneNumTapAction:)];
    self.landlineLabel.userInteractionEnabled = YES;
    [self.landlineLabel addGestureRecognizer:phoneNumTapGR];
}

- (void)phoneNumTapAction:(UITapGestureRecognizer *)tapGR {
    
    if (self.model && ![self.model.companyLandline isEqual:[NSNull null]] && self.model.companyLandline && ![self.model.companyLandline isEqualToString:@""]) {
        
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.model.companyLandline];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
    }
    
    if (self.unionModel && ![self.unionModel.companyLandline isEqual:[NSNull null]] && self.unionModel.companyLandline && ![self.unionModel.companyLandline isEqualToString:@""]) {
        
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.unionModel.companyLandline];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
    }
}

- (void)setModel:(ZCHCooperateListModel *)model {
    
    _model = model;
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    self.nameLabel.text = model.companyName;
    self.typeLabel.text = model.typeName;
    
    [self.applyBtn setTitle:@"申请" forState:UIControlStateNormal];
    // kCustomColor(234, 104, 72)
    [self.applyBtn setBackgroundColor:kMainThemeColor];
    
    if (!model.companyLandline||model.companyLandline.length <= 0) {
        model.companyLandline = @"";
    }
    if ([model.companyId isEqualToString:self.currentCompanyId]) {
        
        self.applyBtn.hidden = YES;
    } else {
        
        self.applyBtn.hidden = NO;
    }
    if (![model.appVip isEqualToString:@"0"]) {
        
        self.vipTagView.hidden = NO;
    } else {
        
        self.vipTagView.hidden = YES;
    }
    self.areaLabel.text = [NSString stringWithFormat:@"[%@]", model.companyAddress];
    self.displayCountLabel.text = model.displayNumbers;
    self.landlineLabel.text = [NSString stringWithFormat:@"座机：%@", model.companyLandline];
}

- (void)setUnionModel:(ZCHCooperateListModel *)unionModel {
    
    _unionModel = unionModel;
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:unionModel.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    self.nameLabel.text = unionModel.companyName;
    self.typeLabel.text = unionModel.typeName;
    
    [self.applyBtn setTitle:@"申请" forState:UIControlStateNormal];
    // kCustomColor(234, 104, 72)
    [self.applyBtn setBackgroundColor:kMainThemeColor];
    self.applyBtn.hidden = NO;
    if (!unionModel.companyLandline||unionModel.companyLandline.length <= 0) {
        
        unionModel.companyLandline = @"";
    }
    if (![unionModel.appVip isEqualToString:@"0"]) {
        
        self.vipTagView.hidden = NO;
    } else {
        
        self.vipTagView.hidden = YES;
    }
    self.areaLabel.text = [NSString stringWithFormat:@"[%@]", unionModel.cityName];
    self.displayCountLabel.text = unionModel.displayNumber;
    self.landlineLabel.text = [NSString stringWithFormat:@"座机：%@", unionModel.companyLandline];
}


- (IBAction)didClickApplyBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickApplyBtnWithIndexPath:)]) {
        
        [self.delegate didClickApplyBtnWithIndexPath:self.indexPath];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
