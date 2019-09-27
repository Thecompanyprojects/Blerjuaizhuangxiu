//
//  localsearchCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localsearchCell.h"
#import "localsearchModel.h"
//    [self.contentLab setMaxNumberOfLinesToShow:2];

@interface localsearchCell()
@property (nonatomic,strong) UIImageView *noteleftImg;
@property (nonatomic,strong) UILabel *notetitleLab;
@property (nonatomic,strong) UILabel *notecontentLab;
@property (nonatomic,strong) UILabel *notetimeLab;

@property (nonatomic,strong) UIImageView *carleftImg;
@property (nonatomic,strong) UILabel *cartitleLab;
@property (nonatomic,strong) UILabel *carcontentLab;
@property (nonatomic,strong) UILabel *cartypeLab;

@property (nonatomic,strong) UIImageView *sitebigImg;
@property (nonatomic,strong) UILabel *sitenameLab;
@property (nonatomic,strong) UILabel *sitestyleLab;
@property (nonatomic,strong) UILabel *siteaddressLab;

@property (nonatomic,strong) UIImageView *comiconImg;
@property (nonatomic,strong) UILabel *comnameLab;
@property (nonatomic,strong) UILabel *comcontentLab;
@property (nonatomic,strong) UILabel *comaddressLab;

@property (nonatomic,strong) UIImageView *goodsleftImg;
@property (nonatomic,strong) UILabel *goodsnameLab;
@property (nonatomic,strong) UILabel *goodsmoneyLab;

@property (nonatomic,strong) UIImageView *acticonImg;
@property (nonatomic,strong) UILabel *actnameLab;
@property (nonatomic,strong) UILabel *actaddressLab;
@property (nonatomic,strong) UIImageView *actleftImg;
@property (nonatomic,strong) UILabel *acttitleLab;
@property (nonatomic,strong) UILabel *acttimeLab;
@property (nonatomic,strong) UILabel *actcityLab;
@property (nonatomic,strong) UILabel *acttypeLab;
@end

@implementation localsearchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.noteleftImg];
        [self.contentView addSubview:self.notetitleLab];
        [self.contentView addSubview:self.notecontentLab];
        [self.contentView addSubview:self.notetimeLab];
        
        [self.contentView addSubview:self.carleftImg];
        [self.contentView addSubview:self.cartitleLab];
        [self.contentView addSubview:self.carcontentLab];
        [self.contentView addSubview:self.cartypeLab];
        
        [self.contentView addSubview:self.sitebigImg];
        [self.contentView addSubview:self.sitenameLab];
        [self.contentView addSubview:self.sitestyleLab];
        [self.contentView addSubview:self.siteaddressLab];
        
        [self.contentView addSubview:self.comiconImg];
        [self.contentView addSubview:self.comnameLab];
        [self.contentView addSubview:self.comcontentLab];
        [self.contentView addSubview:self.comaddressLab];
        
        [self.contentView addSubview:self.goodsleftImg];
        [self.contentView addSubview:self.goodsnameLab];
        [self.contentView addSubview:self.goodsmoneyLab];
        
        [self.contentView addSubview:self.acticonImg];
        [self.contentView addSubview:self.actnameLab];
        [self.contentView addSubview:self.actaddressLab];
        [self.contentView addSubview:self.actleftImg];
        [self.contentView addSubview:self.acttitleLab];
        [self.contentView addSubview:self.acttimeLab];
        [self.contentView addSubview:self.actcityLab];
        [self.contentView addSubview:self.acttypeLab];
        
        [self setuplayout0];
    }
    return self;
}

