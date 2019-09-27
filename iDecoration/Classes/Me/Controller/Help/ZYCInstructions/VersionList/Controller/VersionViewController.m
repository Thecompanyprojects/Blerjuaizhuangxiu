//
//  VersionViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "VersionViewController.h"
#import "VersionModel.h"

@interface VersionViewController ()
@property (strong, nonatomic) NSMutableArray *arrayData;
@end

@implementation VersionViewController

- (void)Network {
    NSString *URL = @"cblejversioninstruction/getList.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [NetWorkRequest postJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        if ([result[@"code"]integerValue] == 1000) {
            self.arrayData = [NSArray yy_modelArrayWithClass:[VersionModel class] json:result[@"data"][@"list"]].mutableCopy;
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self Network];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = White_Color;

    VersionModel *model = self.arrayData[indexPath.section];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VersionModel *model = self.arrayData[indexPath.section];
    ZCHPublicWebViewController *controller = [[ZCHPublicWebViewController alloc]init];
    controller.titleStr = model.name;
    controller.isAddBaseUrl = true;
    controller.webUrl = model.designsHref;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
