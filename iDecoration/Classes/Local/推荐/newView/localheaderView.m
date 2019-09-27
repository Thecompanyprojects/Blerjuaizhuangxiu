//
//  localheaderView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/21.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localheaderView.h"
#import "SDCycleScrollView.h"
#import "localchooseView0.h"
#import "localchooseView1.h"
#import "SGAdvertScrollView.h"
#import "newrankingView.h"
#import "LocalbannerModel.h"
#import "localcompanyPhone.h"
#import "rankingModel.h"

typedef NS_ENUM(NSInteger, rankType)
{
    rankTypearr0,
    rankTypearr1,
    rankTypearr2
};

@interface localheaderView()<SDCycleScrollViewDelegate,SGAdvertScrollViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *scroll;
@property (nonatomic,strong) UILabel *lab0;
@property (nonatomic,strong) UILabel *lab1;
@property (nonatomic,strong) UILabel *lab2;
@property (nonatomic,strong) UILabel *lab3;
@property (nonatomic,strong) UIView *line0;

@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;
@property (nonatomic,strong) UIView *line3;
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UIView *line4;
@property (nonatomic,strong) SGAdvertScrollView *bobaoLab;
@property (nonatomic,strong) UIView *line5;
@property (nonatomic,strong) UIImageView *topImg;
@property (nonatomic,strong) UISegmentedControl *segment;
@property (nonatomic,strong) newrankingView *rankingView0;
@property (nonatomic,strong) newrankingView *rankingView1;
@property (nonatomic,strong) newrankingView *rankingView2;
@property (nonatomic,strong) UIView *line6;
@property (nonatomic,strong) UIView *line7;
@property (nonatomic,strong) UIView *line8;

@property (nonatomic,assign) rankType type;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) NSMutableArray *ranklist0;
@property (nonatomic,strong) NSMutableArray *ranklist1;
@property (nonatomic,strong) NSMutableArray *ranklist2;

@property (nonatomic,strong) NSMutableArray *masonryViewArray;
@end

@implementation localheaderView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.index = 0;
        [self addSubview:self.scroll];
        [self addSubview:self.btn0];
        [self addSubview:self.btn1];
        [self addSubview:self.btn2];
        [self addSubview:self.btn3];
        [self addSubview:self.lab0];
        [self addSubview:self.lab1];
        [self addSubview:self.lab2];
        [self addSubview:self.lab3];
        
        
        [self addSubview:self.line0];
        [self addSubview:self.chooseView0];
        [self addSubview:self.line1];
        [self addSubview:self.line2];
        [self addSubview:self.chooseView1];
        [self addSubview:self.chooseView2];
        [self addSubview:self.line3];
        [self addSubview:self.leftImg];
        [self addSubview:self.bobaomoreBtn];
        [self addSubview:self.line4];
        [self addSubview:self.bobaoLab];
       
        [self addSubview:self.line5];
        [self addSubview:self.topImg];
        [self addSubview:self.segment];
        [self addSubview:self.rankingView0];
        [self addSubview:self.rankingView1];
        [self addSubview:self.rankingView2];
        [self addSubview:self.line6];
        [self addSubview:self.line7];
        [self addSubview:self.line8];
        [self addSubview:self.rankingmoreBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setbanner:(NSMutableArray *)banner
{
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i<banner.count; i++) {
        LocalbannerModel *model = [banner objectAtIndex:i];
        NSString *str = model.picUrl;
        [arr addObject:str];
    }
    self.scroll.imageURLStringsGroup = arr;
}

-(void)setdatafrom:(NSMutableArray *)labelarray
{
    if (labelarray.count!=0) {
        NSMutableArray *dataSource = [NSMutableArray array];
        for (int i = 0; i<labelarray.count; i++) {
            
            localcompanyPhone *model = labelarray[i];
            NSString *str1 = @"手机尾号";
            NSString *str2 = model.companyNumber;
            NSString *str3 = @"的用户注册成为";
            NSString *str4 = model.companyName;
            NSString *str5 = @"商家";
            NSString *newStr = [NSString stringWithFormat:@"%@%@%@%@%@",str1,str2,str3,str4,str5];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:newStr];
            [dataSource addObject:AttributedStr];
        }
        self.bobaoLab.titles = dataSource;
    }
}
-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(221);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
    }];
    self.masonryViewArray = [NSMutableArray array];
    [self.masonryViewArray addObject:self.btn0];
    [self.masonryViewArray addObject:self.btn1];
    [self.masonryViewArray addObject:self.btn2];
    [self.masonryViewArray addObject:self.btn3];
    
    // 实现masonry水平固定间隔方法
    [weakSelf.masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:49 leadSpacing:23 tailSpacing:23];
    
    // 设置array的垂直方向的约束
    [weakSelf.masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.scroll.mas_bottom).with.offset(16);
        make.height.equalTo(49);
    }];
    
    
