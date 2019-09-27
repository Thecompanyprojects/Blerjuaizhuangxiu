//
//  SpecificationViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SpecificationViewController.h"
#import "LimitsViewController.h"
#import "SpeDetailViewController.h"
#import "MustReadViewController.h"
#import "ZCHPublicWebViewController.h"

@interface SpecificationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SpecificationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"使用说明";
    [self createTableView];
}
-(void)createTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = RGB(242, 242, 242);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 13;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 5;
    }
    return 0.0000000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = White_Color;
    if (indexPath.section == 0) {
        
        if (indexPath.row==0) {
            cell.textLabel.text = @"4.8.0版本说明";
        }
        
      
    }
    
    if (indexPath.section==1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"权限介绍";
            
            UIImageView *imageV = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"instructions_authority_prompt"]];
            [cell.contentView addSubview:imageV];
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(0);
                make.right.equalTo(-16);
                make.size.equalTo(CGSizeMake(28, 28));
            }];
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"说明书";
        }
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"总经理必读";
        }
    }
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"家装计算器创建视频（视频讲解）";
            cell.textLabel.textColor = [UIColor redColor];
        }
    }
    if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"爱装修企业网（视频讲解）";
            cell.textLabel.textColor = [UIColor redColor];
        }
    }
    if (indexPath.section == 6) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"施工日志介绍（视频讲解）";
            cell.textLabel.textColor = [UIColor redColor];
        }
    }
    if (indexPath.section == 7) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"合作企业（视频讲解）";
            cell.textLabel.textColor = [UIColor redColor];
        }
    }
    if (indexPath.section == 8) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"商户联盟（视频讲解）";
            cell.textLabel.textColor = [UIColor redColor];
        }
    }
    if (indexPath.section == 9) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"定制版使用攻略";
        }
    }
    if (indexPath.section == 10) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"装修百科";
        }
    }
    if (indexPath.section == 11) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"爱装修与其他公司的区别";
        }
    }
    if (indexPath.section == 12) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"客服 QQ";
            cell.detailTextLabel.text = @"3379607351";
            UILongPressGestureRecognizer *longPGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(QQNumLabelLongPressGR:)];
            cell.detailTextLabel.userInteractionEnabled = YES;
            [cell.detailTextLabel addGestureRecognizer:longPGR];
        }
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row==0) {
            ZCHPublicWebViewController *powerIntroVC = [[ZCHPublicWebViewController alloc] init];
            powerIntroVC.titleStr = @"4.8.0版本说明";
            powerIntroVC.webUrl = @"api/designs/9090/26521.htm";
            [self.navigationController pushViewController:powerIntroVC animated:YES];
        }
        
   
    }
    if (indexPath.section==1) {
        
        ZCHPublicWebViewController *powerIntroVC = [[ZCHPublicWebViewController alloc] init];
        powerIntroVC.titleStr = @"权限介绍";
        powerIntroVC.webUrl = @"resources/html/quanxianjieshao.html";
        [self.navigationController pushViewController:powerIntroVC animated:YES];
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {// 说明书
            
            ZCHPublicWebViewController *explainBookVC = [[ZCHPublicWebViewController alloc] init];
            explainBookVC.titleStr = @"说明书";
            explainBookVC.webUrl = @"resources/html/shuomingshu.html";
            [self.navigationController pushViewController:explainBookVC animated:YES];
        }
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {// 总经理必读
            
            ZCHPublicWebViewController *managerMustReadVC = [[ZCHPublicWebViewController alloc] init];
            managerMustReadVC.titleStr = @"总经理必读";
            managerMustReadVC.webUrl = @"resources/html/zongjinglibidu.html";
            [self.navigationController pushViewController:managerMustReadVC animated:YES];
        }
    }
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {// 家装计算器创建视频
            
            ZCHPublicWebViewController *managerMustReadVC = [[ZCHPublicWebViewController alloc] init];
            managerMustReadVC.titleStr = @"家装计算器创建视频";
            managerMustReadVC.webUrl = @"resources/html/jisuanqishipin.html";
            [self.navigationController pushViewController:managerMustReadVC animated:YES];
        }
    }
    if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            ZCHPublicWebViewController *managerMustReadVC = [[ZCHPublicWebViewController alloc] init];
            managerMustReadVC.titleStr = @"爱装修企业网";
            managerMustReadVC.webUrl = @"resources/html/huangyewang.html";
            [self.navigationController pushViewController:managerMustReadVC animated:YES];
        }
    }
    if (indexPath.section == 6) {
        if (indexPath.row == 0) {
            ZCHPublicWebViewController *managerMustReadVC = [[ZCHPublicWebViewController alloc] init];
            managerMustReadVC.titleStr = @"施工日志介绍";
            managerMustReadVC.webUrl = @"resources/html/shigongshipin.html";
            [self.navigationController pushViewController:managerMustReadVC animated:YES];
        }
    }
    if (indexPath.section == 7) {
        if (indexPath.row == 0) {
            ZCHPublicWebViewController *managerMustReadVC = [[ZCHPublicWebViewController alloc] init];
            managerMustReadVC.titleStr = @"合作企业";
            managerMustReadVC.webUrl = @"resources/html/hezuoqiyeshipin.html";
            [self.navigationController pushViewController:managerMustReadVC animated:YES];
        }
    }
    if (indexPath.section == 8) {
        if (indexPath.row == 0) {
            ZCHPublicWebViewController *managerMustReadVC = [[ZCHPublicWebViewController alloc] init];
            managerMustReadVC.titleStr = @"商户联盟";
            managerMustReadVC.webUrl = @"resources/html/shangjialianmengshipin.html";
            [self.navigationController pushViewController:managerMustReadVC animated:YES];
        }
    }
    if (indexPath.section == 9) {
        if (indexPath.row == 0) {
            ZCHPublicWebViewController *managerMustReadVC = [[ZCHPublicWebViewController alloc] init];
            managerMustReadVC.titleStr = @"定制版使用攻略";
            managerMustReadVC.isAddBaseUrl = YES;
            managerMustReadVC.webUrl = @"http://api.bilinerju.com/api/designs/6575/10094.htm";
            [self.navigationController pushViewController:managerMustReadVC animated:YES];
        }
    }
    if (indexPath.section == 10) {
        if (indexPath.row == 0) {
            ZCHPublicWebViewController *managerMustReadVC = [[ZCHPublicWebViewController alloc] init];
            managerMustReadVC.titleStr = @"装修百科";
            managerMustReadVC.webUrl = @"resources/html/zhuangxiubaike.html";
            [self.navigationController pushViewController:managerMustReadVC animated:YES];
        }
    }
    if (indexPath.section == 11) {
        if (indexPath.row == 0) {
            ZCHPublicWebViewController *managerMustReadVC = [[ZCHPublicWebViewController alloc] init];
            managerMustReadVC.titleStr = @"爱装修与其他公司的区别";
            managerMustReadVC.webUrl = @"resources/html/aizhuangxiuyuqitagongsidequbie.html";
            [self.navigationController pushViewController:managerMustReadVC animated:YES];
        }
    }

}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)QQNumLabelLongPressGR:(UILongPressGestureRecognizer *)longPressGR {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:10]];
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = cell.detailTextLabel.text;
    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"QQ号码已复制"];
}

@end
