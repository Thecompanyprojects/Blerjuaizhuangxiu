//
//  SiteTableViewCell.m
//  iDecoration
//
//  Created by RealSeven on 17/3/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SiteTableViewCell.h"
#import "MySiteModel.h"

@interface SiteTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;

@property (strong, nonatomic) UIButton *selectBtn;

@property (nonatomic, assign) NSInteger siteType; // 0 未交工   1 全部工地
@end

@implementation SiteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.stateBtn addTarget:self action:@selector(stateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _siteType = 0;
}

-(void)setSiteModel:(SiteModel *)siteModel{
    
    
    self.leftIcon.hidden = YES;
    self.rightIcon.hidden = YES;
    
    self.houseHoldLabel.text = [NSString stringWithFormat:@"户主：%@",siteModel.ccHouseholderName];
    self.nodeLabel.text = [siteModel.ccConstructionNodeId isEqualToString: @"2000"] ? @"洽谈合作" : siteModel.crRoleName;
    NSString *dateStr = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:siteModel.ccSrartTime];
    self.signDateLabel.text = [NSString stringWithFormat:@"%@",dateStr];
    self.locationLabel.text = [NSString stringWithFormat:@"%@",siteModel.ccAreaName];
    self.constructionCompanyLabel.text = [NSString stringWithFormat:@"%@",siteModel.ccBuilder];
    
    switch (siteModel.ccComplete) {
        case 0:
            self.stateBtn.hidden = YES;
            break;
        case 1:
            [self.stateBtn setTitle:@"确认交工" forState:UIControlStateNormal];
            self.stateBtn.hidden = NO;
            break;
        default:
            break;
    }
}

#pragma mark - 名片案例传值
- (void)setCardModel:(SiteModel *)cardModel {
    
    _cardModel = cardModel;
    self.leftIcon.hidden = YES;
    self.rightIcon.hidden = YES;
    self.houseHoldLabel.text = [NSString stringWithFormat:@"户主：%@",cardModel.ccHouseholderName];
    self.constructionCompanyLabel.text = [NSString stringWithFormat:@"%@",cardModel.ccBuilder];
    
    self.nodeLabel.text = [cardModel.ccConstructionNodeId isEqualToString: @"2000"]||[cardModel.ccConstructionNodeId isEqualToString: @"6000"] ? @"新日志" : cardModel.crRoleName;
    
    self.locationLabel.text = [NSString stringWithFormat:@"%@",cardModel.ccAreaName];
    NSString *dateStr = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:cardModel.ccSrartTime];
    self.signDateLabel.text = [NSString stringWithFormat:@"%@",dateStr];
}


