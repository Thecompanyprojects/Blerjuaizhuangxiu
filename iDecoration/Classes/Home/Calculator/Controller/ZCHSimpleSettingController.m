//
//  ZCHSimpleSettingController.m
//  iDecoration
//
//  Created by 赵春浩 on 17/7/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHSimpleSettingController.h"
#import "ZCHSimpleSettingCell.h"
#import "BLEJBudgetTemplateGroupHeaderCell.h"
#import "ZCHSimpleBottomCell.h"
#import "ZCHSimpleBottomView.h"
#import "ZCHSimpleSettingHeaderCell.h"
#import "ZCHSimpleSettingHeaderDetailCell.h"
#import "ZCHSimpleSettingRoomModel.h"
#import "ZCHSimpleSettingRoomDetailModel.h"
#import "ZCHSimpleSettingSupplementModel.h"
#import "ZCHSimpleSettingMessageModel.h"
#import "BLEJCalculatePackageDetailCell.h"
#import "BLEJBudgetTemplateController.h"
static NSString *reuseIdentifier = @"ZCHSimpleSettingCell";
static NSString *reuseHeaderIdentifier = @"BLEJBudgetTemplateGroupHeaderCell";
static NSString *reuseFooterIdentifier = @"ZCHSimpleBottomCell";
static NSString *reuseHeaderDetailIdentifier = @"ZCHSimpleSettingHeaderDetailCell";
static NSString *ZCHSimpleSettingHeaderCellIdentifier = @"ZCHSimpleSettingHeaderCell";

@interface ZCHSimpleSettingController ()<UITableViewDelegate, UITableViewDataSource, BLEJBudgetTemplateGroupHeaderCellDelegate, ZCHSimpleSettingCellDelegate, ZCHSimpleSettingHeaderCellDelegate, ZCHSimpleBottomViewDelegate, ZCHSimpleSettingHeaderDetailCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) ZCHSimpleBottomView *bottomView;
@property (strong, nonatomic) NSMutableArray *bottomDataArr;
@property (strong, nonatomic) ZCHSimpleSettingMessageModel *msgModel;
// 记录分组标题中的减号是否被点击了
@property (strong, nonatomic) NSMutableArray *isGroupBtnClick;
// 记录保存时的参数
@property (strong, nonatomic) NSMutableArray *paramArr;
// 标记是否是详细报价(No表示是整装报价)
@property (assign, nonatomic) BOOL isDetail;
// 是否收取设计费
@property (assign, nonatomic) BOOL isGetDesignMoney;
// 是否对业主隐藏详细报价
@property (assign, nonatomic) BOOL isHideDetailPrice;
// 是否对业主收取税费
@property (assign, nonatomic) BOOL isHideTaxPrice;
// 是否对业主收取安装费
@property (assign, nonatomic) BOOL isInst;
// 是否对业主收取安装费
@property (copy, nonatomic) NSString *installFee;
@property (assign, nonatomic) CGRect cellFrame;
@property (assign, nonatomic)NSString *setType;

@end

@implementation ZCHSimpleSettingController{
    NSInteger hasDesign;
    NSInteger showDetail ;
    NSInteger isHideTaxPrice ;
    BOOL  inst;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (self.isSimple ==YES) {
        
          self.title = @"精装设置";
    } else {
        self.title = @"简装设置";
      
    }
    self.view.backgroundColor = White_Color;
    self.dataArr = [NSMutableArray array];
    self.bottomDataArr = [NSMutableArray array];
    self.isGroupBtnClick = [NSMutableArray array];
    self.paramArr = [NSMutableArray array];
   
    self.isGetDesignMoney = 0;
    self.isHideDetailPrice = 0;
    self.isInst=0;
    self.isHideTaxPrice=0;
    self.cellFrame = CGRectZero;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changTableViewFrame:) name:@"changTableViewFrame" object:nil];
    
    // 单独处理这里的返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, BLEJWidth, BLEJHeight - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = White_Color;
    [self.tableView registerClass:[ZCHSimpleSettingCell class] forCellReuseIdentifier:reuseIdentifier];

    [self.tableView registerClass:[BLEJBudgetTemplateGroupHeaderCell class] forHeaderFooterViewReuseIdentifier:reuseHeaderIdentifier];
    [self.tableView registerClass:[ZCHSimpleSettingHeaderCell class] forHeaderFooterViewReuseIdentifier:ZCHSimpleSettingHeaderCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZCHSimpleBottomCell" bundle:nil] forCellReuseIdentifier:reuseFooterIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZCHSimpleSettingHeaderDetailCell" bundle:nil] forCellReuseIdentifier:reuseHeaderDetailIdentifier];
      [self.tableView registerNib:[UINib nibWithNibName:@"BLEJCalculatePackageDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BLEJCalculatePackageDetailCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self addBottomView];
    [self addRightItem];
    [self getData];
    
    for (int i = 0; i < 2; i ++) {
        if (i == 0) {
            [self.isGroupBtnClick addObject:@{@"isClick" : @"1"}];
        } else {

            [self.isGroupBtnClick addObject:@{@"isClick" : @"0"}];
        }
    }
    
    

    
}

// 返回事件
- (void)back {
    
    TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"您还没有保存，是否继续退出？" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alertView show];
    
}

