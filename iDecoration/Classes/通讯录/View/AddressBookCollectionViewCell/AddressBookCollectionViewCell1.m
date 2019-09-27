//
//  AddressBookCollectionViewCell1.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/15.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "AddressBookCollectionViewCell1.h"
#import "AddressBookTableViewCell2.h"

@implementation AddressBookCollectionViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createTableView];
}

- (void)createTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = 0;
    self.tableView.scrollEnabled = false;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_jy"]];
    imageView.contentMode = 2;
    self.tableView.tableHeaderView = imageView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressBookTableViewCell2 *cell = [AddressBookTableViewCell2 cellWithTableView:tableView];
    GeniusSquareListModel *model = self.arrayData[indexPath.row];
    [cell setModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.blockDidtouchCell) {
        GeniusSquareListModel *model = self.arrayData[indexPath.row];
        self.blockDidtouchCell(model);
    }
}

@end