-(void)configData:(id)data{
    
    self.leftIcon.hidden = YES;
    self.rightIcon.hidden = YES;
    if ([data isKindOfClass:[SiteModel class]]) { // 未交工的 以前的工地管理
        _siteType = 0;
        self.contentView.backgroundColor = [UIColor whiteColor];
        SiteModel *siteModel = data;
        self.houseHoldLabel.text = [NSString stringWithFormat:@"户主：%@",siteModel.ccHouseholderName];
        self.nodeLabel.text = [siteModel.ccConstructionNodeId isEqualToString: @"2000"]||[siteModel.ccConstructionNodeId isEqualToString: @"6000"] ? @"新日志" : siteModel.crRoleName;
        NSString *dateStr = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:siteModel.ccSrartTime];
        self.signDateLabel.text = [NSString stringWithFormat:@"%@",dateStr];
        self.locationLabel.text = [NSString stringWithFormat:@"%@",siteModel.ccAreaName];
        self.constructionCompanyLabel.text = [NSString stringWithFormat:@"%@",siteModel.ccBuilder];
        
        switch (siteModel.ccComplete) {
            case 0:
                self.stateBtn.hidden = YES;
                break;
                
            case 1:
                [self.stateBtn setTitle:@"确认交工" forState:UIControlStateNormal];
                
                if (siteModel.cpPersonId.length>0) {
                    self.stateBtn.hidden = NO;
                }else{
                    self.stateBtn.hidden = YES;
                }
                break;
                
            default:
                break;
        }
        
        if (self.bottomView) {
            [self.bottomView removeFromSuperview];
        }
        if (self.bannerBtn) {
            [self.bannerBtn removeFromSuperview];
        }
        if (self.flowerBtn) {
            [self.flowerBtn removeFromSuperview];
        }
        if (self.pushBtn) {
            [self.pushBtn removeFromSuperview];
        }
    }
    
    if ([data isKindOfClass:[MySiteModel class]]) {// 全部工地 以前的 我的工地
        _siteType = 1;
        MySiteModel *siteModel = data;
        
        if ([siteModel.top integerValue] > 0 && [siteModel.isYellow integerValue] > 0) {
            self.leftIcon.hidden = NO;
            self.rightIcon.hidden = NO;
            self.leftIcon.image = [UIImage imageNamed:@"sendCalculator"];
            self.rightIcon.image = [UIImage imageNamed:@"sendYellowPageSmall"];
        } else if ([siteModel.top integerValue] > 0) {
            self.leftIcon.hidden = NO;
            self.rightIcon.hidden = YES;
            self.leftIcon.image = [UIImage imageNamed:@"sendCalculator"];
        } else if ([siteModel.isYellow integerValue] > 0) {
            self.leftIcon.hidden = NO;
            self.rightIcon.hidden = YES;
            self.leftIcon.image = [UIImage imageNamed:@"sendYellowPageSmall"];
        }
        
        if ([siteModel.isTop integerValue] > 0) {
            self.contentView.backgroundColor = kCOLOR(220);
        } else {
            self.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        
        [self.contentView addSubview:self.bannerBtn];
        [self.contentView addSubview:self.flowerBtn];
        [self.contentView addSubview:self.pushBtn];
        
        if ([siteModel.positionNumber integerValue] > 0) {
            if (self.bottomView) {
                [self.bottomView removeFromSuperview];
            }
            [self.contentView addSubview:self.bottomView];
            self.selectBtn.selected = [siteModel.isDisplay integerValue] == 1 ? YES : NO;
            self.bottomView.frame = CGRectMake(0, self.constructionCompanyLabel.bottom+5, BLEJWidth, 30);
            
            self.bannerBtn.frame = CGRectMake(kSCREEN_WIDTH/2-25, self.bottomView.bottom+10, 50, 20);
            self.flowerBtn.frame = CGRectMake(10,self.bannerBtn.top,self.bannerBtn.width,self.bannerBtn.height);
            self.pushBtn.frame = CGRectMake(kSCREEN_WIDTH-60, self.bannerBtn.top, self.bannerBtn.width, self.bannerBtn.height);
            
        } else {
            
            if (_bottomView != nil) {
                [self.bottomView removeFromSuperview];
            }
            
            self.bannerBtn.frame = CGRectMake(kSCREEN_WIDTH/2-25, self.constructionCompanyLabel.bottom+10, 50, 20);
            self.flowerBtn.frame = CGRectMake(10,self.bannerBtn.top,self.bannerBtn.width,self.bannerBtn.height);
            self.pushBtn.frame = CGRectMake(kSCREEN_WIDTH-60, self.bannerBtn.top, self.bannerBtn.width, self.bannerBtn.height);
        }
        
        
        
        
        self.houseHoldLabel.text = [NSString stringWithFormat:@"户主：%@",siteModel.ccHouseholderName];
        self.nodeLabel.text = [siteModel.ccConstructionNodeId isEqualToString: @"2000"] ? @"新日志" : siteModel.crRoleName;
        NSString *dateStr = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:siteModel.ccSrartTime];
        self.signDateLabel.text = [NSString stringWithFormat:@"开工日期：%@",dateStr];
        self.locationLabel.text = [NSString stringWithFormat:@"小区名称：%@",siteModel.ccAreaName];
        self.constructionCompanyLabel.text = [NSString stringWithFormat:@"施工单位：%@",siteModel.ccBuilder];

        NSInteger cccomplete = [siteModel.ccComplete integerValue];
        switch (cccomplete) {
            case 0:
                self.stateBtn.hidden = YES;
                break;
                
            case 1:
                [self.stateBtn setTitle:@"确认交工" forState:UIControlStateNormal];
                if ([siteModel.positionNumber integerValue]>0) {
                    self.stateBtn.hidden = NO;
                }else{
                    self.stateBtn.hidden = YES;
                }
                self.stateBtn.tag = 1;
                break;
            case 2:
                [self.stateBtn setTitle:@"去评论" forState:UIControlStateNormal];
                if ([siteModel.isProprietor integerValue]>0) {
                    self.stateBtn.hidden = NO;
                    self.stateBtn.tag = 2;
                }else{

                }
                break;
            case 3:
                [self.stateBtn setTitle:@"已评论" forState:UIControlStateNormal];
                self.stateBtn.hidden = NO;
                self.stateBtn.tag = 3;
                break;
                
            default:
                break;
        }
    }
}

