//
//  LocalwikipediaVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "LocalwikipediaVC.h"
#import "localwikipediaCell.h"

@interface LocalwikipediaVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@end

static NSString *localwikipediaidentfid = @"localwikipediaidentfid";

@implementation LocalwikipediaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.table];
    [self layoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)layoutUI
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).with.offset(-49-44);
    }];
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] init];
        _table.dataSource = self;
        _table.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchTableView)];
        [_table addGestureRecognizer:tap];
    }
    return _table;
}

- (void)didTouchTableView {
    [ZYCTool alertControllerOneButtonWithTitle:@"敬请期待" message:@"" target:self defaultButtonTitle:nil defaultAction:^{}];
}

#pragma mark - UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    localwikipediaCell *cell = [tableView dequeueReusableCellWithIdentifier:localwikipediaidentfid];
    cell = [[localwikipediaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:localwikipediaidentfid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 1100;
}

@end
