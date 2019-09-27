//
//  EditInfoViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "EditInfoViewController.h"
#import "ChangeLogoTableViewCell.h"
#import "EditNameAndWechatTableViewCell.h"
#import "JobListViewController.h"
#import "PersonalInfoTableViewCell.h"
#import "WorkTimeTableViewCell.h"
#import "GenderTableViewCell.h"
#import "AreaTableViewCell.h"

#import "QrCodeCell.h"
#import "RemarkTableViewCell.h"
#import "IntroduTableViewCell.h"
#import "ZCHJobListView.h"
#import "UploadImageApi.h"
#import "GTMBase64.h"
#import "JobModel.h"
#import "UploadPersonInfoApi.h"
#import "HCGDatePickerAppearance.h"
#import "RegionView.h"
#import "PModel.h"
#import "CModel.h"
#import "DModel.h"

#import "WWPickerView.h"
#import "NSObject+CompressImage.h"
#import "LocationViewController.h"
#import "professionallabelVC.h"
#import "worktypeVC.h"
#import "WorkTypeModel.h"

@interface EditInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    CGFloat _aPid;
    CGFloat _aCid;
    CGFloat _aDid;
    CGFloat _nPid;
    CGFloat _nCid;
    CGFloat _nDid;
    
    CGFloat _roTypeId;
    
    CGFloat remarkViewH;
    CGFloat introduViewH;
    
    NSInteger _upLoadPhotoTag; // 1:更换个人头像 2:更换二维码图片
}

@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;

@property (nonatomic, strong) UITableView *editInfoTableView;
@property (nonatomic, strong) RegionView *regionView;
@property (nonatomic, strong) NSDictionary *jobDict;

@property (nonatomic, copy) NSString *jobStr;//职位
@property (nonatomic, assign) NSInteger gender;//性别
@property (nonatomic, copy) NSString *nameStr;//姓名
@property (nonatomic, copy) NSString *logoStr;//头像
@property (nonatomic, copy) NSString *wechatStr;//微博
@property (nonatomic, copy) NSString *wechatQer;//微信二维码
@property (nonatomic, copy) NSString *dateStr;//从业时间
@property (nonatomic, copy) NSString *birthdayStr;//生日
@property (nonatomic, copy) NSString *nativeStr;//所在地

@property (nonatomic, copy) NSString *address;//个人详细地址
@property (nonatomic, assign) double lantitude; // 地址经纬度
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString *emilStr;//邮箱
@property (nonatomic, copy) NSString *companyJob;//公司职位
@property (nonatomic, copy) NSString *collegeName;//毕业院校
@property (nonatomic, copy) NSString *comment;//人生格言
@property (nonatomic, copy) NSString *introStr;//个人简介
@property (nonatomic, copy) NSString *showPhone;//是否展示手机号 0 不展示 1展示
@property (nonatomic, strong) NSArray *addressArray;
@property (nonatomic, strong) NSArray *nativeArray;
@property (strong, nonatomic) NSString *roleType;
@property (nonatomic, copy) NSString *Individualstr;//个人标签
@property (nonatomic, copy) NSString *worktypestr;//职业类别
// 弹出职位选择时的底部视图
@property (strong, nonatomic) UIView *shadowView;
@property (strong, nonatomic) ZCHJobListView *jobListView;
@property (strong, nonatomic) WorkTypeModel *modelWorkType;//公司职位
@end

@implementation EditInfoViewController

-(NSArray*)addressArray{
    
    if (!_addressArray) {
        _addressArray = [NSArray array];
    }
    return _addressArray;
}

-(NSArray*)nativeArray{
    
    if (!_nativeArray) {
        _nativeArray = [NSArray array];
    }
    return _nativeArray;
}

-(NSDictionary*)jobDict{
    
    if (!_jobDict) {
//        _jobDict = [NSDictionary dictionary];
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        _jobDict = [NSDictionary dictionaryWithObjectsAndKeys:user.jobName,@"cJobTypeName",@(user.roleTypeId),@"cJobTypeId", nil];
//        _jobDict = dict;
    }
    return _jobDict;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initData];
    [self createUI];
}

- (void)initData {
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    self.userModel = user;
    self.nameStr = self.userModel.trueName;
    self.wechatStr = self.userModel.weixin;
//    self.addressStr = self.userModel.addressStr;
    self.wechatQer = self.userModel.wxQrcode;
//    self.nativeStr = self.userModel.homeTownName;
    self.emilStr = self.userModel.email;//邮箱
    self.introStr = self.userModel.indu?self.userModel.indu:@"";
    self.showPhone = self.userModel.showPhone;
    
    if (self.userModel.workingDate == 0) {
        self.dateStr = @"";
    }
    else{
       self.dateStr = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:[NSString stringWithFormat:@"%ld", self.userModel.workingDate]];
    }
    
    
    self.comment = self.userModel.comment;
    self.logoStr = self.userModel.photo;
    self.companyJob = self.userModel.companyJob;
    self.collegeName = self.userModel.agencySchool;
    
    self.address = self.userModel.address;
    self.longitude = [self.userModel.longitude doubleValue];
    self.lantitude = [self.userModel.latitude doubleValue];
    
    if (self.userModel.agencyBirthday==0) {
        self.birthdayStr = @"";
    }
    else{
        self.birthdayStr = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:[NSString stringWithFormat:@"%ld", self.userModel.agencyBirthday]];
    }
    
    self.jobStr = self.userModel.jobName;
    self.gender = self.userModel.gender;
    
    _aPid = self.userModel.provinceId;
    _aCid = self.userModel.cityId;
    _aDid = self.userModel.countyId;
    _nPid = self.userModel.hometownProvinceId;
    _nCid = self.userModel.hometownCityId;
    _nDid = self.userModel.hometownCountyId;
    
    self.nativeStr = [self getCityName];
    
}
- (void)createUI {
    
    self.title = @"编辑个人资料";
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
//    返回
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tui2"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backBtn;
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    [self createTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getJobList:) name:@"jobNoti" object:nil];
}

- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = White_Color;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BLEJWidth, 10)];
    
    [self.view addSubview:tableView];
    self.editInfoTableView = tableView;
    
    [self.editInfoTableView registerNib:[UINib nibWithNibName:@"ChangeLogoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChangeLogoTableViewCell"];
    [self.editInfoTableView registerNib:[UINib nibWithNibName:@"EditNameAndWechatTableViewCell" bundle:nil] forCellReuseIdentifier:@"EditNameAndWechatTableViewCell"];
    [self.editInfoTableView registerNib:[UINib nibWithNibName:@"PersonalInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonalInfoTableViewCell"];
    
    [self.editInfoTableView registerNib:[UINib nibWithNibName:@"QrCodeCell" bundle:nil] forCellReuseIdentifier:@"QrCodeCell"];
    [self.editInfoTableView registerNib:[UINib nibWithNibName:@"WorkTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"WorkTimeTableViewCell"];
    [self.editInfoTableView registerNib:[UINib nibWithNibName:@"GenderTableViewCell" bundle:nil] forCellReuseIdentifier:@"GenderTableViewCell"];
    [self.editInfoTableView registerNib:[UINib nibWithNibName:@"AreaTableViewCell" bundle:nil] forCellReuseIdentifier:@"AreaTableViewCell"];
    [self.editInfoTableView registerNib:[UINib nibWithNibName:@"RemarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"RemarkTableViewCell"];

    [self.editInfoTableView registerNib:[UINib nibWithNibName:@"IntroduTableViewCell" bundle:nil] forCellReuseIdentifier:@"IntroduTableViewCell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([tableView isEqual:self.editInfoTableView]) {
        return 4;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([tableView isEqual:self.editInfoTableView]) {
        
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return 12;
        }else{
            return 1;
        }
    }
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000000000000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.editInfoTableView]) {
        
        if (indexPath.section == 0) {
            return 80;
        }else if (indexPath.section == 1){
            return 44;
        }
        else if (indexPath.section == 2){
            return 56.5+remarkViewH;
        }else{
            return 56.5+introduViewH;
        }
    }
    
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak EditInfoViewController *weakSelf = self;
    
    if ([tableView isEqual:self.editInfoTableView]) {
        
        switch (indexPath.section) {
            case 0:
            {
                ChangeLogoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChangeLogoTableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                NSURL *url = [NSURL URLWithString:self.logoStr];
                [cell.LogoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:DefaultManPic]];
                if (![self.showPhone integerValue]) {
                    [cell.publicBtn setImage:[UIImage imageNamed:@"circle_kong"] forState:UIControlStateNormal];
                }
                else{
                    [cell.publicBtn setImage:[UIImage imageNamed:@"circle_shi"] forState:UIControlStateNormal];
                }
                
                __weak typeof(self) weakSelf = self;
                cell.changeLogoBlock = ^(){
                    _upLoadPhotoTag = 1;
                    [weakSelf imagePicker];
                };
                
                cell.changePublicTag = ^{
                    if (![self.showPhone integerValue]) {
                        weakSelf.showPhone = @"1";
                    }
                    else{
                        weakSelf.showPhone = @"0";
                    }
                    
                    [weakSelf.editInfoTableView reloadData];
                };
                
                return cell;
            }
                break;
                
            case 1:
            {
                
                //            姓名
                if (indexPath.row == 0) {
                    
                    EditNameAndWechatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditNameAndWechatTableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.titleLabel.text = @"姓名";
                    cell.ContentTF.keyboardType = UIKeyboardTypeDefault;
                    cell.ContentTF.tag = indexPath.row;
                    cell.ContentTF.text = self.nameStr;
//                    self.nameStr = cell.ContentTF.text;
                    cell.ContentTF.delegate = self;
                    
                    return cell;
                }
                
                //                性别
                if (indexPath.row == 1) {
                    
                    GenderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GenderTableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.genderLabel.text = @"性别";
                    
                    //                    男
                    cell.maleBlock = ^(NSString *male){
                        
                        weakSelf.gender = [male integerValue];
                    };
                    
                    //                    女
                    cell.femaleBlock = ^(NSString *female){
                        
                        weakSelf.gender = 0;
                    };
                    
                    return cell;
                }
                
                //                年龄
                if (indexPath.row == 2) {
                    
                    WorkTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkTimeTableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.titleLabel.text = @"年龄";
                    cell.timeTF.delegate = self;
                    if (self.birthdayStr.length > 0) {
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        NSDate *currentDate = [NSDate date];//获取当前时间，日期
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        NSString *dateString = [dateFormatter stringFromDate:currentDate];
                        NSArray *nowTimeArr = [dateString componentsSeparatedByString:@"-"];
                        NSArray *birthArr = [self.birthdayStr componentsSeparatedByString:@"-"];
                        NSInteger age = [nowTimeArr[0] integerValue] - [birthArr[0] integerValue];
                        if ([nowTimeArr[1] integerValue] == [birthArr[1] integerValue]) {
                            
                            if ([nowTimeArr[2] integerValue] < [birthArr[2] integerValue]) {
                                
                                age = age - 1;
                            }
                        }
                        if ([nowTimeArr[1] integerValue] < [birthArr[1] integerValue]) {
                            
                            age = age - 1;
                        }
                        cell.timeTF.text = [NSString stringWithFormat:@"%ld", age];
                    } else {
                        
                        cell.timeTF.text = @"";
                    }
                    
                    [cell.timeTF setEnabled:NO];
                    return cell;
                }
                
                //            微博
                if (indexPath.row == 3) {
                    
                    EditNameAndWechatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditNameAndWechatTableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.titleLabel.text = @"微信";
                    cell.ContentTF.keyboardType = UIKeyboardTypeDefault;
                    cell.ContentTF.tag = indexPath.row;
                    cell.ContentTF.text = self.wechatStr;
//                    self.wechatStr = cell.ContentTF.text;
                    cell.ContentTF.delegate = self;
                    
                    return cell;
                }
                //微信二维码
                if (indexPath.row == 4) {
                    QrCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QrCodeCell"];
                    [cell.qrCodeImgV sd_setImageWithURL:[NSURL URLWithString:self.wechatQer] placeholderImage:[UIImage imageNamed:DefaultIcon]];
                    return cell;
                }
                
//                所在地
                if (indexPath.row == 5) {
                    
                    AreaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AreaTableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.areaLabel.text = @"所在地";
                    cell.contentLabel.text = self.nativeStr;
                    
                    return cell;
                }
                
                //个人详细地址
                if (indexPath.row == 6) {
                    
                    EditNameAndWechatTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"EditNameAndWechatTableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.titleLabel.text = @"个人地址";
                    cell.ContentTF.delegate = self;
                    cell.ContentTF.tag = indexPath.row;
                    cell.ContentTF.text = self.address;
                    cell.contentFCons.constant = -30;
                    
                    UIButton *locationButton = [[UIButton alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-40,7,30,30)];
                    locationButton.contentMode = UIViewContentModeScaleAspectFit;
                    [locationButton  addTarget:self action:@selector(localionButtonAction) forControlEvents:UIControlEventTouchUpInside];
                    [locationButton  setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
                    [cell addSubview:locationButton];
                    return cell;
                }
                
                //邮箱
                if (indexPath.row == 7) {
                    
                    EditNameAndWechatTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"EditNameAndWechatTableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.titleLabel.text = @"邮箱";
                    cell.ContentTF.delegate = self;
                    cell.ContentTF.tag = indexPath.row;
                    cell.ContentTF.text = self.emilStr;
                    
                    return cell;
                }
                
                //             公司职称
                if (indexPath.row == 8) {
                    
                    EditNameAndWechatTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"EditNameAndWechatTableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.titleLabel.text = @"公司职位";
                    cell.ContentTF.delegate = self;
                    cell.ContentTF.tag = indexPath.row;
                    cell.ContentTF.text = self.companyJob;
//                    [cell.ContentTF setEnabled:NO];
                    
                    return cell;
                }
                //职业类别
                if (indexPath.row == 9) {
                    
                    EditNameAndWechatTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"EditNameAndWechatTableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.titleLabel.text = @"职业类别";
                    cell.ContentTF.delegate = self;
                    cell.ContentTF.tag = indexPath.row;
                    [cell.ContentTF setEnabled:NO];
                    cell.ContentTF.text = self.modelWorkType.name?:self.userModel.roleType;
                    cell.ContentTF.userInteractionEnabled = false;
                    return cell;
                }
   
                //  毕业院校
                if (indexPath.row == 10) {
                    
                    EditNameAndWechatTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"EditNameAndWechatTableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.titleLabel.text = @"毕业院校";
                    cell.ContentTF.delegate = self;
                    cell.ContentTF.tag = indexPath.row;
                    cell.ContentTF.text = self.collegeName;
//                    [cell.ContentTF setEnabled:NO];
                    
                    return cell;
                }
                
                // 从业时间
                if (indexPath.row == 11) {
                    
                    WorkTimeTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"WorkTimeTableViewCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.titleLabel.text = @"从业时间";
                    cell.timeTF.delegate = self;
                    cell.timeTF.text = self.dateStr;
                    [cell.timeTF setEnabled:NO];

                    return cell;
                }
            }
                break;
                
            case 2:
            {
                

                
                RemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemarkTableViewCell"];
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.titleLabel.text = @"人生格言";
                cell.remarkTextView.delegate = self;
                cell.remarkTextView.tag = indexPath.section;
                if (self.comment&&self.comment.length>0) {
                    cell.remarkTextView.text = self.comment;
                    cell.remarkLabel.hidden = YES;
                }
                else{
                    cell.remarkLabel.hidden = NO;
                    cell.remarkLabel.text = @"讲讲你的人生格言吧！";
                }
                
                CGSize size = [self.comment boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-12*2, MAXFLOAT) withFont:NB_FONTSEIZ_NOR];
                if (size.height<=83.5) {
                    size.height=83.5;
                }
                remarkViewH = size.height+20;
                cell.remarkConH.constant = remarkViewH;
                return cell;
            }
            case 3:
            {
                IntroduTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntroduTableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.titleLabel.text = @"个人简介";
                cell.remarkTextView.delegate = self;
                cell.remarkTextView.tag = indexPath.section;
                if (self.introStr&&self.introStr.length>0) {
                    cell.remarkTextView.text = self.introStr;
                    cell.remarkLabel.hidden = YES;
                }
                else{
                    cell.remarkLabel.hidden = NO;
                    cell.remarkLabel.text = @"请输入个人简介";
                }

                CGSize size = [self.introStr boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-12*2, MAXFLOAT) withFont:NB_FONTSEIZ_NOR];
                if (size.height<=83.5) {
                    size.height=83.5;
                }
                introduViewH = size.height+20;
                cell.remarkConH.constant = introduViewH;
                return cell;
            }
                
            default:
                break;
        }
    }
    
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    switch (indexPath.section) {
        case 0: {
            _upLoadPhotoTag = 1;
            [self imagePicker];
        }
            break;
        case 1:
        {
          
            switch (indexPath.row) {
                case 0:// 姓名
                {
                    [self.regionView removeFromSuperview];
                }
                    break;
                case 1:// 性别
                {
                    [self.regionView removeFromSuperview];
                }
                    break;
                case 2:// 年龄
                {
                    [self.regionView removeFromSuperview];
                    [self getBirthdayStr];
                }
                    break;
                case 3:// 微信
                {
                    [self.regionView removeFromSuperview];
                }
                    break;
                case 4:// 微信二维码
                {
                    [self.regionView removeFromSuperview];
                    _upLoadPhotoTag = 2;
                    [self imagePicker];
                }
                    break;
                    
                case 5:// 所在地
                {
                    [self getNative];
                }
                    break;
                case 7:// 邮箱
                {
//                    [self getNative];
                }
                    break;

                case 8:// 公司职位
                {
                    [self.regionView removeFromSuperview];
                }
                    break;
                case 9:// 职业类别
                {
                    worktypeVC *vc = [worktypeVC new];
                    vc.stringJob = self.modelWorkType.name?:self.userModel.roleType;
                    vc.blockDidTouchItem = ^(WorkTypeModel *model) {
                        self.modelWorkType = model;
                        [self.editInfoTableView reloadData];
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;

//                case 9:// 个人标签
//                {
//                    professionallabelVC *vc = [[professionallabelVC alloc] init];
//                    [vc addObserver:self forKeyPath:@"infoarray" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                    break;

                case 10:// 毕业院校
                {
                    [self.regionView removeFromSuperview];
          
                }
                    break;
                    
                case 11:// 从业时间
                {

                    [self.regionView removeFromSuperview];
                    [self getDateStr];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)getTextfiledData {
    
    //姓名
    NSIndexPath *path1 = [NSIndexPath indexPathForRow:0 inSection:1];
    EditNameAndWechatTableViewCell *cellOne = [self.editInfoTableView cellForRowAtIndexPath:path1];
    self.nameStr = cellOne.ContentTF.text;
    
    //微博
    NSIndexPath *path2 = [NSIndexPath indexPathForRow:3 inSection:1];
    EditNameAndWechatTableViewCell *cellTwo = [self.editInfoTableView cellForRowAtIndexPath:path2];
    self.wechatStr = cellTwo.ContentTF.text;
    
    //人生格言
    NSIndexPath *path3 = [NSIndexPath indexPathForRow:0 inSection:2];
    RemarkTableViewCell *cellThree = [self.editInfoTableView cellForRowAtIndexPath:path3];
    self.comment = cellThree.remarkTextView.text;
    
    //邮箱
    NSIndexPath *emilPath = [NSIndexPath indexPathForRow:7 inSection:1];
    EditNameAndWechatTableViewCell *cellEmil = [self.editInfoTableView cellForRowAtIndexPath:emilPath];
    self.emilStr = cellEmil.ContentTF.text;
    
    //公司职位
    NSIndexPath *path4 = [NSIndexPath indexPathForRow:8 inSection:1];
    EditNameAndWechatTableViewCell *cellFour = [self.editInfoTableView cellForRowAtIndexPath:path4];
    self.companyJob = cellFour.ContentTF.text;
    
    //毕业院校
    NSIndexPath *path5 = [NSIndexPath indexPathForRow:9 inSection:1];
    EditNameAndWechatTableViewCell *cellFive = [self.editInfoTableView cellForRowAtIndexPath:path5];
    self.collegeName = cellFive.ContentTF.text;
}

#pragma mark - 选择从业时间
- (void)getDateStr {
   
    [self.view endEditing:YES];
    
    WWPickerView *pickerView = [[WWPickerView alloc] init];
    
    if (self.dateStr&&self.dateStr.length>0) {
        NSString* string = self.dateStr;
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [inputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *inputDate = [inputFormatter dateFromString:string];
        NSDate *dateNow = [inputDate dateByAddingTimeInterval:8 * 60 * 60];
        [pickerView setDateViewWithTitle:@"" withMode:UIDatePickerModeDate nowDate:dateNow];
    }
    else{
        [pickerView setDateViewWithTitle:@"" withMode:UIDatePickerModeDate];
    }
    
    [pickerView showPickView:self];
    
    //block回调
    __weak typeof (self) wself = self;
    pickerView.block = ^(NSString *selectedStr)
    {
        
        
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        
        NSInteger compareDate = [wself compareDate:selectedStr withDate:dateString];
        
        if (compareDate == -1) {
            //
            [[PublicTool defaultTool] publicToolsHUDStr:@"选择日期不能超过当前日期" controller:wself sleep:1.8];
            //            wself.dateStr = nil;
            
            return ;
        }else{
            wself.dateStr = selectedStr;
            
        }
       // [wself getTextfiledData];
        [wself.editInfoTableView reloadData];
        
    };
}

#pragma mark - 选择年龄
- (void)getBirthdayStr {
 
    [self.view endEditing:YES];
    
    WWPickerView *pickerView = [[WWPickerView alloc] init];
 
    if (self.birthdayStr&&self.birthdayStr.length>0) {
        NSString* string = self.birthdayStr;
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [inputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *inputDate = [inputFormatter dateFromString:string];
        NSDate *dateNow = [inputDate dateByAddingTimeInterval:8 * 60 * 60];
        [pickerView setDateViewWithTitle:@"" withMode:UIDatePickerModeDate nowDate:dateNow];
    }
    else{
        [pickerView setDateViewWithTitle:@"" withMode:UIDatePickerModeDate];
    }
    
    
    [pickerView showPickView:self];
    
    
    //block回调
    __weak typeof (self) wself = self;
    pickerView.block = ^(NSString *selectedStr)
    {
        
        
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        
        NSInteger compareDate = [wself compareDate:selectedStr withDate:dateString];
        
        if (compareDate == -1) {
            //
            [[PublicTool defaultTool] publicToolsHUDStr:@"选择日期不能超过当前日期" controller:wself sleep:1.8];
//            wself.dateStr = nil;
            
            return ;
        }else{
            wself.birthdayStr = selectedStr;
            
        }
        [wself getTextfiledData];
        [wself.editInfoTableView reloadData];
        
    };
    
}


//比较两个日期的大小  日期格式为2016-08-14
-(NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa = 0;
    
    NSComparisonResult result = [aDate compare:bDate];
    
    if (result==NSOrderedSame)
    {
        aa = 0;//相等
    }else if (result==NSOrderedAscending)
    {
        
        aa = 1;//bDate比aDate大
    }else if (result==NSOrderedDescending)
    {
        aa = -1;//bDate比aDate小
    }
    
    return aa;
}

#pragma mark - 图片选择
- (void)imagePicker {
    
    UIImagePickerController * photoAlbum = [[UIImagePickerController alloc]init];
    photoAlbum.delegate = self;
    photoAlbum.allowsEditing = YES;
    photoAlbum.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:photoAlbum animated:YES completion:^{}];
}

//图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage * chooseImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
//    NSData *imageData = UIImageJPEGRepresentation(chooseImage, PHOTO_COMPRESS);
    NSData *imageData = [NSObject imageData:chooseImage];
    
    if ([imageData length] >0) {
        imageData = [GTMBase64 encodeData:imageData];
    }
    NSString *imageStr = [[NSString alloc]initWithData:imageData encoding:NSUTF8StringEncoding];
    
    [self uploadImageWithBase64Str:imageStr];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)uploadImageWithBase64Str:(NSString*)base64Str{
    
    UploadImageApi *uploadApi = [[UploadImageApi alloc]initWithImgStr:base64Str type:@"png"];
    
    [uploadApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSDictionary *dic = request.responseJSONObject;
        NSString *code = [dic objectForKey:@"code"];
        
        if ([code isEqualToString:@"1000"]) {
            
            if (_upLoadPhotoTag==1) {
                self.logoStr = [dic objectForKey:@"imageUrl"];
            }
            else{
                self.wechatQer = [dic objectForKey:@"imageUrl"];
            }
            
            [self.editInfoTableView reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - 根据城市id获取城市地址

-(NSString *)getCityName{
    NSString *pidStr;
    NSString *cidStr;
    NSString *didStr;
    
    
    NSString *finallyStr;
    
    PModel *temppmodel;
    CModel *tempcmodel;
    DModel *tempdmodel;
    
    NSMutableArray *tempPidArray = [NSMutableArray array];
    NSMutableArray *tempCidArray = [NSMutableArray array];
    NSMutableArray *tempDidArray = [NSMutableArray array];
    
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"city_blej_tree" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    if (self.userModel.hometownProvinceId) {
        
        
        
        for (NSDictionary *dict in jsonArr) {
            
            PModel *pmodel = [PModel yy_modelWithJSON:dict];
            [tempPidArray addObject:pmodel];
        }
        
        NSString *tmePStr = [NSString stringWithFormat:@"%f",self.userModel.hometownProvinceId];
        NSString *tmeCStr = [NSString stringWithFormat:@"%f",self.userModel.hometownCityId];
        NSString *tmeDStr = [NSString stringWithFormat:@"%f",self.userModel.hometownCountyId];
        
        for (PModel *pmodel in tempPidArray) {
            if ([pmodel.regionId integerValue]==[tmePStr integerValue]) {
                pidStr = pmodel.name;
                temppmodel = pmodel;
                
                break;
            }
        }
        
        NSInteger regionId = [tmePStr integerValue];
        if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000)//四个直辖市
        {
            //                        cidStr = pidStr;
            NSInteger temInt = [tmeDStr integerValue];
            if (temInt==-1||temInt==0) {
                for (NSDictionary *dict in temppmodel.cities) {
                    
                    CModel *cmodel = [CModel yy_modelWithJSON:dict];
                    [tempCidArray addObject:cmodel];
                }
                
                for (CModel *cmodel in tempCidArray) {
                    if ([cmodel.regionId integerValue]==[tmePStr integerValue]) {
                        cidStr = @"";
                        tempcmodel = cmodel;
                        break;
                    }
                }
                
                for (NSDictionary *dict in tempcmodel.counties) {
                    
                    DModel *dmodel = [DModel yy_modelWithJSON:dict];
                    [tempDidArray addObject:dmodel];
                }
                
                for (DModel *dmodel in tempDidArray) {
                    if ([dmodel.regionId integerValue]==[tmeCStr integerValue]) {
                        didStr = dmodel.name;
                        tempdmodel = dmodel;
                        break;
                    }
                }
            }
            
            else{
                for (NSDictionary *dict in temppmodel.cities) {
                    
                    CModel *cmodel = [CModel yy_modelWithJSON:dict];
                    [tempCidArray addObject:cmodel];
                }
                
                for (CModel *cmodel in tempCidArray) {
                    if ([cmodel.regionId integerValue]==[tmeCStr integerValue]) {
                        cidStr = cmodel.name;
                        tempcmodel = cmodel;
                        
                        break;
                    }
                }
                
                for (NSDictionary *dict in tempcmodel.counties) {
                    
                    DModel *dmodel = [DModel yy_modelWithJSON:dict];
                    [tempDidArray addObject:dmodel];
                }
                
                for (DModel *dmodel in tempDidArray) {
                    if ([dmodel.regionId integerValue]==[tmeDStr integerValue]) {
                        didStr = dmodel.name;
                        tempdmodel = dmodel;
                        break;
                    }
                }
            }
            
            
            
            
        }
        else{
            for (NSDictionary *dict in temppmodel.cities) {
                
                CModel *cmodel = [CModel yy_modelWithJSON:dict];
                [tempCidArray addObject:cmodel];
            }
            
            for (CModel *cmodel in tempCidArray) {
                if ([cmodel.regionId integerValue]==[tmeCStr integerValue]) {
                    cidStr = cmodel.name;
                    tempcmodel = cmodel;
                    
                    break;
                }
            }
            
            for (NSDictionary *dict in tempcmodel.counties) {
                
                DModel *dmodel = [DModel yy_modelWithJSON:dict];
                [tempDidArray addObject:dmodel];
            }
            
            for (DModel *dmodel in tempDidArray) {
                if ([dmodel.regionId integerValue]==[tmeDStr integerValue]) {
                    didStr = dmodel.name;
                    tempdmodel = dmodel;
                    break;
                }
            }
        }
        if (!pidStr) {
            pidStr = @"";
        }
        if (!cidStr) {
            cidStr = @"";
        }
        if (!didStr) {
            didStr = @"";
        }
        finallyStr = [NSString stringWithFormat:@"%@ %@ %@",pidStr,cidStr,didStr];
    }
    else{
        finallyStr = @"";
    }
    return finallyStr;
}

#pragma mark - 所在地设置
-(void)getNative{
    
    __weak EditInfoViewController *weakSelf = self;
    
    self.regionView = [[RegionView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-305, kSCREEN_WIDTH, 305)];
    self.regionView.closeBtn.hidden = NO;
    [self.view addSubview:self.regionView];
    
    self.regionView.selectBlock = ^(NSMutableArray *array){
        [weakSelf.regionView removeFromSuperview];
        [weakSelf getTextfiledData];
        weakSelf.nativeArray = array;
        
        PModel *pmodel = [array objectAtIndex:0];
        CModel *cmodel = [array objectAtIndex:1];
        DModel *dmodel = [array objectAtIndex:2];
        weakSelf.nativeStr = [NSString stringWithFormat:@"%@ %@ %@",pmodel.name,cmodel.name,dmodel.name];
        
        [weakSelf.editInfoTableView reloadData];
        
    };
    
}

#pragma mark - 定位获取地址

- (void)localionButtonAction {
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        
        //定位功能可用
        LocationViewController *locationVC = [[LocationViewController alloc] init];
        NSString *addressStr = self.address.length > 0 ? self.address: @"";
        locationVC.address = addressStr;
        locationVC.longitude = self.longitude;
        locationVC.latitude  = self.lantitude;
        MJWeakSelf;
        locationVC.locationBlock = ^(NSString *addressName, double lantitude, double longitude){
            weakSelf.address = addressName;
            weakSelf.longitude = longitude;
            weakSelf.lantitude = lantitude;
//            weakSelf.AddressTextF.text = addressName;
            [self.editInfoTableView reloadData];
        };
        [self.navigationController pushViewController:locationVC animated:YES];
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        //定位不能用
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"位置不可用"
                                                        message:@"请到 手机设置->爱装修->位置 进行设置"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = 999;
        [alert show];
        
    }
    
    
    
}

#pragma mark - uialertviewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //    if (alertView.tag == 2000) {
    //        if (buttonIndex == 1) {
    //            [self.navigationController popViewControllerAnimated:YES];
    //        }
    //    }
    if (alertView.tag == 999) {
        if (buttonIndex == 1) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        }
    }
}

#pragma mark - 选择完职位
- (void)getJobList:(NSNotification *)sender {
    
    self.shadowView.hidden = YES;
    [self getTextfiledData];
    self.jobDict = sender.userInfo;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.jobDict forKey:JOBDICT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.editInfoTableView reloadData];
}

- (void)back:(UIBarButtonItem*)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认退出编辑?" message:@"退出编辑，不会保存当前修改" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - 完成提交
- (void)finish:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
//    if (self.nativeArray.count == 0) {
//        
//        [[PublicTool defaultTool] publicToolsHUDStr:@"请选择所在地地址" controller:self sleep:1.5];
//        return;
//    }
    
    JobModel *job = [JobModel yy_modelWithJSON:self.jobDict];
    
    self.nameStr = [self.nameStr ew_removeSpacesAndLineBreaks];
    if (self.nameStr.length>0) {
        if (self.nameStr.length>8) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"最多输入8个字符" controller:self sleep:1.5];
            return;
        }
    }
    
    self.address = [self.address ew_removeSpacesAndLineBreaks];
    if (self.address.length>0) {
        if (self.longitude<=0&&self.lantitude<=0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"请在个人地址右方图标处进入选择位置，否则无法保存" controller:self sleep:1.5];
            return;
        }
    }
    
    self.emilStr = [self.emilStr ew_removeSpacesAndLineBreaks];
    if (self.emilStr.length>0) {
        bool isRight = [self.emilStr ew_checkEmail];
        if (!isRight) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"邮箱格式不正确" controller:self sleep:1.5];
            return;
        }
    }

    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    

    
    NSString *temDid = @"";
    if (self.nativeArray.count) {
        NSMutableArray *nativeArray = [self getAddressIdFromArray:self.nativeArray];
        _nPid = [[nativeArray objectAtIndex:0] floatValue];
        _nCid = [[nativeArray objectAtIndex:1] floatValue];
        _nDid = [[nativeArray objectAtIndex:2] floatValue];
        temDid = [NSString stringWithFormat:@"%.0f",_nDid];
        NSInteger regionId = _nPid;
        if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000)//四个直辖市只传省和市
        {
            _nCid = _nDid;
            temDid = @"-1";
        }
    }
    
    else{

        temDid = [NSString stringWithFormat:@"%.0f",_nDid];
        NSInteger regionId = _nPid;
        if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000)//四个直辖市只传省和市
        {
//            _nCid = _nDid;
            temDid = @"-1";
        }
    }
    

    self.nameStr = [self.nameStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.nameStr<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"姓名不能为空" controller:self sleep:1.5];
        return;
    }
