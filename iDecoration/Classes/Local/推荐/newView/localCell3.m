//
//  localCell3.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localCell3.h"
#import "localstrategyView.h"
#import "localexecellentModel.h"

@interface localCell3()
@property (nonatomic,strong) UIImageView *topImg;
@property (nonatomic,strong) UIImageView *bannerImg;
@property (nonatomic,strong) localstrategyView *stragrgyView0;
@property (nonatomic,strong) localstrategyView *stragrgyView1;
@property (nonatomic,strong) NSMutableArray *execellentArray;
@end

@implementation localCell3

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
        [self.contentView addSubview:self.topImg];
        [self.contentView addSubview:self.bannerImg];
        [self.contentView addSubview:self.stragrgyView0];
        [self.contentView addSubview:self.stragrgyView1];
        [self.contentView addSubview:self.moreBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(NSMutableArray *)arr
{
    self.execellentArray = [NSMutableArray array];
    self.execellentArray = arr;
    if (arr.count>=1) {
        localexecellentModel *model0 = [arr firstObject];
        [self.stragrgyView0.leftImg sd_setImageWithURL:[NSURL URLWithString:model0.coveMap]];
        self.stragrgyView0.titleLab.text = model0.caseTitle?:@"";
        self.stragrgyView0.timeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model0.addTime];
        self.stragrgyView0.contentLab.text = model0.designSubtitle?:@"";
        [self.stragrgyView0.readBtn setTitle:[NSString stringWithFormat:@"%ld",(long)model0.readNum] forState:normal];
    }
    if (arr.count>=2) {
        localexecellentModel *model1 = [arr objectAtIndex:1];
        [self.stragrgyView1.leftImg sd_setImageWithURL:[NSURL URLWithString:model1.coveMap]];
        self.stragrgyView1.titleLab.text = model1.caseTitle?:@"";
        self.stragrgyView1.timeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model1.addTime];
        self.stragrgyView1.contentLab.text = model1.designSubtitle?:@"";
        [self.stragrgyView1.readBtn setTitle:[NSString stringWithFormat:@"%ld",(long)model1.readNum] forState:normal];
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
    [weakSelf.bannerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(10);
        make.right.equalTo(weakSelf).with.offset(-10);
        make.top.equalTo(weakSelf.topImg.mas_bottom).with.offset(14);
        make.height.mas_offset(63);
    }];
    
    [weakSelf.stragrgyView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.bannerImg.mas_bottom);
        make.height.mas_offset(90);
    }];
    
    [weakSelf.stragrgyView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.stragrgyView0.mas_bottom);
        make.height.mas_offset(90);
    }];
    
    [weakSelf.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.stragrgyView1.mas_bottom).with.offset(14);
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
        _topImg.image = [UIImage imageNamed:@"icon_gongl"];
    }
    return _topImg;
}

-(UIImageView *)bannerImg
{
    if(!_bannerImg)
    {
        _bannerImg = [[UIImageView alloc] init];
        _bannerImg.image = [UIImage imageNamed:@"pic_zhuangxiu"];
    }
    return _bannerImg;
}

-(localstrategyView *)stragrgyView0
{
    if(!_stragrgyView0)
    {
        _stragrgyView0 = [[localstrategyView alloc] init];
        _stragrgyView0.leftImg.image = [UIImage imageNamed:@"time"];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectclick0)];
        [_stragrgyView0 addGestureRecognizer:tapGesturRecognizer];
    }
    return _stragrgyView0;
}

-(localstrategyView *)stragrgyView1
{
    if(!_stragrgyView1)
    {
        _stragrgyView1 = [[localstrategyView alloc] init];
        _stragrgyView1.leftImg.image = [UIImage imageNamed:@"time"];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectclick1)];
        [_stragrgyView1 addGestureRecognizer:tapGesturRecognizer];
    }
    return _stragrgyView1;
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
        [_moreBtn setTitle:@"更多装修攻略>" forState:normal];
        _moreBtn.layer.cornerRadius = 9;
    }
    return _moreBtn;
}

-(void)selectclick0
{
    if (self.execellentArray.count>=1) {
        localexecellentModel *model = [self.execellentArray firstObject];
        [self.delegate myexecellent:model];
    }
}

-(void)selectclick1
{
    if (self.execellentArray.count>=2) {
        localexecellentModel *model = [self.execellentArray objectAtIndex:1];
        [self.delegate myexecellent:model];
    }
}

@end
