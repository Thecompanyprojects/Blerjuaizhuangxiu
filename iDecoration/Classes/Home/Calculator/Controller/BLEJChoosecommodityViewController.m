//
//  BLEJChoosecommodityViewController.m
//  iDecoration
//
//  Created by john wall on 2018/8/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "BLEJChoosecommodityViewController.h"
#import "GoodsListModel.h"
#import "BLEJBrickChooseCommodityCell.h"
@interface BLEJChoosecommodityViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic,strong)NSMutableDictionary *companyDic;;
@property(nonatomic,strong)NSMutableArray *goodListArray;
@property(nonatomic,strong)NSMutableArray *arrName;
@property(nonatomic,strong)NSMutableArray *arrSearchItems;
@property(nonatomic,strong)NSMutableArray *arrSearchSelectRefrsh;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)  NSInteger  goodID;
@property(nonatomic,strong)  NSString*  url;
@property(nonatomic,strong)  NSString*  name;
@property(nonatomic,strong)  NSString*  price;
@end

@implementation BLEJChoosecommodityViewController{
    BOOL  isRefrshArray;
    BOOL  FirstEnter;
    NSIndexPath   *lastIndexPath;
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
   
    FirstEnter=YES;
    isRefrshArray=NO;
    self.arrSearchItems=[NSMutableArray array];
    
    self.goodListArray=[NSMutableArray array];
    
    self.arrSearchSelectRefrsh=[NSMutableArray array];
    [ self.arrName addObjectsFromArray:@[@"标准规格的地板",@"地板长度",@"地板宽度",@"单价",@"选择商品"]];

    
    [self setNavi];
    [self requestData];
}
-(void)setUI{
    self.tableView=[[UITableView alloc]initWithFrame:  CGRectMake(0, 50, BLEJWidth, BLEJHeight-self.navigationController.navigationBar.bottom) style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=[UIColor redColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BLEJBrickChooseCommodityCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BLEJBrickChooseCommodityCell class] )];
}

