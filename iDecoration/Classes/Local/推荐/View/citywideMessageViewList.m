//
//  citywideMessageViewList.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "citywideMessageViewList.h"
#import "citywideMessageViewListTableViewCell.h"
#import "citywideMessageModel.h"

@implementation citywideMessageViewList

- (void)drawRect:(CGRect)rect {
    [self createTableView];
}

- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = @[].mutableCopy;
    }
    return _arrayData;
}

- (void)reload {
    if (!self.arrayData.count) {
        citywideMessageModel *model = [citywideMessageModel new];
        model.name = @"客服QQ";
        model.phone = @"1111";
        [self.arrayData addObject:model];
    }
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (void)createTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 45;
    self.tableView.layer.cornerRadius = 6.0f;
    self.tableView.layer.masksToBounds = true;
    UIEdgeInsets padding = UIEdgeInsetsMake(Height_Layout(150), Width_Layout(30), Height_Layout(100), Width_Layout(30));
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(padding.top); //with is an optional semantic filler
        make.left.equalTo(self.mas_left).with.offset(padding.left);
        make.bottom.equalTo(self.mas_bottom).with.offset(-padding.bottom);
        make.right.equalTo(self.mas_right).with.offset(-padding.right);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    citywideMessageViewListTableViewCell *cell = [citywideMessageViewListTableViewCell cellWithTableView:tableView];
    citywideMessageModel *model = self.arrayData[indexPath.row];
    cell.labelName.text = model.name;
    cell.labelNumber.text = model.phone;
    cell.labelCity.text = model.cityName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    citywideMessageModel *model = self.arrayData[indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",model.phone]]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.hidden = true;
}

@end
