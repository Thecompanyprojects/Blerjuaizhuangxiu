//
//  SendFlowersViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SendFlowersViewController.h"
#import "SendFlowersModel.h"
#import "SendFlowersTableViewCell.h"
#import "LoginViewController.h"
#import "AppleIAPManager.h"
#import "NewMyPersonCardTwoCell.h"
#import "NewMyPersonCardTwoCell.h"
#import "FlowersStoryViewController.h"

@interface SendFlowersViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *buttonBuy;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (copy, nonatomic) NSString *titleF;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSDictionary *dic;
@property (strong, nonatomic) NSString *flowID;

@end

@implementation SendFlowersViewController

- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = [NSMutableArray arrayWithArray:[SendFlowersModel sharedInstance].arrayData];
    }
    return _arrayData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"鲜花";
    [self createTableView];
    self.view.backgroundColor = self.tableView.backgroundColor;
    self.buttonBuy.layer.cornerRadius = 6.0f;
    self.buttonBuy.layer.masksToBounds = true;
    self.titleF = @"一朵";
}

- (void)createTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = 0;
    [self.tableView setBackgroundColor:[UIColor hexStringToColor:@"f2f2f2"]];
    self.tableView.scrollEnabled = false;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 45;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor hexStringToColor:@"f2f2f2"];
    if (section == 0) {
        UILabel *label = [UILabel new];
        [label setText:@"  购买数量"];
        [label setFont:[UIFont systemFontOfSize:16]];
        return label;
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SendFlowersTableViewCell *cell = [SendFlowersTableViewCell cellWithTableView:tableView];
    SendFlowersModel *model = self.arrayData[indexPath.section];
    cell.imageViewIcon.image = model.imageIcon;
    cell.imageSelected.image = model.isSelected?[UIImage imageNamed:@"btn_normal_pre"]:[UIImage imageNamed:@"btn_normal"];
    cell.labelPrice.text = model.stringPrice;
    cell.labelTitle.text = model.stringTitle;
    cell.labelDetail.text = model.stringDetail;
    if (indexPath.section == 1) {
        cell.blockDidTouchImageViewIcon = ^{//点击留言
            FlowersStoryViewController *controller = [FlowersStoryViewController new];
            controller.personId = self.agencyId;
            controller.blockFinish = ^(NSDictionary *para) {
                self.dic = para;
            };
            [self.navigationController pushViewController:controller animated:true];
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SendFlowersModel *model = self.arrayData[indexPath.section];
    [self.arrayData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SendFlowersModel *m = obj;
        m.isSelected = false;
    }];
    model.isSelected = true;
    self.titleF = model.stringTitle;
    self.index = indexPath.section;
    [self.tableView reloadData];
}

- (IBAction)didTouchButtonBuy:(UIButton *)sender {
    [ZYCTool alertControllerTwoButtonWithTitle:[NSString stringWithFormat:@"您将购买%@鲜花",self.titleF] message:@"" target:self notarizeButtonTitle:@"去购买" cancelButtonTitle:@"下次吧" notarizeAction:^{
        if (![[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
            return ;
        }
        [self NetworkOfSaveStory];
    } cancelAction:^{

    }];
}

- (void)NetworkOfSaveStory {
    MJWeakSelf;
    NSString *URL = @"cblejflower/add.do";
    NSString *title = self.dic[@"title"];
    NSString *story = self.dic[@"story"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"story"] = story;
    parameters[@"title"] = title;
    parameters[@"agencyId"] = GETAgencyId;//当前用户Id
    
    if ((title.length || story.length) && self.index == 1){
        parameters[@"type"] = @(1);//类型(0为普通类型,1为故事类型)
    }else{
        parameters[@"type"] = @(0);//类型(0为普通类型,1为故事类型)
   }
    if (self.isCompamyID) {

    }else{

    }

     parameters[@"companyId"]  =self.compamyIDD ?:@(0);
     parameters[@"personId"] = self.agencyId ?:@(0);//名片主人Id
    
    [NetWorkRequest postJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        if ([result[@"code"] integerValue] == 1000) {
            self.flowID = result[@"data"][@"flowerId"];
            [[AppleIAPManager sharedManager] buyFlowerWithIAP:self.titleF completion:^(NSString *orderId) {
                if (self.isCompamyID) {
                    [weakSelf sendCompanyWithOrderID:orderId Cell:self.cell];
                }else{
                [weakSelf sendpersonFlowerWithOrderID:orderId Cell:self.cell];
                }
            }];
        }
    } fail:^(NSError *error) {

    }];
}


- (void)sendCompanyWithOrderID:(NSString *)orderId Cell:(NewMyPersonCardTwoCell *)cell{
    NSString *defaultApi = [BASEURL stringByAppendingString:@"applpay/companyFlower.do"];
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSMutableDictionary *parameters = @{}.mutableCopy;
    [ parameters setObject:self.flowID ?:@"" forKey:@"flowerId"];
    [ parameters setObject: self.compamyIDD ?:@""  forKey:@"companyId"];
    [ parameters setObject: self.index == 0?@(0):@(1) forKey:@"type"];
     [ parameters setObject: @(userModel.agencyId) forKey:@"agencyId"];
     [ parameters setObject: orderId forKey:@"tradeNo"];
    
  
    [NetManager afPostRequest:defaultApi parms:parameters finished:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([responseObj[@"code"] integerValue] == 1000) {
            SHOWMESSAGE(@"成功支付");
          //  [[NSNotificationCenter defaultCenter] postNotificationName:@"kRealeaseToRefreshData" object:nil];
            if (self.blockIsPay) {
                self.blockIsPay(true);
            }
//            [[SendFlowersModel sharedInstance].arrayData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                SendFlowersModel *m = obj;
//                if (idx == 0) {
//                    m.isSelected = true;
//                }else
//                    m.isSelected = false;
//            }];
           
            [self.navigationController popViewControllerAnimated:true];
        }else
            SHOWMESSAGE(@"与服务器连接失败请重试")
            } failed:^(NSString *errorMsg) {
                SHOWMESSAGE(@"与服务器连接失败请重试")
            }];

}
- (void)sendpersonFlowerWithOrderID:(NSString *)orderId Cell:(NewMyPersonCardTwoCell *)cell{
    NSString *defaultApi = [BASEURL stringByAppendingString:@"applpay/flower2.do"];
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSMutableDictionary *parameters = @{}.mutableCopy;
    
    [ parameters setObject:self.flowID ?:@"" forKey:@"flowerId"];
    [ parameters setObject: self.agencyId ?:@""  forKey:@"personId"];
    [ parameters setObject: self.index == 0?@(0):@(1) forKey:@"type"];
    [ parameters setObject: @(userModel.agencyId) forKey:@"agencyId"];
    [ parameters setObject: orderId forKey:@"tradeNo"];
//    parameters[@"flowerId"] = self.flowID;
//    parameters[@"personId"] = self.agencyId;
//    parameters[@"type"] = self.index == 0?@(0):@(1);
//    parameters[@"agencyId"] = @(userModel.agencyId);
//    parameters[@"tradeNo"] = orderId;
    [NetManager afPostRequest:defaultApi parms:parameters finished:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([responseObj[@"code"] integerValue] == 1000) {
            if (self.blockIsPay) {
                self.blockIsPay(true);
            }
            [[SendFlowersModel sharedInstance].arrayData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SendFlowersModel *m = obj;
                if (idx == 0) {
                    m.isSelected = true;
                }else
                    m.isSelected = false;
            }];
            [self.navigationController popViewControllerAnimated:true];
        }else
            SHOWMESSAGE(@"与服务器连接失败请重试")
    } failed:^(NSString *errorMsg) {
        SHOWMESSAGE(@"与服务器连接失败请重试")
    }];
}

- (void)dealloc {
    [[SendFlowersModel sharedInstance].arrayData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SendFlowersModel *m = obj;
        if (idx == 0) {
            m.isSelected = true;
        }else
            m.isSelected = false;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
