//
//  declarationcardVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/7.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "declarationcardVC.h"
#import "destributionwebVC.h"

@interface declarationcardVC ()
@property (nonatomic,strong) UIImageView *bgImg;
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *topLab;
@property (nonatomic,strong) UILabel *leftLab0;
@property (nonatomic,strong) UILabel *leftLab1;
@property (nonatomic,strong) UILabel *leftLab2;
@property (nonatomic,strong) UILabel *leftLab3;
@property (nonatomic,strong) UILabel *leftLab4;
@property (nonatomic,strong) UILabel *leftLab5;
@property (nonatomic,strong) UILabel *leftLab6;
@property (nonatomic,strong) UILabel *rightLab0;
@property (nonatomic,strong) UILabel *rightLab1;
@property (nonatomic,strong) UILabel *rightLab2;
@property (nonatomic,strong) UILabel *rightLab3;
@property (nonatomic,strong) UILabel *rightLab4;
@property (nonatomic,strong) UILabel *rightLab5;
@property (nonatomic,strong) UILabel *rightLab6;
@property (nonatomic,strong) UIImageView *codeImg;
@property (nonatomic,strong) UILabel *contentlab0;
@property (nonatomic,strong) UILabel *contentlab1;
@property (nonatomic,strong) UILabel *contentlab2;
@property (nonatomic,strong) UIImageView *starImg;
@property (nonatomic,strong) NSDictionary *middleIncomeInfo;//对接人
@property (nonatomic,strong) NSDictionary *spreadIncomeInfo;//分销员自己
@property (nonatomic,strong) NSDictionary *proxyMiddleIncomeInfo;//代理对接人
@property (nonatomic,strong) NSDictionary *cardInfo;
@property (nonatomic,strong) NSDictionary *upTeam;
@property (nonatomic,strong) NSDictionary *upUpTeam;
@end

@implementation declarationcardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"团队报单卡";
    [self loaddata];
    [self.view addSubview:self.bgImg];
    [self.view addSubview:self.iconImg];
    [self.view addSubview:self.topLab];
    [self.view addSubview:self.leftLab0];
    [self.view addSubview:self.leftLab1];
    [self.view addSubview:self.leftLab2];
    [self.view addSubview:self.leftLab3];
    [self.view addSubview:self.leftLab4];
    [self.view addSubview:self.leftLab5];
    [self.view addSubview:self.leftLab6];
    [self.view addSubview:self.rightLab0];
    [self.view addSubview:self.rightLab1];
    [self.view addSubview:self.rightLab2];
    [self.view addSubview:self.rightLab3];
    [self.view addSubview:self.rightLab4];
    [self.view addSubview:self.rightLab5];
    [self.view addSubview:self.rightLab6];
    [self.view addSubview:self.starImg];
    [self.view addSubview:self.codeImg];
    [self.view addSubview:self.contentlab0];
    [self.view addSubview:self.contentlab1];
    [self.view addSubview:self.contentlab2];
    [self setupUI];
}

