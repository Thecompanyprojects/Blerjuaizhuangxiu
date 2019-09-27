//
//  BLEJBudgetTemplateController.m
//  Calculator
//
//  Created by 赵春浩 on 17/4/28.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import "BLEJBudgetTemplateController.h"
#import "UIBarButtonItem+Item.h"
#import "BLEJBudgetTemplateCell.h"
#import "BLEJBudgetTemplateGroupHeaderCell.h"
#import "BLEJCalculatorGetTempletByCompanyId.h"
#import  <AVFoundation/AVFoundation.h>
#import "BLEJCalculatorBottomShadowView.h"
#import "ZCHCalculatorPayController.h"
#import "SubsidiaryModel.h"
#import "UploadImageApi.h"
#import "GTMBase64.h"
#import "HKImageClipperViewController.h"
#import "ZCHSimpleSettingController.h"
#import "ZCHCalculatorItemsModel.h"
#import "NSObject+CompressImage.h"
#import "ZCHPublicWebViewController.h"
#import "VipGroupViewController.h"
#import "PellTableViewSelect.h"
#import "BLEJPackageArticleDesignModel.h"
#import "BLEJCalculatePackageDetailCell.h"
#import "ZCHSimpleBottomCell.h"
#import "CLPlayerView.h"
#import "VrCommenCell.h"
#import "SDCycleScrollView.h"
#import "senceWebViewController.h"
#import "BELJDetailPackageController.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
#import "BLRJCalculatortempletModelAllCalculatorcompanyData.h"
#import "ZYCShareView.h"
#import "BLEJFloorBrickViewController.h"
#import <Photos/Photos.h>

typedef NS_ENUM (NSInteger, calculatorType)   {

    isQinfu = 0,//轻辅计算器
    isTaocan = 1,//套餐计算器
    isFloorBrick = 2,//地砖计算器
    isFloorWood = 3,//地板计算器
    isShedLine = 4,//吊顶计算器
    isWallpaper = 5,//壁纸计算器
    isFloorheating = 6,//地暖计算器
    isFinishedproduct = 7,//成品计算器
    isPipe = 8//管道计算器
};

static NSString *reuseIdentifier = @"BLEJBudgetTemplateCell";
static NSString *reuseHeaderIdentifier = @"BLEJBudgetTemplateGroupHeaderCell";
@interface BLEJBudgetTemplateController ()<UITableViewDelegate, UITableViewDataSource, BLEJBudgetTemplateCellDelegate, BLEJBudgetTemplateGroupHeaderCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate,BLRJCalculatePackageDetailCellDelegate,CLPlayerViewDelegate,UIGestureRecognizerDelegate,SDCycleScrollViewDelegate,MBProgressHUDDelegate>


@property (nonatomic,assign) calculatorType Type;
@property (strong, nonatomic) NSString *taocaoPrice0;
@property (strong, nonatomic) NSString *guandaoPirce0;
@property (strong, nonatomic) NSString *taocaoPrice1;
@property (strong, nonatomic) NSString *guandaoPirce1;


@property (strong, nonatomic) UITableView *tableView;

// 新添加的模板
@property (strong, nonatomic) NSMutableArray *suppleListArr;
// 基础模板
@property (strong, nonatomic) NSMutableArray *baseItemsArr;
//瓷砖数组
@property (strong, nonatomic) NSMutableArray *floorBrickArr;
//地砖数组
@property (strong, nonatomic) NSMutableArray *floorWoodArr;
//地砖数组
@property (strong, nonatomic) NSMutableArray *ShedArr;

@property (strong, nonatomic)CLPlayerView *plyer;
@property (strong, nonatomic) NSMutableArray *companyItemArray;

@property (strong, nonatomic) NSMutableDictionary *companyDict;
@property (strong, nonatomic)NSString * companyIDConstant;
@property (strong, nonatomic)SDCycleScrollView * allview;;

// 所有计算器的模板信息
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes  *allCalculatorTypeModel;
// 所有计算器的模板信息
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorcompanyData *allCalculatorCompanyData;
// 底部弹出视图
@property (strong, nonatomic) BLEJCalculatorBottomShadowView *bottomView;
// 顶部的图片视图
@property (strong, nonatomic) UIImageView *headerView;

// 右边右上角的分享按钮
@property (strong, nonatomic) UIButton *rightBtn;

// 记录设置基础模板的参数
@property (strong, nonatomic) NSMutableDictionary *param;

// 记录点击的indexPath
@property (strong, nonatomic) NSIndexPath *indexPath;

// 底部的分享菜单
@property (strong, nonatomic) UIView *bottomShareView;
// 遮罩层
@property (strong, nonatomic) UIView *shadowView;

// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 二维码
@property (strong, nonatomic) UIView *TwoDimensionCodeView;
// 带logo的公司image
@property (strong, nonatomic) UIImage *companyImage;
// 带logo的业务员image
@property (strong, nonatomic) UIImage *elseImage;
// 显示logo的imageView
@property (strong, nonatomic) UIImageView *codeView;

@property (strong, nonatomic) UIView *topView;

@property (strong, nonatomic) UIButton *collectBtn;

@property (strong, nonatomic) UILabel *companyName;

@property (strong, nonatomic) UILabel *companyAddress;

@property (strong, nonatomic) UIImageView *displayLogo;

@property (strong, nonatomic) UIView *topBgView;

@property (strong, nonatomic) UILabel *getDateLabel;

// 记录删除的index
@property (strong, nonatomic) NSMutableArray *indexArr;

// 选择完照片之后的bgView
@property (strong, nonatomic) UIView *imageBgView;
@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic)UISegmentedControl *segmentedControl;
// 选择可定义裁切大小的系统图片↓
@property (nonatomic, assign) ClipperType clipperType;

@property (strong, nonatomic) UIImageView *clippedImageView; //显示结果图片
// 选择可定义裁切大小的系统图片↑

// 用于标记分组视图中的减号按钮是否被点击了
@property (strong, nonatomic) NSMutableArray *isGroupBtnClick;
// 标记是否开通过vip
@property (assign, nonatomic) NSInteger isOpenVip;
// 简装按钮
@property (strong, nonatomic) UIButton *simpleBtn;
//精装按钮
@property (strong, nonatomic) UIButton *refineBtn;

//右上角的计算器数组
@property (strong, nonatomic) NSMutableArray *rigthItemChoiceArray;
// 预算说明视图
@property (strong, nonatomic) UIView *budgetExplain;
//预算说明视图上的label
@property (strong, nonatomic) UILabel *topTitleLabel;
//预算说明视图上的textview
@property (strong, nonatomic) UITextView *textView;
//预算说明视图上的textview 上的feedlabel
@property (strong, nonatomic) UILabel *feedLabel;


// 是否是业务员分享二维码
@property (nonatomic, assign) BOOL isYeWuYuanShare;
//是否开通了业务员二维码会员(-1: 未获取  0: 未开通  1: 开通)
@property (assign, nonatomic) NSInteger openSaleCode;
// 业务员二维码结束时间
@property (strong, nonatomic) UILabel *saleCodeDateLabel;
// 业务员二维码续费按钮
@property (strong, nonatomic) UIButton *saleCodeBtn;
// 二维码上的公司名字
@property (nonatomic, strong) UILabel *QRCompanyNameLabel;
// 二维码上的计算器汉字
@property (nonatomic, strong) UILabel *QRCalculateNameLabel;

/************************套餐计算器套餐计算器****************************/

@property (strong, nonatomic)UIView* segmentView;

// 标记是否点击简装按钮
@property (nonatomic, assign) BOOL isClickedSimpleBtn;
// 标记编辑按钮的点击状态
@property (assign, nonatomic) BOOL isEditting;
// sectionheader的减号是否
@property (assign, nonatomic) BOOL isclickdMinusBtnshow;
// 记录是否有基础模板
@property (assign, nonatomic) BOOL isHaveBaseModel;


//是否是699套餐
@property (assign, nonatomic)BOOL isPackage699;

// 标记编辑按钮的点击状态
@property (assign, nonatomic) BOOL isLastRowSelected;

@property (strong, nonatomic) NSMutableArray *deletSection1;
@property (strong, nonatomic) NSMutableArray *deletSection2;
@property (strong, nonatomic) NSMutableArray *deletSection3;
@property (strong, nonatomic) NSMutableArray *deletSection4;


@property (strong, nonatomic) ZYCShareView *shareView;

@property (strong, nonatomic)BLEJCalculatePackageDetailCell *cell;

//瓷砖计算器的四个group添加的个数
@property (strong, nonatomic)NSMutableArray *Bricksection1;
@property (strong, nonatomic)NSMutableArray *Bricksection2;
@property (strong, nonatomic)NSMutableArray *Bricksection3;
@property (strong, nonatomic)NSMutableArray *Bricksection4;

//地板计算器的四个group添加的个数
@property (strong, nonatomic) NSMutableArray *WoodGroudArray;//  地板
@property (strong, nonatomic) NSMutableArray *WoodLineArray;//踢脚线
@property (strong, nonatomic) NSMutableArray *WoodexceptionArray;///其他
@property (strong, nonatomic) NSMutableArray *WoodinstallArray;///安装费
//棚角线计算器的四个group添加的个数
@property (strong, nonatomic) NSMutableArray *ShedGroudArray;//  棚板
@property (strong, nonatomic) NSMutableArray *ShedLineArray;//棚角线
@property (strong, nonatomic) NSMutableArray *ShedexceptionArray;///其他

// 套餐计算器的数组个数
@property (strong, nonatomic)NSMutableArray *packageArrsimple;
@property (strong, nonatomic)NSMutableArray *packageArrrefine;

//999套餐的id精装
@property (copy, nonatomic) NSString *packageId999refine;
//999套餐名字精装
@property (copy, nonatomic) NSString *packageName999Refine;

//699套餐的id简装
@property (copy, nonatomic) NSString *packageId699simple;
//699套餐名字简装
@property (copy, nonatomic) NSString *packageName699simple;;

//699和999 的全景视图的参数
@property (strong, nonatomic) NSString *picUrl;

@property (strong, nonatomic) NSString *picHref;

@property (strong, nonatomic) NSString *picTitle;

@property (strong, nonatomic) NSString *picUrl1;

@property (strong, nonatomic) NSString *picHref1;

@property (strong, nonatomic) NSString *picTitle1;

@property (strong, nonatomic)NSMutableArray *mutabeArrayDict;
@property (strong, nonatomic)NSMutableDictionary *mutableDic;

//地暖计算器
@property (nonatomic,strong) NSMutableArray *dinuamArray0;
@property (nonatomic,strong) NSMutableArray *dinuamArray1;
//成品计算器
@property (nonatomic,strong) NSMutableArray *chengpinArray;

@end

@implementation BLEJBudgetTemplateController{
    BOOL isPlay;
    BOOL isReadToPlay;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.isClickedSimpleBtn=NO;
    
    [self initArrayAndProperty];
   
    [self addRightItem];
    [self setSDCylce];
 
    [self addBottomShareView];
   
    [self addSuspendedButton];
    [self getSalerCode];

    [self setTableView];
    [self addHeaderViewAndFootView];
    self.openSaleCode = -1;
    self.isGroupBtnClick = [NSMutableArray arrayWithObjects:@{@"isClick" : @"0"}, @{@"isClick" : @"0"}, nil];
    self.isEditting = NO;
    self.isYeWuYuanShare = NO;
    
    // 单独处理这里的返回按钮(因为需要返回到根控制器)
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationBaseReplaceMes:) name:@"didClickCalculatorBaseBottomViewConfirmBtnReplace" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReplaceMes:) name:@"didClickCalculatorBottomViewConfirmBtnReplace" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAddMes:) name:@"didClickCalculatorBottomViewConfirmBtnAdd" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updataTableViewData:) name:@"EditPackageCalculatorFinished" object:nil ];

    [self getDataWithType:@"1"];

    self.Type = isQinfu;
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.plyer destroyPlayer];
    [self.plyer removeFromSuperview];
    self.plyer =nil;
}

