//
//  attentiondetailsVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/6.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "attentiondetailsVC.h"
#import "attentiondetailsCell.h"
#import <SDAutoLayout.h>
#import "attentionModel.h"
#import "ConstructionDiaryTwoController.h"
#import "MainMaterialDiaryController.h"
#import "NewsActivityShowController.h"
#import "GoodsDetailViewController.h"
#import "BLEJBudgetGuideController.h"
#import "BLEJCalculatorGetTempletByCompanyId.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
#import "BLEJCalculatorBaseAndSuppleListModel.h"
#import "ZCHBudgetGuideConstructionCaseModel.h"
#import "BLRJCalculatortempletModelAllCalculatorcompanyData.h"
@interface attentiondetailsVC ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,copy) NSString *messageId;//消息id

@property (nonatomic,strong) NSMutableArray *topCalculatorImageArr;
@property (nonatomic,strong) BLRJCalculatortempletModelAllCalculatorTypes *calculatorTempletModel;
@property (nonatomic,strong) NSMutableArray *bottomCalculatorImageArr;
@property (nonatomic,strong) NSMutableArray *baseItemsArr;
@property (nonatomic,strong) NSMutableArray *suppleListArr;
@property (nonatomic,strong) NSMutableArray *allCompanyItem;
@property (nonatomic,strong) NSMutableArray *constructionCase;
@end

static NSString *attentiondetailidentfid = @"attentiondetailidentfid";

@implementation attentiondetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _allCompanyItem =[NSMutableArray array];
    self.title = @"消息";
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    [self loaddata];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeread
{
//    if ([self.isRead isEqualToString:@"0"]) {
    
        NSString *url = [BASEURL stringByAppendingString:GET_CHANGEGUANZHUXIAIXI];
        if (!IsNilString(self.messageId)) {
            NSDictionary *para = @{@"messageId":self.messageId};
            [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
                
            } failed:^(NSString *errorMsg) {
                
            }];
        }
    
//    }
}

-(void)loaddata
{
    NSString *url = [BASEURL stringByAppendingString:GET_GUANZHUXIAOXIXIANGQING];
    NSString *agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSDictionary *para = @{@"agencyId":agencyId,@"companyId":self.companyId,@"isRead":@"0"};
    [self.dataSource removeAllObjects];
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[attentionModel class] json:responseObj[@"data"][@"list"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom) style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.emptyDataSetSource = self;
        _table.emptyDataSetDelegate = self;
    }
    return _table;
}

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}



#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    attentiondetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:attentiondetailidentfid];
    cell = [[attentiondetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:attentiondetailidentfid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setdata:self.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:kSCREEN_WIDTH tableView:self.table];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无消息！";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    attentionModel *model = self.dataSource[indexPath.row];
    self.messageId = [NSString stringWithFormat:@"%ld",model.messageId];
    [self changeread];
    
    //（0:公司,1:工地,2:计算器,3:美文，4：活动,5:商品）
   //美文 活动 商品  工地
    

    if (model.type==1) {
        
        if ([model.constructionType isEqualToString:@"0"]) {
            //施工日志
            ConstructionDiaryTwoController *constructionVC = [[ConstructionDiaryTwoController alloc] init];
            constructionVC.consID = model.relId;
            [self.navigationController pushViewController:constructionVC animated:YES];
        }
        else
        {
            //主材日志
            MainMaterialDiaryController *mainDiaryVC = [[MainMaterialDiaryController alloc] init];
            mainDiaryVC.consID = model.relId;
            [self.navigationController pushViewController:mainDiaryVC animated:YES];
        }
    }
    if (model.type==2) {
        BLEJCalculatorGetTempletByCompanyId *calculatorGetTempletByCompanyId = [[BLEJCalculatorGetTempletByCompanyId alloc] initWithCompanyId:[NSString stringWithFormat:@"%ld",(long)model.companyId]];
        
        [calculatorGetTempletByCompanyId startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSInteger code = [[request.responseJSONObject objectForKey:@"code"] integerValue];
            if (code == 1000) {
                
                self.allCompanyItem=[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[BLRJCalculatortempletModelAllCalculatorTypes class] json:request.responseJSONObject[@"list"]]];
                for (BLRJCalculatortempletModelAllCalculatorTypes *dictModel in  self.allCompanyItem) {
                    
                    if ( dictModel.templeteTypeNo  > 2000 &&dictModel.templeteTypeNo <3000) {
                        [self.baseItemsArr addObject:dictModel];
                    }
                    if (dictModel.templeteTypeNo  ==0) {
                        
                        [self.suppleListArr addObject:dictModel];
                    }
                }
                BLRJCalculatortempletModelAllCalculatorcompanyData* companyData=     [BLRJCalculatortempletModelAllCalculatorcompanyData yy_modelWithJSON:request.responseObject[@"company"]];
                
               
              
           
              
                
                
                
                BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
                VC.baseItemsArr = self.baseItemsArr;
                VC.origin = @"0";
                VC.suppleListArr = self.suppleListArr;
                VC.calculatorModel = self.calculatorTempletModel;
                VC.constructionCase = self.constructionCase;
                VC.topImageArr = self.topCalculatorImageArr;
                VC.bottomImageArr = self.bottomCalculatorImageArr;
                VC.companyID = [NSString stringWithFormat:@"%ld",(long)model.companyId];
                VC.isConVip = @"1";
//                VC.dispalyNum = self.calculatorTempletModel.displayNumbers;
                [self.navigationController pushViewController:VC animated:YES];
                
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }
    if (model.type==3) {
        
        NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
        vc.designsId = model.relId;
        vc.activityType = 2;
        //        vc.companyPhone = model.companyPhone;
        //        vc.companyLandLine = model.companyLandline;
        vc.companyLogo = model.companyLogo;
        vc.companyName = model.companyName;
        vc.origin = @"2";
        vc.companyId = [NSString stringWithFormat:@"%ld",(long)model.companyId];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (model.type==4) {
        NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
        vc.designsId = model.relId;
        vc.activityType = 3;
        //        vc.companyPhone = model.companyPhone;
        //        vc.companyLandLine = model.companyLandline;
        vc.companyLogo = model.companyLogo;
        vc.companyName = model.companyName;
        vc.origin = @"2";
        vc.companyId = [NSString stringWithFormat:@"%ld",(long)model.companyId];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (model.type==5) {
        
        GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] init];
        vc.fromBack = NO;
        vc.goodsID = model.relId;
        vc.shopID = [NSString stringWithFormat:@"%ld",model.companyId];
        vc.shopid =  [NSString stringWithFormat:@"%ld",model.companyId];
        vc.origin = @"0";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
