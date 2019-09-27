//
//  rapidpromotionVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "rapidpromotionVC.h"
//导航栏+状态栏高度
#define NAVIGATION_HEIGHT (CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(self.navigationController.navigationBar.frame))
@interface rapidpromotionVC ()
@property (nonatomic,strong) UIImageView *imgbg;
@property (nonatomic,strong) UIImageView *img1;
@property (nonatomic,strong) UILabel *lab0;
@property (nonatomic,strong) UIImageView *borderimg;
@property (nonatomic,strong) UIImageView *img2;
@property (nonatomic,strong) UIImageView *textborder;
@property (nonatomic,strong) UILabel *textLab;
@property (nonatomic,strong) UILabel *lab1;
@property (nonatomic,strong) UILabel *lab2;
@property (nonatomic,strong) UILabel *lab3;
@property (nonatomic,strong) UIImageView *codeImg;
@end

@implementation rapidpromotionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"加入我们";
    [self.view addSubview:self.imgbg];
    [self.view addSubview:self.img1];
    [self.view addSubview:self.lab0];
    [self.view addSubview:self.borderimg];
    [self.view addSubview:self.textborder];
    [self.view addSubview:self.img2];
    [self.view addSubview:self.textLab];
    [self.view addSubview:self.lab1];
    [self.view addSubview:self.lab2];
    [self.view addSubview:self.lab3];
    [self.view addSubview:self.codeImg];
    [self setupUI];
    [self setdata];
}

-(void)setdata
{
    NSString *name = self.trueName;
    NSString *str1 = @"的邀请码:";
    NSString *codestr = self.createCode;
    NSString *str = [NSString stringWithFormat:@"%@%@%@",name,str1,codestr];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"FF2802"] range:NSMakeRange(0, name.length)];
    self.textLab.attributedText = attrStr;
    
    NSString *str2 = @"注册或者申请成为分销员时输入";
    NSString *str3 = @"的邀请码";
    NSString *astr = [NSString stringWithFormat:@"%@%@%@",str2,name,str3];
    NSMutableAttributedString *attrStr2 = [[NSMutableAttributedString alloc]initWithString:astr];
    [attrStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"FF2802"] range:NSMakeRange(str2.length, name.length)];
    self.lab2.attributedText = attrStr2;

    
    NSString *str4 = @"即可加入";
    NSString *str5 = @"的分销团队，和我们一起为明天而奋斗";

    NSString *newstr = [NSString stringWithFormat:@"%@%@%@",str4,name,str5];
    NSMutableAttributedString *attrStr3 = [[NSMutableAttributedString alloc]initWithString:newstr];
    [attrStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"FF2802"] range:NSMakeRange(str4.length, name.length)];

    self.lab3.attributedText = attrStr3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupUI
{
    [self.img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(27);
        make.top.equalTo(self.imgbg).with.offset(25);
        make.width.mas_offset(80);
        make.height.mas_offset(80);
    }];
    [self.lab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(100);
        make.right.equalTo(self.view).with.offset(-70);
        make.top.equalTo(self.imgbg).with.offset(80);
    }];
    [self.borderimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.imgbg).with.offset(141);
        make.width.mas_offset(141);
        make.height.mas_offset(141);
        
    }];
    [self.textborder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_offset(264);
        make.height.mas_offset(43);
        make.top.equalTo(self.borderimg.mas_bottom).with.offset(34);
    }];
    
    [self.img2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.img1);
        make.top.equalTo(self.textborder.mas_bottom).with.offset(40);
        make.width.mas_offset(80);
        make.height.mas_offset(80);
    }];
    
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textborder);
        make.right.equalTo(self.textborder);
        make.top.equalTo(self.textborder);
        make.bottom.equalTo(self.textborder);
    }];
    
    [self.lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(90);
        make.top.equalTo(self.textborder.mas_bottom).with.offset(90);
    }];
    [self.lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.lab1.mas_bottom).with.offset(20);
    }];
    [self.lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.lab2.mas_bottom).with.offset(15);
    }];
    [self.codeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.borderimg).with.offset(1);
        make.top.equalTo(self.borderimg).with.offset(1);
        make.right.equalTo(self.borderimg).with.offset(-1);
        make.bottom.equalTo(self.borderimg).with.offset(-1);
    }];
}

