//
//  DistributionaboutVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DistributionaboutVC.h"
#import "distributionaboutCell0.h"
#import "distributionaboutCell1.h"
#import "distributionaboutCell2.h"
#import <WebKit/WebKit.h>
#import "DistributionaboutModel.h"
#import "destributionwebVC.h"
#import "disaboutCell.h"
#import "distributionaboutVC2.h"

@interface DistributionaboutVC ()<UITableViewDataSource,UITableViewDelegate,WKUIDelegate,WKNavigationDelegate,LYShareMenuViewDelegate,myTabVdelegate>
@property (nonatomic,strong) UITableView *table;

@property (nonatomic,strong) LYShareMenuView *shareMenuView;
// QQ分享
@property (nonatomic,strong) TencentOAuth *tencentOAuth;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSArray *selecrarry;
@property (nonatomic,strong) UIView *footView;
@end

static NSString *disaboutidentfid = @"disaboutidentfid";
static NSString *disaboutidentfid1 = @"disaboutidentfid1";
static NSString *disaboutidentfid2 = @"disaboutidentfid2";
static NSString *disaboutidentfid3 = @"disaboutidentfid3";

@implementation DistributionaboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"爱装修分销平台";
    self.dataSource = [NSMutableArray array];
    
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
    
    
    
    [self loaddata];
    [self.view addSubview:self.table];
    self.table.tableFooterView = self.footView;
    [self setupshare];
    
    self.selecrarry = @[@"http://api.bilinerju.com/api/designs/4278/23830.htm",@"http://api.bilinerju.com/api/designs/6266/23830.htm",@"http://api.bilinerju.com/api/designs/5358/23830.htm",@"http://api.bilinerju.com/api/designs/5750/23830.htm",@"http://api.bilinerju.com/api/designs/4405/23830.htm",@"http://api.bilinerju.com/api/designs/4934/23830.htm",@"http://api.bilinerju.com/api/designs/7179/23830.htm",@"http://api.bilinerju.com/api/designs/6704/23830.htm",@"http://api.bilinerju.com/api/designs/6270/23830.htm",@"http://api.bilinerju.com/api/designs/4863/23830.htm",@"http://api.bilinerju.com/api/designs/4572/23830.htm"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loaddata
{
    NSString *url = [@"http://api.bilinerju.com/api/" stringByAppendingString:@"designs/getDesignListByCompanyIdORAgencysId.do"];
    NSDictionary *para = @{@"agencysId":@"23830"};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [self.dataSource removeAllObjects];
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[DistributionaboutModel class] json:responseObj[@"data"][@"activityList"]]];
            [self.dataSource addObjectsFromArray:data];
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


-(UIView *)footView
{
    if(!_footView)
    {
        _footView = [[UIView alloc] init];
        _footView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 60);
        _footView.backgroundColor = [UIColor whiteColor];
        
    }
    return _footView;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return 1;
    }
    if (section==2) {
        return 1;
    }
    if (section==3) {
        return self.dataSource.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        distributionaboutCell0 *cell = [tableView dequeueReusableCellWithIdentifier:disaboutidentfid];
        if (!cell) {
            cell = [[distributionaboutCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:disaboutidentfid];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==1) {
        disaboutCell *cell = [tableView dequeueReusableCellWithIdentifier:disaboutidentfid2];
        if (!cell) {
            cell = [[disaboutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:disaboutidentfid2];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==2) {
        distributionaboutCell2 *cell = [tableView dequeueReusableCellWithIdentifier:disaboutidentfid3];
        cell = [[distributionaboutCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:disaboutidentfid3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==3) {
        distributionaboutCell1 *cell = [tableView dequeueReusableCellWithIdentifier:disaboutidentfid1];
        if (!cell) {
            cell = [[distributionaboutCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:disaboutidentfid1];
        }
        [cell setdata:self.dataSource[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 746/2;
    }
    if (indexPath.section==1) {
        return 140;
    }
    if (indexPath.section==2) {
        return 43;
    }
    else
    {
        return 100;
    }
    return 746/2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3) {
        destributionwebVC *vc = [destributionwebVC new];
        NSString *str = self.selecrarry[indexPath.row];
        vc.urlstr = str;
        [self.navigationController pushViewController:vc animated:YES];
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
    
    switch (index) {
        case 0:
        {
            // QQ好友
            if ([TencentOAuth iphoneQQInstalled]) {
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                NSString *shareURL = [BASEHTML stringByAppendingString:FENXIAO_WEB];
                NSURL *url = [NSURL URLWithString:shareURL];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:@"爱装修分销平台" description:@"" previewImageData:nil];
                
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
                
                NSString *shareURL = [BASEHTML stringByAppendingString:FENXIAO_WEB];
                NSURL *url = [NSURL URLWithString:shareURL];
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:@"爱装修分销平台" description:@"" previewImageData:nil];
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
            message.title = @"爱装修分销平台";
            message.description = @"";
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            NSString *shareURL = [BASEHTML stringByAppendingString:FENXIAO_WEB];
            //NSURL *url = [NSURL URLWithString:shareURL];
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
            NSString *shareURL = [BASEHTML stringByAppendingString:FENXIAO_WEB];
            message.title = @"爱装修分销平台";
            message.description = @"";

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

#pragma mark - 跳转
-(void)myTabVClick0:(UITableViewCell *)cell
{
    distributionaboutVC2 *vc = [distributionaboutVC2 new];
    vc.typestr = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)myTabVClick1:(UITableViewCell *)cell
{
    distributionaboutVC2 *vc = [distributionaboutVC2 new];
    vc.typestr = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)myTabVClick2:(UITableViewCell *)cell
{
    distributionaboutVC2 *vc = [distributionaboutVC2 new];
    vc.typestr = @"3";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)myTabVClick3:(UITableViewCell *)cell
{
    distributionaboutVC2 *vc = [distributionaboutVC2 new];
    vc.typestr = @"4";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
