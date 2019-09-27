


//
//  localCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localCell1.h"
#import "localeffectView.h"
#import "localimgModel.h"
#import "localdesignModel.h"

@interface localCell1()
@property (nonatomic,strong) UIImageView *topImg;
@property (nonatomic,strong) UISegmentedControl *segment;
@property (nonatomic,strong) localeffectView *effectView0;
@property (nonatomic,strong) localeffectView *effectView1;
@property (nonatomic,strong) localeffectView *effectView2;
@property (nonatomic,strong) localeffectView *effectView3;
@property (nonatomic,strong) NSMutableArray *imgarray;
@property (nonatomic,strong) NSMutableArray *designarray;
@property (nonatomic,copy) NSString *type;
@end

@implementation localCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.type = @"0";
        [self.contentView addSubview:self.topImg];
        [self.contentView addSubview:self.segment];
        [self.contentView addSubview:self.effectView0];
        [self.contentView addSubview:self.effectView1];
        [self.contentView addSubview:self.effectView2];
        [self.contentView addSubview:self.effectView3];
        [self.contentView addSubview:self.moreBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(NSMutableArray *)imgarr and:(NSMutableArray *)designarr
{
    self.imgarray = imgarr;
    self.designarray = designarr;
    [self setdata0];
}

-(void)setdata0
{
    if (self.imgarray.count>1) {
        localimgModel *model0 = [self.imgarray firstObject];
        //[self.effectView0.effectImg sd_setImageWithURL:[NSURL URLWithString:model0.coverMap]];
        [self.effectView0.effectImg sd_setImageWithURL:[NSURL URLWithString:model0.coverMap] placeholderImage:[UIImage imageNamed:@"timg"]];
        self.effectView0.contentLab.text = model0.designTitle?:@"";
    }
    if (self.imgarray.count>2) {
        localimgModel *model1 = [self.imgarray objectAtIndex:1];
        [self.effectView1.effectImg sd_setImageWithURL:[NSURL URLWithString:model1.coverMap] placeholderImage:[UIImage imageNamed:@"timg"]];
        self.effectView1.contentLab.text = model1.designTitle?:@"";
    }
    if (self.imgarray.count>3) {
        localimgModel *model2 = [self.imgarray objectAtIndex:2];
        [self.effectView2.effectImg sd_setImageWithURL:[NSURL URLWithString:model2.coverMap] placeholderImage:[UIImage imageNamed:@"timg"]];
        self.effectView2.contentLab.text = model2.designTitle?:@"";
    }
    if (self.imgarray.count==4) {
        localimgModel *model3 = [self.imgarray objectAtIndex:3];
        [self.effectView3.effectImg sd_setImageWithURL:[NSURL URLWithString:model3.coverMap] placeholderImage:[UIImage imageNamed:@"timg"]];
        self.effectView3.contentLab.text = model3.designTitle?:@"";
    }
}

-(void)setdata1
{
    if (self.designarray.count>=1) {
        localdesignModel *model0 = [self.designarray firstObject];
        //[self.effectView0.effectImg sd_setImageWithURL:[NSURL URLWithString:model0.coverMap]];
        [self.effectView0.effectImg sd_setImageWithURL:[NSURL URLWithString:model0.coverMap] placeholderImage:[UIImage imageNamed:@"timg"]];
        self.effectView0.contentLab.text = model0.designTitle?:@"";
    }
    if (self.imgarray.count>=2) {
        localdesignModel *model1 = [self.designarray objectAtIndex:1];
        [self.effectView1.effectImg sd_setImageWithURL:[NSURL URLWithString:model1.coverMap] placeholderImage:[UIImage imageNamed:@"timg"]];
        self.effectView1.contentLab.text = model1.designTitle?:@"";
    }
    if (self.imgarray.count>=3) {
        localdesignModel *model2 = [self.designarray objectAtIndex:2];
        [self.effectView2.effectImg sd_setImageWithURL:[NSURL URLWithString:model2.coverMap] placeholderImage:[UIImage imageNamed:@"timg"]];
        self.effectView2.contentLab.text = model2.designTitle?:@"";
    }
    if (self.imgarray.count==4) {
        localdesignModel *model3 = [self.designarray objectAtIndex:3];
        [self.effectView3.effectImg sd_setImageWithURL:[NSURL URLWithString:model3.coverMap] placeholderImage:[UIImage imageNamed:@"timg"]];
        self.effectView3.contentLab.text = model3.designTitle?:@"";
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
    [weakSelf.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.topImg.mas_bottom).with.offset(14);
        make.height.mas_offset(19);
        make.width.mas_offset(118);
    }];
    [weakSelf.effectView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(10);
        make.width.mas_offset(kSCREEN_WIDTH/2-15);
        make.height.mas_offset(110);
        make.top.equalTo(weakSelf.segment.mas_bottom).with.offset(14);
    }];
    [weakSelf.effectView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-10);
        make.top.equalTo(weakSelf.effectView0);
        make.height.mas_offset(110);
        make.width.mas_offset(kSCREEN_WIDTH/2-15);
    }];
    [weakSelf.effectView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.effectView0);
        make.width.mas_offset(kSCREEN_WIDTH/2-15);
        make.height.mas_offset(110);
        make.top.equalTo(weakSelf.effectView0.mas_bottom).with.offset(10);
    }];
    [weakSelf.effectView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.effectView2);
        make.height.mas_offset(110);
        make.width.mas_offset(kSCREEN_WIDTH/2-15);
        make.right.equalTo(weakSelf.effectView1);
    }];
    [weakSelf.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.effectView3.mas_bottom).with.offset(14);
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
        _topImg.image = [UIImage imageNamed:@"icon_xiaoguotu"];
    }
    return _topImg;
}

