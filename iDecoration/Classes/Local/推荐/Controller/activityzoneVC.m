//
//  activityzoneVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/15.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "activityzoneVC.h"
#import "activityzoneCell0.h"
#import "activityzoneCell1.h"
#import "activityzoneCell2.h"
#import "activityzoneHeaderView.h"
#import "activityzoneModel.h"
#import "activityzoneCommentVC.h"
#import "LYShareMenuView.h"
#import "NewsActivityShowController.h"

@interface activityzoneVC ()<UITableViewDataSource,UITableViewDelegate,SingupTabVdelegate,myTabVdelegate,LYShareMenuViewDelegate>
{
    int page;
    BOOL isTime;
    BOOL isFllow;
}
@property (nonatomic,strong) activityzoneHeaderView *header;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *imgsList;

@property (nonatomic, strong) LYShareMenuView *shareMenuView;
// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic,copy) NSString *companyId;
@property (nonatomic,copy) NSString *designsId;
@property (nonatomic,copy) NSString *designTitle;
@property (nonatomic,copy) NSString *designSubTitle;
@property (nonatomic,copy) NSString *coverMap;

@property (nonatomic,copy) NSString *relId;
@property (nonatomic,copy) NSString *Newid;

@property (nonatomic,assign) BOOL isclick;
@end

static NSString *activityzoneidentfid0 = @"activityzoneidentfid0";
static NSString *activityzoneidentfid1 = @"activityzoneidentfid1";
static NSString *activityzoneidentfid2 = @"activityzoneidentfid2";

@implementation activityzoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动专区";
    page = 1;
    isTime = NO;
    isFllow = NO;
    self.isclick = NO;
    [self setupshare];
    [self.imgsList removeAllObjects];
    [self.view addSubview:self.table];
    self.table.tableHeaderView = self.header;
    self.table.tableFooterView = [UIView new];
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.table.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:@"activityzonecomment" object:nil];

}

-(void)notice:(id)sender{
    NSLog(@"%@",sender);
    [self loadNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadNewData
{
    page = 1;
    NSString *url = [BASEURL stringByAppendingString:GET_ActivityArrondiList];
    NSString *pagenum = [NSString stringWithFormat:@"%d",page];
    
    NSInteger strint = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    NSString *str = [NSString stringWithFormat:@"%ld",strint];
    NSString *agencysId = @"";
    if (IsNilString(str)) {
        agencysId = @"0";
    }
    else
    {
        agencysId = str;
    }
    NSString *isTimestr = [NSString stringWithFormat:@"%d",isTime];
    NSString *isFllowstr = [NSString stringWithFormat:@"%d",isFllow];
    NSDictionary *para = @{@"agencysId":agencysId,@"isTime":isTimestr,@"isFllow":isFllowstr,@"page":pagenum};
    [self.imgsList removeAllObjects];
    [self.dataSource removeAllObjects];
    
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
            self.isclick = YES;
            
            NSArray *imgarr = [[responseObj objectForKey:@"data"] objectForKey:@"imgList"];
            for (int i = 0; i<imgarr.count; i++) {
                NSDictionary *imgdic = imgarr[i];
                NSString *imgstr = [imgdic objectForKey:@"imgUrl"];
                [self.imgsList addObject:imgstr];
            }
            
            
            self.header.scrollView.imageURLStringsGroup = self.imgsList;
            
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[activityzoneModel class] json:responseObj[@"data"][@"activityList"]]];
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
    page++;
    NSString *url = [BASEURL stringByAppendingString:GET_ActivityArrondiList];
    NSString *pagenum = [NSString stringWithFormat:@"%d",page];
    
    NSInteger strint = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    NSString *str = [NSString stringWithFormat:@"%ld",strint];
    NSString *agencysId = @"";
    if (IsNilString(str)) {
        agencysId = @"0";
    }
    else
    {
        agencysId = str;
    }
    NSString *isTimestr = [NSString stringWithFormat:@"%d",isTime];
    NSString *isFllowstr = [NSString stringWithFormat:@"%d",isFllow];
    NSDictionary *para = @{@"agencysId":agencysId,@"isTime":isTimestr,@"isFllow":isFllowstr,@"page":pagenum};
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            self.isclick = YES;
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[activityzoneModel class] json:responseObj[@"data"][@"activityList"]]];
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

