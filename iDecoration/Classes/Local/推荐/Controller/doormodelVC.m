//
//  doormodelVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "doormodelVC.h"
#import "doormodelCell.h"
#import "newdoorModel.h"

@interface doormodelVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>
@property (nonatomic,strong) UISearchBar *search;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSString *content;
@end

static NSString *doormodelidentfid = @"doormodelidentfid";

@implementation doormodelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"户型样板间";
    [self.view addSubview:self.search];
    self.content = [NSString new];
    [self.view addSubview:self.collectionView];
    [self newload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)newload
{
    NSString *url = [BASEURL stringByAppendingString:@"cblejCommunity/getMobelCons.do"];
    NSDictionary *para = @{@"companyId":self.companyId,@"mobelId":self.mobelId,@"communityId":self.communityId,@"content":self.content};
    [self.dataSource removeAllObjects];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[newdoorModel class] json:responseObj[@"data"][@"list"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.collectionView reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_WIDTH, naviBottom-5) collectionViewLayout:flowLayout];

        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake((kSCREEN_WIDTH-2)/2, 129);
        flowLayout.minimumLineSpacing = 2;
        flowLayout.minimumInteritemSpacing = 1;
        [_collectionView registerClass:[doormodelCell class] forCellWithReuseIdentifier:doormodelidentfid];
        
        flowLayout.headerReferenceSize =CGSizeMake(kSCREEN_WIDTH,40);//头视图大小
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
        _collectionView.backgroundColor = [UIColor whiteColor];
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _collectionView;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"forIndexPath:indexPath];
   // header.backgroundColor = Red_Color;
    
    self.search = [[UISearchBar alloc] init];
    self.search.delegate = self;
    
    _search.placeholder = @"搜索";
    _search.backgroundImage = [UIImage new];
    _search.backgroundColor = [UIColor clearColor];
    UIImage* searchBarBg = [self GetImageWithColor:kBackgroundColor andHeight:32.0f];
    [_search setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
    UITextField *searchField = [_search valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[UIColor whiteColor]];
        searchField.layer.cornerRadius = 14.0f;
        searchField.layer.masksToBounds = YES;
    }
    
    [header addSubview:self.search];
    [self.search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).with.offset(0);
        make.right.equalTo(header).with.offset(0);
        make.top.equalTo(header).with.offset(10);
        make.height.mas_offset(28);
    }];
    
    return header;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //searchText是searchBar上的文字 每次输入或删除都都会打印全部
    self.content = searchText;
}

-(void)headsubmitclick
{
    [self newload];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self headsubmitclick];
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

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count?:0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    doormodelCell *cell = (doormodelCell *)[collectionView dequeueReusableCellWithReuseIdentifier:doormodelidentfid forIndexPath:indexPath];
    cell.backgroundColor = White_Color;
    [cell setdata:self.dataSource[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kSCREEN_WIDTH, 40);
}

@end