-(void)setSDCylce{
  
    _allview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJWidth * 0.6) delegate:self placeholderImage:[UIImage imageNamed:@"top_default"]];
    _allview.autoScrollTimeInterval = BANNERTIME;
    _allview.showPageControl = NO;
    _allview.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    _allview.backgroundColor = [UIColor blackColor];
    _allview.ishaveMiddleImage = YES;
}
-(void)setTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, BLEJHeight - self.navigationController.navigationBar.bottom - 50) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 44)];
    self.tableView.backgroundColor = White_Color;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"BLEJBudgetTemplateCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView registerClass:[BLEJBudgetTemplateGroupHeaderCell class] forHeaderFooterViewReuseIdentifier:reuseHeaderIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BLEJCalculatePackageDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BLEJCalculatePackageDetailCell"];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView=self.topView;
    
    self.bottomView = [[BLEJCalculatorBottomShadowView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.bottomView.hidden = YES;
    [self.view addSubview:self.bottomView];
}

-(void)updataTableViewData:(NSNotification *)notification{
    NSDictionary *dic= notification.userInfo;
   
    if ([[dic objectForKey:@"type"]isEqual:@"0"]) {
        self.isPackage699 =YES;
    }else{
        self.isPackage699 =NO;
    }
    
    //self.Type = isTaocan;
    [self getDataFromServer];
}

-(void)initArrayAndProperty{
    self.stringTextView=[[NSString alloc]init];
    self.indexPath = [NSIndexPath indexPathForRow:300 inSection:0];
    _mutableDic=[NSMutableDictionary dictionary];
    _mutabeArrayDict=[NSMutableArray array];
    _packageArrsimple=[NSMutableArray array];
    _packageArrrefine=[NSMutableArray array];
    
    _floorBrickArr=[NSMutableArray array];
    _floorWoodArr=[NSMutableArray array];
    _ShedArr =[NSMutableArray array];
    self.Bricksection1 =[NSMutableArray array];
    self.Bricksection2 =[NSMutableArray array];
    self.Bricksection3 =[NSMutableArray array];
    self.Bricksection4 =[NSMutableArray array];
    
    self.WoodGroudArray =[NSMutableArray array];
    self.WoodLineArray =[NSMutableArray array];
    self.WoodexceptionArray =[NSMutableArray array];
    self.WoodinstallArray =[NSMutableArray array];
    
    
    self.ShedGroudArray=[NSMutableArray array];
    self.ShedLineArray=[NSMutableArray array];
    self.ShedexceptionArray=[NSMutableArray array];
    
    self.baseItemsArr = [NSMutableArray array];
    self.suppleListArr = [NSMutableArray array];
    self.baseItemsArr = [NSMutableArray array];
    self.suppleListArr = [NSMutableArray array];

    
    self.deletSection1= [NSMutableArray array];
    self.deletSection2= [NSMutableArray array];
    self.deletSection3= [NSMutableArray array];
    self.deletSection4= [NSMutableArray array];
    
    self.companyItemArray =[NSMutableArray array];
    self.companyDict=[NSMutableDictionary dictionary];
    self.param = [NSMutableDictionary dictionary];
    self.indexArr = [NSMutableArray array];
    
    self.dinuamArray0 = [NSMutableArray array];
    self.dinuamArray1 = [NSMutableArray array];
    
    self.chengpinArray = [NSMutableArray array];
    
    self.rigthItemChoiceArray=[NSMutableArray arrayWithObjects:@"分享",@"轻辅计算器",@"套餐计算器",@"瓷砖计算器",@"地板计算器",@"集成吊顶计算器",@"地暖计算器",@"成品计算器",@"管道计算器", nil];
    
}

#pragma mark - UI设计

#pragma mark - 添加navBar右侧的编辑按钮

- (void)addRightItem {
    
   // if (self.isCanEdit) {
        
        self.rightBtn = [[UIButton alloc]initWithFrame:
                        CGRectMake(30, 0, 50,50) ];
        [self.rightBtn setTitle:@"···" forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(didClickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
        
  //  }
}

#pragma mark segementControl的切换button事件

#pragma 点击事件
-(void)SegmentedControl:(UISegmentedControl *)sender
{
    //我定义了一个 NSInteger tag，是为了记录我当前选择的是分段控件的左边还是右边。
    NSInteger selecIndex = sender.selectedSegmentIndex;
    BLEJCalculatePackageDetailCell *packageCell =[self.tableView cellForRowAtIndexPath:self.indexPath];

    NSString *strUrl=  packageCell.ArticleDesignModel.videoUrl;
    packageCell.player.url =[NSURL URLWithString:strUrl];
        if (packageCell.plachoderVideoImgV.hidden==YES) {
            packageCell.plachoderVideoImgV.hidden=NO;
        }


    
    switch(selecIndex){
        case 0:
           
            sender.backgroundColor=[UIColor redColor];
            sender.selectedSegmentIndex=0;
            
            self.isPackage699 =YES;
            [packageCell.player destroyPlayer];
            packageCell.player =nil;
            [self.tableView reloadData];
            break;
            
        case 1:
            sender.selectedSegmentIndex=1;
            [packageCell.player destroyPlayer];
            packageCell.player =nil;
            self.isPackage699 =NO;
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }
}

// 添加顶部视图还有底部视图
- (void)addHeaderViewAndFootView {
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 360)];
    self.topView.backgroundColor = kBackgroundColor;
   
    UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 100)];
    topBgView.backgroundColor = White_Color;
    self.topBgView = topBgView;
    [self.topView addSubview:topBgView];
    
    UIImageView *companyLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    [companyLogo sd_setImageWithURL:[NSURL URLWithString:self.model.companyLogo] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    self.displayLogo = companyLogo;
    [topBgView addSubview:companyLogo];
    
    UILabel *companyName = [[UILabel alloc] initWithFrame:CGRectMake(companyLogo.right + 10, companyLogo.top, BLEJWidth - 160, 20)];
    companyName.textAlignment = NSTextAlignmentLeft;
    companyName.textColor = Black_Color;
    companyName.font = [UIFont systemFontOfSize:14];
    self.companyName = companyName;
    companyName.text = self.model.companyName;
    [topBgView addSubview:companyName];
    
    UILabel *companyAddress = [[UILabel alloc] initWithFrame:CGRectMake(companyName.left, companyName.bottom, BLEJWidth - 90, 20)];
    companyAddress.textAlignment = NSTextAlignmentLeft;
    companyAddress.textColor = [UIColor grayColor];
    companyAddress.font = [UIFont systemFontOfSize:12];
    companyAddress.text = [NSString stringWithFormat:@"%@ %@", self.model.companyAddress, self.model.detailedAddress];
    self.companyAddress = companyAddress;
    [topBgView addSubview:companyAddress];
    
    UILabel *getDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(companyName.left, companyAddress.bottom, companyAddress.width, 20)];
    getDateLabel.textAlignment = NSTextAlignmentLeft;
    getDateLabel.textColor = [UIColor grayColor];
    getDateLabel.font = [UIFont systemFontOfSize:12];
    self.getDateLabel = getDateLabel;
    [topBgView addSubview:getDateLabel];
    
    UIButton *collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(companyName.left, companyLogo.bottom, 60, 20)];
    collectBtn.layer.borderColor = [UIColor redColor].CGColor;
    collectBtn.layer.borderWidth = 1;
    collectBtn.layer.cornerRadius = 3;
    collectBtn.layer.masksToBounds = YES;
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [collectBtn setTitle:@"收集号码" forState:UIControlStateNormal];
    [collectBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(didClickCollectBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.collectBtn = collectBtn;
    if (self.isCanEdit) {
        self.collectBtn.hidden = NO;
    } else {
        self.collectBtn.hidden = YES;
    }
    [topBgView addSubview:collectBtn];

    UIButton *simpleSetting = [[UIButton alloc] initWithFrame:CGRectMake(20, 110, (BLEJWidth - 70) * 0.5, 40)];
    [simpleSetting setBackgroundColor:kMainThemeColor];
    simpleSetting.layer.cornerRadius = 3;
    simpleSetting.layer.masksToBounds = YES;
    [simpleSetting setTitle:@"简装报价设置" forState:UIControlStateNormal];
    simpleSetting.titleLabel.font = [UIFont systemFontOfSize:14];
    [simpleSetting setTitleColor:White_Color forState:UIControlStateNormal];
    [simpleSetting addTarget:self action:@selector(didClickSimpleSettingBtn:) forControlEvents:UIControlEventTouchUpInside];
//    simpleSetting.hidden =YES;
    if (self.isCanEdit) {
        [self.topView addSubview:simpleSetting];
    }

   
    self.simpleBtn = simpleSetting;
    
    UIButton *refineSetting = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth * 0.5 + 15, 110, (BLEJWidth - 70) * 0.5, 40)];
    [refineSetting setBackgroundColor:kMainThemeColor];
    refineSetting.layer.cornerRadius = 3;
    refineSetting.layer.masksToBounds = YES;
    [refineSetting setTitle:@"精装报价设置" forState:UIControlStateNormal];
    refineSetting.titleLabel.font = [UIFont systemFontOfSize:14];
    [refineSetting setTitleColor:White_Color forState:UIControlStateNormal];
    [refineSetting addTarget:self action:@selector(didClickRefineSettingBtn:) forControlEvents:UIControlEventTouchUpInside];
 //   refineSetting.hidden = YES;
    if (self.isCanEdit) {
        [self.topView addSubview:refineSetting];
    }
    self.refineBtn = refineSetting;
    
    UIView *budgetExplain = [[UIView alloc] init];
    if (self.isCanEdit) {
        budgetExplain.frame = CGRectMake(0, 160, BLEJWidth, 190);
    } else {
        budgetExplain.frame = CGRectMake(0, 160 - 40 - 5, BLEJWidth, 190);
    }
    budgetExplain.backgroundColor = White_Color;
    self.budgetExplain = budgetExplain;
    [self.topView addSubview:budgetExplain];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, BLEJWidth - 20, 40)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = Black_Color;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"预算说明";
    self.topTitleLabel = titleLabel;
    [budgetExplain addSubview:titleLabel];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, BLEJWidth - 20, 140)];
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = Black_Color;
    textView.backgroundColor = kBackgroundColor;
    textView.delegate = self;
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    if (self.isCanEdit) {
        textView.editable = YES;
    }
    self.textView = textView;
    [budgetExplain addSubview:textView];
    
    UILabel *feedLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 5, BLEJWidth - 50, 21)];
    feedLabel.textColor = [UIColor darkGrayColor];
    feedLabel.textAlignment = NSTextAlignmentLeft;
    feedLabel.font = [UIFont systemFontOfSize:14];
    if (self.textView.text) {
         feedLabel.text = @"";
    }else{
         feedLabel.text = @"请输入您想对业主说的话";
    }
   
    [textView addSubview:feedLabel];
    self.feedLabel = feedLabel;
    
   //底部视图
    self.editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, BLEJHeight - 50, BLEJWidth, 50)];
    self.editBtn.backgroundColor = kMainThemeColor;
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editBtn addTarget:self action:@selector(didClickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.editBtn.hidden=NO;
    if (self.isCanEdit) {
        [self.view addSubview:self.editBtn];
    }
    
}

- (void)addBottomShareView {

    self.shareView = [ZYCShareView sharedInstance];
    [self makeShareView];
}