//    BOOL nameIsHaveCharct = [self checkeEmojCharacter:self.nameStr];
//    BOOL collegeIsHaveCharct = [self checkeEmojCharacter:self.collegeName];
//    BOOL weixinIsHaveCharct = [self checkeEmojCharacter:self.wechatStr];
//    BOOL emilIsHaveCharct = [self checkeEmojCharacter:self.emilStr];
//    BOOL remarkIsHaveCharct = [self checkeEmojCharacter:self.comment];
//    BOOL introduIsHaveCharct = [self checkeEmojCharacter:self.introStr];
//    BOOL jobIsHaveCharct = [self checkeEmojCharacter:self.companyJob];
#warning 注释原因:bug#4951 个人编辑可以输入特殊字符
//    if (nameIsHaveCharct||collegeIsHaveCharct||remarkIsHaveCharct||weixinIsHaveCharct||jobIsHaveCharct||emilIsHaveCharct||introduIsHaveCharct) {
//        [[PublicTool defaultTool] publicToolsHUDStr:@"不可输入特殊字符" controller:self sleep:1.5];
//        return;
//    }

    

    
    //    微博码
//    BOOL isCorrectW = [[PublicTool defaultTool] publicToolsCheckStrIsWordsWithNumber:wechatCell.ContentTF.text];
//    
//    if (!isCorrectW) {
//        
//        [[PublicTool defaultTool] publicToolsSureAlertInfo:@"请输入正确的微博码" controller:self];
//        
//        return;
//    }
    

    

    
    if (self.logoStr.length<=0) {
        self.logoStr = @"";
    }

    if (self.modelWorkType.jobId.length == 0 && self.userModel.roleTypeId == 0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"职位类别不能为空" controller:self sleep:1.5];
        return;
    }
    
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"agency/updateInfo.do"];
    
    NSInteger temGender = self.gender ? 1 : 0;
    NSInteger temPid = _nPid;
    NSInteger temCid = _nCid;
