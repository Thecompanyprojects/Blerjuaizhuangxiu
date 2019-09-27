//
//  LocalnotesVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "LocalnotesVC.h"
#import "localnotesCell.h"
#import <SDAutoLayout.h>
#import "localnotesModel.h"
#import "NewsActivityShowController.h"
#import "LYShareMenuView.h"
#import "NewsleavemessageVC.h"

@interface LocalnotesVC ()<UITableViewDataSource,UITableViewDelegate,myTabVdelegate,LYShareMenuViewDelegate>
{
    int pagenum;
}
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) LYShareMenuView *shareMenuView;
// QQ分享
@property (nonatomic,strong) TencentOAuth *tencentOAuth;

@property (nonatomic,copy) NSString *designsId;
@property (nonatomic,copy) NSString *shareimg;
@property (nonatomic,copy) NSString *sharetitle;
@property (nonatomic,copy) NSString *descriptiontitle;

@end

static NSString *localnotesidentfid = @"localnotesidentfid";

@implementation LocalnotesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"装修故事";
    self.designsId = @"";
    self.shareimg = @"";
    self.sharetitle = @"";
    self.descriptiontitle = [NSString new];
    pagenum = 1;
    self.dataSource = [NSMutableArray array];
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.table.mj_header beginRefreshing];
    [self setupshare];
    
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
    NSString *cityId = self.cityId?:@"0";
    NSString *countyId = @"";
    countyId = self.countyId?:@"0";
    NSString *page = @"1";
    NSString *pageSize = @"15";
    NSDictionary *para = @{@"agencyId":agencyId,@"cityId":cityId,@"countyId":countyId,@"page":page,@"pageSize":pageSize};
    NSString *url = [BASEURL stringByAppendingString:Local_meiwen];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [self.dataSource removeAllObjects];
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[localnotesModel class] json:responseObj[@"data"][@"list"]]];
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
    NSString *countyId = @"";
    countyId = self.countyId;

    NSString *page = [NSString stringWithFormat:@"%d",pagenum];
    NSString *pageSize = @"15";
    NSDictionary *para = @{@"agencyId":agencyId,@"cityId":cityId,@"countyId":countyId,@"page":page,@"pageSize":pageSize};
    NSString *url = [BASEURL stringByAppendingString:Local_meiwen];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[localnotesModel class] json:responseObj[@"data"][@"list"]]];
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

- (LYShareMenuView *)shareMenuView{
    if (!_shareMenuView) {
        _shareMenuView = [[LYShareMenuView alloc] init];
        _shareMenuView.delegate = self;
    }
    return _shareMenuView;
}

#pragma mark - UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    localnotesCell *cell = [tableView dequeueReusableCellWithIdentifier:localnotesidentfid];
    cell = [[localnotesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:localnotesidentfid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setdata:self.dataSource[indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:kSCREEN_WIDTH tableView:self.table];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    localnotesModel *model = self.dataSource[indexPath.row];
    NewsActivityShowController *vc = [[NewsActivityShowController alloc]init];
    vc.designsId = model.designId;
    vc.activityType = 2;
    vc.companyPhone = model.companyPhone;
    vc.companyLandLine = model.companyLandline;
    vc.companyLogo = model.companyLogo;
    vc.companyName = model.companyName;
    vc.companyId = [NSString stringWithFormat:@"%ld",(long)model.companyId];
    vc.origin = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}


//分享
-(void)myTabVClick0:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.table indexPathForCell:cell];
    localnotesModel *model = self.dataSource[index.row];
    self.designsId = [NSString stringWithFormat:@"%ld",(long)model.designId];
    self.sharetitle = model.designTitle;
    
    if (IsNilString(model.designSubtitle)) {
        self.descriptiontitle = model.companyName;
    }
    else
    {
        self.descriptiontitle = model.designSubtitle;
    }
    
    self.shareimg = model.companyLogo;
    [self.shareMenuView show];
}
//评论
-(void)myTabVClick1:(UITableViewCell *)cell
{
    [[PublicTool defaultTool] publicToolsHUDStr:@"敬请期待" controller:self sleep:1.5];
}
//点赞
-(void)myTabVClick2:(UITableViewCell *)cell
{
    
    NSString *url = [BASEURL stringByAppendingString:Local_notezan];
    NSIndexPath *index = [self.table indexPathForCell:cell];
    localnotesModel *model = self.dataSource[index.row];
    
    if (model.iszan) {
        
    }
    else
    {
        self.designsId = [NSString stringWithFormat:@"%ld",(long)model.designId];
        NSDictionary *para = @{@"designsId":self.designsId};
        [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
            if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                model.likeNum = model.likeNum+1;
                model.iszan = YES;
                [self.table reloadData];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }

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
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/designs/%@/%@.htm?origin=%@",self.designsId,agencyId,@"1"]];
    
    switch (index) {
        case 0:
        {
            // QQ好友
            if ([TencentOAuth iphoneQQInstalled]) {

                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                
             
                UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareimg]]];
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];
                NSURL *url = [NSURL URLWithString:shareURL];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:self.sharetitle description:self.descriptiontitle previewImageData:data];
                
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"CalculatorTemplateShare"];
                    self.sharetitle = @"";
                    self.shareimg = @"";
                    self.designsId = @"";
                }
                self.sharetitle = @"";
                self.shareimg = @"";
                self.designsId = @"";
                self.descriptiontitle = @"";
            }
        }
            break;
        case 1:
        {
            // QQ空间
            if ([TencentOAuth iphoneQQInstalled]){
                
                UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareimg]]];
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];
                NSURL *url = [NSURL URLWithString:shareURL];
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:self.sharetitle description:self.descriptiontitle previewImageData:data];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"CalculatorTemplateShare"];
                    self.sharetitle = @"";
                    self.shareimg = @"";
                    self.designsId = @"";
                }
                self.sharetitle = @"";
                self.shareimg = @"";
                self.designsId = @"";
                self.descriptiontitle = @"";
            }
        }
            break;
        case 2:
        {
            //微信好友

            WXMediaMessage *message = [WXMediaMessage message];
            message.title = self.sharetitle;
            message.description = self.descriptiontitle;
            UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareimg]]];
            // 把图片设置成正方形
            CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
            shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
            UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
            [message setThumbImage:img];

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
                self.sharetitle = @"";
                self.shareimg = @"";
                self.designsId = @"";
            }
            self.sharetitle = @"";
            self.shareimg = @"";
            self.designsId = @"";
            self.descriptiontitle = @"";
        }
            break;
        case 3:
        {
            // 微信朋友圈
            WXMediaMessage *message = [WXMediaMessage message];

            message.title = self.sharetitle;
            message.description = self.descriptiontitle;
            UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareimg]]];
            // 把图片设置成正方形
            CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
            shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
            UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
            [message setThumbImage:img];
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
                self.sharetitle = @"";
                self.shareimg = @"";
                self.designsId = @"";
            }
            self.sharetitle = @"";
            self.shareimg = @"";
            self.designsId = @"";
            self.descriptiontitle = @"";
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
