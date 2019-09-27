//
//  NetworkManagementViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/7/18.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "NetworkManagementViewController.h"
#import "NetworkManagementModel.h"
#import "NetworkManagementTableViewCell.h"
#import "companyprogramVC.h"
#import "PCManagementViewController.h"
#import "ExcellentCaseViewController.h"

@interface NetworkManagementViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NetworkManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"五网合一";
    [self createTableView];
  
}

- (void)createTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = 0;
    [self.tableView setBackgroundColor:[UIColor hexStringToColor:@"f2f2f2"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NetworkManagementModel.arrayTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NetworkManagementTableViewCell *cell = [NetworkManagementTableViewCell cellWithTableView:tableView];
    [cell.imageViewIcon setImage:[UIImage imageNamed:NetworkManagementModel.arrayImage[indexPath.section]]];
    cell.labelTitle.text = NetworkManagementModel.arrayTitle[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExcellentCaseViewController *controller = [ExcellentCaseViewController new];
    switch (indexPath.section) {
        //爱装修app
        case 0:{
            //SHOWMESSAGE(@"敬请期待")
            ZCHPublicWebViewController *vc = [[ZCHPublicWebViewController alloc]init];
            vc.titleStr = @"";
            vc.isAddBaseUrl = true;
            vc.webUrl = @"http://api.bilinerju.com/api/designs/14154/10094.htm?from=singlemessage";
            vc.isNeedShareButton = true;
            vc.titleStr = @"爱装修版本介绍";
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 1:{//企业小程序
            controller.controllerType = ExcellentCaseViewControllerTypeMiniProgram;
            [self.navigationController pushViewController:controller animated:true];
//            companyprogramVC *controller = [companyprogramVC new];
//            controller.currentModel = self.currentModel;
//            controller.curremtModelArray = self.curremtModelArray;
//            controller.currentPersonCompanyArray = self.currentPersonCompanyArray;
//            controller.currentCompanyModel = self.currentCompanyModel;
//            [self.navigationController pushViewController:controller animated:true];
        }
            break;
        case 2:{//PC端管理
            controller.controllerType = ExcellentCaseViewControllerTypePCManager;
            [self.navigationController pushViewController:controller animated:true];
//            PCManagementViewController *controller = [PCManagementViewController new];
//            [self.navigationController pushViewController:controller animated:true];
        }
            break;
        case 3:{//公众号管理
            controller.controllerType = ExcellentCaseViewControllerTypePublic;
            [self.navigationController pushViewController:controller animated:true];
        }
//             SHOWMESSAGE(@"敬请期待")
            break;
        case 4:{
            ZCHPublicWebViewController *vc = [[ZCHPublicWebViewController alloc]init];
            vc.titleStr = @"五网合一说明";
            vc.isAddBaseUrl = true;
            vc.webUrl = @"http://api.bilinerju.com/api/designs/13894/10094.htm";
            vc.isNeedShareButton = true;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
             SHOWMESSAGE(@"敬请期待")
            break;
        default:
         
            break;
    }
}
@end
