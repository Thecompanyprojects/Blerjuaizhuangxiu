//
//  MainMaterialDiaryController.m
//  iDecoration
//
//  Created by Apple on 2017/5/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "MainMaterialDiaryController.h"
#import "SignContractViewController.h"
#import "ZYCShareView.h"
#import "MemberSelectController.h"
#import "ModifyConstructionController.h"
#import "EditJournalController.h"
#import "OptionsTableViewCell.h"
#import "MemberViewController.h"
#import "NoExitMemberController.h"
#import "TitleTableViewCell.h"
#import "DiaryTitleHeaderView.h"
#import "SDCycleScrollView.h"
#import "MainMaterialDiaryHeadCell.h"
#import "SignContractTableViewCell.h"
#import "ShopCaseMaterialCell.h"
#import "TZImagePickerController.h"
#import "YPCommentView.h"
#import "NSObject+CompressImage.h"
#import "MainDiarySiteModel.h"
#import "NodeModel.h"
#import "MainMaterialMemberModel.h"
#import "NewMyPersonCardController.h"
#import "ConstructionDiaryTwoController.h"
#import "CompanyDetailViewController.h"
#import "CodeView.h"
#import "SetwWatermarkController.h"
#import "NewDesignImageWebController.h"
#import "DesignCaseListModel.h"
#import "VoteOptionModel.h"
#import "CaseMaterialController.h"
#import "CaseMaterialCell.h"
#import "CaseMaterialTwoModel.h"
#import "AddMerchanController.h"
#import "PanoramaViewController.h"
#import "ZCHPublicWebViewController.h"
#import "YellowGoodsListViewController.h"
#import "GoodsDetailViewController.h"
#import "DesignCaseListController.h"
#import "localbannerView.h"
#import "BLEJBudgetGuideController.h"
#import "JinQiViewController.h"
#import "SendFlowersViewController.h"
#define deletePeople @"删除人员未保存"

//如何判断显示我来添加的按钮
//1.判断当前人员是否在这个工地中  在：再判断      不再：不显示，并且没有权限修改
//2.判断当前节点是否有数据  有：再判断    没有：不显示我来添加（点击headview直接添加）
//3.判断数据是否是自己添加的  是：不显示  不是：显示我来添加
//
//extern NSMutableString *globalCityNum;
@interface MainMaterialDiaryController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextViewDelegate,DiaryTitleHeaderViewDelegate,SDCycleScrollViewDelegate,SignContractTableViewCellDelegate,TitleTableViewCellDelegate,UIAlertViewDelegate,MainMaterialDiaryHeadCellDelegate,CaseMaterialCellDelegate,ShopCaseMaterialCellDelegate>
{
    NSMutableDictionary *_sectionDict;
    BOOL _isExit;//当前人员是否在当前工地中
    BOOL _isShowRightBtn;//是否显示右上角小的删除按钮
    BOOL isManage;//是否是总经理
    BOOL isShopManage;//是否是店面经理
    BOOL isDesigner;//是否是店面设计师（1029）
    BOOL impletement;//是否是执行经理
    BOOL selectNodeIsHave;//isadd tag
    NSIndexPath *_deletePath;//删除节点的path
    NSInteger deleteCaseIndex;//删除哪一个施工日志
    NSInteger _nowNode;//当前的节点编号
    NSInteger _deleteTag;//删除人员的tag
    NSInteger _singleMerchanID;//删除单个本案材料的关联id
    BOOL isBottomVShow;//评论框是否显示,键盘是否弹出
    CGFloat keyBoardHeight;
    CGFloat cellH;
    CGFloat joinCellH;
    CGFloat cellHeight; // tableView中 section为0时  cell 的高度
    CGFloat caseCellH;//本案装修cell的高度
    NSIndexPath *_indexPath;//评论的index
    BOOL isShareOrCompleteBtn;//分享按钮，还是完成按钮 no:分享 yes：完成
}
@property (nonatomic, strong) UITableView *diaryTableView;
@property (nonatomic, strong) NSMutableArray *nodeArr;
@property (nonatomic, strong) NSMutableArray *memberListArr;
@property (nonatomic, strong) NSMutableArray *merchandArray;//本案材料的数组
@property (nonatomic, strong) NSMutableArray *materialArray;//本案装修的数组
@property (nonatomic, strong) MainDiarySiteModel *siteModel;
@property (nonatomic, strong) UIImageView *coverImgV;
@property (nonatomic, strong) NSMutableArray *bannerImgArray;//轮播图数组
@property (nonatomic, strong) NSMutableArray *deletePeopleArray;//删除人员的数组
@property (nonatomic, strong) SDCycleScrollView *scrollView;
// 底部的分享菜单
@property (strong, nonatomic) UIView *bottomShareView;
// 遮罩层
@property (strong, nonatomic) UIView *shadowView;
// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 二维码
@property (strong, nonatomic) CodeView *TwoDimensionCodeView;
@property (nonatomic, strong)UIView *bottomV;
@property (nonatomic, strong)UITextView *leaveWordTV;
@property (nonatomic, strong)UILabel *placeholderL;
@property (nonatomic, strong)UIButton *sendBtn;
@property (nonatomic, strong) UIButton *shareOrDeleteBtn;
@property (nonatomic, strong)UIView *bottomLogoV;
@property (nonatomic, strong)UIImageView *bottomLogoImg;
@property (nonatomic, strong) NSMutableDictionary *cellHDict;//cell高的字典
@property (nonatomic, strong) NSMutableDictionary *mechanCellDict;//本案材料cell的高度cell高的字典
@property (nonatomic, assign) NSInteger cJobTypeId;//职位id
@property (strong, nonatomic) ZYCShareView *shareView;

@property (nonatomic,assign) BOOL isshoucang;
@property (nonatomic,copy) NSString *collectionId;
@property (nonatomic,strong) localbannerView *bannerView;
@property (nonatomic, strong) DecorateInfoNeedView *infoView;

@property(nonatomic,strong)UIView *FlipView;
@property(nonatomic,strong)UIView *baseView;
@property(nonatomic,strong)UIImageView *xianHua;
@property(nonatomic,strong)UIImageView *jinQi;
@property(nonatomic,strong)UILabel *xianHuaL;
@property(nonatomic,strong)UILabel *jinQiL;

@end

@implementation MainMaterialDiaryController

-(NSMutableArray*)nodeArr{
    
    if (!_nodeArr) {
        _nodeArr = [NSMutableArray array];
    }
    return _nodeArr;
}

-(NSMutableArray*)memberListArr{
    
    if (!_memberListArr) {
        _memberListArr = [NSMutableArray array];
    }
    return _memberListArr;
}

-(NSMutableArray*)bannerImgArray{
    
    if (!_bannerImgArray) {
        _bannerImgArray = [NSMutableArray array];
    }
    return _bannerImgArray;
}

-(NSMutableArray*)deletePeopleArray{
    
    if (!_deletePeopleArray) {
        _deletePeopleArray = [NSMutableArray array];
    }
    return _deletePeopleArray;
}

-(NSMutableDictionary*)cellHDict{
    
    if (!_cellHDict) {
        _cellHDict = [NSMutableDictionary dictionary];
    }
    return _cellHDict;
}

-(NSMutableDictionary*)mechanCellDict{
    
    if (!_mechanCellDict) {
        _mechanCellDict = [NSMutableDictionary dictionary];
    }
    return _mechanCellDict;
}

-(localbannerView *)bannerView
{
    if(!_bannerView)
    {
        _bannerView = [[localbannerView alloc] init];
        _bannerView.frame = CGRectMake(0, kSCREEN_HEIGHT-49, kSCREEN_WIDTH, 49);
        [_bannerView.btn0 addTarget:self action:@selector(headbtn0click) forControlEvents:UIControlEventTouchUpInside];
        [_bannerView.btn1 addTarget:self action:@selector(headbtn1click) forControlEvents:UIControlEventTouchUpInside];
        [_bannerView.btn2 addTarget:self action:@selector(headbtn2click) forControlEvents:UIControlEventTouchUpInside];
        [_bannerView.btn3 addTarget:self action:@selector(headbtn3click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bannerView;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick event:@"MainMaterial"];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];

    manager.enable = NO;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = NO;//这个是它自带键盘工具条开关

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    // 这里统一设置键盘处理
    manager.toolbarDoneBarButtonItemText = @"完成";
    manager.toolbarTintColor = kMainThemeColor;
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = YES;//这个是它自带键盘工具条开关
    
    if (isBottomVShow) {
        [self.view endEditing:YES];
    }

}



-(void)dealloc{
    
    [[SDImageCache sharedImageCache] clearDisk];
    
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    
    
    //主材日志添加施工日志
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataNoHidden) name:@"AddShopMCaseMSucess" object:nil];
    
    //主材日志添加商品
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataNoHidden) name:@"AddMerchanSucess" object:nil];
    

    
    //修改主材日志的工地信息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataNoHidden) name:@"modifyMatiralInfo" object:nil];
    
    //编辑主材日志的节点通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShowCell:) name:@"editMatieralNode" object:nil];
    
    //添加主材日志节点通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShowCell:) name:@"addMatieralNode" object:nil];
    
    //监听键盘的隐藏和显示
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
    [self addSuspendedButton];
    self.shareView = [ZYCShareView sharedInstance];
    if (self.isfromlocal) {
        [self.view addSubview:self.bannerView];
    }
  
}

-(void)createUI{
    
    self.title = @"主材日志";
    self.view.backgroundColor = Bottom_Color;
    _sectionDict = [NSMutableDictionary dictionary];
    self.merchandArray = [NSMutableArray array];
    self.materialArray = [NSMutableArray array];
    
    [self.view addSubview:self.diaryTableView];
    [self.view addSubview:self.bottomV];
    [self.bottomV addSubview:self.leaveWordTV];
    [self.leaveWordTV addSubview:self.placeholderL];
    [self.bottomV addSubview:self.sendBtn];
    
    [self addBottomShareView];
    isBottomVShow = NO;

    //默认显示“分享”
    isShareOrCompleteBtn = NO;

    
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
    
    [moreBtn addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)name:@"UITextFieldTextDidChangeNotification"
                                              object:self.leaveWordTV];
    [self getData];
    self.isshoucang = NO;
    [self isshoucangclick];
    
   
}

#pragma mark - 判断是否收藏

