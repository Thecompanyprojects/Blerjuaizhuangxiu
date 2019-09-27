//
//  localVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/21.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localVC.h"
#import "WMSearchBar.h"
#import "ZCHRightImageBtn.h"
#import "ZCHCityModel.h"
#import "ZCHNewLocationController.h"
#import "localheaderView.h"
#import <ICPagingManager/ICPagingManager.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocalbannerModel.h"
#import "localcompanyPhone.h"
#import "rankingModel.h"
#import "CompanyDetailViewController.h"
#import "activityzoneVC.h"
#import "LocalorderlistVC.h"
#import "LocalofferVC.h"
#import "localCell0.h"
#import "localcompanyVC.h"
#import "localCell1.h"
#import "localCell2.h"
#import "localCell3.h"
#import "localcaseVC.h"
#import "localconstructionsModel.h"
#import "localimgModel.h"
#import "localdesignModel.h"
#import "localgoodModel.h"
#import "localexecellentModel.h"
#import "ConstructionDiaryTwoController.h"
#import "MainMaterialDiaryController.h"
#import "senceWebViewController.h"
#import "NewDesignImageWebController.h"
#import "GoodsDetailViewController.h"
#import "NewsActivityShowController.h"
#import "LocalnotesVC.h"
#import "localexeVC.h"
#import "localbroadcastVC.h"
#import "localgoodsVC.h"
#import "casedesignVC.h"
#import "panoramicvrVC.h"
#import "CLNetworking.h"
#import "LocalsearchVC.h"
#import "AddressBookSearchListViewController.h"
#import "GeniusSquareViewController.h"
#import "GeniusSquareLabelModel.h"
#import "localcommunityVC.h"
#import "personalitytestVC.h"
#import "GeniusSquareListViewController.h"

ZCHCityModel *cityModel;
ZCHCityModel *countyModel;

@interface localVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,seemoreTabVdelegate,myconstructionTabVdelegate,mydesignTabVdelegate,mygoodsTabVdelegate,myexecellentTabVdelegate>
{
    UISearchBar *_searchBar; //search
}

@property (nonatomic,strong) ZCHRightImageBtn *locationBtn;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) localheaderView *headerView;
@property (strong,nonatomic) CLLocationManager* locationManager;
@property (nonatomic,strong) NSMutableArray *bannerArray;
@property (nonatomic,strong) NSMutableArray *phoneArray;
@property (nonatomic,strong) NSMutableArray *listArray0;
@property (nonatomic,strong) NSMutableArray *listArray1;
@property (nonatomic,strong) NSMutableArray *listArray2;
@property (nonatomic,strong) NSMutableArray *constructionsArray;
@property (nonatomic,strong) NSMutableArray *imgArray;
@property (nonatomic,strong) NSMutableArray *designArray;
@property (nonatomic,strong) NSMutableArray *goodsArray;
@property (nonatomic,strong) NSMutableArray *execellentArray;
@property (nonatomic,copy) NSString *today;
@end

static NSString *localidentfid0 = @"localidentfid0";
static NSString *localidentfid1 = @"localidentfid1";
static NSString *localidentfid2 = @"localidentfid2";
static NSString *localidentfid3 = @"localidentfid3";


