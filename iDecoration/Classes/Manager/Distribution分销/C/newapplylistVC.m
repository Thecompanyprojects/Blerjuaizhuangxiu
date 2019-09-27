//
//  newapplylistVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "newapplylistVC.h"
#import "newapplylistCell.h"

@interface newapplylistVC ()<UITableViewDataSource,UITableViewDelegate,myTabVdelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UILabel *topLab;
@property (nonatomic,strong) UIView *line;
@end

static NSString *newapplylistidentfid = @"newapplylistidentfid";

@implementation newapplylistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分销员申请";
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    self.table.tableHeaderView = self.headView;
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
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom)];
        _table.dataSource = self;
        _table.delegate = self;
    }
    return _table;
}

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

-(UIView *)headView
{
    if(!_headView)
    {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 60)];
        _headView.backgroundColor = [UIColor whiteColor];
        [_headView addSubview:self.topLab];
        [_headView addSubview:self.line];
    }
    return _headView;
}

-(UILabel *)topLab
{
    if(!_topLab)
    {
        _topLab = [[UILabel alloc] init];
        _topLab.frame = CGRectMake(14, 0, kSCREEN_WIDTH-14, 52);
        _topLab.text = @"分销员申请记录";
        _topLab.textColor = [UIColor hexStringToColor:@"343434"];
        _topLab.font = [UIFont systemFontOfSize:14];
    }
    return _topLab;
}

-(UIView *)line
{
    if(!_line)
    {
        _line = [[UIView alloc] init];
        _line.frame = CGRectMake(0, 52, kSCREEN_WIDTH, 8);
        _line.backgroundColor = [UIColor hexStringToColor:@"F2F2F2"];
    }
    return _line;
}


#pragma mark -UITableViewDataSource&&UITableViewDelegate
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    newapplylistCell *cell = [tableView dequeueReusableCellWithIdentifier:newapplylistidentfid];
    cell = [[newapplylistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newapplylistidentfid];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - myTabVdelegate

-(void)myTabVClick1:(UITableViewCell *)cell
{
    
}

-(void)myTabVClick2:(UITableViewCell *)cell
{
    
}

@end