// 点击二维码图片后生成的分享页面
- (void)addTwoDimensionCodeView {
    
    if (self.companyImage && self.elseImage) {
        
        if (self.isYeWuYuanShare) {
            
            self.codeView.image = self.elseImage;
            self.saleCodeDateLabel.hidden = NO;
            self.saleCodeBtn.hidden = NO;
            self.QRCompanyNameLabel.hidden = YES;
            self.QRCalculateNameLabel.hidden = YES;
        } else {
            
            self.codeView.image = self.companyImage;
            self.saleCodeDateLabel.hidden = YES;
            self.saleCodeBtn.hidden = YES;
            self.QRCompanyNameLabel.hidden = NO;
            self.QRCalculateNameLabel.hidden = NO;
        }
        return;
    }
    
    self.TwoDimensionCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.TwoDimensionCodeView.backgroundColor = White_Color;
    [self.view addSubview:self.TwoDimensionCodeView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTwoDimensionCodeView:)];
    [self.TwoDimensionCodeView addGestureRecognizer:tap];
    
    UIImageView *codeView = [[UIImageView alloc] init];
    codeView.size = CGSizeMake(BLEJWidth - 40, BLEJWidth - 40);
    codeView.center = self.TwoDimensionCodeView.center;
    codeView.backgroundColor = [UIColor lightGrayColor];
    self.codeView = codeView;
    [self.TwoDimensionCodeView addSubview:codeView];
   
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, codeView.bottom + 20, BLEJWidth, 30)];
    label.text = @"扫一扫，10秒出装修报价";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor darkGrayColor];
    [self.TwoDimensionCodeView addSubview:label];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    self.QRCalculateNameLabel = titleLabel;
    [self.TwoDimensionCodeView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(codeView.mas_top).equalTo(-20);
        make.left.right.equalTo(0);
    }];
    titleLabel.text = @"计算器";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor blackColor];
    
    UILabel *companyNameLabel = [[UILabel alloc] init];
    self.QRCompanyNameLabel = companyNameLabel;
    [self.TwoDimensionCodeView addSubview:companyNameLabel];
    [companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(titleLabel.mas_top).equalTo(-10);
        make.left.equalTo(codeView).equalTo(6);
        make.right.equalTo(codeView).equalTo(-6);
    }];
    companyNameLabel.text = self.model.companyName;
    companyNameLabel.textAlignment = NSTextAlignmentCenter;
    companyNameLabel.numberOfLines = 0;
    companyNameLabel.font = [UIFont systemFontOfSize:20];
    companyNameLabel.textColor = [UIColor blackColor];
    
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [self.TwoDimensionCodeView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeView).equalTo(6);
        make.bottom.equalTo(codeView.mas_top).equalTo(-20);
    }];
    timeLabel.textColor = [UIColor redColor];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.font = [UIFont systemFontOfSize:16];
    self.saleCodeDateLabel = timeLabel;
    
    UIButton *renewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.TwoDimensionCodeView addSubview:renewButton];
    [renewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(codeView).equalTo(-6);
        make.centerY.equalTo(timeLabel);
        make.size.equalTo(CGSizeMake(60, 20));
    }];
    [renewButton setTitle:@"续 费" forState:UIControlStateNormal];
    [renewButton setTitle:@"续 费" forState:UIControlStateHighlighted];
    [renewButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [renewButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    renewButton.titleLabel.font = [UIFont systemFontOfSize:15];
    renewButton.layer.borderColor = [UIColor redColor].CGColor;
    renewButton.layer.cornerRadius = 4;
    renewButton.layer.borderWidth = 1;
    [renewButton addTarget:self action:@selector(renewButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.saleCodeBtn = renewButton;
    
    
    
//    if (self.isYeWuYuanShare) { // 业务员分享我的二维码
    
    
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *shareElseURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/calculator/v3/html/%@/%ld.htm?origin=%@", self.companyID,(long)userModel.agencyId,@"2"]];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userModel.photo]]];
        if (!image) {
            image = [UIImage imageNamed:@"defaultCompanyLogo"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            codeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareElseURL logoImageName:image logoScaleToSuperView:0.25];
            weakSelf.elseImage = codeView.image;
        });
    });
    
    NSString *shareCompanyURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/calculator/v3/html/%@/%ld.htm?origin=%@", self.companyID,(long)userModel.agencyId,@"2"]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.companyLogo]]];
        if (!image) {
            image = [UIImage imageNamed:@"defaultCompanyLogo"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            codeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareCompanyURL logoImageName:image logoScaleToSuperView:0.25];
            weakSelf.companyImage = codeView.image;
        });
    });
    self.TwoDimensionCodeView.hidden = YES;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    switch (self.Type) {
        case isTaocan:
            return 2;
            break;
        case isQinfu:
            return 2;
            break;
        case isFloorBrick:
            return 4;
            break;
        case isFloorWood:
            return 3;
            break;
        case isShedLine:
            return 3;
            break;
        case isFloorheating:
            return 2;
            break;
        case isFinishedproduct:
            return 1;
            break;
        case isPipe:
            return 2;
            break;
        case isWallpaper:
            
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.Type==isTaocan||self.Type==isPipe) {
        if (section==0) {
            if(self.isPackage699 ==YES){
                    return self.packageArrsimple.count;
            }else{
                    return self.packageArrrefine.count;
            }
        }else if(section ==1){
            if ( self.picUrl.length >0 ||self.picUrl1.length >0) {
                if (_isPackage699==YES &&self.picUrl.length==0 ) {
                      return 0;
                }
                if (_isPackage699 ==NO &&self.picUrl1.length ==0) {
                   return 0;
                }
                return 1;
            }
        }
    }else if (self.Type == isQinfu){
        if (section == 0) {
        return self.baseItemsArr.count;
        }else{
            return self.suppleListArr.count;
        }
    }else if (self.Type ==isFloorBrick){
        
        if ( section==0) {
            return  self.Bricksection1.count?:0;
        }else if ( section==1) {
            return self.Bricksection2.count?:0;
        }else if ( section==2) {
           return self.Bricksection3.count?:0;
        }else if (section==3) {
         return self.Bricksection4.count?:0;
        }
    }else if (self.Type == isFloorWood){
        if ( section==0) {
            return  self.WoodGroudArray.count?:0;
        }else if ( section==1) {
            return self.WoodLineArray.count?:0;
        }else if ( section==2) {
            return self.WoodexceptionArray.count?:0;
        }
    }else if (self.Type == isShedLine){
        if ( section==0) {
            return  self.ShedGroudArray.count?:0;
        }else if ( section==1) {
            return self.ShedLineArray.count?:0;
        }else if ( section==2) {
            return self.ShedexceptionArray.count?:0;
        }
    }else if (self.Type==isFloorheating) //地暖计算器
    {
        if (section==0) {
            return self.dinuamArray0.count?:0;
        }
        if (section==1) {
            return self.dinuamArray1.count?:0;
        }
    }
    else if (self.Type==isFinishedproduct) //成品计算器
    {
        if (section==0) {
            return self.chengpinArray.count?:0;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //轻辅计算器
    if (self.Type==isQinfu) {
        BLEJBudgetTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        if (indexPath.section == 0 && [@[@10, @11, @12, @13,@14] containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
            
            cell.cellType = @"1";
        } else if (indexPath.section == 1) {
            
            cell.cellType = @"2";
        } else {
            
            cell.cellType = @"0";
        }
        
        if (indexPath.section == 0) {
            cell.model = self.baseItemsArr[indexPath.row];
        } else {
            cell.model = self.suppleListArr[indexPath.row];
        }
        cell.isShowMinus = self.isclickdMinusBtnshow;
        cell.budgetTemplateCellDelegate = self;
        cell.indexPath = indexPath;
        if (indexPath.section == 1) {
            if ([self.indexArr containsObject:@(indexPath.row)]) {
                cell.hidden = YES;
            } else {
                cell.hidden = NO;
            }
        }
        return cell;
    }
    //套餐计算器
    if (self.Type ==isTaocan) {
        if (indexPath.section ==0) {
         
        self.cell = (BLEJCalculatePackageDetailCell*)[tableView dequeueReusableCellWithIdentifier:@"BLEJCalculatePackageDetailCell"];
            self.cell.pathVideoSelected =indexPath;
        
            self.cell.PackageCellDelegate=self;
                if(self.isPackage699 ==YES){
                    if (self.packageArrsimple.count >0) {
                        self.cell.ArticleDesignModel =self.packageArrsimple[indexPath.row];
                     
                    }
                }else{
                  if (self.packageArrrefine.count >0) {
                        self.cell.ArticleDesignModel =self.packageArrrefine[indexPath.row];
                  }
                }
            return self.cell;;
        }else if(indexPath.section ==1){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJWidth * 0.6)];
             [cell.contentView addSubview:self.allview];
           
            NSString *strurl;
            if (_isPackage699 ==YES) {
                strurl=self.picHref;
                if (self.picUrl.length>0) {
                self.allview.imageURLStringsGroup = @[self.picUrl].copy;
                self.allview.titlesGroup = @[self.picTitle].copy;
                }
            }else{
                strurl =self.picHref1;
                if (self.picHref1.length>0) {
                self.allview.imageURLStringsGroup = @[self.picUrl1].copy;
                self.allview.titlesGroup = @[self.picTitle1].copy;
                }
            }
                __weak typeof(self) weakSelf = self;
                self.allview.clickItemOperationBlock = ^(NSInteger currentIndex) {
                    if (strurl.length>0) {

                        senceWebViewController *sence = [[senceWebViewController alloc]init];
                           sence.isFrom =YES;
                           sence.webUrl =strurl;
                            sence.companyLogo = weakSelf.companyLogo;
                            sence.companyName = weakSelf.companybname;
                        [weakSelf.navigationController pushViewController:sence animated:YES];
                    }
                };
            
                    return cell;
        }
    }
    if (self.Type==isPipe) {
        if (indexPath.section ==0) {
            
            self.cell = (BLEJCalculatePackageDetailCell*)[tableView dequeueReusableCellWithIdentifier:@"BLEJCalculatePackageDetailCell"];
            self.cell.pathVideoSelected =indexPath;
            self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.cell.PackageCellDelegate=self;
            if(self.isPackage699 ==YES){
                if (self.packageArrsimple.count >0) {
                    self.cell.ArticleDesignModel =self.packageArrsimple[indexPath.row];
                    
                }
            }else{
                if (self.packageArrrefine.count >0) {
                    self.cell.ArticleDesignModel =self.packageArrrefine[indexPath.row];
                }
            }
            return self.cell;;
        }else if(indexPath.section ==1){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJWidth * 0.6)];
            [cell.contentView addSubview:self.allview];
            
            NSString *strurl;
            if (_isPackage699 ==YES) {
                strurl=self.picHref;
                if (self.picUrl.length>0) {
                    self.allview.imageURLStringsGroup = @[self.picUrl].copy;
                    self.allview.titlesGroup = @[self.picTitle].copy;
                }
            }else{
                strurl =self.picHref1;
                if (self.picHref1.length>0) {
                    self.allview.imageURLStringsGroup = @[self.picUrl1].copy;
                    self.allview.titlesGroup = @[self.picTitle1].copy;
                }
            }
            __weak typeof(self) weakSelf = self;
            self.allview.clickItemOperationBlock = ^(NSInteger currentIndex) {
                if (strurl.length>0) {
                    
                    senceWebViewController *sence = [[senceWebViewController alloc]init];
                    sence.isFrom =YES;
                    sence.webUrl =strurl;
                    sence.companyLogo = weakSelf.companyLogo;
                    sence.companyName = weakSelf.companybname;
                    [weakSelf.navigationController pushViewController:sence animated:YES];
                }
            };
            
            return cell;
        }
    }
    if (self.Type == isFloorBrick) {
        BLEJBudgetTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.budgetTemplateCellDelegate = self;
        cell.indexPath = indexPath;
        cell.isShowMinus = self.isclickdMinusBtnshow;
        
        if (indexPath.section==0) {
                cell.model = self.Bricksection1[indexPath.row];
                cell.hidden = [self.deletSection1 containsObject:@(indexPath.row)]? YES:NO;
            
        }else if (indexPath.section==1) {
           
                cell.model = self.Bricksection2[indexPath.row];
                cell.hidden = [self.deletSection2 containsObject:@(indexPath.row)]? YES:NO;
            
        }else if (indexPath.section==2) {
           
                cell.model = self.Bricksection3[indexPath.row];
                cell.hidden = [self.deletSection3 containsObject:@(indexPath.row)]? YES:NO;
            
        }else if (indexPath.section==3) {
           
                cell.model = self.Bricksection4[indexPath.row];
                cell.hidden = [self.deletSection4 containsObject:@(indexPath.row)]? YES:NO;
            }

        return cell;
    }else if (self.Type== isFloorWood || self.Type==isShedLine) {
        BLEJBudgetTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
 
        cell.budgetTemplateCellDelegate = self;
        cell.indexPath = indexPath;
        cell.isShowMinus = self.isclickdMinusBtnshow;
        if (indexPath.section==0) {
            if (self.Type== isFloorWood) {
                cell.model = self.WoodGroudArray[indexPath.row];
                cell.hidden = [self.deletSection1 containsObject:@(indexPath.row)]? YES:NO;
            }else{
                cell.model = self.ShedGroudArray[indexPath.row];
                cell.hidden = [self.deletSection1 containsObject:@(indexPath.row)]? YES:NO;
            }

        }else if ( indexPath.section==1) {
            if (self.Type== isFloorWood) {
                  cell.model = self.WoodLineArray[indexPath.row];
                  cell.hidden = [self.deletSection2 containsObject:@(indexPath.row)]? YES:NO;
            }else{
                cell.model = self.ShedLineArray[indexPath.row];
                cell.hidden = [self.deletSection2 containsObject:@(indexPath.row)]? YES:NO;
                }
        }else if ( indexPath.section==2) {
             if (self.Type== isFloorWood) {
                 cell.model = self.WoodexceptionArray[indexPath.row];
                 cell.hidden = [self.deletSection3 containsObject:@(indexPath.row)]? YES:NO;
             }else{
                 cell.model = self.ShedexceptionArray[indexPath.row];
                 cell.hidden = [self.deletSection2 containsObject:@(indexPath.row)]? YES:NO;
             }
        }
        return cell;
    }
    if (self.Type==isFloorheating) {
        BLEJBudgetTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        cell.budgetTemplateCellDelegate = self;
        cell.indexPath = indexPath;
        cell.isShowMinus = self.isclickdMinusBtnshow;
        if (indexPath.section==0) {
            cell.model = self.dinuamArray0[indexPath.row];
            cell.hidden = [self.deletSection1 containsObject:@(indexPath.row)]? YES:NO;
        }
        if (indexPath.section==1) {
            cell.model = self.dinuamArray1[indexPath.row];
            cell.hidden = [self.deletSection2 containsObject:@(indexPath.row)]? YES:NO;
        }
        return cell;
    }
    if (self.Type==isFinishedproduct) {
        BLEJBudgetTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        cell.budgetTemplateCellDelegate = self;
        cell.indexPath = indexPath;
        cell.isShowMinus = self.isclickdMinusBtnshow;
        cell.model = self.chengpinArray[indexPath.row];
        cell.hidden = [self.deletSection1 containsObject:@(indexPath.row)]? YES:NO;
        return cell;
    }
    //地暖计算器
    if (self.Type==isFloorheating) {
        BLEJBudgetTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.budgetTemplateCellDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath = indexPath;
        cell.isShowMinus = self.isclickdMinusBtnshow;
        if (indexPath.section==0) {
            cell.model = self.dinuamArray0[indexPath.row];
            cell.hidden = [self.deletSection1 containsObject:@(indexPath.row)]? YES:NO;
        }
        if (indexPath.section==1) {
            cell.model = self.dinuamArray1[indexPath.row];
            cell.hidden = [self.deletSection2 containsObject:@(indexPath.row)]? YES:NO;
        }
        return cell;
    }
    //成品计算器
    if (self.Type==isFinishedproduct) {
        BLEJBudgetTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.budgetTemplateCellDelegate = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isShowMinus = self.isclickdMinusBtnshow;
        cell.hidden = [self.deletSection1 containsObject:@(indexPath.row)]? YES:NO;
        cell.model = self.chengpinArray[indexPath.row];
        return cell;
    }
    return [UITableViewCell new];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    if (self.Type ==isTaocan||self.Type==isPipe) {
        if (indexPath.section ==0) {
         self.indexPath = indexPath;

       }
    }
    
    if(self.Type ==isQinfu){//轻铺计算器
//    // 这个用于弹出视图2的时候那些可以进行编辑(0: 什么都可以编辑  1: 只可以编辑面积 2: 可以编辑单价和工艺)
//    @property (copy, nonatomic) NSString *edittingType;
//    // 这个是用来设置显示的文字 (0 : 面积 平米 单价 元  1: 面积 平米 单价 %  2: 数量 自定义单位 单价 元)
        if (!self.isEditting) {
            NSLog(@"请切换到编辑状态");
            return;
        }
       
    BLEJBudgetTemplateCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.indexPath = indexPath;
    if (indexPath.section == 0) {
        self.bottomView.allcalModel = self.baseItemsArr[indexPath.row];
    } else {
        self.bottomView.allcalModel = self.suppleListArr[indexPath.row];
    }
    if (indexPath.section == 0) {
        self.bottomView.viewType = 3;

        if ([cell.cellType isEqualToString:@"0"]) {
            
            self.bottomView.edittingType = @"2";
            self.bottomView.showType = @"0";
        }
        if ([cell.cellType isEqualToString:@"1"]) {
            
            self.bottomView.edittingType = @"2";
            self.bottomView.showType = @"1";
        }
        if ([cell.cellType isEqualToString:@"2"]) {
            
            self.bottomView.edittingType = @"2";
            self.bottomView.showType = @"2";
        }
    } else {
        self.bottomView.viewType = 5;
        self.bottomView.edittingType = @"0";
        self.bottomView.showType = @"3";
    }    
      
        
        self.bottomView.hidden = NO;
        [self.view sendSubviewToBack:self.editBtn];
    }else if  (self.Type == isFloorBrick ) {
        if (!self.isEditting) {
            NSLog(@"请切换到编辑状态");
            return;
        }
        BLEJFloorBrickViewController *brick =[BLEJFloorBrickViewController new];
        brick.isFromLastController=YES;
        brick.companyID=self.companyID;
        brick.calcaulatorType=self.allCalculatorCompanyData.calculatorType;
        brick.isLastRowSelected = indexPath.section ==3?YES:NO;
        self.isLastRowSelected =indexPath.section ==3?YES:NO;
        brick.isClickplusBtn =NO;
        self.indexPath=indexPath;
        brick.blockBrick = ^(NSDictionary *dictPass) {
            self.isNewAdded=NO;
            [self addModelForBrickOrWoodWithDictionary:dictPass withSection:indexPath.section];
            
            [self.tableView reloadData];
        };
     
        if (indexPath.section==0) {
            brick.model = self.Bricksection1[indexPath.row];
            brick.Contrlollertitle =@"地砖添加";
        }else if ( indexPath.section==1) {
           brick.model = self.Bricksection2[indexPath.row];
             brick.Contrlollertitle =@"墙砖添加";
        }else if ( indexPath.section==2) {
           brick.model = self.Bricksection3[indexPath.row];
             brick.Contrlollertitle =@"踢脚线添加";
        }else if ( indexPath.section==3) {
            brick.model = self.Bricksection4[indexPath.row];
            brick.Contrlollertitle =@"其他添加";
        }
      
        [self.navigationController pushViewController:brick animated:YES];

    }else if (self.Type==isFloorWood || self.Type==isShedLine||self.Type==isFloorheating||self.Type==isFinishedproduct){
        if (!self.isEditting) {
            NSLog(@"请切换到编辑状态");
            return;
        }
        BLEJFloorBrickViewController *brick =[BLEJFloorBrickViewController new];
        brick.isFromLastController=YES;
        brick.companyID=self.companyID;
        brick.calcaulatorType=self.allCalculatorCompanyData.calculatorType;
        brick.isLastRowSelected = indexPath.section ==2?YES:NO;
        self.isLastRowSelected =indexPath.section ==2?YES:NO;
        brick.isClickplusBtn=NO;
        self.indexPath=indexPath;
        brick.blockBrick = ^(NSDictionary *dictPass) {
            self.isNewAdded =NO;
            [self addModelForBrickOrWoodWithDictionary:dictPass withSection:indexPath.section];
            [self.tableView reloadData];
        };
        
        if (self.Type==isFloorWood) {
            if (indexPath.section==0) {
                brick.model = self.WoodGroudArray[indexPath.row];
                brick.Contrlollertitle =@"地砖添加";

            }
            if (indexPath.section==1) {
                brick.model = self.WoodLineArray[indexPath.row];
                brick.Contrlollertitle =@"墙砖添加";

            }
            if (indexPath.section==2) {
                brick.model = self.WoodexceptionArray[indexPath.row];
                brick.Contrlollertitle =@"其他添加";

            }
        }
        if (self.Type==isShedLine) {
            if (indexPath.section==0) {
                brick.model = self.ShedGroudArray[indexPath.row];
                brick.Contrlollertitle =@"棚板添加";

            }
            if (indexPath.section==1) {
                brick.model = self.ShedLineArray[indexPath.row];
                brick.Contrlollertitle =@"棚角线添加";

            }
            if (indexPath.section==2) {
                brick.model = self.ShedexceptionArray[indexPath.row];
                brick.Contrlollertitle =@"其他添加";
            }
        }
        if (self.Type==isFloorheating) {
            if (indexPath.section==0) {
                brick.model = self.dinuamArray0[indexPath.row];
                brick.Contrlollertitle =@"地暖添加";
            }
            if (indexPath.section==1) {
                brick.model = self.dinuamArray1[indexPath.row];
                brick.Contrlollertitle =@"其他添加";
            }
        }
        if (self.Type==isFinishedproduct) {
            brick.model = self.chengpinArray[indexPath.row];
            brick.Contrlollertitle =@"其他添加";
        }
        [self.navigationController pushViewController:brick animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.Type==isTaocan||self.Type==isPipe) {
        if (section==0) {
             return 44;
        }else{
            return 0.001;
        }
       
    }
    if (self.Type == isQinfu) {
        return 44;
    }
    if (self.Type==isFloorWood || self.Type ==isFloorBrick ||self.Type == isShedLine||self.Type==isFloorheating||self.Type==isFinishedproduct||self.Type==isFloorheating||self.Type==isFinishedproduct) {
        return 44;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.Type ==isTaocan||self.Type==isPipe) {
        if (section ==0) {
            _segmentView = [[UIView alloc] init];
            NSMutableArray *segmentedArray=[NSMutableArray arrayWithObjects:self.packageName699simple?:@"699.0套餐",self.packageName999Refine?:@"999.0套餐", nil];//
            self.segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
            self.segmentedControl .frame=CGRectMake(BLEJWidth/4, 5, BLEJWidth/2, 30);
            self.segmentedControl .tintColor = kMainThemeColor;
            self.segmentedControl.momentary=NO;
            [self.segmentedControl  addTarget:self action:@selector(SegmentedControl:) forControlEvents:UIControlEventValueChanged];
            [self.segmentView addSubview:self.segmentedControl ];
            return self.segmentView;
        }
    }
    if (self.Type ==isQinfu){
    BLEJBudgetTemplateGroupHeaderCell *SectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeaderIdentifier];
        SectionHeader.budgetTemplateGroupHeaderCellDelegate = self;
        SectionHeader.sectionIndex = section;
        if (!SectionHeader) {
            SectionHeader = [[BLEJBudgetTemplateGroupHeaderCell alloc] initWithReuseIdentifier:reuseHeaderIdentifier];
        }
    SectionHeader.title = section == 0 ? @"基础项目" : @"自定义项目";
    if (section == 1) {
         SectionHeader.isShowMinusAndPlusBtn =self.isEditting  ? YES : NO;
        SectionHeader.isRotate =self.isclickdMinusBtnshow?YES:NO;
    
    }else{
        SectionHeader.isShowMinusAndPlusBtn = NO;
        SectionHeader.isRotate = NO;
    }
       return SectionHeader;
    }
    if (self.Type== isFloorBrick ) {
        BLEJBudgetTemplateGroupHeaderCell *SectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeaderIdentifier];
        SectionHeader.budgetTemplateGroupHeaderCellDelegate = self;
        SectionHeader.sectionIndex = section;
        NSArray *sectionArr=@[ @"地砖",@"墙砖",@"踢脚线/腰线",@"其他"];
        SectionHeader.title = sectionArr[section];
        SectionHeader.isShowMinusAndPlusBtn =self.isEditting  ? YES : NO;
        SectionHeader.isRotate =self.isclickdMinusBtnshow?YES:NO;
        return SectionHeader;
    }else if( self.Type ==isFloorWood ||self.Type==isShedLine){
        BLEJBudgetTemplateGroupHeaderCell *SectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeaderIdentifier];
        SectionHeader.budgetTemplateGroupHeaderCellDelegate = self;
        SectionHeader.sectionIndex = section;
        NSArray *sectionArr=@[ @"地砖",@"墙砖",@"其他"];
        NSArray *sectionLine=@[ @"棚板",@"棚角线",@"其他"];
        SectionHeader.title =self.Type==isFloorWood? sectionArr[section]:sectionLine[section];
        SectionHeader.isShowMinusAndPlusBtn =self.isEditting  ? YES : NO;
        SectionHeader.isRotate =self.isclickdMinusBtnshow?YES:NO;
        return SectionHeader;
    }
    else if (self.Type==isFloorheating)
    {
        BLEJBudgetTemplateGroupHeaderCell *SectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeaderIdentifier];
        SectionHeader.budgetTemplateGroupHeaderCellDelegate = self;
        SectionHeader.sectionIndex = section;
        NSArray *sectionArr=@[@"管材",@"其他"];
        SectionHeader.title = sectionArr[section];
        SectionHeader.isShowMinusAndPlusBtn =self.isEditting  ? YES : NO;
        SectionHeader.isRotate =self.isclickdMinusBtnshow?YES:NO;
        return SectionHeader;
    }
    else if (self.Type==isFinishedproduct)
    {
        BLEJBudgetTemplateGroupHeaderCell *SectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeaderIdentifier];
        SectionHeader.budgetTemplateGroupHeaderCellDelegate = self;
        SectionHeader.sectionIndex = section;
        NSArray *sectionArr=@[@"商品"];
        SectionHeader.title = sectionArr[section];
        SectionHeader.isShowMinusAndPlusBtn =self.isEditting  ? YES : NO;
        SectionHeader.isRotate =self.isclickdMinusBtnshow?YES:NO;
        return SectionHeader;
    }
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
   if (self.Type == isTaocan||self.Type==isPipe) {
     if (indexPath.section ==0) {
        
        if (self.isPackage699 ==YES ) {
            return self.cell.cellHeight;
        }else if (self.isPackage699 ==NO) {
            return self.cell.cellHeight;
        }
    }else if (indexPath.section ==1) {
            if (_isPackage699==YES) {
                if (self.picUrl.length>0 ) {
                    return BLEJWidth*0.6;
                }
            }else{
               if (self.picUrl1.length>0) {
                 return BLEJWidth*0.6;
               }
           }
                return 0.001;
          }
    }
    if(self.Type==isQinfu){//轻辅计算器
       if (indexPath.section == 1) {
           if ([self.indexArr containsObject:@(indexPath.row)]) {
                   return 0.001;
            }
              }else{
                    return 44;
            }
        return 44;
     }
    if (self.Type==isFloorBrick) {
        if ( indexPath.section==0) {
                return [self.deletSection1 containsObject:@(indexPath.row)]?0.001:44;
        }else if ( indexPath.section==1) {
           return [self.deletSection2 containsObject:@(indexPath.row)]? 0.001:44;
        }else if ( indexPath.section==2) {
         
              return [self.deletSection3 containsObject:@(indexPath.row)]? 0.001:44;
        }else if ( indexPath.section==3) {
               return [self.deletSection4 containsObject:@(indexPath.row)]? 0.001:44;
        }

    }else if(self.Type==isFloorWood||self.Type==isShedLine){
        if (indexPath.section==0) {
            return [self.deletSection1 containsObject:@(indexPath.row)]?0.001:44;
        }else if ( indexPath.section==1) {
            return [self.deletSection2 containsObject:@(indexPath.row)]? 0.001:44;
        }else if ( indexPath.section==2) {
            
            return [self.deletSection3 containsObject:@(indexPath.row)]? 0.001:44;
        }
        
     }
    else if (self.Type==isFloorheating)
    {
        if (indexPath.section==0) {
             return [self.deletSection1 containsObject:@(indexPath.row)]?0.001:44;
        }
        if (indexPath.section==1) {
             return [self.deletSection2 containsObject:@(indexPath.row)]?0.001:44;
        }
        return 44;
    }
    else if (self.Type==isFinishedproduct)
    {
        return [self.deletSection1 containsObject:@(indexPath.row)]?0.001:44;
    }
    return 0.001;

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.tableView.contentOffset.y>400) {
        [self.plyer pausePlay];
    }
}