-(void)isshoucangclick
{
    NSString *url = [BASEURL stringByAppendingString:GET_SELECTSHOUCANG];
    NSString *relId = [NSString stringWithFormat:@"%ld",self.consID];
    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"]?:@"0";
    NSString *type = @"3";
    NSDictionary *para = @{@"relId":relId,@"agencysId":agencysId,@"type":type};
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            self.isshoucang = YES;
            self.collectionId = [responseObj objectForKey:@"collectionId"];
        }
        if ([[responseObj objectForKey:@"code"] intValue]==1002) {
            self.isshoucang = NO;
            self.collectionId = [responseObj objectForKey:@"collectionId"];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 三点按钮

- (void)moreBtnClicked:(UIButton *)sender {
    
    // 弹出的自定义视图
    NSArray *array;
    if (self.isshoucang) {
        array = @[@"取消收藏", @"分享"];
        
    }
    else
    {
        array = @[@"收藏", @"分享"];
    }
    
    
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(kSCREEN_WIDTH-100, kNaviBottom, 120, 0) selectData:array images:nil action:^(NSInteger index) {
        
        if (index==0) {
            
            if (self.isshoucang) {
                NSDictionary *para = @{@"collectionId":self.collectionId};
                NSString *url = [BASEURL stringByAppendingString:DELETE_SHOUCANG];
                [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
                    if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"取消收藏成功" controller:self sleep:1.5];
                        self.isshoucang = NO;
                    }
                } failed:^(NSString *errorMsg) {
                    
                }];
            }
            else
            {
                BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
                if (!isLogin) { // 未登录
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请登录后再收藏"];
                    return ;
                }
                else
                {
                    NSString *relId = [NSString stringWithFormat:@"%ld",self.consID];
                    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
                    NSString *type = @"3";
                    //0:公司1:店铺2:商品3:工地4:美文5:名片
                    NSDictionary *para = @{@"relId":relId,@"agencysId":agencysId,@"type":type};
                    NSString *url = [BASEURL stringByAppendingString:POST_ADDSHOUCANG];
                    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
                        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                            [[PublicTool defaultTool] publicToolsHUDStr:@"收藏成功" controller:self sleep:1.5];
                            self.isshoucang = YES;
                        }
                    } failed:^(NSString *errorMsg) {
                        
                    }];
                }
            }
        }
        if (index==1) {
            [self DeleteOrShare];
        }
        
    } animated:YES];
    
}


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.nodeArr.count+2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section >=2) {

        if (section==2) {
            NSString *string = [NSString stringWithFormat:@"%ld",section];
            if ([_sectionDict[string] integerValue] == 1 ){
                return self.merchandArray.count;
            }
            else{
                return 0;
            }
        }
        else if(section==(self.nodeArr.count+2-1)){
            NSString *string = [NSString stringWithFormat:@"%ld",section];
            if ([_sectionDict[string] integerValue] == 1 ){
                return self.materialArray.count;
            }
            else{
                return 0;
            }
        }
        else{
            NSString *string = [NSString stringWithFormat:@"%ld",section];
            if ([_sectionDict[string] integerValue] == 1 ) {  //打开cell返回数组的count
                NodeModel *model = self.nodeArr[section-2];
                NSArray *arr = model.journalList;
                return arr.count;
                
            }
            else{
                return 0;
            }
            
        }
        
        
        
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 200;
    }
    if (section>=2) {
        return 60.0f;
    }
    return 0.0000000000000001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==1) {
        return 5;
    }
    else if (section==6){
        return 5;
    }
    else{
        return 5;
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    __weak MainMaterialDiaryController *weakSelf = self;
    
    if (section==0) {
        UIView *heavV = [[UIView alloc]init];
        
        if (!_coverImgV) {
            _coverImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
            
            _coverImgV.layer.masksToBounds = YES;
            _coverImgV.contentMode = UIViewContentModeScaleAspectFill;
            
        }
        [heavV addSubview:self.coverImgV];
        
        
        if (self.siteModel) {
            if (self.siteModel.coverMap.length<=0) {
                self.coverImgV.image = [UIImage imageNamed:@"carousel"];
            }
            else{

                [self.coverImgV sd_setImageWithURL:[NSURL URLWithString:self.siteModel.coverMap] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (!image) {
                        self.coverImgV.image = [UIImage imageNamed:@"carousel"];
                    }
                }];
                
                
            }
        }
        
        return heavV;
    }
    
    
    else if (section >=2) {
        DiaryTitleHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DiaryTitleHeaderView"];
        headerView.delegate = self;
        headerView.addBtn.tag = section;
        headerView.addBtn.hidden = YES;
        if (self.nodeArr.count<=0) {
            return [[UITableViewHeaderFooterView alloc]init];;
        }
        NodeModel *node = self.nodeArr[section-2];
        headerView.title.text = node.crRoleName;
        NSURL *url = [NSURL URLWithString:node.crRoleImg];
        [headerView.logo sd_setImageWithURL:url placeholderImage:nil];
        
        //判断当前节点有没有数据
        
        if (section==2||section==(self.nodeArr.count+2-1)){
            if(section==(self.nodeArr.count+2-1)){
                if (self.materialArray.count<=0) {
                    headerView.rowImgV.hidden = YES;
                }
                else{
                    headerView.rowImgV.hidden = NO;
                    NSString *str = [NSString stringWithFormat:@"%ld",section];
                    if ([_sectionDict[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
                        headerView.rowImgV.image = [UIImage imageNamed:@"row_bottom.png"];
                    }else{//反之关闭cell
                        headerView.rowImgV.image = [UIImage imageNamed:@"row_top.png"];
                    }
                }
            }
            else{
                if (self.merchandArray.count<=0) {
                    headerView.rowImgV.hidden = YES;
                }
                else{
                    headerView.rowImgV.hidden = NO;
                    NSString *str = [NSString stringWithFormat:@"%ld",section];
                    if ([_sectionDict[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
                        headerView.rowImgV.image = [UIImage imageNamed:@"row_bottom.png"];
                    }else{//反之关闭cell
                        headerView.rowImgV.image = [UIImage imageNamed:@"row_top.png"];
                    }
                }
            }
        }
        else{
            if (node.journalList.count<=0) {
                headerView.rowImgV.hidden = YES;
            }
            else{
                headerView.rowImgV.hidden = NO;
                NSString *str = [NSString stringWithFormat:@"%ld",section];
                if ([_sectionDict[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
                    headerView.rowImgV.image = [UIImage imageNamed:@"row_bottom.png"];
                }else{//反之关闭cell
                    headerView.rowImgV.image = [UIImage imageNamed:@"row_top.png"];
                }
            }
        }
        
        
        
        headerView.tag = 300 + section;
        
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        
        bool isLogin = [[PublicTool defaultTool]publicToolsJudgeIsLogined];
        //本案材料 和本案装修 单独处理
        if (section==2||section==(self.nodeArr.count+2-1)) {
            if (section==(self.nodeArr.count+2-1)) {
                
                if ((self.siteModel.ccComplete==0||self.siteModel.ccComplete==1)&&(_isExit)&&(isLogin)) {
                    
                    headerView.addBtn.hidden = NO;
                    
                    //本案装修的节点，没有数据，显示添加   有数据，判断权限（店面经理，经理，设计师），有权限--显示继续添加，没有权限，隐藏按钮
                    if (self.materialArray.count<=0) {
                        [headerView.addBtn setTitle:@"添加" forState:UIControlStateNormal];
                    }
                    else{
                        //只允许添加一个施工日志
                        headerView.addBtn.hidden = YES;

                    }
                }
                else{
                    //已交工 即不可以编辑也不可以添加
                    headerView.addBtn.hidden = YES;
                }
                
            }
            else{
                if ((self.siteModel.ccComplete==0||self.siteModel.ccComplete==1)&&(_isExit)&&(isLogin)&&(isManage||isShopManage||isDesigner||impletement)) {
                    
                    headerView.addBtn.hidden = NO;
                    
                    //本案材料的节点，没有数据，显示添加   有数据，判断权限（店面经理，经理，设计师），有权限--显示继续添加，没有权限，隐藏按钮
                    if (self.merchandArray.count<=0) {
                        [headerView.addBtn setTitle:@"添加" forState:UIControlStateNormal];
                    }
                    else{
                        if (isManage||isShopManage||isDesigner||impletement) {
                            headerView.addBtn.hidden = NO;
                            [headerView.addBtn setTitle:@"继续添加" forState:UIControlStateNormal];
                        }
                        else{
                            headerView.addBtn.hidden = YES;
                        }
                    }
                }
                else{
                    //已交工 即不可以编辑也不可以添加
                    headerView.addBtn.hidden = YES;
                }
            }
        }
        else{
            
            
            //1.判断当前人员是否在这个工地中,是否完工，是否登录  在：再判断      不再：不显示，并且没有权限修改
            //3.判断当前节点是否有数据  有：再判断    没有：不显示我来添加（点击headview直接添加）
            //4.判断数据是否是自己添加的  是：不显示  不是：显示我来添加
            
            
            
            //1.判断当前人员是否在这个工地中 是否完工 是否登录
            if (_isExit&&isLogin&&(self.siteModel.ccComplete==0||self.siteModel.ccComplete==1)) {
                NodeModel *model = self.nodeArr[section-2];
                    //3.判断当前节点是否有数据  有：再判断    没有：不显示我来添加（点击headview直接添加）
                    if (model.journalList.count>0) {
                        //4.判断数据是否是自己添加的  是：不显示  不是：显示我来添加
                        //有数据，判断自己有没有添加过
                        BOOL meIsAdd = NO;
                        for (NSDictionary *dict in model.journalList) {
//                            NSDictionary *cblejJournalModelDit = [dict objectForKey:@"cblejJournalModel"];
                            if ([[dict objectForKey:@"agencysId"] integerValue]==user.agencyId) {
                                
                                meIsAdd = YES;
                                break;
                            }else{
                                //
                                meIsAdd = NO;
                            }
                        }
                        if (meIsAdd) {
                            //自己已添加过 不允许添加，不显示我来添加的按钮
                            headerView.addBtn.hidden = YES;
                        }
                        else{
                            selectNodeIsHave = NO;
                            headerView.addBtn.hidden = NO;
                            
                        }
                    }else{
                        selectNodeIsHave = NO;
                        headerView.addBtn.hidden = YES;
                    }
                
                
            }
            else{
                
                headerView.addBtn.hidden = YES;
            }
        }
        
        
        
        
        
        
        __weak typeof(DiaryTitleHeaderView) *weakView = headerView;
        headerView.tapBlock = ^(){
            
            NSString *str = [NSString stringWithFormat:@"%ld",headerView.tag - 300];
            
            if ([_sectionDict[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
                [_sectionDict setObject:@"1" forKey:str];
                weakView.rowImgV.image = [UIImage imageNamed:@"row_top.png"];
            }else{//反之关闭cell
                [_sectionDict setObject:@"0" forKey:str];
                weakView.rowImgV.image = [UIImage imageNamed:@"row_bottom.png"];
            }
            
            if (section==2||section==(self.nodeArr.count+2-1)) {
                if (section==(self.nodeArr.count+2-1)) {
                    if (self.materialArray.count<=0) {
                        
                    }
                    else{

                    }
                }
                else{
                    if (self.merchandArray.count<=0) {
                        //其他身份点击的时候，提示不权限
                        if (!(isManage||isShopManage||isDesigner||impletement)) {
                            [[PublicTool defaultTool] publicToolsHUDStr:@"您没有当前节点的操作权限" controller:self sleep:1.5];
                        }
                    }
                    
                }
            }
            else
            {
                if (_isExit&&isLogin&&(self.siteModel.ccComplete==0||self.siteModel.ccComplete==1)) {
                    
                    //NSInteger selectTag = [node.crNodeNumber integerValue];//点击的节点
                    if (node.journalList.count<=0) {
                        
                        if (_isShowRightBtn) {
                            [[PublicTool defaultTool] publicToolsHUDStr:deletePeople controller:self sleep:1.5];
                            return;
                        }
                        //没有数据--进入添加页面
                        
                        //如果当前节点是“成品展示”，那么之前的节点都必须添加过，才能添加“成品展示”
                        if (section==self.nodeArr.count) {
                            BOOL isHaveData = NO;
                            NSMutableArray *temArray = [NSMutableArray array];
                            [temArray addObjectsFromArray:self.nodeArr];
                            //去掉第一个和最后两个
                            [temArray removeObjectAtIndex:0];
                            [temArray removeLastObject];
                            [temArray removeLastObject];
                            for (NodeModel *model in temArray) {
                                if (model.journalList.count<=0) {
                                    isHaveData = NO;
                                    break;
                                }
                                else{
                                    isHaveData = YES;
                                }
                            }
                            
                            if (!isHaveData) {
                                [[PublicTool defaultTool] publicToolsHUDStr:@"其他节点还未添加" controller:self sleep:1.5];
                            }
                            else{
                                SignContractViewController *signVC = [[SignContractViewController alloc]init];
                                signVC.title = node.crRoleName;
                                signVC.constructionIdStr = self.consID;
                                signVC.cJobTypeIdStr = [self.siteModel.cpLimitsId integerValue];
                                signVC.type = node.crNodeNumber;
                                signVC.isAdd = 0;
                                signVC.index = 2;
                                signVC.nodeId = node.crNodeNumber;
                                signVC.companyId = self.companyId;
                                signVC.companyLogo = self.siteModel.companyLogo;
                                signVC.companyName = self.siteModel.companyName;
                                signVC.agencysJob = self.agencysJob;
                                [self.navigationController pushViewController:signVC animated:YES];
                            }
                            
                        }
                        else{
                            SignContractViewController *signVC = [[SignContractViewController alloc]init];
                            signVC.title = node.crRoleName;
                            signVC.constructionIdStr = self.consID;
                            signVC.cJobTypeIdStr = [self.siteModel.cpLimitsId integerValue];
                            signVC.type = node.crNodeNumber;
                            signVC.isAdd = 0;
                            signVC.index = 2;
                            signVC.nodeId = node.crNodeNumber;
                            signVC.companyLogo = self.siteModel.companyLogo;
                            signVC.companyName = self.siteModel.companyName;
                            signVC.companyId = self.companyId;
                            signVC.agencysJob = self.agencysJob;
                            [self.navigationController pushViewController:signVC animated:YES];
                        }
                        
                    }
                    else{

                    }
                    
                }
                else{
                    if (_isShowRightBtn) {
                        [[PublicTool defaultTool] publicToolsHUDStr:deletePeople controller:self sleep:1.5];
                        return;
                    }
                }
                
                
            }

            
            
            //一个section刷新
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
            [weakSelf.diaryTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
            
            
        };
        

        
        return headerView;
    }else{
        return [[UITableViewHeaderFooterView alloc]init];
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (section==6) {

        if (!_bottomLogoV) {
            _bottomLogoV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 80)];
            _bottomLogoV.backgroundColor = Bottom_Color;
        }
        if (!_bottomLogoImg) {
            _bottomLogoImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kSCREEN_WIDTH, 40)];
            [_bottomLogoV addSubview:_bottomLogoImg];
        }

        return _bottomLogoV;
    }
    else{
        return [[UITableViewHeaderFooterView alloc]init];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return cellHeight;
    }else if (indexPath.section==1){
//        return joinCellH;
//        return 44;
        return 95;
    }
    else if (indexPath.section==2){
        
        if (self.merchandArray.count<=0) {
            return 0;
        }
        else{
            
            NSString *indexSectionRow = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
            
            CGFloat temH = [[self.mechanCellDict objectForKey:indexSectionRow] floatValue];
            return temH;
        }

    }
    else if (indexPath.section==(self.nodeArr.count+2-1)){
        if (self.materialArray.count<=0) {
            return 0;
        }
        else{
            return caseCellH;
        }
        
    }
    else{
        
        NSString *indexSectionRow = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
        NSString *sectionStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
        if ([_sectionDict[sectionStr] integerValue] == 1 ) {  //打开cell返回数组的count
            CGFloat temH = [[self.cellHDict objectForKey:indexSectionRow] floatValue];
            return temH;
        }else{
            return 0;
        }
    }

    
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
    MainMaterialDiaryHeadCell *cell = [MainMaterialDiaryHeadCell cellWithTableView:tableView indexpath:indexPath];
    [cell configWith:self.siteModel];
        cellHeight = cell.cellHeight;
        cell.delegate = self;

        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        bool isLogin = [[PublicTool defaultTool]publicToolsJudgeIsLogined];
        
        
        //店面经理，总经理，创建人，可以编辑工地，并且未交工
        if ((self.siteModel.ccHouseholderId == user.agencyId||isManage||isShopManage||impletement)&&(self.siteModel.ccComplete==0||self.siteModel.ccComplete==1)&&isLogin&&_isExit) {
            cell.editBtn.hidden = NO;
        }
        else{
            cell.editBtn.hidden = YES;
        }
        
        return cell;
    }
    else if (indexPath.section==1){

        
        OptionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionsTableViewCell"];
        cell.fromTag = 2;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.designBlock = ^{
            //本案视频
            [[PublicTool defaultTool] publicToolsHUDStr:@"敬请期待" controller:self sleep:1.5];
        };

        cell.memberBlock = ^(){
            //参与人员
            bool isLogin = [[PublicTool defaultTool]publicToolsJudgeIsLogined];
            if (_isExit&&isLogin) {
                MemberViewController *memberVC = [[MemberViewController alloc]init];
                //传递群组的ID
                memberVC.groupid = self.siteModel.groupId;
                memberVC.index = 2;
                memberVC.consID = self.consID;
                memberVC.socialName = self.siteModel.ccAreaName;
                memberVC.consCreatPeopleID = self.siteModel.ccHouseholderId;
                memberVC.companyFlag = self.companyFlag;
                if(self.siteModel.ccComplete==0||self.siteModel.ccComplete==1){
                    memberVC.isComplete = NO;
                }
                else{
                    memberVC.isComplete = YES;
                }
                [self.navigationController pushViewController:memberVC animated:YES];
            }
            else{
                NoExitMemberController *memberVC = [[NoExitMemberController alloc]init];
                memberVC.consID = self.consID;
                //                memberVC.consCreatPeopleID = self.siteModel.ccHouseholderId;
                [self.navigationController pushViewController:memberVC animated:YES];
            }
        };
        cell.holderBlock = ^{
            //店长手记
            [self requestManageOwnerOfDiary];
        };
        cell.supervisorBlock = ^(){
            //全景vr
            PanoramaViewController *panorama = [[PanoramaViewController alloc]init];
            //页面跳转标记
            panorama.tag = 2000;
            panorama.shopID = [NSString stringWithFormat:@"%ld",(long)self.consID];
            panorama.jobId = self.siteModel.cpLimitsId;
            panorama.origin = @"0";
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:self.siteModel.companyId,@"companyId",
                                  @"1010",@"companyType",
                                  self.siteModel.companyLandline,@"companyLandline",
                                  self.siteModel.companyPhone,@"companyPhone",
                                  self.siteModel.companyName,@"companyName", nil];
            panorama.dataDic = dict;
            
            if(self.siteModel.ccComplete==0||self.siteModel.ccComplete==1){
                //未交工
                panorama.isComplete = NO;
            }else{
                panorama.isComplete = YES;
            }
            
            [self.navigationController pushViewController:panorama animated:YES];
        };

        return cell;
    }
    else if (indexPath.section==2){
        ShopCaseMaterialCell *cell = [ShopCaseMaterialCell cellWithTableView:tableView indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.path = indexPath;
        id data = self.merchandArray[indexPath.row];
        cell.delegate = self;
        [cell configData:data isComplete:self.siteModel.ccComplete];
        
        NSString *indexSectionRow = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
        
        [self.mechanCellDict setObject:@(cell.cellH) forKey:indexSectionRow];
        
        return cell;
    }
    else if (indexPath.section==(self.nodeArr.count+2-1)){
        if (self.materialArray.count<=0) {
            return [[UITableViewCell alloc]init];
        }
        CaseMaterialCell *cell = [CaseMaterialCell cellWithTableView:tableView indexpath:indexPath];
        
        CaseMaterialTwoModel *model = self.materialArray[indexPath.row];
        [cell configWith:model];
        caseCellH = cell.cellH;
        cell.delegate = self;
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSInteger tempAgencyId = model.agencysIds;
        //已交工，未登录，不在工地 ，都不显示评论按钮
        
        BOOL isLogin = [[PublicTool defaultTool]publicToolsJudgeIsLogined];
        if ((self.siteModel.ccComplete==2||self.siteModel.ccComplete==3)||(!isLogin)||(!_isExit)){
            cell.commentL.hidden = YES;
            cell.commentBtn.hidden = YES;
            cell.deleteBtn.hidden = YES;
        }
        else{
            cell.commentL.hidden = NO;
            cell.commentBtn.hidden = NO;
            if (tempAgencyId==user.agencyId) {
                cell.deleteBtn.hidden = NO;
            }else{
                cell.deleteBtn.hidden = YES;
            }
        }
        return cell;
    }
    else{
        SignContractTableViewCell *cell = [SignContractTableViewCell cellWithTableView:tableView indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
//        self.imgArray = cell.imgArray;
        cell.path = indexPath;
        NodeModel *model = self.nodeArr[indexPath.section-2];
        NSArray *arr = model.journalList;
        //            我来添加
        if (arr.count) {
            NSDictionary *dict = arr[indexPath.row];
            BOOL isLogin = [[PublicTool defaultTool]publicToolsJudgeIsLogined];
            
            
            
            [cell configData:dict indexpath:indexPath isComplete:self.siteModel.ccComplete isLogin:isLogin isExit:_isExit type:2 nodeName:model.crRoleName];
            
            NodeModel *model = self.nodeArr[indexPath.section-2];
            //判断是否是当前节点  是：显示删除按钮，不是隐藏
            if ([model.crNodeNumber integerValue]!=_nowNode) {
                cell.deletePointBtn.hidden = YES;
            }
            
            NSString *indexSectionRow = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
            
            
            if (indexPath.row == arr.count-1) {
                cell.divView.hidden = YES;
                cell.cellH = cell.cellH-10;
                
            }else{
                cell.divView.hidden = NO;
            }
            
            [self.cellHDict setObject:@(cell.cellH) forKey:indexSectionRow];
            
            
        }
        return cell;
    }
 
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //跳转到主材日志界面
    if (indexPath.section == (self.nodeArr.count+2-1)) {
        
        CaseMaterialTwoModel *model = self.materialArray[indexPath.row];
        ConstructionDiaryTwoController *vc = [[ConstructionDiaryTwoController alloc]init];
        vc.consID = [model.materialConstructionId integerValue];
        vc.agencysJob = self.agencysJob;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark–键盘显示事件

-(void)keyboardWillShow:(NSNotification *)notification{
    CGFloat cukeyBoardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"]CGRectValue].size.height;
    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    //第三方键盘回调三次问题，监听仅执行最后一次
    if (begin.size.height>0&&begin.origin.y-end.origin.y>0) {
        keyBoardHeight = cukeyBoardHeight;
        

        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            self.diaryTableView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64-keyBoardHeight-44);
            self.bottomV.frame = CGRectMake(0, kSCREEN_HEIGHT - keyBoardHeight-44, kSCREEN_WIDTH, 44);
            [self.diaryTableView scrollToRowAtIndexPath:_indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        } completion:^(BOOL finished) {
            isBottomVShow = YES;
        }];
        
        
    }
}

-(void)keyBoardDidHide:(NSNotification *)notification{
    
    [UIView  animateWithDuration:0.05 animations:^{
        self.diaryTableView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64);
        self.bottomV.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 44);
    }];
    
    isBottomVShow = NO;
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
}

-(void)textViewDidChange:(UITextView *)textView{
//    self.leaveWordTV.text = textView.text;
    if (self.leaveWordTV.text.length == 0) {
        self.placeholderL.hidden = NO;
    }else{
        self.placeholderL.hidden = YES;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    self.leaveWordTV.text = textView.text;
    if (self.leaveWordTV.text.length == 0) {
        self.placeholderL.hidden = NO;
    }else{
        self.placeholderL.hidden = YES;
    }

    
}

-(void)textFieldEditChanged:(NSNotification *)obj{
    UITextView *textView = (UITextView *)obj.object;
    NSString *toBeString = self.leaveWordTV.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage ; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            toBeString = [toBeString stringByReplacingOccurrencesOfString:@" " withString:@""];
            toBeString = [toBeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

            self.leaveWordTV.text = toBeString;
            //            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{

        self.leaveWordTV.text = toBeString;
        //        }
    }
}

-(void)sendBtnClick{
    [self.view endEditing:YES];
    [UIView transitionWithView:self.view duration:0.3 options:0 animations:^{
        //执行的动画
        //        NSLog(@"动画开始执行前的位置：%@",NSStringFromCGPoint(self.customView.center));
        self.diaryTableView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64);
        self.bottomV.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 44);
    } completion:^(BOOL finished) {

    }];
    [self reqestCommentWith:_indexPath];
}

-(void)refreshShowCell:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    NSString *nodeStr = [dict objectForKey:@"node"];
    NSInteger temNode = [nodeStr integerValue];
    NSInteger temInt = 0;
    //    NodeModel *node = self.nodeArr[section-2];
    for (int i = 0; i<self.nodeArr.count; i++) {
        NodeModel *model = self.nodeArr[i];
        NSInteger modelNode = [model.crNodeNumber integerValue];
        
        if (modelNode==temNode) {
            temInt = (i+2);
            break;
        }
    }
    NSString *keyStr = [NSString stringWithFormat:@"%ld",temInt];
    [_sectionDict setObject:@"1" forKey:keyStr];
    [self getDataNoHidden];
    
    if (temNode == 6005) {
        NodeModel *model = [self.nodeArr lastObject];
        if (model.journalList.count) {
            NSInteger tag = model.journalList.count-1;
            NSIndexPath *path = [NSIndexPath indexPathForRow:tag inSection:6];
            [self.diaryTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionBottom];
        }
    }

}

-(void)back{
    [self SuspendedButtonDisapper];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)isButtonTouched{
    ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
    VC.titleStr = @"使用说明";
    VC.webUrl = INSTRCTIONHTML;
    VC.isAddBaseUrl = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

}

#pragma mark - 添加二维码
- (void)addTwoDimensionCodeView {

    self.TwoDimensionCodeView = [[CodeView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.TwoDimensionCodeView.backgroundColor = White_Color;
    [self.view addSubview:self.TwoDimensionCodeView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickShadowView:)];
    [self.TwoDimensionCodeView addGestureRecognizer:tap];
    
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"resources/html/shangjiarizhi.jsp?constructionId=%ld", (long)self.consID]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.siteModel.coverMap]];
    UIImage *image = [UIImage imageWithData:data];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.TwoDimensionCodeView.QRCodeImageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:image logoScaleToSuperView:0.3];
        });
    });
    self.TwoDimensionCodeView.typeLabel.text = [NSString stringWithFormat:@"%@",self.siteModel.ccShareTitle];
    self.TwoDimensionCodeView.areaLabel.text = self.siteModel.ccAreaName;
    self.TwoDimensionCodeView.companyNameLabel.text = self.siteModel.companyName;
    self.TwoDimensionCodeView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.TwoDimensionCodeView.imageView.clipsToBounds = YES;
    [self.TwoDimensionCodeView.imageView sd_setImageWithURL:[NSURL URLWithString:self.siteModel.coverMap]];
    // 没有图片
    if (self.siteModel.coverMap.length == 0) {
        [self.TwoDimensionCodeView.labelView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.bottom.equalTo(-(kSCREEN_HEIGHT - 62-20));
            make.height.equalTo(62);
        }];
        
        [self.TwoDimensionCodeView.QRCodeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH*0.4, kSCREEN_WIDTH * 0.4));
            make.centerX.equalTo(0);
            make.centerY.equalTo(0);
        }];
        
        [self.TwoDimensionCodeView.visitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.left.right.equalTo(0);
            make.top.equalTo(self.TwoDimensionCodeView.labelView.mas_bottom);
            make.bottom.equalTo(self.TwoDimensionCodeView.QRCodeImageView.mas_top);
        }];
    }
    self.TwoDimensionCodeView.hidden = YES;
}

