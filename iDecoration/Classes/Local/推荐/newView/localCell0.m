//
//  localCell0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localCell0.h"
#import "localcaseView.h"
#import "localconstructionsModel.h"

@interface localCell0()
@property (nonatomic,strong) UIImageView *topImg;
@property (nonatomic,strong) localcaseView *caseView0;
@property (nonatomic,strong) localcaseView *caseView1;
@property (nonatomic,strong) localcaseView *caseView2;
@property (nonatomic,strong) localcaseView *caseView3;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation localCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.topImg];
        [self.contentView addSubview:self.caseView0];
        [self.contentView addSubview:self.caseView1];
        [self.contentView addSubview:self.caseView2];
        [self.contentView addSubview:self.caseView3];
        [self.contentView addSubview:self.moreBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(NSMutableArray *)array
{
    self.dataSource = [NSMutableArray array];
    self.dataSource = array;
    if (array.count>=1) {
        localconstructionsModel *model0 = [array firstObject];
        [self.caseView0.caseImg sd_setImageWithURL:[NSURL URLWithString:model0.coverMap]];
        self.caseView0.styleLab.text = model0.sharTitle?:@"";
        self.caseView0.areaLab.text = [NSString stringWithFormat:@"%@%@",model0.ccAcreage,@"m²"]?:@"";
    }
    if (array.count>=2) {
        localconstructionsModel *model1 = [array objectAtIndex:1];
        [self.caseView1.caseImg sd_setImageWithURL:[NSURL URLWithString:model1.coverMap]];
        self.caseView1.styleLab.text = model1.sharTitle?:@"";
        self.caseView1.areaLab.text = [NSString stringWithFormat:@"%@%@",model1.ccAcreage,@"m²"]?:@"";
    }
    if (array.count>=3) {
         localconstructionsModel *model2 = [array objectAtIndex:2];
        [self.caseView2.caseImg sd_setImageWithURL:[NSURL URLWithString:model2.coverMap]];
        self.caseView2.styleLab.text = model2.sharTitle?:@"";
        self.caseView2.areaLab.text = [NSString stringWithFormat:@"%@%@",model2.ccAcreage,@"m²"]?:@"";
    }
    if (array.count==4) {
        localconstructionsModel *model3 = [array objectAtIndex:3];
        [self.caseView3.caseImg sd_setImageWithURL:[NSURL URLWithString:model3.coverMap]];
        self.caseView3.styleLab.text = model3.sharTitle?:@"";
        self.caseView3.areaLab.text = [NSString stringWithFormat:@"%@%@",model3.ccAcreage,@"m²"]?:@"";
    }
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(29);
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(91);
        make.height.mas_offset(16);
    }];
    [weakSelf.caseView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(10);
        make.top.equalTo(weakSelf.topImg.mas_bottom).with.offset(14);
        make.width.mas_offset(kSCREEN_WIDTH/2-15);
        make.height.mas_offset(140);
    }];
    [weakSelf.caseView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-10);
        make.top.equalTo(weakSelf.caseView0);
        make.width.mas_offset(kSCREEN_WIDTH/2-15);
        make.height.mas_offset(140);
    }];
    [weakSelf.caseView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.caseView0);
        make.top.equalTo(weakSelf.caseView0.mas_bottom).with.offset(14);
        make.width.mas_offset(kSCREEN_WIDTH/2-15);
        make.height.mas_offset(140);
    }];
    [weakSelf.caseView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.caseView1);
        make.top.equalTo(weakSelf.caseView2);
        make.width.mas_offset(kSCREEN_WIDTH/2-15);
        make.height.mas_offset(140);
    }];
    [weakSelf.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.caseView3.mas_bottom).with.offset(14);
        make.width.mas_offset(94);
        make.height.mas_offset(19);
    }];
}

#pragma mark - getters

-(UIImageView *)topImg
{
    if(!_topImg)
    {
        _topImg = [[UIImageView alloc] init];
        _topImg.image = [UIImage imageNamed:@"icon_zhuangxiuanli"];
    }
    return _topImg;
}

-(localcaseView *)caseView0
{
    if(!_caseView0)
    {
        _caseView0 = [[localcaseView alloc] init];
        _caseView0.caseImg.image = [UIImage imageNamed:@"timg"];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectclick0)];
        [_caseView0 addGestureRecognizer:tapGesturRecognizer];
    }
    return _caseView0;
}

-(localcaseView *)caseView1
{
    if(!_caseView1)
    {
        _caseView1 = [[localcaseView alloc] init];
        _caseView1.caseImg.image = [UIImage imageNamed:@"timg"];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectclick1)];
        [_caseView1 addGestureRecognizer:tapGesturRecognizer];
    }
    return _caseView1;
}

-(localcaseView *)caseView2
{
    if(!_caseView2)
    {
        _caseView2 = [[localcaseView alloc] init];
        _caseView2.caseImg.image = [UIImage imageNamed:@"timg"];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectclick2)];
        [_caseView2 addGestureRecognizer:tapGesturRecognizer];
    }
    return _caseView2;
}

-(localcaseView *)caseView3
{
    if(!_caseView3)
    {
        _caseView3 = [[localcaseView alloc] init];
        _caseView3.caseImg.image = [UIImage imageNamed:@"timg"];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectclick3)];
        [_caseView3 addGestureRecognizer:tapGesturRecognizer];
    }
    return _caseView3;
}

-(UIButton *)moreBtn
{
    if(!_moreBtn)
    {
        _moreBtn = [[UIButton alloc] init];
        _moreBtn.layer.masksToBounds = YES;
        _moreBtn.layer.borderColor = [UIColor hexStringToColor:@"DDDDDD"].CGColor;
        _moreBtn.layer.borderWidth = 0.5f;
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moreBtn setTitleColor:[UIColor hexStringToColor:@"777777"] forState:normal];
        [_moreBtn setTitle:@"更多装修案例>" forState:normal];
        _moreBtn.layer.cornerRadius = 9;
    }
    return _moreBtn;
}


-(void)selectclick0
{
    if (self.dataSource.count>1) {
        [self.delegate myconstruction:[self.dataSource firstObject]];
    }
}

-(void)selectclick1
{
    if (self.dataSource.count>2) {
        [self.delegate myconstruction:[self.dataSource objectAtIndex:1]];
    }
}

-(void)selectclick2
{
    if (self.dataSource.count>3) {
        [self.delegate myconstruction:[self.dataSource objectAtIndex:2]];
    }
}

-(void)selectclick3
{
    if (self.dataSource.count>=4) {
        [self.delegate myconstruction:[self.dataSource objectAtIndex:3]];
    }
}



@end