#pragma mark -sectionHeader 加减cell的方法
// 点击+
- (void)didClickPlusBtnWithSection:(NSInteger)section {
    
    if (!self.isEditting) {
        NSLog(@"请切换到编辑状态");
        return;
    }
    if (self.Type==isQinfu) {
        self.bottomView.viewType = 4;
        self.bottomView.allcalModel = nil;
        self.bottomView.edittingType = @"0";
        self.bottomView.showType = @"3";
        self.bottomView.hidden = NO;
        [self.view sendSubviewToBack:self.editBtn];
        [self.tableView reloadTableViewWithRow:-1 andSection:section];
    }
    if (self.Type==isFloorWood ||self.Type==isFloorBrick||self.Type==isShedLine||self.Type==isFinishedproduct||self.Type==isFloorheating) {

        BLEJFloorBrickViewController *floor =[[BLEJFloorBrickViewController alloc]init];
        floor.section=section;
        floor.companyID =self.companyID;
        floor.isClickplusBtn=YES;
        floor.isFromLastController=NO;
        floor.calcaulatorType=self.allCalculatorCompanyData.calculatorType;
        
        if (self.Type==isShedLine) {
            floor.isLastRowSelected = section == 2?YES:NO;
            self.isLastRowSelected = section == 2?YES:NO;
            if (section==0) {
                floor.Contrlollertitle = @"栅板添加";
            }
            if (section==1) {
                 floor.Contrlollertitle = @"栅角线添加";
            }
            if (section==2) {
                 floor.Contrlollertitle = @"其他添加";
            }
        }
        if (self.Type==isFloorWood) {
            floor.isLastRowSelected = section == 2?YES:NO;
            self.isLastRowSelected = section == 2?YES:NO;
            if (section==0) {
                floor.Contrlollertitle = @"地砖添加";
            }
            if (section==1) {
                floor.Contrlollertitle = @"墙砖添加";
            }
            if (section==2) {
                floor.Contrlollertitle = @"其他添加";
            }
        }
        if (self.Type==isFloorBrick) {
             floor.isLastRowSelected = section== 3?YES:NO;
             self.isLastRowSelected= section == 3?YES:NO;
         
            if (section==0) {
                floor.Contrlollertitle = @"地砖添加";
            }
            if (section==1) {
                floor.Contrlollertitle = @"墙砖添加";
            }
            if (section==2) {
                floor.Contrlollertitle = @"踢脚线添加";
            }
            if (section==3) {
                floor.Contrlollertitle = @"其他添加";
            }
        }
        if (self.Type==isFinishedproduct) {
            floor.isLastRowSelected = section== 0?YES:NO;
            self.isLastRowSelected= section == 0?YES:NO;
            floor.Contrlollertitle = @"其他";
        }
        if (self.Type==isFloorheating) {
//            floor.isLastRowSelected = section== 1?YES:NO;
//            self.isLastRowSelected= section == 1?YES:NO;
            floor.isLastRowSelected = YES;
            self.isLastRowSelected = YES;
            if (section==0) {
                floor.Contrlollertitle = @"地暖添加";
            }
            if (section==1) {
                floor.Contrlollertitle = @"其他";
            }
        }
        floor.blockBrick = ^(NSDictionary *dictPass) {
            self.isNewAdded =YES;
            [self addModelForBrickOrWoodWithDictionary:dictPass withSection:section];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:floor animated:YES];
    }
}

// 点击-
- (void)didClickMinusBtnWithSection:(NSInteger)section andIsSelected:(BOOL)isSeleted {
    if (!self.isEditting) {
        NSLog(@"请切换到编辑状态");
        return;
    }
    BLEJBudgetTemplateGroupHeaderCell *SectionHeader = (BLEJBudgetTemplateGroupHeaderCell *)[self.tableView headerViewForSection:section];
    self.isclickdMinusBtnshow =!self.isclickdMinusBtnshow;
    SectionHeader.isRotate= self.isclickdMinusBtnshow;
    if (self.Type==isQinfu) {
       [self.tableView reloadTableViewWithRow:-1 andSection:section];
    }
    if (self.Type==isFloorWood ||self.Type==isFloorBrick||self.Type==isShedLine||self.Type==isFloorheating||self.Type==isFinishedproduct) {
       [self.tableView reloadTableViewWithRow:-1 andSection:section];
        
    }
}

#pragma mark 添加model

-(void)addModelForBrickOrWoodWithDictionary:(NSDictionary *)parameter  withSection:(NSInteger)section{
    
     NSString *spec =[parameter objectForKey:@"lenthandwidth"];
     NSString *lenth =[parameter objectForKey:@"lenth"];
     NSString *width =[parameter objectForKey:@"width"];
     NSString *price =[parameter objectForKey:@"price"];
     NSString *merchantID =[parameter objectForKey:@"goodid"];
     NSString *merchantName=[parameter objectForKey:@"merchandname"];
   
    BLRJCalculatortempletModelAllCalculatorTypes *model=[BLRJCalculatortempletModelAllCalculatorTypes new];
    
    BLEJBudgetTemplateGroupHeaderCell*groupHeader=  (BLEJBudgetTemplateGroupHeaderCell *)[self.tableView headerViewForSection:section] ;
    NSInteger zeroCal=0;
    NSString *string =[NSString stringWithFormat:@"%ld",(long)zeroCal];
   
    model.supplementName= merchantName?:groupHeader.title;
    model.spec=spec ?:@"";
    model.deal =300;
    model.supplementPrice=price?:@"";
    model.templeteId=[self.allCalculatorCompanyData.templetId integerValue]?:zeroCal;
    model.merchandId=[merchantID integerValue]?:zeroCal;
    model.width=[width integerValue]?:zeroCal;
    model.length=[lenth integerValue]?:zeroCal;
    
    if (self.Type==isFloorWood ||self.Type==isShedLine) {
        if (section ==2) {
            model.supplementPrice=lenth?:@"";
            model.supplementName=spec ?:string;
            model.merchandId =[merchantID integerValue]?:zeroCal;
        }
    }else if (self.Type==isFloorBrick){
         if (section ==3) {
             model.supplementPrice=lenth?:@"";
             model.supplementName=spec ?:string;
             model.merchandId =[merchantID integerValue]?:zeroCal;
         }
    }
    if (self.Type==isFloorBrick) {
        switch (section) {
            case 0:
                model.templeteTypeNo=3000;
                if (self.isNewAdded) {
                     [self.Bricksection1 addObject:model];
                }
                break;
            case 1:
                model.templeteTypeNo=3100;
                if (self.isNewAdded) {
                    [self.Bricksection2 addObject:model];
                }
                break;
            case 2:
                model.templeteTypeNo=3200;
                [self.Bricksection3 addObject:model];
                
                break;
            case 3:
                model.templeteTypeNo=3300;
                [self.Bricksection4 addObject:model];
                break;
            default:
                break;
            }
        }
        if (self.Type==isFloorWood) {//地板计算器
            if (section==0) {
                model.templeteTypeNo=4000;
                [self.WoodGroudArray addObject:model];

            }
            if (section==1) {
                model.templeteTypeNo=4100;
                [self.WoodLineArray addObject:model];
            }
            if (section==2) {
                model.templeteTypeNo=4200;
                [self.WoodexceptionArray addObject:model];

            }

        }
        if (self.Type==isShedLine) {
            if (section==0) {
                model.templeteTypeNo=5000;
                [self.ShedGroudArray addObject:model];

            }
            if (section==1) {
                model.templeteTypeNo=5100;
                [self.ShedGroudArray addObject:model];

            }
            if (section==2) {
                model.templeteTypeNo=5200;
                [self.ShedGroudArray addObject:model];
            }
        }
        if (self.Type==isFloorheating) {//地暖计算器
            if (section==0) {
                model.templeteTypeNo=6000;
                [self.dinuamArray0 addObject:model];
            }
            if (section==1) {
                model.templeteTypeNo=6100;
                [self.dinuamArray1 addObject:model];
            }
        }
        if (self.Type==isFinishedproduct) {//成品计算器
            model.templeteTypeNo=7000;
            [self.chengpinArray addObject:model];
        }
}

