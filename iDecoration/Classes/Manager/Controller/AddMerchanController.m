//
//  AddMerchanController.m
//  iDecoration
//
//  Created by sty on 2017/12/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "AddMerchanController.h"
#import "AddMerchanCell.h"
#import "GoodsListModel.h"

@interface AddMerchanController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSInteger _pageNum;
}
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableDictionary *selectDict;
@end

@implementation AddMerchanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加商品";
    _pageNum = 1;
    self.dataArray = [NSMutableArray array];
    self.selectDict = [NSMutableDictionary dictionary];
    [self creatUI];
    
    [self requestAllMerchan];
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(successBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    
    self.view.backgroundColor = White_Color;
    
    [self.view addSubview:self.searchTF];
    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
//    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 88;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddMerchanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddMerchanCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BOOL isSelect = NO;
    NSString *str = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSInteger tag = [[self.selectDict objectForKey:str] integerValue];
    if (!tag) {
        isSelect = NO;
    }
    else{
        isSelect = YES;
    }
    [cell configData:self.dataArray[indexPath.row] isSelect:isSelect];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSInteger tag = [[self.selectDict objectForKey:str] integerValue];
    if (!tag) {
        [self.selectDict setObject:@(1) forKey:str];
    }
    else{
       [self.selectDict setObject:@(0) forKey:str];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
//    GoodsListModel *model = self.dataArray[indexPath.row];
//    [self postDataWith:model.goodsID];
}

#pragma mark - 查询店铺所有商品列表

-(void)requestAllMerchan{
    [self.view endEditing:YES];
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *temStr = self.searchTF.text;
    temStr = [temStr ew_removeSpaces];
    temStr = [temStr ew_removeSpacesAndLineBreaks];
    if (!temStr||temStr.length<=0) {
        temStr = @"";
    }
    NSString *defaultURL = [BASEURL stringByAppendingString:@"construction/serchMerchandisList.do"];
    NSDictionary *paramDic = @{
                               @"companyId": @(self.shopId.integerValue),
                               @"constructionId": @(self.consID),
                               @"page": @(_pageNum),
                               @"serchContent":temStr
                               };
    MJWeakSelf;
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            NSArray *array = [responseObj objectForKey:@"list"];
            [weakSelf.dataArray removeAllObjects];
            
            [weakSelf.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[GoodsListModel class] json:array]];
            if (weakSelf.dataArray.count == 0) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
            }
            else{
                _pageNum++;
            }
            [weakSelf.tableView reloadData];
        }
        
        else if(code==1001){
            [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
        }
        else if(code==1002){
            [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
        }
        else if(code==2000){
            [[PublicTool defaultTool] publicToolsHUDStr:@"服务器异常" controller:self sleep:1.5];
        }
        else {
           [[PublicTool defaultTool] publicToolsHUDStr:@"服务器异常" controller:self sleep:1.5];
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

-(void)refreshData{
    [self.view endEditing:YES];
    _pageNum = 1;
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *temStr = self.searchTF.text;
    temStr = [temStr ew_removeSpaces];
    temStr = [temStr ew_removeSpacesAndLineBreaks];
    if (!temStr||temStr.length<=0) {
        temStr = @"";
    }
    NSString *defaultURL = [BASEURL stringByAppendingString:@"construction/serchMerchandisList.do"];
    NSDictionary *paramDic = @{
                               @"companyId": @(self.shopId.integerValue),
                               @"constructionId": @(self.consID),
                               @"page": @(_pageNum),
                               @"serchContent":temStr
                               };
    MJWeakSelf;
//    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
//        [[UIApplication sharedApplication].keyWindow hiddleHud];
        
        [self.tableView.mj_header endRefreshing];
        
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            NSArray *array = [responseObj objectForKey:@"list"];
            [weakSelf.dataArray removeAllObjects];
            
            [weakSelf.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[GoodsListModel class] json:array]];
            if (weakSelf.dataArray.count == 0) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
            }
            else{
                _pageNum++;
            }
            [weakSelf.tableView reloadData];
        }
        else if(code==1001){
            [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
        }
        else if(code==1002){
            [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
        }
        else if(code==2000){
            [[PublicTool defaultTool] publicToolsHUDStr:@"服务器异常" controller:self sleep:1.5];
        }
        else {
            [[PublicTool defaultTool] publicToolsHUDStr:@"服务器异常" controller:self sleep:1.5];
        }
    } failed:^(NSString *errorMsg) {
//        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [self.tableView.mj_header endRefreshing];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

-(void)loadMoreData{
    [self.view endEditing:YES];
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *temStr = self.searchTF.text;
    temStr = [temStr ew_removeSpaces];
    temStr = [temStr ew_removeSpacesAndLineBreaks];
    if (!temStr||temStr.length<=0) {
        temStr = @"";
    }
    NSString *defaultURL = [BASEURL stringByAppendingString:@"construction/serchMerchandisList.do"];
    NSDictionary *paramDic = @{
                               @"companyId": @(self.shopId.integerValue),
                               @"constructionId": @(self.consID),
                               @"page": @(_pageNum),
                               @"serchContent":temStr
                               };
    MJWeakSelf;
//    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
//        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [self.tableView.mj_footer endRefreshing];
        
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            NSArray *array = [responseObj objectForKey:@"list"];
//            [weakSelf.dataArray removeAllObjects];
            
            [weakSelf.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[GoodsListModel class] json:array]];
            if (array.count == 0) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
            }
            else{
                _pageNum++;
            }
            [weakSelf.tableView reloadData];
        }
        else if(code==1001){
            [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
        }
        else if(code==1002){
            [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
        }
        else if(code==2000){
            [[PublicTool defaultTool] publicToolsHUDStr:@"服务器异常" controller:self sleep:1.5];
        }
        else {
            [[PublicTool defaultTool] publicToolsHUDStr:@"服务器异常" controller:self sleep:1.5];
        }
    } failed:^(NSString *errorMsg) {
//        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [self.tableView.mj_footer endRefreshing];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - 搜索商品

-(void)searchMechan{
    [self.view endEditing:YES];
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *temStr = self.searchTF.text;
    temStr = [temStr ew_removeSpaces];
    temStr = [temStr ew_removeSpacesAndLineBreaks];
    if (!temStr||temStr.length<=0) {
        temStr = @"";
    }
    NSString *defaultURL = [BASEURL stringByAppendingString:@"construction/serchMerchandisList.do"];
    NSDictionary *paramDic = @{
                               @"companyId": @(self.shopId.integerValue),
                               @"constructionId": @(self.consID),
                               @"page": @(1),
                               @"serchContent":temStr
                               };
    MJWeakSelf;
        [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
                [[UIApplication sharedApplication].keyWindow hiddleHud];
        
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            NSArray *array = [responseObj objectForKey:@"list"];
            [weakSelf.dataArray removeAllObjects];
            
            [weakSelf.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[GoodsListModel class] json:array]];
            if (weakSelf.dataArray.count == 0) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
            }
            else{
                _pageNum++;
            }
            [weakSelf.selectDict removeAllObjects];
            [weakSelf.tableView reloadData];
        }
        else if(code==1001){
            [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
        }
        else if(code==1002){
            [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
        }
        else if(code==2000){
            [[PublicTool defaultTool] publicToolsHUDStr:@"服务器异常" controller:self sleep:1.5];
        }
        else {
            [[PublicTool defaultTool] publicToolsHUDStr:@"服务器异常" controller:self sleep:1.5];
        }
    } failed:^(NSString *errorMsg) {
                [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - 关联商品
-(void)postDataWith:(NSString *)merchandiesIds{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"constructionMerchandies/save.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    
    NSDictionary *paramDic = @{@"constructionId":@(self.consID),
                               @"journalId":@(self.journalId),
                               @"merchandiesIds":merchandiesIds,
                               @"agencysId":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AddMerchanSucess" object:nil];
                [[PublicTool defaultTool] publicToolsHUDStr:@"添加成功" controller:self sleep:1.5];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
                
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"服务器异常" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"添加失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - action

-(void)successBtnClick{
    NSArray *keyArray = [self.selectDict allKeys];
    if (keyArray.count<=0||self.dataArray.count<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请选择商品" controller:self sleep:1.5];
        return;
    }
    
    NSMutableArray *selectArray = [NSMutableArray array];
    for (int i = 0; i<self.dataArray.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        NSInteger tag = [[self.selectDict objectForKey:str] integerValue];
        if (tag) {
            [selectArray addObject:@(i)];
        }
    }
    if (selectArray.count<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请选择商品" controller:self sleep:1.5];
    }
    else{
        NSString *merchandiesIds;
        if (selectArray.count==1) {
            NSInteger tag = [selectArray[0] integerValue];
            GoodsListModel *model = self.dataArray[tag];
            merchandiesIds = [NSString stringWithFormat:@"%ld",(long)model.merchandiesId];
        }
        else{
            for (int i = 0; i<selectArray.count; i++) {
                NSInteger tag = [selectArray[i] integerValue];
                GoodsListModel *model = self.dataArray[tag];
                if (i==0) {
                    merchandiesIds = [NSString stringWithFormat:@"%ld",(long)model.merchandiesId];
                }
                else{
                    NSString *temStr = [NSString stringWithFormat:@"%ld",(long)model.merchandiesId];
                    merchandiesIds = [merchandiesIds stringByAppendingString:[NSString stringWithFormat:@",%@",temStr]];
                }
            }
        }
        if (merchandiesIds == nil) {
            return;
        }
        [self postDataWith:merchandiesIds];
    }
}

-(void)searchClick{
    [self searchMechan];
}

-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(10, self.navigationController.navigationBar.bottom+6, kSCREEN_WIDTH-20, 36)];
//        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 64+6, kSCREEN_WIDTH-20, 36)];
        _searchTF.delegate = self;
        _searchTF.backgroundColor = White_Color;
        _searchTF.layer.borderColor = Bottom_Color.CGColor;
        _searchTF.layer.cornerRadius = 5;
        _searchTF.layer.borderWidth = 1;
        _searchTF.font = [UIFont systemFontOfSize:14];
        //    self.searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.placeholder = @"请输入商品名称";
        
    }
    return _searchTF;
}

-(UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(kSCREEN_WIDTH-30-10-10, self.searchTF.top+(6), 24, 24);
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.searchTF.bottom+10,kSCREEN_WIDTH,kSCREEN_HEIGHT-self.searchTF.bottom-10) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        [_tableView registerNib:[UINib nibWithNibName:@"AddMerchanCell" bundle:nil] forCellReuseIdentifier:@"AddMerchanCell"];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