@implementation localVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self startLocation];
    [self whetherHistoryCityExist];
    [self.view addSubview:self.table];
    self.table.tableHeaderView = self.headerView;
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.table.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUI
{
    self.locationBtn = [[ZCHRightImageBtn alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [self.locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.locationBtn.myFont = AdaptedFontSize(14);
    self.locationBtn.titleLabel.text = @"定位中...";
    [self.locationBtn addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    [self.locationBtn setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:self.locationBtn];
    self.navigationItem.leftBarButtonItem = barItem;
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion floatValue] >= 11.0) {
        
        self.definesPresentationContext = YES;
        
        WMSearchBar *searchBar = [[WMSearchBar alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH - 2 * 44 - 2 * 15, 44)];
        searchBar.delegate = self;
        searchBar.placeholder = @"搜索商家品类或店铺名";
        searchBar.backgroundImage = [UIImage new];
        searchBar.backgroundColor = [UIColor clearColor];
        searchBar.userInteractionEnabled = YES;
        searchBar.tintColor = kDisabledColor;
        
        CGFloat height = searchBar.bounds.size.height;
        CGFloat top = (height - 30.0) / 2.0;
        CGFloat bottom = top;
        searchBar.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
        
        UIView *wrapView = [[UIView alloc] initWithFrame:searchBar.frame];
        [wrapView addSubview:searchBar];
        self.navigationItem.titleView = wrapView;
        _searchBar = searchBar;
    } else {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(80, 0, 50, 44)];
        _searchBar.placeholder = @"搜索商家品类或店铺名";
        _searchBar.delegate = self;
        _searchBar.userInteractionEnabled = YES;
        _searchBar.backgroundImage = [UIImage new];
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.tintColor = kDisabledColor;
        self.navigationItem.titleView = _searchBar;
    }
    _searchBar.delegate = self;
}

-(void)whetherHistoryCityExist{

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"HistoryCity"]) {
        //   取
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"HistoryCity"];
        NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (arr.count > 0) {

            //_firstStatus = 1;
            if ([[arr[0] objectForKey:@"type"] isEqualToString:@"1"]) {
                cityModel = [arr[0] objectForKey:@"cityModel"];
            } else {
                cityModel = [arr[0] objectForKey:@"cityModel"];
                countyModel = [arr[0] objectForKey:@"model"];
            }
            [self.locationBtn setTitle:countyModel ? countyModel.name : cityModel.name forState:UIControlStateNormal];

        }
    }else{

    }
}

-(void)loadNewData
{
    NSString *cityId = cityModel.cityId?:@"0";
    NSString *countyId = countyModel ? countyModel.cityId : @"0";
    NSString *url = [BASEURL stringByAppendingString:Tongcheng_getdat];
    
    NSString *lng = @"";
    NSString *lat = @"";
    
    lng = [[NSUserDefaults standardUserDefaults] objectForKey:Local_dingweijindu]?:@"0";
    lat = [[NSUserDefaults standardUserDefaults] objectForKey:Local_dingweiweidu]?:@"0";
    NSString *page = @"1";
    NSString *pageSize = @"30";
    NSString *content = @"";
    NSString *type = @"-1";
    NSString *agencyId = @"";
    NSInteger strint = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    NSString *str = [NSString stringWithFormat:@"%ld",(long)strint];
    if ([str isEqualToString:@"0"]) {
        agencyId = @"0";
    }
    else
    {
        agencyId = str;
    }
    NSDictionary *para = @{@"lng":lng,@"lat":lat,@"cityId":cityId,@"countyId":countyId,@"page":page,@"pageSize":pageSize,@"content":content,@"type":type,@"agencyId":agencyId};
    
    [self.bannerArray removeAllObjects];
    [self.phoneArray removeAllObjects];
    [self.constructionsArray removeAllObjects];
    [self.imgArray removeAllObjects];
    [self.designArray removeAllObjects];
    [self.goodsArray removeAllObjects];
    [self.execellentArray removeAllObjects];
    
    [CLNetworkingManager getNetworkRequestWithUrlString:url parameters:para isCache:YES succeed:^(id data) {
        if ([[data objectForKey:@"code"] intValue]==1000) {
            self.bannerArray  = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[LocalbannerModel class] json:data[@"data"][@"banners"]];
            [self.headerView setbanner:self.bannerArray];
            self.today =data[@"data"][@"today"];
            [self.headerView.bobaomoreBtn setTitle:[NSString stringWithFormat:@"%@%@%@",@"今日\n",_today,@"\n家入驻"] forState:normal];
            self.phoneArray  = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[localcompanyPhone class] json:data[@"data"][@"companyPhone"]];
            self.constructionsArray = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[localconstructionsModel class] json:data[@"data"][@"constructions"]];
            self.imgArray = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[localimgModel class] json:data[@"data"][@"img"]];
            self.designArray = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[localdesignModel class] json:data[@"data"][@"design"]];
            self.goodsArray = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[localgoodModel class] json:data[@"data"][@"goods"]];
            self.execellentArray = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[localexecellentModel class] json:data[@"data"][@"execellent"]];;
            [self.headerView setdatafrom:self.phoneArray];
            
            
            [self.listArray1 removeAllObjects];
            [self.listArray0 removeAllObjects];
            [self.listArray2 removeAllObjects];
            
            NSMutableArray *data1 = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[rankingModel class] json:data[@"data"][@"rngList"]]];
            [self.listArray0 addObjectsFromArray:data1];
            
            NSMutableArray *data2 = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[rankingModel class] json:data[@"data"][@"rngList1"]]];
            [self.listArray1 addObjectsFromArray:data2];
            
            NSMutableArray *data3 = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[rankingModel class] json:data[@"data"][@"rngList2"]]];
            [self.listArray2 addObjectsFromArray:data3];
            
            
            [self.headerView setdatarr0:self.listArray0 andarr1:self.listArray1 andarr2:self.listArray2];
             [self.table.mj_header endRefreshing];
        }
    } fail:^(NSError *error) {
        [self.table.mj_header endRefreshing];
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
       
    }
    return _table;
}