#pragma mark -action

- (void)addBottomShareView {
    
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.shadowView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickShadowView:)];
    [self.shadowView addGestureRecognizer:tap];
    
    [self.view addSubview:self.shadowView];
    self.shadowView.hidden = YES;
    
    self.bottomShareView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth, kSCREEN_WIDTH/1.5 + 70)];
    self.bottomShareView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.shadowView addSubview:self.bottomShareView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, BLEJWidth - 40, 30)];
    titleLabel.text = @"分享给好友";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottomShareView addSubview:titleLabel];
    
    NSArray *imageNames = @[@"weixin-share", @"pengyouquan", @"qq", @"qqkongjian", @"erweima-0"];
    NSArray *names = @[@"微信好友", @"微信朋友圈", @"QQ好友", @"QQ空间", @"二维码"];
    for (int i = 0; i < 5; i ++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i%4 * BLEJWidth * 0.25, titleLabel.bottom + 20 + (i/4 * BLEJWidth * 0.25), BLEJWidth * 0.25, BLEJWidth * 0.25)];
        btn.tag = i;
        [btn addTarget:self action:@selector(didClickShareContentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [btn setTitle:names[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // 1. 得到imageView和titleLabel的宽、高
        CGFloat imageWith = btn.imageView.frame.size.width;
        CGFloat imageHeight = btn.imageView.frame.size.height;
        
        CGFloat labelWidth = 0.0;
        CGFloat labelHeight = 0.0;
        labelWidth = btn.titleLabel.intrinsicContentSize.width;
        labelHeight = btn.titleLabel.intrinsicContentSize.height;
        UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
        UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
        imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-5/1.5, 0, 0, -labelWidth);
        labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-5/1.5, 0);
        btn.titleEdgeInsets = labelEdgeInsets;
        btn.imageEdgeInsets = imageEdgeInsets;
        [self.bottomShareView addSubview:btn];
    }
}


