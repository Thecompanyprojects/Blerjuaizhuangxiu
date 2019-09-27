//
//  DemoShowViewController.m
//  iDecoration
//
//  Created by zuxi li on 2018/6/1.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DemoShowViewController.h"
#import "DemoShowCell.h"
#import "ShopDetailViewController.h"
#import "CompanyDetailViewController.h"
#import "ConstructionDiaryTwoController.h"
#import "senceWebViewController.h"
#import "BLEJCalculatorGetTempletByCompanyId.h"
#import "BLEJBudgetGuideController.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
#import "ZCHBudgetGuideConstructionCaseModel.h"
#import "BLEJCalculatorBaseAndSuppleListModel.h"
#import "senceModel.h"
#import "ZCHCalculatorItemsModel.h"
#import "BLRJCalculatortempletModelAllCalculatorcompanyData.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"


#if DEBUG
static NSString *calculatorCompanyID = @"1398";
static NSString *constructionID = @"2507";
static NSString *yellowID = @"1398";  // 公司1018

#else
static NSString *calculatorCompanyID = @"1409";
static NSString *constructionID = @"13830";
static NSString *yellowID = @"11846";  //店铺1051
#endif


@interface DemoShowViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

// 计算器模板的
// 新添加的模板
@property (strong, nonatomic) NSMutableArray *suppleListArr;
// 基础模板
@property (strong, nonatomic) NSMutableArray *baseItemsArr;
// 置顶的公司列表
@property (strong, nonatomic) NSMutableArray *topConstructionList;
// 基础模板中的其他信息
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *calculatorModel;
// 预算报价的顶部图片
@property (strong, nonatomic) NSMutableArray *topCalculatorImageArr;
// 预算报价的底部图片
@property (strong, nonatomic) NSMutableArray *bottomCalculatorImageArr;
// 施工案例
@property (strong, nonatomic) NSMutableArray *constructionCase;

@end

@implementation DemoShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看演示站";
    self.view.backgroundColor = kColorRGB(0xf2f2f2);
    [self tableView];
    
    [self getData];
}

