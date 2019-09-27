//
//  localcommunityVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localcommunityVC.h"
#import "communityCell.h"
#import "communitymanagerVC.h"
#import "localcommunityModel.h"
#import "newaddcommunityVC.h"


@interface localcommunityVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    int page;
}
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UISearchBar *search;
@property (nonatomic,strong) UIView *header;
@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *addBtn;
@end

static NSString *communityidentfid = @"communityidentfid";

@implementation localcommunityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.title = @"小区管理";
    [self.view addSubview:self.table];
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(0, 0, 80, 44);
    [btn setImage:[UIImage imageNamed:@"back1"] forState:normal];
    [btn setTitle:@"小区管理" forState:normal];
    [btn addTarget:self action:@selector(popbtnclick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = barItem;
    self.navigationItem.titleView = self.search;
    self.table.tableFooterView = [UIView new];
    

    if (self.ischange) {
        [self.view addSubview:self.footView];
    }
    page = 1;
    self.content = [NSString new];
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.table.mj_header beginRefreshing];
    
}

-(void)popbtnclick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadNewData
{
    page = 1;
    [self.dataSource removeAllObjects];
    NSString *url = [BASEURL stringByAppendingString:@"cblejCommunity/getCommunityList.do"];
    NSString *pagestr = [NSString stringWithFormat:@"%d",page];
    NSString *pageSize = @"30";

    NSString *lng = [[NSUserDefaults standardUserDefaults] objectForKey:Local_dingweijindu]?:@"0";
    NSString *lat = [[NSUserDefaults standardUserDefaults] objectForKey:Local_dingweiweidu]?:@"0";
    
    NSDictionary *para = @{@"page":pagestr,@"pageSize":pageSize,@"longitude":lng?:@"0",@"longitude":lat?:@"0",@"content":self.content};
    

    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[localcommunityModel class] json:responseObj[@"data"][@"list"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.table.mj_header endRefreshing];
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        [self.table.mj_header endRefreshing];
    }];
}

-(void)loadMoreData
{
    page ++;
    NSString *url = [BASEURL stringByAppendingString:@"cblejCommunity/getCommunityList.do"];
    NSString *pagestr = [NSString stringWithFormat:@"%d",page];
    NSString *pageSize = @"30";
    
    NSString *lng = [[NSUserDefaults standardUserDefaults] objectForKey:Local_dingweijindu]?:@"0";
    NSString *lat = [[NSUserDefaults standardUserDefaults] objectForKey:Local_dingweiweidu]?:@"0";
    
    NSDictionary *para = @{@"page":pagestr,@"pageSize":pageSize,@"longitude":lng?:@"0",@"longitude":lat?:@"0",@"content":self.content};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[localcommunityModel class] json:responseObj[@"data"][@"list"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.table.mj_footer endRefreshing];
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        [self.table.mj_footer endRefreshing];
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

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}


-(UIView *)header
{
    if(!_header)
    {
        _header = [[UIView alloc] init];
        _header.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 40);
//        [_header addSubview:self.search];
//        [_header addSubview:self.submitBtn];
        
    }
    return _header;
}

-(UISearchBar *)search
{
    if(!_search)
    {
        _search = [[UISearchBar alloc] init];
        _search.delegate = self;
        _search.placeholder = @"输入小区名称";
        _search.frame = CGRectMake(10, 10, kSCREEN_WIDTH-60, 28);
        _search.backgroundImage = [UIImage new];
        _search.backgroundColor = [UIColor clearColor];
        UIImage* searchBarBg = [self GetImageWithColor:kBackgroundColor andHeight:32.0f];
        [_search setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
        UITextField *searchField = [_search valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[UIColor whiteColor]];
            searchField.layer.cornerRadius = 10.0f;
            searchField.layer.masksToBounds = YES;
        }
    }
    return _search;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.frame = CGRectMake(self.search.right, 10, 40, 28);
        [_submitBtn setTitleColor:[UIColor hexStringToColor:@"25B764"] forState:normal];
        [_submitBtn setTitle:@"确认" forState:normal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_submitBtn addTarget:self action:@selector(submitbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

-(UIView *)footView
{
    if(!_footView)
    {
        _footView = [[UIView alloc] init];
        _footView.frame = CGRectMake(0, kSCREEN_HEIGHT-44, kSCREEN_WIDTH, 44);
        _footView.backgroundColor = [UIColor hexStringToColor:@"25B764"];
        [_footView addSubview:self.addBtn];
    }
    return _footView;
}

-(UIButton *)addBtn
{
    if(!_addBtn)
    {
        _addBtn = [[UIButton alloc] init];
        _addBtn.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 44);
        [_addBtn setTitle:@"添加小区" forState:normal];
        [_addBtn setImage:[UIImage imageNamed:@"whiteadd"] forState:normal];
        [_addBtn setTitleColor:White_Color forState:normal];
        [_addBtn addTarget:self action:@selector(addbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count?:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    communityCell *cell = [tableView dequeueReusableCellWithIdentifier:communityidentfid];
    cell = [[communityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:communityidentfid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setdata:self.dataSource[indexPath.row]];
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 97;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isfromsite) {
        localcommunityModel *model = self.dataSource[indexPath.row];
        NSString *inputString = model.communityName?:@"";
        __weak typeof(self) weakself = self;
        
        if (weakself.returnValueBlock) {
            //将自己的值传出去，完成传值
            weakself.returnValueBlock(inputString);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        communitymanagerVC *vc = [communitymanagerVC new];
        vc.comModel = self.dataSource[indexPath.row];
        vc.ischange = self.ischange;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.content = searchBar.text;
    [self loadNewData];
    return YES;
}

-(void)submitbtnclick
{
    
}

- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

-(void)addbtnclick
{
    newaddcommunityVC *vc = [newaddcommunityVC new];
    vc.companyId = self.companyId;
    vc.cityId = self.cityId;
    vc.countyId = self.countyId;
    //赋值Block，并将捕获的值赋值给UILabel
    vc.returnValueBlock = ^(NSString *passedValue){
        
        [self loadNewData];
        
    };

    [self.navigationController pushViewController:vc animated:YES];
}

@end
