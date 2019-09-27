//
//  distributionaboutVC2.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/15.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "distributionaboutVC2.h"
#import "disablutCell1.h"

@interface distributionaboutVC2 ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSArray *arr;
@end

static NSString *disabultcell1identfid = @"disabultcell1identfid";

@implementation distributionaboutVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分销介绍";
    [self loaddata];
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loaddata
{
    self.arr = [NSArray new];
    if ([self.typestr isEqualToString:@"1"]) {
        self.arr = @[@"fengxiao1",@"fengxiao3"];
    }
    if ([self.typestr isEqualToString:@"2"]) {
        self.arr = @[@"fengxiao2"];
    }
    if ([self.typestr isEqualToString:@"3"]) {
        self.arr = @[@"fengxiao5"];
    }
    if ([self.typestr isEqualToString:@"4"]) {
        self.arr = @[@"fengxiao4"];
    }
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom)];
        _table.dataSource = self;
        _table.delegate = self;
    }
    return _table;
}


#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.typestr isEqualToString:@"1"]) {
        return 2;
    }
    else
    {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    disablutCell1 *cell = [tableView dequeueReusableCellWithIdentifier:disabultcell1identfid];
    if (!cell) {
        cell = [[disablutCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:disabultcell1identfid];
    }
    [cell setdatafrom:self.arr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kSCREEN_HEIGHT-kNaviBottom;
}
@end