-(void)loaddata
{
    NSDictionary *dic = @{@"incomeId":self.incomeId};
    NSString *url = [BASEURL stringByAppendingString:GET_reportCard];
    [NetManager afGetRequest:url parms:dic finished:^(id responseObj) {
        self.cardInfo = [responseObj objectForKey:@"cardInfo"];
        self.middleIncomeInfo = [responseObj objectForKey:@"middleIncomeInfo"];
        self.spreadIncomeInfo = [responseObj objectForKey:@"spreadIncomeInfo"];
        self.proxyMiddleIncomeInfo = [responseObj objectForKey:@"proxyMiddleIncomeInfo"];
        NSDictionary *data = [responseObj objectForKey:@"data"];
        self.upTeam = [data objectForKey:@"upTeam"];
        self.upUpTeam = [data objectForKey:@"upUpTeam"];
        [self setdata];
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)setdata
{
    NSString *newname = [self.spreadIncomeInfo objectForKey:@"trueName"];
    NSString *str1 = [NSString new];
    if (newname.length>3) {
        str1 = [NSString stringWithFormat:@"%@%@",[newname substringToIndex:3],@"..."];
    }
    else
    {
        str1 = newname;
    }
    NSString *str2 = [NSString stringWithFormat:@"%@%@",@"的邀请码:",[self.spreadIncomeInfo objectForKey:@"createCode"]];
    NSString *str = [NSString stringWithFormat:@"%@%@",str1,str2];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"25B764"]range:NSMakeRange(0, str1.length)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"333333"]range:NSMakeRange(str1.length, str2.length)];
    self.contentlab0.font = [UIFont systemFontOfSize:12];
    self.contentlab0.attributedText = AttributedStr;
    NSString *str3 = @"注册或申请成为分销员时输入";
    NSString *str4 = @"的邀请码";
    NSString *newstr = [NSString stringWithFormat:@"%@%@%@",str3,str1,str4];
    NSMutableAttributedString *AttributedStr2 = [[NSMutableAttributedString alloc]initWithString:newstr];
    [AttributedStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"333333"]range:NSMakeRange(0, str3.length)];
    [AttributedStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"25B764"]range:NSMakeRange(str3.length, str1.length)];
    [AttributedStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"333333"]range:NSMakeRange(str3.length+str1.length, str4.length)];
    self.contentlab1.font = [UIFont systemFontOfSize:12];
    self.contentlab1.attributedText = AttributedStr2;
    NSString *str5 = @"即可加入";
    NSString *str6 = @"的团队，和我们一起为明天奋斗";
    NSString *newstr2 = [NSString stringWithFormat:@"%@%@%@",str5,str1,str6];
    NSMutableAttributedString *AttributedStr3 = [[NSMutableAttributedString alloc]initWithString:newstr2];
    [AttributedStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"333333"]range:NSMakeRange(0, str5.length)];
    [AttributedStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"25B764"]range:NSMakeRange(str5.length, str1.length)];
    [AttributedStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"333333"]range:NSMakeRange(str5.length+str1.length, str6.length)];
    self.contentlab2.font = [UIFont systemFontOfSize:12];
    self.contentlab2.attributedText = AttributedStr3;
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[self.spreadIncomeInfo objectForKey:@"photo"]]];
    self.leftLab0.text = @"公司名称";
    self.rightLab0.text = [self.cardInfo objectForKey:@"companyName"];
    NSString  *islevel1 =  [NSString stringWithFormat:@"%@",[self.spreadIncomeInfo objectForKey:@"islevel"]];
    if ([islevel1 isEqualToString:@"1"]) {
        self.leftLab1.text = @"一级分销员";
    }
    if ([islevel1 isEqualToString:@"2"]) {
        self.leftLab1.text = @"二级分销员";
    }
    if ([islevel1 isEqualToString:@"3"]) {
        self.leftLab1.text = @"三级分销员";
    }
    self.rightLab1.text = [NSString stringWithFormat:@"%@%@%@",str1,@"￥",[self.spreadIncomeInfo objectForKey:@"incomeMoney"]];
    NSString *newvalue0 = [self.upTeam objectForKey:@"trueName"];
    NSString *newvalue1 = [self.upUpTeam objectForKey:@"trueName"];
    NSString *newvalue2 = [self.middleIncomeInfo objectForKey:@"trueName"];//代理对接人
    NSString *newvalue3 = [self.proxyMiddleIncomeInfo objectForKey:@"trueName"];//对接人
    NSString *value0 = [NSString new];
    NSString *value1 = [NSString new];
    NSString *value2 = [NSString new];
    NSString *value3 = [NSString new];
    if (newvalue0.length>3) {
        value0 = [NSString stringWithFormat:@"%@%@",[newvalue0 substringToIndex:3],@"..."];
    }
    else
    {
        value0 = newvalue0;
    }
    if (newvalue1.length>3) {
        value1 = [NSString stringWithFormat:@"%@%@",[newvalue1 substringToIndex:3],@"..."];
    }
    else
    {
        value1 = newvalue1;
    }
    if (newvalue2.length>3) {
        value2 = [NSString stringWithFormat:@"%@%@",[newvalue2 substringToIndex:3],@"..."];
        
    }
    else
    {
        value2 = newvalue2;
    }
    if (newvalue3.length>3) {
        value3 = [NSString stringWithFormat:@"%@%@",[newvalue3 substringToIndex:3],@"..."];
    }
    else
    {
        value3 = newvalue3;
    }
    if (IsNilString(value0)) {
        [self.leftLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(-15);
        }];
        [self.rightLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(-15);
        }];
    }
    if (IsNilString(value1)) {
        [self.leftLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(-15);
        }];
        [self.rightLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(-15);
        }];
    }
    if (IsNilString(value2)) {
        [self.leftLab4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(-15);
        }];
        [self.rightLab4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(-15);
        }];
    }
    if (IsNilString(value3)) {
        [self.leftLab5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(-15);
        }];
        [self.rightLab5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(-15);
        }];
    }
    NSString  *islevel2 =  [NSString stringWithFormat:@"%@",[self.upTeam objectForKey:@"islevel"]];
    if ([islevel2 isEqualToString:@"1"]) {
        self.leftLab2.text = @"一级分销员";
    }
    if ([islevel2 isEqualToString:@"2"]) {
        self.leftLab2.text = @"二级分销员";
    }
    if ([islevel2 isEqualToString:@"3"]) {
        self.leftLab2.text = @"三级分销员";
    }
    
    self.rightLab2.text  = [NSString stringWithFormat:@"%@%@%@",value0,@"￥",[self.upTeam objectForKey:@"incomeMoney"]];
    NSString  *islevel3 =  [NSString stringWithFormat:@"%@",[self.upUpTeam objectForKey:@"islevel"]];
    if ([islevel3 isEqualToString:@"1"]) {
        self.leftLab3.text = @"一级分销员";
    }
    if ([islevel3 isEqualToString:@"2"]) {
        self.leftLab3.text = @"二级分销员";
    }
    if ([islevel3 isEqualToString:@"3"]) {
        self.leftLab3.text = @"三级分销员";
    }
    self.rightLab3.text = [NSString stringWithFormat:@"%@%@%@",value1,@"￥",[self.upUpTeam objectForKey:@"incomeMoney"]];
    self.rightLab5.text = [NSString stringWithFormat:@"%@%@%@",value2,@"￥",[self.middleIncomeInfo objectForKey:@"incomeMoney"]];
    self.leftLab5.text = @"对接人";
    self.rightLab4.text = [NSString stringWithFormat:@"%@%@%@",value3,@"￥",[self.proxyMiddleIncomeInfo objectForKey:@"incomeMoney"]];
    self.leftLab4.text = @"代理对接人";
    self.leftLab6.text = @"时间";
    self.rightLab6.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStampWithSeconds:[self.cardInfo objectForKey:@"reportTime"]];
}

