//
//  ShopDetailController.m
//  iDecoration
//
//  Created by Apple on 2017/5/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ShopDetailController.h"
#import "ShopTitleTableViewCell.h"
#import "ShopDetailMidCell.h"
#import "ShopDetailBottomCell.h"
#import "CompanyPeopleInfoModel.h"
#import "AddCompanyPeopleController.h"
#import "VipDetailController.h"
#import "EditShopDetailController.h"
#import "BLEJBudgetTemplateController.h"
#import "CompanyDetailViewController.h"
#import "ZCHShopperManageViewController.h"
#import "EditCompanyPeopleController.h"
#import "ZCHGoodsShowController.h"
#import "AreaListModel.h"
#import "CreatShopController.h"
#import "ZCHPublicWebViewController.h"
#import "MeViewController.h"
#import "DecorationAreaViewController.h"
#import "ZCHCalculatorPayController.h"
#import "ZCHConstructionVipController.h"
#import "CooperativeEnterpriseViewController.h"
#import "UploadAdvertisementController.h"
#import "OrderToInformViewController.h"
#import "ShopDetailViewController.h"
#import "IntroductionToMemberPackagesViewController.h"
#import "NewMyPersonCardController.h"
#import "localcommunityVC.h"

//全景界面
#import "PanoramaViewController.h"

// 合作企业
#import "ZCHCooerateCompanyController.h"
#import "DateStatisticsViewController.h"
// 新闻活动
#import "ZCHNewsActivityController.h"
#import "BackGoodsListViewController.h"
#import "ZCHCashCouponController.h"
#import "VipGroupViewController.h"
#import "OnLineVipViewController.h"
#import "VipGroupViewController.h"
#import "CalculatorSetViewController.h"
#import "CompanyCertificationController.h"
#import "CertificateStatusController.h"
#import "CompanyIncomeController.h"
#import "CompanyMarginController.h"
#import "CertificationModel.h"
#import "chooseimplementVC.h"
#import "CertificateSuccessNewController.h"
#import "companybindingVC.h"
#import "NotVipYellowPageViewController.h"
#import "VIPExperienceViewController.h"
#import "Timestr.h"
#import "SpecialAlertView.h"
#import "DiscountPackageViewController.h"

