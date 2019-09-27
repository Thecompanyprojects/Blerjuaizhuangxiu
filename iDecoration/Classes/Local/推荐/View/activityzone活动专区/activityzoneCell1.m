//
//  activityzoneCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/15.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "activityzoneCell1.h"
#import "activityzoneModel.h"
#import "homenewsModel.h"

@interface activityzoneCell1()
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *addressLab;
@property (nonatomic,strong) UILabel *distanceLab;
@property (nonatomic,strong) UILabel *typeLab;
@property (nonatomic,strong) UIButton *singupBtn;
@end

@implementation activityzoneCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.addressLab];
        //[self.contentView addSubview:self.distanceLab];
        [self.contentView addSubview:self.typeLab];
        [self.contentView addSubview:self.singupBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setdata2:(homenewsModel *)model
{
    
    //activityStatus true number 状态（0：报名中，3：活动结束，4：活动进行中，6：停止报名，7：报名人数达到上限8:活动不存在）
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:model.coverMap]];
    self.titleLab.text = model.designTitle;
    NSString *timestr = [NSString stringWithFormat:@"%@",model.startTime];
    NSString *newtimestr = [NSString stringWithFormat:@"%@%@",[[PublicTool defaultTool] newgetDateFormatStrFromTimeStampWithMin:timestr],@"开始"];
    self.timeLab.text = newtimestr;
    

    switch (model.activityStatus) {
        case 0:
            [self.singupBtn setTitle:@"报名" forState:normal];
            break;
        case 3:
            [self.singupBtn setTitle:@"结束" forState:normal];
            break;
        case 4:
            [self.singupBtn setTitle:@"报名" forState:normal];
            break;
        case 6:
            [self.singupBtn setTitle:@"结束" forState:normal];
            break;
        case 7:
            [self.singupBtn setTitle:@"报名" forState:normal];
            break;
        case 8:
            [self.singupBtn setTitle:@"结束" forState:normal];
            break;
        default:
            break;
    }
    
    if (model.activityAddress.length==0) {
        self.addressLab.text = @"线上活动";
    }
    else
    {
        self.addressLab.text = model.activityAddress;
    }
    
    if ([model.money isEqualToString:@"0"]) {
        self.typeLab.text = @"免费";
    }
    else
    {
        self.typeLab.text = [NSString stringWithFormat:@"%@%@",@"￥",model.money];
    }
    
}

-(void)setdata:(activityzoneModel *)model
{
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:model.coverMap]];
    self.titleLab.text = model.designTitle;
    NSString *timestr = [NSString stringWithFormat:@"%ld",model.startTime];
    NSString *newtimestr = [NSString stringWithFormat:@"%@%@",[[PublicTool defaultTool] newgetDateFormatStrFromTimeStampWithMin:timestr],@"开始"];
    self.timeLab.text = newtimestr;
    
    
    
    if (model.activityAddress.length==0) {
        self.addressLab.text = @"线上活动";
    }
    else
    {
        self.addressLab.text = model.activityAddress;
    }
    
    if ([model.money isEqualToString:@"0"]) {
        self.typeLab.text = @"免费";
    }
    else
    {
        self.typeLab.text = [NSString stringWithFormat:@"%@%@",@"￥",model.money];
    }
    
}


-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(12);
        make.top.equalTo(weakSelf).with.offset(12);
        make.width.mas_offset(168);
        make.height.mas_offset(98);
    }];
    [weakSelf.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(10);
        make.top.equalTo(weakSelf.leftImg);
        make.right.equalTo(weakSelf).with.offset(-14);
    }];
    


    [weakSelf.singupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.leftImg);
        make.right.equalTo(weakSelf).with.offset(-12);
        make.width.mas_offset(46);
        make.height.mas_offset(22);
    }];
    
    [weakSelf.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.singupBtn);
        make.left.equalTo(weakSelf.addressLab);
        make.left.equalTo(weakSelf.titleLab);
    }];
    
    [weakSelf.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.timeLab);
        make.bottom.equalTo(weakSelf.typeLab.mas_top).with.offset(-7);
        make.right.equalTo(weakSelf.titleLab);
        make.height.mas_offset(15);
    }];
    
    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab);
        make.bottom.equalTo(weakSelf.addressLab.mas_top).with.offset(-7);
        make.height.mas_offset(15);
        make.right.equalTo(weakSelf).with.offset(-12);
    }];
    
}

#pragma mark - getters

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.contentMode = UIViewContentModeScaleAspectFill;
        _leftImg.layer.masksToBounds = YES;
    }
    return _leftImg;
}

-(UILabel *)titleLab
{
    if(!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = [UIColor hexStringToColor:@"233040"];
        _titleLab.numberOfLines = 2;
        
    }
    return _titleLab;
}

-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.textColor = [UIColor hexStringToColor:@"8C8C8C"];
    }
    return _timeLab;
}

-(UILabel *)addressLab
{
    if(!_addressLab)
    {
        _addressLab = [[UILabel alloc] init];
        _addressLab.font = [UIFont systemFontOfSize:12];
        _addressLab.textColor = [UIColor hexStringToColor:@"8C8C8C"];
    }
    return _addressLab;
}

-(UILabel *)distanceLab
{
    if(!_distanceLab)
    {
        _distanceLab = [[UILabel alloc] init];
        _distanceLab.font = [UIFont systemFontOfSize:12];
        _distanceLab.textColor = [UIColor hexStringToColor:@"8C8C8C"];
        _distanceLab.textAlignment = NSTextAlignmentRight;
    }
    return _distanceLab;
}

-(UILabel *)typeLab
{
    if(!_typeLab)
    {
        _typeLab = [[UILabel alloc] init];
        _typeLab.font = [UIFont systemFontOfSize:12];
        _typeLab.textColor = [UIColor hexStringToColor:@"FF9933"];
    }
    return _typeLab;
}

-(UIButton *)singupBtn
{
    if(!_singupBtn)
    {
        _singupBtn = [[UIButton alloc] init];
        [_singupBtn setTitle:@"报名" forState:normal];
        _singupBtn.backgroundColor = [UIColor hexStringToColor:@"fbebdc"];
        _singupBtn.layer.masksToBounds = YES;
        _singupBtn.layer.borderWidth = 1;
        _singupBtn.layer.borderColor = [UIColor hexStringToColor:@"FF9933"].CGColor;
        [_singupBtn setTitleColor:[UIColor hexStringToColor:@"FF9933"] forState:normal];
        [_singupBtn addTarget:self action:@selector(singupBtnclick) forControlEvents:UIControlEventTouchUpInside];
        _singupBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _singupBtn;
}

#pragma mark - 实现方法

-(void)singupBtnclick
{
    [self.delegate singupTabbtn:self];
}

@end