-(activityzoneHeaderView *)header
{
    if(!_header)
    {
        _header = [[activityzoneHeaderView alloc] init];
        _header.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 193+73);
        [_header.btn0 addTarget:self action:@selector(headbtn0click) forControlEvents:UIControlEventTouchUpInside];
        [_header.btn1 addTarget:self action:@selector(headbtn1click) forControlEvents:UIControlEventTouchUpInside];
        [_header.btn2 addTarget:self action:@selector(headbtn2click) forControlEvents:UIControlEventTouchUpInside];
       
        UITapGestureRecognizer *labelTapGestureRecognizer0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside0)];
        [_header.lab0 addGestureRecognizer:labelTapGestureRecognizer0];
        
        UITapGestureRecognizer *labelTapGestureRecognizer1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside1)];
        [_header.lab1 addGestureRecognizer:labelTapGestureRecognizer1];
        
        UITapGestureRecognizer *labelTapGestureRecognizer2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside2)];
        [_header.lab2 addGestureRecognizer:labelTapGestureRecognizer2];
    }
    return _header;
}


-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

-(NSMutableArray *)imgsList
{
    if(!_imgsList)
    {
        _imgsList = [NSMutableArray array];
        
    }
    return _imgsList;
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        activityzoneCell0 *cell = [tableView dequeueReusableCellWithIdentifier:activityzoneidentfid0];
        cell = [[activityzoneCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activityzoneidentfid0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataSource.count!=0) {
            [cell setdata:self.dataSource[indexPath.section]];
        }
        return cell;
    }
    if (indexPath.row==1) {
        activityzoneCell1 *cell = [tableView dequeueReusableCellWithIdentifier:activityzoneidentfid1];
        cell = [[activityzoneCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activityzoneidentfid1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataSource.count!=0) {
            [cell setdata:self.dataSource[indexPath.section]];
        }
        cell.delegate = self;
        return cell;
    }
    if (indexPath.row==2) {
        activityzoneCell2 *cell = [tableView dequeueReusableCellWithIdentifier:activityzoneidentfid2];
        cell = [[activityzoneCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activityzoneidentfid2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataSource.count!=0) {
            [cell setdata:self.dataSource[indexPath.section]];
        }
        cell.delegate = self;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 70;
    }
    if (indexPath.row==1) {
        return 128;
    }
    if (indexPath.row==2) {
        return 27;
    }
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    activityzoneModel *model = self.dataSource[indexPath.section];
    NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
    vc.designsId = model.designsId;
    vc.activityType = 3;
    vc.companyPhone = model.companyPhone;
    vc.companyLandLine = model.companyLandLine;
    vc.companyLogo = model.companyLogo;
    vc.companyName = model.companyName;
    vc.companyId = [NSString stringWithFormat:@"%ld",model.companyId];
    vc.origin = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 实现方法

-(void)labelTouchUpInside0
{
    [self headbtn0click];
}

-(void)labelTouchUpInside1
{
    [self headbtn1click];
}

-(void)labelTouchUpInside2
{
    [self headbtn2click];
}

-(void)headbtn0click
{
    [[PublicTool defaultTool] publicToolsHUDStr:@"敬请期待" controller:self sleep:1.5];
}

-(void)headbtn1click
{
    isTime = YES;
    isFllow = NO;
    [self loadNewData];
}

-(void)headbtn2click
{
    isFllow = YES;
    isTime = NO;
    [self loadNewData];
}

-(void)singupTabbtn:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.table indexPathForCell:cell];
    activityzoneModel *model = self.dataSource[index.section];
    NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
    vc.designsId = model.designsId;
    vc.activityType = 3;
    vc.companyLandLine = model.companyLandLine;
    vc.companyLogo = model.companyLogo;
    vc.companyName = model.companyName;
    vc.companyId = [NSString stringWithFormat:@"%ld",model.companyId];
    vc.origin = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)myTabVClick0:(UITableViewCell *)cell
{
    [self sharebtnclick];
    NSIndexPath *index = [self.table indexPathForCell:cell];
    activityzoneModel *model = self.dataSource[index.section];
   
    self.companyId = [NSString stringWithFormat:@"%ld",model.companyId];
    self.designsId = [NSString stringWithFormat:@"%ld",model.designsId];
    self.designTitle = model.designTitle;
    self.coverMap = model.coverMap;
    self.designSubTitle = model.designSubtitle;
    

    
    [self addsharenumber];
    
}

-(void)myTabVClick1:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.table indexPathForCell:cell];
    activityzoneModel *model = self.dataSource[index.section];
    activityzoneCommentVC *vc = [activityzoneCommentVC new];
    vc.zoneModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)myTabVClick2:(UITableViewCell *)cell
{
    NSString *url = [BASEURL stringByAppendingString:Local_notezan];
    NSIndexPath *index = [self.table indexPathForCell:cell];
    if (self.dataSource.count!=0) {
        
        activityzoneModel *model = self.dataSource[index.section];
        if (!model.isliked) {
            model.isliked = YES;
            model.likeCount = model.likeCount+1;
            [self.table reloadData];
            NSString *designsId = [NSString stringWithFormat:@"%ld",model.designsId];
            NSDictionary *para = @{@"designsId":designsId};
            [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
                
            } failed:^(NSString *errorMsg) {
                
            }];
        }
      
       
    }
   
}

