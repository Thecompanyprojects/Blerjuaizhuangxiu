//
//  EliteDetailViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/25.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "EliteDetailViewController.h"
#import "NewMyPersonCardController.h"
#import "DesignCaseListModel.h"
#import "VoteOptionModel.h"
#import "WriteStoryViewController.h"

@interface EliteDetailViewController ()
@property (strong, nonatomic) UserInfoModel *user;
@end

@implementation EliteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    self.url = [NSString stringWithFormat:@"%@designs/elite/%ld/%ld/%ld.htm",BASEURL,(long)self.designsId,self.id?:(long)self.user.agencyId,(long)5];
    NSLog(@"%@",self.url);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.title = @"精英故事";
    [self.bottomV removeFromSuperview];
    if (self.user.agencyId == self.id) {
        [self setupRightButton];
    }
}

- (void)viewWillLayoutSubviews {
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_equalTo(isiPhoneX?88:64);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}

- (void)setupRightButton {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [rightButton setTitle:@"编辑" forState:(UIControlStateNormal)];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFixedSpace) target:nil action:nil];
    item.width = -7;
    self.navigationItem.rightBarButtonItems = @[item,rightItem];
    [rightButton addTarget:self  action:@selector(didTouchRightButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTouchRightButton {
    NSString *defaultApi = [BASEURL stringByAppendingString:@"designs/getDesignsDetailsByDesignsId.do"];
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"designsId":@(self.designsId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                WriteStoryViewController *vc = [[WriteStoryViewController alloc]init];
                NSDictionary *dict = responseObj[@"data"][@"design"];
                NSArray *temArray = [dict objectForKey:@"detailsList"];
                NSArray *dataArr = [NSArray yy_modelArrayWithClass:[DesignCaseListModel class] json:temArray];
                vc.designId = self.designsId;
                [vc.orialArray addObjectsFromArray:dataArr];
                [vc.dataArray addObjectsFromArray:dataArr];
                vc.voteDescribe = [dict objectForKey:@"voteDescribe"];
                vc.voteType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"voteType"]];
                vc.coverTitle = [dict objectForKey:@"designTitle"];
                vc.coverTitleTwo = [dict objectForKey:@"designSubtitle"];
                vc.musicStyle = [[dict objectForKey:@"musicPlay"]integerValue];
                vc.coverImgUrl = [dict objectForKey:@"coverMap"];
                vc.endTime = [dict objectForKey:@"voteEndTime"];
                vc.musicName = [dict objectForKey:@"musicName"] ;
                vc.musicUrl = [dict objectForKey:@"musicUrl"];
                vc.coverImgStr = [dict objectForKey:@"picUrl"] ;
                vc.nameStr = [dict objectForKey:@"picTitle"];
                vc.linkUrl = [dict objectForKey:@"picHref"];
                vc.isFistr = NO;
                //当前页面使用
                self.designTitle = [dict objectForKey:@"picUrl"];
                self.designSubTitle = [dict objectForKey:@"designSubtitle"];
                self.coverMap = [dict objectForKey:@"coverMap"];
                self.musicStyle = [[dict objectForKey:@"musicPlay"] integerValue];
                self.order = [[dict objectForKey:@"order"] integerValue];
                self.templateStr = [dict objectForKey:@"template"] ;
                NSArray *optionArray = [dict objectForKey:@"optionList"];
                NSArray *arrTwo = [NSArray yy_modelArrayWithClass:[VoteOptionModel class] json:optionArray];
                [vc.optionList addObjectsFromArray:arrTwo];
                NSDictionary *activityDict = [dict objectForKey:@"activity"];
                NSString *customStr =[activityDict objectForKey:@"custom"];
                if (customStr.length<=0) {
                    vc.setDataArray = [NSMutableArray array];
                }else{
                    NSData *data = [customStr dataUsingEncoding:NSUTF8StringEncoding];
                    id temID = [self toArrayOrNSDictionary:data];
                    if ([temID isKindOfClass:[NSArray class]]) {
                        NSArray *temArray = temID;
                        vc.setDataArray = [NSMutableArray array];
                        [vc.setDataArray addObjectsFromArray:temArray];
                    }else{
                        vc.setDataArray = [NSMutableArray array];
                    }
                }
                vc.customStr = customStr;
                vc.isFistr = NO;
                vc.unionId = 0;
                vc.companyName = @"";
                vc.companyLogo = @"";
                [self.navigationController pushViewController:vc animated:YES];
            }else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
            }else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL * url = [request URL];
    if ([[url scheme] isEqualToString:@"callphone"]) {//打电话
        NSLog(@"callphonecallphonecallphone");
        NSString *urlStr;
        NSArray *params =[url.query componentsSeparatedByString:@"=="];
        urlStr = [params[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",urlStr]]];
        return false;
    }
    if ([[url scheme] isEqualToString:@"startbusinesscard"]) {//点击头像
        NSLog(@"StartBusinessCard");
        NSArray *params = [url.query componentsSeparatedByString:@"&"];
        NSArray *arrayValue = [params[0] componentsSeparatedByString:@"="];
        NSString *agencyId = [arrayValue[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NewMyPersonCardController *controller = [NewMyPersonCardController new];
        controller.agencyId = agencyId;
        [self.navigationController pushViewController:controller animated:true];
        return false;
    }
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
