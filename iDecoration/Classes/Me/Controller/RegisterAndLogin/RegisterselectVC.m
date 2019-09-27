//
//  RegisterselectVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "RegisterselectVC.h"
#import "VIPExperienceViewController.h"
#import "AppDelegate.h"

@interface RegisterselectVC ()
@property (nonatomic,strong) UIButton *jumpBtn;
@property (nonatomic,strong) UIButton *personalBtn;
@property (nonatomic,strong) UIButton *companyBtn;
@property (nonatomic,strong) UILabel *contentLab;
@end

@implementation RegisterselectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    [self.view addSubview:self.jumpBtn];
    [self.view addSubview:self.contentLab];
    [self.view addSubview:self.personalBtn];
    [self.view addSubview:self.companyBtn];
    [self setuplayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setuplayout
{
    CGFloat hei;
    if (isiPhoneX) {
        hei = 88;
    }
    else
    {
        hei = 64;
    }
    __weak typeof (self) weakSelf = self;
    [weakSelf.jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).with.offset(-31);
        make.top.equalTo(weakSelf.view).with.offset(hei+30);
        make.width.mas_offset(72);
        make.height.mas_offset(31*HEIGHT_SCALE);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_offset(30);
        make.left.equalTo(weakSelf.view).with.offset(14);
        make.top.equalTo(weakSelf.view).with.offset(130*HEIGHT_SCALE+hei);
    }];
    [weakSelf.personalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentLab.mas_bottom).with.offset(75*HEIGHT_SCALE);
        make.width.mas_offset(243);
        make.height.mas_offset(49);
        make.centerX.equalTo(weakSelf.view);
    }];
    [weakSelf.companyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.personalBtn.mas_bottom).with.offset(49*HEIGHT_SCALE);
        make.width.mas_offset(243);
        make.height.mas_offset(49);
        make.centerX.equalTo(weakSelf.view);
    }];
}

#pragma mark - getters

-(UIButton *)jumpBtn
{
    if(!_jumpBtn)
    {
        _jumpBtn = [[UIButton alloc] init];
        [_jumpBtn setTitle:@"跳过" forState:normal];
        [_jumpBtn setTitleColor:[UIColor lightGrayColor] forState:normal];
        _jumpBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        _jumpBtn.layer.masksToBounds = YES;
        _jumpBtn.layer.cornerRadius = 5;
        _jumpBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _jumpBtn.layer.borderWidth = 2;
        [_jumpBtn addTarget:self action:@selector(jumpbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jumpBtn;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.text = @"注册成功";
        _contentLab.font = [UIFont systemFontOfSize:28];
        _contentLab.textColor = Black_Color;
        
    }
    return _contentLab;
}

-(UIButton *)personalBtn
{
    if(!_personalBtn)
    {
        _personalBtn = [[UIButton alloc] init];
        [_personalBtn setTitle:@"我是业主" forState:normal];
        [_personalBtn setTitleColor:Main_Color forState:normal];
        _personalBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _personalBtn.layer.masksToBounds = YES;
        _personalBtn.layer.cornerRadius = 25;
        _personalBtn.layer.borderWidth = 2;
        _personalBtn.layer.borderColor = Main_Color.CGColor;
        [_personalBtn addTarget:self action:@selector(personbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _personalBtn;
}

-(UIButton *)companyBtn
{
    if(!_companyBtn)
    {
        _companyBtn = [[UIButton alloc] init];
        [_companyBtn setTitle:@"我是商家" forState:normal];
        [_companyBtn setTitleColor:Main_Color forState:normal];
        _companyBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _companyBtn.layer.masksToBounds = YES;
        _companyBtn.layer.cornerRadius = 25;
        _companyBtn.layer.borderWidth = 2;
        _companyBtn.layer.borderColor = Main_Color.CGColor;
        [_companyBtn addTarget:self action:@selector(companybtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _companyBtn;
}



#pragma mark - 实现方法

-(void)jumpbtnclick
{
//     [self.navigationController popToViewController:self.navigationController.childViewControllers[1] animated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SNTabBarController * main = [[SNTabBarController alloc] init];
    appDelegate.window.rootViewController = main;
}

-(void)personbtnclick
{
//     [self.navigationController popToViewController:self.navigationController.childViewControllers[1] animated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SNTabBarController * main = [[SNTabBarController alloc] init];
    appDelegate.window.rootViewController = main;
}

-(void)companybtnclick
{
    VIPExperienceViewController *vc = [VIPExperienceViewController new];
    vc.islogup = YES;
    vc.isNew = YES;
    vc.companyNumber = self.companyNumber;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
