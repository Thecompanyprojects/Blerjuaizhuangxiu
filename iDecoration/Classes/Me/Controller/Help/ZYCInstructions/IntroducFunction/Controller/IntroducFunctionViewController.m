//
//  IntroducFunctionViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "IntroducFunctionViewController.h"

@interface IntroducFunctionViewController ()

@end

@implementation IntroducFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能介绍";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return DirectionModel.arrayTitleIntroducFunction.count;
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
    cell.textLabel.text = DirectionModel.arrayTitleIntroducFunction[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCHPublicWebViewController *controller = [[ZCHPublicWebViewController alloc] init];
    controller.titleStr = DirectionModel.arrayTitleIntroducFunction[indexPath.section];
    controller.webUrl = DirectionModel.arrayTitleIntroducFunctionURL[indexPath.section];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
