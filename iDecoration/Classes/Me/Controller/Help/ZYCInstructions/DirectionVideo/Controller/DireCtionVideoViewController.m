//
//  DireCtionVideoViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DireCtionVideoViewController.h"

@interface DireCtionVideoViewController ()

@end

@implementation DireCtionVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"操作视频";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return DirectionModel.arrayTitleVideo.count;
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
    cell.textLabel.text = DirectionModel.arrayTitleVideo[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCHPublicWebViewController *controller = [[ZCHPublicWebViewController alloc] init];
    NSString *URL = DirectionModel.arrayTitleVideoURL[indexPath.section];
    controller.titleStr = DirectionModel.arrayTitleVideo[indexPath.section];
    controller.webUrl = URL;
    if ([controller.titleStr isEqualToString:@"【PC网】后台编辑PC端设置"] || [controller.titleStr isEqualToString:@"【APP】1.注册流程"]) {
        controller.isAddBaseUrl = true;
        controller.webUrl = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else
        controller.isAddBaseUrl = false;
    controller.isNeedShareButton = true;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