-(void)setNavi{
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"选择商品";
    self.view.backgroundColor = kBackgroundColor;

    UIButton *moreBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    moreBtn.frame = CGRectMake(0, 0, 44, 44);
    [moreBtn setTitle:@"完成" forState:UIControlStateNormal];
   
    
    [moreBtn addTarget:self action:@selector(finishedClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    
    
    UISearchBar * bar = [[UISearchBar alloc]initWithFrame:CGRectMake(20, 5, BLEJWidth-40, 40)];
  
    bar.barStyle=UIBarStyleDefault;
    bar.searchBarStyle=UISearchBarStyleMinimal;
    bar.placeholder=@"请输入商品名字搜索";
    bar.autocapitalizationType=UITextAutocorrectionTypeDefault;
  //  bar.showsSearchResultsButton =YES;
  //  bar.showsCancelButton=YES;
    bar.delegate=self;
    [self.view addSubview:bar];
    
    
    
}
-(void)finishedClicked{
    
    if (self.blockchoose) {
        self.blockchoose(self.goodID,self.url,self.name,self.price);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView           {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (isRefrshArray==YES) {
        return self.arrSearchSelectRefrsh.count;
    }
    return self.goodListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *   cellID=NSStringFromClass([BLEJBrickChooseCommodityCell class]);
    BLEJBrickChooseCommodityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.imageIcon.hidden=NO;
    if (isRefrshArray==YES) {
        cell.goodModel=self.arrSearchSelectRefrsh[indexPath.row];
    }else{
        cell.goodModel =self.goodListArray[indexPath.row];
    }
    
   
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
  
        BLEJBrickChooseCommodityCell *cell = [tableView cellForRowAtIndexPath:indexPath];

      //  cell.ShowSelectIcon.selected  = NO;
    
    [cell.imageIcon setImage: [UIImage imageNamed:@""]];

    

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

   NSInteger newRow = [indexPath row];
   NSInteger oldRow = [lastIndexPath row];
    if (newRow ==0) {
        lastIndexPath =[NSIndexPath indexPathForRow:200 inSection:0];
        oldRow =[lastIndexPath row];
    }
   
    if (newRow != oldRow)
    {
       
       BLEJBrickChooseCommodityCell *cell = [tableView cellForRowAtIndexPath:
                                    indexPath];
   
        if (isRefrshArray) {
            cell.goodModel=self.arrSearchSelectRefrsh[indexPath.row];
        }
        cell.goodModel=self.goodListArray[indexPath.row];
        self.goodID =cell.goodModel.goodsID ;
        self.url =cell.goodModel.display;
        self.name =cell.goodModel.name;
        self.price =cell.goodModel.price;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_checkBlue" ofType:@"png"];//checkBluecommodity
        
        NSData *gifData = [NSData dataWithContentsOfFile:path];
          cell.imageIcon.contentMode =UIViewContentModeScaleToFill;
        [cell.imageIcon setImage:[UIImage imageWithData:gifData] ];

      
       
        BLEJBrickChooseCommodityCell *cell2 = [tableView cellForRowAtIndexPath:
                                    lastIndexPath];
        [cell2.imageIcon setImage: [UIImage imageNamed:@""]];
      
         lastIndexPath = indexPath;
    }
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];

   
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

#pragma mark uisearchbardelegate



- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    return YES;
}

//将要开始编辑时的回调，返回为NO，则不能编辑

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}

//已经开始编辑时的回调

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    return YES;
}

//将要结束编辑时的回调

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
   
}//已经结束编辑的回调

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    [self.arrSearchSelectRefrsh removeAllObjects];
    for ( GoodsListModel *model in self.goodListArray) {
        
        if ([model.name containsString:searchBar.text]) {
            
            [self.arrSearchSelectRefrsh addObject:model];
        }
        
        
    }
    
    
    isRefrshArray=YES;
    
    [self.tableView reloadData];
   
    if ([searchBar.text isEqualToString:@""]) {
        [searchBar resignFirstResponder];
        isRefrshArray =NO;
        [self.tableView reloadData];
    }
    
    
    
}  //编辑文字改变的回调

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}//编辑文字改变前的回调，返回NO则不能加入新的编辑文字


////搜索按钮点击的回调
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    [searchBar resignFirstResponder];
//
//    [self.arrSearchSelectRefrsh removeAllObjects];
//    for ( goodsModel*model in self.goodListArray) {
//
//            if ([model.name containsString:searchBar.text]) {
//
//                [self.arrSearchSelectRefrsh addObject:model];
//            }
//
//
//    }
//
//
//    isRefrshArray=YES;
//
//    [self.tableView reloadData];
//}

//取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:NO animated:NO];    // 取消按钮回收
     [searchBar resignFirstResponder];
    isRefrshArray =NO;
    [self.tableView reloadData];
   
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    
}//搜索结果按钮点击的回调

#pragma mark  获取数据
- (void)requestData {
    
//    NSString *requestString = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"company/yellowInit/%@.do", self.companyID]];
    UserInfoModel *model = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *agencyId = [NSString stringWithFormat:@"%ld", (long)model.agencyId];

   
  
    NSString *defaultURL = [BASEURL stringByAppendingString:@"merchandies/getMerchandiesList.do"];
    NSDictionary *paramDic = @{
                               @"merchantId": @(self.companyID.integerValue),
                               @"agencysId": agencyId,
                               @"type": @(0),
                               @"sign": @(0)//0是综合，1排序2 热度
                               };
    MJWeakSelf;
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
   
            
           
                NSArray *array = [responseObj objectForKey:@"list"];
                [weakSelf.goodListArray removeAllObjects];
                
                [weakSelf.goodListArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[GoodsListModel class] json:array]];
            
               
                [weakSelf.tableView reloadData];
            } else {
               
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"商品数据加载失败"];
            }
           
            [self.tableView reloadData];
        }
    failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
    }];
        
     

}


@end