-(void)setdata:(localsearchModel *)model
{
    /*
     type = 0 公司
     type = 1 商品
     type = 2 活动
     type = 3 工地
     type = 4 美文
     type = 5 计算器
     */
    switch (model.type) {
        case 0:
            [self.comiconImg sd_setImageWithURL:[NSURL URLWithString:model.coveMap]];
            self.comnameLab.text = model.cname;
            self.comcontentLab.text = [NSString stringWithFormat:@"%@%@",@"简介",model.companyIntroduction];
            self.comaddressLab.text = [NSString stringWithFormat:@"%@%@",@"[地址]:",model.companyAddress];
         
            [self setuplayout3];
            [self.comcontentLab setMaxNumberOfLinesToShow:1];
            [self.comaddressLab setMaxNumberOfLinesToShow:1];
            break;
        
        case 1:
            [self.goodsleftImg sd_setImageWithURL:[NSURL URLWithString:model.coveMap]];
            self.goodsnameLab.text = model.cname;
            self.goodsmoneyLab.text = [NSString stringWithFormat:@"%@%@",@"￥",model.caddress?:@""];
            [self setuplayout4];
            [self.goodsnameLab setMaxNumberOfLinesToShow:2];
            break;
        
        case 2:
            [self.acticonImg sd_setImageWithURL:[NSURL URLWithString:model.templatePic]];
            self.actnameLab.text = model.locationStr?:@"";
            self.actaddressLab.text = [NSString stringWithFormat:@"%@%@",@"地址：",model.companyAddress?:@""];
            [self.actleftImg sd_setImageWithURL:[NSURL URLWithString:model.coveMap]];
            self.acttitleLab.text = model.cname?:@"";
            self.actaddressLab.text = model.caddress?:@"";
            self.acttimeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.appVip];
            if ([model.svip isEqualToString:@"0"]) {
                self.acttypeLab.text = @"已结束";
            }
            else
            {
                self.acttypeLab.text = @"进行中";
            }
            self.actcityLab.text = model.companyAddress?:@"";
            [self setuplayout5];
            break;
        
        case 3:
            [self.sitebigImg sd_setImageWithURL:[NSURL URLWithString:model.coveMap]];
            self.sitenameLab.text = model.cname;
            self.sitestyleLab.text = [NSString stringWithFormat:@"%@%@%@",model.locationStr,@"㎡ ",model.companyAddress];
            self.siteaddressLab.text = model.companyIntroduction;
            [self setuplayout2];
            
            break;
        
        case 4:
            [self.noteleftImg sd_setImageWithURL:[NSURL URLWithString:model.coveMap]];
            self.notetitleLab.text = model.cname;
            self.notecontentLab.text = model.companyIntroduction;
        
            self.notetimeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.appVip];
            [self setuplayout0];
            [self.notecontentLab setMaxNumberOfLinesToShow:2];
            break;
        case 5:
            [self.carleftImg sd_setImageWithURL:[NSURL URLWithString:model.coveMap]];
            self.cartitleLab.text = model.cname;
            [self setuplayout1];
            break;
        default:
            break;
    }
}