//    [weakSelf.btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_offset(49);
//        make.height.mas_offset(49);
//        make.top.equalTo(weakSelf.scroll.mas_bottom).with.offset(16);
//        make.left.equalTo(weakSelf).with.offset(23);
//    }];
//    [weakSelf.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.btn0);
//        make.width.mas_offset(49);
//        make.height.mas_offset(49);
//        make.left.equalTo(weakSelf.btn0.mas_right).with.offset(45);
//    }];
//    [weakSelf.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_offset(49);
//        make.height.mas_offset(49);
//        make.top.equalTo(weakSelf.scroll.mas_bottom).with.offset(16);
//        make.right.equalTo(weakSelf).with.offset(-23);
//    }];
//    [weakSelf.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.btn0);
//        make.width.mas_offset(49);
//        make.height.mas_offset(49);
//        make.right.equalTo(weakSelf.btn3.mas_left).with.offset(-45);
//    }];
   
    [weakSelf.lab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.btn0.mas_bottom).with.offset(10);
        make.left.equalTo(weakSelf.btn0).with.offset(-10);
        make.right.equalTo(weakSelf.btn0).with.offset(10);
    }];
    [weakSelf.lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lab0);
        make.left.equalTo(weakSelf.btn1).with.offset(-10);
        make.right.equalTo(weakSelf.btn1).with.offset(10);
    }];
    [weakSelf.lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lab0);
        make.left.equalTo(weakSelf.btn2).with.offset(-10);
        make.right.equalTo(weakSelf.btn2).with.offset(10);
    }];
    [weakSelf.lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lab0);
        make.left.equalTo(weakSelf.btn3).with.offset(-10);
        make.right.equalTo(weakSelf.btn3).with.offset(10);
    }];
    [weakSelf.line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.height.mas_offset(7);
        make.top.equalTo(weakSelf.lab0.mas_bottom).with.offset(16);
    }];
    [weakSelf.chooseView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.line0.mas_bottom);
        make.left.equalTo(weakSelf);
        make.width.mas_offset(kSCREEN_WIDTH/2);
        make.height.mas_offset(139);
    }];
    [weakSelf.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(1);
        make.top.equalTo(weakSelf.chooseView0);
        make.bottom.equalTo(weakSelf.chooseView0);
        make.left.equalTo(weakSelf.chooseView0.mas_right);
    }];
    [weakSelf.chooseView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.chooseView0);
        make.left.equalTo(weakSelf.line1.mas_right);
        make.right.equalTo(weakSelf);
        make.height.mas_offset(68);
    }];
    [weakSelf.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.chooseView1);
        make.right.equalTo(weakSelf);
        make.height.mas_offset(1);
        make.top.equalTo(weakSelf.chooseView1.mas_bottom);
    }];
    [weakSelf.chooseView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.chooseView1);
        make.right.equalTo(weakSelf);
        make.height.mas_offset(68);
        make.top.equalTo(weakSelf.line2.mas_bottom);
    }];
    [weakSelf.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.height.mas_offset(7);
        make.top.equalTo(weakSelf.chooseView0.mas_bottom);
    }];
    
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(37);
        make.height.mas_offset(39);
        make.left.equalTo(weakSelf).with.offset(12);
        make.top.equalTo(weakSelf.line3.mas_bottom).with.offset(15);
    }];
    
    [weakSelf.bobaomoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImg);
        make.right.equalTo(weakSelf).with.offset(-4);
        make.width.mas_offset(50);
        make.bottom.equalTo(weakSelf.leftImg);
    }];
    
    [weakSelf.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(1);
        make.height.mas_offset(30);
        make.top.equalTo(weakSelf.line3.mas_bottom).with.offset(24);
        make.right.equalTo(weakSelf.bobaomoreBtn.mas_left).with.offset(-3);
    }];
    
    [weakSelf.bobaoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImg);
        make.bottom.equalTo(weakSelf.leftImg);
        make.right.equalTo(weakSelf.line4.mas_left);
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(4);
    }];
    [weakSelf.line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImg.mas_bottom).with.offset(15);
        make.height.mas_offset(7);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
    }];
    
    [weakSelf.topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(91);
        make.height.mas_offset(16);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.line5.mas_bottom).with.offset(19);
    }];
    
    [weakSelf.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(27);
        make.height.mas_offset(28);
        make.top.equalTo(weakSelf.topImg.mas_bottom).with.offset(16);
    }];
    
    [weakSelf.rankingView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.segment.mas_bottom).with.offset(20);
        make.height.mas_offset(68);
    }];
    
    [weakSelf.rankingView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.rankingView0.mas_bottom).with.offset(4);
        make.height.mas_offset(68);
    }];
    
    [weakSelf.rankingView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.rankingView1.mas_bottom).with.offset(4);
        make.height.mas_offset(68);
    }];
    
    [weakSelf.line6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.centerX.equalTo(weakSelf);
        make.height.mas_offset(1);
        make.top.equalTo(weakSelf.rankingView0.mas_bottom).with.offset(2);
    }];
    
    [weakSelf.line7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.centerX.equalTo(weakSelf);
        make.height.mas_offset(1);
        make.top.equalTo(weakSelf.rankingView1.mas_bottom).with.offset(2);
    }];
    
    [weakSelf.line8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.centerX.equalTo(weakSelf);
        make.height.mas_offset(1);
        make.top.equalTo(weakSelf.rankingView2.mas_bottom).with.offset(2);
    }];
    
    [weakSelf.rankingmoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(18);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.top.equalTo(weakSelf.line8.mas_bottom).with.offset(8);
        make.width.mas_offset(120);
    }];
}

