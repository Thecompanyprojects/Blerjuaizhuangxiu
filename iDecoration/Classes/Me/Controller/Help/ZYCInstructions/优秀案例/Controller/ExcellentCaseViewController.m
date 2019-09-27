//
//  ExcellentCaseViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/30.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "ExcellentCaseViewController.h"
#import "ExcellentCaseModel.h"
#import "ExcellentCaseTableViewCell.h"

@interface ExcellentCaseViewController ()
@property (assign, nonatomic) NSInteger type;

@end

@implementation ExcellentCaseViewController

- (void)Network {
    NSString *URL = @"excellent/getList.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @(self.type);
    [NetWorkRequest postJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        if ([result[@"code"]integerValue] == 1000) {
            self.arrayData = [NSArray yy_modelArrayWithClass:[ExcellentCaseModel class] json:result[@"data"][@"list"]].mutableCopy;
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.controllerType) {
        case ExcellentCaseViewControllerTypeExcellentCase:
            self.title = @"商家优秀推广案例";
            break;
        case ExcellentCaseViewControllerTypeMiniProgram:
            self.title = @"企业小程序";
            break;
        case ExcellentCaseViewControllerTypePCManager:
            self.title = @"PC端管理";
            break;
        case ExcellentCaseViewControllerTypePublic:
            self.title = @"公众号管理";
            break;
        default:
            break;
    }
    self.type = self.controllerType;
    [self Network];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExcellentCaseTableViewCell *cell = [ExcellentCaseTableViewCell cellWithTableView:tableView];
//    NSString *cellID = @"UITableViewCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
//    }
//    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
//    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.contentView.backgroundColor = White_Color;

    ExcellentCaseModel *model = self.arrayData[indexPath.section];
    cell.labelTitle.text = model.caseTitle;
    [cell.imageView sd_setImageWithURL:model.coverMap placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExcellentCaseModel *model = self.arrayData[indexPath.section];
    ZCHPublicWebViewController *controller = [[ZCHPublicWebViewController alloc]init];
    controller.titleStr = model.caseTitle;
    controller.isAddBaseUrl = true;
    controller.webUrl = model.caseHref;
    controller.isNeedShareButton = true;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