#pragma mark - BLEJBudgetTemplateCellDelegate 删除cell方法

- (void)didClickDeleteBtn:(NSIndexPath *)indexPath {

    if (self.Type==isQinfu) {
        BLRJCalculatortempletModelAllCalculatorTypes *model = self.suppleListArr[indexPath.row];
        if (model.deal ==200) {
            model.deal =2;
        }
        model.deal=2;
        [self.indexArr addObject:@(indexPath.row)];
        [self.tableView reloadData];
        
    }else if (self.Type==isFloorBrick){

        if ( indexPath.section==0) {
             BLRJCalculatortempletModelAllCalculatorTypes *model = self.Bricksection1[indexPath.row];
            if (model.deal == 0)  {
                  model.deal=[[NSString stringWithFormat:@"%d",2] integerValue];
            }
            
            [self.deletSection1 addObject:@(indexPath.row)];
        }else if( indexPath.section==1) {
            BLRJCalculatortempletModelAllCalculatorTypes *model =
            self.Bricksection2[indexPath.row];
            if ( model.deal == 0) {
                model.deal=[[NSString stringWithFormat:@"%d",2] integerValue];
            }
            [self.deletSection2 addObject:@(indexPath.row)];
        }else if ( indexPath.section==2) {
            BLRJCalculatortempletModelAllCalculatorTypes *model =
            self.Bricksection3[indexPath.row];
             if (model.deal == 0) {
                model.deal=[[NSString stringWithFormat:@"%d",2] integerValue];
            }
            [self.deletSection3 addObject:@(indexPath.row)];
        }else if ( indexPath.section==3) {
            BLRJCalculatortempletModelAllCalculatorTypes *model =
            self.Bricksection4[indexPath.row];
             if (model.deal == 0) {
                model.deal=[[NSString stringWithFormat:@"%d",2] integerValue];
            }
            [self.deletSection4 addObject:@(indexPath.row)];
        }
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }else if (self.Type==isFloorWood ||self.Type==isShedLine){

        [self.deletSection1 removeAllObjects];
        [self.deletSection2 removeAllObjects];
        [self.deletSection3 removeAllObjects];
        if (indexPath.section==0) {
            BLRJCalculatortempletModelAllCalculatorTypes *model = self.Type==isShedLine?self.ShedGroudArray[indexPath.row]:
            self.WoodGroudArray[indexPath.row];
           if (model.deal == 0) {
                model.deal=[[NSString stringWithFormat:@"%d",2] integerValue];
            }
           [self.deletSection1 addObject:@(indexPath.row)];
        }else if ( indexPath.section==1) {
            BLRJCalculatortempletModelAllCalculatorTypes *model = self.Type==isShedLine?self.ShedLineArray[indexPath.row]:
             self.WoodLineArray[indexPath.row];
            if (model.deal == 0) {
                model.deal=[[NSString stringWithFormat:@"%d",2] integerValue];
            }
            [self.deletSection2 addObject:@(indexPath.row)];
        }else if (indexPath.section==2) {
            BLRJCalculatortempletModelAllCalculatorTypes *model = self.Type==isShedLine?self.ShedexceptionArray[indexPath.row]:
            self.WoodexceptionArray[indexPath.row];
            
           if (model.deal == 0) {
                model.deal=[[NSString stringWithFormat:@"%d",2] integerValue];
            }
            [self.deletSection3 addObject:@(indexPath.row)];
        }
      
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (self.Type==isFloorheating)
    {
        if (indexPath.section==0) {
            BLRJCalculatortempletModelAllCalculatorTypes *model = self.dinuamArray0[indexPath.row];
            if (model.deal == 0) {
                model.deal=[[NSString stringWithFormat:@"%d",2] integerValue];
            }
            [self.deletSection1 addObject:@(indexPath.row)];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
        if (indexPath.section==1) {
            BLRJCalculatortempletModelAllCalculatorTypes *model = self.chengpinArray[indexPath.row];
            if (model.deal == 0) {
                model.deal=[[NSString stringWithFormat:@"%d",2] integerValue];
            }
            [self.deletSection2 addObject:@(indexPath.row)];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }else if (self.Type==isFinishedproduct)
    {
        BLRJCalculatortempletModelAllCalculatorTypes *model = self.dinuamArray0[indexPath.row];
        if (model.deal == 0) {
            model.deal=[[NSString stringWithFormat:@"%d",2] integerValue];
        }
        [self.deletSection1 addObject:@(indexPath.row)];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }

    
}

#pragma mark - 通知处理

- (void)notificationBaseReplaceMes:(NSNotification *)noc {
    
    NSDictionary *dic = noc.userInfo;
    BLRJCalculatortempletModelAllCalculatorTypes *model = self.baseItemsArr[self.indexPath.row];
  
    if ([@[@10, @11, @12, @13,@14] containsObject:@(self.indexPath.row)]) {
        NSString *price = [NSString stringWithFormat:@"%.4f", [[dic objectForKey:@"price"] doubleValue] / 100];
        model.supplementPrice =  price;
    } else {
        model.supplementPrice = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"price"] doubleValue]];
    }
    if (model.deal ==200) {
        model.deal =200;
    }
    model.deal=1;
    model.supplementTech = [dic objectForKey:@"supplementTech"];
    [self.baseItemsArr replaceObjectAtIndex:self.indexPath.row withObject:model];
    [self.view bringSubviewToFront:self.editBtn];
    [self.tableView reloadData];
}


- (void)notificationReplaceMes:(NSNotification *)noc {
    
    NSDictionary *dic = noc.userInfo;
    
    if (self.Type==isQinfu) {
        BLRJCalculatortempletModelAllCalculatorTypes *model = self.suppleListArr[self.indexPath.row];
         model.supplementPrice = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"price"] doubleValue]];
        model.supplementName = [dic objectForKey:@"name"];
        model.supplementUnit = [dic objectForKey:@"area"];
        model.supplementTech = [dic objectForKey:@"supplementTech"];
        if (model.deal ==200) {
            model.deal =200;
        }
        model.deal=1;

        [self.suppleListArr replaceObjectAtIndex:self.indexPath.row   withObject:model];
        [self.view bringSubviewToFront:self.editBtn];
        [self.tableView reloadData];
        
        
    }else if (self.Type==isFloorWood  ||self.Type==isFloorBrick||self.Type==isShedLine||self.Type==isFloorheating||self.Type==isFinishedproduct){
        
        
        BLRJCalculatortempletModelAllCalculatorTypes *model = [BLRJCalculatortempletModelAllCalculatorTypes new];
        
        
        if (self.indexPath.section==0) {
            if (self.Type==isShedLine) {
                model =self.ShedGroudArray[self.indexPath.row];
            }else{
                model  = self.Type==isFloorBrick?  self.Bricksection1[self.indexPath.row]:self.WoodGroudArray[self.indexPath.row];
            }
        }else if (self.indexPath.section==1){
            if (self.Type==isShedLine) {
                model =self.ShedLineArray[self.indexPath.row];
            }else{
                model = self.Type==isFloorBrick?  self.Bricksection2[self.indexPath.row]:self.WoodLineArray[self.indexPath.row];
            }
        }else if (self.indexPath.section==2){
            if (self.Type==isShedLine) {
                model =self.ShedexceptionArray[self.indexPath.row];
            }else{
              model  = self.Type==isFloorBrick?  self.Bricksection3[self.indexPath.row]:self.WoodexceptionArray[self.indexPath.row];
            }
        }else if (self.indexPath.section==3){
            model  = self.Type==isFloorBrick?self.Bricksection4[self.indexPath.row]:@"";
        }
 
        
        NSInteger zeroCal=0;
        NSString *string =[NSString stringWithFormat:@"%ld",(long)zeroCal];

        if (model.deal ==300) {
            model.deal =300;
        }else{
            model.deal=1;
        }
        model.supplementPrice= [dic objectForKey:@"price"] ?:string;
        model.supplementName=  [dic objectForKey:@"merchandname"] ?:@"";
        model.spec=[dic objectForKey:@"lenthandwidth"] ?:@"";
        model.length=[[dic objectForKey:@"lenth"] integerValue]?:zeroCal;
        model.width=[[dic objectForKey:@"width"]integerValue]?:zeroCal;
        
        model.templeteId=[self.allCalculatorCompanyData.templetId integerValue]?:zeroCal;
        model.merchandId=[[dic objectForKey:@"goodid"] integerValue]?:zeroCal;
        if (self.Type==isFloorWood||self.Type==isShedLine) {
            if (self.indexPath.section ==2) {
                model.supplementPrice=[dic objectForKey:@"price"]?:@"";
                model.supplementName=[dic objectForKey:@"merchandname"] ?:string;
                model.merchandId =[[dic objectForKey:@"merchandid"]integerValue]?:zeroCal;
            }
        }else{
            if (self.indexPath.section ==3) {
                model.supplementPrice=[dic objectForKey:@"price"]?:@"";
                model.supplementName=[dic objectForKey:@"merchandname"] ?:string;
                model.merchandId =[[dic objectForKey:@"merchandid"]integerValue]?:zeroCal;
            }
        }
        
        if ( self.indexPath.section==0) {
            if (self.Type==isFloorBrick) {
                  [self.Bricksection1 replaceObjectAtIndex:self.indexPath.row withObject:model];
            }else if(self.Type==isFloorWood){
                  [self.WoodGroudArray replaceObjectAtIndex:self.indexPath.row withObject:model];
            }else if(self.Type==isShedLine){
                [self.ShedGroudArray replaceObjectAtIndex:self.indexPath.row withObject:model];
            }
        }else if (self.indexPath.section==1){
            if (self.Type==isFloorBrick) {
                [self.Bricksection2 replaceObjectAtIndex:self.indexPath.row withObject:model];
            }else if(self.Type==isFloorWood){
                [self.WoodLineArray replaceObjectAtIndex:self.indexPath.row withObject:model];
            }else if(self.Type==isShedLine){
                [self.ShedLineArray replaceObjectAtIndex:self.indexPath.row withObject:model];
            }
            
        }else if (self.indexPath.section==2){
            if (self.Type==isFloorBrick) {
                [self.Bricksection3 replaceObjectAtIndex:self.indexPath.row withObject:model];
            }else if(self.Type==isFloorWood){
                    [self.WoodexceptionArray replaceObjectAtIndex:self.indexPath.row withObject:model];
                }else if(self.Type==isShedLine){
                    [self.ShedexceptionArray replaceObjectAtIndex:self.indexPath.row withObject:model];
                }
         
        }else if (self.indexPath.section==3){
            if (self.Type==isFloorBrick) {
                [self.Bricksection4 replaceObjectAtIndex:self.indexPath.row withObject:model];
            }
        }
        
        [self.view bringSubviewToFront:self.editBtn];
  
        [self.tableView reloadData];
    }
}

- (void)notificationAddMes:(NSNotification *)noc {
    NSDictionary *dic = noc.userInfo;
     NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    if (self.Type==isQinfu) {
        BLRJCalculatortempletModelAllCalculatorTypes *model = [[BLRJCalculatortempletModelAllCalculatorTypes alloc] init];
   
        model.supplementName = [dic objectForKey:@"name"];
        model.supplementUnit = [dic objectForKey:@"area"];
        model.deal = 200;//因为服务器返回的也是0 但是0 是新增的有冲突。这个把服务器返回的设置为3 把新的添加的设置为200；
        model.supplementTech = [dic objectForKey:@"supplementTech"];
        model.supplementPrice = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"price"] doubleValue]];
        [paramDic setValue:[dic objectForKey:@"supplementTech"] forKey:@"supplementTech"];
        [paramDic setValue:@"0" forKey:@"deal"];
        [paramDic setValue:[dic objectForKey:@"price"] forKey:@"supplementPrice"];
        [paramDic setValue:[dic objectForKey:@"area"] forKey:@"supplementUnit"];
        [paramDic setValue:[dic objectForKey:@"name"] forKey:@"supplementName"];
  
    
        NSMutableArray *arr = [self.param objectForKey:@"supplementList"];
        [arr addObject:paramDic];
        [self.suppleListArr addObject:model];

    }else if (self.Type == isFloorBrick){
       
    }
    
    [self.view bringSubviewToFront:self.editBtn];
    [self.tableView reloadData];
}

#pragma mark - 点击编辑和重置按钮

- (void)didClickEditBtn:(UIButton *)btn {

    [self.textView endEditing:YES];
  
    if (self.Type==isQinfu) {
        if ([btn.currentTitle isEqualToString:@"重置"] &&[self.rightBtn.currentTitle isEqualToString:@"完成"]) {
            
            __weak typeof(self) weakSelf = self;
            TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"设置精装/简装模板后，才可使用计算器，是否设置?" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    
                    [weakSelf ResetCalculatorTemplatePort];
                }
                
                
            } cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            
            [alertView show];
        }
    }
    
   
    //改变编辑按钮的状态
    [self didClickEdittingBtn];
    
}