#pragma mark - getters

-(SDCycleScrollView *)scroll
{
    if(!_scroll)
    {
        _scroll = [[SDCycleScrollView alloc] init];
        _scroll.delegate = self;
    }
    return _scroll;
}

-(UIButton *)btn0
{
    if(!_btn0)
    {
        _btn0 = [[UIButton alloc] init];
        [_btn0 setImage:[UIImage imageNamed:@"icon_zhaoshangjia"] forState:normal];
    }
    return _btn0;
}

-(UIButton *)btn1
{
    if(!_btn1)
    {
        _btn1 = [[UIButton alloc] init];
        [_btn1 setImage:[UIImage imageNamed:@"icon_huodongrenmen"] forState:normal];
    }
    return _btn1;
}

-(UIButton *)btn2
{
    if(!_btn2)
    {
        _btn2 = [[UIButton alloc] init];
        [_btn2 setImage:[UIImage imageNamed:@"icon_jingygushi"] forState:normal];
    }
    return _btn2;
}

-(UIButton *)btn3
{
    if(!_btn3)
    {
        _btn3 = [[UIButton alloc] init];
        [_btn3 setImage:[UIImage imageNamed:@"icon_tongxulu"] forState:normal];
    }
    return _btn3;
}

-(UILabel *)lab0
{
    if(!_lab0)
    {
        _lab0 = [[UILabel alloc] init];
        _lab0.textAlignment = NSTextAlignmentCenter;
        _lab0.text = @"找商家";
        _lab0.font = [UIFont systemFontOfSize:13];
        _lab0.textColor = [UIColor hexStringToColor:@"333333"];
    }
    return _lab0;
}

-(UILabel *)lab1
{
    if(!_lab1)
    {
        _lab1 = [[UILabel alloc] init];
        _lab1.textAlignment = NSTextAlignmentCenter;
        _lab1.textColor = [UIColor hexStringToColor:@"333333"];
        _lab1.font = [UIFont systemFontOfSize:13];
        _lab1.text = @"热门活动";
    }
    return _lab1;
}

-(UILabel *)lab2
{
    if(!_lab2)
    {
        _lab2 = [[UILabel alloc] init];
        _lab2.textAlignment = NSTextAlignmentCenter;
        _lab2.text = @"精英故事";
        _lab2.font = [UIFont systemFontOfSize:13];
        _lab2.textColor = [UIColor hexStringToColor:@"333333"];
    }
    return _lab2;
}

