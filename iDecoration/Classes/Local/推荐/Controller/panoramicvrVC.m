//
//  panoramicvrVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "panoramicvrVC.h"
#import "panoramicvrCell0.h"
#import "panoramicvrCell1.h"
#import "panoramicvrModel.h"
#import "senceWebViewController.h"

@interface panoramicvrVC ()<UITableViewDataSource,UITableViewDelegate,LYShareMenuViewDelegate>
{
    int page;
}
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) LYShareMenuView *shareMenuView;
@property (nonatomic,strong) TencentOAuth *tencentOAuth;
@end

static NSString *panoramicvridentfid0 = @"panoramicvridentfid0";
static NSString *panoramicvridentfid1 = @"panoramicvridentfid1";

@implementation panoramicvrVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"3D效果图";
    page = 1;
    
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
    
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
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
    page = 1;
    NSDictionary *para = @{@"pageSize":@"30",@"type":@"10",@"page":@"1",@"agencyId":self.agencyId,@"cityId":self.cityId,@"countyId":self.countyId};
    NSString *url = [BASEURL stringByAppendingString:GET_ImgVip];
    [self.dataSource removeAllObjects];
    
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[panoramicvrModel class] json:responseObj[@"data"][@"list"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.table reloadData];
        [self.table.mj_header endRefreshing];
    } failed:^(NSString *errorMsg) {
         [self.table.mj_header endRefreshing];
    }];
    

}

-(void)loadMoreData
{
    page ++;
    NSString *pagestr = [NSString stringWithFormat:@"%d",page];
    NSDictionary *para = @{@"pageSize":@"30",@"type":@"10",@"page":pagestr,@"agencyId":self.agencyId,@"cityId":self.cityId,@"countyId":self.countyId};
    NSString *url = [BASEURL stringByAppendingString:GET_ImgVip];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[panoramicvrModel class] json:responseObj[@"data"][@"list"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.table reloadData];
        [self.table.mj_footer endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.table.mj_footer endRefreshing];
    }];
    
}


#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] init];
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        _table.frame = CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_WIDTH, naviBottom);
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

- (LYShareMenuView *)shareMenuView{
    if (!_shareMenuView) {
        _shareMenuView = [[LYShareMenuView alloc] init];
        _shareMenuView.delegate = self;
    }
    return _shareMenuView;
}



#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        panoramicvrCell0 *cell = [tableView dequeueReusableCellWithIdentifier:panoramicvridentfid0];
        cell = [[panoramicvrCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:panoramicvridentfid0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setdata:self.dataSource[indexPath.section]];
        return cell;
    }
    if (indexPath.row==1) {
        panoramicvrCell1 *cell = [tableView dequeueReusableCellWithIdentifier:panoramicvridentfid1];
        cell = [[panoramicvrCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:panoramicvridentfid1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setdata:self.dataSource[indexPath.section]];
        return cell;
    }
    return [UITableViewCell new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 60;
    }
    if (indexPath.row==1) {
        return 239;
    }
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    panoramicvrModel *model = self.dataSource[indexPath.section];
    senceWebViewController *vc = [[senceWebViewController alloc]init];
    vc.isFrom = YES;
    vc.webUrl = model.picHref;
    vc.companyName = model.companyName;
    vc.companyLogo = model.companyLogo;
    vc.isfromlocal = YES;
    vc.companyPhone = model.companyPhone;
    vc.companyLandline = model.companyLandline;
    vc.companyId = model.companyId;
    vc.companyType = model.companyType;
    vc.constructionType = model.companyType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 10.0f);
    view.backgroundColor = kBackgroundColor;
    return view;
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
    NSString *shareURL = [NSString stringWithFormat:@"%@%@%@%@%@%@",str1,@"?type=1",@"&cityId=",self.cityId,@"&countyId",self.countyId];
    
    
    NSString *sharetitle = @"全屋设计漫游";
    NSString *sharedescription = @"全方位3D效果图，带你全方位享受~";
    
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