- (void)didClickEdittingBtn {
    self.isEditting = !self.isEditting;
    [self.editBtn setTitle:self.isEditting ? @"重置" : @"编辑" forState:UIControlStateNormal];
    if (self.Type!=isQinfu) {
        self.editBtn.hidden= !self.editBtn.hidden;
    }
    if ([self.editBtn.currentTitle isEqualToString:@"重置"]) {
        [self.rightBtn setTitle:@"完成"  forState:UIControlStateNormal];
    }else{
        [self.rightBtn setTitle: @"···" forState:UIControlStateNormal];
    }
    if (self.Type==isQinfu) {
        BLEJBudgetTemplateGroupHeaderCell *view = (BLEJBudgetTemplateGroupHeaderCell *)[self.tableView headerViewForSection:1];
        view.isShowMinusAndPlusBtn = [self.editBtn.currentTitle isEqualToString:@"重置"] ? YES : NO;
    }
    if (self.Type==isFloorBrick ||self.Type==isFloorWood|| self.Type==isShedLine||self.Type==isFinishedproduct||self.Type==isFloorheating) {
        BLEJBudgetTemplateGroupHeaderCell *view = [[BLEJBudgetTemplateGroupHeaderCell  alloc]init];
        view.isShowMinusAndPlusBtn = [self.editBtn.currentTitle isEqualToString:@"重置"] ? YES : NO;
        [self.tableView reloadData];
    }

}

#pragma mark 返回的点击事件

- (void)back {
    
    [self.textView endEditing:YES];
    if ([self.editBtn.currentTitle isEqualToString:@"重置"] ||[self.rightBtn.currentTitle isEqualToString:@"···"]) {
        
        switch (self.Type) {
            case isQinfu:
                 [self CalculatorType:@"1"];
                break;
            case isTaocan:
                 [self CalculatorType:@"2"];
                break;
            case isFloorBrick:
                 [self CalculatorType:@"3"];
                break;
            case isFloorWood:
                 [self CalculatorType:@"4"];
                break;
            case isShedLine:
                 [self CalculatorType:@"5"];
                break;
            case isWallpaper:
                break;
            case isFloorheating:
                 [self CalculatorType:@"7"];
                break;
            case isFinishedproduct:
                 [self CalculatorType:@"8"];
                break;
            case isPipe:
                 [self CalculatorType:@"9"];
                break;
                
            default:
                break;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)isButtonTouched{
    ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
    VC.titleStr = @"使用说明";
    VC.webUrl = @"http://api.bilinerju.com/api/designs/14053/10094.htm";
    VC.isAddBaseUrl = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)changeTableViewFrame{
    CGFloat heigthTable=BLEJHeight - self.navigationController.navigationBar.bottom ;
    [UIView animateWithDuration:.5 animations:^{
        self.tableView.height=heigthTable;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 右侧按钮切换计算器

- (void)didClickShareBtn:(UIButton *)btn {
  
//    计算器类型(1.轻辅计算器,2.套餐计算器,3.瓷砖计算器,4.地板计算器,5.集成吊顶计算器,6.壁纸、壁布计算器,7.地暖计算器,8.成品计算器)
    
    if ([btn.currentTitle isEqualToString:@"···"] ){
    __weak typeof(self) weakSelf = self;
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(BLEJWidth-200, 64, 200, 0) selectData:self.rigthItemChoiceArray images:nil action:^(NSInteger index) {
        switch (index) {
            case 0:
                [weakSelf continueShare];
                break;
            case 1:
                self.isclickdMinusBtnshow=NO;
                self.Type = isQinfu;
                self.title = @"轻辅报价模板";
                self.editBtn.hidden=NO;
                self.allCalculatorCompanyData.calculatorType=[NSString stringWithFormat:@"%@",@"1"];
              
                [self.tableView reloadData];
               
                break;
                
            case 2:
    
                [self changeTableViewFrame];
                self.isclickdMinusBtnshow=NO;
                self.Type = isTaocan;
                self.editBtn.hidden=YES;
                self.allCalculatorCompanyData.calculatorType=[NSString stringWithFormat:@"%@",@"2"];
                self.title =@"套餐报价模板";
                self.isPackage699=YES;
                [self CalculatorType:self.allCalculatorCompanyData.calculatorType];
                [self getDataFromServer];

                break;
            case 3:
               
               
                self.title = @"瓷砖计算器";
                self.isclickdMinusBtnshow=NO;
                self.allCalculatorCompanyData.calculatorType=[NSString stringWithFormat:@"%@",@"3"];
                
                self.Type = isFloorBrick;
                self.editBtn.hidden=NO;
                [self.tableView reloadData];
                
                break;
            case 4:
              
                self.title = @"地板计算器";
                self.allCalculatorCompanyData.calculatorType=[NSString stringWithFormat:@"%@",@"4"];
                self.isclickdMinusBtnshow=NO;
                self.Type = isFloorWood;
                self.editBtn.hidden=NO;
                [self.tableView reloadData];
                break;
            case 5:
                self.title = @"集成吊顶报价模版";
                self.allCalculatorCompanyData.calculatorType=[NSString stringWithFormat:@"%@",@"5"];
                self.isclickdMinusBtnshow=NO;
                self.Type = isShedLine;
                self.editBtn.hidden=NO;
                [self.tableView reloadData];
                
                break;
  
            case 6:
                
                self.title = @"地暖计算器";
                self.Type = isFloorheating;
                self.isclickdMinusBtnshow=NO;
                self.editBtn.hidden = NO;
                self.allCalculatorCompanyData.calculatorType=[NSString stringWithFormat:@"%@",@"7"];
                [self.tableView reloadData];
                break;
            case 7:
                self.title = @"成品计算器";
                self.Type = isFinishedproduct;
                self.editBtn.hidden = NO;
                self.allCalculatorCompanyData.calculatorType=[NSString stringWithFormat:@"%@",@"8"];
                [self.tableView reloadData];
                break;
            case 8:
                self.title = @"管道计算器";
                [self changeTableViewFrame];
                self.isclickdMinusBtnshow=NO;
                self.Type = isPipe;
                self.editBtn.hidden=YES;
                self.allCalculatorCompanyData.calculatorType=[NSString stringWithFormat:@"%@",@"9"];
                self.isPackage699=YES;
                [self getDataFromServer];
                [self CalculatorType:self.allCalculatorCompanyData.calculatorType];
                [self.tableView reloadData];
                break;
            default:
                break;
        }
        
        } animated:YES];
    }

    /***如果要保存数据，btn的名字是完成****/
    if ([btn.currentTitle isEqualToString:@"完成"]) {
        
        if ([self.textView.text isEqualToString:@""]) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请添加商家说明"];
            return;
        }

        self.topView.frame = CGRectMake(0, 0, BLEJWidth, 360);
        self.budgetExplain.frame = CGRectMake(0, 160, BLEJWidth, 190);
        if (!self.isCanEdit) {
            self.topView.frame = CGRectMake(0, 0, BLEJWidth, 360 - 45);
            self.budgetExplain.frame = CGRectMake(0, 160 - 40 - 5, BLEJWidth, 190);
        }
        self.topBgView.hidden = NO;
        self.simpleBtn.hidden = NO;
        self.refineBtn.hidden = NO;
        self.tableView.tableHeaderView = self.topView;
                  //在此上传数据
             
                    [self didClickEdittingBtn];
                    [self updateBaseTemplate];
      
    }
}

- (void)continueShare {
    [self.shareView share];
}

#pragma mark - 简装按钮的点击事件

- (void)didClickSimpleSettingBtn:(UIButton *)btn {

    if (self.Type ==isTaocan||self.Type==isPipe) {
        BELJDetailPackageController *detailPackage =[BELJDetailPackageController new];
        detailPackage.dataArray =self.packageArrsimple;
        detailPackage.packageId699=self.packageId699simple;
        detailPackage.packageName699=self.packageName699simple;
        detailPackage.nameStr =self.picTitle;
        detailPackage.coverImgStr=self.picUrl;
        detailPackage.linkUrl =self.picHref;
        detailPackage.companyIdConstant=self.companyIDConstant;
        detailPackage.introduction=self.textView.text;
        detailPackage.agencyId=   self.model.agencysId;
        detailPackage.companyId=  self.model.companyId;
        detailPackage.isPackage699 =YES;
        
        if (self.Type==isTaocan) {

            detailPackage.type = @"0";
            detailPackage.price  =[NSString stringWithFormat:@"%@",self.taocaoPrice0]?:@"0";
        }
        else
        {

            detailPackage.type = @"2";
            detailPackage.price = [NSString stringWithFormat:@"%@",self.guandaoPirce0]?:@"0";
        }
        detailPackage.isFistr =self.packageArrrefine.count==0? YES:NO;
        [self.navigationController pushViewController:detailPackage animated:YES];
        
    }
    if (self.Type==isQinfu |self.Type==isFloorBrick |self.Type==isFloorWood|self.Type==isShedLine|self.Type==isFloorheating|self.Type==isFinishedproduct){
        [self ToSimpleSettingController];
    }
}

#pragma mark - 精装按钮的点击事件
- (void)didClickRefineSettingBtn:(UIButton *)btn {
    
    self.isClickedSimpleBtn =YES;
    if (self.Type == isTaocan||self.Type==isPipe) {
        BELJDetailPackageController *detailPackage =[BELJDetailPackageController new];
        detailPackage.dataArray =self.packageArrrefine;
        detailPackage.packageId999 =self.packageId999refine;
        detailPackage.packageName999=self.packageName999Refine;
        detailPackage.nameStr =self.picTitle1;
        detailPackage.coverImgStr=self.picUrl1;
        detailPackage.linkUrl =self.picHref1;
        detailPackage.companyIdConstant=self.companyIDConstant;
        detailPackage.introduction=self.textView.text;
        detailPackage.agencyId = self.model.agencysId;
        detailPackage.companyId = self.model.companyId;
        detailPackage.isPackage699 = NO;
        //detailPackage.type = self.isPackage699 ==YES?@"0":@"1";
        if (self.Type==isTaocan) {
            
            detailPackage.type = @"1";
            detailPackage.price  = [NSString stringWithFormat:@"%@",self.taocaoPrice1];
        }
        if (self.Type==isPipe) {

            detailPackage.type = @"3";
            detailPackage.price  = [NSString stringWithFormat:@"%@",self.guandaoPirce1]?:@"0";
        }
        detailPackage.isFistr =self.packageArrrefine.count==0? YES:NO;
        [self.navigationController pushViewController:detailPackage animated:YES];
    }
    if (self.Type==isQinfu |self.Type==isFloorBrick |self.Type==isFloorWood|self.Type==isShedLine|self.Type==isFloorheating|self.Type==isFinishedproduct){
        [self ToSimpleSettingController];
    }
}

#pragma mark - 收集号码的点击事件

- (void)didClickCollectBtn:(UIButton *)btn {
    
    // 会员套餐
    VipGroupViewController *VC = [[UIStoryboard storyboardWithName:@"VipGroupViewController" bundle:nil] instantiateInitialViewController];
    VC.companyId = self.companyID;
    __weak typeof(self) weakSelf = self;
    VC.successBlock = ^() {
        [weakSelf getDataWithType:@"2"];
    };
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma  mark 业务员二维码续费
- (void)renewButtonAction {
    
    [self didClickTwoDimensionCodeView:nil];
    ZCHCalculatorPayController *payVC = [UIStoryboard storyboardWithName:@"ZCHCalculatorPayController" bundle:nil].instantiateInitialViewController;
    payVC.companyId = self.model.companyId;
    payVC.type = @"1";
    payVC.isNotCompany = YES;
    __weak typeof(self) weakSelf = self;
    payVC.refreshBlock = ^() {
        
        [weakSelf getSalerCode];
    };
    [self.navigationController pushViewController:payVC animated:YES];
}
#pragma mark 分享视图的点击事件
- (void)didClickShadowView:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.bottomShareView.blej_y = BLEJHeight;
    } completion:^(BOOL finished) {
        
        self.shadowView.hidden = YES;
    }];
}

- (void)didClickTwoDimensionCodeView:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.25 animations:^{


    }completion:^(BOOL finished) {
        
        self.TwoDimensionCodeView.hidden = YES;
    }];
}

- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

#pragma mark - UITextViewDelegate方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (!(self.Type ==isTaocan||self.Type==isPipe)) {
        if ([self.editBtn.currentTitle isEqualToString:@"编辑"]) {
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length) {
        self.feedLabel.hidden = YES;
    } else {
        self.feedLabel.hidden = NO;
    }
    if ([textView.text length] > 150) {
        textView.text = [textView.text substringToIndex:150];
        [textView resignFirstResponder];
        [self.view hudShowWithText:@"字数长度不要超过150字哦！"];
    }
}


#pragma  mark 跳转到简装精装设置
-(void)ToSimpleSettingController{
    
    ZCHSimpleSettingController *simpleVC = [[ZCHSimpleSettingController alloc] init];

    simpleVC.Calcaultortype =self.allCalculatorCompanyData.calculatorType;
    
    simpleVC.isSimple  =  self.isClickedSimpleBtn ==YES?YES:NO;
    self.isClickedSimpleBtn=NO;
    simpleVC.companyId = self.companyID;
    __weak typeof(self) weakSelf = self;
    simpleVC.refreshBlock = ^() {
        
        [weakSelf getDataWithType:@"1"];
    };
    [self.navigationController pushViewController:simpleVC animated:YES];

}

- (void)makeShareView {
   
    WeakSelf(self);
//    self.shareView.URL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/calculator/v3/html/?companyId=%@&agencyId=%@&origin=%@", self.companyID,@"",@"2"]];
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    self.shareView.URL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/calculator/v3/html/%@/%ld.htm?origin=%@", self.companyID,(long)userModel.agencyId,@"2"]];
    self.shareView.shareTitle = @"装修要花多少钱，点我10秒出报价";
    self.shareView.shareCompanyIntroduction = [NSString stringWithFormat:@"爱装修--%@", self.model.companyName];
    self.shareView.shareCompanyLogo = self.model.companyLogo;
    self.shareView.companyName = self.companyName.text;
    self.shareView.blockQRCode1st = ^{
        [weakself makeQRCodeWithType:1];
    };
    self.shareView.blockQRCode2nd = ^{
        [weakself makeQRCodeWithType:0];
    };
}

- (void)makeQRCodeWithType:(NSInteger)type {
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userModel.photo]]];
    FlowersStoryQRCodeViewController *controller = [FlowersStoryQRCodeViewController new];
    [controller.view setBackgroundColor:[UIColor whiteColor]];
    controller.labelTitle.text = @"扫一扫,十秒出装修报价";
    controller.viewCenter.hidden = true;
    controller.imageView2.hidden = true;
    controller.labelTitle2.hidden = true;

    controller.imageViewQRCode.hidden = true;
    
    NSString *shareElseURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/calculator/v3/html/%@/%ld.htm?origin=%@", self.companyID,(long)userModel.agencyId,@"2"]];
    
    if (type == 1) {//公司
        controller.title = @"公司二维码分享";
    
        controller.imageViewTop.image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:shareElseURL imageViewWidth:500];

        }else{
            controller.title = @"员工二维码分享";
            controller.imageViewTop.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareElseURL logoImageName:image logoScaleToSuperView:0.25];

    }
    [self.navigationController pushViewController:controller animated:true];
}