- (void)didClickShadowView:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomShareView.blej_y = BLEJHeight;
    } completion:^(BOOL finished) {
        self.shadowView.hidden = YES;
    }];
    
    self.TwoDimensionCodeView.hidden = YES;
    self.navigationController.navigationBar.alpha = 1;
}

- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

- (void)makeShareView {
    WeakSelf(self);
    NSString *shareTitle = self.siteModel.ccShareTitle;
    NSString *shareDescription = [NSString stringWithFormat:@"%@ %@", self.siteModel.companyName, self.siteModel.ccAreaName];
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"resources/html/shangjiarizhi.jsp?constructionId=%ld", (long)self.consID]];

    self.shareView.URL = shareURL;
    self.shareView.shareTitle = shareTitle;
    self.shareView.shareCompanyIntroduction = shareDescription;
    self.shareView.shareCompanyLogo = self.siteModel.coverMap;
    self.shareView.shareViewType = ZYCShareViewTypeDefault;
    self.shareView.blockQRCode1st = ^{
        [MobClick event:@"MainMaterialDiaryShare"];
        weakself.TwoDimensionCodeView.hidden = NO;
        weakself.navigationController.navigationBar.alpha = 0;
    };
    self.shareView.blockQRCode2nd = ^{
        [MobClick event:@"MainMaterialDiaryShare"];
        weakself.TwoDimensionCodeView.hidden = NO;
        weakself.navigationController.navigationBar.alpha = 0;
    };
}

#pragma  mark - 分享
- (void)didClickShareContentBtn:(UIButton *)btn {
    NSString *shareTitle = self.siteModel.ccShareTitle;
    NSString *shareDescription = [NSString stringWithFormat:@"%@ %@", self.siteModel.companyName, self.siteModel.ccAreaName];
    NSURL *shareImageUrl;
//    if (self.siteModel.coverMap) {
        shareImageUrl = [NSURL URLWithString:self.siteModel.coverMap];
//    }
    switch (btn.tag) {
        case 0:
        {// 微信好友
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
            
            // 把图片设置成正方形
            CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
            shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
            
            UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
            if (self.siteModel.coverMap) {
                [message setThumbImage:img];
            } else {
                UIImage *image = [UIImage imageNamed:@"shareDefaultIcon"];
                [message setThumbImage:image];
            }
            
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            //            NSString *shareURL = WebPageUrl;
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"resources/html/shangjiarizhi.jsp?constructionId=%ld", (long)self.consID]];
            
            
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"MainMaterialDiaryShare"];
            }
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomShareView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                self.shadowView.hidden = YES;
            }];
        }
            break;
        case 1:
        {// 微信朋友圈
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
            
            // 把图片设置成正方形
            CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
            shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
            
            UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
            if (self.siteModel.coverMap) {
                [message setThumbImage:img];
            } else {
                [message setThumbImage:[UIImage imageNamed:@"shareDefaultIcon"]];
            }
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"resources/html/shangjiarizhi.jsp?constructionId=%ld", (long)self.consID]];
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"MainMaterialDiaryShare"];
            }
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomShareView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                self.shadowView.hidden = YES;
            }];
        }
            break;
        case 2:
        {// QQ好友
            if ([TencentOAuth iphoneQQInstalled]) {
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"resources/html/shangjiarizhi.jsp?constructionId=%ld", (long)self.consID]];
                NSURL *url = [NSURL URLWithString:shareURL];
                
                UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
                
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];
                
                QQApiNewsObject *newObject;
                if (self.siteModel.coverMap) {

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
                    [MobClick event:@"MainMaterialDiaryShare"];
                }
                [UIView animateWithDuration:0.25 animations:^{
                    self.bottomShareView.blej_y = BLEJHeight;
                } completion:^(BOOL finished) {
                    self.shadowView.hidden = YES;
                }];
            }
        }
            
            break;
        case 3:
        {// QQ空间
            if ([TencentOAuth iphoneQQInstalled]){
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                //从contentObj中传入数据，生成一个QQReq
                
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"resources/html/shangjiarizhi.jsp?constructionId=%ld", (long)self.consID]];
                
                NSURL *url = [NSURL URLWithString:shareURL];
                
                UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
                
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];
                QQApiNewsObject *newObject;
                if (self.siteModel.coverMap) {

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
                    [MobClick event:@"MainMaterialDiaryShare"];
                }
                [UIView animateWithDuration:0.25 animations:^{
                    self.bottomShareView.blej_y = BLEJHeight;
                } completion:^(BOOL finished) {
                    self.shadowView.hidden = YES;
                }];
            }
        }
            break;
        case 4:
        {// 生成二维码
            [MobClick event:@"MainMaterialDiaryShare"];
            self.TwoDimensionCodeView.hidden = NO;
            self.navigationController.navigationBar.alpha = 0;
        }
            break;
        default:
            break;
    }
    [NSObject contructionShareStatisticsWithConstructionId:[NSString stringWithFormat:@"%ld", self.consID]];
    
}

#pragma mark - MainMaterialDiaryHeadCellDelegate

-(void)modifyCon{
    if (_isShowRightBtn) {
        [[PublicTool defaultTool] publicToolsHUDStr:deletePeople controller:self sleep:1.5];
        return;
    }
    ModifyConstructionController *vc = [[ModifyConstructionController alloc]init];
    vc.mainSiteModel = self.siteModel;
    vc.consID = self.consID;
    vc.ccComplete = self.siteModel.ccComplete;
    vc.companyOrShop = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goToShopLook{
    YellowGoodsListViewController *VC = [YellowGoodsListViewController new];
    VC.fromBack = NO;
    VC.shopId = self.siteModel.companyId;
    VC.shopid = self.siteModel.companyId;
    VC.origin = @"0";
    VC.companyName = self.siteModel.companyName;
    VC.shareCompanyLogoURLStr = self.siteModel.companyLogo;
    VC.shareDescription = self.siteModel.typeName;
    
    NSString *companytype = self.siteModel.companyType;
    if (!companytype) {
        companytype = @"0";
    }
    VC.companyType = companytype;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.siteModel.companyId,@"companyId",
                          self.siteModel.companyLandline,@"companyLandline",
                          self.siteModel.companyPhone,@"companyPhone",
                          companytype,@"companyType",
                          nil];
    VC.dataDic = dict;
    [self.navigationController pushViewController:VC animated:YES];
}



#pragma mark - TitleTableViewCellDelegate