-(void)setupUI
{
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(kNaviBottom+20);
        make.height.mas_offset(551);
    }];
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImg).with.offset(-8);
        make.width.mas_offset(74);
        make.height.mas_offset(74);
        make.centerX.equalTo(self.view);
    }];
    
    [self.topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(18);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.iconImg.mas_bottom).with.offset(10);
        make.left.equalTo(self.view).with.offset(14);
    }];

    [self.leftLab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImg).with.offset(20);
        make.top.equalTo(self.bgImg.mas_top).with.offset(110);
        //make.height.mas_offset(18);
    }];

    [self.rightLab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftLab0);
        make.right.equalTo(self.bgImg).with.offset(-14);
    }];
    
    [self.leftLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLab0);
       // make.width.mas_offset(80);
        make.top.equalTo(self.leftLab0.mas_bottom).with.offset(15);
    }];
    
    [self.rightLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightLab0);
        make.top.equalTo(self.leftLab1);
    }];
    
    [self.starImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightLab1);
        make.right.equalTo(self.rightLab1.mas_left).with.offset(-6);
        make.width.mas_offset(14);
        make.height.mas_offset(14);
    }];
    
    [self.leftLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLab0);
      //  make.height.mas_offset(18);
        make.top.equalTo(self.leftLab1.mas_bottom).with.offset(15);
    }];
    
    [self.rightLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightLab0);
       // make.height.mas_offset(18);
        make.top.equalTo(self.leftLab2);
    }];
    
    [self.leftLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLab0);
       // make.height.mas_offset(18);
        make.top.equalTo(self.leftLab2.mas_bottom).with.offset(15);
    }];
    
    [self.rightLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightLab0);
       // make.height.mas_offset(18);
        make.top.equalTo(self.rightLab2.mas_bottom).with.offset(15);
    }];
    
    [self.leftLab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLab0);
       // make.height.mas_offset(18);
        make.top.equalTo(self.leftLab3.mas_bottom).with.offset(15);
    }];
    
    [self.rightLab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightLab0);
        make.top.equalTo(self.leftLab4);
       // make.height.mas_offset(18);
    }];
    
    [self.leftLab5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLab0);
        make.top.equalTo(self.leftLab4.mas_bottom).with.offset(15);
    }];
    
    [self.rightLab5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightLab0);
        make.top.equalTo(self.leftLab5);
    }];
    
    [self.leftLab6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLab0);
        make.top.equalTo(self.leftLab5.mas_bottom).with.offset(15);
    }];
    
    [self.rightLab6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightLab0);
        make.top.equalTo(self.leftLab6);
    }];
    
    [self.contentlab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgImg).with.offset(-12);
        make.height.mas_offset(18);
        make.left.equalTo(self.bgImg).with.offset(14);
        make.centerX.equalTo(self.bgImg);
    }];
    
    [self.contentlab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentlab1);
        make.bottom.equalTo(self.contentlab2.mas_top).with.offset(-10);
        make.centerX.equalTo(self.bgImg);
        make.height.mas_offset(18);
    }];
    
    [self.contentlab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentlab1);
        make.bottom.equalTo(self.contentlab1.mas_top).with.offset(-10);
        make.centerX.equalTo(self.bgImg);
        make.height.mas_offset(18);
    }];
    
    [self.codeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentlab0.mas_top).with.offset(-14);
        make.centerX.equalTo(self.bgImg);
        make.width.mas_offset(90);
        make.height.mas_offset(90);
    }];
}