@interface ShopDetailController ()<UITableViewDelegate,UITableViewDataSource,ShopDetailBottomCellDelegate,ShopTitleTableViewCellDelegat,UIAlertViewDelegate>{
    BOOL isShow;
    BOOL isEdit;//是否有权限删除人员(1.总经理不能删除自己，编辑自己)，添加人员()，修改公司()（只有总经理和经理可以）只有总经理不能退出公司
    NSInteger changeIndex;
    NSInteger _NOrW;//当前人是内网状态还是外网状态  0:内网  1:外网
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *areaArray;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *changeNetBtn;
@property (strong, nonatomic) TTAlertView *alertView;
// 是否有图片  0：没有  非0： 有
@property (nonatomic, assign) NSInteger hasImg;
@property (nonatomic, assign)CertificateStatus certificateStatus;
@property (nonatomic, strong)CertificationModel *cModel; // 认证信息
@property (nonatomic, strong)NSMutableArray *zhixinArray;
// 总经理， 执行经理 有公司认证 公司收入 交保证金 权限  执行经理权限和总经理相同
@property (nonatomic, strong) NSMutableArray *arrX;
// 经理 权限
@property (nonatomic, strong) NSMutableArray *arr;
// 设计师 权限
@property (nonatomic, strong) NSMutableArray *arrTwo;
// 普通员工 权限
@property (nonatomic, strong) NSMutableArray *arrThree;
@end

@implementation ShopDetailController

- (void)makeDataArray {
    if ([self.model.companyType integerValue] == 1018 || [self.model.companyType integerValue] == 1064 || [self.model.companyType integerValue] == 1065) {
        //总经理和经理显示全部，其余都不显示商家管理和数据统计
        //总经理和经理，设计师显示计算器模板，其余都不显示
        // 总经理 经理 设计师 显示 广告图管理 其他都不显示
        // 新增 所有人员可以看到计算器模板  总经理 经理  设计师以外的人不可以编辑
        // 新增 所有人都可以看到新闻活动
        // 新增促销代金券(所有人 但是经理总经理可以编辑 创建 删除)

        if (isCustomMadeHidden) {
            // 企业网会员
            self.arrX = @[@"公司认证",@"绑定账户", @"公司收入", @"交保证金",@"计算器模板",@"商品展示",@"全景展示",@"企业网站",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
            // 经理 权限
            self.arr = @[@"计算器模板",@"小区管理",@"商品展示",@"全景展示",@"企业网站",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
        }else{
            // 企业网会员
            self.arrX = @[@"公司认证",@"绑定账户", @"公司收入", @"交保证金",@"商家管理",@"计算器模板",@"商品展示",@"全景展示",@"企业网站",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
            // 经理 权限
            self.arr = @[@"商家管理",@"计算器模板",@"小区管理",@"商品展示",@"全景展示",@"企业网站",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
        }
        // 设计师 权限
        self.arrTwo = @[@"计算器模板",@"小区管理",@"商品展示",@"全景展示",@"企业网站",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
        // 普通员工 权限
        self.arrThree = @[ @"计算器模板",@"全景展示",@"企业网站",@"新闻活动",@"促销代金券"].mutableCopy;

        if (self.model.appVip.integerValue > 0) {
            // 企业网会员
            if (isCustomMadeHidden) {
                self.arrX = @[@"公司认证",@"绑定账户", @"公司收入", @"交保证金",@"计算器模板",@"小区管理",@"商品展示",@"全景展示",@"企业网站",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
                self.arr = @[@"计算器模板",@"小区管理",@"商品展示",@"全景展示",@"企业网站",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
            }else{
                self.arrX = @[@"公司认证",@"绑定账户", @"公司收入", @"交保证金",@"商家管理",@"计算器模板",@"商品展示",@"全景展示",@"企业网站",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
                self.arr = @[@"商家管理",@"计算器模板",@"小区管理",@"商品展示",@"全景展示",@"企业网站",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
            }
            // 经理 权限

            // 设计师 权限
            self.arrTwo = @[@"计算器模板",@"小区管理",@"商品展示",@"全景展示",@"企业网站",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
            // 普通员工 权限
            self.arrThree = @[ @"计算器模板",@"小区管理",@"全景展示",@"企业网站",@"新闻活动",@"促销代金券"].mutableCopy;
        } else {
            if (isCustomMadeHidden) {
                // 非企业网会员
                self.arrX = @[@"免费版企业网",@"公司认证",@"绑定账户", @"公司收入", @"交保证金",@"计算器模板",@"小区管理",@"商品展示",@"全景展示",@"企业网站",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
                // 经理 权限
                self.arr = @[@"免费版企业网",@"计算器模板",@"小区管理",@"商品展示",@"全景展示",@"企业网站",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
            }else{
                // 非企业网会员
                self.arrX = @[@"免费版企业网",@"公司认证",@"绑定账户", @"公司收入", @"交保证金",@"商家管理",@"计算器模板",@"小区管理",@"商品展示",@"全景展示",@"企业网站",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
                // 经理 权限
                self.arr = @[@"免费版企业网",@"商家管理",@"计算器模板",@"小区管理",@"商品展示",@"全景展示",@"企业网站",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
            }
            // 设计师 权限
            self.arrTwo = @[@"免费版企业网",@"计算器模板",@"小区管理",@"商品展示",@"全景展示",@"企业网站",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
            // 普通员工 权限
            self.arrThree = @[@"免费版企业网", @"计算器模板",@"小区管理",@"全景展示",@"企业网站",@"新闻活动",@"促销代金券"].mutableCopy;
        }
    } else {
        
        if (isCustomMadeHidden) {
            // 企业会员
         self.arrX = @[@"商家编号",@"公司认证", @"绑定账户",@"公司收入", @"交保证金",@"计算器模板",@"小区管理",@"商品展示",@"全景展示",@"店铺企业",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
            //            //经理 商铺展示只有经理和店面经理可以看到
            self.arr = @[@"商家编号",@"商品展示",@"全景展示",@"店铺企业",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
            //设计师
            self.arrThree = @[@"商家编号",@"商品展示",@"全景展示",@"店铺企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
            // 其他员工
            self.arrTwo = @[@"商家编号",@"全景展示",@"店铺企业",@"新闻活动",@"促销代金券"].mutableCopy;
        }else{
            // 企业会员
            self.arrX = @[@"商家编号",@"公司认证", @"绑定账户",@"公司收入", @"交保证金",@"计算器模板", @"入驻企业",@"商品展示",@"全景展示",@"店铺企业",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
            //            //经理 商铺展示只有经理和店面经理可以看到
            self.arr = @[@"商家编号",@"入驻企业",@"商品展示",@"全景展示",@"店铺企业",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
            //设计师
            self.arrThree = @[@"商家编号",@"入驻企业",@"商品展示",@"全景展示",@"店铺企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
            // 其他员工
            self.arrTwo = @[@"商家编号",@"入驻企业",@"全景展示",@"店铺企业",@"新闻活动",@"促销代金券"].mutableCopy;
        }

        if (self.model.appVip.integerValue > 0) {
            if (isCustomMadeHidden) {
                // 企业会员
             self.arrX = @[@"商家编号",@"公司认证", @"绑定账户",@"公司收入",@"交保证金", @"计算器模板",@"小区管理",@"全景展示",@"店铺企业",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
                //            //经理 商铺展示只有经理和店面经理可以看到
                self.arr = @[@"商家编号",@"商品展示",@"全景展示",@"店铺企业",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
                //设计师
                self.arrThree = @[@"商家编号",@"商品展示",@"全景展示",@"店铺企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
                // 其他员工
                self.arrTwo = @[@"商家编号",@"全景展示",@"店铺企业",@"新闻活动",@"促销代金券"].mutableCopy;
            }else{
                // 企业会员
                self.arrX = @[@"商家编号",@"公司认证", @"绑定账户",@"公司收入", @"交保证金",@"计算器模板",@"小区管理", @"入驻企业",@"商品展示",@"全景展示",@"店铺企业",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
                //            //经理 商铺展示只有经理和店面经理可以看到
                self.arr = @[@"商家编号",@"入驻企业",@"商品展示",@"全景展示",@"店铺企业",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
                //设计师
                self.arrThree = @[@"商家编号",@"入驻企业",@"商品展示",@"全景展示",@"店铺企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
                // 其他员工
                self.arrTwo = @[@"商家编号",@"入驻企业",@"全景展示",@"店铺企业",@"新闻活动",@"促销代金券"].mutableCopy;
            }
        } else {
            if (isCustomMadeHidden) {
                // 免费版企业网
                self.arrX = @[@"商家编号", @"免费版企业网",@"公司认证", @"绑定账户",@"公司收入", @"交保证金",@"计算器模板",@"小区管理",@"商品展示",@"全景展示",@"店铺企业",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
                //            //经理 商铺展示只有经理和店面经理可以看到
                self.arr = @[@"商家编号", @"免费版企业网",@"商品展示",@"全景展示",@"店铺企业",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
                //设计师
                self.arrThree = @[@"商家编号", @"免费版企业网",@"商品展示",@"全景展示",@"店铺企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
                // 其他员工
                self.arrTwo = @[@"商家编号", @"免费版企业网",@"全景展示",@"店铺企业",@"新闻活动",@"促销代金券"].mutableCopy;
            }else{
                // 免费版企业网
                self.arrX = @[@"商家编号", @"免费版企业网",@"公司认证", @"绑定账户",@"公司收入", @"交保证金",@"计算器模板",@"小区管理", @"入驻企业",@"商品展示",@"全景展示",@"店铺企业",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
                //            //经理 商铺展示只有经理和店面经理可以看到
                self.arr = @[@"商家编号", @"免费版企业网",@"入驻企业",@"商品展示",@"全景展示",@"店铺企业",@"合作企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
                //设计师
                self.arrThree = @[@"商家编号", @"免费版企业网",@"入驻企业",@"商品展示",@"全景展示",@"店铺企业",@"新闻活动",@"促销代金券",@"广告图管理"].mutableCopy;
                // 其他员工
                self.arrTwo = @[@"商家编号", @"免费版企业网",@"入驻企业",@"全景展示",@"店铺企业",@"新闻活动",@"促销代金券"].mutableCopy;
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.areaArray = [NSMutableArray array];
    self.zhixinArray = [NSMutableArray array];
    [self makeDataArray];
    [self getCertificationStatus];
    isShow = NO;
    [self creatUI];
    [self requestAreaList];
    self.hasImg = 1;
    [self showalertView];
    [self getCompanyList];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    isShow = NO;
}

- (void)creatUI {

    self.view.backgroundColor = White_Color;
    self.navigationItem.title = self.model.companyName;
    [self.view addSubview:self.tableView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAreaList) name:@"refreshPeopleList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:@"zhixinjingli" object:nil];
    NSInteger jobId = [self.jobId integerValue];

    isEdit = false;
    if (jobId == 1002 || self.model.implement) {
        isEdit = true;
    }

    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(editCompany) forControlEvents:UIControlEventTouchUpInside];
    self.editBtn = editBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];

    if (!isEdit) {
        self.editBtn.hidden = YES;
    }
    else{
        self.editBtn.hidden = NO;
    }
    UIBarButtonItem *rightbarItem = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn];
    self.navigationItem.rightBarButtonItem = rightbarItem;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAreaList) name:@"companyAgencysNot" object:nil];

    NSString *modiArea =  [[NSUserDefaults standardUserDefaults] objectForKey:@"modiArea"];


    if (!modiArea||[modiArea isEqualToString:@"0"]) {
        //没有提示过
        NSString *requestStr = [BASEURL stringByAppendingString:@"user/getChangeCompareVersion.do"];
        [NetManager afGetRequest:requestStr parms:nil finished:^(id responseObj) {
            if ([responseObj[@"code"] integerValue] == 1000) {
                NSDictionary *dict = responseObj[@"data"];
                NSString *version = dict[@"version"];
                if ([version isEqualToString:@"4.2.0"]) {
                    //                    [self popTishi];
                }
            }

        } failed:^(NSString *errorMsg) {

        }];
    }

}

-(void)showalertView
{
    NSInteger timeint = [Timestr creatdatetime:self.model.vipEndTime];
    NSString *time2 = [NSString stringWithFormat:@"%@",self.model.vipEndTime];
    if (timeint<=14&&timeint>0) {
        
        //弹出试图通知会员到期
        
        SpecialAlertView *special = [[SpecialAlertView alloc]initWithTime:time2 messageTitle:@"尊贵的会员用户" messageString:@"" sureBtnTitle:@"续费" sureBtnColor:[UIColor blueColor]];
        [special withSureClick:^(NSString *string) {
            
            DiscountPackageViewController *vc = [DiscountPackageViewController new];
            vc.companyId = self.model.companyId;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
    }
}

#pragma mark - 提醒修改装修区域
- (void)popTishi {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"本版本修复装修区域无法接单问题，为保证使用正确，需要重新编辑装修区域"
                                                   delegate:self
                                          cancelButtonTitle:@"我知道了"
                                          otherButtonTitles:nil,nil];
    [alert show];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"modiArea"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            if ([self.model.companyType integerValue] == 1018 || [self.model.companyType integerValue] == 1064 || [self.model.companyType integerValue] == 1065) {
                //总经理和经理显示全部，其余都不显示商家管理和数据统计
                //总经理和经理，设计师显示计算器模板，其余都不显示
                NSInteger agencyJob = [self.model.agencysJob integerValue];
                if (agencyJob == 1002 || self.implement) {
                    rows = self.arrX.count;
                }else if (agencyJob ==1003) {
                    rows = self.arr.count;
                }else if (agencyJob == 1010) {
                    rows = self.arrTwo.count;
                }else{
                    rows = self.arrThree.count;
                }
            } else {
                //店铺
                //商铺展示和数据统计 只有经理和店面经理可以看到
                NSInteger agencyJob = [self.model.agencysJob integerValue];
                if (agencyJob == 1002 || self.implement) { // 总经理 执行经理
                    rows = self.arrX.count;
                }else if (agencyJob ==1027) { // 经理
                    rows = self.arrX.count;
                }else if (agencyJob == 1029) { // 有设计师
                    rows = self.arrTwo.count;
                }else{
                    // 其他人员
                    rows = self.arrThree.count;
                }
            }
            break;
        case 2:
            return self.dataArray.count;//变量
            break;
        default:
            break;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 2) {

        return 50;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if (section == 0) {

        return 0.001;
    }
    if (section==2) {
        return 200;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 2) {

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50)];
        view.backgroundColor = RGB(247, 247, 247);
        UILabel *numL = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, view.height)];
        numL.textColor = COLOR_BLACK_CLASS_3;
        numL.font = [UIFont systemFontOfSize
                     :17];
        numL.textAlignment = NSTextAlignmentLeft;
        numL.text = [NSString stringWithFormat:@"公司成员( %ld人 )",(unsigned long)self.dataArray.count];

        [view addSubview:numL];

        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(kSCREEN_WIDTH-30-15, 10, 30, 30);
        [addBtn setBackgroundImage:[UIImage imageNamed:@"ty_add"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(goAddPeopleVC) forControlEvents:UIControlEventTouchUpInside];
        addBtn.layer.masksToBounds = YES;

        [view addSubview:addBtn];

        UIButton *reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reduceBtn.frame = CGRectMake(addBtn.left-10-30, addBtn.top, addBtn.width, addBtn.height);
        [reduceBtn setBackgroundImage:[UIImage imageNamed:@"ty_reduce"] forState:UIControlStateNormal];
        [reduceBtn addTarget:self action:@selector(reducePeople) forControlEvents:UIControlEventTouchUpInside];

        [view addSubview:reduceBtn];
        reduceBtn.hidden = addBtn.hidden = !isEdit;
        return view;
    }
    return [[UIView alloc]init];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (section == 2) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 80)];
        view.backgroundColor = White_Color;


        UIButton *quitCompanyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        quitCompanyBtn.frame = CGRectMake(kSCREEN_WIDTH/8, 20, kSCREEN_WIDTH/4*3, 40);
        quitCompanyBtn.backgroundColor = Red_Color;
        quitCompanyBtn.layer.cornerRadius = 5.0f;
        quitCompanyBtn.layer.masksToBounds = YES;
        [quitCompanyBtn setTitle:@"退出公司" forState:UIControlStateNormal];
        [quitCompanyBtn addTarget:self action:@selector(signOutCompany) forControlEvents:UIControlEventTouchUpInside];
        if ([self.jobId integerValue]==1002){
            quitCompanyBtn.hidden = YES;
        }
        else{
            quitCompanyBtn.hidden = NO;
        }
        [view addSubview:quitCompanyBtn];

        UIButton *changeInnerOrOut = [UIButton buttonWithType:UIButtonTypeCustom];
        changeInnerOrOut.frame = CGRectMake(quitCompanyBtn.left, quitCompanyBtn.bottom+20, quitCompanyBtn.width, quitCompanyBtn.height);
        changeInnerOrOut.backgroundColor = Main_Color;
        if (self.dataArray.count) {
            if (!_NOrW) {
                //内网状态
                [changeInnerOrOut setTitle:@"切换至外网" forState:UIControlStateNormal];
            }
            else{
                //外网状态
                [changeInnerOrOut setTitle:@"切换至内网" forState:UIControlStateNormal];
            }
        }
        changeInnerOrOut.titleLabel.font = [UIFont systemFontOfSize:17];
        changeInnerOrOut.layer.cornerRadius = 5.0f;
        changeInnerOrOut.layer.masksToBounds = YES;
        [changeInnerOrOut addTarget:self action:@selector(changeNet:) forControlEvents:UIControlEventTouchUpInside];
        self.changeNetBtn = changeInnerOrOut;
        [view addSubview:self.changeNetBtn];


        if ([self.model.companyType integerValue]==1018 || [self.model.companyType integerValue] == 1064 || [self.model.companyType integerValue] == 1065) {

            self.changeNetBtn.hidden = isCustomMadeHidden;
            if (![self.model.customizedVip integerValue]) {
                //不是会员
                self.changeNetBtn.tag = 100;
                [self.changeNetBtn setTitle:@"切换网络" forState:UIControlStateNormal];
            }else{
                //是会员
                self.changeNetBtn.tag = 200;
            }
        }else{
            self.changeNetBtn.hidden = YES;
        }

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =  CGRectMake(kSCREEN_WIDTH/8, 20, kSCREEN_WIDTH/4*3, 40);
        btn.backgroundColor = Main_Color;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;
        [btn setTitle:@"设置执行经理" forState:normal];
        [btn addTarget:self action:@selector(setimplementclick) forControlEvents:UIControlEventTouchUpInside];

        if ([self.jobId intValue]==1002&&self.dataArray.count!=1) {
            [view addSubview:btn];
        }
        return view;
    }
    return [[UIView alloc]init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {

        return  215;
    } else {

        return 60;
    }
}


#pragma mark ShopDetailBottomCellDelegate

-(void)deletePeopleWith:(NSInteger)tag{

    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    CompanyPeopleInfoModel *model = self.dataArray[tag];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"companyAgencys/delete.do"];
    NSDictionary *paramDic = @{@"id":@(model.id),
                               @"companyId":self.model.companyId,
                               @"agencyId":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {

        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {

            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];

            switch (statusCode) {
                case 1000:

                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"删除成功" controller:self sleep:1.5];
                    [self requestAreaList];
                }
                    break;

                case 1001:

                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"id不存在" controller:self sleep:1.5];
                }
                    break;

                case 1004:

                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"对不起，你没有权限" controller:self sleep:1.5];
                }
                    break;

                case 2000:

                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1.5];
                }
                    break;
                default:
                    [[PublicTool defaultTool] publicToolsHUDStr:@"服务器异常" controller:self sleep:1.5];
                    break;
            }
        }
    } failed:^(NSString *errorMsg) {
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

- (void)modifyJobWith:(NSInteger)tag {

    CompanyPeopleInfoModel *model = self.dataArray[tag];
    EditCompanyPeopleController *vc = [[EditCompanyPeopleController alloc]init];

    if ([self.model.companyType integerValue]==1018 || [self.model.companyType integerValue] == 1064 || [self.model.companyType integerValue] == 1065){
        vc.comPanyOrShop = 1;
    }
    else{
        vc.comPanyOrShop = 2;
    }
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lookDetailInfo:(NSInteger)tag {

    CompanyPeopleInfoModel *model = self.dataArray[tag];
    NewMyPersonCardController *vc = [[NewMyPersonCardController alloc]init];
    vc.agencyId = model.agencysId;
    //    vc.fromIndex = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ShopTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopTitleTableViewCellSecond"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ShopTitleTableViewCell" owner:nil options:nil][1];
        }
        cell.delegate = self;
        cell.jobId = self.jobId;
        cell.companyIdlab.text = [NSString stringWithFormat:@"%@%@",@"id:",self.model.companyId];
        [cell configData:self.model];
        cell.certificateBtn.hidden = NO;
        cell.addressLabelTarilingCon.constant = 82;
        cell.certificateStateImageV.hidden = YES;
//        cell.scrollView.scrollEnabled = self.model.svip;
        switch (self.certificateStatus) {
            case CertificateStatusUnPay: // 未支付
            {
                [cell.certificateBtn setTitle:@"未认证" forState:UIControlStateNormal];
            }
                break;
            case CertificateStatusUnderway: // 认证中
            {
                [cell.certificateBtn setTitle:@"认证中" forState:UIControlStateNormal];
            }
                break;
            case CertificateStatusFailure: // 认证失败
            {
                [cell.certificateBtn setTitle:@"未通过" forState:UIControlStateNormal];
            }
                break;
            case CertificateStatusTimeOut: // 认证过期
            {
                [cell.certificateBtn setTitle:@"已过期" forState:UIControlStateNormal];
            }
                break;
            case CertificateStatusSuccess: // 认证通过
            {
                cell.certificateBtn.hidden = YES;
                cell.addressLabelTarilingCon.constant = 10;
                cell.certificateStateImageV.hidden = NO;
            }
                break;
            case CertificateStatusUnknown: // 未认证过
            {
                [cell.certificateBtn setTitle:@"未认证" forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        // 总经理和执行经理才有公司认证
        NSInteger agencyJob = [self.model.agencysJob integerValue];
        if (!(agencyJob == 1002 || self.implement)) {
            cell.certificateBtn.hidden = YES;
            cell.addressLabelTarilingCon.constant = 10;
        }
        return cell;
    }
    if (indexPath.section == 1) {
        ShopDetailMidCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailMidCell"];
        cell.contentL.hidden = YES;
        cell.flagLabel.hidden = YES;
        NSInteger agencyJob = [self.model.agencysJob integerValue];
        if (KIsCompany(self.model.companyType)) {
            if (self.implement) { // 执行经理
                [cell configData:self.arrX[indexPath.row]];
                if (indexPath.row == 14) {
                    cell.contentL.text = @"请上传广告图";
                    cell.contentL.textColor = [UIColor lightGrayColor];
                    cell.contentL.hidden = NO;
                    if (self.hasImg == 0) { // 没有广告图
                        cell.ContentLRightCon.constant = 32;
                        cell.flagLabel.hidden = NO;
                    }else{
                        cell.ContentLRightCon.constant = 10;
                        cell.flagLabel.hidden = YES;
                    }
                }
            }else{
                if (agencyJob == 1002) { // 总经理
                    [cell configData:self.arrX[indexPath.row]];
                    if (indexPath.row == 14) {
                        cell.contentL.text = @"请上传广告图";
                        cell.contentL.textColor = [UIColor lightGrayColor];
                        cell.contentL.hidden = NO;
                        if (self.hasImg == 0) { // 没有广告图
                            cell.ContentLRightCon.constant = 32;
                            cell.flagLabel.hidden = NO;
                        } else {
                            cell.ContentLRightCon.constant = 10;
                            cell.flagLabel.hidden = YES;
                        }
                    }
                }else if (agencyJob ==1003) {//  经理
                    [cell configData:self.arr[indexPath.row]];
                    if (indexPath.row == 10) {
                        cell.contentL.text = @"请上传广告图";
                        cell.contentL.textColor = [UIColor lightGrayColor];
                        cell.contentL.hidden = NO;
                        if (self.hasImg == 0) { // 没有广告图
                            cell.ContentLRightCon.constant = 32;
                            cell.flagLabel.hidden = NO;
                        } else {
                            cell.ContentLRightCon.constant = 10;
                            cell.flagLabel.hidden = YES;
                        }
                    }
                }else if (agencyJob == 1010) {// 设计师
                    [cell configData:self.arrTwo[indexPath.row]];
                    if (indexPath.row == 8) {
                        cell.contentL.text = @"请上传广告图";
                        cell.contentL.textColor = [UIColor lightGrayColor];
                        cell.contentL.hidden = NO;
                        if (self.hasImg == 0) {
                            cell.ContentLRightCon.constant = 32;
                            cell.flagLabel.hidden = NO;
                        }else{
                            cell.ContentLRightCon.constant = 10;
                            cell.flagLabel.hidden = YES;
                        }
                    }
                }else{// 其他人
                    [cell configData:self.arrThree[indexPath.row]];
                }
            }
        }else{
            NSInteger agencyJob = [self.model.agencysJob integerValue];
            if (self.implement) {// 执行经理
                [cell configData:self.arrX[indexPath.row]];
                if (indexPath.row == 13) {
                    cell.contentL.text = @"请上传广告图";
                    cell.contentL.textColor = [UIColor lightGrayColor];
                    cell.contentL.hidden = NO;
                    if (self.hasImg == 0) {
                        cell.ContentLRightCon.constant = 32;
                        cell.flagLabel.hidden = NO;
                    } else {
                        cell.ContentLRightCon.constant = 10;
                        cell.flagLabel.hidden = YES;
                    }
                }
            } else {
                if (agencyJob == 1002) {// 总经理
                    [cell configData:self.arrX[indexPath.row]];
                    if (indexPath.row == 13) {
                        cell.contentL.text = @"请上传广告图";
                        cell.contentL.textColor = [UIColor lightGrayColor];
                        cell.contentL.hidden = NO;
                        if (self.hasImg == 0) {
                            cell.ContentLRightCon.constant = 32;
                            cell.flagLabel.hidden = NO;
                        } else {
                            cell.ContentLRightCon.constant = 10;
                            cell.flagLabel.hidden = YES;
                        }
                    }
                } else if (agencyJob ==1027) {// 店面经理
                    [cell configData:self.arrX[indexPath.row]];
                    if (indexPath.row == 9) {
                        cell.contentL.text = @"请上传广告图";
                        cell.contentL.textColor = [UIColor lightGrayColor];
                        cell.contentL.hidden = NO;
                        if (self.hasImg == 0) {
                            cell.ContentLRightCon.constant = 32;
                            cell.flagLabel.hidden = NO;
                        } else {
                            cell.ContentLRightCon.constant = 10;
                            cell.flagLabel.hidden = YES;
                        }
                    }
                } else if (agencyJob == 1029) {// 设计师
                    [cell configData:self.arrThree[indexPath.row]];
                    if (indexPath.row == 8) {
                        cell.contentL.text = @"请上传广告图";
                        cell.contentL.textColor = [UIColor lightGrayColor];
                        cell.contentL.hidden = NO;
                        if (self.hasImg == 0) {
                            cell.ContentLRightCon.constant = 32;
                            cell.flagLabel.hidden = NO;
                        } else {
                            cell.ContentLRightCon.constant = 10;
                            cell.flagLabel.hidden = YES;
                        }
                    }
                }else{// 其他人员
                    [cell configData:self.arrTwo[indexPath.row]];
                }
            }
        }
        NSString *str = @"";
        if (indexPath.row == 0) {// 装修区域
            if ([self.model.companyType integerValue] == 1018 || [self.model.companyType integerValue] == 1064 || [self.model.companyType integerValue] == 1065) {
                //公司
//                if (self.areaArray.count) {
//                    for (AreaListModel *areaModel in self.areaArray) {
//                        NSArray *arr = [areaModel.retion componentsSeparatedByString:@" "];
//                        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@ ", arr.lastObject]];
//                    }
//                }
                cell.contentL.text = str;
                cell.contentL.hidden = NO;
            } else {
                //店铺
                cell.contentL.text = self.model.merchantNo;
                cell.contentL.hidden = NO;
            }
        }
        return cell;
    }
    if (indexPath.section==2) {
        ShopDetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailBottomCell"];
        CompanyPeopleInfoModel *model = self.dataArray[indexPath.row];
        [cell configData:model];

        //        NSString *str = @"";
        //
        //        if ([model.implement isEqualToString:@"1"]) {
        //
        //        }

        [cell setImg:model.implement];
        cell.tag = indexPath.row;
        cell.delegate = self;
        NSInteger jobId = [self.jobId integerValue];
        if (!isShow) {
            cell.deleteBtn.hidden = YES;
        }else{//不允许删除总经理
            if ([model.agencysJob integerValue]==1002) {
                cell.deleteBtn.hidden = YES;
            }else{//如果自己是经理并且当前cell也是经理 && 如果自己是店面经理并且当前cell也店面是经理
                if ((jobId == 1003&&[model.agencysJob integerValue]==1003)||(jobId == 1027&&[model.agencysJob integerValue]==1027)) {
                    cell.deleteBtn.hidden = YES;
                }else if ([model.implement isEqualToString:@"1"] && self.model.implement){
                    cell.deleteBtn.hidden = YES;
                }else {
                    cell.deleteBtn.hidden = NO;
                }
            }
        }

        if (jobId == 1002 ||jobId == 1003 ||jobId == 1027||self.implement) {
            if (jobId == 1002||self.implement) {
                if ([model.agencysJob integerValue]==1002) {
                    cell.modefyJobBtn.hidden = YES;
                } else {
                    cell.modefyJobBtn.hidden = NO;
                }
            } else if (jobId == 1003) {
                if ([model.agencysJob integerValue]==1002||[model.agencysJob integerValue]==1003) {
                    cell.modefyJobBtn.hidden = YES;
                } else {
                    cell.modefyJobBtn.hidden = NO;
                }
            } else {
                if ([model.agencysJob integerValue]==1002||[model.agencysJob integerValue]==1003||[model.agencysJob integerValue]==1027) {
                    cell.modefyJobBtn.hidden = YES;
                } else {
                    cell.modefyJobBtn.hidden = NO;
                }
            }
        } else {

            cell.modefyJobBtn.hidden = YES;
        }
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        ShopDetailMidCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *titleStr = cell.titleL.text;
        NSInteger agencyJob = [self.model.agencysJob integerValue];

        if ([titleStr isEqualToString:@"装修区域"]) {
            //装修区域
            DecorationAreaViewController *areaVC = [[DecorationAreaViewController alloc] init];
            areaVC.listArray = self.areaArray;
            NSInteger jobId = [self.jobId integerValue];
            if (jobId == 1002||self.implement) {
                // 只有总经理 经理  可以编辑装修区域
                areaVC.type = @"1";
            } else {
                areaVC.type = @"2";
            }
            __weak typeof(self) weakSelf = self;
            areaVC.refreshBlock = ^(NSArray *areaArr) {

                NSData *data = [NSJSONSerialization dataWithJSONObject:areaArr options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                NSString *defaultApi = [BASEURL stringByAppendingString:@"area/upArea.do"];
                NSDictionary *paramDic = @{@"companyId":weakSelf.model.companyId,
                                           @"areaList":jsonStr
                                           };
                [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {

                    if (responseObj && [responseObj[@"code"] integerValue] == 1000) {

                        [weakSelf.areaArray removeAllObjects];
                        NSArray *arr2 = [NSArray yy_modelArrayWithClass:[AreaListModel class] json:jsonStr];
                        [weakSelf.areaArray addObjectsFromArray:arr2];

                    }
                    [self.tableView reloadData];
                } failed:^(NSString *errorMsg) {

                }];
            };
            [self.navigationController pushViewController:areaVC animated:YES];
        }

        if ([titleStr isEqualToString:@"免费版企业网"]) {
            NotVipYellowPageViewController *vc = [NotVipYellowPageViewController new];
            self.model.certificateStatus = self.certificateStatus;
            vc.companyID = self.model.companyId;
            vc.noVipDesignId = self.model.noVipDesignId;
            vc.companyName = self.model.companyName;
            NSInteger agencyJob = [self.model.agencysJob integerValue];
            vc.agencyJob= agencyJob;
            vc.isImplement = self.implement;
            vc.modelSubsidiary = self.model;
            vc.isEdit = isEdit;
            
            vc.origin = @"2";
            
            [self.navigationController pushViewController:vc animated:YES];
        }

        if ([titleStr isEqualToString:@"公司认证"]){

            [self gotoCertificateAction];

        }
        if ([titleStr isEqualToString:@"绑定账户"]){
            companybindingVC *vc = [companybindingVC new];
            vc.companyId = self.model.companyId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([titleStr isEqualToString:@"公司收入"]) {
            CompanyIncomeController *vc = [[CompanyIncomeController alloc ] initWithNibName:@"CompanyIncomeController" bundle:nil];
            vc.companyId = self.model.companyId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([titleStr isEqualToString:@"交保证金"]) {
            CompanyMarginController *vc = [[CompanyMarginController alloc ] initWithNibName:@"CompanyMarginController" bundle:nil];
            vc.companyId = self.model.companyId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([titleStr isEqualToString:@"商家管理"]){
            //商家管理
            if (self.model.customizedVip == nil || [self.model.customizedVip integerValue] <= 0 || self.model.customizedVip.length <= 0) {
                TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:nil message:@"您还不是定制公司，请联系客服开通！" clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {

                    switch (buttonIndex) {
                        case 0:
                        {
                            ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
                            VC.titleStr = @"定制详情";
                            VC.webUrl = @"resources/html/vipxiangqing.html";
                            [self.navigationController pushViewController:VC animated:YES];
                            break;
                        }
                        case 1:
                        {
                            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"18956706605"];
                            UIWebView *callWebview = [[UIWebView alloc] init];
                            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
                        }
                            break;
                        default:
                            break;
                    }
                } cancelButtonTitle:nil otherButtonTitles:@"定制详情", @"联系客服", nil];
                self.alertView = alertView;
                [alertView show];

                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
                tap.numberOfTapsRequired = 1;
                tap.cancelsTouchesInView = NO;
                [[UIApplication sharedApplication].keyWindow addGestureRecognizer:tap];

            } else {
                // 跳转到商家管理
                ZCHShopperManageViewController *VC = [[ZCHShopperManageViewController alloc] init];
                VC.companyID = self.model.companyId;
                VC.VIPType = self.model.customizedVip;
                [self.navigationController pushViewController:VC animated:YES];
            }
        }
        if ([titleStr isEqualToString:@"计算器模板"]){

           
            BLEJBudgetTemplateController *VC = [[BLEJBudgetTemplateController alloc] init];
            MJWeakSelf;
            VC.refreshBlock = ^(){
                [weakSelf getCompanyList];
            };
            VC.companyID = self.model.companyId;
            VC.companyLogo = self.model.companyLogo;
            VC.model = self.model;
            if (agencyJob == 1010||agencyJob == 1002||agencyJob ==1003||self.implement) {  // 设计师可以编辑 其他人不可以编辑
                VC.isCanEdit = YES;
            } else {
                VC.isCanEdit = NO;
            }
            [self.navigationController pushViewController:VC animated:YES];
        }
        if ([titleStr isEqualToString:@"小区管理"]) {
            localcommunityVC *vc = [localcommunityVC new];
            vc.cityId = _model.companyCity;
            vc.countyId = _model.companyCounty;
            vc.ischange = YES;
            vc.companyId = self.model.companyId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([titleStr isEqualToString:@"入驻企业"]){
            CooperativeEnterpriseViewController *cooVC = [[CooperativeEnterpriseViewController alloc] init];
            cooVC.companyID = self.model.companyId;
            [self.navigationController pushViewController:cooVC animated:YES];
        }
        if ([titleStr isEqualToString:@"商品展示"]){
            // 设计师 商品展示
            int a = [self.model.appVip intValue];
            if (a == 1) {
                BackGoodsListViewController *vc = [[BackGoodsListViewController alloc] init];
                vc.shopId = self.model.companyId;
                vc.agencJob = agencyJob;
                vc.companyType = self.model.companyType;
                vc.implement = self.implement;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                // 过期
                [self showViewWithoutOpenVIP];
            }
        }

        if ([titleStr isEqualToString:@"全景展示"]){
            NSInteger a = [self.model.appVip integerValue];

            if (!a) {
                //未开通会员
                [self showViewWithoutOpenVIP];
            } else {

                PanoramaViewController *full = [[PanoramaViewController alloc]init];
                full.shopID = self.model.companyId;
                full.jobId = self.jobId;
                full.origin = @"2";
                NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:self.model.companyId,@"companyId",
                                      self.model.companyType,@"companyType",
                                      self.model.companyLandline,@"companyLandline",
                                      self.model.companyPhone,@"companyPhone",
                                      self.model.companyName,@"companyName", nil];
                full.dataDic = dict;
                [self.navigationController  pushViewController:full animated:YES];
            }

        }

        if ([titleStr isEqualToString:@"企业网站"] || [titleStr isEqualToString:@"店铺企业"]){
            int a = [self.model.appVip intValue];

            if (a == 1) {
                //未过期
                if ([self.model.companyType integerValue]==1018 || [self.model.companyType integerValue] == 1064 || [self.model.companyType integerValue] == 1065) {
                    CompanyDetailViewController *VC = [[CompanyDetailViewController alloc] init];
                    VC.companyID = self.model.companyId;
                    VC.companyName = self.model.companyName;
                    VC.origin = @"2";
                    [self.navigationController pushViewController:VC animated:YES];
                }
                else{
                    ShopDetailViewController *VC = [[ShopDetailViewController alloc] init];

                    VC.shopID = self.model.companyId;
                    VC.shopName = self.model.companyName;
                    VC.origin = @"2";
                    [self.navigationController pushViewController:VC animated:YES];
                }


            } else {
                // 过期
                [self showViewWithoutOpenVIP];
            }
        }
        if ([titleStr isEqualToString:@"新闻活动"]){
            ZCHNewsActivityController *newsVC = [[ZCHNewsActivityController alloc] init];
            newsVC.model = self.model;
            newsVC.implement = self.implement;
            __weak typeof(self) weakSelf = self;
            newsVC.ZCHNewsActivityVipBlock = ^{
                weakSelf.model.calVip = @"1";
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:newsVC animated:YES];
        }

        if ([titleStr isEqualToString:@"促销代金券"]){
            if ([self.model.calVip isEqualToString:@"0"]) {
                TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"充值公司号码通" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {

                    if (buttonIndex == 1) {
                        // 会员套餐
                        VipGroupViewController *VC = [[UIStoryboard storyboardWithName:@"VipGroupViewController" bundle:nil] instantiateInitialViewController];
                        VC.companyId = self.model.companyId;
                        //                        __weak typeof(self) weakSelf = self;
                        VC.successBlock = ^() {

                        };
                        [self.navigationController pushViewController:VC animated:YES];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
            } else {
                ZCHCashCouponController *VC = [[ZCHCashCouponController alloc] init];
                VC.isCanNew = YES;
                //经理，总经理，设计师有权限创建代金券和礼品券
                if (agencyJob==1002||agencyJob==1003||agencyJob==1027||agencyJob==1010||agencyJob==1029||self.implement) {
                    VC.isCanNewCoupon = YES;
                }
                else{
                    VC.isCanNewCoupon = NO;
                }

                VC.companyId = self.model.companyId;
                VC.companyName = self.model.companyName;
                [self.navigationController pushViewController:VC animated:YES];
            }
        }
        if ([titleStr isEqualToString:@"合作企业"]){
            ZCHCooerateCompanyController *cooperateVC = [[ZCHCooerateCompanyController alloc] init];
            cooperateVC.companyId = self.model.companyId;
            BOOL isShop = NO;
            if ([self.model.companyType integerValue]==1018 || [self.model.companyType integerValue] == 1064 || [self.model.companyType integerValue] == 1065) {
                isShop = NO;
            }
            else{
                isShop = YES;
            }
            cooperateVC.isShop = isShop;
            cooperateVC.companyModel = self.model;
            [self.navigationController pushViewController:cooperateVC animated:YES];
        }
        if ([titleStr isEqualToString:@"广告图管理"]){
            UploadAdvertisementController *VC = [[UploadAdvertisementController alloc] init];
            VC.companyID = self.model.companyId;

            MJWeakSelf;
            VC.adBlock = ^(NSInteger hasImage) {
                weakSelf.hasImg = hasImage;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
        if ([titleStr isEqualToString:@"数据统计"]){
            DateStatisticsViewController *vc = [[DateStatisticsViewController alloc] init];
            BOOL isShop = NO;
            if ([self.model.companyType integerValue]==1018 || [self.model.companyType integerValue] == 1064 || [self.model.companyType integerValue] == 1065) {
                isShop = NO;
                //                vc.titles = @[@"企业", @"工地", @"计算器", @"量房", @"活动"];
                vc.titles = @[@"企业", @"工地", @"计算器", @"量房"];
            }
            else{
                isShop = YES;
                //                vc.titles = @[@"企业", @"工地", @"商品", @"预约", @"活动"];
                vc.titles = @[@"企业", @"工地", @"商品", @"预约"];
            }

            vc.isShop = isShop;
            vc.isHeadOffice = NO;
            vc.sonCompanyDateModel = self.sonCompanyDateModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark - 退出公司
- (void)signOutCompany {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"是否确认退出公司？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    alert.tag = 100;
    [alert show];

}

#pragma mark - 点击屏幕使alertView消失
- (void)tap:(UITapGestureRecognizer *)tap {

    if (tap.state == UIGestureRecognizerStateEnded){
        CGPoint location = [tap locationInView:nil];
        if (![self.alertView pointInside:[self.alertView convertPoint:location fromView:self.alertView.window] withEvent:nil]){
            [self.alertView.window removeGestureRecognizer:tap];
            [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}

#pragma mark - 未开通会员 商品展示 ----提示开通企业网会员
- (void)showViewWithoutOpenVIP {

    TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"您未开通企业网会员，开通后可查看，立即开通？" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {

        if (buttonIndex == 1) {

            // 跳转开通会员
            [self goOpenVipVC];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"开通", nil];

    [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
            NSInteger personId = 0;
            for (CompanyPeopleInfoModel *model in self.dataArray) {
                if ([model.agencysId integerValue] == user.agencyId) {
                    personId = model.id;
                    break;
                }
            }

            NSString *defaultApi = [BASEURL stringByAppendingString:@"companyAgencys/delete.do"];
            NSDictionary *paramDic = @{@"id":@(personId),
                                       @"companyId":self.model.companyId,
                                       @"agencyId":GETAgencyId
                                       };
            [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {

                if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {

                    NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];

                    switch (statusCode) {
                        case 1000:
                        {
                            [[PublicTool defaultTool] publicToolsHUDStr:@"退出成功" controller:self sleep:1.5];
                            [[NSNotificationCenter defaultCenter] postNotificationName:kOutCompany object:nil];

                            for (UIViewController *vc in self.navigationController.viewControllers) {
                                if ([vc isKindOfClass:[MeViewController class]]) {
                                    [self.navigationController popToViewController:vc animated:YES];
                                }
                            }
                        }
                            break;

                        case 1001:
                        {
                            [[PublicTool defaultTool] publicToolsHUDStr:@"id不存在" controller:self sleep:1.5];
                        }
                            break;

                        case 2000:
                        {
                            [[PublicTool defaultTool] publicToolsHUDStr:@"退出失败" controller:self sleep:1.5];
                        }
                            break;
                        default:
                            break;
                    }
                }
            } failed:^(NSString *errorMsg) {

            }];
        }
    }
}

#pragma mark - ShopTitleTableViewCellDelegat(开通VIP)
- (void)goOpenVipVC {//企业网会员
    //    // 开通VIP 单个会员 注释不要删
    //    VipDetailController *VC = [[UIStoryboard storyboardWithName:@"VipDetailController" bundle:nil] instantiateInitialViewController];
    //    VC.companyId = self.model.companyId;
    //    __weak typeof(self) weakSelf = self;
    //    VC.successBlock = ^() {
    //        [weakSelf getCompanyList];
    //    };
    //    [self.navigationController pushViewController:VC animated:YES];

    // 会员套餐
    VipGroupViewController *VC = [[UIStoryboard storyboardWithName:@"VipGroupViewController" bundle:nil] instantiateInitialViewController];
    VC.companyId = self.model.companyId;
    __weak typeof(self) weakSelf = self;
    VC.successBlock = ^() {
        [weakSelf getCompanyList];
    };
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)goVipDetailVC {//同城套餐

    //    // 开通云管理会员 注释不要删
    //    if ([self.model.companyType integerValue] == 1018 || [self.model.companyType integerValue] == 1064 || [self.model.companyType integerValue] == 1065) {
    //        // 公司
    //
    //        ZCHConstructionVipController *consVIP = [UIStoryboard storyboardWithName:@"ZCHConstructionVipController" bundle:nil].instantiateInitialViewController;
    //        consVIP.companyId = self.model.companyId;
    //        __weak typeof(self) weakSelf = self;
    //        consVIP.block = ^() {
    //
    //            [weakSelf getCompanyList];
    //        };
    //        [self.navigationController pushViewController:consVIP animated:YES];
    //    } else {
    //        // 店铺
    //        ZCHConstructionVipController *consVIP = [UIStoryboard storyboardWithName:@"ZCHConstructionVipController" bundle:nil].instantiateInitialViewController;
    //        consVIP.companyId = self.model.companyId;
    //        __weak typeof(self) weakSelf = self;
    //        consVIP.block = ^() {
    //
    //            [weakSelf getCompanyList];
    //        };
    //        [self.navigationController pushViewController:consVIP animated:YES];
    //    }

    // 会员套餐
//    VipGroupViewController *VC = [[UIStoryboard storyboardWithName:@"VipGroupViewController" bundle:nil] instantiateInitialViewController];
//    VC.companyId = self.model.companyId;
//    __weak typeof(self) weakSelf = self;
//    VC.successBlock = ^() {
//        [weakSelf getCompanyList];
//    };
//    [self.navigationController pushViewController:VC animated:YES];
    IntroductionToMemberPackagesViewController *controller = [IntroductionToMemberPackagesViewController new];
    controller.title = @"同城套餐";//
    controller.companyId = self.model.companyId;
    controller.webUrl = [NSString stringWithFormat:@"%@resources/html/taocanjieshao.html",BASEHTML];
    [self.navigationController pushViewController:controller animated:true];
}

- (void)goCalculateVipVC {//提醒短信
    //    // 跳转  ZCHCalculatorPayController  计算器会员 不要删注释代码
    //    ZCHCalculatorPayController *calVC = [UIStoryboard storyboardWithName:@"ZCHCalculatorPayController" bundle:nil].instantiateInitialViewController;
    //    calVC.companyId = self.model.companyId;
    //    if ([self.model.calEndTime isEqualToString:@""] || !self.model.calEndTime || self.model.calEndTime.length == 0) {
    //        // 0: 新开通  1: 续费
    //        calVC.type = @"0";
    //    } else {
    //
    //        calVC.type = @"1";
    //    }
    //    __weak typeof(self) weakSelf = self;
    //    calVC.refreshBlock = ^() {
    //        [weakSelf getCompanyList];
    //    };
    //    [self.navigationController pushViewController:calVC animated:YES];
//    if (self.model.svip) {
        OrderToInformViewController *controller = [[OrderToInformViewController alloc] initWithNibName:@"DiscountPackageViewController" bundle:nil];
        controller.companyId = self.model.companyId;
        [self.navigationController pushViewController:controller animated:true];
//    }
}

- (void)goOnLineVIPVC {
    // 线上通道
    OnLineVipViewController *VC = [[UIStoryboard storyboardWithName:@"OnLineVipViewController" bundle:nil] instantiateInitialViewController];
    VC.companyId = self.model.companyId;
    __weak typeof(self) weakSelf = self;
    VC.successBlock = ^() {
        [weakSelf getCompanyList];
    };
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)raiseTheRankAction {
    YSNLog(@"提高排名");
    ZCHPublicWebViewController *powerIntroVC = [[ZCHPublicWebViewController alloc] init];
    powerIntroVC.titleStr = @"排序说明";
    powerIntroVC.webUrl = @"resources/html/paixu.html";
    [self.navigationController pushViewController:powerIntroVC animated:YES];
}

- (void)gotoCertificateAction {
    switch (self.certificateStatus) {
        case CertificateStatusUnPay: // 未支付
        {
            CompanyCertificationController *VC = [[UIStoryboard storyboardWithName:@"CompanyCertificationController" bundle:nil] instantiateInitialViewController];
            VC.companyId = [self.model.companyId copy];
            MJWeakSelf;
            VC.CertificatSuccessBlock = ^{
                [weakSelf getCertificationStatus];
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case CertificateStatusUnderway: // 认证中
            break;
        case CertificateStatusFailure: // 认证失败
        {
            CompanyCertificationController *VC = [[UIStoryboard storyboardWithName:@"CompanyCertificationController" bundle:nil] instantiateInitialViewController];
            VC.companyId = [self.model.companyId copy];
            MJWeakSelf;
            VC.CertificatSuccessBlock = ^{
                [weakSelf getCertificationStatus];
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case CertificateStatusTimeOut: // 认证过期
        {
            CompanyCertificationController *VC = [[UIStoryboard storyboardWithName:@"CompanyCertificationController" bundle:nil] instantiateInitialViewController];
            VC.companyId = [self.model.companyId copy];
            MJWeakSelf;
            VC.CertificatSuccessBlock = ^{
                [weakSelf getCertificationStatus];
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case CertificateStatusSuccess: // 认证通过
        {
            CertificateSuccessNewController *vc = [[CertificateSuccessNewController alloc] initWithNibName:@"CertificateSuccessNewController" bundle:nil];
            vc.model = self.cModel;
            vc.companyId = self.model.companyId;
            MJWeakSelf;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
            break;
        case CertificateStatusUnknown: // 未认证过
        {
            CompanyCertificationController *VC = [[UIStoryboard storyboardWithName:@"CompanyCertificationController" bundle:nil] instantiateInitialViewController];
            VC.companyId = [self.model.companyId copy];
            MJWeakSelf;
            VC.CertificatSuccessBlock = ^{
                [weakSelf getCertificationStatus];
            };
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - action
- (void)changeNet:(UIButton *)btn {

    if (btn.tag == 100) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"未开通定制功能" controller:self sleep:1.5];
        return;
    }

    if (!_NOrW) {
        //内网状态
        [self changeToW];
    } else {
        //外网状态
        [self changeToN];
    }
}

#pragma mark - 切换到内网

- (void)changeToN {
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"companyAgencys/toInnerNet.do"];
    NSDictionary *paramDic = @{@"agencyId":@(user.agencyId),
                               @"companyId":self.model.companyId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {

        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {

            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];

            switch (statusCode) {
                case 1000:

                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"切换成功" controller:self sleep:1.0];
                    _NOrW = 0;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingChangeNet" object:nil];
                    [self.tableView reloadData];
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;

                default:
                    [[PublicTool defaultTool] publicToolsHUDStr:@"切换失败" controller:self sleep:1.5];
                    break;
            }
        }

    } failed:^(NSString *errorMsg) {

        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}


#pragma mark - 切换到外网
- (void)changeToW {

    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"companyAgencys/toOuterNet.do"];
    NSDictionary *paramDic = @{@"agencyId":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {

        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {

            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];

            switch (statusCode) {
                case 1000:

                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"切换成功" controller:self sleep:1.0];
                    _NOrW = 1;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingChangeNet" object:nil];
                    [self.tableView reloadData];
                }
                    break;

                default:
                    [[PublicTool defaultTool] publicToolsHUDStr:@"切换失败" controller:self sleep:1.5];
                    break;
            }
        }

    } failed:^(NSString *errorMsg) {

        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - 添加人员
- (void)goAddPeopleVC {

    AddCompanyPeopleController *vc = [[AddCompanyPeopleController alloc]init];
    if ([self.model.companyType integerValue] == 1018 || [self.model.companyType integerValue] == 1064 || [self.model.companyType integerValue] == 1065){
        vc.comPanyOrShop = 1;
    }else{
        vc.comPanyOrShop = 2;
    }
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reducePeople {

    if (!isShow) {

        isShow = YES;
    } else {

        isShow = NO;
    }
    [self.tableView reloadData];
}

#pragma mark - 编辑按钮的点击事件
- (void)editCompany {
    [self NetworkWithModel:self.model];
}

- (void)NetworkWithModel:(SubsidiaryModel *)model {
    WeakSelf(self)
    ShowMB
    NSString *URL = @"company/getNoVipYellowPage.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"agencyId"] = GETAgencyId;
    parameters[@"companyId"] = model.companyId;
    [NetWorkRequest postJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        HiddenMB
        if ([result[@"code"] integerValue] == 1000) {
            SubsidiaryModel *modelTmp = [SubsidiaryModel yy_modelWithJSON:result[@"data"]];
            model.headImgs = modelTmp.headImgs;
            model.footImgs = modelTmp.footImgs;
            NSInteger type = [model.companyType integerValue];
            if (type == 1018 || type == 1064 || type == 1065) {
                model.isCompany = true;
            }
            VIPExperienceViewController *vc = [[VIPExperienceViewController alloc]init];
            self.model.areaList = self.areaArray;
            vc.model = model;
            vc.model.detailedAddress = result[@"data"][@"company"][@"companyAddress"];
            vc.blockFreshBack = ^() {
                [weakself getCompanyList];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    } fail:^(NSError *error) {
        HiddenMB
    }];
}

// 获取公司认证状态
- (void)getCertificationStatus {
    NSString *defaultApi = [BASEURL stringByAppendingString:@"companyAuthentication/getCompanyAuthencation.do"];
    NSDictionary *paramDic = @{@"companyId":self.model.companyId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        switch ([responseObj[@"code"] integerValue]) {
            case 1002: // 未认证
            {
                self.certificateStatus = CertificateStatusUnknown;
            }
                break;
            case 1000:
            {
                self.cModel = [CertificationModel yy_modelWithJSON:responseObj[@"data"][@"data"]];
                self.certificateStatus= self.cModel.status;
            }
                break;
            default:
                break;
        }
        if (self.certificateStatus == CertificateStatusSuccess) {
            NSMutableArray *array = @[self.arr, self.arrX, self.arrTwo, self.arrThree].mutableCopy;
            for (NSMutableArray *ar in array) {
                [ar enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (![NSStringFromClass([obj class]) isEqualToString:@"CompanyPeopleInfoModel"]) {
                        NSString *string = obj;
                        if ([string isEqualToString:@"公司认证"]) {
                            [ar removeObject:string];
                        }
                    }
                }];
            }

        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {

    }];
}

#pragma mark - 获取装修区域 成员列表
- (void)requestAreaList {

    [self.view hudShow];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"companyAgencys/getAgencyAndAreaListByCompanyId.do"];
    NSDictionary *paramDic = @{@"companyId":self.model.companyId,
                               @"companyType":self.model.companyType
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];

        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [self.dataArray removeAllObjects];
            [self.areaArray removeAllObjects];

            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];

            switch (statusCode) {
                case 1000:

                    if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = responseObj[@"data"];
                        // 是否有广告图
                        if ([dic objectForKey:@"hasImg"] != nil) {
                            self.hasImg = [[dic objectForKey:@"hasImg"] integerValue];
                        }
                        self.arr = [NSArray yy_modelArrayWithClass:[CompanyPeopleInfoModel class] json:[dic objectForKey:@"agencysList"]].mutableCopy;

                        [self.dataArray addObjectsFromArray:self.arr];

                        NSMutableArray *arr22 = self.arr.mutableCopy;
                        [arr22 removeObjectAtIndex:0];
                        self.zhixinArray = arr22;


                        NSArray *arr2 = [NSArray yy_modelArrayWithClass:[AreaListModel class] json:[dic objectForKey:@"areaList"]];

                        [self.areaArray addObjectsFromArray:arr2];

                        self.model.areaList = self.areaArray.mutableCopy;
                        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
                        if (self.dataArray.count) {
                            for (int i = 0; i<self.dataArray.count; i++) {
                                CompanyPeopleInfoModel *model = self.dataArray[i];
                                if ([model.agencysId integerValue] == user.agencyId) {
                                    changeIndex = i;
                                    if (![model.innerAndOuterSwitch integerValue]) {
                                        //内网状态
                                        _NOrW = 0;
                                    } else {

                                        //外网状态
                                        _NOrW = 1;
                                    }
                                    break;
                                }
                            }
                        }

                        [self.tableView reloadData];

                    };
                    break;

                default:
                    break;
            }
        }

    } failed:^(NSString *errorMsg) {

        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - setter

- (UITableView *)tableView {

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,kSCREEN_WIDTH,kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = White_Color;
        [_tableView registerNib:[UINib nibWithNibName:@"ShopDetailMidCell" bundle:nil] forCellReuseIdentifier:@"ShopDetailMidCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"ShopDetailBottomCell" bundle:nil] forCellReuseIdentifier:@"ShopDetailBottomCell"];
    }

    return _tableView;
}

// 比较日期前后
- (int)compareDate:(NSString*)date01 withDate:(NSString*)date02 formatter:(NSString *)formatter {

    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    [df setDateFormat:formatter];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

//NSDate转NSString
- (NSString *)date2Str:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
    formattor.dateFormat = format;
    NSTimeZone* GTMzone = [NSTimeZone localTimeZone];
    [formattor setTimeZone:GTMzone];
    return [formattor stringFromDate:date];
}

#pragma mark - 获取公司列表
- (void)getCompanyList {

    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *requestString = [BASEURL stringByAppendingString:@"company/findCompanyList.do"];
    NSDictionary *dic = @{@"agencysId":@(user.agencyId)
                          };
    [NetManager afPostRequest:requestString parms:dic finished:^(id responseObj) {
        if ([responseObj[@"code"] isEqualToString:@"1000"]) {
            NSDictionary *dict = responseObj[@"data"];
            NSArray *arr = [dict objectForKey:@"companyList"];
            for (NSDictionary *dic in arr) {
                if ([dic[@"companyId"] integerValue] == [self.model.companyId integerValue]) {
                    self.model = [SubsidiaryModel yy_modelWithDictionary:dic];
                    self.backRefreshBlock();
                }
            }
        }
        self.title = self.model.companyName;

        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {

    }];
}

#pragma mark - 根据公司id获取公司是不是开通了计算器模板VIP(是否可以跳转)
- (void)isOpenCalculatorVIP {

    NSString *api = [BASEURL stringByAppendingString:@"company/getVipStatusByCompanyId.do"];
    NSDictionary *param = @{
                            @"companyId" : self.model.companyId
                            };
    [NetManager afGetRequest:api parms:param finished:^(id responseObj) {

        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {

            if ([responseObj[@"data"][@"calVip"] integerValue] == 1) {// 开通VIP

                BLEJBudgetTemplateController *VC = [[BLEJBudgetTemplateController alloc] init];
                MJWeakSelf;
                VC.refreshBlock = ^(){
                    [weakSelf getCompanyList];
                };
                VC.companyID = self.model.companyId;
                VC.companyLogo = self.model.companyLogo;
                VC.model = self.model;
                [self.navigationController pushViewController:VC animated:YES];
            } else {

                TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"是否开通计算器模板功能" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {

                    if (buttonIndex == 1) {
                        // 会员套餐
                        VipGroupViewController *VC = [[UIStoryboard storyboardWithName:@"VipGroupViewController" bundle:nil] instantiateInitialViewController];
                        VC.companyId = self.model.companyId;
                        VC.successBlock = ^() {
                        };
                        [self.navigationController pushViewController:VC animated:YES];

                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

                [alertView show];
            }
        } else if ([responseObj[@"code"] integerValue] == 1001) {

            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司已不存在..."];
        }
    } failed:^(NSString *errorMsg) {

        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
    }];

}

#pragma mark - 设定执行经理

-(void)setimplementclick
{
    chooseimplementVC *vc = [chooseimplementVC new];
    vc.dataSource = self.zhixinArray;
    vc.dataSource = self.zhixinArray;
    vc.companyId = self.model.companyId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)notice:(id)sender{
    NSLog(@"%@",sender);
    [self requestAreaList];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"zhixinjingli" object:nil];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}


@end