- (void)getData {
 //   0:简装，1:精装,2:瓷砖简装，3:瓷砖精装,4:地板简装，5:地板精装,6:吊顶简装，7:吊顶精装
  //type   0:简装，1:精装,2:瓷砖简装，3:瓷砖精装,4:地板简装，5:地板精装
    
//0:简装，1:精装,2:瓷砖简装，3:瓷砖精装,4:地板简装，5:地板精装,6:吊顶简装，7:吊顶精装,8:地暖简装,9:地暖精装,10:成品简装,11:成品精装
// calculatorType (1.轻辅计算器,2.套餐计算器,3.瓷砖计算器,4.地板计算器,5.集成吊顶计算器,6.壁纸、壁布计算器,7.地暖计算器,8.成品计算器)
    
    self.setType =[NSString string];
    int  ppa=self.Calcaultortype.intValue;

        switch (ppa) {
            
            case 1:
                self.setType = self.isSimple?@"1": @"0";
                break;
            case 2:
                break;
            case 3:
                self.setType = self.isSimple?@"3": @"2";
                break;
            case 4:
                self.setType = self.isSimple?@"5": @"4";
                break;
            case 5:
                self.setType = self.isSimple?@"7": @"6";
                break;
            case 6:
                break;
            case 7:
                self.setType = self.isSimple?@"9": @"8";
                break;
            case 8:
                self.setType = self.isSimple?@"11": @"10";
                break;
            default:
                break;
        
    }
    
    NSString *api = [BASEURL stringByAppendingString:@"calRoomSet/getByCompanyId.do"];
    NSDictionary *param = @{
                            @"companyId" :self.companyId,
                            @"type" : self.setType?:@""
                            };
    
    [NetManager afPostRequest:api parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.dataArr removeAllObjects];
            [self.bottomDataArr removeAllObjects];
            [self.isGroupBtnClick removeAllObjects];
            [self.paramArr removeAllObjects];
            
            self.msgModel = [ZCHSimpleSettingMessageModel yy_modelWithJSON:responseObj[@"data"][@"roomSet"]];
            self.isDetail = [self.msgModel.showDetail boolValue];
            self.isGetDesignMoney = [self.msgModel.hasDesign boolValue];
            self.isHideDetailPrice = [self.msgModel.showDetail boolValue];
            self.isInst =[self.msgModel.inst boolValue];
            self.installFee =self.msgModel.installationFee;
            for (int i = 0; i < [responseObj[@"data"][@"roomList"] count]+1 ; i ++) {

                if (i == 0) {
                    [self.isGroupBtnClick addObject:@{@"isClick" : @"0"}];
                } else {
                    [self.isGroupBtnClick addObject:@{@"isClick" : @"0"}];
                }
        
            }
            if ([responseObj[@"data"][@"roomList"] count] > 0) {
                
                self.paramArr = [NSMutableArray arrayWithArray:responseObj[@"data"][@"roomList"]];
                for (NSDictionary *dic in self.paramArr) {
                    
                    [self.dataArr addObject:[ZCHSimpleSettingRoomModel yy_modelWithDictionary:dic]];
                }
            }
            
            if ([responseObj[@"data"][@"supplementList"] count] > 0) {
                
                for (NSDictionary *dic in responseObj[@"data"][@"supplementList"]) {
                    
                    [self.bottomDataArr addObject:[ZCHSimpleSettingSupplementModel yy_modelWithDictionary:dic]];
                }
            }
            self.bottomView.dataArr = self.bottomDataArr;
        }else{
             [[PublicTool defaultTool]publicToolsHUDStr:@"还未设置基础模版，请点击完成，会为您自动生成！" controller:self sleep:2];
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

#pragma mark - 添加navBar右侧的编辑按钮
- (void)addRightItem {
    
    // 设置导航栏最右侧的按钮
    UIButton *finishBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    finishBtn.frame = CGRectMake(0, 0, 44, 44);
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    finishBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    finishBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [finishBtn addTarget:self action:@selector(didClickFinishBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
}


- (void)addBottomView {
    
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 80)];

    self.tableView.tableFooterView = bottomBgView;
    
    ZCHSimpleBottomView *bottomView = [[ZCHSimpleBottomView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    [self.view addSubview:bottomView];
    bottomView.delegate = self;
    self.bottomView = bottomView;
    self.bottomView.hidden = YES;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.section == 0) {
            if ([self.Calcaultortype isEqualToString:@"4"]||[self.Calcaultortype isEqualToString:@"7"]||[self.Calcaultortype isEqualToString:@"8"]) {
               
                    ZCHSimpleBottomCell* detailcell = [tableView dequeueReusableCellWithIdentifier:@"ZCHSimpleBottomCell"];
                    detailcell.unitPrice.text =self.installFee;
                    detailcell.Name.text =@"请输入安装费";
                    return  detailcell;
                }else if ([self.Calcaultortype isEqualToString:@"3"]||[self.Calcaultortype isEqualToString:@"5"]){
                    return  [UITableViewCell new];
                }else{
            ZCHSimpleSettingHeaderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseHeaderDetailIdentifier forIndexPath:indexPath];
            cell.model = self.msgModel;
            cell.designSwitch.on = self.isGetDesignMoney;
            cell.detailPriceSwitch.on = self.isHideDetailPrice;
            cell.TaxSwith.on=self.isHideTaxPrice;
            cell.delegate = self;
            return cell;
            
        }
        }
            ZCHSimpleSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
          
            ZCHSimpleSettingRoomModel *model = self.dataArr[indexPath.section - 1];
            cell.isShowMinusBtn = [[self.isGroupBtnClick[indexPath.section] objectForKey:@"isClick"] boolValue];
            [cell settingCellWithData:model.items];
            cell.delegate = self;
            cell.indexpath = indexPath;
            return cell;

    

    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

          if (indexPath.section == 0) {
            
              if ([self.Calcaultortype isEqualToString:@"4"]||[self.Calcaultortype isEqualToString:@"7"]||[self.Calcaultortype isEqualToString:@"8"]) {
                  return 44;
              }else if([self.Calcaultortype isEqualToString:@"3"]||[self.Calcaultortype isEqualToString:@"5"]){
                  return 0.001;
              }
            return 93+46;
          }else{
            return ([((ZCHSimpleSettingRoomModel *)self.dataArr[indexPath.section - 1]).items count] / 3 + ([((ZCHSimpleSettingRoomModel *)self.dataArr[indexPath.section - 1]).items count] % 3 > 0 ? 1 : 0)) * 40 + 10;
          }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section ==0) {
        if ([self.Calcaultortype isEqualToString:@"4"]||[self.Calcaultortype isEqualToString:@"7"]||[self.Calcaultortype isEqualToString:@"8"]) {
            return 44;

        }else if ([self.Calcaultortype isEqualToString:@"3"]||[self.Calcaultortype isEqualToString:@"5"]){
            return 0.001;
        }
        return 0.001;
    }
    
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section ==0) {
        if ([self.Calcaultortype isEqualToString:@"4"]||[self.Calcaultortype isEqualToString:@"7"]||[self.Calcaultortype isEqualToString:@"8"]) {
            ZCHSimpleSettingHeaderCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ZCHSimpleSettingHeaderCellIdentifier];
            cell.delegate = self;
            cell.titleLabel.text = @"安装费";
            return cell;
        }
        return [UIView new];
    }
    BLEJBudgetTemplateGroupHeaderCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeaderIdentifier];
    cell.budgetTemplateGroupHeaderCellDelegate=self;
    cell.isRotate = [[self.isGroupBtnClick[section] objectForKey:@"isClick"] boolValue];
    cell.sectionIndex = section;
    cell.model = self.dataArr[section - 1];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - 完成按钮的点击事件
