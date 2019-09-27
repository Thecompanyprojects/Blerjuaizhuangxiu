//
//  LocalsearchVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/25.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "LocalsearchVC.h"
#import "localsearchCell.h"
#import "localsearchModel.h"
#import "CompanyDetailViewController.h"
#import "GoodsDetailViewController.h"
#import "NewsActivityShowController.h"
#import "ConstructionDiaryTwoController.h"
#import "BLEJBudgetGuideController.h"

@interface LocalsearchVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;


@end

static NSString *searchidentfid = @"searchidentfid";

@implementation LocalsearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];

    self.dataSource = [NSMutableArray array];
    [self.searchBar becomeFirstResponder];
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUI
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(80, 0, 50, 44)];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.delegate = self;
    self.searchBar.userInteractionEnabled = YES;
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.tintColor = kDisabledColor;
    self.navigationItem.titleView = self.searchBar;
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
    return self.dataSource.count?:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    localsearchCell *cell = [tableView dequeueReusableCellWithIdentifier:searchidentfid];
    cell = [[localsearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchidentfid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setdata:self.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:kSCREEN_WIDTH tableView:self.table];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     type = 0 公司
     type = 1 商品
     type = 2 活动
     type = 3 工地
     type = 4 美文
     type = 5 计算器
     */
    localsearchModel *model = self.dataSource[indexPath.row];
    switch (model.type) {
        case 0:
        {
            CompanyDetailViewController *company = [CompanyDetailViewController new];
            company.companyName = model.cname;
            company.companyID = model.companyId;
            [self.navigationController pushViewController:company animated:YES];
        }
            break;
        case 1:
        {
            GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] init];
            vc.fromBack = NO;
            vc.goodsID = model.cid;
            vc.goodsID = model.cid;
            vc.shopID = model.companyId;
            vc.shopid = model.companyId;
            //vc.companyType = model.companyType;
            vc.origin = @"1";
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 2:
        {
            NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
            vc.designsId = model.cid;
            vc.activityType = 3;
            vc.origin = @"1";
            //        vc.companyPhone = model.companyPhone;
            //        vc.companyLandLine = model.companyLandline;
            vc.companyLogo = model.companyIntroduction;
            vc.companyName = model.cname;
            vc.companyId = [NSString stringWithFormat:@"%@",model.companyId];
            [self.navigationController pushViewController:vc animated:YES];
        }
   

            break;
        case 3:
        {
            ConstructionDiaryTwoController *constructionVC = [[ConstructionDiaryTwoController alloc] init];
            constructionVC.consID = model.cid;
            [self.navigationController pushViewController:constructionVC animated:YES];

        }
            break;
        case 4:
        {
            NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
            vc.designsId = model.cid;
            vc.activityType = 2;
            vc.origin = @"1";
            //        vc.companyPhone = model.companyPhone;
            //        vc.companyLandLine = model.companyLandline;
            vc.companyLogo = model.companyIntroduction;
            vc.companyName = model.cname;
            vc.companyId = [NSString stringWithFormat:@"%@",model.companyId];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 5:
        {
            BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
            VC.companyID = [NSString stringWithFormat:@"%@",model.companyId];
            VC.isConVip = @"1";
            VC.origin = @"1";
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *content = searchBar.text?:@"";
    NSString *url = [BASEURL stringByAppendingString:GET_SEARCHLOCAL];
    [self.dataSource removeAllObjects];
    NSDictionary *para = @{@"cityId":self.cityId,@"countyId":self.countyId,@"content":content};
    
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[localsearchModel class] json:responseObj[@"data"][@"list"]]];
            [self.dataSource addObjectsFromArray:data];
            [self.table reloadData];
        }

    } failed:^(NSString *errorMsg) {
        
    }];
}


@end