#pragma mark - 后台获取当前登录用户是否开通了业务员二维码

- (void)getSalerCode {
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"salesman/getVipInfo.do"];
    NSDictionary *param = @{
                            @"agencyId" : @(((UserInfoModel *)[[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict]).agencyId),
                            @"companyId" : self.companyID
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            self.openSaleCode = [responseObj[@"data"][@"vipInfo"][@"isVip"] integerValue];
            self.saleCodeDateLabel.text = [NSString stringWithFormat:@"%@到期", [[PublicTool defaultTool] getDateFormatStrFromTimeStampWithSeconds:responseObj[@"data"][@"vipInfo"][@"endDate"]]];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 计算图片按照比例显示
- (CGSize)calculateImageSizeWithSize:(CGSize)size {
    
    CGSize finalSize;
    if (size.width / BLEJWidth > size.height / BLEJHeight) {
        
        finalSize.width = size.width * BLEJWidth / size.width;
        finalSize.height = size.height * BLEJWidth / size.width;
    } else {
        
        finalSize.width = size.width * BLEJHeight / size.height;
        finalSize.height = size.height * BLEJHeight / size.height;
    }
    return finalSize;
}

#pragma mark 从服务器获取基础模版和数据

- (void)getDataWithType:(NSString *)type{
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSString *urlStr =[BASEURL stringByAppendingString:BLEJCalculatorGetTempletByCompanyIdUrl];
    NSString *companyId = self.companyID;
    NSDictionary *parameter = @{@"companyId":companyId};
    [NetManager afPostRequest:urlStr parms:parameter finished:^(id responseObj) {

    if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
        [self.param removeAllObjects];
        [self.baseItemsArr removeAllObjects];
        [self.suppleListArr removeAllObjects];
        [self.Bricksection1 removeAllObjects];
        [self.Bricksection2 removeAllObjects];
        [self.Bricksection3 removeAllObjects];
        [self.Bricksection4 removeAllObjects];
        [self.WoodGroudArray removeAllObjects];
        [self.WoodLineArray removeAllObjects];
        [self.WoodexceptionArray removeAllObjects];
        [self.WoodinstallArray removeAllObjects];
        [self.ShedGroudArray removeAllObjects];
        [self.ShedLineArray removeAllObjects];
        [self.ShedexceptionArray removeAllObjects];
        [self.dinuamArray0 removeAllObjects];
        [self.dinuamArray1 removeAllObjects];
        [self.chengpinArray removeAllObjects];
    
            self.isHaveBaseModel = YES;
            NSDictionary *dictData= [responseObj objectForKey:@"data"];
            BLRJCalculatortempletModelAllCalculatorcompanyData* companyData=     [BLRJCalculatortempletModelAllCalculatorcompanyData yy_modelWithJSON:dictData[@"company"]];
            
            self.allCalculatorCompanyData=companyData;
            self.isOpenVip = [self.allCalculatorCompanyData.calVip integerValue];
            if (self.allCalculatorCompanyData.calVip == nil || [self.allCalculatorCompanyData.calVip isEqualToString:@""]) {// 0表示不是会员  还没有开通200
                [self.collectBtn setTitle:@"收集号码" forState:UIControlStateNormal];
            } else {
                [self.collectBtn setTitle:@"续费" forState:UIControlStateNormal];
            }
        
            if (self.allCalculatorCompanyData.calVipEndTime == nil || [self.allCalculatorCompanyData.calVipEndTime isEqualToString:@""]) {// 0表示不是会员  还没有开通200
                self.getDateLabel.hidden = YES;
            } else {
                self.getDateLabel.hidden = NO;
                self.getDateLabel.text = [NSString stringWithFormat:@"%@到期", [[PublicTool defaultTool] getDateFormatStrFromTimeStampWithSeconds:self.allCalculatorCompanyData.calVipEndTime]];
            }
            NSString *stringInfo =@"温馨提示：尊敬的业主您好，您现在看到的是我公司的预算报价总计，稍后我公司将有客服人员与您联系， 并将详细报价清单发送给您，如有打扰敬请谅解！";
           self.textView.text=[NSString stringWithFormat:@"%@",companyData.introduction?:stringInfo];
           CGFloat heigth =self.isCanEdit?360:360 - 45 - 5;
           CGFloat topspace  =self.isCanEdit?160:160 - 45 - 5;
                self.topView.frame = CGRectMake(0, 0, BLEJWidth, heigth);
                self.budgetExplain.frame = CGRectMake(0, topspace, BLEJWidth, 190);
            self.topBgView.hidden = NO;
            self.simpleBtn.hidden = NO;
            self.refineBtn.hidden = NO;
            self.tableView.tableHeaderView = self.topView;
            
           self.companyItemArray=[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[BLRJCalculatortempletModelAllCalculatorTypes class] json:dictData[@"list"]]];
            for (BLRJCalculatortempletModelAllCalculatorTypes *dictModel in  self.companyItemArray) {
           
                if ( dictModel.templeteTypeNo  > 2000 &&dictModel.templeteTypeNo <3000) {
                    [self.baseItemsArr addObject:dictModel];
                }
                if (dictModel.templeteTypeNo  ==0) {
                 
                    [self.suppleListArr addObject:dictModel];
                }
                
                if (dictModel.templeteTypeNo  ==3000) {
                    
                    [self.Bricksection1 addObject:dictModel];
                }else if (dictModel.templeteTypeNo  ==3100) {
                    
                    [self.Bricksection2 addObject:dictModel];
                }else if ( dictModel.templeteTypeNo  ==3200) {
                
                    [self.Bricksection3 addObject:dictModel];
                }else if ( dictModel.templeteTypeNo  ==3300) {
                    
                    [self.Bricksection4 addObject:dictModel];
                }
                
                if (dictModel.templeteTypeNo  ==4000) {
                    
                    [self.WoodGroudArray addObject:dictModel];
                }else if (dictModel.templeteTypeNo  ==4100) {
                    
                    [self.WoodLineArray addObject:dictModel];
                }else if (dictModel.templeteTypeNo  ==4200) {
                    
                    [self.WoodexceptionArray addObject:dictModel];
                }
                if ( dictModel.templeteTypeNo  ==5000) {
                    
                    [self.ShedGroudArray addObject:dictModel];
                }else if ( dictModel.templeteTypeNo  ==5100) {
                    
                    [self.ShedLineArray addObject:dictModel];
                }else if ( dictModel.templeteTypeNo  ==5200) {
                    
                    [self.ShedexceptionArray addObject:dictModel];
                }
                if (dictModel.templeteTypeNo==6000) {
                    [self.dinuamArray0 addObject:dictModel];
                }
                if (dictModel.templeteTypeNo==6100) {
                    [self.dinuamArray1 addObject:dictModel];
                }
                if (dictModel.templeteTypeNo==7000) {
                    [self.chengpinArray addObject:dictModel];
                }
     }
    /************如果baseitems数据为空，去本地取出数据*********************/
         if (self.baseItemsArr.count ==0 &&self.Type==isQinfu){
  
            NSString *strPath = [[NSBundle mainBundle] pathForResource:@"DefaultBaseItem" ofType:@"geojson"];
            NSData *JSONData = [NSData dataWithContentsOfFile:strPath];
            id jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
            self.companyItemArray=[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[BLRJCalculatortempletModelAllCalculatorTypes class] json:jsonObject[@"data"][@"list"]]];
            for (BLRJCalculatortempletModelAllCalculatorTypes *dict in  self.companyItemArray) {
                    if ( dict.templeteTypeNo  > 2000 &&dict.templeteTypeNo <3000){
                         [self.baseItemsArr addObject:dict];
                    }else if (dict.templeteTypeNo  ==0) {
                          [self.suppleListArr addObject:dict];
                        }
                      }
                   }
        }else{
                [[PublicTool defaultTool] publicToolsHUDStr:responseObj[@"msg"] controller:self sleep:1.5];
        }
         [[UIApplication sharedApplication].keyWindow hiddleHud];
        /*****这里判断是那种类型的计算器******/
        NSString *strCal =self.allCalculatorCompanyData.calculatorType;
        if ( [strCal isEqualToString:@"1"]){
            
            self.Type=isQinfu;
            self.editBtn.hidden=NO;
            self.title = @"轻辅报价模板";
            
        }else if ([strCal isEqualToString:@"2"]){
            self.Type=isTaocan;
            [self changeTableViewFrame];
            self.title =@"套餐报价模板";
            self.isPackage699=YES;
            self.editBtn.hidden=YES;
            [self getDataFromServer];

        }else if ([strCal isEqualToString:@"3"]) {
            self.Type=isFloorBrick;
            self.title = @"瓷砖计算器";
           self.editBtn.hidden=NO;
        }else if ([ strCal isEqualToString:@"4"]) {
            self.Type=isFloorWood;
            self.title = @"地板计算器";
            self.editBtn.hidden=NO;
          
        }else if ([strCal isEqualToString:@"5"]) {
            self.Type=isShedLine;
            self.title = @"集成吊顶报价模版";
            self.editBtn.hidden=NO;
        }
        else if ([strCal isEqualToString:@"7"])
        {
            self.Type=isFloorheating;
            self.title = @"地暖计算器";
            self.editBtn.hidden=NO;
        }
        else if ([strCal isEqualToString:@"8"])
        {
            self.Type=isFinishedproduct;
            self.title = @"成品计算器";
            self.editBtn.hidden=NO;
        }
         [self.tableView reloadData];
       
     } failed:^(NSString *errorMsg) {
         [[PublicTool defaultTool] publicToolsHUDStr:errorMsg controller:self sleep:1.5];
     }];
}

#pragma mark 获取 套餐计算器数据&&获取管道计算器数据