- (void)didClickFinishBtn:(UIButton *)btn {
    if ([self.Calcaultortype isEqualToString:@"1"] ) {
        if ([self.msgModel.setId integerValue] > 0) {
            
            [self updateSetting];
        } else {
            
            [self firstSaveSetting];
        }
        return;
    }
    if (self.paramArr.count ==0) {
         [self firstSaveSetting];
        return;
    }
    int kPQ =0;
    int kMM =0;
    if ([self.Calcaultortype isEqualToString:@"3"]||[self.Calcaultortype isEqualToString:@"4"]||[self.Calcaultortype isEqualToString:@"5"]||[self.Calcaultortype isEqualToString:@"7"]||[self.Calcaultortype isEqualToString:@"8"]) {
        for (int i=0; i<self.dataArr.count; i++) {
             ZCHSimpleSettingRoomModel *model = self.dataArr[i];
            if (model) {
                kMM++;
                if ( model.items.count>0) {
                    kPQ ++;
                }
            }
        }
    if (kMM>=3 &&kPQ>=3) {
            if ([self.msgModel.setId integerValue] > 0) {
                
                [self updateSetting];
            } else {
                
                [self firstSaveSetting];
            }
    }else{
      
          TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"您还没有添加完模板(至少添加三个房间类型，每个类型里面有一个设置)，是否继续添加？" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
            
            if (buttonIndex == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } cancelButtonTitle:@"放弃" otherButtonTitles:@"继续", nil];
              [alertView show];
      }
    }
}