-(void)addPeople{
    if (!_isExit) {
        return;
    }
    if (_isShowRightBtn) {
        [[PublicTool defaultTool] publicToolsHUDStr:deletePeople controller:self sleep:1.5];
        return;
    }
    MemberSelectController *vc = [[MemberSelectController alloc]init];
    vc.consID = self.consID;
    vc.index = 2;
    vc.companyFlag = self.companyFlag;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)reducePeople{
    if (!_isExit) {
        return;
    }
    _isShowRightBtn = YES;
    [self.shareOrDeleteBtn setTitle:@"完成" forState:UIControlStateNormal];
    isShareOrCompleteBtn = YES;
    //一个cell刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
    [self.diaryTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)deleteWith:(NSInteger)tag{
    if (!_isExit) {
        return;
    }
    //经理和总经理必须留一个
    _deleteTag = tag;
    MainMaterialMemberModel *model = self.memberListArr[_deleteTag];
    
    if (self.cJobTypeId == 1027&&[model.cpLimitsId integerValue]==1002) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"你不能删除总经理" controller:self sleep:1.5];
        return;
    }
    
    [self.memberListArr removeObject:model];
    [self.deletePeopleArray addObject:model];
    
    if (self.memberListArr.count<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"无法删除，需要保留一位总经理或店面经理" controller:self sleep:1.5];
        [self.memberListArr addObject:model];
        [self.deletePeopleArray removeObject:model];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
        [self.diaryTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
        return;
    }
    
    bool isHaveManage = NO;
    for (MainMaterialMemberModel *model in self.memberListArr) {
        
        if ([model.cpLimitsId integerValue]==1002||[model.cpLimitsId integerValue]==1027) {
            isHaveManage = YES;
            break;
        }
        else{
            isHaveManage = NO;
        }
    }
    if (!isHaveManage) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"无法删除，需要保留一位总经理或店面经理" controller:self sleep:1.5];

        if (_deleteTag == 0) {
            [self.memberListArr insertObject:model atIndex:0];
        }
        else{
            [self.memberListArr insertObject:model atIndex:_deleteTag-1];
        }
        
        [self.deletePeopleArray removeObject:model];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
        [self.diaryTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    else{
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
        [self.diaryTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

#pragma mark - ShopCaseMaterialCellDelegate

-(void)deleteShopCaseWithRow:(NSInteger)row tag:(NSInteger)tag{
    
    NSDictionary *dict = self.merchandArray[row];
    NSArray *merchArray = [dict objectForKey:@"merchandiesList"];
    NSDictionary *merhchDict = merchArray[tag];
    _singleMerchanID = [[merhchDict objectForKey:@"merchdisConstructionId"] integerValue];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确认删除该商品？"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = 400;
    [alertView show];

}

#pragma mark - 去商品详情
-(void)goGoodsDetailWithRow:(NSInteger)row tag:(NSInteger)tag{
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] init];
    
    NSDictionary *dict = self.merchandArray[row];
    NSArray *merchArray = [dict objectForKey:@"merchandiesList"];
    NSDictionary *merhchDict = merchArray[tag];
    vc.origin = @"0";
    vc.goodsID = [[merhchDict objectForKey:@"merchandiesId"] integerValue];
    vc.shopID = self.siteModel.companyId;
    
    vc.fromBack = NO;
    vc.shopid = self.siteModel.companyId;
    vc.companyType = self.siteModel.companyType;
    vc.phone = self.siteModel.companyPhone;
    vc.telPhone = self.siteModel.companyLandline;
    
    NSString *merchanStr = [NSString stringWithFormat:@"%@",[merhchDict objectForKey:@"merchandiesId"]];
    NSDictionary *dicTwo= [NSDictionary dictionaryWithObjectsAndKeys:merchanStr,@"merchandiesId",
                          self.siteModel.companyLandline,@"companyLandline",
                          self.siteModel.companyPhone,@"companyPhone",
                          self.siteModel.companyId,@"companyId",
                           self.siteModel.companyType,@"companyType",
                          nil];
    
    vc.dataDic = dicTwo;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 本案材料的点赞
-(void)zanShopCaseWith:(NSIndexPath *)path{
    
    BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
    if (!isLogin) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请先登录" controller:self sleep:1.5];
        return;
    }
    
    NSDictionary *dict = self.merchandArray[path.row];
    
    //当前人员是否点过赞 isHaveZan：0当前人员没点赞   不为0：点过赞
    NSInteger isHaveZan = [[dict objectForKey:@"dzAgencysId"] integerValue];
    if (isHaveZan) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"您已经点过赞" controller:self sleep:1.5];
        return;
    }
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"constructionMerchandies/clickLike.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"agencysId":@(user.agencyId),
                               @"constructionId":@(self.consID)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"点赞成功" controller:self sleep:1.5];
                [self getDataNoHidden];
            }

            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"点赞失败" controller:self sleep:1.5];
            }
            
        }

    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}



#pragma mark - DiaryTitleHeaderViewDelegate

-(void)addPointWith:(NSInteger)tag

{
    bool isLogin = [[PublicTool defaultTool]publicToolsJudgeIsLogined];
    
    if ((!isLogin)||(!_isExit)||(self.siteModel.ccComplete==2||self.siteModel.ccComplete==3)){
        return;
    }
    
    if (_isShowRightBtn) {
        [[PublicTool defaultTool] publicToolsHUDStr:deletePeople controller:self sleep:1.5];
        return;
    }
    
    NodeModel *model = self.nodeArr[tag-2];

    
    if (tag==2) {
        //本案材料
        
        if (!self.siteModel.companyId||self.siteModel.companyId.length<=0||[self.siteModel.companyId isEqualToString:@"0"]) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"该公司不存在" controller:self sleep:1.5];
            return;
        }
        AddMerchanController *vc = [[AddMerchanController alloc]init];
        vc.shopId = self.siteModel.companyId;
        vc.consID = self.consID;
        vc.journalId = [model.crNodeNumber integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (tag==(self.nodeArr.count+2-1)) {
        
        //本案装修
        CaseMaterialController *vc = [[CaseMaterialController alloc]init];
        vc.consID = self.consID;
        vc.fromIndex = 2;
        vc.cJobTypeId = [self.siteModel.cpLimitsId integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        NSInteger n = 0;
        if (selectNodeIsHave) {
            n = 0;
        }
        else{
            n = 1;
        }
        
        //下一个节点可以添加，进入添加页面
        SignContractViewController *signVC = [[SignContractViewController alloc]init];
        signVC.title = model.crRoleName;
        signVC.constructionIdStr = self.consID;
        signVC.cJobTypeIdStr = [self.siteModel.cpLimitsId integerValue];
        signVC.type = model.crNodeNumber;
        signVC.isAdd = n;
        signVC.index = 2;
        signVC.companyLogo = self.siteModel.companyLogo;
        signVC.companyName = self.siteModel.companyName;
        signVC.companyId = self.companyId;
        signVC.agencysJob = self.agencysJob;
        signVC.nodeId = model.crNodeNumber;
        [self.navigationController pushViewController:signVC animated:YES];
    }
    
}

-(void)lookDetailInfo:(NSInteger)tag{
    if (_isShowRightBtn) {
        [[PublicTool defaultTool] publicToolsHUDStr:deletePeople controller:self sleep:1.5];
        return;
    }
    MainMaterialMemberModel *model = self.memberListArr[tag];
    NewMyPersonCardController *vc = [[NewMyPersonCardController alloc]init];
    vc.agencyId = model.cpPersonId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SignContractTableViewCellDelegate

-(void)zanWith:(NSIndexPath *)path{
    if (_isShowRightBtn) {
        [[PublicTool defaultTool] publicToolsHUDStr:deletePeople controller:self sleep:1.5];
        return;
    }
    [self requsetZanWith:path];
}


-(void)commentWith:(NSIndexPath *)path{
    if (!_isExit) {
        return;
    }
    if (_isShowRightBtn) {
        [[PublicTool defaultTool] publicToolsHUDStr:deletePeople controller:self sleep:1.5];
        return;
    }
    _indexPath = path;
    CGFloat keyH = 0;
    if (kSCREEN_WIDTH<350) {
        keyH = 253;
    }else if (kSCREEN_WIDTH<400){
        keyH = 258;
    }else{
        keyH = 271;
    }
    [self.leaveWordTV becomeFirstResponder];

}

-(void)editWith:(NSIndexPath *)path{
    bool isLogin = [[PublicTool defaultTool]publicToolsJudgeIsLogined];
    
    if ((self.siteModel.ccComplete==2||self.siteModel.ccComplete==3)||(!isLogin)||(!_isExit)){
        return;
    }
    
    
    
    if (_isShowRightBtn) {
        [[PublicTool defaultTool] publicToolsHUDStr:deletePeople controller:self sleep:1.5];
        return;
    }
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];

    NodeModel *model = self.nodeArr[path.section-2];
    NSArray *journalList = model.journalList;
    if (journalList.count<=0) {
        return;
    }
    
    NSDictionary *dic = journalList[path.row];
    NSInteger agencysId = [[dic objectForKey:@"agencysId"] integerValue];
    NSArray *imgArray = [dic objectForKey:@"imgList"];
    NSMutableArray *temImgArray = [NSMutableArray array];
    if (imgArray.count>0) {
        for (NSDictionary *imgDict in imgArray) {
            NSString *imgStr = [imgDict objectForKey:@"picUrl"];
            [temImgArray addObject:imgStr];
        }
    }
    NSArray *copyArray = [temImgArray copy];
    if (agencysId == user.agencyId){
        EditJournalController *signVC = [[EditJournalController alloc]init];
        signVC.model = model;
        signVC.imgList = copyArray;
        signVC.contentStr = [dic objectForKey:@"content"];
        signVC.journalId = [dic objectForKey:@"journalId"];
        signVC.constructionId = self.consID;
        signVC.type = model.crNodeNumber;
        signVC.likeNum = [dic objectForKey:@"likeNum"];
        signVC.isAdd = @"1";
        signVC.titleStr = model.crRoleName;
        signVC.fromIndex = 2;
        signVC.companyLogo = self.siteModel.companyLogo;
        signVC.companyName = self.siteModel.companyName;
        signVC.companyId = self.siteModel.companyId;
        signVC.agencysJob = self.agencysJob;
        [self.navigationController pushViewController:signVC animated:YES];
    }
    else{

    }
}

#pragma mark - 节点上查看他人资料

-(void)lookInfoWith:(NSIndexPath *)path{
    
    NodeModel *model = self.nodeArr[path.section-2];
    NSArray *journalList = model.journalList;
    if (journalList.count<=0) {
        return;
    }
    NSDictionary *dic = journalList[path.row];
    NSInteger agencysId = [[dic objectForKey:@"agencysId"] integerValue];
    
    NewMyPersonCardController *vc = [[NewMyPersonCardController alloc]init];
    vc.agencyId =[NSString stringWithFormat:@"%ld",agencysId];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)tapCommentLabel:(UILabel *)label indexPath:(NSIndexPath *)path {
    label.numberOfLines = label.numberOfLines == 0;
    //一个cell刷新
    [self.diaryTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path,nil] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - 删除人员 或者分享

-(void)DeleteOrShare{
    
    if (!isShareOrCompleteBtn) {
        [self.shareView share];
        //调用分享

    }
    else{
        if (self.deletePeopleArray.count<=0) {
            [self.memberListArr addObjectsFromArray:self.deletePeopleArray];
            [self.deletePeopleArray removeAllObjects];
            _isShowRightBtn = NO;
            isShareOrCompleteBtn = NO;
            [self.shareOrDeleteBtn setTitle:@"分享" forState:UIControlStateNormal];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
            [self.diaryTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"确定要删除所选的人员吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        alert.tag = 100;
        [alert show];

    }
    
    
    
    
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        if (buttonIndex==0) {
            [self.memberListArr addObjectsFromArray:self.deletePeopleArray];
            [self.deletePeopleArray removeAllObjects];
            _isShowRightBtn = NO;
            isShareOrCompleteBtn = NO;
            [self.shareOrDeleteBtn setTitle:@"分享" forState:UIControlStateNormal];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
            [self.diaryTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        if (buttonIndex == 1) {
            NSString *jsonStr = @"";
            //[{"id":"2589","rongUserId":"88e1890f-b6bf-498e-90db-05ed57f377e8"},{"id":"2585","rongUserId":"010161"}]
            NSMutableArray *temArray = [NSMutableArray array];
            for (MainMaterialMemberModel *model in self.deletePeopleArray) {
                NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
                
                [addDict setObject:model.personId forKey:@"id"];
                [temArray addObject:addDict];
            }
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:temArray options:NSJSONWritingPrettyPrinted error:nil];
            jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            
            
            
            NSString *defaultApi = [BASEURL stringByAppendingString:@"participant/deleteById.do"];
            
            NSDictionary *paramDic = @{@"persionId":jsonStr
                                       };
            [self.view hudShow];
            [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
                
                if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
                    [self.view hiddleHud];
                    NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
                    
                    switch (statusCode) {
                        case 10000:
                            
                        {
                            isShareOrCompleteBtn = NO;
                            [self.shareOrDeleteBtn setTitle:@"分享" forState:UIControlStateNormal];
                            
                            
                            
                            [[PublicTool defaultTool] publicToolsHUDStr:@"删除成功" controller:self sleep:1.5];
                            
                            //判断删除人员中是否有自己
                            bool isHave = NO;
                            for (MainMaterialMemberModel *model in self.deletePeopleArray) {
                                if ([model.cpLimitsId integerValue]==self.cJobTypeId) {
                                    isHave = YES;
                                    break;
                                }
                                else{
                                    isHave = NO;
                                }
                            }
                            
                            if (isHave) {
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"QuitContructrefreshList" object:nil];
                                [self SuspendedButtonDisapper];
                                //自己
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            else{
                                _isShowRightBtn = NO;
                                [self.deletePeopleArray removeAllObjects];
                                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
                                [self.diaryTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                            }
                            
                        }
                            break;
                            
                        case 10001:
                            
                        {
                            [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1.5];
                        }
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
    }
    
    if (alertView.tag==200) {
        if (buttonIndex==1) {
            NodeModel *model = self.nodeArr[_deletePath.section-2];
            NSArray *journalList = model.journalList;
            NSString *journalId = [journalList[_deletePath.row] objectForKey:@"journalId"];
            NSString *defaultApi = [BASEURL stringByAppendingString:@"journal/getDelete.do"];
            
            NSInteger journCount = journalList.count;
            NSInteger temConsID = self.consID;
            if (journCount>1) {
                temConsID = 0;
            }
            
            NSDictionary *paramDic = @{@"journalId":journalId,
                                       @"constructionId":@(temConsID)
                                       };
            [[UIApplication sharedApplication].keyWindow hudShow];
            [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
                [[UIApplication sharedApplication].keyWindow hiddleHud];
                
                if (responseObj) {
                    
                    NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
                    if (statusCode==1000) {
                        [self getDataNoHidden];
                    }
                    else if (statusCode==1001){
                        [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
                    }
                    
                    else if (statusCode==2000){
                        [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1.5];
                    }
                    else{
                        [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1.5];
                    }
                }
            } failed:^(NSString *errorMsg) {
                YSNLog(@"%@",errorMsg);
                [[UIApplication sharedApplication].keyWindow hiddleHud];
                [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
            }];
        }
    }
    
    if (alertView.tag==300) {
        if (buttonIndex==1) {
            CaseMaterialTwoModel *model = self.materialArray[deleteCaseIndex];
            NSInteger temId = [model.materialId integerValue];
            [self deleteCaseMatiarlWith:temId];
            
        }
    }
    
    if (alertView.tag==400){
        if (buttonIndex==1) {
            [self deleteSingelMerchan];
        }
    }
    
}

#pragma mark - 删除主材日志单个本案材料

-(void)deleteSingelMerchan{
    NSString *defaultApi = [BASEURL stringByAppendingString:@"constructionMerchandies/delete.do"];
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"constructionMerchandiesId":@(_singleMerchanID)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"删除成功" controller:self sleep:1.5];
                [self getDataNoHidden];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"服务器异常" controller:self sleep:1.5];
            }
            
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 删除本案装修
-(void)deleteCaseMatiarlWith:(NSInteger)materialId{
    NSString *defaultApi = [BASEURL stringByAppendingString:@"journalMaterial/delete.do"];
    NSDictionary *paramDic = @{@"materialId":@(materialId)
                               };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            switch (statusCode) {
                case 1000:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"删除成功" controller:self sleep:1.5];
                    [self.materialArray removeObjectAtIndex:deleteCaseIndex];
                    [self.diaryTableView reloadData];
                    
                }
                    break;
                case 1001:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
                }
                    break;
                case 2000:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"服务器错误" controller:self sleep:1.5];
                }
                    break;
                    
                default:
                    [[PublicTool defaultTool] publicToolsHUDStr:@"服务器错误" controller:self sleep:1.5];
                    break;
            }
        }

    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}


#pragma mark - 评论接口

-(void)reqestCommentWith:(NSIndexPath *)path{
    if (self.leaveWordTV.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"评论不能为空" controller:self sleep:1.5];
        return;
    }
    NSInteger type = 0;
    NodeModel *model = self.nodeArr[path.section-2];
    NSString *journalId = @"";
    if (path.section==(self.nodeArr.count+2-1)) {
        //本案装修
        type = 1;
        CaseMaterialTwoModel *Casemodel = self.materialArray[path.row];
        journalId = Casemodel.materialId;
    }
    else{
        type = 0;
        NSArray *journalList = model.journalList;
        journalId = [journalList[path.row] objectForKey:@"journalId"];
    }
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"comment/save.do"];
    NSDictionary *paramDic = @{@"journalId":journalId,
                               @"type":@(type),
                               @"agencyId":@(user.agencyId),
                               @"cpConstructionId":@(self.consID),
                               @"content":self.leaveWordTV.text
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        self.leaveWordTV.text = @"";
        self.placeholderL.hidden = NO;
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    isBottomVShow = NO;
                    [[PublicTool defaultTool] publicToolsHUDStr:@"评论成功" controller:self sleep:1.5];
                    [self getDiaryDatawith:path];
                    
                    
                }
                    break;
 
                    
                default:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"评论失败" controller:self sleep:1.5];
                }
                    break;
            }
        }

    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)lookPhoto:(NSInteger)index imgArray:(NSArray *)imgArray{
    if (_isShowRightBtn) {
        [[PublicTool defaultTool] publicToolsHUDStr:deletePeople controller:self sleep:1.5];
        return;
    }
    __weak MainMaterialDiaryController *weakSelf=self;
    YPImagePreviewController *yvc = [[YPImagePreviewController alloc]init];
    yvc.images = imgArray ;
    yvc.index = index ;
    UINavigationController *uvc = [[UINavigationController alloc]initWithRootViewController:yvc];
    [weakSelf presentViewController:uvc animated:YES completion:nil];
}