- (void)getDataFromServer {
    NSString *strings=   [BASEURL stringByAppendingFormat:@"calculatorpackage/list.do"];
    [self.packageArrsimple removeAllObjects];
    [self.packageArrrefine removeAllObjects];
    NSString *typeStr = [NSString new];
    
    if (self.Type==isTaocan) {
        typeStr = @"0";
    }
    else
    {
        typeStr = @"1";
    }
    NSDictionary *params =@{@"companyId":@(self.companyID.integerValue),@"type":typeStr?:@"0"};
    [NetManager afGetRequest:strings parms:params finished:^(id responseObj) {
        if ([responseObj[@"code"]  isEqual: @"1000"]) {
            NSMutableDictionary *dataDic =[NSMutableDictionary dictionary];
            dataDic= [responseObj objectForKey:@"data"];
            self.companyIDConstant = dataDic[@"company"][@"companyId"];
            self.companyLogo=dataDic[@"company"][@"companyLogo"];
            self.companybname=dataDic[@"company"][@"companyName"];
            for (NSDictionary *dicts in  dataDic[@"packages"]) {
                if ([dicts[@"type"] isEqual:@"0"]||[dicts[@"type"] isEqual:@"2"]) {//0 套餐简装 2 管道精装
                    if ([dicts[@"packageId"] stringValue] ) {
                        self.packageId699simple =dicts[@"packageId"];
                        self.packageName699simple =dicts[@"packageName"];
                        if (self.Type==isTaocan) {
                            self.taocaoPrice0 =dicts[@"price"];
                        }
                        if (self.Type==isPipe) {
                            self.guandaoPirce0 =dicts[@"price"];
                        }
                    }
                    if (![dicts[@"price"] stringValue]  ) {
                        self.packageName699simple =@"699.0套餐";
                    }
                        for (NSDictionary *dict in dicts[@"designs"] ) {
                            
                            BLEJPackageArticleDesignModel *designModel = [BLEJPackageArticleDesignModel yy_modelWithDictionary:dict];
                            [self.packageArrsimple addObject:designModel];
                        }

                        if ([dicts[@"picUrl"]length] >0) {
                            self.picUrl =dicts[@"picUrl"];
                            self.picHref=dicts[@"picHref"];
                            self.picTitle=dicts[@"picTitle"];
                         }
            }else if ([dicts[@"type"] isEqual:@"1"]||[dicts[@"type"] isEqual:@"3"]) //1 套餐精装  3  管道精装
            {//1是精装
               
                        if ([dicts[@"packageId"] stringValue] ) {
                           self.packageId999refine =dicts[@"packageId"];
                           self.packageName999Refine =dicts[@"packageName"];
                            if (self.Type==isTaocan) {
                                 self.taocaoPrice1 =dicts[@"price"];
                            }
                            if (self.Type==isPipe) {
                                self.guandaoPirce1 =dicts[@"price"];
                            }
                        }
              
                        if (![dicts[@"price"] stringValue]  ) {
                            self.packageName999Refine =@"999.0套餐";
                        }
                        for (NSDictionary *dict in dicts[@"designs"] ) {
                            BLEJPackageArticleDesignModel *designModel = [BLEJPackageArticleDesignModel yy_modelWithDictionary:dict];
                            [self.packageArrrefine addObject:designModel];
                          }
                        }
                if ([dicts[@"picUrl"]length] >0) {
                    self.picUrl1 =dicts[@"picUrl"];
                    self.picHref1=dicts[@"picHref"];
                    self.picTitle1=dicts[@"picTitle"];
                 }
            }
                 [self.tableView reloadData];
      
        }else{
            //失败请求
              [[UIApplication sharedApplication].keyWindow hudShowWithText:responseObj[@"code"]];
        }
    } failed:^(NSString *errorMsg) {
          [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
    }];
}

#pragma mark 重置计算器

- (void)ResetCalculatorTemplatePort{
    self.isEditting =NO;
    self.bottomView.hidden = YES;
    
    self.topView.frame = CGRectMake(0, 0, BLEJWidth, 360);
    self.budgetExplain.frame = CGRectMake(0, 160, BLEJWidth, 190);
    if (!self.isCanEdit) {
        self.topView.frame = CGRectMake(0, 0, BLEJWidth, 360 - 45);
        self.budgetExplain.frame = CGRectMake(0, 160 - 40 - 5, BLEJWidth, 190);
    }
    self.topBgView.hidden = NO;
    self.simpleBtn.hidden = NO;
    self.refineBtn.hidden = NO;
    self.tableView.tableHeaderView = self.topView;
    [self getDataWithType:@"1"];
    [self.tableView reloadData];
    __weak typeof(self) weakSelf = self;
    TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"设置" message:@"简装报价/精装报价设置完成后才使用计算器，是否去设置简装报价" clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            
            [weakSelf ToSimpleSettingController];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
    [alertView show];
}
            
       
#pragma mark 设置 套餐计算器数据

- (void)CalculatorType:(NSString *)Type{
    
    NSString *strings=   [BASEURL stringByAppendingFormat:@"/calculator/setCalCulatorType.do"];
   
    NSDictionary *params =@{@"companyId":self.companyID,
                            @"type":Type
                            };
    [NetManager afGetRequest:strings parms:params finished:^(id responseObj) {
        if ([responseObj[@"code"] isEqualToString:@"1000"]) {
            [[PublicTool defaultTool]publicToolsHUDStr:@"成功" controller:self sleep:2];
        }
    } failed:^(NSString *errorMsg) {
        [[PublicTool defaultTool]publicToolsHUDStr:errorMsg controller:self sleep:2];
        
    }];
}

#pragma mark - 上传数据修改基础模板
- (void)updateBaseTemplate {
    // calculatorType (1.轻辅计算器,2.套餐计算器,3.瓷砖计算器,4.地板计算器,5.集成吊顶计算器,6.壁纸、壁布计算器,7.地暖计算器,8.成品计算器)
    
    [self.mutableDic removeAllObjects];
    UserInfoModel *info=[[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
    [self.mutableDic setObject:self.allCalculatorCompanyData.templetId forKey:@"templetId"];
    [self.mutableDic setObject:self.textView.text?:self.allCalculatorCompanyData.introduction forKey:@"introuction"];
    [self.mutableDic setObject:@(info.agencyId) forKey:@"modifyPersonId"];
    [self.mutableDic setObject:self.companyID forKey:@"companyId"];

    switch (self.Type) {
        case isQinfu:
            [self.mutableDic setObject: @"1" forKey:@"calculatorType"];
            break;
        case isTaocan:
            [self.mutableDic setObject: @"2" forKey:@"calculatorType"];
            break;
        case isFloorBrick:
            [self.mutableDic setObject: @"3" forKey:@"calculatorType"];
            break;
        case isShedLine:
            [self.mutableDic setObject: @"4" forKey:@"calculatorType"];
            break;
        case isWallpaper:
            [self.mutableDic setObject: @"5" forKey:@"calculatorType"];
            break;
        case isFloorheating:
            [self.mutableDic setObject: @"7" forKey:@"calculatorType"];
            break;
        case isFinishedproduct:
            [self.mutableDic setObject: @"8" forKey:@"calculatorType"];
            break;
        case isPipe:
            [self.mutableDic setObject: @"9" forKey:@"calculatorType"];
            break;
        default:
            break;
    }
    
    //[self CalculatorType:self.allCalculatorCompanyData.calculatorType];
    
    NSData *dataCompanyPara =[NSJSONSerialization dataWithJSONObject:self.mutableDic options:NSJSONWritingPrettyPrinted error:nil];
   
    NSString *CompanyPara = [[NSString alloc] initWithData:dataCompanyPara encoding:NSUTF8StringEncoding];
     /********************获取companyData的jsonStr**********************/

    [self.mutabeArrayDict removeAllObjects];
   
    if (self.Type==isQinfu) {
        for (BLRJCalculatortempletModelAllCalculatorTypes *model in  self.baseItemsArr) {
            //    deal true string 标识0: 新增，1：修改，2：删除，3：服务器返回
            //    supplementId  新增传0
            //    templeteId  基础模板Id
            //   templeteTypeNo  基础模板类型
            //    merchandId  关联商品Id
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSString *emptyStr=@"";
            NSUInteger strEmpty =(NSInteger)emptyStr ;
            if (model.deal ==0 ) {
                model.deal =3;
            }
           
            [dic setObject:@(model.deal) forKey:@"deal"];
            [  dic setObject: [NSNumber numberWithInteger:model.merchandId]? [NSNumber numberWithInteger:model.merchandId]:@(strEmpty) forKey:@"merchandId"];
            
            [dic setObject:[NSNumber numberWithInteger:model.templeteTypeNo]? [NSNumber numberWithInteger:model.templeteTypeNo]:@(strEmpty)  forKey:@"templeteTypeNo"];
            [dic setObject:model.supplementId?model.supplementId:@(0)  forKey:@"supplementId"];
            [dic setObject:[NSNumber numberWithInteger:model.templeteId]? [NSNumber numberWithInteger:model.templeteId]:@(strEmpty)  forKey:@"templeteId"];
            [dic setObject:[NSNumber numberWithInteger:model.length]? [NSNumber numberWithInteger:model.length]:@(strEmpty)  forKey:@"length"];
            [dic setObject:[NSNumber numberWithInteger:model.width]? [NSNumber numberWithInteger:model.width]:@(strEmpty)   forKey:@"width"];
            [dic setObject: model.spec ?model.spec :@""    forKey:@"spec"];
            [dic setObject:model.supplementPrice?:@(strEmpty) forKey:@"supplementPrice"];
            [dic setObject:model.supplementUnit ?model.supplementUnit :@"" forKey:@"supplementUnit"];
            [dic setObject:model.supplementName ?model.supplementName :@"" forKey:@"supplementName"];
            [dic setObject:model.supplementTech ?model.supplementTech :@"" forKey:@"supplementTech"];
            [self.mutabeArrayDict addObject:dic];
            
        }
       
        for (BLRJCalculatortempletModelAllCalculatorTypes *model in  self.suppleListArr) {
          
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSString *emptyStr=@"";
            NSUInteger strEmpty =(NSInteger)emptyStr ;
            if (model.deal ==0 ) {
                model.deal =3;
            }
            if (model.deal ==200) {
                model.deal =0;
            }
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)model.deal] forKey:@"deal"];
            [  dic setObject: [NSNumber numberWithInteger:model.merchandId]? [NSNumber numberWithInteger:model.merchandId]:@(strEmpty) forKey:@"merchandId"];
            [dic setObject:[NSNumber numberWithInteger:model.templeteTypeNo]? [NSNumber numberWithInteger:model.templeteTypeNo]:@(strEmpty)  forKey:@"templeteTypeNo"];
            [dic setObject:model.supplementId?model.supplementId:@(0)  forKey:@"supplementId"];
            [dic setObject:[NSNumber numberWithInteger:model.templeteId]? [NSNumber numberWithInteger:model.templeteId]:@(strEmpty)  forKey:@"templeteId"];
            [dic setObject:[NSNumber numberWithInteger:model.length]? [NSNumber numberWithInteger:model.length]:@(strEmpty)  forKey:@"length"];
            [dic setObject:[NSNumber numberWithInteger:model.width]? [NSNumber numberWithInteger:model.width]:@(strEmpty)   forKey:@"width"];
            [dic setObject: model.spec ?model.spec :@"自定义"    forKey:@"spec"];
            [dic setObject:model.supplementPrice?:@(strEmpty) forKey:@"supplementPrice"];
            [dic setObject:model.supplementUnit ?model.supplementUnit :@"" forKey:@"supplementUnit"];
            [dic setObject:model.supplementName ?model.supplementName :@"" forKey:@"supplementName"];
            [dic setObject:model.supplementTech ?model.supplementTech :@"" forKey:@"supplementTech"];
            [self.mutabeArrayDict addObject:dic];
        }
       
    }
   
    if (self.Type==isFloorWood ||self.Type==isShedLine||self.Type==isFloorheating||self.Type==isFinishedproduct) {
        
        [self.floorWoodArr removeAllObjects];
        [self.ShedArr removeAllObjects];
        

        NSMutableArray *dinuam = [NSMutableArray new];
        NSMutableArray *chengpin = [NSMutableArray new];
        
        NSMutableArray *newArr = [NSMutableArray new];
        
        if (self.Type==isFloorWood) {
            
            if (self.WoodGroudArray.count>0 ) {
                [self.floorWoodArr addObjectsFromArray:self.WoodGroudArray];
            }
            if (self.WoodLineArray.count>0){
                [self.floorWoodArr addObjectsFromArray:self.WoodLineArray];
            }
            if (self.WoodexceptionArray.count>0){
                [self.floorWoodArr addObjectsFromArray:self.WoodexceptionArray];
            }
            newArr = self.floorWoodArr;
        }
        if (self.Type==isShedLine) {
            if (self.ShedGroudArray.count>0){
                [self.ShedArr addObjectsFromArray:self.ShedGroudArray];
            }
            if (self.ShedLineArray.count>0){
                [self.ShedArr addObjectsFromArray:self.ShedLineArray];
            }
            if (self.ShedexceptionArray.count>0){
                [self.ShedArr addObjectsFromArray:self.ShedexceptionArray];
            }
            newArr = self.ShedArr;
        }
        if (self.Type==isFloorheating) {
            if (self.dinuamArray0.count>0) {
                [dinuam addObjectsFromArray:self.dinuamArray0];
            }
            if (self.dinuamArray1.count>0) {
                [dinuam addObjectsFromArray:self.dinuamArray1];
            }
            newArr = dinuam;
        }
        if (self.Type==isFinishedproduct) {
            if (self.chengpinArray.count>0) {
                [chengpin addObjectsFromArray:self.chengpinArray];
            }
            newArr = chengpin;
        }

        for (BLRJCalculatortempletModelAllCalculatorTypes *model  in  newArr) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSInteger strEmpty= [[NSString stringWithFormat:@"%@",@""]integerValue] ;
            if (model.deal == 0) {
                 model.deal = 3;
            }else if (model.deal ==300){
                model.deal=0;
            }
            
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)model.deal] forKey:@"deal"];
            [  dic setObject: [NSNumber numberWithInteger:model.merchandId]? [NSNumber numberWithInteger:model.merchandId]:@(strEmpty) forKey:@"merchandId"];
            [dic setObject:[NSNumber numberWithInteger:model.templeteTypeNo]? [NSNumber numberWithInteger:model.templeteTypeNo]:@(strEmpty)  forKey:@"templeteTypeNo"];
            [dic setObject:model.supplementId?model.supplementId:@(0)  forKey:@"supplementId"];
            [dic setObject:[NSNumber numberWithInteger:model.templeteId]? [NSNumber numberWithInteger:model.templeteId]:@(strEmpty)  forKey:@"templeteId"];
            [dic setObject:[NSNumber numberWithInteger:model.length]? [NSNumber numberWithInteger:model.length]:@(strEmpty)  forKey:@"length"];
            [dic setObject:[NSNumber numberWithInteger:model.width]? [NSNumber numberWithInteger:model.width]:@(strEmpty)   forKey:@"width"];
            [dic setObject: model.spec ?model.spec :@(strEmpty)    forKey:@"spec"];
            [dic setObject:model.supplementPrice?:@(strEmpty) forKey:@"supplementPrice"];
             [dic setObject:model.supplementName ?model.supplementName :@"" forKey:@"supplementName"];
            [dic setObject:@"" forKey:@"supplementUnit"];
            [dic setObject:@"" forKey:@"supplementTech"];
            [self.mutabeArrayDict addObject:dic];
        }

    }
    
    if (self.Type==isFloorBrick) {
        
        [self.floorBrickArr removeAllObjects];
        if (self.Bricksection1.count>0) {
            [self.floorBrickArr addObjectsFromArray:self.Bricksection1];
        }
        if (self.Bricksection2.count>0){
             [self.floorBrickArr addObjectsFromArray:self.Bricksection2];
        }
        if (self.Bricksection3.count>0){
             [self.floorBrickArr addObjectsFromArray:self.Bricksection3];
        }
        if (self.Bricksection4.count>0){
             [self.floorBrickArr addObjectsFromArray:self.Bricksection4];
        }
     
        for (BLRJCalculatortempletModelAllCalculatorTypes *model in  self.floorBrickArr) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSString *emptyStr=@"";
            NSUInteger strEmpty =(NSInteger)emptyStr ;
            if (model.deal == 0) {
                model.deal = 3;
            }else if (model.deal ==300){
                model.deal=0;
            }
            
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)model.deal]?:@"0" forKey:@"deal"];
            [  dic setObject: [NSNumber numberWithInteger:model.merchandId]? [NSNumber numberWithInteger:model.merchandId]:@(strEmpty) forKey:@"merchandId"];
            [dic setObject:[NSNumber numberWithInteger:model.templeteTypeNo]? [NSNumber numberWithInteger:model.templeteTypeNo]:@(strEmpty)  forKey:@"templeteTypeNo"];
            [dic setObject:model.supplementId?model.supplementId:@(0)  forKey:@"supplementId"];
            [dic setObject:[NSNumber numberWithInteger:model.templeteId]? [NSNumber numberWithInteger:model.templeteId]:@(strEmpty)  forKey:@"templeteId"];
            [dic setObject:[NSNumber numberWithInteger:model.length]? [NSNumber numberWithInteger:model.length]:@(strEmpty)  forKey:@"length"];
            [dic setObject:[NSNumber numberWithInteger:model.width]? [NSNumber numberWithInteger:model.width]:@(strEmpty)   forKey:@"width"];
            [dic setObject: model.spec ?model.spec :@(strEmpty)    forKey:@"spec"];
            [dic setObject:model.supplementPrice?:@(strEmpty) forKey:@"supplementPrice"];
            [dic setObject:model.supplementName ?model.supplementName :@"" forKey:@"supplementName"];
            [dic setObject:@"" forKey:@"supplementUnit"];
            [dic setObject:@"" forKey:@"supplementTech"];
            [self.mutabeArrayDict addObject:dic];
        }
        
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.mutabeArrayDict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *itemStr=  [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"calculator/v3/save.do"];
    
    NSDictionary *paramDic = @{
                               @"supplementList":itemStr,
                               @"templet":CompanyPara
                               };
    
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
      
        NSInteger code = [responseObj[@"code"] integerValue];
        
        if (code == 1000) {
         
            [self getDataWithType:@"1"];
      
        }
    } failed:^(NSString *errorMsg) {

        [[PublicTool defaultTool]publicToolsHUDStr:errorMsg controller:self sleep:2];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)didselectVideoButtonClickAtIndexPath:(NSIndexPath *)path {

    if (self.indexPath !=path){
        BLEJCalculatePackageDetailCell *package =[self.tableView cellForRowAtIndexPath:self.indexPath];
        if (package.ArticleDesignModel.videoUrl.length>0){
            package.plachoderVideoImgV.hidden=NO;
            [self.plyer pausePlay];
        }
    }
    
    BLEJCalculatePackageDetailCell *packageCell =[self.tableView cellForRowAtIndexPath:path];
    self.indexPath = path;
    NSString *strUrl=  packageCell.ArticleDesignModel.videoUrl;
    packageCell.player.url =[NSURL URLWithString:strUrl];
    if (strUrl.length>0) {

        if (![strUrl ew_isUrlString]) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"视频地址不正确， 不能播放"];
            return;
        }
        
        if (packageCell.plachoderVideoImgV.hidden==NO) {
                 packageCell.plachoderVideoImgV.hidden=YES;
        }
        self.plyer =packageCell.player;
        packageCell.player.hidden=NO;
        [packageCell.player playVideo];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:
(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                NSLog(@"item 有误");
             isReadToPlay = NO;
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准好播放了");
              isReadToPlay = YES; 
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"视频资源出现未知错误");
           isReadToPlay = NO;
                break;
            default:
                break;
        }
    }
    //移除监听（观察者）
    [object removeObserver:self forKeyPath:@"status"];
}

@end