//    NSInteger temDid = (NSInteger)_aDid;
//    UserInfoModel *user = [[PublicTool defaultTool]  ];
    
    NSString *finalAddress = self.address.length>0?self.address:@"";
    NSString *finallongitude = [NSString stringWithFormat:@"%f",self.longitude];
    NSString *finallantitude = [NSString stringWithFormat:@"%f",self.lantitude];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSString *finallyPid = [NSString stringWithFormat:@"%ld",temPid];
    NSString *finallyCid = [NSString stringWithFormat:@"%ld",temCid];
//    NSString *finallyDid = [NSString stringWithFormat:@"%ld",temPid];
    NSDictionary *paramDic = @{@"agencyId":@(user.agencyId),
                               @"photo":self.logoStr,
                               @"roleTypeId":self.modelWorkType.jobId.length?self.modelWorkType.jobId:@(self.userModel.roleTypeId),
                               @"trueName":self.nameStr.length > 0 ? self.nameStr:@"",
                               @"gender":@(temGender),
                               @"workingDateStr":self.dateStr.length >0 ? self.dateStr : @"1970-01-01",
                           @"comment":self.comment.length > 0 ? self.comment : @"",
                               @"agencyBirthdayStr":self.birthdayStr.length >0 ? self.birthdayStr : @"1970-01-01",
                               @"companyJob":self.companyJob.length >0 ? self.companyJob : @"",
                               @"agencySchool":self.collegeName.length >0 ? self.collegeName : @"",
                               @"hometownProvinceId":finallyPid,
                               @"hometownCityId":finallyCid,
                               
                               @"hometownCountyId":temDid,
                               @"weixin":self.wechatStr.length >0 ? self.wechatStr : @"",
                               @"email":self.emilStr.length>0?self.emilStr:@"",
                               @"indu":self.introStr.length>0?self.introStr:@"",
                               @"wxQrcode":self.wechatQer,
                               @"showPhone":self.showPhone.length>0?self.showPhone:@"0",
                               @"address":finalAddress,
                               @"longitude":finallongitude.length>0?finallongitude:@"",
                               @"latitude":finallantitude.length>0?finallantitude:@""
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        NSLog(@"%@",responseObj);
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"个人资料提交成功" controller:self sleep:1.5];
                //
                NSMutableDictionary *agencyDict = [NSMutableDictionary dictionaryWithDictionary:[[responseObj objectForKey:@"data"] objectForKey:@"agency"]];
            
                NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                [agencyDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    
                    if ([obj isEqual:[NSNull null]]) {
                        obj = @"";
                    }
                    [dictM setObject:obj forKey:key];
                }];
                
                [[NSUserDefaults standardUserDefaults] setObject:dictM forKey:AGENCYDICT];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"personInfoEditSucess" object:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"提交失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:responseObj[@"msg"] controller:self sleep:1.5];
            }
            
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