//美文
-(void)setuplayout0
{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.noteleftImg setHidden:NO];
    [weakSelf.notetitleLab setHidden:NO];
    [weakSelf.notecontentLab setHidden:NO];
    [weakSelf.notetimeLab setHidden:NO];
    
    [weakSelf.carleftImg setHidden:YES];
    [weakSelf.cartitleLab setHidden:YES];
    [weakSelf.carcontentLab setHidden:YES];
    [weakSelf.cartypeLab setHidden:YES];

    [weakSelf.sitebigImg setHidden:YES];
    [weakSelf.sitenameLab setHidden:YES];
    [weakSelf.sitestyleLab setHidden:YES];
    [weakSelf.siteaddressLab setHidden:YES];

    [weakSelf.comiconImg setHidden:YES];
    [weakSelf.comnameLab setHidden:YES];
    [weakSelf.comcontentLab setHidden:YES];
    [weakSelf.comaddressLab setHidden:YES];
    
    [weakSelf.goodsleftImg setHidden:YES];
    [weakSelf.goodsnameLab setHidden:YES];
    [weakSelf.goodsmoneyLab setHidden:YES];
    
    [weakSelf.acticonImg setHidden:YES];
    [weakSelf.actnameLab setHidden:YES];
    [weakSelf.actaddressLab setHidden:YES];
    [weakSelf.actleftImg setHidden:YES];
    [weakSelf.acttitleLab setHidden:YES];
    [weakSelf.acttimeLab setHidden:YES];
    [weakSelf.actcityLab setHidden:YES];
    [weakSelf.acttypeLab setHidden:YES];
    
    
    weakSelf.noteleftImg
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 11)
    .topSpaceToView(weakSelf.contentView, 27)
    .widthIs(104)
    .heightIs(70);
    
    weakSelf.notetitleLab
    .sd_layout
    .leftSpaceToView(weakSelf.noteleftImg, 10)
    .topEqualToView(weakSelf.noteleftImg)
    .rightSpaceToView(weakSelf.contentView, 10)
    .autoHeightRatio(0);
    
    weakSelf.notecontentLab
    .sd_layout
    .leftEqualToView(weakSelf.notetitleLab)
    .rightEqualToView(weakSelf.notetitleLab)
    .topSpaceToView(weakSelf.notetitleLab, 7)
    .autoHeightRatio(0);
    
    weakSelf.notetimeLab
    .sd_layout
    .leftEqualToView(weakSelf.notetitleLab)
    .rightEqualToView(weakSelf.notetitleLab)
    .topSpaceToView(weakSelf.notecontentLab, 8)
    .autoHeightRatio(0);
    
    [weakSelf setupAutoHeightWithBottomView:weakSelf.notetimeLab bottomMargin:22];
    
}
//计算器
-(void)setuplayout1
{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.noteleftImg setHidden:YES];
    [weakSelf.notetitleLab setHidden:YES];
    [weakSelf.notecontentLab setHidden:YES];
    [weakSelf.notetimeLab setHidden:YES];
    
    [weakSelf.carleftImg setHidden:NO];
    [weakSelf.cartitleLab setHidden:NO];
    [weakSelf.carcontentLab setHidden:NO];
    [weakSelf.cartypeLab setHidden:NO];
    
    [weakSelf.sitebigImg setHidden:YES];
    [weakSelf.sitenameLab setHidden:YES];
    [weakSelf.sitestyleLab setHidden:YES];
    [weakSelf.siteaddressLab setHidden:YES];
    
    [weakSelf.comiconImg setHidden:YES];
    [weakSelf.comnameLab setHidden:YES];
    [weakSelf.comcontentLab setHidden:YES];
    [weakSelf.comaddressLab setHidden:YES];
    
    [weakSelf.goodsleftImg setHidden:YES];
    [weakSelf.goodsnameLab setHidden:YES];
    [weakSelf.goodsmoneyLab setHidden:YES];
    
    [weakSelf.acticonImg setHidden:YES];
    [weakSelf.actnameLab setHidden:YES];
    [weakSelf.actaddressLab setHidden:YES];
    [weakSelf.actleftImg setHidden:YES];
    [weakSelf.acttitleLab setHidden:YES];
    [weakSelf.acttimeLab setHidden:YES];
    [weakSelf.actcityLab setHidden:YES];
    [weakSelf.acttypeLab setHidden:YES];
    
    weakSelf.carleftImg
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 11)
    .topSpaceToView(weakSelf.contentView, 19)
    .widthIs(98)
    .heightIs(84);
    
    weakSelf.cartitleLab
    .sd_layout
    .leftSpaceToView(weakSelf.carleftImg, 10)
    .rightSpaceToView(weakSelf.contentView, 10)
    .topEqualToView(weakSelf.carleftImg)
    .autoWidthRatio(0);
    
    weakSelf.carcontentLab
    .sd_layout
    .leftEqualToView(weakSelf.cartitleLab)
    .rightEqualToView(weakSelf.cartitleLab)
    .topSpaceToView(weakSelf.cartitleLab, 14)
    .autoWidthRatio(0);
    
    weakSelf.cartypeLab
    .sd_layout
    .leftEqualToView(weakSelf.cartitleLab)
    .topSpaceToView(weakSelf.carcontentLab, 13)
    .widthIs(56)
    .heightIs(18);
    
    [weakSelf setupAutoHeightWithBottomView:weakSelf.carleftImg bottomMargin:19];
}
//工地
-(void)setuplayout2
{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.noteleftImg setHidden:YES];
    [weakSelf.notetitleLab setHidden:YES];
    [weakSelf.notecontentLab setHidden:YES];
    [weakSelf.notetimeLab setHidden:YES];
    
    [weakSelf.carleftImg setHidden:YES];
    [weakSelf.cartitleLab setHidden:YES];
    [weakSelf.carcontentLab setHidden:YES];
    [weakSelf.cartypeLab setHidden:YES];
    
    [weakSelf.sitebigImg setHidden:NO];
    [weakSelf.sitenameLab setHidden:NO];
    [weakSelf.sitestyleLab setHidden:NO];
    [weakSelf.siteaddressLab setHidden:NO];
    
    [weakSelf.comiconImg setHidden:YES];
    [weakSelf.comnameLab setHidden:YES];
    [weakSelf.comcontentLab setHidden:YES];
    [weakSelf.comaddressLab setHidden:YES];
    
    [weakSelf.goodsleftImg setHidden:YES];
    [weakSelf.goodsnameLab setHidden:YES];
    [weakSelf.goodsmoneyLab setHidden:YES];
    
    [weakSelf.acticonImg setHidden:YES];
    [weakSelf.actnameLab setHidden:YES];
    [weakSelf.actaddressLab setHidden:YES];
    [weakSelf.actleftImg setHidden:YES];
    [weakSelf.acttitleLab setHidden:YES];
    [weakSelf.acttimeLab setHidden:YES];
    [weakSelf.actcityLab setHidden:YES];
    [weakSelf.acttypeLab setHidden:YES];
    
    weakSelf.sitebigImg
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 11)
    .rightSpaceToView(weakSelf.contentView, 11)
    .topSpaceToView(weakSelf.contentView, 19)
    .heightIs(159);
    
    weakSelf.sitenameLab
    .sd_layout
    .leftEqualToView(weakSelf.sitebigImg)
    .rightEqualToView(weakSelf.sitebigImg)
    .topSpaceToView(weakSelf.sitebigImg, 8)
    .autoHeightRatio(0);
    
    weakSelf.sitestyleLab
    .sd_layout
    .leftEqualToView(weakSelf.sitebigImg)
    .rightEqualToView(weakSelf.sitebigImg)
    .topSpaceToView(weakSelf.sitenameLab, 8)
    .autoHeightRatio(0);
    
    weakSelf.siteaddressLab
    .sd_layout
    .leftEqualToView(weakSelf.sitebigImg)
    .rightEqualToView(weakSelf.sitebigImg)
    .topSpaceToView(weakSelf.sitestyleLab, 8)
    .autoHeightRatio(0);
    
    [weakSelf setupAutoHeightWithBottomView:weakSelf.siteaddressLab bottomMargin:19];
}
//公司
-(void)setuplayout3
{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.noteleftImg setHidden:YES];
    [weakSelf.notetitleLab setHidden:YES];
    [weakSelf.notecontentLab setHidden:YES];
    [weakSelf.notetimeLab setHidden:YES];
    
    [weakSelf.carleftImg setHidden:YES];
    [weakSelf.cartitleLab setHidden:YES];
    [weakSelf.carcontentLab setHidden:YES];
    [weakSelf.cartypeLab setHidden:YES];
    
    [weakSelf.sitebigImg setHidden:YES];
    [weakSelf.sitenameLab setHidden:YES];
    [weakSelf.sitestyleLab setHidden:YES];
    [weakSelf.siteaddressLab setHidden:YES];
    
    [weakSelf.comiconImg setHidden:NO];
    [weakSelf.comnameLab setHidden:NO];
    [weakSelf.comcontentLab setHidden:NO];
    [weakSelf.comaddressLab setHidden:NO];
    
    [weakSelf.goodsleftImg setHidden:YES];
    [weakSelf.goodsnameLab setHidden:YES];
    [weakSelf.goodsmoneyLab setHidden:YES];
    
    [weakSelf.acticonImg setHidden:YES];
    [weakSelf.actnameLab setHidden:YES];
    [weakSelf.actaddressLab setHidden:YES];
    [weakSelf.actleftImg setHidden:YES];
    [weakSelf.acttitleLab setHidden:YES];
    [weakSelf.acttimeLab setHidden:YES];
    [weakSelf.actcityLab setHidden:YES];
    [weakSelf.acttypeLab setHidden:YES];
    
    weakSelf.comiconImg
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 13)
    .topSpaceToView(weakSelf.contentView, 19)
    .widthIs(84)
    .heightIs(84);
    
    weakSelf.comnameLab
    .sd_layout
    .leftSpaceToView(weakSelf.comiconImg, 10)
    .rightSpaceToView(weakSelf.contentView, 12)
    .topEqualToView(weakSelf.comiconImg)
    .autoHeightRatio(0);
    
    weakSelf.comcontentLab
    .sd_layout
    .leftEqualToView(weakSelf.comnameLab)
    .rightEqualToView(weakSelf.comnameLab)
    .topSpaceToView(weakSelf.comnameLab, 19)
    .autoHeightRatio(0);
    
    weakSelf.comaddressLab
    .sd_layout
    .leftEqualToView(weakSelf.comnameLab)
    .rightEqualToView(weakSelf.comnameLab)
    .topSpaceToView(weakSelf.comcontentLab, 11)
    .autoHeightRatio(0);
    
    [weakSelf setupAutoHeightWithBottomView:weakSelf.comiconImg bottomMargin:19];
    
}
//商品
-(void)setuplayout4
{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.noteleftImg setHidden:YES];
    [weakSelf.notetitleLab setHidden:YES];
    [weakSelf.notecontentLab setHidden:YES];
    [weakSelf.notetimeLab setHidden:YES];
    
    [weakSelf.carleftImg setHidden:YES];
    [weakSelf.cartitleLab setHidden:YES];
    [weakSelf.carcontentLab setHidden:YES];
    [weakSelf.cartypeLab setHidden:YES];
    
    [weakSelf.sitebigImg setHidden:YES];
    [weakSelf.sitenameLab setHidden:YES];
    [weakSelf.sitestyleLab setHidden:YES];
    [weakSelf.siteaddressLab setHidden:YES];
    
    [weakSelf.comiconImg setHidden:YES];
    [weakSelf.comnameLab setHidden:YES];
    [weakSelf.comcontentLab setHidden:YES];
    [weakSelf.comaddressLab setHidden:YES];
    
    [weakSelf.goodsleftImg setHidden:NO];
    [weakSelf.goodsnameLab setHidden:NO];
    [weakSelf.goodsmoneyLab setHidden:NO];
    
    [weakSelf.acticonImg setHidden:YES];
    [weakSelf.actnameLab setHidden:YES];
    [weakSelf.actaddressLab setHidden:YES];
    [weakSelf.actleftImg setHidden:YES];
    [weakSelf.acttitleLab setHidden:YES];
    [weakSelf.acttimeLab setHidden:YES];
    [weakSelf.actcityLab setHidden:YES];
    [weakSelf.acttypeLab setHidden:YES];
    
    weakSelf.goodsleftImg
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 14)
    .topSpaceToView(weakSelf.contentView, 19)
    .widthIs(101)
    .heightIs(93);
    
    weakSelf.goodsnameLab
    .sd_layout
    .leftSpaceToView(weakSelf.goodsleftImg, 10)
    .topEqualToView(weakSelf.goodsleftImg)
    .rightSpaceToView(weakSelf.contentView, 14)
    .autoHeightRatio(0);
    
    weakSelf.goodsmoneyLab
    .sd_layout
    .leftEqualToView(weakSelf.goodsnameLab)
    .rightEqualToView(weakSelf.goodsnameLab)
    .bottomEqualToView(weakSelf.goodsleftImg)
    .autoHeightRatio(0);
    
    
    [weakSelf setupAutoHeightWithBottomView:weakSelf.goodsleftImg bottomMargin:19];
}
//活动
-(void)setuplayout5
{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.noteleftImg setHidden:YES];
    [weakSelf.notetitleLab setHidden:YES];
    [weakSelf.notecontentLab setHidden:YES];
    [weakSelf.notetimeLab setHidden:YES];
    
    [weakSelf.carleftImg setHidden:YES];
    [weakSelf.cartitleLab setHidden:YES];
    [weakSelf.carcontentLab setHidden:YES];
    [weakSelf.cartypeLab setHidden:YES];
    
    [weakSelf.sitebigImg setHidden:YES];
    [weakSelf.sitenameLab setHidden:YES];
    [weakSelf.sitestyleLab setHidden:YES];
    [weakSelf.siteaddressLab setHidden:YES];
    
    [weakSelf.comiconImg setHidden:YES];
    [weakSelf.comnameLab setHidden:YES];
    [weakSelf.comcontentLab setHidden:YES];
    [weakSelf.comaddressLab setHidden:YES];
    
    [weakSelf.goodsleftImg setHidden:YES];
    [weakSelf.goodsnameLab setHidden:YES];
    [weakSelf.goodsmoneyLab setHidden:YES];
    
    [weakSelf.acticonImg setHidden:NO];
    [weakSelf.actnameLab setHidden:NO];
    [weakSelf.actaddressLab setHidden:NO];
    [weakSelf.actleftImg setHidden:NO];
    [weakSelf.acttitleLab setHidden:NO];
    [weakSelf.acttimeLab setHidden:NO];
    [weakSelf.actcityLab setHidden:NO];
    [weakSelf.acttypeLab setHidden:NO];
    
    weakSelf.acticonImg
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 14)
    .topSpaceToView(weakSelf.contentView, 19)
    .widthIs(40)
    .heightIs(40);
    
    weakSelf.actnameLab
    .sd_layout
    .leftSpaceToView(weakSelf.acticonImg, 10)
    .rightSpaceToView(weakSelf.contentView, 13)
    .topEqualToView(weakSelf.acticonImg)
    .autoHeightRatio(0);
    
    weakSelf.actaddressLab
    .sd_layout
    .leftEqualToView(weakSelf.actnameLab)
    .rightEqualToView(weakSelf.actnameLab)
    .bottomEqualToView(weakSelf.acticonImg)
    .autoHeightRatio(0);
    
    weakSelf.actleftImg
    .sd_layout
    .topSpaceToView(weakSelf.actaddressLab, 26)
    .leftEqualToView(weakSelf.acticonImg)
    .widthIs(168)
    .heightIs(99);
    
    weakSelf.acttitleLab
    .sd_layout
    .leftSpaceToView(weakSelf.actleftImg, 10)
    .rightSpaceToView(weakSelf.contentView, 10)
    .topEqualToView(weakSelf.actleftImg)
    .autoHeightRatio(0);
    
    weakSelf.acttimeLab
    .sd_layout
    .leftEqualToView(weakSelf.acttitleLab)
    .rightEqualToView(weakSelf.acttitleLab)
    .topSpaceToView(weakSelf.acttitleLab, 24)
    .autoHeightRatio(0);
    
    weakSelf.actcityLab
    .sd_layout
    .leftEqualToView(weakSelf.acttitleLab)
    .rightEqualToView(weakSelf.acttitleLab)
    .topSpaceToView(weakSelf.acttimeLab, 8)
    .autoHeightRatio(0);
    
    weakSelf.acttypeLab
    .sd_layout
    .leftEqualToView(weakSelf.acttitleLab)
    .rightEqualToView(weakSelf.acttitleLab)
    .topSpaceToView(weakSelf.actcityLab, 8)
    .autoHeightRatio(0);
    
    [weakSelf setupAutoHeightWithBottomView:weakSelf.actleftImg bottomMargin:19];
}


