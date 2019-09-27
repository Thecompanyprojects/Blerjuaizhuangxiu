//
//  localgoodsVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localgoodsVC.h"
#import "CQSideBarConst.h"
#import "CQSideBarManager.h"
#import "localgoodstypeVC.h"
#import "localgoodsCell.h"
#import "localgoodsHeaderView.h"
#import "localgoodsModel.h"
#import "GoodsDetailViewController.h"

@interface localgoodsVC ()<CQSideBarManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,myTabVdelegate,UISearchBarDelegate,LYShareMenuViewDelegate>
{
    int pagenum;
}
@property (nonatomic, strong) localgoodstypeVC *sideBarVC;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,copy) NSString *companyType;//商品类别
@property (nonatomic,copy) NSString *type;//类型(0:综合，1:热度，2:价格从低到高，3:从高到低)
@property (nonatomic,copy) NSString *name;//搜索内容
@property (nonatomic,assign) BOOL pirce;

@property (nonatomic,strong) LYShareMenuView *shareMenuView;
@property (nonatomic,strong) TencentOAuth *tencentOAuth;
@end

static NSString *localgoodsidentfid = @"localgoodsidentfid";

@implementation localgoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商城优品";
    
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
    
    pagenum = 1;
    self.companyType = @"";
    self.type = @"0";
    self.name = @"";
    self.pirce = YES;
    [self.view addSubview:self.collectionView];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.collectionView.mj_header beginRefreshing];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transferSectionName:) name:@"kAppTransferSectionNameForTitle" object:nil];
       
    
}
-(void)transferSectionName:(NSNotification*)noti{
    
    NSDictionary *dict = noti.userInfo;
    self.title =dict[@"name"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadNewData
{
    [self.dataSource removeAllObjects];
    NSString *url = [BASEURL stringByAppendingString:GET_Merchandies2];
    NSDictionary *para = @{@"cityId":self.cityId,@"countyId":self.countyId,@"page":@"1",@"pageSize":@"30",@"name":self.name,@"companyType":self.companyType,@"type":self.type};
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSArray *arr = (NSArray *)[NSArray yy_modelArrayWithClass:[localgoodsModel class] json:responseObj[@"data"][@"list"]];
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
    NSString *url = [BASEURL stringByAppendingString:GET_Merchandies2];
    pagenum++;
    NSString *page = [NSString stringWithFormat:@"%d",pagenum];
    NSDictionary *para = @{@"cityId":self.cityId,@"countyId":self.countyId,@"page":page,@"pageSize":@"30",@"name":self.name,@"companyType":self.companyType,@"type":self.type};
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSArray *arr = (NSArray *)[NSArray yy_modelArrayWithClass:[localgoodsModel class] json:responseObj[@"data"][@"list"]];
            [self.dataSource addObjectsFromArray:arr];
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.collectionView.mj_footer endRefreshing];
    }];
}