#pragma mark - 普通的点赞接口

-(void)requsetZanWith:(NSIndexPath *)path{
    
    bool isLogin = [[PublicTool defaultTool]publicToolsJudgeIsLogined];
    if (!isLogin) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"未登录不能点赞" controller:self sleep:1.5];
        return;
    }
    NodeModel *model = self.nodeArr[path.section-2];
    NSArray *journalList = model.journalList;
    NSString *journalId = [journalList[path.row]  objectForKey:@"journalId"];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"journal/upByGradeAndlikeNum.do"];
    [self.view hudShow];
    NSDictionary *paramDic = @{@"journalId":journalId,
                               @"likeNum":@(3),
                               @"agencysId":@(user.agencyId),
                               @"constructionId":@(self.consID),
                               @"ccConstructionNodeId":model.crNodeNumber
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"点赞成功" controller:self sleep:1.5];
                    [self getDiaryDatawith:path];

                }
                    break;
                case 1001:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"节点id为空" controller:self sleep:1.5];
                }
                    break;
                case 1002:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"点赞标识为空" controller:self sleep:1.5];
                }
                    break;
                case 1004:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"已经点过赞了" controller:self sleep:1.5];
                }
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

#pragma mark - 点赞之后重新刷新指定的cell
-(void)getDiaryDatawith:(NSIndexPath *)path{
    [self.nodeArr removeAllObjects];
    [self.materialArray removeAllObjects];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/newJournalzc.do"];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID),
                               @"agencysId":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            YSNLog(@"%@",responseObj);
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    
                    NSArray *nodeArr = [[responseObj objectForKey:@"data"]objectForKey:@"roleList"];
                    //
                    for (NSDictionary *dict in nodeArr) {
                        
                        NodeModel *node = [NodeModel yy_modelWithJSON:dict];
                        
                        if (![self.nodeArr containsObject:node]) {
                            [self.nodeArr addObject:node];
                        }
                    }
                    
                    //本案装修
                    NSArray *materalArray = [[responseObj objectForKey:@"data"]objectForKey:@"material"];
                    if (materalArray.count>0) {
                        [self.materialArray removeAllObjects];
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:materalArray];
                        [self.materialArray addObjectsFromArray:arr];
                    }
                    
                    //一个cell刷新
                    
                    [UIView animateWithDuration:0 animations:^{
                        [self.diaryTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path,nil] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
    
}

#pragma mark - 删除评论

- (void)longPressCommentLabel:(UILabel *)label indexPath:(NSIndexPath *)path {
    if (self.siteModel.ccComplete==2||self.siteModel.ccComplete==3) {
        return;
    }
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除提示" message:@"删除后不可恢复!!！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:cancleAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *defaultApi = [BASEURL stringByAppendingString:@"comment/getDelete.do"];
        NSDictionary *paramDic = @{@"commentId":@(label.tag),
                                   };
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                {
                    [self.view hudShowWithText:@"删除成功"];
                    [self getDiaryDatawith:path];
                }
                    break;
                default:
                    [self.view hudShowWithText:@"删除失败"];
                    break;
            }
        } failed:^(NSString *errorMsg) {
            
        }];
        
    }];
    [alertC addAction:sureAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - 删除普通节点
-(void)deletePointWith:(NSIndexPath *)path{
    
    _deletePath = path;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确认删除该节点？"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag=200;
    [alertView show];
    
}

#pragma mark CaseMaterialCellDelegate

-(void)CasecommentWith:(NSIndexPath *)path{
    
    YSNLog(@"2222");
    if (self.siteModel.ccComplete==2||self.siteModel.ccComplete==3) {
        return;
    }
    _indexPath = path;
    CGFloat keyH = 0;
    if (kSCREEN_WIDTH<350) {
        keyH = 253;
    }else if (kSCREEN_WIDTH<400){
        keyH = 258;
    }else{
        keyH = 271;
    }

    [self.leaveWordTV becomeFirstResponder];
}

-(void)CasezanWith:(NSIndexPath *)path{
    
    if (self.siteModel.ccComplete==2||self.siteModel.ccComplete==3) {
        return;
    }
    [self caseRequestZanWith:path];
}

-(void)goShopWith:(NSIndexPath *)path{
    
    CaseMaterialTwoModel *model = self.materialArray[path.row];
    CompanyDetailViewController *shopDetail = [[CompanyDetailViewController alloc] init];
    shopDetail.companyName = model.companyName;
    shopDetail.companyID = model.merchantId;
    
    [self.navigationController pushViewController:shopDetail animated:YES];
}

-(void)deleteShopWith:(NSIndexPath *)path{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确认删除该施工日志？"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    deleteCaseIndex = path.row;
    alertView.tag = 300;
    [alertView show];
}

#pragma mark - 本案装修点赞

-(void)caseRequestZanWith:(NSIndexPath *)path{
    bool isLogin = [[PublicTool defaultTool]publicToolsJudgeIsLogined];
    if (!isLogin) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"未登录不能点赞" controller:self sleep:1.5];
        return;
    }
    CaseMaterialTwoModel *model = self.materialArray[path.row];
    NSString *journalId = model.materialId;
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"journalMaterial/uplikeNum.do"];
    NSDictionary *paramDic = @{@"materialId":journalId,
                               @"agencysId":@(user.agencyId),
                               @"constructionId":@(self.consID)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"点赞成功" controller:self sleep:1.5];
                    [self getDiaryDatawith:path];
                    
                    
                }
                    break;
                case 1001:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"节点id为空" controller:self sleep:1.5];
                }
                    break;
     
                case 1004:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"已经点过赞了" controller:self sleep:1.5];
                }
                    break;
                    
                default:
                    [[PublicTool defaultTool] publicToolsHUDStr:@"点赞失败" controller:self sleep:1.5];
                    break;
            }

        }
    } failed:^(NSString *errorMsg) {
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - 获取主材日志详情

-(void)getData{
    [self.nodeArr removeAllObjects];
    [self.bannerImgArray removeAllObjects];
    [self.memberListArr removeAllObjects];
    [self.merchandArray removeAllObjects];
    [self.materialArray removeAllObjects];
    [[UIApplication sharedApplication].keyWindow hudShow];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/newJournalzc.do"];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID),
                               @"agencysId":@(user.agencyId)
                               };
    self.diaryTableView.hidden = YES;
    self.shareOrDeleteBtn.hidden = YES;
    
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            YSNLog(@"%@",responseObj);
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    self.diaryTableView.hidden = NO;
                    self.shareOrDeleteBtn.hidden = NO;
                    
                    
                    //轮播图数组
                    NSArray *imgListArray = [[responseObj objectForKey:@"data"]objectForKey:@"imgList"];

                    if (imgListArray.count) {

                    }
                    
                    //节点数组
                    NSArray *nodeArr = [[responseObj objectForKey:@"data"]objectForKey:@"roleList"];
                    NSArray *tempArray = [NSArray yy_modelArrayWithClass:[NodeModel class] json:nodeArr];
                    [self.nodeArr addObjectsFromArray:tempArray];

                    
                    //本案材料
                    NSArray *merchanArray = [[responseObj objectForKey:@"data"]objectForKey:@"merchandies"];
                    if (merchanArray.count>0) {
                        [self.merchandArray removeAllObjects];
                        [self.merchandArray addObjectsFromArray:merchanArray];
                    }
                    
                    //本案装修
                    NSArray *materalArray = [[responseObj objectForKey:@"data"]objectForKey:@"material"];
                    if (materalArray.count>0) {
                        [self.materialArray removeAllObjects];
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:materalArray];
                        [self.materialArray addObjectsFromArray:arr];
                    }
                    
                    //工地信息model
                    NSDictionary *construction = [[responseObj objectForKey:@"data"]objectForKey:@"construction"];
                    self.siteModel = [MainDiarySiteModel yy_modelWithJSON:construction];
                    if ([self.siteModel.cpPersonId integerValue]==0) {
                        _isExit = NO;
                    }
                    else{
                        _isExit = YES;
                    }
                    
                    if ([self.siteModel.cpLimitsId integerValue]==1002) {
                        isManage = YES;
                    }
                    else{
                        isManage = NO;
                    }
                    
                    if ([self.siteModel.cpLimitsId integerValue]==1027) {
                        isShopManage = YES;
                    }
                    else{
                        isShopManage = NO;
                    }
                    
                    if ([self.siteModel.cpLimitsId integerValue]==1029) {
                        isDesigner = YES;
                    }
                    else{
                        isDesigner = NO;
                    }
                    
                    if ([self.siteModel.implement isEqualToString:@"1"]) {
                        impletement = YES;
                    }
                    else
                    {
                        impletement = NO;
                    }
                    
                    [self addTwoDimensionCodeView];
                    if ([self.siteModel.ccConstructionNodeId integerValue]==6000) {
                        _nowNode = 6001;
                        self.siteModel.crRoleName = @"新日志";
                    }
                    else{
                        _nowNode = [self.siteModel.ccConstructionNodeId integerValue];
                        
                        for (NodeModel *model in self.nodeArr) {
                            if ([model.crNodeNumber integerValue]==_nowNode) {
                                self.siteModel.crRoleName = model.crRoleName;
                                break;
                            }
                        }
                        
                    }
                    
                   [self.diaryTableView reloadData];
                }
                    break;
                    
                case 2000:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"获取详情失败" controller:self sleep:1.5];
                }
                    break;
                    
                default:
                    break;
            }
        }
        [self makeShareView];
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

