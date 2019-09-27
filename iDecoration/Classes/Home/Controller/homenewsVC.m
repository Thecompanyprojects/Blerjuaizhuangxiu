//
//  homenewsVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "homenewsVC.h"
#import "homenewsCell0.h"
#import "homenewsCell1.h"
#import "homenewsCell2.h"
#import "NewsActivityShowController.h"
#import "homenewsModel.h"
#import "LYShareMenuView.h"
#import "activityzoneCommentVC.h"

@interface homenewsVC ()<UITableViewDataSource,UITableViewDelegate,singupTabVdelegate,myTabVdelegate,LYShareMenuViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *table;

@property (nonatomic, strong) LYShareMenuView *shareMenuView;
// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic,copy) NSString *designsId;
@property (nonatomic,copy) NSString *designTitle;
@property (nonatomic,copy) NSString *designSubTitle;
@property (nonatomic,copy) NSString *coverMap;

@property (nonatomic,copy) NSString *relId;
@property (nonatomic,copy) NSString *Newid;

@end

static NSString *homenewsidentfid0 = @"homenewsidentfid0";
static NSString *homenewsidentfid1 = @"homenewsidentfid1";
static NSString *homenewsidentfid2 = @"homenewsidentfid2";

@implementation homenewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新闻资讯";
    [self.view addSubview:self.table];
    [self setupshare];
    self.table.tableFooterView = [UIView new];
    [self loaddata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loaddata
{
    NSString *url = [BASEURL stringByAppendingString:@"designs/getDesignListByCompanyIdORAgencysId.do"];
    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"]?:@"";
    NSDictionary *para = @{@"companyId":self.companyId,@"agencysId":agencysId,@"type":@"1"};
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            self.companyId = [responseObj objectForKey:@"companyId"];
            self.dataSource = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[homenewsModel class] json:responseObj[@"data"][@"activityList"]];
        }
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        homenewsCell0 *cell = [tableView dequeueReusableCellWithIdentifier:homenewsidentfid0];
        cell = [[homenewsCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homenewsidentfid0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setdata:self.dataSource[indexPath.section]];
        return cell;
    }
    if (indexPath.row==1) {
        homenewsCell1 *cell = [tableView dequeueReusableCellWithIdentifier:homenewsidentfid1];
        cell = [[homenewsCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homenewsidentfid1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setdata:self.dataSource[indexPath.section]];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.row==2) {
        homenewsCell2 *cell = [tableView dequeueReusableCellWithIdentifier:homenewsidentfid2];
        cell = [[homenewsCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homenewsidentfid2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setdata:self.dataSource[indexPath.section]];
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
    homenewsModel *model = self.dataSource[indexPath.section];
    NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
    vc.designsId = model.designsId;
    if (model.type>0) {
         vc.activityType = 3;
    }
    else
    {
        vc.activityType = 2;
    }
    vc.companyPhone = model.companyPhone;
    vc.companyLandLine = model.companyLandline;
    vc.companyLogo = model.companyLogo;
    vc.companyName = model.companyName;
    vc.companyId = self.companyId;
    vc.origin = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)singupTabbtn:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.table indexPathForCell:cell];
    homenewsModel *model = self.dataSource[index.section];
    NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
    vc.designsId = model.designsId;
    vc.activityType = 3;
    vc.companyLandLine = model.companyLandline;
    vc.companyLogo = model.companyLogo;
    vc.companyName = model.companyName;
    vc.companyId = self.companyId;
    vc.origin = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)myTabVClick0:(UITableViewCell *)cell
{
    [self sharebtnclick];
    NSIndexPath *index = [self.table indexPathForCell:cell];
    homenewsModel *model = self.dataSource[index.section];
    
    self.companyId = self.companyId;
    self.designsId = [NSString stringWithFormat:@"%ld",model.designsId];
    self.designTitle = model.designTitle;
    self.coverMap = model.coverMap;
    self.designSubTitle = model.designTitle;
    
    [self addsharenumber];
    
}

-(void)myTabVClick1:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.table indexPathForCell:cell];
    homenewsModel *model = self.dataSource[index.section];
    activityzoneCommentVC *vc = [activityzoneCommentVC new];
    vc.homeModel = model;
    vc.ishome = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)myTabVClick2:(UITableViewCell *)cell
{
    NSString *url = [BASEURL stringByAppendingString:Local_notezan];
    NSIndexPath *index = [self.table indexPathForCell:cell];
    if (self.dataSource.count!=0) {
        
        homenewsModel *model = self.dataSource[index.section];
        if (!model.isliked) {
            model.isliked = YES;
            model.likeNum = model.likeNum+1;
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
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:dataOne];
                }
                
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    
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
        [self loaddata];
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


@end
