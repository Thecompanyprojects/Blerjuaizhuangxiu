//
//  selectlogtypeVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "selectlogtypeVC.h"
#import "CreateConstructionViewController.h"



@interface selectlogtypeVC ()
@property (nonatomic,strong) UILabel *topLab;
@property (nonatomic,strong) UIButton *leftImg;
@property (nonatomic,strong) UIButton *rightImg;
@property (nonatomic,strong) UILabel *leftLab;
@property (nonatomic,strong) UILabel *rightLab;
@end

@implementation selectlogtypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择日志";
    [self.view addSubview:self.topLab];
    [self.view addSubview:self.leftImg];
    [self.view addSubview:self.rightImg];
    [self.view addSubview:self.leftLab];
    [self.view addSubview:self.rightLab];
    [self setuplayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).with.offset(kNaviBottom+30);
        make.height.mas_offset(20);
    }];
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLab.mas_bottom).with.offset(30);
        make.width.mas_offset(56);
        make.height.mas_offset(56);
        make.left.equalTo(weakSelf.view).with.offset(kSCREEN_WIDTH/4-56/2);
    }];
    [weakSelf.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLab.mas_bottom).with.offset(30);
        make.width.mas_offset(56);
        make.height.mas_offset(56);
        make.right.equalTo(weakSelf.view).with.offset(-kSCREEN_WIDTH/4+56/2);
    }];
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImg.mas_bottom).with.offset(12);
        make.height.mas_offset(20);
        make.left.equalTo(weakSelf.leftImg);
        make.right.equalTo(weakSelf.leftImg);
    }];

    [weakSelf.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftLab);
        make.height.mas_offset(20);
        make.left.equalTo(weakSelf.rightImg);
        make.right.equalTo(weakSelf.rightImg);
    }];
}

#pragma mark - getters

-(UILabel *)topLab
{
    if(!_topLab)
    {
        _topLab = [[UILabel alloc] init];
        _topLab.textAlignment = NSTextAlignmentCenter;
        _topLab.text = @"请选择日志类型";
        _topLab.font = [UIFont systemFontOfSize:13];
        _topLab.textColor = [UIColor hexStringToColor:@"666666"];
    }
    return _topLab;
}

-(UIButton *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIButton alloc] init];
        //_leftImg.image = [UIImage imageNamed:@"icon_shigongrzhi"];
        [_leftImg setImage:[UIImage imageNamed:@"icon_zhucairzhi"] forState:normal];
        [_leftImg addTarget:self action:@selector(leftimgclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftImg;
}

-(UIButton *)rightImg
{
    if(!_rightImg)
    {
        _rightImg = [[UIButton alloc] init];
        //_rightImg.image = [UIImage imageNamed:@""];
        [_rightImg setImage:[UIImage imageNamed:@"icon_shigongrzhi"] forState:normal];
        [_rightImg addTarget:self action:@selector(rightimgclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightImg;
}


-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.textAlignment = NSTextAlignmentCenter;
        _leftLab.text = @"主材日志";
        _leftLab.font = [UIFont systemFontOfSize:12];
        _leftLab.textColor = [UIColor hexStringToColor:@"333333"];
    }
    return _leftLab;
}

-(UILabel *)rightLab
{
    if(!_rightLab)
    {
        _rightLab = [[UILabel alloc] init];
        _rightLab.textAlignment = NSTextAlignmentCenter;
        _rightLab.text = @"施工日志";
        _rightLab.font = [UIFont systemFontOfSize:12];
        _rightLab.textColor = [UIColor hexStringToColor:@"333333"];
    }
    return _rightLab;
}

#pragma mark - 跳转方法

//主材日志
-(void)leftimgclick
{
     CreateConstructionViewController *companyVC = [[CreateConstructionViewController alloc]init];
     companyVC.roleTypeId = self.roleTypeId;
     companyVC.companyId = [self.dict objectForKey:@"companyId"];
     companyVC.companyType = [[self.dict objectForKey:@"companyType"]integerValue];
     companyVC.companyName = [self.dict objectForKey:@"companyName"];
     companyVC.constructionType = @"1";
     companyVC.cityId = self.cityId;
    
     [self.navigationController pushViewController:companyVC animated:YES];
}

//施工日志
-(void)rightimgclick
{
     CreateConstructionViewController *companyVC = [[CreateConstructionViewController alloc]init];
     companyVC.roleTypeId = self.roleTypeId;
     companyVC.companyId = [self.dict objectForKey:@"companyId"];
     companyVC.companyType = [[self.dict objectForKey:@"companyType"]integerValue];
     companyVC.companyName = [self.dict objectForKey:@"companyName"];
     companyVC.constructionType = @"0";
     companyVC.cityId = self.cityId;
     companyVC.countyId = self.countyId;
     [self.navigationController pushViewController:companyVC animated:YES];
}

@end
