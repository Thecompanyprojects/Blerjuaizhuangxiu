//
//  citywideMessageVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "citywideMessageVC.h"
#import "citywideCell.h"
#import <SDAutoLayout.h>
#import "citywideModel.h"
#import "citywideMessageModel.h"
#import "citywideMessageViewList.h"

@interface citywideMessageVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) UIButton *buttonBottom;
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (strong, nonatomic) citywideMessageViewList *viewList;

@end

static NSString *citywideidentfid = @"citywideidentfid";

@implementation citywideMessageVC

- (citywideMessageViewList *)viewList {
    if (!_viewList) {
        _viewList = [citywideMessageViewList new];
        _viewList.hidden = true;
        [_viewList setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        [self.view addSubview:_viewList];
    }
    return _viewList;
}

- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = @[].mutableCopy;
    }
    return _arrayData;
}

- (UIButton *)buttonBottom {
    if (!_buttonBottom) {
        _buttonBottom = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _buttonBottom.layer.cornerRadius = 4.0f;
        _buttonBottom.layer.masksToBounds = true;
        [_buttonBottom setBackgroundColor:[UIColor colorWithRed:0.22 green:0.71 blue:0.42 alpha:1.00] forState:(UIControlStateNormal)];
        [_buttonBottom.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _buttonBottom.hidden = true;
        [self.view addSubview:_buttonBottom];
        [_buttonBottom addTarget:self action:@selector(didTouchButtonBottom) forControlEvents:(UIControlEventTouchUpInside)];
        [self.buttonBottom setTitle:@"快速审核" forState:(UIControlStateNormal)];
    }
    return _buttonBottom;
}

- (void)NetworkOfPhoneNumber {
    NSString *URL = @"agency/getOperatePhonesByAgencyId.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"agencyId"] = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];
    [NetWorkRequest getJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        if ([[result objectForKey:@"code"] intValue]==1000) {
            for (NSDictionary *dic in result[@"data"][@"operateList"]) {
                citywideMessageModel *model = [citywideMessageModel yy_modelWithJSON:dic];
                [self.arrayData addObject:model];
            }
            self.viewList.arrayData = self.arrayData;
            [self.viewList reload];
        }
    } fail:^(id error) {

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NetworkOfPhoneNumber];
    self.title = @"审核消息";
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    [self loaddata];
}

- (void)viewWillLayoutSubviews {
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, (isiPhoneX?30:10), 10);
    [self.buttonBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.table.mas_bottom).with.offset(padding.top); //with is an optional semantic filler
        make.left.equalTo(self.view.mas_left).with.offset(padding.left);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-padding.bottom);
        make.right.equalTo(self.view.mas_right).with.offset(-padding.right);
    }];

    UIEdgeInsets paddingList = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.viewList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(paddingList.top); //with is an optional semantic filler
        make.left.equalTo(self.view.mas_left).with.offset(paddingList.left);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-paddingList.bottom);
        make.right.equalTo(self.view.mas_right).with.offset(-paddingList.right);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loaddata {
    NSString *idstr = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];

    NSDictionary *para = @{@"agencyId":idstr};
    NSString *url = [BASEURL stringByAppendingString:widepush_shenhe];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue] == 1000) {
            self.dataSource = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[citywideModel class] json:responseObj[@"data"][@"list"]]];
            self.buttonBottom.hidden = self.dataSource.count?false:true;
        }
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - getters

- (UITableView *)table {
    if(!_table) {
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom - (isiPhoneX?90:70)) style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.backgroundColor = kBackgroundColor;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _table;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    citywideCell *cell = [tableView dequeueReusableCellWithIdentifier:citywideidentfid];
    cell = [[citywideCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:citywideidentfid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setdata:self.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:kSCREEN_WIDTH tableView:self.table];
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    citywideModel *model = self.dataSource[indexPath.row];
    if ([model.checked isEqualToString:@"2"])
    {
        model.isshow = ! model.isshow;
        NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath1];
        [tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 自定义左滑显示编辑按钮
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *rowActionSec = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消推送"    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                                NSLog(@"快速备忘");
                                                                            }];
    rowActionSec.backgroundColor = [UIColor hexStringToColor:@"f38202"];
    NSArray *arr = @[rowActionSec];
    return arr;
}

- (void)didTouchButtonBottom {
    self.viewList.hidden = false;
}

@end
