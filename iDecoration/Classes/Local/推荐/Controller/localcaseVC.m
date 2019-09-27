//
//  localcaseVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/27.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localcaseVC.h"
#import "localcaseCell.h"
#import "localcaseHeaderView.h"
#import "SpreadDropMenu.h"
#import "localcaseModel.h"
#import "ConstructionDiaryTwoController.h"
#import "MainMaterialDiaryController.h"

@interface localcaseVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,myTabVdelegate,UISearchBarDelegate,LYShareMenuViewDelegate>
{
    int pagenum;
    
}
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) localcaseHeaderView *headView;
@property (nonatomic,strong) NSString *order;
@property (nonatomic,strong) NSString *serchContent;
@property (nonatomic,copy) NSString *type;

@property (nonatomic,strong) LYShareMenuView *shareMenuView;
@property (nonatomic,strong) TencentOAuth *tencentOAuth;
@end

static NSString *localcaseidentfid = @"localcaseidentfid";

@implementation localcaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"装修案例";
    
    // 设置导航栏最右侧的按钮
    UIButton *moreBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    moreBtn.frame = CGRectMake(0, 0, 44, 44);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"threemorewithe"]];
    [moreBtn addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.centerY.equalTo(0);
        make.size.equalTo(CGSizeMake(25, 25));
    }];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, -12)];
    [moreBtn addTarget:self action:@selector(addsaveclick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    [self setupshare];
    
    self.serchContent = @"";
    self.type = @"0";
    [self.view addSubview:self.collectionView];
    pagenum = 1;
    self.order = @"1";
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadNewData
{
    NSString *url = [BASEURLWX stringByAppendingString:@"construction/getList.do"];
    NSDictionary *para = @{@"order":self.order,@"page":@"1",@"pageSize":@"30",@"city":self.cityId,@"county":self.countyId,@"province":self.province,@"serchContent":self.serchContent};
    [self.dataSource removeAllObjects];
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *arr = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[localcaseModel class] json:responseObj[@"list"]];
            [self.dataSource addObjectsFromArray:arr];
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.collectionView.mj_header endRefreshing];
    }];
}

-(void)loadMoreData
{
    pagenum++;
    NSString *page = [NSString stringWithFormat:@"%d",pagenum];
    NSString *url = [BASEURLWX stringByAppendingString:@"construction/getList.do"];
    NSDictionary *para = @{@"order":self.order,@"page":page,@"pageSize":@"30",@"city":self.cityId,@"county":self.countyId,@"province":self.province,@"serchContent":self.serchContent};
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *arr = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[localcaseModel class] json:responseObj[@"list"]];
            [self.dataSource addObjectsFromArray:arr];
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.collectionView.mj_footer endRefreshing];
    }];
}

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