-(localheaderView *)headerView
{
    if(!_headerView)
    {
        _headerView = [[localheaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 920);
        _headerView.backgroundColor = White_Color;
        _headerView.delegate = self;
        _headerView.userInteractionEnabled = YES;
        [_headerView.btn0 addTarget:self action:@selector(headbtn0click) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.btn1 addTarget:self action:@selector(headbtn1click) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.btn2 addTarget:self action:@selector(headbtn2click) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.btn3 addTarget:self action:@selector(headbtn3click) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.rankingmoreBtn addTarget:self action:@selector(rankingmorebtnclick) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tapGesturRecognizer0=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction0)];
        [_headerView.chooseView0 addGestureRecognizer:tapGesturRecognizer0];
        
        UITapGestureRecognizer *tapGesturRecognizer1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction1)];
        [_headerView.chooseView1 addGestureRecognizer:tapGesturRecognizer1];
        UITapGestureRecognizer *tapGesturRecognize2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction2)];
        [_headerView.chooseView2 addGestureRecognizer:tapGesturRecognize2];
        [_headerView.bobaomoreBtn addTarget:self action:@selector(bobaomorebtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

-(NSMutableArray *)bannerArray
{
    if(!_bannerArray)
    {
        _bannerArray = [NSMutableArray array];
        
    }
    return _bannerArray;
}

-(NSMutableArray *)phoneArray
{
    if(!_phoneArray)
    {
        _phoneArray = [NSMutableArray array];
        
    }
    return _phoneArray;
}

-(NSMutableArray *)listArray0
{
    if(!_listArray0)
    {
        _listArray0 = [NSMutableArray array];
        
    }
    return _listArray0;
}

-(NSMutableArray *)listArray1
{
    if(!_listArray1)
    {
        _listArray1 = [NSMutableArray array];
        
    }
    return _listArray1;
}

-(NSMutableArray *)listArray2
{
    if(!_listArray2)
    {
        _listArray2 = [NSMutableArray array];
        
    }
    return _listArray2;
}

-(NSMutableArray *)constructionsArray
{
    if(!_constructionsArray)
    {
        _constructionsArray = [NSMutableArray array];
        
    }
    return _constructionsArray;
}

-(NSMutableArray *)imgArray
{
    if(!_imgArray)
    {
        _imgArray = [NSMutableArray array];
        
    }
    return _imgArray;
}

-(NSMutableArray *)designArray
{
    if(!_designArray)
    {
        _designArray = [NSMutableArray array];
        
    }
    return _designArray;
}

-(NSMutableArray *)goodsArray
{
    if(!_goodsArray)
    {
        _goodsArray = [NSMutableArray array];
        
    }
    return _goodsArray;
}

-(NSMutableArray *)execellentArray
{
    if(!_execellentArray)
    {
        _execellentArray = [NSMutableArray array];
        
    }
    return _execellentArray;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        localCell0 *cell = [tableView dequeueReusableCellWithIdentifier:localidentfid0];
        cell = [[localCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:localidentfid0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.moreBtn addTarget:self action:@selector(localcaseclick) forControlEvents:UIControlEventTouchUpInside];
        [cell setdata:self.constructionsArray];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section==1) {
        localCell1 *cell = [tableView dequeueReusableCellWithIdentifier:localidentfid1];
        cell = [[localCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:localidentfid1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setdata:self.imgArray and:self.designArray];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section==2) {
        localCell2 *cell = [tableView dequeueReusableCellWithIdentifier:localidentfid2];
        cell = [[localCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:localidentfid2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setdata:self.goodsArray];
        cell.delegate = self;
        [cell.moreBtn addTarget:self action:@selector(pushgoodsclick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if (indexPath.section==3) {
        localCell3 *cell = [tableView dequeueReusableCellWithIdentifier:localidentfid3];
        cell = [[localCell3 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:localidentfid3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setdata:self.execellentArray];
        cell.delegate = self;
        [cell.moreBtn addTarget:self action:@selector(pushnotesclick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0||indexPath.section==1) {
        return 400;
    }
    else
    {
        return 360;
    }
    return 400;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 8);
    view.backgroundColor = kBackgroundColor;
    return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
#pragma mark - 跳转界面

-(void)tapAction0
{
    LocalofferVC *vc = [LocalofferVC new];
    vc.cityId = cityModel.cityId?:@"0";
    vc.countyId = countyModel ? countyModel.cityId : @"0";
    vc.lng = [[NSUserDefaults standardUserDefaults] objectForKey:Local_dingweijindu]?:@"0";
    vc.lat = [[NSUserDefaults standardUserDefaults] objectForKey:Local_dingweiweidu]?:@"0";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tapAction1
{
    localcommunityVC *vc = [localcommunityVC new];
    vc.cityId = cityModel.cityId?:@"0";
    vc.countyId = countyModel ? countyModel.cityId : @"0";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tapAction2
{
    [[PublicTool defaultTool] publicToolsHUDStr:@"敬请期待" controller:self sleep:1.5];
//    personalitytestVC *vc = [personalitytestVC new];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)headbtn0click
{

     self.tabBarController.selectedIndex = 0;
}

-(void)headbtn1click
{
    activityzoneVC *vc = [activityzoneVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)headbtn2click
{
    AddressBookSearchListViewController *controller = [[AddressBookSearchListViewController alloc] initWithNibName:@"EliteListViewController" bundle:nil];
    controller.listType = SearchListTypeElite;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)headbtn3click
{
    [self Network];
    
}

/**
 人才广场更多标签
 */
- (void)Network {
    NSString *URL = @"cblejnamelist/list.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [NetWorkRequest postJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        if ([result[@"code"] isEqualToString:@"1000"]) {
            
            NSMutableArray *dataarr = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[GeniusSquareLabelModel class] json:result[@"data"][@"list"]].mutableCopy;
            [[CacheData sharedInstance] setObject:dataarr forKey:KGeniusSquareLabelList];
          GeniusSquareListViewController *vc = [[GeniusSquareListViewController alloc] initWithNibName:@"GeniusSquareViewController" bundle:nil];
            vc.arrayData = dataarr;
            vc.cityId = cityModel.cityId?:@"0";
            vc.countyId = countyModel ? countyModel.cityId : @"0";
            [self.navigationController pushViewController:vc animated:YES];
        }
    } fail:^(NSError *error) {
        
    }];
}


/**
 排行榜查看更多
 */

-(void)rankingmorebtnclick
{
    LocalorderlistVC *vc = [LocalorderlistVC new];
    vc.cityId = cityModel.cityId?:@"0";
    vc.countryId = countyModel ? countyModel.cityId : @"0";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)myTabVClick0:(NSInteger )Integer
{
    rankingModel *model = [rankingModel new];
    if (Integer==0) {
        if (self.listArray0.count!=0) {
            model = [self.listArray0 firstObject];
        }
    }
    if (Integer==1) {
        if (self.listArray1.count!=0) {
            model = [self.listArray1 firstObject];
        }
    }
    if (Integer==2) {
        if (self.listArray2.count!=0) {
            model = [self.listArray2 firstObject];
        }
    }
    
    CompanyDetailViewController *company = [CompanyDetailViewController new];
    company.companyName = model.companyName;
    company.companyID = [NSString stringWithFormat:@"%ld",model.companyId];
    [self.navigationController pushViewController:company animated:YES];
}

-(void)myTabVClick1:(NSInteger )Integer
{
    rankingModel *model = [rankingModel new];
    if (Integer==0) {
        if (self.listArray0.count>1) {
            model = [self.listArray0 objectAtIndex:1];
        }
        
    }
    if (Integer==1) {
        if (self.listArray1.count>1) {
            model = [self.listArray1 objectAtIndex:1];
        }
    }
    if (Integer==2) {
        if (self.listArray2.count>1) {
            model = [self.listArray2 objectAtIndex:1];
        }
    }
    CompanyDetailViewController *company = [CompanyDetailViewController new];
    company.companyName = model.companyName;
    company.companyID = [NSString stringWithFormat:@"%ld",model.companyId];
    [self.navigationController pushViewController:company animated:YES];
}

-(void)myTabVClick2:(NSInteger )Integer
{
    rankingModel *model = [rankingModel new];
    
    if (Integer==0) {
        if (self.listArray0.count!=0) {
            model = [self.listArray0 objectAtIndex:2];
            
        }
    }
    if (Integer==1) {
        if (self.listArray1.count!=0) {
            model = [self.listArray1 objectAtIndex:2];
        }
        
    }
    if (Integer==2) {
        if (self.listArray2.count!=0) {
            model = [self.listArray2 objectAtIndex:2];
        }
    }
    CompanyDetailViewController *company = [CompanyDetailViewController new];
    if (!IsNilString(model.companyName)) {
        company.companyName = model.companyName;
        company.companyID = [NSString stringWithFormat:@"%ld",model.companyId];
        [self.navigationController pushViewController:company animated:YES];
    }
}

-(void)localcaseclick
{
    localcaseVC *vc = [localcaseVC new];
    vc.cityId = cityModel.cityId?:@"0";
    vc.countyId = countyModel ? countyModel.cityId : @"0";
    vc.province = cityModel.provinceId?:@"0";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)morebtnchoose:(NSString *)type
{
    if ([type isEqualToString:@"1"]) {
        casedesignVC *vc = [casedesignVC new];
        vc.cityId = cityModel.cityId?:@"0";
        vc.countyId = countyModel ? countyModel.cityId : @"0";
        NSInteger strint = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
        NSString *str = [NSString stringWithFormat:@"%ld",(long)strint];
        if ([str isEqualToString:@"0"]) {
            vc.agencyId = @"0";
        }
        else
        {
            vc.agencyId = str;
        }
        [self.navigationController pushViewController:vc animated:YES];

    }
    if ([type isEqualToString:@"0"]) {
        panoramicvrVC *vc = [panoramicvrVC new];
        vc.cityId = cityModel.cityId?:@"0";
        vc.countyId = countyModel ? countyModel.cityId : @"0";
        NSInteger strint = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
        NSString *str = [NSString stringWithFormat:@"%ld",(long)strint];
        if ([str isEqualToString:@"0"]) {
            vc.agencyId = @"0";
        }
        else
        {
            vc.agencyId = str;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}
/**
 跳转装修攻略
 */

-(void)pushnotesclick
{
    localexeVC *exevc = [[localexeVC alloc] init];
    [self.navigationController pushViewController:exevc animated:YES];
}

-(void)pushgoodsclick
{
    localgoodsVC *vc = [localgoodsVC new];
    vc.cityId = cityModel.cityId?:@"0";
    vc.countyId = countyModel ? countyModel.cityId : @"0";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)myconstruction:(localconstructionsModel *)model
{
    if (model.constructionType==0) {
        //施工日志
        ConstructionDiaryTwoController *constructionVC = [[ConstructionDiaryTwoController alloc] init];
        constructionVC.consID = model.constructionId;
        constructionVC.isfromlocal = YES;
        constructionVC.companyType = [NSString stringWithFormat:@"%ld",model.constructionType];
        constructionVC.constructionType = [NSString stringWithFormat:@"%ld",model.constructionType];
        [self.navigationController pushViewController:constructionVC animated:YES];
    }
    else
    {
        //主材日志
        MainMaterialDiaryController *mainDiaryVC = [[MainMaterialDiaryController alloc] init];
        mainDiaryVC.consID = model.constructionId;
        mainDiaryVC.isfromlocal = YES;
        mainDiaryVC.companyType = [NSString stringWithFormat:@"%ld",model.constructionType];
        mainDiaryVC.constructionType = [NSString stringWithFormat:@"%ld",model.constructionType];
        [self.navigationController pushViewController:mainDiaryVC animated:YES];
    }
}

// 精品设计

-(void)mydesign:(localdesignModel *)model
{
    NewDesignImageWebController *vc = [[NewDesignImageWebController alloc]init];
    vc.fromIndex = 1;
    vc.companyId = [NSString stringWithFormat:@"%ld",(long)model.companyId];
    vc.companyLogo = model.companyLogo;
    vc.companyName = model.companyName;
    vc.consID = [model.constructionId intValue];
    vc.isfromlocal = YES;
    vc.companyPhone = model.companyPhone;
    vc.companyLandline = model.companyLandline;
    vc.constructionType = model.companyType;
    vc.companyType = model.companyType;
    [self.navigationController pushViewController:vc animated:YES];
}

//3D VR
-(void)myimg:(localimgModel *)model
{
    senceWebViewController *vc = [[senceWebViewController alloc]init];
    vc.isFrom = YES;
    vc.webUrl = model.picHref;
    vc.companyId =model.companyId;
    vc.companyName = model.companyName;
    vc.companyLogo = model.companyLogo;
    vc.pennantnumber =model.pennantNumber;
    vc.flowerNumber =model.pennantNumber;
    vc.isfromlocal = YES;
    vc.companyPhone = model.companyPhone;
    vc.companyLandline = model.companyLandline;
    vc.companyType = model.companyType;
    vc.constructionType = model.companyType;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)mygoods:(localgoodModel *)model
{
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] init];
    vc.fromBack = NO;
 
    vc.goodsID = [model.Newid intValue];

    vc.origin = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)myexecellent:(localexecellentModel *)model
{
    NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
    vc.designsId = [model.designId intValue];
    vc.activityType = 2;
    vc.origin = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)bobaomorebtnclick
{
    localbroadcastVC *vc = [localbroadcastVC new];
    vc.cityId = cityModel.cityId?:@"0";
    vc.countyId = countyModel ? countyModel.cityId : @"0";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    LocalsearchVC *vc = [LocalsearchVC new];
    NSString *lng = @"";
    NSString *lat = @"";
    lng = [[NSUserDefaults standardUserDefaults] objectForKey:Local_dingweijindu]?:@"0";
    lat = [[NSUserDefaults standardUserDefaults] objectForKey:Local_dingweiweidu]?:@"0";
    vc.lng = lng;
    vc.lat = lat;
    vc.cityId = cityModel.cityId?:@"0";
    vc.countyId = countyModel ? countyModel.cityId : @"0";
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

#pragma mark - 定位城市选择

-(void)selectCity
{
    ZCHNewLocationController *locationVC = [[ZCHNewLocationController alloc] init];
    __weak typeof(self) weakSelf = self;
    
    locationVC.refreshBlock = ^(NSDictionary *modelDic) {
        [weakSelf.locationBtn setTitle:[modelDic objectForKey:@"name"]?:@"" forState:UIControlStateNormal];
        [weakSelf startLocation];
        [self loadNewData];
    };
    [self.navigationController pushViewController:locationVC animated:YES];
}

//开始定位

-(void)startLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    NSString *lng = [NSString stringWithFormat:@"%f",oldCoordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",oldCoordinate.latitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
        
        [[NSUserDefaults standardUserDefaults] setObject:lng forKey:Local_dingweijindu];
        [[NSUserDefaults standardUserDefaults] setObject:lat forKey:Local_dingweiweidu];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (placemarks.count==0) {
            
        }
        else
        {
            for (CLPlacemark *place in placemarks) {
                NSLog(@"name,%@",place.name);                      // 位置名
                NSLog(@"thoroughfare,%@",place.thoroughfare);      // 街道
                NSLog(@"subThoroughfare,%@",place.subThoroughfare);// 子街道
                NSLog(@"locality,%@",place.locality);              // 市
                NSLog(@"subLocality,%@",place.subLocality);        // 区
                NSLog(@"country,%@",place.country);                // 国家
                NSString *cityname = cityModel.name;
                [self.locationBtn setTitle:cityname?:place.locality forState:UIControlStateNormal];
            }
        }
    }];
}

@end
