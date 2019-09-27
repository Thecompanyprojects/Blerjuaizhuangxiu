//
//  agreementVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "agreementVC.h"

@interface agreementVC ()
@property (nonatomic,strong) UITextView *content;
@property (nonatomic,strong) UIButton *knowBtn;
@end

@implementation agreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"执行经理说明";
    [self.view addSubview:self.content];
    [self.view addSubview:self.knowBtn];
    [self setdata];
    [self setlayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setdata
{
    NSString *str = @"总经理可赋予分公司任意员工为执行经理，分公司员工原有的职位保留不变。一个分公司可以有多个执行经理。执行经理在分公司拥有和总经理相同权限，代总经理管理分公司。\n\n执行经理职责：\n1.创建、编辑、删除工地\n2.添加、编辑、删除商品\n3.上传、修改广告图\n4.创建、编辑、删除美文及活动\n5.创建、编辑、删除、查看红包\n6.创建、编辑联盟及联盟活动\n7.创建联盟之后可以审核联盟内成员提交的联盟活动\n8.申请、解除、拉黑合作\n9.创建、编辑、删除全景\n10.查看公司内的数据统计\n11.收到执行经理所在分公司的消息提醒";
    self.content.text = str;
}

-(void)setlayout
{
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(14);
        make.right.equalTo(self.view).with.offset(-14);
        make.top.equalTo(self.view).with.offset(kNaviBottom+14);
        make.bottom.equalTo(self.view).with.offset(-14);
    }];
    [self.knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.height.mas_offset(40);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}

#pragma mark - getters

-(UITextView *)content
{
    if(!_content)
    {
        _content = [[UITextView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _content.font = [UIFont systemFontOfSize:14];
        //_content.numberOfLines = 0;
        _content.editable = NO;
        _content.backgroundColor = kBackgroundColor;
    }
    return _content;
}

-(UIButton *)knowBtn
{
    if(!_knowBtn)
    {
        _knowBtn = [[UIButton alloc] init];
        _knowBtn.backgroundColor = Main_Color;
        [_knowBtn setTitle:@"知道了" forState:normal];
        [_knowBtn setTitleColor:[UIColor whiteColor] forState:normal];
        [_knowBtn addTarget:self action:@selector(knowclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _knowBtn;
}

#pragma mark - 实现方法

-(void)knowclick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