-(UILabel *)lab3
{
    if(!_lab3)
    {
        _lab3 = [[UILabel alloc] init];
        _lab3.textAlignment = NSTextAlignmentCenter;
        _lab3.font = [UIFont systemFontOfSize:13];
        _lab3.textColor = [UIColor hexStringToColor:@"333333"];
        _lab3.text = @"通讯录";
    }
    return _lab3;
}

-(UIView *)line0
{
    if(!_line0)
    {
        _line0 = [[UIView alloc] init];
        _line0.backgroundColor = kBackgroundColor;
    }
    return _line0;
}

-(localchooseView0 *)chooseView0
{
    if(!_chooseView0)
    {
        _chooseView0 = [[localchooseView0 alloc] init];
        
    }
    return _chooseView0;
}

-(localchooseView1 *)chooseView1
{
    if(!_chooseView1)
    {
        _chooseView1 = [[localchooseView1 alloc] init];
        _chooseView1.topLab.text = @"小区样板间";
        _chooseView1.contentLab.text = @"不出门看邻居装修";
    }
    return _chooseView1; 
}

-(localchooseView1 *)chooseView2
{
    if(!_chooseView2)
    {
        _chooseView2 = [[localchooseView1 alloc] init];
        _chooseView2.topLab.text = @"风格测试";
        _chooseView2.contentLab.text = @"快速了解自己喜欢的风格";
    }
    return _chooseView2;
}

-(UIView *)line1
{
    if(!_line1)
    {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor hexStringToColor:@"EEEEEE"];
    }
    return _line1;
}

-(UIView *)line2
{
    if(!_line2)
    {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor hexStringToColor:@"EEEEEE"];
    }
    return _line2;
}

-(UIView *)line3
{
    if(!_line3)
    {
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = kBackgroundColor;
    }
    return _line3;
}

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.image = [UIImage imageNamed:@"icon_shangjiabobao"];
    }
    return _leftImg;
}

-(UIButton *)bobaomoreBtn
{
    if(!_bobaomoreBtn)
    {
        _bobaomoreBtn = [[UIButton alloc] init];
        _bobaomoreBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [_bobaomoreBtn setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
        _bobaomoreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _bobaomoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _bobaomoreBtn;
}

-(UIView *)line4
{
    if(!_line4)
    {
        _line4 = [[UIView alloc] init];
        _line4.backgroundColor = [UIColor hexStringToColor:@"989898"];
    }
    return _line4;
}

-(SGAdvertScrollView *)bobaoLab
{
    if(!_bobaoLab)
    {
        _bobaoLab = [[SGAdvertScrollView alloc] init];
        _bobaoLab.delegate = self;
        _bobaoLab.titleFont = [UIFont systemFontOfSize:14];
        _bobaoLab.titleColor = [UIColor hexStringToColor:@"666666"];
    }
    return _bobaoLab;
}

-(UIView *)line5
{
    if(!_line5)
    {
        _line5 = [[UIView alloc] init];
        _line5.backgroundColor = kBackgroundColor;
    }
    return _line5;
}

-(UIImageView *)topImg
{
    if(!_topImg)
    {
        _topImg = [[UIImageView alloc] init];
        _topImg.image = [UIImage imageNamed:@"icon_shoudan"];
    }
    return _topImg;
}

-(UISegmentedControl *)segment
{
    if(!_segment)
    {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"年排行",@"月排行",@"周排行"]];
        _segment.selectedSegmentIndex = 0;
        _segment.tintColor = [UIColor hexStringToColor:@"00D897"];
        [_segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

-(newrankingView *)rankingView0
{
    if(!_rankingView0)
    {
        _rankingView0 = [[newrankingView alloc] init];
        _rankingView0.rightImg.image = [UIImage imageNamed:@"icon_diyiming"];
        _rankingView0.nameLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rank0click)];
        [_rankingView0.nameLab addGestureRecognizer:labelTapGestureRecognizer];
    }
    return _rankingView0;
}

-(newrankingView *)rankingView1
{
    if(!_rankingView1)
    {
        _rankingView1 = [[newrankingView alloc] init];
        _rankingView1.rightImg.image = [UIImage imageNamed:@"icon_dierming"];
        _rankingView1.nameLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rank1click)];
        [_rankingView1.nameLab addGestureRecognizer:labelTapGestureRecognizer];
    }
    return _rankingView1;
}