-(void)getDataNoHidden{
    [self.nodeArr removeAllObjects];
    [self.bannerImgArray removeAllObjects];
    [self.memberListArr removeAllObjects];
    [self.merchandArray removeAllObjects];
    [self.materialArray removeAllObjects];
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/newJournalzc.do"];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID),
                               @"agencysId":@(user.agencyId)
                               };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            YSNLog(@"%@",responseObj);
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    
                    //轮播图数组
                    NSArray *imgListArray = [[responseObj objectForKey:@"data"]objectForKey:@"imgList"];
 
                    if (imgListArray.count) {
                       
                    }
                    
                    //节点数组
                    NSArray *nodeArr = [[responseObj objectForKey:@"data"]objectForKey:@"roleList"];
                    NSArray *tempArray = [NSArray yy_modelArrayWithClass:[NodeModel class] json:nodeArr];
                    [self.nodeArr addObjectsFromArray:tempArray];

                    
                    //本案材料
                    NSArray *merchanArray = [[responseObj objectForKey:@"data"]objectForKey:@"merchandies"];
                    if (merchanArray.count>0) {
                        [self.merchandArray removeAllObjects];
                        [self.merchandArray addObjectsFromArray:merchanArray];
                    }
                    
                    //本案装修
                    NSArray *materalArray = [[responseObj objectForKey:@"data"]objectForKey:@"material"];
                    if (materalArray.count>0) {
                        [self.materialArray removeAllObjects];
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:materalArray];
                        [self.materialArray addObjectsFromArray:arr];
                    }
                    
                    //工地信息model
                    NSDictionary *construction = [[responseObj objectForKey:@"data"]objectForKey:@"construction"];
                    self.siteModel = [MainDiarySiteModel yy_modelWithJSON:construction];
                    if ([self.siteModel.cpPersonId integerValue]==0) {
                        _isExit = NO;
                    }
                    else{
                        _isExit = YES;
                    }
                    
                    
                    if ([self.siteModel.cpLimitsId integerValue]==1002) {
                        isManage = YES;
                    }
                    else{
                        isManage = NO;
                    }
                    
                    if ([self.siteModel.cpLimitsId integerValue]==1027) {
                        isShopManage = YES;
                    }
                    else{
                        isShopManage = NO;
                    }
                    
                    if ([self.siteModel.cpLimitsId integerValue]==1029) {
                        isDesigner = YES;
                    }
                    else{
                        isDesigner = NO;
                    }
                    if ([self.siteModel.implement isEqualToString:@"1"]) {
                        impletement = YES;
                    }
                    else
                    {
                        impletement = NO;
                    }
                    [self addTwoDimensionCodeView];
                    if ([self.siteModel.ccConstructionNodeId integerValue]==6000) {
                        _nowNode = 6001;
                        self.siteModel.crRoleName = @"新日志";
                    }
                    else{
                        _nowNode = [self.siteModel.ccConstructionNodeId integerValue];
                        
                        for (NodeModel *model in self.nodeArr) {
                            if ([model.crNodeNumber integerValue]==_nowNode) {
                                self.siteModel.crRoleName = model.crRoleName;
                                break;
                            }
                        }
                        
                    }
                    
                    
                }
                    break;
                    
                case 2000:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"获取详情失败" controller:self sleep:1.5];
                }
                    break;
                    
                default:
                    break;
            }
        }
      //  [self makeShareView];
        [self.diaryTableView reloadData];

    } failed:^(NSString *errorMsg) {

        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - 查询店长手机的接口（即本案设计）

-(void)requestManageOwnerOfDiary{
    NSString *defaultApi = [BASEURL stringByAppendingString:@"designs/getByConstructionId.do"];
    
    
    NSDictionary *paramDic = @{@"constructionId":@(self.consID)
                               };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                NSArray *arr = responseObj[@"data"][@"design"];
                BOOL isHavePower = NO;
                if (isShopManage||isManage||isDesigner||impletement) {
                    isHavePower = YES;
                }
                else{
                    isHavePower = NO;
                }
                if (arr.count<=0) {
                    //没有店长手记
                    
                    if (isHavePower) {
                        DesignCaseListController *vc = [[DesignCaseListController alloc] init];
                        vc.isFistr = YES;
                        vc.companyId = self.siteModel.companyId;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else{
                        [[PublicTool defaultTool] publicToolsHUDStr:@"相关人员还未上传，请耐心等待！" controller:self sleep:1.5];
                    }
                }
                else{
                    NewDesignImageWebController *designVC = [[NewDesignImageWebController alloc]init];
                    NSDictionary *dict = arr.firstObject;
                    designVC.consID = self.consID;
                    designVC.isPower = isHavePower;
                    designVC.isFistr = NO;
                    designVC.fromIndex = 2;
                    NSArray *temArray = [dict objectForKey:@"detailsList"];
                    NSArray *arr = [NSArray yy_modelArrayWithClass:[DesignCaseListModel class] json:temArray];
                    [designVC.orialArray addObjectsFromArray:arr];
                    [designVC.dataArray addObjectsFromArray:arr];
                    designVC.voteDescribe = [dict objectForKey:@"voteDescribe"];
                    designVC.voteType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"voteType"]];
                    designVC.order = [[dict objectForKey:@"order"] integerValue];
                    designVC.templateStr = [dict objectForKey:@"template"];
                    NSArray *couponArray =[dict objectForKey:@"coupons"];
                    NSArray *redArray = [NSArray yy_modelArrayWithClass:[ZCHCouponModel class] json:couponArray];
                    [designVC.redArray addObjectsFromArray:redArray];
                    designVC.coverTitle = [dict objectForKey:@"designTitle"];
                    designVC.coverTitleTwo = [dict objectForKey:@"designSubtitle"];
                    designVC.musicStyle = [[dict objectForKey:@"musicPlay"]integerValue];
                    designVC.coverImgUrl = [dict objectForKey:@"coverMap"];
                    designVC.designId = [[dict objectForKey:@"designId"] integerValue];
                    designVC.endTime = [dict objectForKey:@"endTime"];
                    designVC.musicName = [dict objectForKey:@"musicName"] ;
                    designVC.musicUrl = [dict objectForKey:@"musicUrl"];
                    designVC.coverImgStr = [dict objectForKey:@"picUrl"] ;
                    designVC.nameStr = [dict objectForKey:@"picTitle"];
                    designVC.linkUrl = [dict objectForKey:@"picHref"] ;
                    designVC.companyLogo = self.siteModel.companyLogo;
                    designVC.companyName = self.siteModel.companyName;
                    designVC.companyId = self.siteModel.companyId;
                    NSArray *optionArray = [dict objectForKey:@"optionList"];
                    NSArray *arrTwo = [NSArray yy_modelArrayWithClass:[VoteOptionModel class] json:optionArray];
                    [designVC.optionList addObjectsFromArray:arrTwo];
                    if(self.siteModel.ccComplete==0||self.siteModel.ccComplete==1){
                        //未交工
                        designVC.isComplate = NO;
                    }else{
                        designVC.isComplate = YES;
                    }
                    [self.navigationController pushViewController:designVC animated:YES];
                }
            }
        }
    } failed:^(NSString *errorMsg) {
        YSNLog(@"%@",errorMsg);
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - setter

-(UITableView *)diaryTableView{
    if (!_diaryTableView) {
        
        _diaryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        _diaryTableView.delegate = self;
        _diaryTableView.dataSource = self;
        _diaryTableView.showsVerticalScrollIndicator = NO;
        _diaryTableView.showsHorizontalScrollIndicator = NO;
        _diaryTableView.estimatedRowHeight = 0;
        _diaryTableView.estimatedSectionHeaderHeight = 0;
        _diaryTableView.estimatedSectionFooterHeight = 0;
        _diaryTableView.backgroundColor = Bottom_Color;
        _diaryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _diaryTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_diaryTableView registerClass:[DiaryTitleHeaderView class] forHeaderFooterViewReuseIdentifier:@"DiaryTitleHeaderView"];
        [_diaryTableView registerNib:[UINib nibWithNibName:@"OptionsTableViewCell" bundle:nil] forCellReuseIdentifier:@"OptionsTableViewCell"];
    }
    return _diaryTableView;
}

-(UIView *)bottomV{
    if (!_bottomV) {
        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 44)];
        _bottomV.backgroundColor = HEX_COLOR(0xf5f5f5);
    }
    return _bottomV;
}

-(UITextView *)leaveWordTV{
    if (!_leaveWordTV) {
        _leaveWordTV = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-90, 34)];
        _leaveWordTV.textColor = COLOR_BLACK_CLASS_3;
        _leaveWordTV.font = NB_FONTSEIZ_NOR;
        _leaveWordTV.delegate = self;
        _leaveWordTV.layer.masksToBounds = YES;
        _leaveWordTV.layer.cornerRadius = 4;
        
    }
    return _leaveWordTV;
}

-(UILabel *)placeholderL{
    if (!_placeholderL) {
        _placeholderL = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 34)];
        _placeholderL.text = @"我也想说一句";
        _placeholderL.textColor = COLOR_BLACK_CLASS_9;
        _placeholderL.font = NB_FONTSEIZ_NOR;
    }
    return _placeholderL;
}

