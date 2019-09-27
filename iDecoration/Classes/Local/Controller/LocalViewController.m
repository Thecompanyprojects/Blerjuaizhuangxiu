//
//  LocalViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "LocalViewController.h"
#import "SNNavigationController.h"
#import "MeViewController.h"
#import <JPUSHService.h>
#import "ZCHCityModel.h"
#import "ScancodeController.h"
#import "LocalshopVC.h"
#import "AddressBookViewController.h"
#import "LocalwikipediaVC.h"
#import "ZCHNewLocationController.h"
#import <ICPagingManager/ICPagingManager.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UIButton+LXMImagePosition.h>
#import "ZCHCityModel.h"
#import "NewManagerViewController.h"
#import "NewMeViewController.h"
#import "KPNavigationDropdownMenu.h"


@interface LocalViewController ()<ICPagingManagerProtocol,CLLocationManagerDelegate>
{
    ZCHCityModel *cityModel;
}
@property (strong,nonatomic) CLLocationManager* locationManager;
/**
 注意Manager 要一直引用到这个控制器销毁，否则会使内部的代理失效
 */
@property (nonatomic, strong) ICPagingManager *manager;
@property (nonatomic, strong) UIButton *titleBtn;

@property (nonatomic,strong)KPNavigationDropdownMenu *topMenu ;
@end

@implementation LocalViewController
#pragma mark - LifeCircle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dingweixinxi" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (KPNavigationDropdownMenu *)topMenu {
    if(!_topMenu) {
        _topMenu = [[KPNavigationDropdownMenu alloc] initWithNavigationController:self.navigationController andTitles:@[@"定位中"]];
     
    }
    return _topMenu;
}


- (void)viewDidLoad {

    [super viewDidLoad];
    self.titleBtn = [[UIButton alloc] init];
    self.titleBtn.frame = CGRectMake(0, 0, 120, 44);
    self.titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.titleBtn setTitleColor:[UIColor whiteColor] forState:normal];
    [self.titleBtn setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
    [self.titleBtn setTitle:@"定位中..." forState:normal];
    [self.titleBtn addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBtn setImagePosition:LXMImagePositionRight spacing:2];

    [self startLocation];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.manager = [ICPagingManager manager];
    self.manager.delegate = self;
    [self.manager loadPagingWithConfig:^(ICSegmentBarConfig *config)
     {
         config.nor_color([UIColor darkGrayColor]);
         config.sel_color([UIColor blackColor]);
         config.line_color(Main_Color);
         config.backgroundColor = [UIColor clearColor];
     }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:@"dingweixinxi" object:nil];
    
    self.navigationItem.title = @"";
}

-(void)notice:(NSNotification *)sender{
    NSLog(@"%@",sender.object);
    NSArray *arr = sender.object;
    NSMutableArray *namearr = [NSMutableArray new];
    NSMutableArray *cityidarr = [NSMutableArray new];
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *dic = arr[i];
        NSString *name = [dic objectForKey:@"name"];
        NSString *cityid = [dic objectForKey:@"id"];
        [namearr addObject:name];
        [cityidarr addObject:cityid];
    }
    NSString *cityname = [[NSUserDefaults standardUserDefaults] objectForKey:@"dinweicity"];
    [namearr insertObject:cityname atIndex:0];
     _topMenu = [[KPNavigationDropdownMenu alloc] initWithNavigationController:self.navigationController andTitles:namearr];
    _topMenu.categoryBtnClicked = ^(UIButton *btn) {
        NSString *idstr = @"0";
        if (btn.tag==999) {
            idstr = @"0";
        }
        else
        {
            NSInteger intger = btn.tag-kOrderListCategoryButtonTagOffset-1;
            idstr = [cityidarr objectAtIndex:intger];
        }
        NSNotification *notification = [NSNotification notificationWithName:@"dingweichengshiid" object:idstr];
        [[NSNotificationCenter defaultCenter] postNotification:notification];

    };
     //self.navigationItem.titleView = self.topMenu;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.self.topMenu];
}

//调起城市选择

- (void)selectCity {


}

#pragma mark - 定位相关

//开始定位

-(void)startLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    NSString *lng = [NSString stringWithFormat:@"%f",oldCoordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",oldCoordinate.latitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
        
        [[NSUserDefaults standardUserDefaults] setObject:lng forKey:Local_dingweijindu];
        [[NSUserDefaults standardUserDefaults] setObject:lat forKey:Local_dingweiweidu];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //创建通知对象
        NSNotification *notification = [NSNotification notificationWithName:@"dingwei" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        if (placemarks.count==0) {
             [self.titleBtn setTitle:@"定位失败" forState:normal];
        }
        else
        {
            for (CLPlacemark *place in placemarks) {
                NSLog(@"name,%@",place.name);                      // 位置名
                NSLog(@"thoroughfare,%@",place.thoroughfare);      // 街道
                NSLog(@"subThoroughfare,%@",place.subThoroughfare);// 子街道
                NSLog(@"locality,%@",place.locality);              // 市
                NSLog(@"subLocality,%@",place.subLocality);        // 区
                NSLog(@"country,%@",place.country);                // 国家
           
                [self.titleBtn setTitle:place.locality forState:normal];
            }
        }
    }];
}

-(void)requestAlwaysAuthorization
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark icPagingComponetBaystyle
- (ICPagingComponentBarStyle)style
{
    return ICPagingComponentStyleNormal;
}

/**
 
 控制器集合
 @return 控制器集合
 */
- (NSArray<UIViewController *> *)pagingControllerComponentChildViewControllers
{
//    NSArray *array = @[[newlocalVC new],
//                       [AddressBookViewController new],
//                       [LocalshopVC new],
//                       [LocalwikipediaVC new]
//                       ];

    return [NSArray new];
}