-(UISegmentedControl *)segment
{
    if(!_segment)
    {
        NSArray *array = [NSArray arrayWithObjects:@"3D图",@"平面图", nil];
        _segment = [[UISegmentedControl alloc] initWithItems:array];
        _segment.tintColor = [UIColor hexStringToColor:@"3598DC"];
        _segment.backgroundColor = [UIColor hexStringToColor:@"FFFFFF"];
        _segment.layer.masksToBounds = YES;
        _segment.layer.cornerRadius = 10;
        _segment.layer.borderWidth = 1;
        _segment.layer.borderColor = [UIColor hexStringToColor:@"3598DC"].CGColor;
        _segment.selectedSegmentIndex = 0;
        [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

-(localeffectView *)effectView0
{
    if(!_effectView0)
    {
        _effectView0 = [[localeffectView alloc] init];
        _effectView0.effectImg.image = [UIImage imageNamed:@"timg"];
        
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectclick0)];
        [_effectView0 addGestureRecognizer:tapGesturRecognizer];
    }
    return _effectView0;
}

-(localeffectView *)effectView1
{
    if(!_effectView1)
    {
        _effectView1 = [[localeffectView alloc] init];
        _effectView1.effectImg.image = [UIImage imageNamed:@"timg"];
        
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectclick1)];
        [_effectView1 addGestureRecognizer:tapGesturRecognizer];
    }
    return _effectView1;
}

-(localeffectView *)effectView2
{
    if(!_effectView2)
    {
        _effectView2 = [[localeffectView alloc] init];
        _effectView2.effectImg.image = [UIImage imageNamed:@"timg"];
        
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectclick2)];
        [_effectView2 addGestureRecognizer:tapGesturRecognizer];
    }
    return _effectView2;
}

-(localeffectView *)effectView3
{
    if(!_effectView3)
    {
        _effectView3 = [[localeffectView alloc] init];
        _effectView3.effectImg.image = [UIImage imageNamed:@"timg"];
        
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectclick3)];
        [_effectView3 addGestureRecognizer:tapGesturRecognizer];
    }
    return _effectView3;
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
        [_moreBtn setTitle:@"更多装修效果图>" forState:normal];
        _moreBtn.layer.cornerRadius = 9;
        [_moreBtn addTarget:self action:@selector(morebtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

-(void)segmentAction:(UISegmentedControl*)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            NSLog(@"我是red,下标0！！！");
            self.type = @"0";
            [self setdata0];
            break;
        case 1:
            NSLog(@"我是green,下标1！！！");
            self.type = @"1";
            [self setdata1];
            break;
        default:
            break;
    }

}

-(void)selectclick0
{
    if ([self.type isEqualToString:@"0"]) {
        if (self.imgarray.count>=1) {
            localimgModel *model = [self.imgarray firstObject];
            [self.delegate myimg:model];
        }
    }
    else
    {
        if (self.designarray.count>1) {
            localdesignModel *model = [self.designarray firstObject];
            [self.delegate mydesign:model];
        }
    }
}


-(void)selectclick1
{
    if ([self.type isEqualToString:@"0"]) {
        if (self.imgarray.count>=2) {
            localimgModel *model = [self.imgarray objectAtIndex:1];
            [self.delegate myimg:model];
        }
    }
    else
    {
        if (self.designarray.count>=2) {
            localdesignModel *model = [self.designarray objectAtIndex:1];
            [self.delegate mydesign:model];
        }
    }
}

-(void)selectclick2
{
    if ([self.type isEqualToString:@"0"]) {
        if (self.imgarray.count>=3) {
            localimgModel *model = [self.imgarray objectAtIndex:2];
            [self.delegate myimg:model];
        }
    }
    else
    {
        if (self.designarray.count>=3) {
            localdesignModel *model = [self.designarray objectAtIndex:2];
            [self.delegate mydesign:model];
        }
    }
}

-(void)selectclick3
{
    if ([self.type isEqualToString:@"0"]) {
        if (self.imgarray.count>=4) {
            localimgModel *model = [self.imgarray objectAtIndex:3];
            [self.delegate myimg:model];
        }
    }
    else
    {
        if (self.designarray.count>=4) {
            localdesignModel *model = [self.designarray objectAtIndex:3];
            [self.delegate mydesign:model];
        }
    }
}


-(void)morebtnclick
{
    [self.delegate morebtnchoose:self.type];
}
@end
