//
//  citywideCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "citywideCell.h"
#import <SDAutoLayout.h>
#import "citywideModel.h"

@interface citywideCell()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UIImageView *rightImg;
@property (nonatomic,strong) UILabel *contentlab;
@property (nonatomic,strong) UILabel *timelab;
@property (nonatomic,strong) UIImageView *vipimg0;
@property (nonatomic,strong) UIImageView *vipimg1;
@property (nonatomic,strong) UILabel *labelDetail;
//未通过
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIButton *detailsBtn;
@property (nonatomic,strong) UIImageView *typeImg;

@property (nonatomic,strong) UILabel *reasonLab;
@end

@implementation citywideCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.contentView.backgroundColor = kBackgroundColor;
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.rightImg];
        [self.contentView addSubview:self.contentlab];
        [self.contentView addSubview:self.timelab];
        [self.contentView addSubview:self.vipimg0];
        [self.contentView addSubview:self.vipimg1];
        
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.detailsBtn];
        [self.contentView addSubview:self.typeImg];
        
        [self.contentView addSubview:self.reasonLab];
        [self.contentView addSubview:self.labelDetail];
        self.labelDetail.hidden = true;
        [self setuplauout];
    }
    return self;
}

-(void)setdata:(citywideModel *)model
{
    
    NSArray  *array = [model.imgs componentsSeparatedByString:@","];//--分隔符
    NSString *imgurl = [array firstObject];
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:imgurl]];
    
    self.timelab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.createDate];
    //newtrue;//（0:待审核,1:审核成功,2:拒绝）
    //（0:公司,1:工地,2:计算器,3:美文，4：活动,5:商品, 6精英推荐）
    if ([model.checked isEqualToString:@"2"]) {
        __weak typeof (self) weakSelf = self;
        weakSelf.bgView
        .sd_layout
        .leftSpaceToView(weakSelf.contentView, 14)
        .topSpaceToView(weakSelf.contentView, 14)
        .rightSpaceToView(weakSelf.contentView, 14)
        .heightIs(150);
        [self.line setHidden:NO];
        [self.typeImg setHidden:NO];
        [self.detailsBtn setHidden:NO];
        [self setupAutoHeightWithBottomView:self.typeImg bottomMargin:14];
        self.nameLab.textColor = [UIColor hexStringToColor:@"FB8C25"];
        
        if (model.isshow == YES) {
            [self.detailsBtn setHidden:YES];
            [self.reasonLab setHidden:NO];
            [self setupAutoHeightWithBottomView:self.detailsBtn bottomMargin:14];
            
            NSString *str1 = @"原因:";
            NSString *str2 = @"";
            if (model.reason.length==0) {
                str2 = @"管理员未给出原因";
            }
            else
            {
                str2 = model.reason;
            }
            NSString *str = [NSString stringWithFormat:@"%@%@",str1,str2];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
            [AttributedStr addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor darkGrayColor]
                                  range:NSMakeRange(0, str1.length)];

            self.reasonLab.attributedText = AttributedStr;
            //self.reasonLab.text = str;
        }
        else
        {
            [self.detailsBtn setHidden:NO];
            [self.reasonLab setHidden:YES];

        }
        
        if ([model.type isEqualToString:@"0"]) {
            self.nameLab.text = @"公司未通过审核";
        }
        if ([model.type isEqualToString:@"1"]) {
            self.nameLab.text = @"工地未通过审核";
        }
        if ([model.type isEqualToString:@"2"]) {
            self.nameLab.text = @"计算器未通过审核";
        }
        if ([model.type isEqualToString:@"3"]) {
            self.nameLab.text = @"美文未通过审核";
        }
        if ([model.type isEqualToString:@"4"]) {
            self.nameLab.text = @"活动未通过审核";
        }
        if ([model.type isEqualToString:@"5"]) {
            self.nameLab.text = @"商品未通过审核";
        }
        if ([model.type isEqualToString:@"6"]) {
            self.nameLab.text = @"精英推荐未通过审核";
        }
     
        
    }
    else
    {
        __weak typeof (self) weakSelf = self;
        weakSelf.bgView
        .sd_layout
        .leftSpaceToView(weakSelf.contentView, 14)
        .topSpaceToView(weakSelf.contentView, 14)
        .rightSpaceToView(weakSelf.contentView, 14)
        .heightIs(120);
        [self.line setHidden:YES];
        [self.typeImg setHidden:YES];
        [self.detailsBtn setHidden:YES];
        [self setupAutoHeightWithBottomView:self.bgView bottomMargin:14];
        self.nameLab.textColor = [UIColor hexStringToColor:@"6C6C6C"];
        if ([model.checked isEqualToString:@"0"]) {
            if ([model.type isEqualToString:@"0"]) {
                self.nameLab.text = @"公司审核中";
            }
            if ([model.type isEqualToString:@"1"]) {
                self.nameLab.text = @"工地审核中";
            }
            if ([model.type isEqualToString:@"2"]) {
                self.nameLab.text = @"计算器审核中";
            }
            if ([model.type isEqualToString:@"3"]) {
                self.nameLab.text = @"美文审核中";
            }
            if ([model.type isEqualToString:@"4"]) {
                self.nameLab.text = @"活动审核中";
            }
            if ([model.type isEqualToString:@"5"]) {
                self.nameLab.text = @"商品审核中";
            }
            if ([model.type isEqualToString:@"6"]) {
                self.nameLab.text = @"精英推荐审核中";
            }
        }
        if ([model.checked isEqualToString:@"1"]) {
            if ([model.type isEqualToString:@"0"]) {
                self.nameLab.text = @"公司已通过审核";
            }
            if ([model.type isEqualToString:@"1"]) {
                self.nameLab.text = @"工地已通过审核";
            }
            if ([model.type isEqualToString:@"2"]) {
                self.nameLab.text = @"计算器已通过审核";
            }
            if ([model.type isEqualToString:@"3"]) {
                self.nameLab.text = @"美文已通过审核";
            }
            if ([model.type isEqualToString:@"4"]) {
                self.nameLab.text = @"活动已通过审核";
            }
            if ([model.type isEqualToString:@"5"]) {
                self.nameLab.text = @"商品已通过审核";
            }
            if ([model.type isEqualToString:@"6"]) {
                self.nameLab.text = @"精英推荐已通过审核";
            }
        }
    }
    
    if ([model.type isEqualToString:@"0"]) {
        [self.vipimg0 setHidden:NO];
        [self.vipimg1 setHidden:NO];
    }
    else
    {
        [self.vipimg0 setHidden:YES];
        [self.vipimg1 setHidden:YES];
    }
    self.contentlab.text = model.content;
    if ([model.type isEqualToString:@"6"]) {
        self.labelDetail.hidden = false;
        self.labelDetail.text = model.companyName;
        self.contentlab.text = model.trueName;
    }
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    
    weakSelf.bgView
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 14)
    .topSpaceToView(weakSelf.contentView, 14)
    .rightSpaceToView(weakSelf.contentView, 14)
    .heightIs(150);
    
    weakSelf.nameLab
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 24)
    .topSpaceToView(weakSelf.contentView, 24)
    .rightSpaceToView(weakSelf.contentView, 24)
    .heightIs(20);
    
    weakSelf.leftImg
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 24)
    .topSpaceToView(weakSelf.nameLab, 14)
    .widthIs(72)
    .heightIs(55);
    weakSelf.leftImg.contentMode = UIViewContentModeScaleAspectFill;
    weakSelf.leftImg.clipsToBounds = true;

    weakSelf.contentlab
    .sd_layout
    .leftSpaceToView(weakSelf.leftImg, 10)
    .topEqualToView(weakSelf.leftImg)
    .heightIs(20);
    
    [weakSelf.contentlab setSingleLineAutoResizeWithMaxWidth:200];

    weakSelf.labelDetail
    .sd_layout
    .leftSpaceToView(weakSelf.leftImg, 10)
    .topSpaceToView(weakSelf.contentlab, 10)
    .heightIs(20);
    [weakSelf.labelDetail setSingleLineAutoResizeWithMaxWidth:200];

    weakSelf.vipimg0
    .sd_layout
    .leftSpaceToView(weakSelf.contentlab, 4)
    .centerYEqualToView(weakSelf.contentlab)
    .heightIs(14)
    .widthIs(13);
    
    weakSelf.vipimg1
    .sd_layout
    .leftSpaceToView(weakSelf.vipimg0, 4)
    .centerYEqualToView(weakSelf.contentlab)
    .heightIs(14)
    .widthIs(13);
    
    weakSelf.timelab
    .sd_layout
    .rightSpaceToView(weakSelf.contentView, 24)
    .heightIs(20)
    .topSpaceToView(weakSelf.leftImg, -20);
    
    [weakSelf.timelab setSingleLineAutoResizeWithMaxWidth:200];
    
    weakSelf.rightImg
    .sd_layout
    .rightEqualToView(weakSelf.bgView)
    .topEqualToView(weakSelf.bgView)
    .widthIs(20)
    .heightIs(20);
    
    weakSelf.line
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 24)
    .rightSpaceToView(weakSelf.contentView, 24)
    .heightIs(1)
    .topSpaceToView(weakSelf.timelab, 14);
    
    weakSelf.detailsBtn
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 14)
    .rightSpaceToView(weakSelf.contentView, 40)
    .topSpaceToView(weakSelf.line, 6)
    .heightIs(20);

    weakSelf.typeImg
    .sd_layout
    .rightSpaceToView(weakSelf.contentView, 24)
    .heightIs(13)
    .widthIs(8)
    .topSpaceToView(weakSelf.line, 7);
    
    weakSelf.reasonLab
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 24)
    .rightSpaceToView(weakSelf.contentView, 14)
    .autoHeightRatio(0)
    .topSpaceToView(weakSelf.line, 6);
    
    
    [weakSelf setupAutoHeightWithBottomView:weakSelf.typeImg bottomMargin:14];
}