/**
 选项卡标题
 
 @return @[]
 */
- (NSArray<NSString *> *)pagingControllerComponentSegmentTitles
{
//    return @[@"推荐",
//             @"通讯录",
//             @"本地商城",
//             @"家装百科"];
    return @[@"推荐"];
}

/**
 选项卡位置 适配iPhone X 则减去88
 
 @return rect
 */
- (CGRect)pagingControllerComponentSegmentFrame
{
    return CGRectMake(0, kNaviBottom, self.view.bounds.size.width, 0);
}

/**
 选项卡位置 中间控制器view 高度
 
 @return CGFloat
 */
- (CGFloat)pagingControllerComponentContainerViewHeight
{
    return self.view.bounds.size.height - kNaviBottom;
}

#pragma mark - 获取消息数量

- (void)getMessageNumData {
    if ([[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
            if (!agencyid||agencyid == 0) {
                agencyid = 0;
            }
            UserInfoModel *userInfo = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
            
            NSString *defaultApi = [BASEURL stringByAppendingString:@"message/getMessageNum.do"];
            NSDictionary *paramDic = @{
                                       @"agencyId":@(agencyid),
                                       @"phone": @(userInfo.phone.integerValue)
                                       };
            
            [NetManager afPostRequest:defaultApi parms:paramDic finished:^(NSDictionary *responseObj) {
                // 加载成功
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
                    if (code == 1000) {
                        NSDictionary *numDic = [responseObj objectForKey:@"data"];
                        NSMutableArray *numArray = [NSMutableArray array];
                        // 计算器报价消息数量
                        NSInteger calCount = [numDic[@"calCount"] integerValue];
                        [numArray addObject:@(calCount)];
                        //客户预约
                        NSInteger callDeco = [numDic[@"callDeco"] integerValue];
                        [numArray addObject:@(callDeco)];
                        //报名活动
                        NSInteger signupMessageNum = [numDic[@"signupMessageNum"] integerValue];
                        [numArray addObject:@(signupMessageNum)];
                        //公司申请
                        NSInteger companyApply = [numDic[@"companyApply"] integerValue];
                        [numArray addObject:@(companyApply)];
                        //联盟邀请
                        NSInteger invatationSum = [numDic[@"invatationSum"] integerValue];
                        [numArray addObject:@(invatationSum)];
                        //联盟申请
                        NSInteger unionApplyNum = [numDic[@"unionApplyNum"] integerValue];
                        [numArray addObject:@(unionApplyNum)];
                        
                        NSInteger totalNum = 0; // 云管理消息总数
                        for (int i = 0; i < numArray.count; i ++) {
                            totalNum += [numArray[i] integerValue];
                        }
                        if (totalNum > 0) {
                            [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld", totalNum]];
                        } else {
                            [self.tabBarItem setBadgeValue:nil];
                        }
                        
                        NSString *messageNUMStr = [NSString stringWithFormat:@"%ld", (long)totalNum];
                        SNNavigationController *navi = self.tabBarController.viewControllers[2];
                        NewManagerViewController *newManagerVC = navi.viewControllers[0];
                        
                        if (totalNum > 99) {
                            newManagerVC.tabBarItem.badgeValue = @"99+";
                        } else if (totalNum > 0) {
                            newManagerVC.tabBarItem.badgeValue = messageNUMStr;
                        } else {
                            newManagerVC.tabBarItem.badgeValue = nil;
                        }
                        
                        
                        // 个人中心有系统消息 和 使用说明提示
                        NSInteger systemNum = [numDic[@"complain"] integerValue];
                        // 所有消息总数
                        NSInteger allNum = [numDic[@"total"] integerValue];
                        
                        // 消息数量添加 使用说明提示
                        BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
                        if (kHasUseExpalinUpdate && !isReade) {
                            systemNum += 1;
                            allNum += 1;
                        }
                        NSString *systemNUMStr = [NSString stringWithFormat:@"%ld", (long)systemNum];
                        SNNavigationController *meNavi = self.tabBarController.viewControllers[3];
                        NewMeViewController *newMeVC = meNavi.viewControllers[0];
                        
                        if (systemNum > 99) {
                            newMeVC.tabBarItem.badgeValue = @"99+";
                        } else if (systemNum > 0) {
                            newMeVC.tabBarItem.badgeValue = systemNUMStr;
                        } else {
                            newMeVC.tabBarItem.badgeValue = nil;
                        }
                        
                        
                        [UIApplication sharedApplication].applicationIconBadgeNumber = allNum;
                        if (allNum == 0) {
                            [JPUSHService resetBadge];
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kTabBarItemBadageValueChange" object:nil];
                    }
                });
                
            } failed:^(NSString *errorMsg) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //加载失败
                    [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
                });
            }];
            
        });
        
    } else {
        // 消息数量添加 使用说明提示
        BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
        if (kHasUseExpalinUpdate && !isReade) {
            SNNavigationController *navi = self.tabBarController.viewControllers[3];
            NewMeViewController *meVC = navi.viewControllers[0];
            meVC.tabBarItem.badgeValue = @"1";
            [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
        } else {
            SNNavigationController *navi = self.tabBarController.viewControllers[3];
            MeViewController *meVC = navi.viewControllers[0];
            meVC.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
        // 云管理的
        SNNavigationController *navi = self.tabBarController.viewControllers[2];
        NewManagerViewController *newManagerVC = navi.viewControllers[0];
        newManagerVC.tabBarItem.badgeValue = nil;
    }
}

-(void)qrBtnClick:(UIButton *)btn{
    ScancodeController *vc = [[ScancodeController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