-(newrankingView *)rankingView2
{
    if(!_rankingView2)
    {
        _rankingView2 = [[newrankingView alloc] init];
        _rankingView2.rightImg.image = [UIImage imageNamed:@"icon_disanm"];
        _rankingView2.nameLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rank2click)];
        [_rankingView2.nameLab addGestureRecognizer:labelTapGestureRecognizer];
    }
    return _rankingView2;
}

-(UIView *)line6
{
    if(!_line6)
    {
        _line6 = [[UIView alloc] init];
        _line6.backgroundColor = [UIColor hexStringToColor:@"E4E4E4"];
    }
    return _line6;
}

-(UIView *)line7
{
    if(!_line7)
    {
        _line7 = [[UIView alloc] init];
        _line7.backgroundColor = [UIColor hexStringToColor:@"E4E4E4"];
    }
    return _line7;
}

-(UIView *)line8
{
    if(!_line8)
    {
        _line8 = [[UIView alloc] init];
        _line8.backgroundColor = [UIColor hexStringToColor:@"E4E4E4"];
    }
    return _line8;
}

-(UIButton *)rankingmoreBtn
{
    if(!_rankingmoreBtn)
    {
        _rankingmoreBtn = [[UIButton alloc] init];
        [_rankingmoreBtn setTitle:@"查看更多 >" forState:normal];
        _rankingmoreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rankingmoreBtn setTitleColor:[UIColor hexStringToColor:@"000000"] forState:normal];
        _rankingmoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _rankingmoreBtn;
}


-(void)setdatarr0:(NSMutableArray *)arr0 andarr1:(NSMutableArray *)arr1 andarr2:(NSMutableArray *)arr2
{
    self.ranklist0 = [NSMutableArray array];
    self.ranklist1 = [NSMutableArray array];
    self.ranklist2 = [NSMutableArray array];
    
    self.ranklist0 = arr0;
    self.ranklist1 = arr1;
    self.ranklist2 = arr2;
    
    [self rankmodel];
}

#pragma mark - 点击事件

-(void)change:(UISegmentedControl *)sender{
    NSLog(@"测试");
    if (sender.selectedSegmentIndex == 0) {
//        NSLog(@"1");
        self.type = rankTypearr0;
        [self rankmodel];
    }else if (sender.selectedSegmentIndex == 1){
//        NSLog(@"2");
        self.type = rankTypearr1;
        [self rankmodel];
    }else if (sender.selectedSegmentIndex == 2){
//        NSLog(@"3");
        self.type = rankTypearr2;
        [self rankmodel];
    }
}


-(void)rank0click
{
    if (self.type==rankTypearr0) {
        [self.delegate myTabVClick0:0];
    }
    if (self.type==rankTypearr1) {
        [self.delegate myTabVClick0:1];
    }
    if (self.type==rankTypearr2) {
        [self.delegate myTabVClick0:2];
    }
    
}

-(void)rank1click
{
    if (self.type==rankTypearr0) {
        [self.delegate myTabVClick1:0];
    }
    if (self.type==rankTypearr1) {
        [self.delegate myTabVClick1:1];
    }
    if (self.type==rankTypearr2) {
        [self.delegate myTabVClick1:2];
    }
}

-(void)rank2click
{
    if (self.type==rankTypearr0) {
        [self.delegate myTabVClick2:0];
    }
    if (self.type==rankTypearr1) {
        [self.delegate myTabVClick2:1];
    }
    if (self.type==rankTypearr2) {
        [self.delegate myTabVClick2:2];
    }
    
}
#pragma mark - rankModel

