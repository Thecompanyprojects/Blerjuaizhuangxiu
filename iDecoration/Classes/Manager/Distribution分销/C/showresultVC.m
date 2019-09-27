//
//  showresultVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "showresultVC.h"
#import "showresuleCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "showresulefootView.h"

@interface showresultVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) showresulefootView *footView;
@end

static NSString *showresuleidentfid = @"showresuleidentfid";

@implementation showresultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现状态";
    
    self.typestr = @"0";
    
    if ([self.typestr isEqualToString:@"0"]) {
        self.titleArray = @[@"发起提现申请",@"已处理",@"成功"];
    }
    if ([self.typestr isEqualToString:@"1"]) {
        self.titleArray = @[@"发起提现申请",@"已处理",@"失败"];
    }
    if ([self.typestr isEqualToString:@"2"]) {
        self.titleArray = @[@"发起提现申请",@"处理中"];
    }
    [self.view addSubview:self.table];
    self.table.tableFooterView = self.footView;
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"重新提现" style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom) style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _table;
}


-(showresulefootView *)footView
{
    if(!_footView)
    {
        _footView = [[showresulefootView alloc] init];
        _footView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 150);
        [_footView.submitBtn addTarget:self action:@selector(submitclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footView;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath\
{
    showresuleCell *cell = [tableView dequeueReusableCellWithIdentifier:showresuleidentfid];
    cell = [[showresuleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:showresuleidentfid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        [cell.onLine removeFromSuperview];
    }
    if (indexPath.row == self.titleArray.count-1) {
        [cell.downLine removeFromSuperview];
    }
    cell.titleLabel.text = self.titleArray[indexPath.row];
    if([self.typestr isEqualToString:@"0"])
    {
        cell.onLine.backgroundColor = [UIColor hexStringToColor:@"32DB7B"];
        cell.downLine.backgroundColor = [UIColor hexStringToColor:@"32DB7B"];
        cell.roundView.backgroundColor = [UIColor hexStringToColor:@"32DB7B"];
        cell.titleLabel.textColor = [UIColor hexStringToColor:@"666666"];
    }
    if([self.typestr isEqualToString:@"1"])
    {
        if(indexPath.row==0)
        {
            cell.onLine.backgroundColor = [UIColor hexStringToColor:@"32DB7B"];
            cell.downLine.backgroundColor = [UIColor hexStringToColor:@"32DB7B"];
            cell.roundView.backgroundColor = [UIColor hexStringToColor:@"32DB7B"];
            cell.titleLabel.textColor = [UIColor hexStringToColor:@"666666"];
        }
        if(indexPath.row==1)
        {
            cell.onLine.backgroundColor = [UIColor hexStringToColor:@"32DB7B"];
            cell.downLine.backgroundColor = [UIColor hexStringToColor:@"CCCCCC"];
            cell.roundView.backgroundColor = [UIColor hexStringToColor:@"32DB7B"];
            cell.titleLabel.textColor = [UIColor hexStringToColor:@"666666"];
        }
        if(indexPath.row==2)
        {
            cell.onLine.backgroundColor = [UIColor hexStringToColor:@"CCCCCC"];
            cell.downLine.backgroundColor = [UIColor hexStringToColor:@"CCCCCC"];
            cell.roundView.backgroundColor = [UIColor hexStringToColor:@"CCCCCC"];
            cell.titleLabel.textColor = [UIColor hexStringToColor:@"000000"];
        }
    }
    if([self.typestr isEqualToString:@"2"])
    {
        if(indexPath.row==0)
        {
            cell.onLine.backgroundColor = [UIColor hexStringToColor:@"32DB7B"];
            cell.downLine.backgroundColor = [UIColor hexStringToColor:@"CCCCCC"];
            cell.roundView.backgroundColor = [UIColor hexStringToColor:@"32DB7B"];
            cell.titleLabel.textColor = [UIColor hexStringToColor:@"666666"];
        }
        if(indexPath.row==1)
        {
            cell.onLine.backgroundColor = [UIColor hexStringToColor:@"CCCCCC"];
            cell.downLine.backgroundColor = [UIColor hexStringToColor:@"CCCCCC"];
            cell.roundView.backgroundColor = [UIColor hexStringToColor:@"CCCCCC"];
            cell.titleLabel.textColor = [UIColor hexStringToColor:@"000000"];
        }
    }
    return cell;
}

#pragma mark - 实现方法

-(void)onClickedOKbtn
{
    
}

-(void)submitclick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
