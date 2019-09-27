//
//  NeedDecorationViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "NeedDecorationViewController.h"
#import "GetConstructsApi.h"
#import "GetConstructsTableViewCell.h"
#import "ConstructsDetailViewController.h"
#import "HanZXModel.h"
#import "EditHanApi.h"
#import "NSObject+CompressImage.h"
#import "DecorateNeedDetailViewController.h"
//#import "ZCHCalculatorPayController.h"
#import "ZCHVoiceReportSettingController.h"
#import "VipGroupViewController.h"
#import "PopupsViewDelegate.h"
#import "AdviserList.h"

@interface NeedDecorationViewController ()<UITableViewDelegate,UITableViewDataSource,POAlertViewDelegate>

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) PopupsViewDelegate *popView;
@end

@implementation NeedDecorationViewController

-(NSMutableArray*)listArray{
    
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createUI];
    [self createTableView];
    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self getConstructs];
    }];
    self.listTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page += 1;
        [self getConstructs];
    }];
    [self.listTableView.mj_header beginRefreshing];
    
    // 收到通知刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:kReciveRemoteNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSObject promptWithControllerName:@"NeedDecorationViewController"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshData:(NSNotification *)noti {
    if ([noti.userInfo[@"messageType"] integerValue] == 1) {
        _page = 1;
        [self getConstructs];
    }
}
-(void)createUI{
    
    self.title = @"客户预约";
    [self addRightItem];
}

#pragma mark - 添加navBar右侧的编辑按钮
- (void)addRightItem {
    
    // 设置导航栏最右侧的按钮
    UIButton *settingBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    settingBtn.frame = CGRectMake(0, 0, 44, 44);
    [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
    [settingBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    settingBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    settingBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    settingBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [settingBtn addTarget:self action:@selector(didClickSettingBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
}

-(void)createTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = Bottom_Color;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
    
 
    
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"GetConstructsTableViewCell" bundle:nil] forCellReuseIdentifier:@"GetConstructsTableViewCell"];
    
    self.listTableView = tableView;
}

-(PopupsViewDelegate *)popView
{
    if(!_popView)
    {
        _popView = [[PopupsViewDelegate alloc] initWithImage:@""];
        _popView.delegate = self;
        _popView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableSingleTap)];
        [_popView addGestureRecognizer:singleTap];
    }
    return _popView;
}

-(void)tableSingleTap
{
    [self.popView dismissAlertView];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000000000000001;
}



- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 5)];
    view.backgroundColor = kBackgroundColor;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak NeedDecorationViewController *weakSelf = self;
    
    GetConstructsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GetConstructsTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.hanModel = self.listArray[indexPath.section];

    HanZXModel *model = self.listArray[indexPath.section];
    cell.flagLabel.hidden = model.isRead;
    cell.toviewBlock = ^(NSString *companyId)
    {
         [self popshowalert:companyId];
    };
    
//    电话按钮
    cell.contactBlock = ^(NSMutableArray *phoneArr){
        
         if ([model.phone containsString:@"****"])
         {
            // [self popshowalert:[NSString stringWithFormat:@"%ld",(long)model.companyId]];
         }
         else
         {
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"拨打电话" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
             
             for (int i = 0; i<phoneArr.count; i++) {
                 
                 UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@",phoneArr[i]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     
                     NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneArr[i]];
                     UIWebView *callWebview = [[UIWebView alloc] init];
                     [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                     [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
                     
                 }];
                 
                 [alert addAction:action];
             }
             UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 
             }];
             [alert addAction:cancel];
             
             [weakSelf presentViewController:alert animated:YES completion:nil];
         }

    };
        
    
    return cell;
}


//是否允许编辑，默认值是YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        HanZXModel *model = self.listArray[indexPath.section];
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除提示" message:@"删除后不可恢复，请慎重！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [tableView setEditing:NO animated:YES];
        }];
        [alertC addAction:cancleAction];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteHanOrderByModel:model];
            YSNLog(@"删除 了");
        }];
        [alertC addAction:sureAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

//修改删除按钮的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GetConstructsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.flagLabel.hidden = YES;
    HanZXModel *model = self.listArray[indexPath.section];
    if (model.isRead != 1) {
        model.isRead = 1;
        [self setIsReadDataWithdecorationID:model.decorationId];
    }
    

}