-(void)rankmodel
{
    if (self.type==rankTypearr0) {
        
        if (self.ranklist0.count==0) {
            [self.rankingView0 setHidden:YES];
            [self.rankingView1 setHidden:YES];
            [self.rankingView2 setHidden:YES];
            [self.line7 setHidden:YES];
            [self.line8 setHidden:YES];
        }
        
        
        if (self.ranklist0.count==1) {
            [self.rankingView0 setHidden:NO];
            [self.rankingView1 setHidden:YES];
            [self.rankingView2 setHidden:YES];
            
            [self.line7 setHidden:YES];
            [self.line8 setHidden:YES];
            
            rankingModel *model = [self.ranklist0 firstObject];
            
            [self.rankingView0.leftImg sd_setImageWithURL:[NSURL URLWithString:model.companyLogo]];
            self.rankingView0.nameLab.text = model.companyName;
            self.rankingView0.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model.counts];
            
        }
        if (self.ranklist0.count==2) {
            
            [self.rankingView0 setHidden:NO];
            [self.rankingView2 setHidden:YES];
            [self.rankingView1 setHidden:NO];
            
            [self.line7 setHidden:NO];
            [self.line8 setHidden:YES];
            
            rankingModel *model0 = [self.ranklist0 firstObject];
            
            [self.rankingView0.leftImg sd_setImageWithURL:[NSURL URLWithString:model0.companyLogo]];
            self.rankingView0.nameLab.text = model0.companyName;
            self.rankingView0.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model0.counts];
            
            rankingModel *model1 = [self.ranklist0 objectAtIndex:1];
            [self.rankingView1.leftImg sd_setImageWithURL:[NSURL URLWithString:model1.companyLogo]];
            self.rankingView1.nameLab.text = model1.companyName;
            self.rankingView1.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model1.counts];
            
        }
        if (self.ranklist0.count==3) {
            [self.rankingView0 setHidden:NO];
            [self.rankingView1 setHidden:NO];
            [self.rankingView2 setHidden:NO];
            
            [self.line7 setHidden:NO];
            [self.line8 setHidden:NO];
            
            rankingModel *model0 = [self.ranklist0 firstObject];
            [self.rankingView0.leftImg sd_setImageWithURL:[NSURL URLWithString:model0.companyLogo]];
            self.rankingView0.nameLab.text = model0.companyName;
            self.rankingView0.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model0.counts];
            
            rankingModel *model1 = [self.ranklist0 objectAtIndex:1];
            [self.rankingView1.leftImg sd_setImageWithURL:[NSURL URLWithString:model1.companyLogo]];
            self.rankingView1.nameLab.text = model1.companyName;
            self.rankingView1.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model1.counts];
            
            rankingModel *model2 = [self.ranklist0 objectAtIndex:2];
            [self.rankingView2.leftImg sd_setImageWithURL:[NSURL URLWithString:model2.companyLogo]];
            self.rankingView2.nameLab.text = model2.companyName;
            self.rankingView2.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model2.counts];
        }
        
    }
    if (self.type==rankTypearr1) {
        
        if (self.ranklist1.count==0) {
            [self.rankingView0 setHidden:YES];
            [self.rankingView1 setHidden:YES];
            [self.rankingView2 setHidden:YES];
            [self.line7 setHidden:YES];
            [self.line8 setHidden:YES];
        }
        
        
        if (self.ranklist1.count==1) {
            [self.rankingView0 setHidden:NO];
            [self.rankingView1 setHidden:YES];
            [self.rankingView2 setHidden:YES];
            [self.line7 setHidden:YES];
            [self.line8 setHidden:YES];
            
            rankingModel *model0 = [self.ranklist1 firstObject];
            [self.rankingView0.leftImg sd_setImageWithURL:[NSURL URLWithString:model0.companyLogo]];
            self.rankingView0.nameLab.text = model0.companyName;
            self.rankingView0.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model0.counts];
            
        }
        if (self.ranklist1.count==2) {
            [self.rankingView0 setHidden:NO];
            [self.rankingView1 setHidden:NO];
            [self.rankingView2 setHidden:YES];
            [self.line7 setHidden:NO];
            [self.line8 setHidden:YES];
            
            rankingModel *model0 = [self.ranklist1 firstObject];
            [self.rankingView0.leftImg sd_setImageWithURL:[NSURL URLWithString:model0.companyLogo]];
            self.rankingView0.nameLab.text = model0.companyName;
            self.rankingView0.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model0.counts];
            
            rankingModel *model1 = [self.ranklist1 objectAtIndex:1];
            [self.rankingView1.leftImg sd_setImageWithURL:[NSURL URLWithString:model1.companyLogo]];
            self.rankingView1.nameLab.text = model1.companyName;
            self.rankingView1.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model1.counts];
        }
        if (self.ranklist1.count==3) {
            
            [self.rankingView0 setHidden:NO];
            [self.rankingView1 setHidden:NO];
            [self.rankingView2 setHidden:NO];
            
            [self.line7 setHidden:NO];
            [self.line8 setHidden:NO];
            
            
            
            rankingModel *model0 = [self.ranklist1 firstObject];
            [self.rankingView0.leftImg sd_setImageWithURL:[NSURL URLWithString:model0.companyLogo]];
            self.rankingView0.nameLab.text = model0.companyName;
            self.rankingView0.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model0.counts];
            
            rankingModel *model1 = [self.ranklist1 objectAtIndex:1];
            [self.rankingView1.leftImg sd_setImageWithURL:[NSURL URLWithString:model1.companyLogo]];
            self.rankingView1.nameLab.text = model1.companyName;
            self.rankingView1.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model1.counts];
            
            rankingModel *model2 = [self.ranklist1 objectAtIndex:2];
            [self.rankingView2.leftImg sd_setImageWithURL:[NSURL URLWithString:model2.companyLogo]];
            self.rankingView2.nameLab.text = model2.companyName;
            self.rankingView2.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model2.counts];
        }
        
    }
    if (self.type==rankTypearr2) {
        if (self.ranklist2.count==0) {
            [self.rankingView0 setHidden:YES];
            [self.rankingView1 setHidden:YES];
            [self.rankingView2 setHidden:YES];
            [self.line7 setHidden:YES];
            [self.line8 setHidden:YES];
        }
        
        if (self.ranklist2.count==1) {
            [self.rankingView1 setHidden:YES];
            [self.rankingView2 setHidden:YES];
            [self.line7 setHidden:YES];
            [self.line8 setHidden:NO];
            [self.rankingView0 setHidden:NO];
            
            rankingModel *model0 = [self.ranklist2 firstObject];
            
            [self.rankingView0.leftImg sd_setImageWithURL:[NSURL URLWithString:model0.companyLogo]];
            self.rankingView0.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model0.counts];
            self.rankingView0.nameLab.text = model0.companyName;
        }
        if (self.ranklist2.count==2) {
            [self.rankingView0 setHidden:NO];
            [self.rankingView1 setHidden:NO];
            [self.rankingView2 setHidden:YES];
            [self.line7 setHidden:NO];
            [self.line8 setHidden:YES];
            
            rankingModel *model0 = [self.ranklist2 firstObject];
            
            [self.rankingView0.leftImg sd_setImageWithURL:[NSURL URLWithString:model0.companyLogo]];
            self.rankingView0.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model0.counts];
            self.rankingView0.nameLab.text = model0.companyName;
            
            rankingModel *model1 = [self.ranklist2 objectAtIndex:1];
            
            [self.rankingView1.leftImg sd_setImageWithURL:[NSURL URLWithString:model1.companyLogo]];
            self.rankingView1.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model1.counts];
            self.rankingView1.nameLab.text = model1.companyName;
        }
        if (self.ranklist2.count==3) {
            
            [self.rankingView0 setHidden:NO];
            [self.rankingView1 setHidden:NO];
            [self.rankingView2 setHidden:NO];
            [self.line7 setHidden:NO];
            [self.line8 setHidden:NO];
            
            rankingModel *model0 = [self.ranklist2 firstObject];
            
            [self.rankingView0.leftImg sd_setImageWithURL:[NSURL URLWithString:model0.companyLogo]];
            self.rankingView0.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model0.counts];
            self.rankingView0.nameLab.text = model0.companyName;
            
            rankingModel *model1 = [self.ranklist2 objectAtIndex:1];
            
            [self.rankingView1.leftImg sd_setImageWithURL:[NSURL URLWithString:model1.companyLogo]];
            self.rankingView1.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model1.counts];
            self.rankingView1.nameLab.text = model1.companyName;
            
            rankingModel *model2 = [self.ranklist2 objectAtIndex:2];
            
            [self.rankingView2.leftImg sd_setImageWithURL:[NSURL URLWithString:model2.companyLogo]];
            self.rankingView2.numberLab.text = [NSString stringWithFormat:@"%@%@",@"收单  ",model2.counts];
            self.rankingView2.nameLab.text = model2.companyName;
        }
    }
}


- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index
{
    
}
@end
