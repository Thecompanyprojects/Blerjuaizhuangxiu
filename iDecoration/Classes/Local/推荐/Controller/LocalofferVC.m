//
//  LocalofferVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "LocalofferVC.h"
#import "localofferCell.h"
#import "localofferModel.h"
#import "BLEJBudgetGuideController.h"
#import "BLEJCalculatorGetTempletByCompanyId.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
#import "BLEJCalculatorBaseAndSuppleListModel.h"
#import "ZCHBudgetGuideConstructionCaseModel.h"
#import "BLRJCalculatortempletModelAllCalculatorcompanyData.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
#import "ZCHCalculatorItemsModel.h"
#import "localofferHeader.h"


@interface LocalofferVC ()<UITableViewDataSource,UITableViewDelegate,LYShareMenuViewDelegate>
{
    int pagenum;
}
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *topCalculatorImageArr;
@property (nonatomic,strong) BLRJCalculatortempletModelAllCalculatorTypes *calculatorTempletModel;
@property (nonatomic,strong) BLRJCalculatortempletModelAllCalculatorcompanyData *allCalculatorCompanyData;
@property (nonatomic,strong) NSMutableArray *bottomCalculatorImageArr;
@property (nonatomic,strong) NSMutableArray *baseItemsArr;
@property (nonatomic,strong) NSMutableArray *suppleListArr;
@property (nonatomic,strong) NSMutableArray *constructionCase;

@property (nonatomic,strong) LYShareMenuView *shareMenuView;
@property (nonatomic,strong) TencentOAuth *tencentOAuth;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) localofferHeader *header;
@end

static NSString *localofferidentfid = @"localofferidentfid";

@implementation LocalofferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"报价";
    
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
    
    self.topCalculatorImageArr = [NSMutableArray array];
    self.bottomCalculatorImageArr = [NSMutableArray array];
    self.suppleListArr = [NSMutableArray array];
    self.baseItemsArr = [NSMutableArray array];
    self.constructionCase = [NSMutableArray array];
    pagenum = 1; 
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    self.type = @"0";
    self.table.tableHeaderView = self.header;
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.table.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadNewData
{
    NSInteger strint = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    NSString *str = [NSString stringWithFormat:@"%ld",(long)strint];
    NSString *agencyId = @"";
    if (IsNilString(str)) {
        agencyId = @"0";
    }
    else
    {
        agencyId = str;
    }
    NSString *cityId = self.cityId;
    NSString *countyId = self.countyId;
    NSString *page = @"1";
    NSString *pageSize = @"30";
    NSDictionary *para = @{@"agencyId":agencyId,@"cityId":cityId?:@"0",@"countyId":countyId,@"page":page,@"pageSize":pageSize,@"type":self.type,@"provinceId":@"0",@"cityName":@"",@"lon":self.lng,@"lat":self.lat};
    NSString *url = [BASEURL stringByAppendingString:@"calculator/getWeCalInit2.do"];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [self.dataSource removeAllObjects];
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[localofferModel class] json:responseObj[@"data"][@"list"]]];
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
    pagenum++;
    NSInteger strint = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    NSString *str = [NSString stringWithFormat:@"%ld",strint];
    NSString *agencyId = @"";
    if (IsNilString(str)) {
        agencyId = @"0";
    }
    else
    {
        agencyId = str;
    }
    NSString *cityId = self.cityId;
    NSString *countyId = self.countyId;
    NSString *page = [NSString stringWithFormat:@"%d",pagenum];
    NSString *pageSize = @"30";
    NSDictionary *para = @{@"agencyId":agencyId,@"cityId":cityId?:@"0",@"countyId":countyId,@"page":page,@"pageSize":pageSize,@"type":self.type,@"provinceId":@"0",@"cityName":@"",@"lon":self.lng,@"lat":self.lat};
    
    NSString *url = [BASEURL stringByAppendingString:@"calculator/getWeCalInit2.do"];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[localofferModel class] json:responseObj[@"data"][@"list"]]];
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

-(localofferHeader *)header
{
    if(!_header)
    {
        _header = [[localofferHeader alloc] init];
        _header.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 44);
        [_header.btn0 addTarget:self action:@selector(headtypebtn0click) forControlEvents:UIControlEventTouchUpInside];
        [_header.btn1 addTarget:self action:@selector(headtypebtn1click) forControlEvents:UIControlEventTouchUpInside];
        [_header.btn2 addTarget:self action:@selector(headtypebtn2click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _header;
}

- (LYShareMenuView *)shareMenuView{
    if (!_shareMenuView) {
        _shareMenuView = [[LYShareMenuView alloc] init];
        _shareMenuView.delegate = self;
    }
    return _shareMenuView;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    localofferCell *cell = [tableView dequeueReusableCellWithIdentifier:localofferidentfid];
    if (!cell) {
        cell = [[localofferCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:localofferidentfid];
    }
    [cell setdata:self.dataSource[indexPath.row] andwithtype:self.type];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    localofferModel *model = self.dataSource[indexPath.row];
    BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
    VC.origin = @"1";
    VC.companyID = [NSString stringWithFormat:@"%ld",(long)model.companyId];
    VC.isConVip = @"1";
    [self.navigationController pushViewController:VC animated:YES];
}
            
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
    NSString *shareURL = [NSString stringWithFormat:@"%@%@%@%@%@%@",str1,@"?type=0",@"&cityId=",self.cityId,@"&countyId",self.countyId];
    NSString *sharetitle = @"精准装修报价";
    NSString *sharedescription = @"10秒钟带你了解装修花多少钱...";
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

#pragma mark - type

-(void)headtypebtn0click
{
    self.type = @"0";
    [self loadNewData];
}

-(void)headtypebtn1click
{
    self.type = @"1";
    [self loadNewData];
}

-(void)headtypebtn2click
{
    self.type = @"2";
    [self loadNewData];
}

@end
