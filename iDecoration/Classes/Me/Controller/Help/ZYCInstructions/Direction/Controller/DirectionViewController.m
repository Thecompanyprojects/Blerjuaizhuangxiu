//
//  DirectionViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DirectionViewController.h"
#import "DireCtionVideoViewController.h"
#import "IntroducFunctionViewController.h"

@interface DirectionViewController ()

@end

@implementation DirectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return DirectionModel.arrayTitle.count;
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
    cell.textLabel.text = DirectionModel.arrayTitle[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0://功能介绍
        {
            IntroducFunctionViewController *controller = [IntroducFunctionViewController new];
            [self.navigationController pushViewController:controller animated:true];
        }
            break;
        case 1://视频
        {
            DireCtionVideoViewController *controller = [DireCtionVideoViewController new];
            [self.navigationController pushViewController:controller animated:true];
        }
            break;
        case 2://攻略
        {
            if (isCustomMadeHidden) {
                ZCHPublicWebViewController *managerMustReadVC = [[ZCHPublicWebViewController alloc] init];
                managerMustReadVC.titleStr = @"装修百科";
                managerMustReadVC.webUrl = @"resources/html/zhuangxiubaike.html";
                [self.navigationController pushViewController:managerMustReadVC animated:YES];
            }else{
                ZCHPublicWebViewController *managerMustReadVC = [[ZCHPublicWebViewController alloc] init];
                managerMustReadVC.titleStr = @"定制版使用攻略";
                managerMustReadVC.isAddBaseUrl = YES;
                managerMustReadVC.webUrl = @"http://api.bilinerju.com/api/designs/10493/10094.htm";
                [self.navigationController pushViewController:managerMustReadVC animated:YES];
            }
        }
            break;
        case 3://百科
        {
            ZCHPublicWebViewController *managerMustReadVC = [[ZCHPublicWebViewController alloc] init];
            managerMustReadVC.titleStr = @"装修百科";
            managerMustReadVC.webUrl = @"resources/html/zhuangxiubaike.html";
            [self.navigationController pushViewController:managerMustReadVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
