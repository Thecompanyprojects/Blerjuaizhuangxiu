//
//  detailsofenvelopeVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "detailsofenvelopeVC.h"
#import "detailsofenvelopeCell0.h"
#import "detailsofenvelopeCell1.h"
#import "detailsofenvelopeCell2.h"

@interface detailsofenvelopeVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@end

static NSString *detailofevelope0 = @"detailofevelope0";
static NSString *detailofevelope1 = @"detailofevelope1";
static NSString *detailofevelope2 = @"detailofevelope2";

@implementation detailsofenvelopeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"红包详情";
    
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor hexStringToColor:@"DB5544"];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = Main_Color;
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
        _table.backgroundColor = kBackgroundColor;
    }
    return _table;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        detailsofenvelopeCell0 *cell = [tableView dequeueReusableCellWithIdentifier:detailofevelope0];
        cell = [[detailsofenvelopeCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailofevelope0];
        [cell setdata:self.modelDic];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row==1) {
        detailsofenvelopeCell1 *cell = [tableView dequeueReusableCellWithIdentifier:detailofevelope1];
        cell = [[detailsofenvelopeCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailofevelope1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row==2) {
        detailsofenvelopeCell2 *cell = [tableView dequeueReusableCellWithIdentifier:detailofevelope2];
        cell = [[detailsofenvelopeCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailofevelope2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 310;
    }
    if (indexPath.row==1) {
        return 40;
    }
    if (indexPath.row==2) {
        return 180;
    }
    return 0.01f;
}
@end