-(BOOL)checkeEmojCharacter:(NSString *)string{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (NSMutableArray*)getAddressIdFromArray:(NSArray*)array {
    
    NSMutableArray *addArray = [NSMutableArray array];
    
    PModel *pmodel = [array objectAtIndex:0];
    CModel *cmodel = [array objectAtIndex:1];
    DModel *dmodel = [array objectAtIndex:2];
    
    NSString *pStr = pmodel.regionId;
    NSString *cStr = cmodel.regionId;
    NSString *dStr = dmodel.regionId;
    
    [addArray addObject:pStr];
    [addArray addObject:cStr];
    [addArray addObject:dStr];
    
    return addArray;
}

#pragma mark - textfieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    

    if (textField.tag==0) {
        self.nameStr = textField.text;
    }
    else if (textField.tag==3) {
        self.wechatStr = textField.text;
    }
    else if (textField.tag==6) {
        self.address = textField.text;
    }
    else if (textField.tag==7) {
        self.emilStr = textField.text;
    }
    else if (textField.tag==8) {
        self.companyJob = textField.text;
    }
    else if (textField.tag==9) {
        self.collegeName = textField.text;
    }else{
        
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    if (textField.tag==0) {
        self.nameStr = textField.text;
    }
    else if (textField.tag==3) {
        self.wechatStr = textField.text;
    }
    else if (textField.tag==6) {
        self.address = textField.text;
    }
    else if (textField.tag==7) {
        self.emilStr = textField.text;
    }
    else if (textField.tag==8) {
        self.companyJob = textField.text;
    }
    else if (textField.tag==10) {
        self.collegeName = textField.text;
    }else{
        
    }
}

//键盘return键收回键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - textviewDelegate

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.tag==2) {
        
        
        NSIndexPath *intrduIndex = [NSIndexPath indexPathForRow:0 inSection:2];
        RemarkTableViewCell *intrduCell = (RemarkTableViewCell*)[self.editInfoTableView cellForRowAtIndexPath:intrduIndex];
        if (textView.text.length<=0) {
            intrduCell.remarkLabel.hidden = NO;
        }
        else{
            intrduCell.remarkLabel.hidden = YES;
        }
        
        self.comment = textView.text;
        
    }
    if (textView.tag==3) {
        
        NSIndexPath *intrduIndex = [NSIndexPath indexPathForRow:0 inSection:3];
        IntroduTableViewCell *intrduCell = (IntroduTableViewCell*)[self.editInfoTableView cellForRowAtIndexPath:intrduIndex];
        if (textView.text.length<=0) {
            intrduCell.remarkLabel.hidden = NO;
        }
        else{
            intrduCell.remarkLabel.hidden = YES;
        }
        
        self.introStr = textView.text;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.tag==2) {
        
        NSIndexPath *intrduIndex = [NSIndexPath indexPathForRow:0 inSection:2];
        RemarkTableViewCell *intrduCell = (RemarkTableViewCell*)[self.editInfoTableView cellForRowAtIndexPath:intrduIndex];
        //        intrduCell.remarkLabel.hidden = YES;
        
        
        if (textView.text.length<=0) {
            intrduCell.remarkLabel.hidden = NO;
        }
        else{
            intrduCell.remarkLabel.hidden = YES;
        }
        
        self.comment = textView.text;
    }
    if (textView.tag==3) {
        
        NSIndexPath *intrduIndex = [NSIndexPath indexPathForRow:0 inSection:3];
        IntroduTableViewCell *intrduCell = (IntroduTableViewCell*)[self.editInfoTableView cellForRowAtIndexPath:intrduIndex];
        if (textView.text.length<=0) {
            intrduCell.remarkLabel.hidden = NO;
        }
        else{
            intrduCell.remarkLabel.hidden = YES;
        }
        
        self.introStr = textView.text;
    }
}

#pragma mark - kvo回调

// 必须实现这个方法, 这个是用来回调取值的!
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    professionallabelVC *vc1 =(professionallabelVC*)object;
    if ([keyPath isEqualToString:@"infoarray"]) {
        //取出改变后的新值.
        id obj = change[@"new"];
        NSLog(@"obj------%@",obj);
        self.Individualstr = [obj componentsJoinedByString:@","];
        [vc1 removeObserver:self forKeyPath:@"infoarray"];
        [self.editInfoTableView reloadData];
    }
}





#pragma mark - 点击shadowView隐藏职位选择视图
- (void)didClickShadowView:(UITapGestureRecognizer *)tap {
    
    self.shadowView.hidden = YES;
}

- (void)dealloc {
    
    self.returnKeyHandler = nil;
    if (self.shadowView != nil) {
        
        [self.shadowView removeFromSuperview];
        self.shadowView = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
