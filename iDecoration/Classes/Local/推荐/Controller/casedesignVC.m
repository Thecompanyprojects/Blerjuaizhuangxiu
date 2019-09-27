//
//  casedesignVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "casedesignVC.h"
#import "newdesignModel.h"
#import "casedesignCell0.h"
#import "casedesignCell1.h"
#import "casedesignCell2.h"
#import "NewDesignImageWebController.h"

@interface casedesignVC ()<UITableViewDataSource,UITableViewDelegate,myTabVdelegate,LYShareMenuViewDelegate>
{
    int page;
}
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) LYShareMenuView *shareMenuView;
@property (nonatomic,strong) TencentOAuth *tencentOAuth;
@end

static NSString *casedesignidentfid0 = @"casedesignidentfid0";
static NSString *casedesignidentfid1 = @"casedesignidentfid1";
static NSString *casedesignidentfid2 = @"casedesignidentfid2";

@implementation casedesignVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"平面效果图";
  
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
    
    page = 1;
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
    
    NSDictionary *para = @{@"pageNum":@"30",@"type":@"0",@"page":@"1",@"agencyId":self.agencyId,@"cityId":self.cityId,@"countyId":self.countyId};
    NSString *url = [BASEURL stringByAppendingString:GET_DesignVip];
    [self.dataSource removeAllObjects];
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[newdesignModel class] json:responseObj[@"data"][@"list"]]];
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
    NSDictionary *para = @{@"pageNum":@"30",@"type":@"0",@"page":pagestr,@"agencyId":self.agencyId,@"cityId":self.cityId,@"countyId":self.countyId};
    NSString *url = [BASEURL stringByAppendingString:GET_DesignVip];
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[newdesignModel class] json:responseObj[@"data"][@"list"]]];
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
        casedesignCell0 *cell = [tableView dequeueReusableCellWithIdentifier:casedesignidentfid0];
        cell = [[casedesignCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:casedesignidentfid0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataSource.count!=0) {
            [cell setdata:self.dataSource[indexPath.section]];
        }
        return cell;
    }
    if (indexPath.row==1) {
        casedesignCell1 *cell = [tableView dequeueReusableCellWithIdentifier:casedesignidentfid1];
        cell = [[casedesignCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:casedesignidentfid1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataSource.count!=0) {
            [cell setdata:self.dataSource[indexPath.section]];
        }
        return cell;
    }
    if (indexPath.row==2) {
        casedesignCell2 *cell = [tableView dequeueReusableCellWithIdentifier:casedesignidentfid2];
        cell = [[casedesignCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:casedesignidentfid2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataSource.count!=0) {
            [cell setdata:self.dataSource[indexPath.section]];
        }        cell.delegate = self;
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
        return [self cellHeightForIndexPath:indexPath cellContentViewWidth:kSCREEN_WIDTH tableView:self.table];
    }
    if (indexPath.row==2) {
        return 36;
    }
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count!=0) {
        newdesignModel *model = self.dataSource[indexPath.section];
        NewDesignImageWebController *vc = [[NewDesignImageWebController alloc]init];
        vc.fromIndex = 1;
        vc.companyId = [NSString stringWithFormat:@"%ld",model.companyId];
        vc.companyLogo = model.companyLogo;
        vc.companyName = model.companyName;
        vc.consID = model.constructionId;
        vc.isfromlocal = YES;
        vc.companyLandline = model.companyLandline;
        vc.companyPhone = model.companyPhone;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
#pragma mark -myTabVdelegate

-(void)shareTabVClick0:(UITableViewCell *)cell
{
    
}

-(void)commentsTabVClick1:(UITableViewCell *)cell
{
    
}

-(void)zanTabVClick2:(UITableViewCell *)cell
{
    NSString *url = [BASEURL stringByAppendingString:GET_ZANdesign];
    NSIndexPath *index = [self.table indexPathForCell:cell];
    if (self.dataSource.count!=0) {
        
        newdesignModel *model = self.dataSource[index.section];
        if (!model.isliked) {
            model.isliked = YES;
            model.likeNumbers = model.likeNumbers+1;
            [self.table reloadData];
            NSString *designsId = [NSString stringWithFormat:@"%ld",model.designId];
            NSDictionary *para = @{@"designsId":designsId};
            [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
                
            } failed:^(NSString *errorMsg) {
                
            }];
        }
    }
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
    NSString *shareURL = [NSString stringWithFormat:@"%@%@%@%@%@%@",str1,@"?type=2",@"&cityId=",self.cityId,@"&countyId",self.countyId];
    
    
    NSString *sharetitle = @"家居、家装美图";
    NSString *sharedescription = @"倾情为您推荐海量家居美图，赶快收藏吧~";
    
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