-(void)sharebtnclick
{
    [self.shareMenuView show];
}

-(void)setupshare
{
    //[self.view addSubview:self.shareMenuView];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self.shareMenuView];
    //配置item
    NSMutableArray *array = NSMutableArray.new;
    LYShareMenuItem *item0 = nil;
    item0 = [LYShareMenuItem shareMenuItemWithImageName:@"weixin-share" itemTitle:@"微信好友"];
    [array addObject:item0];
    
    LYShareMenuItem *item1 = nil;
    item1 = [LYShareMenuItem shareMenuItemWithImageName:@"pengyouquan" itemTitle:@"朋友圈"];
    [array addObject:item1];
    
    LYShareMenuItem *item2 = nil;
    item2 = [LYShareMenuItem shareMenuItemWithImageName:@"qq" itemTitle:@"QQ"];
    [array addObject:item2];
    
    LYShareMenuItem *item3 = nil;
    item3 = [LYShareMenuItem shareMenuItemWithImageName:@"qqkongjian" itemTitle:@"QQ空间"];
    [array addObject:item3];
    
    self.shareMenuView.shareMenuItems = [array copy];
}

- (void)shareMenuView:(LYShareMenuView *)shareMenuView didSelecteShareMenuItem:(LYShareMenuItem *)shareMenuItem atIndex:(NSInteger)index{
    
    NSInteger strint = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    NSString *str = [NSString stringWithFormat:@"%ld",strint];
    NSString *agencyId = @"";
    
    NSString *shareTitle = self.designTitle;
    NSString *shareDescription = self.designSubTitle;
    NSURL *shareImageUrl;
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    shareImageUrl = [NSURL URLWithString:self.coverMap];
    
   
    if (IsNilString(str)) {
        agencyId = @"0";
    }
    else
    {
        agencyId = str;
    }
    //NSString *shareURL = @"";
    
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm?origin=%@",self.designsId, (long)user.agencyId,@"2"]];
    if (user.agencyId==0) {
        shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm",self.designsId, (long)0]];
    }
    else{
        [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%ld.htm",self.designsId, (long)user.agencyId]];
    }
    
    switch (index) {
        case 2:
        {
            
            // QQ好友
            if ([TencentOAuth iphoneQQInstalled]) {
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                //从contentObj中传入数据，生成一个QQReq
                
                if (!user.agencyId) {
                    user.agencyId = 0;
                }
                if (!self.companyId||self.companyId.length<=0) {
                    self.companyId = @"0";
                }
              
                
                NSURL *url = [NSURL URLWithString:shareURL];
                
                UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
                
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];
                
                QQApiNewsObject *newObject;
                if (self.coverMap) {
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:data];
                } else {
                    UIImage *image = [UIImage imageNamed:@"shareDefaultIcon"];
                    NSData *dataOne = [self imageWithImage:image scaledToSize:CGSizeMake(300, 300)];
                    //                    NSData *dataOne = UIImagePNGRepresentation(image);
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:dataOne];
                }
                
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    //                    [MobClick event:@"ConstructionDiaryShare"];
                }
                
                self.companyId = @"";
                self.designsId = @"";
                self.designTitle = @"";
                self.designSubTitle = @"";
                self.coverMap = @"";
            
            }
        }
            break;
        case 3:
        {
            // QQ空间
            if ([TencentOAuth iphoneQQInstalled]){
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                //从contentObj中传入数据，生成一个QQReq
                
                if (!user.agencyId) {
                    user.agencyId = 0;
                }
                if (!self.companyId||self.companyId.length<=0) {
                    self.companyId = @"0";
                }
         
                
                NSURL *url = [NSURL URLWithString:shareURL];
                
                UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
                
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];
                
                QQApiNewsObject *newObject;
                if (self.coverMap) {
                    //                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageURL:shareImageUrl];
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:data];
                } else {
                    UIImage *image = [UIImage imageNamed:@"shareDefaultIcon"];
                    //                    NSData *data = UIImagePNGRepresentation(image);
                    NSData *dataOne = [self imageWithImage:image scaledToSize:CGSizeMake(300, 300)];
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:dataOne];
                }
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    //                    [MobClick event:@"ConstructionDiaryShare"];
                }
                self.companyId = @"";
                self.designsId = @"";
                self.designTitle = @"";
                self.designSubTitle = @"";
                self.coverMap = @"";
           
            }
        }
            break;
        case 0:
        {
            //微信好友
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
            
            // 把图片设置成正方形
            CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
            shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
            
            UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
            if (self.coverMap) {
                [message setThumbImage:img];
            } else {
                UIImage *image = [UIImage imageNamed:@"shareDefaultIcon"];
                [message setThumbImage:image];
            }
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            
            if (!user.agencyId) {
                user.agencyId = 0;
            }
            if (!self.companyId||self.companyId.length<=0) {
                self.companyId = @"0";
            }
            
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                
            }

            self.companyId = @"";
            self.designsId = @"";
            self.designTitle = @"";
            self.designSubTitle = @"";
            self.coverMap = @"";
        }
            break;
        case 1:
        {
            // 微信朋友圈
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
            
            // 把图片设置成正方形
            
            CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
            shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
            
            UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
            if (self.coverMap) {
                [message setThumbImage:img];
            } else {
                UIImage *image = [UIImage imageNamed:@"shareDefaultIcon"];
                [message setThumbImage:image];
            }
            
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            
            if (!user.agencyId) {
                user.agencyId = 0;
            }
            if (!self.companyId||self.companyId.length<=0) {
                self.companyId = @"0";
            }

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
            self.companyId = @"";
            self.designsId = @"";
            self.designTitle = @"";
            self.designSubTitle = @"";
            self.coverMap = @"";
          
        }
            break;
        default:
            break;
    }
}

-(void)addsharenumber
{
    NSString *url = [BASEURL stringByAppendingString:@"designs/addShare.do"];
    NSDictionary *para = @{@"designId":self.designsId};
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        [self loadNewData];
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"activityzonecomment" object:nil];
}

@end