#pragma mark - getters

-(UIImageView *)noteleftImg
{
    if(!_noteleftImg)
    {
        _noteleftImg = [[UIImageView alloc] init];
        
    }
    return _noteleftImg;
}

-(UILabel *)notetitleLab
{
    if(!_notetitleLab)
    {
        _notetitleLab = [[UILabel alloc] init];
        _notetitleLab.font = [UIFont systemFontOfSize:16];
        _notetitleLab.textColor = [UIColor hexStringToColor:@"424242"];
    }
    return _notetitleLab;
}

-(UILabel *)notecontentLab
{
    if(!_notecontentLab)
    {
        _notecontentLab = [[UILabel alloc] init];
        _notecontentLab.font = [UIFont systemFontOfSize:12];
        _notecontentLab.textColor = [UIColor hexStringToColor:@"777777"];
        _notecontentLab.numberOfLines = 2;
    }
    return _notecontentLab;
}

-(UILabel *)notetimeLab
{
    if(!_notetimeLab)
    {
        _notetimeLab = [[UILabel alloc] init];
        _notetimeLab.font = [UIFont systemFontOfSize:10];
        _notetimeLab.textColor = [UIColor hexStringToColor:@"777777"];
    }
    return _notetimeLab;
}

-(UIImageView *)carleftImg
{
    if(!_carleftImg)
    {
        _carleftImg = [[UIImageView alloc] init];
        
    }
    return _carleftImg;
}

