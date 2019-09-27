//
//  InstructionsViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "InstructionsViewController.h"
#import "InstructionsModel.h"
#import "VersionViewController.h"
#import "DirectionViewController.h"//说明书
#import "ExcellentCaseViewController.h"

@interface InstructionsViewController ()<UITableViewDelegate, UITableViewDataSource>
@end

@implementation InstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"使用说明";
    [self createTableView];
}

- (void)viewWillLayoutSubviews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(0);
    }];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStyleGrouped)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return InstructionsModel.arrayTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
    UIImageView *imageV = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"instructions_authority_prompt"]];
    [cell.contentView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.right.equalTo(-16);
        make.size.equalTo(CGSizeMake(28, 28));
    }];
    imageV.hidden = true;

    cell.textLabel.text = InstructionsModel.arrayTitle[indexPath.section];
    cell.detailTextLabel.text = @"";

    if (indexPath.section == InstructionsModel.arrayTitle.count - 1) {
        cell.detailTextLabel.text = @"3379607351";
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;;
    }
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
        imageV.hidden = false;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{//版本列表
            VersionViewController *controller = [VersionViewController new];
            [self.navigationController pushViewController:controller animated:true];
        }
            break;
//        case 1:{//会员介绍
//            ZCHPublicWebViewController *controller = [[ZCHPublicWebViewController alloc]init];
//            controller.titleStr = @"会员介绍";
//            controller.isAddBaseUrl = false;
//            controller.webUrl = @"resources/html/new_huiyuanjieshao.html";
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//            break;
        case 1:{//权限介绍
            ZCHPublicWebViewController *powerIntroVC = [[ZCHPublicWebViewController alloc] init];
            powerIntroVC.titleStr = @"权限介绍";
            powerIntroVC.webUrl = @"resources/html/quanxianjieshao.html";
            [self.navigationController pushViewController:powerIntroVC animated:YES];
        }
            break;//DirectionViewController
        case 2:{//说明书
            DirectionViewController *controller = [[DirectionViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
//        case 4:{//商家优秀推广案例
//            ExcellentCaseViewController *powerIntroVC = [[ExcellentCaseViewController alloc] init];
//            powerIntroVC.title = @"商家优秀推广案例";
////            powerIntroVC.webUrl = @"resources/html/quanxianjieshao.html";
//            [self.navigationController pushViewController:powerIntroVC animated:YES];
//        }
//            break;
        case 3:{//爱装修区别
            ZCHPublicWebViewController *managerMustReadVC = [[ZCHPublicWebViewController alloc] init];
            managerMustReadVC.titleStr = @"爱装修与其他公司的区别";
            managerMustReadVC.webUrl = @"resources/html/aizhuangxiuyuqitagongsidequbie.html";
            [self.navigationController pushViewController:managerMustReadVC animated:YES];
            }
             break;
           case 4:{//爱装修区别
        
            
            NSString *qqstr = @"3379607351";
            NSString *qq=[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqstr];
            NSURL *url = [NSURL URLWithString:qq];
            [[UIApplication sharedApplication] openURL:url];
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