#pragma mark - getters

-(UIImageView *)imgbg
{
    if(!_imgbg)
    {
        _imgbg = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT-NAVIGATION_HEIGHT)];
       _imgbg.image = [UIImage imageNamed:@"矩形6"];
    }
    return _imgbg;
}

-(UIImageView *)img1
{
    if(!_img1)
    {
        _img1 = [[UIImageView alloc] init];
        _img1.image = [UIImage imageNamed:@"1-1"];
    }
    return _img1;
}

-(UILabel *)lab0
{
    if(!_lab0)
    {
        _lab0 = [[UILabel alloc] init];
        _lab0.text = @"";
        _lab0.textAlignment = NSTextAlignmentCenter;
        _lab0.font = [UIFont fontWithName:@"Adobe Heiti Std R" size:18];
        _lab0.textColor = [UIColor hexStringToColor:@"000000"];
        _lab0.text = @"长按二维码下载app";
    }
    return _lab0;
}


-(UIImageView *)borderimg
{
    if(!_borderimg)
    {
        _borderimg = [[UIImageView alloc] init];
        _borderimg.image = [UIImage imageNamed:@"矩形 4"];
    }
    return _borderimg;
}


-(UIImageView *)img2
{
    if(!_img2)
    {
        _img2 = [[UIImageView alloc] init];
        _img2.image = [UIImage imageNamed:@"2"];
    }
    return _img2;
}


-(UIImageView *)textborder
{
    if(!_textborder)
    {
        _textborder = [[UIImageView alloc] init];
        _textborder.image = [UIImage imageNamed:@"矩形5"];
    }
    return _textborder;
}


-(UILabel *)textLab
{
    if(!_textLab)
    {
        _textLab = [[UILabel alloc] init];
        _textLab.textAlignment = NSTextAlignmentCenter;
        _textLab.font = [UIFont fontWithName:@"Adobe Heiti Std R" size:18];
        _textLab.textColor = [UIColor hexStringToColor:@"000000"];
    }
    return _textLab;
}


-(UILabel *)lab1
{
    if(!_lab1)
    {
        _lab1 = [[UILabel alloc] init];
        _lab1.text = @"下载app ";
        _lab1.font = [UIFont systemFontOfSize:30];
//        _lab1.font = [UIFont fontWithName:@"FZMWJW--GB1-0" size:30];
        _lab1.textColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1];
        _lab1.textAlignment = NSTextAlignmentCenter;
    }
    return _lab1;
}

-(UILabel *)lab2
{
    if(!_lab2)
    {
        _lab2 = [[UILabel alloc] init];
        _lab2.font = [UIFont fontWithName:@"FZMWJW--GB1-0" size:18];
        _lab2.textColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1];
        _lab2.textAlignment = NSTextAlignmentCenter;
        _lab2.numberOfLines = 0;
    }
    return _lab2;
}


-(UILabel *)lab3
{
    if(!_lab3)
    {
        _lab3 = [[UILabel alloc] init];
        _lab3.numberOfLines = 0;
        _lab3.font = [UIFont fontWithName:@"FZMWJW" size:18];
        _lab3.textColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1];
        _lab3.textAlignment = NSTextAlignmentCenter;
    }
    return _lab3;
}


-(UIImageView *)codeImg
{
    if(!_codeImg)
    {
        _codeImg = [[UIImageView alloc] init];
//        [_codeImg sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1523380338855&di=1d1a79a0d62621ca471dd2dc9c4ae194&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fzhidao%2Fwh%253D450%252C600%2Fsign%3Db3194d729e82d158bbd751b5b53a35ee%2F342ac65c1038534399e24cbd9113b07eca808879.jpg"]];
        _codeImg.image = [UIImage imageNamed:@"qrcode_1524798777"];
    }
    return _codeImg;
}



@end