-(UILabel *)cartitleLab
{
    if(!_cartitleLab)
    {
        _cartitleLab = [[UILabel alloc] init];
        _cartitleLab.font = [UIFont systemFontOfSize:16];
        _cartitleLab.textColor = [UIColor hexStringToColor:@"424242"];
    }
    return _cartitleLab;
}

-(UILabel *)carcontentLab
{
    if(!_carcontentLab)
    {
        _carcontentLab = [[UILabel alloc] init];
        _carcontentLab.text = @"装修要花多少钱，点我10秒出报价";
        _carcontentLab.textColor = [UIColor hexStringToColor:@"999999"];
        _carcontentLab.font = [UIFont systemFontOfSize:14];
    }
    return _carcontentLab;
}

-(UILabel *)cartypeLab
{
    if(!_cartypeLab)
    {
        _cartypeLab = [[UILabel alloc] init];
        _cartypeLab.textAlignment = NSTextAlignmentCenter;
        _cartypeLab.font = [UIFont systemFontOfSize:10];
        _cartypeLab.textColor = [UIColor hexStringToColor:@"E6A460"];
        _cartypeLab.layer.masksToBounds = YES;
        _cartypeLab.layer.borderColor = [UIColor hexStringToColor:@"DA1712"].CGColor;
        _cartypeLab.layer.borderWidth = 1;
        _cartypeLab.backgroundColor = [UIColor hexStringToColor:@"FFEBE4"];
        _cartypeLab.text = @"生成预算";
        _cartypeLab.layer.cornerRadius = 4;
    }
    return _cartypeLab;
}

