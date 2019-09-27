//
//  disaboutCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/14.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "disaboutCell.h"
#import "aboutView.h"

@interface disaboutCell()
@property (nonatomic,strong) UIView *widthLine;
@property (nonatomic,strong) UIView *heightLine;
@property (nonatomic,strong) aboutView *aview0;
@property (nonatomic,strong) aboutView *aview1;
@property (nonatomic,strong) aboutView *aview2;
@property (nonatomic,strong) aboutView *aview3;
@end

@implementation disaboutCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.widthLine];
        [self.contentView addSubview:self.heightLine];
        [self.contentView addSubview:self.aview0];
        [self.contentView addSubview:self.aview1];
        [self.contentView addSubview:self.aview2];
        [self.contentView addSubview:self.aview3];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.widthLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(kSCREEN_WIDTH);
        make.centerY.equalTo(weakSelf);
        make.height.mas_offset(1);
    }];
    [weakSelf.heightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.width.mas_offset(1);
        make.centerX.equalTo(weakSelf);
    }];
    [weakSelf.aview0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-kSCREEN_WIDTH/2-14);
        make.bottom.equalTo(weakSelf).with.offset(-70);
    }];
    [weakSelf.aview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.aview0);
        make.left.equalTo(weakSelf).with.offset(kSCREEN_WIDTH/2);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.aview0);
    }];
    [weakSelf.aview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.right.equalTo(weakSelf.aview0);
        make.top.equalTo(70);
    }];
    [weakSelf.aview3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.aview1);
        make.bottom.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(70);
    }];
}

#pragma mark - getters


-(UIView *)widthLine
{
    if(!_widthLine)
    {
        _widthLine = [[UIView alloc] init];
        _widthLine.backgroundColor = [UIColor hexStringToColor:@"DDDDDD"];
    }
    return _widthLine;
}


-(UIView *)heightLine
{
    if(!_heightLine)
    {
        _heightLine = [[UIView alloc] init];
        _heightLine.backgroundColor = [UIColor hexStringToColor:@"DDDDDD"];
    }
    return _heightLine;
}


-(aboutView *)aview0
{
    if(!_aview0)
    {
        _aview0 = [[aboutView alloc] init];
        _aview0.nameLab.text = @"0任务0门槛";
        _aview0.contentLab.text = @"开放式的赚钱环境";
        _aview0.rightImg.image = [UIImage imageNamed:@"about01"];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aviewclick0)];
        [_aview0 addGestureRecognizer:tapGesturRecognizer];
        

    }
    return _aview0;
}


-(aboutView *)aview1
{
    if(!_aview1)
    {
        _aview1 = [[aboutView alloc] init];
        _aview1.nameLab.text = @"强大的开发能力";
        _aview1.contentLab.text = @"二十款营销工具海量用户";
        _aview1.rightImg.image = [UIImage imageNamed:@"about02"];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aviewclick1)];
        [_aview1 addGestureRecognizer:tapGesturRecognizer];
    }
    return _aview1;
}


-(aboutView *)aview2
{
    if(!_aview2)
    {
        _aview2 = [[aboutView alloc] init];
        _aview2.nameLab.text = @"睡觉都能自动赚钱";
        _aview2.contentLab.text = @"无需缴纳任何费用";
        _aview2.rightImg.image = [UIImage imageNamed:@"about03"];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aviewclick2)];
        [_aview2 addGestureRecognizer:tapGesturRecognizer];
    }
    return _aview2;
}

-(aboutView *)aview3
{
    if(!_aview3)
    {
        _aview3 = [[aboutView alloc] init];
        _aview3.nameLab.text = @"专业的软件培训";
        _aview3.contentLab.text = @"教你用装修知识赚大钱";
        _aview3.rightImg.image = [UIImage imageNamed:@"about04"];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aviewclick3)];
        [_aview3 addGestureRecognizer:tapGesturRecognizer];
    }
    return _aview3;
}

#pragma mark - 实现方法

-(void)aviewclick0
{
    [self.delegate myTabVClick0:self];
}

-(void)aviewclick1
{
    [self.delegate myTabVClick1:self];
}

-(void)aviewclick2
{
    [self.delegate myTabVClick2:self];
}

-(void)aviewclick3
{
    [self.delegate myTabVClick3:self];
}

@end
