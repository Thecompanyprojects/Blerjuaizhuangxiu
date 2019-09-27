//
//  dockingchooseVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "dockingchooseVC.h"
#import "dockingchooseCell.h"
#import "dockingModel.h"

@interface dockingchooseVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,myTabVdelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UISearchBar *search;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,copy)  NSString *middleCode;
@property (nonatomic,strong) UIButton *submitbtn;
//@property (nonatomic,strong) UILabel *toplab;
@end

static NSString *dockingchooseidentfid = @"dockingchooseidentfid";


@implementation dockingchooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"指派";
    self.middleCode = @"";
    
    self.submitbtn = [[UIButton alloc] init];
    [self.submitbtn setTitle:@"确认(0/1)" forState:normal];
    [self.submitbtn setTitleColor:[UIColor hexStringToColor:@"FFFFFF"] forState:normal];
    self.submitbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.submitbtn.frame = CGRectMake(0, 0, 44, 44);
    [self.submitbtn addTarget:self action:@selector(addsaveclick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.submitbtn];
    
    [self loaddata];
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    self.table.tableHeaderView = self.headView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loaddata
{
    NSString *url = [BASEURL stringByAppendingString:POST_twomiddelManTeam];
    NSString *agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSString *middleManName = @"";
    
    NSString *newurl = [NSString stringWithFormat:@"%@%@%@%@%@",url,@"?agencyId=",agencyId,@"&middleManName=",middleManName];
    [self.dataSource removeAllObjects];
    [NetManager afGetRequest:newurl parms:nil finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[dockingModel class] json:responseObj[@"data"][@"spreadList"]]];
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
    }
    return _table;
}

-(UIView *)headView
{
    if(!_headView)
    {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 60)];
        _headView.backgroundColor = [UIColor whiteColor];
        [_headView addSubview:self.search];
        //[_headView addSubview:self.toplab];
    }
    return _headView;
}

-(UISearchBar *)search
{
    if(!_search)
    {
        _search = [[UISearchBar alloc] init];
        _search.frame = CGRectMake(30, 15, kSCREEN_WIDTH-60, 30);
        _search.placeholder = @"请输入一级分销员的姓名";
        _search.barTintColor = [UIColor whiteColor];
        _search.delegate = self;
        _search.searchBarStyle = UISearchBarStyleMinimal;
    }
    return _search;
}

#pragma mark - UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    dockingchooseCell *cell = [tableView dequeueReusableCellWithIdentifier:dockingchooseidentfid];
    if (!cell) {
        cell = [[dockingchooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dockingchooseidentfid];
    }
    cell.delegate = self;
    [cell setdata:self.dataSource[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(void)myTabVchooseClick:(UITableViewCell *)cell
{

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    for (int i = 0; i<self.dataSource.count; i++) {
        dockingModel *newmodel = self.dataSource[i];
        if (i!=indexPath.row) {
            newmodel.ischoose = NO;
        }
        else if (i==indexPath.row)
        {
            newmodel.ischoose = YES;
            self.middleCode = newmodel.createCode;
        }
    }
    [self.submitbtn setTitle:@"确认(1/1)" forState:normal];
    [self.table reloadData];
}

-(void)addsaveclick
{

    NSString *url = [BASEURL stringByAppendingString:POST_commitToAdminMessage];
    
    NSDictionary *para = @{@"agencyId":self.useragencyId,@"createCode":self.middleCode};
    
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        NSString *msg = [responseObj objectForKey:@"msg"];
        [[PublicTool defaultTool] publicToolsHUDStr:msg controller:self sleep:1.5];
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
            
//            [[PublicTool defaultTool] publicToolsHUDStr:@"该指派信息已提交后台管理员审核，请耐心等待" controller:self.navigationController sleep:1.5];

            
            UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"该指派信息已提交后台管理员审核，请耐心等待" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [control addAction:action0];
            [control addAction:action1];
            [self presentViewController:control animated:YES completion:^{
                
            }];
            
            NSNotification *notification = [NSNotification notificationWithName:@"change" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];

            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            [[PublicTool defaultTool] publicToolsHUDStr:msg controller:self sleep:1.5];
        }
    } failed:^(NSString *errorMsg) {
        
    }];

}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
   
   
    NSString *middleManName = @"";
    if (searchBar.text.length==0) {
        middleManName = @"";
    }
    else
    {
        middleManName = searchBar.text;
    }
    
    NSString *url = [BASEURL stringByAppendingString:POST_twomiddelManTeam];
    NSString *agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    
    NSString *newurl = [NSString stringWithFormat:@"%@%@%@%@%@",url,@"?agencyId=",agencyId,@"&middleManName=",middleManName];
    [self.dataSource removeAllObjects];
    [NetManager afGetRequest:newurl parms:nil finished:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[dockingModel class] json:responseObj[@"data"][@"spreadList"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.table reloadData];
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

@end