-(UIButton *)bannerBtn{
    if (!_bannerBtn) {
        _bannerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bannerBtn.frame = CGRectMake(kSCREEN_WIDTH/2-25, self.bottomView.bottom+10, 50, 20);
        [_bannerBtn setTitle:@"锦旗" forState:UIControlStateNormal];
        [_bannerBtn setImage:[UIImage imageNamed:@"silk"] forState:UIControlStateNormal];
        _bannerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [_bannerBtn setTitleColor:COLOR_BLACK_CLASS_6 forState:UIControlStateNormal];
        _bannerBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        [_bannerBtn addTarget:self action:@selector(bannerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bannerBtn;
}

-(UIButton *)flowerBtn{
    if (!_flowerBtn) {
        _flowerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _flowerBtn.frame = CGRectMake(10,self.bannerBtn.top,self.bannerBtn.width,self.bannerBtn.height);
        [_flowerBtn setTitle:@"鲜花" forState:UIControlStateNormal];
        _flowerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [_flowerBtn setImage:[UIImage imageNamed:@"flower"] forState:UIControlStateNormal];
        [_flowerBtn setTitleColor:COLOR_BLACK_CLASS_6 forState:UIControlStateNormal];
        _flowerBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        
        [_flowerBtn addTarget:self action:@selector(flowerClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flowerBtn;
}




-(UIButton *)pushBtn{
    if (!_pushBtn) {
        _pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pushBtn.frame = CGRectMake(kSCREEN_WIDTH-60, self.bannerBtn.top, self.bannerBtn.width, self.bannerBtn.height);
        [_pushBtn setTitle:@"推送" forState:UIControlStateNormal];
        [_pushBtn setImage:[UIImage imageNamed:@"push"] forState:UIControlStateNormal];
        _pushBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [_pushBtn setTitleColor:COLOR_BLACK_CLASS_6 forState:UIControlStateNormal];
        _pushBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        
        [_pushBtn addTarget:self action:@selector(pushClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushBtn;
}

- (UIView *)bottomView {
    
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.constructionCompanyLabel.bottom+5, BLEJWidth, 30)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.locationLabel.left, 0, 200, 30)];
        label.text = @"是否在企业网显示";
        label.font = NB_FONTSEIZ_NOR;
        label.textColor = COLOR_BLACK_CLASS_6;
        label.textAlignment = NSTextAlignmentLeft;
        [_bottomView addSubview:label];
        
        UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 40, 0, 30, 30)];
        [selectBtn setImage:[UIImage imageNamed:@"meixuanzhong"] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
        selectBtn.selected = YES;
        [selectBtn addTarget:self action:@selector(didClickIsSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.selectBtn = selectBtn;
        [_bottomView addSubview:selectBtn];
    }
    return _bottomView;
}

-(void)bannerClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(HanBannerWith:)]) {
        [self.delegate HanBannerWith:self.path];
    }
}

-(void)flowerClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(HandFlowerWith:)]) {
        [self.delegate HandFlowerWith:self.path];
    }
}

-(void)pushClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(HandPushWith:)]) {
        [self.delegate HandPushWith:self.path];
    }
}

-(void)stateBtnClick:(UIButton *)sender{
    if (_siteType == 0) { // 未交工
        if ([self.delegate respondsToSelector:@selector(HandleccompleteWith:)]) {
            [self.delegate HandleccompleteWith:self.path];
        }
    }
    
    if (_siteType == 1) { // 全部工地
        if ([self.delegate respondsToSelector:@selector(HandleccompleteWith:tag:)]) {
            [self.delegate HandleccompleteWith:self.path tag:sender.tag];
        }
    }
}

#pragma mark - 是否在企业网显示点击事件
- (void)didClickIsSelectBtn:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(didClickIsSelectBtn:)]) {
        
        btn.selected = !btn.selected;
        [self.delegate didClickIsSelectBtn:self.path];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
