//
//  MyBeautifulArtController.m
//  iDecoration
//
//  Created by sty on 2017/11/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "MyBeautifulArtController.h"
#import "UnionActivityListCell.h"
#import "NSObject+CompressImage.h"
#import "DesignCaseListModel.h"
#import "BeautifulArtListModel.h"
#import "SetwWatermarkController.h"
#import "BeautifulArtManageController.h"
#import "EditMyBeatArtController.h"
#import "MyBeautifulArtShowController.h"
#import "TZImagePickerController.h"
#import "AdvertisingVC.h"
#import "VoteOptionModel.h"
#import "SSPopup.h"

static NSString *reuseIdentifier = @"UnionActivityListCell";
@interface MyBeautifulArtController ()<UITableViewDataSource, UITableViewDelegate>{
    CGFloat _cellH;
    
    NSInteger deleteTag;//删除的tag
}
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger meCalVipTag;//0:该人员未开通个人计算器会员  1:开通
@end

@implementation MyBeautifulArtController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的美文";
    self.dataArray = [NSMutableArray array];
    [self setUpUI];
    [self getData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"refreshBeatAteList" object:nil];
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"广告位" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getData];
}

- (void)setUpUI {
    
    UIButton *createNewsBtn = [[UIButton alloc] init];
    if (BLEJHeight > 736) {
        
        createNewsBtn.frame = CGRectMake(0, BLEJHeight - 59, BLEJWidth, 59);
        [createNewsBtn setBackgroundColor:kBackgroundColor];
        [createNewsBtn addTarget:self action:@selector(didClickCreateNewsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:createNewsBtn];
        
        UIImageView *addImage = [[UIImageView alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 50, 10, 24, 24)];
        addImage.image = [UIImage imageNamed:@"greenAddBtn"];
        [createNewsBtn addSubview:addImage];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(addImage.right + 10, 0, 100, 44)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = kMainThemeColor;
        label.text = @"创建美文";
        label.font = [UIFont systemFontOfSize:16];
        [createNewsBtn addSubview:label];
    } else {
        
        createNewsBtn.frame = CGRectMake(0, BLEJHeight - 44, BLEJWidth, 44);
        [createNewsBtn setBackgroundColor:kBackgroundColor];
        [createNewsBtn addTarget:self action:@selector(didClickCreateNewsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:createNewsBtn];
        
        UIImageView *addImage = [[UIImageView alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 - 50, 10, 24, 24)];
        addImage.image = [UIImage imageNamed:@"greenAddBtn"];
        [createNewsBtn addSubview:addImage];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(addImage.right + 10, 0, 100, 44)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = kMainThemeColor;
        label.text = @"创建美文";
        label.font = [UIFont systemFontOfSize:16];
        [createNewsBtn addSubview:label];
    }
    
    CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom+createNewsBtn.height);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom) style:UITableViewStylePlain];
    self.tableView.backgroundColor = White_Color;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"UnionActivityListCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return _cellH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BeautifulArtListModel *model = self.dataArray[indexPath.row];
    if (model.startTime&&model.startTime.length>2) {
        //活动
        UnionActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnionActivityListCellFirst"];
        if (!cell){
            cell = [[NSBundle mainBundle] loadNibNamed:@"UnionActivityListCell" owner:self options:nil][0];
        }
        [cell.stateBtn setHidden:YES];
        [cell configData:self.dataArray[indexPath.row] isLeader:YES];
        cell.stateBtn.tag = indexPath.row;
        _cellH = 100;
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(10, _cellH-1, kSCREEN_WIDTH-10, 1)];
        lineV.backgroundColor = kSepLineColor;
        [cell addSubview:lineV];
        return cell;
    }
    else{
        //美文
        UnionActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnionActivityListCellTwo"];
        if (!cell){
            cell = [[NSBundle mainBundle] loadNibNamed:@"UnionActivityListCell" owner:self options:nil][1];
        }
        [cell configData:self.dataArray[indexPath.row] isLeader:YES];
        _cellH = 50;
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(10, _cellH-1, kSCREEN_WIDTH-10, 1)];
        lineV.backgroundColor = kSepLineColor;
        [cell addSubview:lineV];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BeautifulArtListModel *model = self.dataArray[indexPath.row];
    if (model.startTime&&model.startTime.length>2){
        //活动
        BeautifulArtManageController *vc = [[BeautifulArtManageController alloc]init];
        vc.designsId = model.designsId;
        vc.activityId = model.activityId;
        
        vc.readNum = model.readNum;
        vc.shareNumber = model.shareNumber;
        vc.personNum = model.personNum;
        vc.collectionNum = model.collectionNum;
        vc.designTitle = model.designTitle;
        vc.designSubTitle = model.designSubTitle;
        vc.coverMap = model.coverMap;
        
        vc.agencysId = model.agencysId;
        
        
        vc.activityTime = model.startTime;
        vc.meCalVipTag = self.meCalVipTag;
        __weak typeof(self) weakSelf = self;
        vc.BeautifulArtManageBlock = ^{
            weakSelf.meCalVipTag = 1;
        };
        
        [self.navigationController pushViewController:vc animated:YES];
    }

    else{
        //美文
        MyBeautifulArtShowController *vc = [[MyBeautifulArtShowController alloc]init];
        vc.designsId = [model.designsId integerValue];
        vc.activityType = 2;
        vc.meCalVipTag = self.meCalVipTag;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

//是否允许编辑，默认值是YES
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

//修改删除按钮的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //__weak typeof(self) weakSelf = self;
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //    __weak typeof(self) weakSelf = self;
         BeautifulArtListModel *model = self.dataArray[indexPath.row];
        NSString *titlestr = @"";
        if (model.startTime&&model.startTime.length>2)
        {
            titlestr = @"是否确认删除该活动？";
        }
        else
        {
            titlestr = @"是否确认删除该美文？";
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titlestr
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        //                                                           delegate:self
        deleteTag = indexPath.row;
        alertView.tag = 300;
        [alertView show];
    }];
    
    return [NSArray arrayWithObjects:deleteAction, nil];

    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==300) {
        if (buttonIndex==1) {
            [self deleteActivity];
        }
    }
    
}


#pragma mark - 删除美文或活动
-(void)deleteActivity{
    //UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    BeautifulArtListModel *model = self.dataArray[deleteTag];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"cblejActivity/delete.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"designsId":model.designsId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"删除成功" controller:self sleep:1.5];
                [self getData];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"活动结束一个月后才能删除" controller:self sleep:1.5];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }

    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 获取数据

-(void)getData{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"designs/getDesignListByCompanyIdORAgencysId.do"];
    
  //  [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"agencysId":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
           //[[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                
                NSDictionary *dict = responseObj[@"data"];
                self.meCalVipTag = [responseObj[@"vipFlag"] integerValue];
                NSArray *array = [dict objectForKey:@"activityList"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[BeautifulArtListModel class] json:array];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:arr];
                [self.tableView reloadData];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"暂无美文" controller:self sleep:1.5];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
//        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

// 创建美文
- (void)didClickCreateNewsBtn:(UIButton *)btn {

    EditMyBeatArtController *vc = [[EditMyBeatArtController alloc] init];
    vc.isFistr = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (id)toArrayOrNSDictionary:(NSData *)jsonData{
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
    
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

-(void)rightBtnClick
{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    AdvertisingVC *vc = [AdvertisingVC new];
    vc.type = @"21";
    vc.relId = [NSString stringWithFormat:@"%ld",user.agencyId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