-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(self.leaveWordTV.right+10, self.leaveWordTV.top, 60, self.leaveWordTV.height);
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        _sendBtn.backgroundColor = Main_Color;
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 4;
        [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

#pragma mark - 底部菜单栏

-(void)headbtn0click
{
    
}

-(void)headbtn1click{
    
    
    
    
    self.FlipView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight+ 180)];
    [self.view addSubview:self.FlipView];
    
    self.baseView =[[UIView alloc]initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth,  180)];
    self.baseView.backgroundColor =[UIColor whiteColor];
    [self.FlipView addSubview:self.baseView];
    
    UIButton *BtnGift = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, BLEJWidth/6, 30)];
    
    BtnGift.titleLabel.adjustsFontSizeToFitWidth=YES;
    [BtnGift setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [BtnGift setTitle:@"礼物" forState:UIControlStateNormal];
    
    [self.baseView addSubview:BtnGift];
    UIButton *btnLine=[[UIButton alloc]initWithFrame:CGRectMake(20,BtnGift.bottom+3 , BLEJWidth/6-10, 1)];
    btnLine.backgroundColor=[UIColor redColor];
    [self.baseView addSubview:btnLine];
    
    
    _xianHua=[[UIImageView alloc]initWithFrame:CGRectMake(20,80, 40, 40)];
  //  _xianHuaL=[[UILabel alloc]initWithFrame:CGRectMake(20+_xianHua.right+5, 80+10, 20, 20)];
    _jinQi=[[UIImageView alloc]initWithFrame:CGRectMake(20+60+40,80 , 40, 40)];
 //   _jinQiL=[[UILabel alloc]initWithFrame:CGRectMake(20+60+40+_xianHua.right+5, 80+10, 20, 20)];
    [_jinQi setContentMode:UIViewContentModeScaleAspectFill];
    [_xianHua setContentMode:UIViewContentModeScaleAspectFill];
    _jinQi.image=[UIImage imageNamed:@"Personcard_Flag"];
    _xianHua.image= [UIImage imageNamed:@"Personcard_Flower"] ;
//    NSInteger a=  [[NSUserDefaults standardUserDefaults] integerForKey:@"jinQiCount"];
//    NSInteger b= [[NSUserDefaults standardUserDefaults]integerForKey:@"XinahuaCount"];
//    _jinQiL.text =@(a).stringValue;
//    _xianHuaL.text =@(b).stringValue;
    
    
    _jinQi.userInteractionEnabled=YES;
    _xianHua.userInteractionEnabled =YES;
    UITapGestureRecognizer *Tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(ToJinQiPurchase)];
    
    UITapGestureRecognizer *Tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(ToXianHuaPurchase)];
    [_jinQi addGestureRecognizer:Tap1];
    [_xianHua addGestureRecognizer:Tap2];
    //     [jinQi addTarget:self action:@selector(ToJinQiPurchase) forControlEvents:UIControlEventTouchUpInside];
    //     [xianHua addTarget:self action:@selector(ToXianHuaPurchase) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:_jinQi];
    [self.baseView addSubview:_xianHua];
    [self.baseView addSubview:_jinQiL];
    [self.baseView addSubview:_xianHuaL];
    
    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(hiddenView:)];
    
    [self.FlipView addGestureRecognizer:Tap];
    
    
    
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.FlipView.mj_y = -180;
        self.FlipView.backgroundColor=    [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
    }];
}



- (void)hiddenView:(UITapGestureRecognizer*)tapGesture{
    
    CGPoint selectPoint = [tapGesture locationInView:self.FlipView];
    
    NSLog(@"%@",[NSValue valueWithCGPoint:selectPoint]);
    
    //CGRectContainsPoint(CGRect rect, <#CGPoint point#>)判断某个点是否包含在某个CGRect区域内
    
    if(!CGRectContainsPoint(self.baseView.frame, selectPoint)){
        
        [UIView animateWithDuration:0.3f animations:^{
            
            // self.FlipView.backgroundColor= [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5 ];
            self.FlipView.mj_y += 180 ;
        } completion:^(BOOL finished) {
            [self.FlipView removeFromSuperview];
        }];
        
    }
    
    
    
}
#pragma mark 锦旗的购买事件
-(void)ToJinQiPurchase{
    
    
    [UIView animateWithDuration:0.3f animations:^{
        
        // self.FlipView.backgroundColor= [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5 ];
        self.FlipView.mj_y += 180 ;
    } completion:^(BOOL finished) {
        [self.FlipView removeFromSuperview];
    }];
    JinQiViewController *view =[[JinQiViewController alloc]init];
     view.isSendFromCompany =YES;
    view.companyId = self.siteModel.companyId;
    WeakSelf(self)
    view.completionBlock = ^(NSString *count) {
        StrongSelf(weakself)
        if (count) {
            strongself.jinQiL.text=[NSString stringWithFormat:@"%d",(self.pennantnumber.integerValue +1)];
          
//            NSUserDefaults *defaultUser= [NSUserDefaults standardUserDefaults];
//            NSInteger totalDisk = [defaultUser integerForKey:@"jinQiCount"];
//            //锦旗的数量加一
//            totalDisk=[count integerValue] +1;
//            [defaultUser setInteger:totalDisk forKey:@"jinQiCount"];
//            [defaultUser synchronize];
//            strongself.jinQiL.text = [NSString stringWithFormat:@"%ld",(long)totalDisk];
            
        }
    };
    [self.navigationController pushViewController:view animated:YES];
    
}
#pragma mark 鲜花的购买事件

-(void)ToXianHuaPurchase{
    
    [UIView animateWithDuration:0.3f animations:^{
        
        // self.FlipView.backgroundColor= [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5 ];
        self.FlipView.mj_y += 180 ;
    } completion:^(BOOL finished) {
        [self.FlipView removeFromSuperview];
    }];
    NSLog(@"++++++++++++++++++");
    SendFlowersViewController *Flowerview =[[SendFlowersViewController alloc]init];
    Flowerview.compamyIDD =self.siteModel.companyId;
    Flowerview.isCompamyID =YES;
    WeakSelf(self)
    Flowerview.blockIsPay = ^(BOOL isPay) {
        StrongSelf(weakself)
        if (isPay ==YES) {
            //鲜花的数量加一
           // [strongself getData];
              strongself.xianHuaL.text =[NSString stringWithFormat:@"%d",(self.flowerNumber.integerValue +1)];
            
        }
        
    };
    [self.navigationController pushViewController:Flowerview animated:YES];
}


-(void)headbtn2click
{
    BLEJBudgetGuideController *vc = [BLEJBudgetGuideController new];
    vc.companyID = self.companyId;
    vc.origin = @"1";
    vc.isConVip = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)headbtn3click
{
    [self didClickHouseBtn];
}

- (void)didClickHouseBtn {// 量房
    self.infoView = [[NSBundle mainBundle] loadNibNamed:@"DecorateInfoNeedView" owner:nil options:nil].lastObject;
    self.infoView.frame = self.view.frame;
    [self.infoView.finishButton addTarget:self action:@selector(finishiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.infoView];
    // 店铺和公司的界面区别
    [self.infoView.areaTF removeFromSuperview];
    [self.infoView.timeTF removeFromSuperview];
    self.infoView.tipLabel.text = @"本公司业务人员会与您电话沟通，请确保电话畅通！     ";
    //    self.infoView.tipLabelHeight.constant = 30;
    self.infoView.protocolImageTopToPhoneTFCon.constant = 6;
    
    MJWeakSelf;
    self.infoView.sendVertifyCodeBlock = ^{
        [weakSelf sendvertifyAction];
    };
    self.infoView.hidden = NO;
    
    // 在线预约 后台数据统计
    [NSObject needDecorationStatisticsWithConpanyId:[NSString stringWithFormat:@"%ld",self.consID]];
    
}


#pragma  mark - 发送验证码
- (void)sendvertifyAction {
    
    [self.infoView endEditing:YES];
    if (![self.infoView.phoneTF.text ew_justCheckPhone]) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的手机号"];
        return;
    }
    
    NSString* url = [NSString stringWithFormat:@"%@%@", BASEURL, @"callDecoration/sendPhoneCode.do"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.infoView.phoneTF.text forKey:@"phone"];
    [param setObject:[NSString stringWithFormat:@"%ld",self.consID] forKey:@"companyId"];
    MJWeakSelf;
    [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
        
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码发送成功"];
                [weakSelf timelessWithSecond:120 button:weakSelf.infoView.sendVertifyBtn];
                break;
            case 1001:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"当月已喊过装修"];
                break;
            default:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"预约失败或操作过于频繁"];
                break;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)timelessWithSecond:(NSInteger)s button:(UIButton *)btn {
    
    __block int timeout = (int)s; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout <= 0) { //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
                btn.backgroundColor = kMainThemeColor;
            });
        } else {
            
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [btn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                btn.userInteractionEnabled = NO;
                btn.backgroundColor = kDisabledColor;
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
}

#pragma mark - 完成
- (void)finishiAction {
    
    if ([self.infoView.nameTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入您的姓名"];
        return;
    }
    if (![self.infoView.phoneTF.text ew_checkPhoneNumber]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的联系方式"];
        return;
    }
    if (self.infoView.vertifyCodeTF.text.length != 6) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入6位数的验证码"];
        return;
    }
    NSInteger proType = -1;
    if ([self.infoView.itemTF.text isEqualToString:@"量房"]) {
        proType = 0;
    }
    if ([self.infoView.itemTF.text isEqualToString:@"设计"]) {
        proType = 1;
    }
    if ([self.infoView.itemTF.text isEqualToString:@"施工"]) {
        proType = 2;
    }
    if ([self.infoView.itemTF.text isEqualToString:@"维修"]) {
        proType = 3;
    }
    if ([self.infoView.itemTF.text isEqualToString:@"其他"]) {
        proType = 4;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.infoView.vertifyCodeTF.text forKey:@"phoneCode"];
    [dic setObject:self.infoView.phoneTF.text forKey:@"phone"];
    [dic setObject:self.infoView.nameTF.text forKey:@"fullName"];
//    [dic setObject:self.companyDic[@"companyId"] forKey:@"companyId"];
    [dic setObject:self.companyId forKey:@"companyId"];
//    [dic setObject:self.companyDic[@"companyType"] forKey:@"companyType"];
    [dic setObject:@"" forKey:@"companyType"];
    [dic setObject:@(proType) forKey:@"proType"];
    [dic setObject:@"0" forKey:@"agencyId"];
    [dic setObject:@"0" forKey:@"callPage"];
    [self upDataRequest:dic];
}

- (void)upDataRequest:(NSMutableDictionary *)dic {
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    __weak typeof(self)  weakSelf = self;
    [dic setObject:@"0" forKey:@"origin"];
    NSString *url = [BASEURL stringByAppendingString:@"callDecoration/v2/save.do"];
    [NetManager  afGetRequest:url parms:dic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        
        switch ([responseObj[@"code"] integerValue]) {
                //喊装修成功
            case 1000:
            {
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您已提交成功请等待回复"];
                
                // 睡一秒
                [NSThread sleepForTimeInterval:1];
                
                DecorateCompletionViewController *completionVC = [[DecorateCompletionViewController alloc] init];
                completionVC.dataDic = responseObj[@"data"];
                completionVC.companyType = weakSelf.companyType?:@"0";
                NSString *constructionType = weakSelf.constructionType?:@"0";
                completionVC.constructionType = constructionType;
                [self.navigationController pushViewController:completionVC animated:YES];
                break;
            }
            case 1001:
                break;
                //            本月已喊过装修
            case 1002:
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您本月已经预约过了"];
                break;
                //            不在装修区域
            case 1003:
                self.infoView.hidden = YES;
                [self replySubmit:dic];
                break;
                //             该区域暂无接单公司
            case 1004:
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该区域暂无接单公司"];
                break;
            case 2000:
            {
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"预约失败，稍后重试"];
                break;
            }
            case 2001:
            {
                self.infoView.hidden = NO;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码错误"];
                break;
            }
            default:
                break;
        }
        
    } failed:^(NSString *errorMsg) {
        
        [weakSelf.view hiddleHud];
        self.infoView.hidden = NO;
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

#pragma mark   不在装修区域  是否继续提交
- (void)replySubmit:(NSMutableDictionary *)dic {
    
    //该地区不在装修公司服务区域，继续提交，我们会为您提供本地区优秀公司服务，是否继续提交？
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"该地区不在装修公司服务区域，继续提交，我们会为您提供本地区优秀公司服务，是否继续提交？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    __weak typeof(self)  weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"提交" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [dic setObject:@(1) forKey:@"type"];
        
        [weakSelf upDataRequest:dic];
    }];
    
    
    [aler addAction:action];
    [aler addAction:action1];
    [self presentViewController:aler animated:YES completion:nil];
}

@end
