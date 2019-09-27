//
//  BatchManagerViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/15.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SelectGoodsController.h"
#import "BackGoodsListBottomView.h"
#import "BatchManagerCell.h"
#import "BatchMangerMoveToGroupViewController.h"
#import "GoodsListModel.h"


@interface SelectGoodsController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

// 商品数组
@property (nonatomic, strong) NSMutableArray *dateArray;
// 要删除的数组
@property (nonatomic, strong) NSMutableArray *deleteArray;
@property (nonatomic, strong) NSMutableArray *selectedImageArray;
// 商品类别列表
@property (nonatomic, strong) UITableView *tableView;
// 顶部搜索条
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

static NSString *cellIdentified = @"cellIdentified";
@implementation SelectGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择商品";
    self.view.backgroundColor = kBackgroundColor;
    [self setupUI];
    [self getDataWithSearchText:@""];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(backAction)];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.deleteArray removeAllObjects];
    [self.selectedImageArray removeAllObjects];
}

#pragma mark - NormalMethod
- (void)setupUI {
    [self searchView];
    [self tableView];
}

- (void)backAction {
    if (self.CompletionBlock) {
        self.CompletionBlock([self.selectedImageArray copy]);
    }
    if (self.CompletionBlockWithGoodsModel) {
        self.CompletionBlockWithGoodsModel([self.deleteArray copy]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getDataWithSearchText:(NSString *)text {
    [[UIApplication sharedApplication].keyWindow hudShow];
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultURL = [BASEURL stringByAppendingString:@"merchandies/getMerchandiesList.do"];
    NSDictionary *paramDic = nil;
    if (text.length > 0) {
        paramDic = @{
                     @"merchantId": @(self.shopId.integerValue),
                     @"agencysId": @(userModel.agencyId),
                     @"type": @(0),
                     @"sign": @(0),
                     @"serchName": text
                     };
    } else {
        paramDic = @{
                     @"merchantId": @(self.shopId.integerValue),
                     @"agencysId": @(userModel.agencyId),
                     @"type": @(0),
                     @"sign": @(0)
                     };
    }
    MJWeakSelf;
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            NSArray *array = [responseObj objectForKey:@"list"];
            [weakSelf.dateArray removeAllObjects];
            
            [weakSelf.dateArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[GoodsListModel class] json:array]];
            if (weakSelf.dateArray.count == 0) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"暂无数据"];
            }
            
            [weakSelf.tableView reloadData];
            
        } else {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"商品数据加载失败"];
        }
        
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)deleteGoodsAction {
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSString *defaultURL = [BASEURL stringByAppendingString:@"merchandies/deleteMerchandiesBatch.do"];
    
    NSMutableDictionary *multiDict = [NSMutableDictionary dictionary];
    NSMutableString *paramString = [NSMutableString string];
    [paramString appendString:@"["];
    
    for (int i = 0; i < self.deleteArray.count; i ++) {
        GoodsListModel *model = self.deleteArray[i];
        
        [multiDict setObject:@(model.goodsID) forKey:@"id"];
        [multiDict setObject:model.name forKey:@"name"];
        
        NSString *dictStr = [self dictionaryToJson:multiDict];
        [paramString appendString:dictStr];
        if (i != self.deleteArray.count - 1) {
            [paramString appendString:@","];
        }
        [multiDict removeAllObjects];
    }
    
    [paramString appendString:@"]"];
    
    NSDictionary *paramDic = @{
                               @"list": paramString
                               };
    MJWeakSelf;
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        YSNLog(@"%@", responseObj);
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            [weakSelf.dateArray removeObjectsInArray:self.deleteArray];
            [weakSelf.deleteArray removeAllObjects];
            [weakSelf.tableView reloadData];
        } else {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"操作失败， 请稍后再试"];
            [weakSelf.deleteArray removeAllObjects];
        }
        
        
    } failed:^(NSString *errorMsg) {
        [weakSelf.deleteArray removeAllObjects];
        
    }];
}


- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dateArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BatchManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentified forIndexPath:indexPath];
    cell.model = self.dateArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
     
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.deleteArray addObject:[self.dateArray objectAtIndex:indexPath.row]];
    BatchManagerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.imageV.image) {
        [self.selectedImageArray addObject:cell.imageV.image];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.deleteArray removeObject:[self.dateArray objectAtIndex:indexPath.row]];
    BatchManagerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.imageV.image) {
        [self.selectedImageArray removeObject:cell.imageV.image];
    }
    
}


#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [self getDataWithSearchText:searchBar.text];
}

#pragma mark - lazyMethod
- (UIView *)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, 44)];
        [self.view addSubview:_searchView];
        _searchView.backgroundColor = [UIColor whiteColor];
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(16, 6, kSCREEN_WIDTH - 32, 32)];
        self.searchBar = searchBar;
        //        searchBar.placeholder = @"搜索商家品类或店铺";
        searchBar.delegate = self;
        searchBar.backgroundImage = [UIImage new];
        searchBar.backgroundColor = [UIColor clearColor];
        
        UIImage* searchBarBg = [self GetImageWithColor:kBackgroundColor andHeight:32.0f];
        [searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
        UITextField *searchField = [searchBar valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[UIColor whiteColor]];
            searchField.layer.cornerRadius = 14.0f;
            searchField.layer.masksToBounds = YES;
        }
        
        [_searchView addSubview:searchBar];
    }
    return _searchView;
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

- (NSMutableArray *)dateArray {
    if (_dateArray == nil) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}

- (NSMutableArray *)deleteArray {
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}
- (NSMutableArray *)selectedImageArray {
    if (!_selectedImageArray) {
        _selectedImageArray = [NSMutableArray array];
    }
    return _selectedImageArray;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(self.searchView.mas_bottom).equalTo(2);
            make.bottom.equalTo(0);
        }];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.editing = YES;
        [_tableView registerNib:[UINib nibWithNibName:@"BatchManagerCell" bundle:nil] forCellReuseIdentifier:cellIdentified];
    }
    return _tableView;
}
@end