#pragma mark - 创建collectionView并设置代理

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
       
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom-5, kSCREEN_WIDTH, naviBottom-5) collectionViewLayout:flowLayout];
        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake((kSCREEN_WIDTH-2)/2, 169);
        flowLayout.minimumLineSpacing = 2;
        flowLayout.minimumInteritemSpacing = 1;
        [_collectionView registerClass:[localcaseCell class] forCellWithReuseIdentifier:localcaseidentfid];
        
        flowLayout.sectionInset =UIEdgeInsetsMake(0,0, 0, 0);
        flowLayout.headerReferenceSize =CGSizeMake(kSCREEN_WIDTH,87);//头视图大小
        [_collectionView registerClass:[localcaseHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
        _collectionView.backgroundColor = kBackgroundColor;
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count?:0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    localcaseCell *cell = (localcaseCell *)[collectionView dequeueReusableCellWithReuseIdentifier:localcaseidentfid forIndexPath:indexPath];
    cell.backgroundColor = White_Color;
    [cell setdata:self.dataSource[indexPath.item] withtype:self.type];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    localcaseHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"forIndexPath:indexPath];
    
    header.backgroundColor = White_Color;
    [header.chooseBtn0 addTarget:self action:@selector(headchoosebtn0click) forControlEvents:UIControlEventTouchUpInside];
    [header.chooseBtn1 addTarget:self action:@selector(headchoosebtn1click) forControlEvents:UIControlEventTouchUpInside];
    [header.chooseBtn2 addTarget:self action:@selector(headchoosebtn2click) forControlEvents:UIControlEventTouchUpInside];
    [header.chooseBtn3 addTarget:self action:@selector(headchoosebtn3click) forControlEvents:UIControlEventTouchUpInside];
    header.search.delegate = self;
    [header.submitBtn addTarget:self action:@selector(headsubmitclick) forControlEvents:UIControlEventTouchUpInside];
    return header;
}


- (LYShareMenuView *)shareMenuView{
    if (!_shareMenuView) {
        _shareMenuView = [[LYShareMenuView alloc] init];
        _shareMenuView.delegate = self;
    }
    return _shareMenuView;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kSCREEN_WIDTH, 87);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    localcaseModel *model = self.dataSource[indexPath.item];
    if (model.constructionType==0) {
        //施工日志
        ConstructionDiaryTwoController *constructionVC = [[ConstructionDiaryTwoController alloc] init];
        constructionVC.consID = model.Newid;
        constructionVC.isfromlocal = YES;
        constructionVC.constructionType = [NSString stringWithFormat:@"%ld",model.constructionType];
        [self.navigationController pushViewController:constructionVC animated:YES];
    }
    else
    {
        //主材日志
        MainMaterialDiaryController *mainDiaryVC = [[MainMaterialDiaryController alloc] init];
        mainDiaryVC.consID = model.Newid;
        mainDiaryVC.isfromlocal = YES;
        mainDiaryVC.constructionType = [NSString stringWithFormat:@"%ld",model.constructionType];
        [self.navigationController pushViewController:mainDiaryVC animated:YES];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //searchText是searchBar上的文字 每次输入或删除都都会打印全部
    self.serchContent = searchText;
}

-(void)headsubmitclick
{
    [self loadNewData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self headsubmitclick];
}

#pragma mark - chooseclick
//类型(0:好评，1:浏览量，2:创建时间，3:收藏数，4:信用)
-(void)headchoosebtn0click
{
    self.order = @"1";
    self.type = @"0";
    [self loadNewData];
}

-(void)headchoosebtn1click
{
    self.order = @"0";
    self.type = @"1";
    [self loadNewData];
}

-(void)headchoosebtn2click
{
    self.order = @"4";
    self.type = @"2";
    [self loadNewData];
}

-(void)headchoosebtn3click
{
    [self normalFromTopMenu];
}

-(void)myTabVClick:(NSInteger )index
{
    switch (index) {
        case 0:
            self.order = @"";
            self.type = @"4";
            [self loadNewData];
            break;
        case 1:
            self.order = @"0";
            self.type = @"4";
            [self loadNewData];
            break;
        case 2:
            self.order = @"2";
            self.type = @"4";
            [self loadNewData];
            break;
        case 3:
            self.order = @"3";
            self.type = @"4";
            [self loadNewData];
            break;
        default:
            break;
    }
}

#pragma mark - 展开动画,从上往下 , 下拉菜单

- (void)normalFromTopMenu
{
    CGFloat hei = 64;
    if (isiPhoneX) {
        hei = 88+86;
    }
    else
    {
        hei = 64+86;
    }
    //创建菜单
    SpreadDropMenu *menu = [[SpreadDropMenu alloc]initWithShowFrame:CGRectMake(0,hei, [UIScreen mainScreen].bounds.size.width, 121) ShowStyle:MYPresentedViewShowStyleFromTopSpreadStyle callback:^(id callback) {
        
        //在此处获取菜单对应的操作 ， 而做出一些处理
        NSLog(@"-----------------%@",callback);
        
    }];
    menu.delegate = self;
    //菜单展示
    [self presentViewController:menu animated:YES completion:nil];
}

#pragma mark - share

-(void)addsaveclick
{
    [self.shareMenuView show];
}


-(void)setupshare
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self.shareMenuView];
    //配置item
    NSMutableArray *array = NSMutableArray.new;
    LYShareMenuItem *item0 = nil;
    item0 = [LYShareMenuItem shareMenuItemWithImageName:@"qq" itemTitle:@"QQ"];
    [array addObject:item0];
    
    LYShareMenuItem *item1 = nil;
    item1 = [LYShareMenuItem shareMenuItemWithImageName:@"qqkongjian" itemTitle:@"QQ空间"];
    [array addObject:item1];
    
    LYShareMenuItem *item2 = nil;
    item2 = [LYShareMenuItem shareMenuItemWithImageName:@"weixin-share" itemTitle:@"微信好友"];
    [array addObject:item2];
    
    LYShareMenuItem *item3 = nil;
    item3 = [LYShareMenuItem shareMenuItemWithImageName:@"pengyouquan" itemTitle:@"朋友圈"];
    [array addObject:item3];
    
    self.shareMenuView.shareMenuItems = [array copy];
}

- (void)shareMenuView:(LYShareMenuView *)shareMenuView didSelecteShareMenuItem:(LYShareMenuItem *)shareMenuItem atIndex:(NSInteger)index{

    NSString *str1 = [BASEURL stringByAppendingString:@"citywiderecomend"];
    NSString *shareURL = [NSString stringWithFormat:@"%@%@%@%@%@%@",str1,@"?type=4",@"&cityId=",self.cityId,@"&countyId",self.countyId];
    
    NSString *sharetitle = @"带你走进不一样的装修";
    NSString *sharedescription = @"欧式、中式、田园、地中海......各种风格等你来看哦~";
    
    switch (index) {
        case 0:
        {
            // QQ好友
            if ([TencentOAuth iphoneQQInstalled]) {
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
              
                NSURL *url = [NSURL URLWithString:shareURL];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:sharetitle description:sharedescription previewImageData:nil];
                
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"CalculatorTemplateShare"];
                    
                }
                
            }
        }
            break;
        case 1:
        {
            // QQ空间
            if ([TencentOAuth iphoneQQInstalled]){
                
                
                NSURL *url = [NSURL URLWithString:shareURL];
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:sharetitle description:sharedescription previewImageData:nil];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"CalculatorTemplateShare"];
                    
                }
                
            }
        }
            break;
        case 2:
        {
            //微信好友
            
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = sharetitle;
            message.description = sharedescription;
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
           
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"CalculatorTemplateShare"];
                
            }
            
        }
            break;
        case 3:
        {
            // 微信朋友圈
            WXMediaMessage *message = [WXMediaMessage message];
           
            message.title = sharetitle;
            message.description = sharedescription;
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"CalculatorTemplateShare"];
                
            }
            
            
        }
            break;
        default:
            break;
    }
}

- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

@end