#pragma mark - 获取计算器模板相关的内容
- (void)getData {
    NSString *urlStr =[BASEURL stringByAppendingString:BLEJCalculatorGetTempletByCompanyIdUrl];
    NSString *agencyid=   [[NSUserDefaults standardUserDefaults ]objectForKey:@"alias"];
    
    //NSString *companyId = self.companyID;
    NSString *companyId = @"1398";
    NSDictionary *parameter = @{@"companyId":companyId};
    
    [NetManager afPostRequest:urlStr parms:parameter finished:^(id responseObj) {
        //        [self getDataWithType:@"1"];
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
            
            
            [self.baseItemsArr removeAllObjects];
            [self.suppleListArr removeAllObjects];
            
            
            
            NSDictionary *dictData= [responseObj objectForKey:@"data"];
            NSMutableArray *companyItemArray =[NSMutableArray array];
            companyItemArray=[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[BLRJCalculatortempletModelAllCalculatorTypes class] json:dictData[@"list"]]];
            for (BLRJCalculatortempletModelAllCalculatorTypes *dict in  companyItemArray) {
                
                if ( dict.templeteTypeNo  > 2000 &&dict.templeteTypeNo <3000) {
                    [self.baseItemsArr addObject:dict];
                }
                if (dict.templeteTypeNo  ==0) {
                    [self.suppleListArr addObject:dict];
                }
            }
            BLRJCalculatortempletModelAllCalculatorcompanyData* companyData=     [BLRJCalculatortempletModelAllCalculatorcompanyData yy_modelWithJSON:dictData[@"company"]];
            
            //   self.allCalculatorCompanyData=companyData;
            
            
            
            
            //如果baseitems数据为空，去本地取出数据
            NSString *strPath = [[NSBundle mainBundle] pathForResource:@"DefaultBaseItem" ofType:@"geojson"];
            NSData *JSONData = [NSData dataWithContentsOfFile:strPath];
            
            id jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *dicTemplet = [[jsonObject
                                                objectForKey:@"data"]objectForKey:@"templet"] ;
            if (self.suppleListArr.count ==0) {
                NSMutableArray *supplyArray = [NSMutableArray arrayWithArray:[[jsonObject
                                                                               objectForKey:@"data"] objectForKey:@"defaultSupplementItemsList"]];
                
                self.suppleListArr=[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ZCHCalculatorItemsModel class] json:supplyArray]];
            }
            if (self.baseItemsArr.count ==0){
                NSMutableArray *baseItemArray = [NSMutableArray arrayWithArray:[[jsonObject objectForKey:@"data"] objectForKey:@"defaultBaseItemsList"]];
                
                self.baseItemsArr=[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ZCHCalculatorItemsModel class] json:baseItemArray]];
                
            }
            
            
            
            
            //                if (self.allCalculatorCompanyData.calVip == nil || [self.allCalculatorCompanyData.calVip isEqualToString:@""]) {// 0表示不是会员  还没有开通200
            //                }
            
        }else{
            [[PublicTool defaultTool] publicToolsHUDStr:responseObj[@"msg"] controller:self sleep:1.5];
        }
        
        
       
        
    } failed:^(NSString *errorMsg) {
        [[PublicTool defaultTool] publicToolsHUDStr:errorMsg controller:self sleep:1.5];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoShowCell *cell = [DemoShowCell cellWithTableView:tableView];
    NSArray *imageNameArr = @[@"icon_huangy", @"icon_gdi", @"icom_jisuan", @"icon_quanj"];
    cell.imageV.image = [UIImage imageNamed:imageNameArr[indexPath.section]];
    cell.titleLabel.text = @[@"企业网展示", @"工地展示", @"计算器展示", @"全景VR展示"][indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
#if DEBUG
        ShopDetailViewController *shop = [[ShopDetailViewController alloc] init];
        shop.shopName = @"北京中安瑞公司";
        shop.shopID = yellowID;
        [self.navigationController pushViewController:shop animated:YES];
#else
        CompanyDetailViewController *company = [CompanyDetailViewController new];
        company.companyName = @"欧曼地板招商总部";
        company.companyID = yellowID;
        [self.navigationController pushViewController:company animated:YES];
        
#endif
        
    }
    if (indexPath.section == 1) {
        ConstructionDiaryTwoController *constructionVC = [[ConstructionDiaryTwoController alloc] init];
        constructionVC.consID = constructionID.integerValue;
        [self.navigationController pushViewController:constructionVC animated:YES];
    }
    if (indexPath.section == 2) {
        BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
        VC.origin = @"0";
        VC.baseItemsArr = self.baseItemsArr;
        VC.suppleListArr = self.suppleListArr;
        VC.calculatorModel= self.calculatorModel;
        VC.constructionCase = self.constructionCase;
        VC.companyID = calculatorCompanyID;
        VC.topImageArr = self.topCalculatorImageArr;
        VC.bottomImageArr = self.bottomCalculatorImageArr;
        VC.isConVip = @"1";
     //   VC.dispalyNum = self.calculatorTempletModel.displayNumbers;
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (indexPath.section == 3) {
        //全景图
        senceWebViewController *sence = [[senceWebViewController alloc]init];
        senceModel *model = [senceModel new];
        model.picUrl = @"http://image.bilinerju.com/group1/M00/03/7D/ZcmPAlm45ICAcOksAAJkNMxI7ao763.png";
        model.picHref = @"http://55586685.m.weimob.com/Fpanorama/view360/view/xpq3jj";
        model.picTitle = @"淡雅的香，天然模样，到你面前，为了三生缘";
        sence.model = model;
        sence.companyLogo = @"http://image.bilinerju.com/group1/M00/02/6E/ZcmPAlmcMzmAKI-VAAC8aQuEIdM079.png";
        sence.companyName = @"欧曼地板招商总部";
        [self.navigationController pushViewController:sence animated:YES];

    }
}


-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kNaviBottom);
            make.left.right.bottom.equalTo(0);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kColorRGB(0xf2f2f2);
        [_tableView registerNib:[UINib nibWithNibName:@"DemoShowCell" bundle:nil] forCellReuseIdentifier:@"DemoShowCell.h"];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
