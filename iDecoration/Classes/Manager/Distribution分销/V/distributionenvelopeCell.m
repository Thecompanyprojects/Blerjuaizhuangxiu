//
//  distributionenvelopeCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "distributionenvelopeCell.h"
#import "RedPacketList.h"
@interface distributionenvelopeCell()
@property (nonatomic,strong) UILabel *reasonLab;
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UIButton *submitBtn;

@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *moneyLab;
@end

@implementation distributionenvelopeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.reasonLab];
        [self.contentView addSubview:self.submitBtn];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.moneyLab];
        //[self setuplayout];
    }
    return self;
}

-(void)setdata:(RedPacketList *)model
{
    if (model.reason.length==0) {
        [self.leftImg setHidden:YES];
        [self.reasonLab setHidden:YES];
        [self.submitBtn setHidden:YES];
        [self setuplayout];
    }
    else
    {
        [self.leftImg setHidden:NO];
        [self.reasonLab setHidden:NO];
        [self.submitBtn setHidden:NO];
        [self setuplayout2];
    }
    self.nameLab.text = model.companyName;
    self.timeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStampWithMin:model.createDate];
    float moneyfl = [model.redIncomeMoney floatValue];
    if (!(moneyfl</* DISABLES CODE */ (9))) {
        int moneyint = round(moneyfl);
        NSString *newstr = [NSString stringWithFormat:@"%d",moneyint];
        self.moneyLab.text = [NSString stringWithFormat:@"%@%@",newstr,@"元"];
    }
    else
    {
        NSString *newstr = [NSString stringWithFormat:@"%.2f",moneyfl];
        self.moneyLab.text = [NSString stringWithFormat:@"%@%@",newstr,@"元"];
    }
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(22);
        make.top.equalTo(weakSelf).with.offset(29);
        
    }];
    
    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(15);
        make.left.equalTo(weakSelf.nameLab);
    }];
    
    [weakSelf.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-23);
        make.centerY.equalTo(weakSelf);
    }];
    
}

-(void)setuplayout2
{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(12);
        make.height.mas_offset(12);
        make.left.equalTo(weakSelf).with.offset(23);
        make.top.equalTo(weakSelf).with.offset(16);
    }];
    
    [weakSelf.reasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(16);
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(3);
        make.width.mas_offset(252);
        make.height.mas_offset(13);
    }];
    
    [weakSelf.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(16);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.width.mas_offset(70);
        make.height.mas_offset(13);
    }];
    
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(22);
        make.top.equalTo(weakSelf.reasonLab.mas_bottom).with.offset(18);
    }];
    
    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(15);
        make.left.equalTo(weakSelf.nameLab);
    }];
    
    [weakSelf.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-23);
       // make.centerY.equalTo(weakSelf);
        make.top.equalTo(weakSelf.reasonLab.mas_bottom).with.offset(32);
    }];
    
}

#pragma mark - getters

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:16];
        _nameLab.textColor = [UIColor hexStringToColor:@"333333"];
        
    }
    return _nameLab;
}

-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:13];
        _timeLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _timeLab;
}

-(UILabel *)moneyLab
{
    if(!_moneyLab)
    {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.textAlignment = NSTextAlignmentRight;
        _moneyLab.textColor = [UIColor hexStringToColor:@"FF0000"];
        _moneyLab.font = [UIFont systemFontOfSize:17];
    }
    return _moneyLab;
}

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.image = [UIImage imageNamed:@"gantan"];
    }
    return _leftImg;
}

-(UILabel *)reasonLab
{
    if(!_reasonLab)
    {
        _reasonLab = [[UILabel alloc] init];
        _reasonLab.text = @"商家认证信息未通过二次审核，此红包作废";
        _reasonLab.textColor = [UIColor hexStringToColor:@"FFA931"];
        _reasonLab.font = [UIFont systemFontOfSize:13];
    }
    return _reasonLab;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:@"查看详情>" forState:normal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_submitBtn setTitleColor:[UIColor hexStringToColor:@"999999"] forState:normal];
        [_submitBtn addTarget:self action:@selector(submitbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

-(void)submitbtnclick
{
    [self.delegate myTabVClick:self];
}
@end