- (void)firstSaveSetting {
    
     NSInteger   price = 0;//已经废弃，之前的字段ispakcage 也废弃
     if ([self.Calcaultortype isEqualToString:@"4"]||[self.Calcaultortype isEqualToString:@"3"]||[self.Calcaultortype isEqualToString:@"5"]||[self.Calcaultortype isEqualToString:@"7"]||[self.Calcaultortype isEqualToString:@"8"]) {
         
         if ([self.Calcaultortype isEqualToString:@"4"]||[self.Calcaultortype isEqualToString:@"7"]||[self.Calcaultortype isEqualToString:@"8"]) {
              ZCHSimpleBottomCell *cell =  (ZCHSimpleBottomCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
             self.installFee =cell.unitPrice.text;
             inst = self.installFee?YES:NO;
         }
     }else{
         ZCHSimpleSettingHeaderDetailCell *topCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
          hasDesign = topCell.designSwitch.on;
          showDetail = topCell.detailPriceSwitch.on;
         isHideTaxPrice =topCell.TaxSwith.on;
     }

    if (self.paramArr.count ==0) {
        [self getDataIfNetworkDataIsUnavailable];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.paramArr options:0 error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSString *api = [BASEURL stringByAppendingString:@"calRoomSet/save.do"];
    NSDictionary *param = @{
                            @"companyId" : self.companyId,
                            @"setType" : self.setType?:@"0",
                            @"hasDesign" : @(hasDesign),
                            @"showDetail" : @(showDetail),
                            @"isPackage" : @(0),
                            @"price" : @(price),
                             @"tax" : @(isHideTaxPrice),
                            @"inst" : @(inst),
                            @"installation" : self.installFee?:@"",
                            @"roomItemsList" : str,
                            };

    [NetManager afPostRequest:api parms:param finished:^(id responseObj) {

        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {

            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"设置成功"];

            [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(NSString *errorMsg) {

        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

- (void)updateSetting {
    
    if ([self.Calcaultortype isEqualToString:@"4"]||[self.Calcaultortype isEqualToString:@"7"]||[self.Calcaultortype isEqualToString:@"8"]) {
        ZCHSimpleBottomCell *cell =  (ZCHSimpleBottomCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.installFee =cell.unitPrice.text;
         inst = self.installFee?YES:NO;
    }else  if ([self.Calcaultortype isEqualToString:@"3"]||[self.Calcaultortype isEqualToString:@"5"]){
        
    }else{
    ZCHSimpleSettingHeaderDetailCell *topCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        hasDesign = topCell.designSwitch.on;
        showDetail = topCell.detailPriceSwitch.on;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.paramArr options:0 error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *param = @{
                            @"setId" :self.msgModel.setId,//0为新增，其他为修改
                            @"companyId" : self.companyId,
                            @"setType" :self.setType?:@"0",
                            @"price" : @(0),
                            @"hasDesign" : @(hasDesign),
                            @"showDetail" : @(showDetail),
                            @"isPackage" : @(0),
                            @"roomItemsList" : str,
                            @"inst" : @(inst),
                            @"installation" : self.installFee?:@"",
                            };
          NSString *Api = [BASEURL stringByAppendingString:@"/calRoomSet/update.do"];
    [NetManager afPostRequest:Api parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"设置成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}


#pragma mark - BLEJBudgetTemplateGroupHeaderCellDelegate方法
// 点击+
- (void)didClickPlusBtnWithSection:(NSInteger)section {
    
    [self.isGroupBtnClick replaceObjectAtIndex:section withObject:@{@"isClick" : [NSString stringWithFormat:@"%d", 0]}];
    [self.tableView reloadTableViewWithRow:-1 andSection:section];
    self.bottomView.section = section;
    self.bottomView.hidden = NO;
    
    ZCHSimpleSettingCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    CGRect rect = [cell convertRect:cell.bounds toView:self.view];
    CGFloat maxHeight = CGRectGetMaxY(rect);
    CGFloat margin = BLEJHeight - maxHeight - 220;
    
    CGRect tableViewFrame = self.tableView.frame;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.tableView.frame = CGRectMake(tableViewFrame.origin.x, tableViewFrame.origin.y, tableViewFrame.size.width, tableViewFrame.size.height - 220);
    }];
    
    if (margin < 0) {
        
        CGRect cellFrame = cell.frame;
        self.cellFrame = cellFrame;
        [self.tableView scrollRectToVisible:CGRectMake(cellFrame.origin.x, CGRectGetMinY(cellFrame), cellFrame.size.width, cellFrame.size.height) animated:YES];
    }
    
//    NSLog(@"%@", NSStringFromCGRect(rect));
}

// 点击-
- (void)didClickMinusBtnWithSection:(NSInteger)section andIsSelected:(BOOL)isSeleted {
    
    [self.isGroupBtnClick replaceObjectAtIndex:section withObject:@{@"isClick" : [NSString stringWithFormat:@"%d", isSeleted]}];
    [self.tableView reloadTableViewWithRow:-1 andSection:section];
}

#pragma mark - ZCHSimpleSettingCellDelegate代理方法(删除某一项)
- (void)didClickDeleteBtnWithIndexpath:(NSIndexPath *)indexpath andIndex:(NSInteger)index {
    
    
    ZCHSimpleSettingRoomModel *model = self.dataArr[indexpath.section - 1];
    [model.items removeObjectAtIndex:index];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.paramArr[indexpath.section - 1]];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[dic objectForKey:@"items"]];
    [arr removeObjectAtIndex:index];
    [dic setObject:arr forKey:@"items"];
     [self.isGroupBtnClick replaceObjectAtIndex:indexpath.section withObject:@{@"isClick" : @"0" }];
    [self.paramArr replaceObjectAtIndex:indexpath.section - 1 withObject:dic];
    
    [self.tableView reloadTableViewWithRow:-1 andSection:indexpath.section];
}


#pragma mark - ZCHSimpleSettingHeaderDetailCellDelegate方法(用于是否收取设计费还有是否隐藏详细报价的点击事件
- (void)didClickSwitchBtn:(UISwitch *)btn andType:(NSString *)type {
    
    if ([type isEqualToString:@"1"]) {// 设计费
        
        self.isGetDesignMoney = btn.isOn;
    } else if ([type isEqualToString:@"2"]){// 隐藏详细报价
        
        self.isHideDetailPrice = btn.isOn;
    }else if ([type isEqualToString:@"3"]){// 税费
        self.isHideTaxPrice=btn.isOn;
    }
}

#pragma mark - ZCHSimpleBottomViewDelegate代理方法(底部弹出视图的点击事件)

- (void)didClickPickerViewWithIndex:(NSInteger)index andSection:(NSInteger)section {
    
    ZCHSimpleSettingSupplementModel *model = self.bottomDataArr[index];
    ZCHSimpleSettingRoomModel *settingModel = self.dataArr[section - 1];
    
    for (ZCHSimpleSettingRoomDetailModel *modelDetail in settingModel.items) {
        
        if ([self.Calcaultortype isEqualToString:@"3"]||[self.Calcaultortype isEqualToString:@"4"]||[self.Calcaultortype isEqualToString:@"5"]||[self.Calcaultortype isEqualToString:@"7"]||[self.Calcaultortype isEqualToString:@"8"]) {
            if ([modelDetail.supplementId isEqualToString:model.supplementId] || [modelDetail.name isEqualToString:model.supplementName]) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请不要重复添加"];
                return;
            }
            
        }else{
            if ([modelDetail.supplementId isEqualToString:model.supplementId] && [modelDetail.positionType isEqualToString:model.positionType]) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请不要重复添加"];
                return;
            }
        }
        
        
    }
    NSDictionary *dic = @{
                          @"roomItemId" : @"0",
                          @"setId" : self.isSimple ? @"1" : @"0",
                          @"supplementId" : model.supplementId?:@"",
                          @"roomType" : ((ZCHSimpleSettingRoomModel *)self.dataArr[section - 1]).typeNo,
                          @"companyId" : self.companyId,
                          @"positionType" : model.positionType?:@"",
                          @"name" : model.supplementName?:@"",
                           @"itemNumber" : @"1",
                          };
    ZCHSimpleSettingRoomDetailModel *newModel = [ZCHSimpleSettingRoomDetailModel yy_modelWithDictionary:dic];
    [settingModel.items addObject:newModel];
//    [self.dataArr replaceObjectAtIndex:section - 1 withObject:settingModel];
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionaryWithDictionary:self.paramArr[section - 1]];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[dicParam objectForKey:@"items"]];
    [arr addObject:dic];
    [dicParam setObject:arr forKey:@"items"];
    [self.paramArr replaceObjectAtIndex:section - 1 withObject:dicParam];
    
//    self.bottomView.hidden = YES;
    [self.tableView reloadTableViewWithRow:-1 andSection:section];
    ZCHSimpleSettingCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    if (![NSStringFromCGRect(self.cellFrame) isEqualToString:NSStringFromCGRect(CGRectZero)]) {
        
        [self.tableView scrollRectToVisible:CGRectMake(self.cellFrame.origin.x, CGRectGetMinY(self.cellFrame), self.cellFrame.size.width, cell.frame.size.height) animated:YES];
    }
}
-(void)getDataIfNetworkDataIsUnavailable{
    
    //如果baseitems数据为空，去本地取出数据
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"DefaultSettingSImpleRoomModel" ofType:@"geojson"];
    NSData *JSONData = [NSData dataWithContentsOfFile:strPath];
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    
    
    self.msgModel = [ZCHSimpleSettingMessageModel yy_modelWithJSON: jsonObject[@"data"][@"roomSet"]];
    self.isDetail = [self.msgModel.showDetail boolValue];
    self.isGetDesignMoney = [self.msgModel.hasDesign boolValue];
    self.isHideDetailPrice = [self.msgModel.showDetail boolValue];
    self.isInst =[self.msgModel.inst boolValue];
    
    for (int i = 0; i < [ jsonObject[@"data"][@"roomList"] count] + 1; i ++) {
        if (i == 0) {
            [self.isGroupBtnClick addObject:@{@"isClick" : @"0"}];
        } else {
            [self.isGroupBtnClick addObject:@{@"isClick" : @"0"}];
        }
    }
    if ([jsonObject[@"data"][@"roomList"] count] > 0) {
        
        self.paramArr = [NSMutableArray arrayWithArray:jsonObject[@"data"][@"roomList"]];
        for (NSDictionary *dic in self.paramArr) {
            
            [self.dataArr addObject:[ZCHSimpleSettingRoomModel yy_modelWithDictionary:dic]];
        }
    }
    
    if ([ jsonObject[@"data"][@"supplementList"] count] > 0) {
        
        for (NSDictionary *dic in jsonObject[@"data"][@"supplementList"]) {
            
            [self.bottomDataArr addObject:[ZCHSimpleSettingSupplementModel yy_modelWithDictionary:dic]];
        }
    }
    self.bottomView.dataArr = self.bottomDataArr;
}

- (void)changTableViewFrame:(NSNotification *)noc {
    
    __weak typeof(self) weakSelf = self;
    self.cellFrame = CGRectZero;
    [UIView animateWithDuration:0.25 animations:^{
        
        weakSelf.tableView.frame = CGRectMake(0, 64, BLEJWidth, BLEJHeight - 64);
    }];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