#pragma mark - 设置按钮的点击事件
- (void)didClickSettingBtn:(UIButton *)btn {
    
    ZCHVoiceReportSettingController *settingVC = [UIStoryboard storyboardWithName:@"ZCHVoiceReportSettingController" bundle:nil].instantiateInitialViewController;
    settingVC.type = @"2";
    [self.navigationController pushViewController:settingVC animated:YES];
}


// 将已读
- (void)setIsReadDataWithdecorationID:(NSInteger)decorationID {
    NSString *defaultApi = [BASEURL stringByAppendingString:@"callDecoration/upRead.do"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@(decorationID) forKeyedSubscript:@"decorationId"];
    
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        // 加载成功
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
            YSNLog(@"------read");
        } else {
            YSNLog(@"------read");
        }
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

//根据id删除订单
-(void)deleteHanOrderByModel:(HanZXModel*)model{
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"callDecoration/delete.do"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    NSInteger hanId = model.decorationId > 0 ? model.decorationId : model.hanId;
    [paramDic setObject:@(hanId) forKeyedSubscript:@"decorationId"];
    
    YSNLog(@"%ld", model.hanId)
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        // 加载成功
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"订单删除成功"];
            [self.listArray removeObject:model];
            [self.listTableView reloadData];
        }
        if (code == 2000) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"订单删除失败"];
        }
        
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

-(void)getConstructs{
    
    // 最新的喊装修接口
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"callDecoration/v2/getList.do"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    [paramDic setObject:@(user.agencyId) forKeyedSubscript:@"agencysId"];
    [paramDic setObject:@(_page) forKey:@"page"];
    [paramDic setObject:@(30) forKey:@"pageSize"];

    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        // 加载成功
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
            NSArray *listArray = [responseObj objectForKey:@"data"][@"callList"];
            if (_page == 1) {
                [self.listArray removeAllObjects];
                self.listArray = [[NSArray yy_modelArrayWithClass:[HanZXModel class] json:listArray] mutableCopy];
            } else {
                [self.listArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[HanZXModel class] json:listArray]];
            }
            [self.listTableView reloadData];
        } else if (code == 1002) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"暂无消息"];
            
        } else if (code == 2000){
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请求数据出错"];
        } else {
            
        }
        if (_page == 1) {
            [self.listTableView.mj_header endRefreshing];
        } else {
            [self.listTableView.mj_footer endRefreshing];
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (_page == 1) {
            [self.listTableView.mj_header endRefreshing];
        } else {
            [self.listTableView.mj_footer endRefreshing];
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.listTableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - newDelegate

-(void)phoneclick:(NSInteger )index
{
    AdviserList *model = self.popView.dataSource[index];
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",model.adviserPhone];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
}

-(void)wxclick:(NSInteger )index
{
    [[PublicTool defaultTool] publicToolsHUDStr:@"复制成功" controller:self sleep:1.5];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    AdviserList *model = self.popView.dataSource[index];
    pasteboard.string = model.adviserWx;
    

}
-(void)qqclick:(NSInteger )index
{
    [[PublicTool defaultTool] publicToolsHUDStr:@"复制成功" controller:self sleep:1.5];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    AdviserList *model = self.popView.dataSource[index];
    pasteboard.string = model.adviserWx;
}


-(void)popshowalert:(NSString *)companyId
{
    NSDictionary *para = @{@"companyId":companyId};
    self.popView.dataSource = [NSMutableArray array] ;
    NSString *url = [BASEURL stringByAppendingString:GET_ZHUANGXIUGUWEN];
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[AdviserList class] json:responseObj[@"adviserList"]]];
            [self.popView.dataSource addObjectsFromArray:data];
            [self.popView.collectionView reloadData];
             [self.popView showView];
        }else{
            SHOWMESSAGE(@"暂无专属顾问");
        }
       
    } failed:^(NSString *errorMsg) {
        
    }];
}

@end