#pragma mark - getters

-(UIImageView *)bgImg
{
    if(!_bgImg)
    {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.image = [UIImage imageNamed:@"bg_baiseban"];
    }
    return _bgImg;
}

-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 74/2;
    }
    return _iconImg;
}

-(UILabel *)topLab
{
    if(!_topLab)
    {
        _topLab = [[UILabel alloc] init];
        _topLab.textAlignment = NSTextAlignmentCenter;
        _topLab.textColor = [UIColor hexStringToColor:@"25B764"];
        _topLab.font = [UIFont systemFontOfSize:14];
        _topLab.text = @"报单详情";
    }
    return _topLab;
}

-(UILabel *)leftLab0
{
    if(!_leftLab0)
    {
        _leftLab0 = [[UILabel alloc] init];
        _leftLab0.textColor = [UIColor hexStringToColor:@"040000"];
        _leftLab0.font = [UIFont systemFontOfSize:14];
    }
    return _leftLab0;
}

-(UILabel *)leftLab1
{
    if(!_leftLab1)
    {
        _leftLab1 = [[UILabel alloc] init];
        _leftLab1.textColor = [UIColor hexStringToColor:@"040000"];
        _leftLab1.font = [UIFont systemFontOfSize:14];
    }
    return _leftLab1;
}

-(UILabel *)leftLab2
{
    if(!_leftLab2)
    {
        _leftLab2 = [[UILabel alloc] init];
        _leftLab2.textColor = [UIColor hexStringToColor:@"040000"];
        _leftLab2.font = [UIFont systemFontOfSize:14];
    }
    return _leftLab2;
}

-(UILabel *)leftLab3
{
    if(!_leftLab3)
    {
        _leftLab3 = [[UILabel alloc] init];
        _leftLab3.textColor = [UIColor hexStringToColor:@"040000"];
        _leftLab3.font = [UIFont systemFontOfSize:14];
    }
    return _leftLab3;
}

-(UILabel *)leftLab4
{
    if(!_leftLab4)
    {
        _leftLab4 = [[UILabel alloc] init];
        _leftLab4.textColor = [UIColor hexStringToColor:@"040000"];
        _leftLab4.font = [UIFont systemFontOfSize:14];
    }
    return _leftLab4;
}

-(UILabel *)leftLab5
{
    if(!_leftLab5)
    {
        _leftLab5 = [[UILabel alloc] init];
        _leftLab5.textColor = [UIColor hexStringToColor:@"040000"];
        _leftLab5.font = [UIFont systemFontOfSize:14];
    }
    return _leftLab5;
}

-(UILabel *)leftLab6
{
    if(!_leftLab6)
    {
        _leftLab6 = [[UILabel alloc] init];
        _leftLab6.textColor = [UIColor hexStringToColor:@"040000"];
        _leftLab6.font = [UIFont systemFontOfSize:14];
    }
    return _leftLab6;
}


-(UILabel *)rightLab0
{
    if(!_rightLab0)
    {
        _rightLab0 = [[UILabel alloc] init];
        _rightLab0.font = [UIFont systemFontOfSize:14];
        _rightLab0.textColor = [UIColor hexStringToColor:@"333333"];
        _rightLab0.textAlignment = NSTextAlignmentRight;
    }
    return _rightLab0;
}

-(UILabel *)rightLab1
{
    if(!_rightLab1)
    {
        _rightLab1 = [[UILabel alloc] init];
        _rightLab1.font = [UIFont systemFontOfSize:14];
        _rightLab1.textColor = [UIColor hexStringToColor:@"333333"];
        _rightLab1.textAlignment = NSTextAlignmentRight;
    }
    return _rightLab1;
}