-(UIImageView *)sitebigImg
{
    if(!_sitebigImg)
    {
        _sitebigImg = [[UIImageView alloc] init];
        
    }
    return _sitebigImg;
}

-(UILabel *)sitenameLab
{
    if(!_sitenameLab)
    {
        _sitenameLab = [[UILabel alloc] init];
        _sitenameLab.textColor = [UIColor hexStringToColor:@"000000"];
        _sitenameLab.font = [UIFont systemFontOfSize:15];
    }
    return _sitenameLab;
}

-(UILabel *)sitestyleLab
{
    if(!_sitestyleLab)
    {
        _sitestyleLab = [[UILabel alloc] init];
        _sitestyleLab.font = [UIFont systemFontOfSize:14];
        _sitestyleLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _sitestyleLab;
}

-(UILabel *)siteaddressLab
{
    if(!_siteaddressLab)
    {
        _siteaddressLab = [[UILabel alloc] init];
        _siteaddressLab.font = [UIFont systemFontOfSize:14];
        _siteaddressLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _siteaddressLab;
}

-(UIImageView *)comiconImg
{
    if(!_comiconImg)
    {
        _comiconImg = [[UIImageView alloc] init];
        
    }
    return _comiconImg;
}

-(UILabel *)comnameLab
{
    if(!_comnameLab)
    {
        _comnameLab = [[UILabel alloc] init];
        _comnameLab.textColor = [UIColor hexStringToColor:@"333333"];
        _comnameLab.font = [UIFont systemFontOfSize:16];
    }
    return _comnameLab;
}

-(UILabel *)comcontentLab
{
    if(!_comcontentLab)
    {
        _comcontentLab = [[UILabel alloc] init];
        _comcontentLab.textColor = [UIColor hexStringToColor:@"999999"];
        _comcontentLab.font = [UIFont systemFontOfSize:12];
    }
    return _comcontentLab;
}

-(UILabel *)comaddressLab
{
    if(!_comaddressLab)
    {
        _comaddressLab = [[UILabel alloc] init];
        _comaddressLab.textColor = [UIColor hexStringToColor:@"999999"];
        _comaddressLab.font = [UIFont systemFontOfSize:12];
    }
    return _comaddressLab;
}

-(UIImageView *)goodsleftImg
{
    if(!_goodsleftImg)
    {
        _goodsleftImg = [[UIImageView alloc] init];
        
    }
    return _goodsleftImg;
}

-(UILabel *)goodsnameLab
{
    if(!_goodsnameLab)
    {
        _goodsnameLab = [[UILabel alloc] init];
        _goodsnameLab.textColor = [UIColor hexStringToColor:@"333333"];
        _goodsnameLab.font = [UIFont systemFontOfSize:16];
    }
    return _goodsnameLab;
}

-(UILabel *)goodsmoneyLab
{
    if(!_goodsmoneyLab)
    {
        _goodsmoneyLab = [[UILabel alloc] init];
        _goodsmoneyLab.font = [UIFont systemFontOfSize:16];
        _goodsmoneyLab.textColor = [UIColor hexStringToColor:@"FF0000"];
    }
    return _goodsmoneyLab;
}

-(UIImageView *)acticonImg
{
    if(!_acticonImg)
    {
        _acticonImg = [[UIImageView alloc] init];
        _acticonImg.layer.masksToBounds = YES;
        _acticonImg.layer.cornerRadius = 20;
    }
    return _acticonImg;
}

-(UILabel *)actnameLab
{
    if(!_actnameLab)
    {
        _actnameLab = [[UILabel alloc] init];
        _actnameLab.textColor = [UIColor hexStringToColor:@"25303F"];
        _actnameLab.font = [UIFont systemFontOfSize:14];
    }
    return _actnameLab;
}

-(UILabel *)actaddressLab
{
    if(!_actaddressLab)
    {
        _actaddressLab = [[UILabel alloc] init];
        _actaddressLab.textColor = [UIColor hexStringToColor:@"868686"];
        _actaddressLab.font = [UIFont systemFontOfSize:12];
    }
    return _actaddressLab;
}

-(UILabel *)acttitleLab
{
    if(!_acttitleLab)
    {
        _acttitleLab = [[UILabel alloc] init];
        _acttitleLab.font = [UIFont systemFontOfSize:14];
        _acttitleLab.textColor = [UIColor hexStringToColor:@"25303F"];
    }
    return _acttitleLab;
}

-(UILabel *)acttimeLab
{
    if(!_acttimeLab)
    {
        _acttimeLab = [[UILabel alloc] init];
        _acttimeLab.font = [UIFont systemFontOfSize:12];
        _acttimeLab.textColor = [UIColor hexStringToColor:@"8C8C8C"];
    }
    return _acttimeLab;
}

-(UILabel *)actcityLab
{
    if(!_actcityLab)
    {
        _actcityLab = [[UILabel alloc] init];
        _actcityLab.font = [UIFont systemFontOfSize:12];
        _actcityLab.textColor = [UIColor hexStringToColor:@"8C8C8C"];
    }
    return _actcityLab;
}

-(UILabel *)acttypeLab
{
    if(!_acttypeLab)
    {
        _acttypeLab = [[UILabel alloc] init];
        _acttypeLab.font = [UIFont systemFontOfSize:12];
        _acttypeLab.textColor = [UIColor hexStringToColor:@"8C8C8C"];
    }
    return _acttypeLab;
}

-(UIImageView *)actleftImg
{
    if(!_actleftImg)
    {
        _actleftImg = [[UIImageView alloc] init];
        
    }
    return _actleftImg;
}


@end