#pragma mark - getters
#pragma mark - 创建collectionView并设置代理

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //flowLayout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH, AD_height+10);//头部大小
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom-5, kSCREEN_WIDTH, naviBottom-5) collectionViewLayout:flowLayout];
        //定义每个UICollectionView 的大小
        
        flowLayout.itemSize = CGSizeMake((kSCREEN_WIDTH-12)/2, 184);
        flowLayout.minimumLineSpacing = 4;
        flowLayout.minimumInteritemSpacing = 4;
        [_collectionView registerClass:[localgoodsCell class] forCellWithReuseIdentifier:localgoodsidentfid];
        //flowLayout.sectionInset =UIEdgeInsetsMake(3,3, 3, 1);
        
        flowLayout.sectionInset = UIEdgeInsetsMake(1, 4, 4, 3);
        
        flowLayout.headerReferenceSize =CGSizeMake(kSCREEN_WIDTH,87);//头视图大小
        [_collectionView registerClass:[localgoodsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
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

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

- (LYShareMenuView *)shareMenuView{
    if (!_shareMenuView) {
        _shareMenuView = [[LYShareMenuView alloc] init];
        _shareMenuView.delegate = self;
    }
    return _shareMenuView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count?:0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    localgoodsCell *cell = (localgoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:localgoodsidentfid forIndexPath:indexPath];
    cell.backgroundColor = White_Color;
    [cell setdata:self.dataSource[indexPath.item]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    localgoodsHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"forIndexPath:indexPath];
    [header.chooseBtn0 addTarget:self action:@selector(headbtn0click) forControlEvents:UIControlEventTouchUpInside];
    [header.chooseBtn1 addTarget:self action:@selector(headbtn1click) forControlEvents:UIControlEventTouchUpInside];
    [header.chooseBtn2 addTarget:self action:@selector(headbtn2click) forControlEvents:UIControlEventTouchUpInside];
    [header.chooseBtn3 addTarget:self action:@selector(headbtn3click) forControlEvents:UIControlEventTouchUpInside];
    header.search.delegate = self;
    header.backgroundColor = White_Color;
    [header.submitBtn addTarget:self action:@selector(headsearchclick) forControlEvents:UIControlEventTouchUpInside];
    header.chooseBtn3.tag = 2018;
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kSCREEN_WIDTH, 87);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    localgoodsModel *model = self.dataSource[indexPath.item];
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] init];
    vc.fromBack = NO;
    vc.goodsID = model.Newid;
    //    vc.shopID = [NSString stringWithFormat:@"%ld",model.merchantId];
    //    vc.companyType = [NSString stringWithFormat:@"%ld",model.companyType];
    vc.origin = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)myTabVClick:(NSString *)index
{
    [[CQSideBarManager sharedInstance] closeSideBar];
    self.type = @"0";
    
    self.companyType = index;
    [self loadNewData];
}

#pragma mark - Head click

-(void)headbtn0click
{
    self.type = @"0";
    self.companyType = @"";
    [self loadNewData];
}

-(void)headbtn1click
{
    self.type = @"1";
    self.companyType = @"";
    [self loadNewData];
}

-(void)headbtn2click
{
    [self showAction];
    self.type = @"0";
    
}

-(void)headbtn3click
{
    self.companyType = @"";
    self.pirce = !self.pirce;
    if (self.pirce) {
        self.type = @"2";
        UIButton *btn = [self.collectionView viewWithTag:2018];
        [btn setImage:[UIImage imageNamed:@"icon_shang_jihuo"] forState:normal];
    }
    else
    {
        self.type = @"3";
        UIButton *btn = [self.collectionView viewWithTag:2018];
        [btn setImage:[UIImage imageNamed:@"icon_xia_jihuo"] forState:normal];
    }
    [self loadNewData];
}

-(void)headsearchclick
{
    [self loadNewData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self headsearchclick];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //searchText是searchBar上的文字 每次输入或删除都都会打印全部
    self.name = searchText;
}



#pragma mark - actions
- (void)showAction{
    [CQSideBarManager sharedInstance].startOffsetPoint = CGPointMake(110.0f, 0);
    [[CQSideBarManager sharedInstance] openSideBar:self];
    
}



#pragma mark - CQSideBarManagerDelegate

- (UIView *)viewForSideBar
{
    /*
     *  如果使用VC的view作为侧边栏视图，那么需要注意在ARC模式下控制器出了作用域会被释放掉这种情况，导致无法响应点击事件，个别同学已经碰到这种问题，现已作出解释。比如以下这个写法:
     *  SideBarViewController *sideBarVC = [[SideBarViewController alloc] init];
     *  sideBarVC.view.cq_width = self.view.cq_width - 35.f;
     *  return sideBarVC.view;
     */
    return self.sideBarVC.view;
}

- (BOOL)canCloseSideBar
{
    return YES;
}

#pragma mark ---Getter

- (localgoodstypeVC *)sideBarVC
{
    if (!_sideBarVC) {
        _sideBarVC = [[localgoodstypeVC alloc] init];
        _sideBarVC.view.cq_width = self.view.cq_width-110;
        _sideBarVC.delegate = self;
    }
    return _sideBarVC;
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
    NSString *shareURL = [NSString stringWithFormat:@"%@%@%@%@%@%@",str1,@"?type=3",@"&cityId=",self.cityId,@"&countyId",self.countyId];
    
    NSString *sharetitle = @"上爱装修挑万家优品";
    NSString *sharedescription = @"大牌来袭，等你抢购，特卖产品，等你来拿~";
    
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