-(UILabel *)rightLab2
{
    if(!_rightLab2)
    {
        _rightLab2 = [[UILabel alloc] init];
        _rightLab2.font = [UIFont systemFontOfSize:14];
        _rightLab2.textColor = [UIColor hexStringToColor:@"333333"];
        _rightLab2.textAlignment = NSTextAlignmentRight;
    }
    return _rightLab2;
}

-(UILabel *)rightLab3
{
    if(!_rightLab3)
    {
        _rightLab3 = [[UILabel alloc] init];
        _rightLab3.font = [UIFont systemFontOfSize:14];
        _rightLab3.textColor = [UIColor hexStringToColor:@"333333"];
        _rightLab3.textAlignment = NSTextAlignmentRight;
    }
    return _rightLab3;
}

-(UILabel *)rightLab4
{
    if(!_rightLab4)
    {
        _rightLab4 = [[UILabel alloc] init];
        _rightLab4.font = [UIFont systemFontOfSize:14];
        _rightLab4.textColor = [UIColor hexStringToColor:@"333333"];
        _rightLab4.textAlignment = NSTextAlignmentRight;
    }
    return _rightLab4;
}

-(UILabel *)rightLab5
{
    if(!_rightLab5)
    {
        _rightLab5 = [[UILabel alloc] init];
        _rightLab5.font = [UIFont systemFontOfSize:14];
        _rightLab5.textColor = [UIColor hexStringToColor:@"333333"];
        _rightLab5.textAlignment = NSTextAlignmentRight;
    }
    return _rightLab5;
}

-(UILabel *)rightLab6
{
    if(!_rightLab6)
    {
        _rightLab6 = [[UILabel alloc] init];
        _rightLab6.font = [UIFont systemFontOfSize:14];
        _rightLab6.textColor = [UIColor hexStringToColor:@"333333"];
        _rightLab6.textAlignment = NSTextAlignmentRight;
    }
    return _rightLab6;
}




-(UIImageView *)codeImg
{
    if(!_codeImg)
    {
        _codeImg = [[UIImageView alloc] init];
        _codeImg.image = [UIImage imageNamed:@"qrcode_1524798777"];
    }
    return _codeImg;
}

-(UILabel *)contentlab0
{
    if(!_contentlab0)
    {
        _contentlab0 = [[UILabel alloc] init];
        _contentlab0.textAlignment = NSTextAlignmentCenter;
    }
    return _contentlab0;
}

-(UILabel *)contentlab1
{
    if(!_contentlab1)
    {
        _contentlab1 = [[UILabel alloc] init];
        _contentlab1.textAlignment = NSTextAlignmentCenter;
    }
    return _contentlab1;
}

-(UILabel *)contentlab2
{
    if(!_contentlab2)
    {
        _contentlab2 = [[UILabel alloc] init];
        _contentlab2.textAlignment = NSTextAlignmentCenter;
    }
    return _contentlab2;
}

-(UIImageView *)starImg
{
    if(!_starImg)
    {
        _starImg = [[UIImageView alloc] init];
        _starImg.image = [UIImage imageNamed:@"icon_newstar"];
    }
    return _starImg;
}


-(NSDictionary *)spreadIncomeInfo
{
    if(!_spreadIncomeInfo)
    {
        _spreadIncomeInfo = [NSDictionary dictionary];
        
    }
    return _spreadIncomeInfo;
}

-(NSDictionary *)middleIncomeInfo
{
    if(!_middleIncomeInfo)
    {
        _middleIncomeInfo = [NSDictionary dictionary];
        
    }
    return _middleIncomeInfo;
}

-(NSDictionary *)cardInfo
{
    if(!_cardInfo)
    {
        _cardInfo = [NSDictionary dictionary];
        
    }
    return _cardInfo;
}

-(NSDictionary *)upTeam
{
    if(!_upTeam)
    {
        _upTeam = [NSDictionary dictionary];
        
    }
    return _upTeam;
}

-(NSDictionary *)upUpTeam
{
    if(!_upUpTeam)
    {
        _upUpTeam = [NSDictionary dictionary];
        
    }
    return _upUpTeam;
}

-(NSDictionary *)proxyMiddleIncomeInfo
{
    if(!_proxyMiddleIncomeInfo)
    {
        _proxyMiddleIncomeInfo = [NSDictionary dictionary];
        
    }
    return _proxyMiddleIncomeInfo;
}

@end