#pragma mark - getters


-(UILabel *)reasonLab
{
    if(!_reasonLab)
    {
        _reasonLab = [[UILabel alloc] init];
        _reasonLab.font = [UIFont systemFontOfSize:14];
        _reasonLab.isAttributedContent = YES;
        _reasonLab.textColor = [UIColor redColor];
    }
    return _reasonLab;
}



-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];

    }
    return _leftImg;
}

-(UIImageView *)rightImg
{
    if(!_rightImg)
    {
        _rightImg = [[UIImageView alloc] init];
        _rightImg.image = [UIImage imageNamed:@"icon_massage"];
    }
    return _rightImg;
}


-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:16];
        _nameLab.textColor = [UIColor hexStringToColor:@"6C6C6C"];
    }
    return _nameLab;
}


-(UILabel *)contentlab
{
    if(!_contentlab)
    {
        _contentlab = [[UILabel alloc] init];
        _contentlab.text = @"北京比邻而居";
        _contentlab.font = [UIFont systemFontOfSize:14];
        _contentlab.textColor = [UIColor hexStringToColor:@"676767"];
    }
    return _contentlab;
}

- (UILabel *)labelDetail {
    if (!_labelDetail) {
        _labelDetail = [UILabel new];
        _labelDetail.font = [UIFont systemFontOfSize:14];
        _labelDetail.textColor = [UIColor hexStringToColor:@"676767"];
    }
    return _labelDetail;
}

