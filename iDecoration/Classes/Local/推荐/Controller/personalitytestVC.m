//
//  personalitytestVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "personalitytestVC.h"
#import "personalitytestCell.h"
#import "localstylechangeVC.h"

@interface personalitytestVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *submitBtn;
@end

#define CHANGEURL0 @"http://testapi.bilinerju.com/resources/images/xgcs1.png";
#define CHANGEURL1 @"http://testapi.bilinerju.com/resources/images/xgcs2.png";


static NSString *personalityidentfid = @"identfidty";

@implementation personalitytestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.table];
    self.table.tableFooterView = self.footView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] init];
        _table.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        _table.dataSource = self;
        _table.delegate = self;
    }
    return _table;
}

-(UIView *)footView
{
    if(!_footView)
    {
        _footView = [[UIView alloc] init];
        _footView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 100);
        [_footView addSubview:self.submitBtn];
    }
    return _footView;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.frame = CGRectMake(kSCREEN_WIDTH/2-278/2, 14, 278, 48);
        [_submitBtn addTarget:self action:@selector(submitbtnclick) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.backgroundColor = [UIColor hexStringToColor:@"50B16E"];
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = 5;
        [_submitBtn setTitle:@"开始测试" forState:normal];
        [_submitBtn setTitleColor:White_Color forState:normal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _submitBtn;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    personalitytestCell *cell = [tableView dequeueReusableCellWithIdentifier:personalityidentfid];
    cell = [[personalitytestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personalityidentfid];
    [cell.leftBtn addTarget:self action:@selector(leftbtnclick) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 712;
}

#pragma mark - 点击事件

-(void)leftbtnclick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submitbtnclick
{
    localstylechangeVC *vc = [localstylechangeVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
