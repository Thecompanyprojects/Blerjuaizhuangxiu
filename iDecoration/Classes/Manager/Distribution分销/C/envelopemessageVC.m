//
//  envelopemessageVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/27.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "envelopemessageVC.h"

@interface envelopemessageVC ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *typeLab;
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UILabel *reasonLab;
@end

@implementation envelopemessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详细信息";
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.typeLab];
    [self.view addSubview:self.leftImg];
    [self.view addSubview:self.nameLab];
    [self.view addSubview:self.timeLab];
    [self.view addSubview:self.line];
    [self.view addSubview:self.reasonLab];
    [self setuplayout];
    [self setdata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setdata
{
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:self.model.companyLogo]];
    self.nameLab.text = self.model.companyName;
    self.timeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:self.model.createDate];
    self.reasonLab.text = [NSString stringWithFormat:@"%@%@",@"原因：",self.model.reason];
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).with.offset(9);
        make.top.equalTo(weakSelf.view).with.offset(kNaviBottom+14);
        make.right.equalTo(weakSelf.view).with.offset(-9);
        make.height.mas_offset(174);
    }];
    
    [weakSelf.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView).with.offset(14);
        make.top.equalTo(weakSelf.bgView).with.offset(24);
        make.height.mas_offset(15);
        make.right.equalTo(weakSelf.bgView).with.offset(-14);
    }];
    
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView).with.offset(14);
        make.top.equalTo(weakSelf.typeLab.mas_bottom).with.offset(18);
        make.width.mas_offset(42);
        make.height.mas_offset(42);
    }];

    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(10);
        make.top.equalTo(weakSelf.leftImg).with.offset(2);
        
    }];

    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView).with.offset(-14);
        make.top.equalTo(weakSelf.bgView).with.offset(87);
    }];

    [weakSelf.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView);
        make.right.equalTo(weakSelf.bgView);
        make.height.mas_offset(1);
        make.top.equalTo(weakSelf.bgView).with.offset(124);
    }];

    [weakSelf.reasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView).with.offset(15);
        make.top.equalTo(weakSelf.line).with.offset(18);
        make.height.mas_offset(15);
    }];
}

#pragma mark - getters

-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = White_Color;
    }
    return _bgView;
}

-(UILabel *)typeLab
{
    if(!_typeLab)
    {
        _typeLab = [[UILabel alloc] init];
        _typeLab.font = [UIFont systemFontOfSize:13];
        _typeLab.textColor = [UIColor hexStringToColor:@"FFA931"];
        _typeLab.text = @"二次审核未通过";
    }
    return _typeLab;
}

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        
    }
    return _leftImg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:13];
        _nameLab.textColor = Black_Color;
    }
    return _nameLab;
}

-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.textColor = [UIColor hexStringToColor:@"999999"];
        _timeLab.textAlignment = NSTextAlignmentRight;
    }
    return _timeLab;
}

-(UIView *)line
{
    if(!_line)
    {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor hexStringToColor:@"F2F2F2"];
    }
    return _line;
}

-(UILabel *)reasonLab
{
    if(!_reasonLab)
    {
        _reasonLab = [[UILabel alloc] init];
        _reasonLab.font = [UIFont systemFontOfSize:12];
        _reasonLab.textColor = [UIColor hexStringToColor:@"FF0000"];
    }
    return _reasonLab;
}








@end