-(UILabel *)timelab
{
    if(!_timelab)
    {
        _timelab = [[UILabel alloc] init];
        _timelab.font = [UIFont systemFontOfSize:13];
        _timelab.textColor = [UIColor hexStringToColor:@"676767"];
        _timelab.textAlignment = NSTextAlignmentRight;
        _timelab.text = @"2019:03:32";
    }
    return _timelab;
}

-(UIImageView *)vipimg0
{
    if(!_vipimg0)
    {
        _vipimg0 = [[UIImageView alloc] init];
        _vipimg0.image = [UIImage imageNamed:@"vip1"];
    }
    return _vipimg0;
}

-(UIImageView *)vipimg1
{
    if(!_vipimg1)
    {
        _vipimg1 = [[UIImageView alloc] init];
        _vipimg1.image = [UIImage imageNamed:@"zhuanshi"];
    }
    return _vipimg1;
}


-(UIView *)line
{
    if(!_line)
    {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor hexStringToColor:@"6C6C6C"];
    }
    return _line;
}


-(UIButton *)detailsBtn
{
    if(!_detailsBtn)
    {
        _detailsBtn = [[UIButton alloc] init];
        [_detailsBtn setTitle:@"查看详情" forState:normal];
        _detailsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_detailsBtn setTitleColor:[UIColor hexStringToColor:@"6C6C6C"] forState:normal];
        _detailsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _detailsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return _detailsBtn;
}

-(UIImageView *)typeImg
{
    if(!_typeImg)
    {
        _typeImg = [[UIImageView alloc] init];
        _typeImg.image = [UIImage imageNamed:@"youjiantou"];
    }
    return _typeImg;
}





@end
