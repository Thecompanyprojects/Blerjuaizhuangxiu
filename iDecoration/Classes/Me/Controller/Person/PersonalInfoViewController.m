//
//  PersonalInfoViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "LogoAndNameTableViewCell.h"
#import "PersonalInfoTableViewCell.h"
#import "RemarkTableViewCell.h"
#import "EditInfoViewController.h"
#import "ZCHMyPersonCardController.h"

#import "PModel.h"
#import "CModel.h"
#import "DModel.h"
#import "SiteGroupChatViewController.h"

#import "NewMyPersonCardController.h"
#import "PersonCoverController.h"


@interface PersonalInfoViewController ()<UITableViewDelegate,UITableViewDataSource,LogoAndNameTableViewCellDelegate>{
    CGFloat remarkViewH;
    
    CGFloat introduViewH;
}

@property (nonatomic, strong) UITableView *personTableView;
@property (nonatomic, strong) UserInfoModel *userModel;
@property (copy, nonatomic) NSString *companyName;
//@property (nonatomic, strong) NSMutableDictionary *userDict;//个人资料的字典（登录接口和编辑个人资料返回的）

@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    [self createUI];
    [self createTableView];
    [self getCompanyName];
}

- (void)getCompanyName {
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSInteger agencyId = 0;
    if (self.fromIndex == 0) {
        agencyId = user.agencyId;
    }
    else{
        agencyId = self.agenceyId;
    }
    
    NSString *requestString = [BASEURL stringByAppendingString:@"agency/getCompanyByAgencyId.do"];
    NSDictionary *dic = @{@"agencyId":@(agencyId)
                          };
    [NetManager afPostRequest:requestString parms:dic finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            self.companyName = responseObj[@"companyName"];
        }
        [self.personTableView reloadData];
    } failed:^(NSString *errorMsg) {
        YSNLog(@"%@",errorMsg);
    }];
}


- (void)createUI {
    
    self.title = @"个人资料";
    self.view.backgroundColor = White_Color;
    
    if (self.fromIndex == 0) {
        // 设置导航栏最右侧的按钮
        UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        editBtn.frame = CGRectMake(0, 0, 44, 44);
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        [editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getJob:) name:@"jobNoti" object:nil];
    }
    
    else{
        //查看别人资料
        [self lookOtherInfo];
    }


}

- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = White_Color;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 10)];
    tableView.backgroundColor = kBackgroundColor;
    [self.view addSubview:tableView];
    self.personTableView = tableView;
    
    [self.personTableView registerNib:[UINib nibWithNibName:@"LogoAndNameTableViewCell" bundle:nil] forCellReuseIdentifier:@"LogoAndNameTableViewCell"];
    
    [self.personTableView registerNib:[UINib nibWithNibName:@"PersonalInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonalInfoTableViewCell"];
    
    [self.personTableView registerNib:[UINib nibWithNibName:@"RemarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"RemarkTableViewCell"];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    }
//    else if ((section == 1 && self.fromIndex == 1 && [self.userModel.isCard integerValue] != 0) || (section == 1 && self.fromIndex == 0)) {
//
//        return 9;
//    }
    else if (section == 1) {
        
        return 9;
    } else {
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section==2) {
        if (self.fromIndex==1) {
            bool isLogin = [[PublicTool defaultTool]publicToolsJudgeIsLogined];
            if (!isLogin) {
                return 0.0000000000000001;
            }
            else{
                return 60;
            }
            
        }
        else{
            return 0.0000000000000001;
        }
    }
    return 0.0000000000000001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //获取用户信息
    UserInfoModel  *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    if (section==2) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 60)];
        UIButton *sendMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendMessageBtn.frame = CGRectMake(8, 15, kSCREEN_WIDTH-16, 44);
        [sendMessageBtn setTitle:@"发送消息" forState:UIControlStateNormal];
        sendMessageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [sendMessageBtn setTitleColor:White_Color forState:UIControlStateNormal];
        sendMessageBtn.backgroundColor = Main_Color;
        sendMessageBtn.titleLabel.font = NB_FONTSEIZ_BIG;
        sendMessageBtn.layer.masksToBounds = YES;
        sendMessageBtn.layer.cornerRadius = 5;
        //进入单聊的界面
        [sendMessageBtn addTarget:self action:@selector(peopleChat) forControlEvents:UIControlEventTouchUpInside];
//        _addBtn.layer.borderWidth = 1.0;
//        _addBtn.layer.borderColor = COLOR_BLACK_CLASS_9.CGColor;
        //            _addressBtn.backgroundColor = Red_Color;
        //                [_addressBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
        
        bool isLogin = [[PublicTool defaultTool]publicToolsJudgeIsLogined];
        if (!isLogin) {
            sendMessageBtn.hidden = YES;
        }
        else{
            sendMessageBtn.hidden = NO;
        }
        
        //如果点击的是自己的头像 则无发送消息的按钮
        if (self.fromIndex==1  && ![self.userModel.huanXinId isEqualToString:userModel.huanXinId]) {
            [view addSubview:sendMessageBtn];
        }
        
        return view;
    }
    
    return [[UITableViewHeaderFooterView alloc]init];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 80;
    } else if (indexPath.section == 1) {
        
        return 44;
    } else if (indexPath.section == 2) {
        
        return 56.5+remarkViewH;
    }
    else{
        return 56.5+introduViewH;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        LogoAndNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogoAndNameTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userLogo = self.userModel.photo;
        cell.userName = self.userModel.trueName;
        cell.gender = self.userModel.gender;
        cell.delegate = self;
        
        return cell;
        
    }else if (indexPath.section == 1){
        
        NSString *tempPhoneStr = @"";
        
        if (self.userModel.phone&&self.userModel.phone.length>0) {
            tempPhoneStr = self.userModel.phone;
            if (self.fromIndex == 1){
                tempPhoneStr = [tempPhoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }
            
        }
        else{
            tempPhoneStr = @"";
        }
        
        
        NSString *tempwechatStr = @"";
        if (self.userModel.weixin&&self.userModel.weixin.length>0) {
            tempwechatStr = self.userModel.weixin;
            if (self.fromIndex == 1){
                NSInteger lenth = tempwechatStr.length;
                NSString *temStar=@"";
                for (int i=0; i<lenth-2; i++) {
                    temStar = [temStar stringByAppendingString:@"*"];
                }
                tempwechatStr = [tempwechatStr stringByReplacingCharactersInRange:NSMakeRange(1, lenth-2) withString:temStar];
                
                
                
            }
        }
        else{
            tempwechatStr = @"";
        }
        
        PersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalInfoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        // 禁用个人名片  打开时换掉下面的if语句即可
//        if ((self.fromIndex == 1 && [self.userModel.isCard integerValue] != 0) || (self.fromIndex == 0)) {
        
        NSInteger flag = 0;
        if (flag) {
            switch (indexPath.row) {
                case 0:
                {
                    cell.titleLabel.text = @"名片";
                    cell.contentLabel.text = @"点击查看名片";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                }
                    break;
                    
                case 1:
                {
                    cell.titleLabel.text = @"年龄";
                    if (self.userModel.agencyBirthday==0) {
                        cell.contentLabel.text = @"";
                    }
                    else{
                        NSString *dateStr = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:[NSString stringWithFormat:@"%ld", self.userModel.agencyBirthday]];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        NSDate *currentDate = [NSDate date];//获取当前时间，日期
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        NSString *dateString = [dateFormatter stringFromDate:currentDate];
                        NSArray *nowTimeArr = [dateString componentsSeparatedByString:@"-"];
                        NSArray *birthArr = [dateStr componentsSeparatedByString:@"-"];
                        NSInteger age = [nowTimeArr[0] integerValue] - [birthArr[0] integerValue];
                        if ([nowTimeArr[1] integerValue] == [birthArr[1] integerValue]) {
                            
                            if ([nowTimeArr[2] integerValue] < [birthArr[2] integerValue]) {
                                
                                age = age - 1;
                            }
                        }
                        if ([nowTimeArr[1] integerValue] < [birthArr[1] integerValue]) {
                            
                            age = age - 1;
                        }
                        cell.contentLabel.text = [NSString stringWithFormat:@"%ld", age];
                    }
                    
                }
                    break;
                    
                case 2:
                    cell.titleLabel.text = @"手机号";
                    cell.contentLabel.text = tempPhoneStr;
                    
                    
                    break;
                    
                case 3:
                    cell.titleLabel.text = @"微信";
                    cell.contentLabel.text = tempwechatStr;
                    break;
                    
                case 4:
                    //                cell.titleLabel.text = @"籍贯";
                    cell.titleLabel.text = @"所在地";
                    cell.contentLabel.text = self.userModel.homeTownName;
                    
                    //                cell.titleLabel.text = @"所在地";
                    //                cell.contentLabel.text = self.userModel.addressStr;
                    break;
                    
                case 5:
                    cell.titleLabel.text = @"公司名称";
                    cell.contentLabel.text = self.companyName;
                    break;
                    
                case 6:
                    cell.titleLabel.text = @"公司职位";
                    cell.contentLabel.text = self.userModel.companyJob;
                    break;
                    
                case 7:
                    cell.titleLabel.text = @"毕业院校";
                    cell.contentLabel.text = self.userModel.agencySchool;
                    break;
                case 8:
                {
                    cell.titleLabel.text = @"从业时间";
                    if (self.userModel.workingDate==0) {
                        cell.contentLabel.text = @"";
                    }
                    else{
                        NSString *dateStr = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:[NSString stringWithFormat:@"%ld", self.userModel.workingDate]];
                        cell.contentLabel.text = dateStr;
                    }
                    
                }
                    break;
                default:
                    break;
            }
            return cell;
        } else {
//            UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
            NSString *cityNameStr = [self getCityName];
            switch (indexPath.row) {
                    
                case 0:
                {
                    cell.titleLabel.text = @"年龄";
                    if (self.userModel.agencyBirthday==0) {
                        cell.contentLabel.text = @"";
                    }
                    else{
                        NSString *dateStr = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:[NSString stringWithFormat:@"%ld", self.userModel.agencyBirthday]];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        NSDate *currentDate = [NSDate date];//获取当前时间，日期
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        NSString *dateString = [dateFormatter stringFromDate:currentDate];
                        NSArray *nowTimeArr = [dateString componentsSeparatedByString:@"-"];
                        NSArray *birthArr = [dateStr componentsSeparatedByString:@"-"];
                        NSInteger age = [nowTimeArr[0] integerValue] - [birthArr[0] integerValue];
                        if ([nowTimeArr[1] integerValue] == [birthArr[1] integerValue]) {
                            
                            if ([nowTimeArr[2] integerValue] < [birthArr[2] integerValue]) {
                                
                                age = age - 1;
                            }
                        }
                        if ([nowTimeArr[1] integerValue] < [birthArr[1] integerValue]) {
                            
                            age = age - 1;
                        }
                        cell.contentLabel.text = [NSString stringWithFormat:@"%ld", age];
                    }
                    
                }
                    break;
                    
                case 1:
                    cell.titleLabel.text = @"手机号";
                    cell.contentLabel.text = tempPhoneStr;
                    
                    
                    break;
                    
                case 2:
                    cell.titleLabel.text = @"微信";
                    cell.contentLabel.text = tempwechatStr;
                    break;
                    
                case 3:
                    //                cell.titleLabel.text = @"籍贯";
                    cell.titleLabel.text = @"所在地";
                    
                    cell.contentLabel.text = cityNameStr;
                    
                    //                cell.titleLabel.text = @"所在地";
                    //                cell.contentLabel.text = self.userModel.addressStr;
                    break;
                    
                case 4:
//                    cell.titleLabel.text = @"公司名称";
//                    cell.contentLabel.text = self.companyName;
                    
//                    NSMutableDictionary *mudict = [NSMutableDictionary dict];
//                    mudict = [[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT];
                    
                    cell.titleLabel.text = @"邮箱";
                    cell.contentLabel.text = self.userModel.email;
                    break;
                    
                case 5:
                    cell.titleLabel.text = @"公司职位";
                    cell.contentLabel.text = self.userModel.companyJob;
                    break;
                    
                case 6://职业类别
                    cell.titleLabel.text = @"职业类别";
                    cell.contentLabel.text = self.userModel.roleType;
                    break;
//                case 7://个人标签
//                    cell.titleLabel.text = @"个人标签";
//                    // cell.contentLabel.text = self.userModel.companyJob;
//                    break;
                case 7:
                    cell.titleLabel.text = @"毕业院校";
                    cell.contentLabel.text = self.userModel.agencySchool;
                    break;
                case 8:
                {
                    cell.titleLabel.text = @"从业时间";
                    if (self.userModel.workingDate==0) {
                        cell.contentLabel.text = @"";
                    }
                    else{
                        NSString *dateStr = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:[NSString stringWithFormat:@"%ld", self.userModel.workingDate]];
                        cell.contentLabel.text = dateStr;
                    }
                }
                    break;
                default:
                    break;
            }
            
            return cell;
        }
    }
    else if(indexPath.section==2){
        RemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemarkTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"人生格言";
        cell.remarkTextView.editable = NO;
        cell.remarkTextView.text = self.userModel.comment;
        
        CGSize size = [self.userModel.comment boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-12*2, MAXFLOAT) withFont:NB_FONTSEIZ_NOR];
        if (size.height<=83.5) {
            size.height=83.5;
        }
        remarkViewH = size.height+20;
        cell.remarkConH.constant = remarkViewH;
        cell.remarkTextView.scrollEnabled = NO;
        return cell;
    }
    else {
        
        RemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemarkTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"个人简介";
        cell.remarkTextView.editable = NO;
        cell.remarkTextView.text = self.userModel.indu;
        
        CGSize size = [self.userModel.indu boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-12*2, MAXFLOAT) withFont:NB_FONTSEIZ_NOR];
        if (size.height<=83.5) {
            size.height=83.5;
        }
        introduViewH = size.height+20;
        cell.remarkConH.constant = introduViewH;
        cell.remarkTextView.scrollEnabled = NO;
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    // 禁用个人名片
    if (indexPath.section == 1 && indexPath.row == 0) {
        ZCHMyPersonCardController *VC = [[ZCHMyPersonCardController alloc] init];
        VC.isMe = (self.fromIndex == 0 ? YES : NO);
        if (self.fromIndex == 0) {
            NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
            if (!agencyid||agencyid == 0) {
                agencyid = 0;
            }
            VC.agencyId = [NSString stringWithFormat:@"%ld", agencyid];
        } else {
            
            VC.agencyId = [NSString stringWithFormat:@"%ld", self.agenceyId];
        }
        
        [self.navigationController pushViewController:VC animated:YES];
    }
     */
}


- (void)edit:(UIBarButtonItem*)sender {
    
    EditInfoViewController *editVC = [[EditInfoViewController alloc]init];
    editVC.userModel = self.userModel;
    [self.navigationController pushViewController:editVC animated:YES];
    
}

#pragma mark - LogoAndNameTableViewCellDelegate

//上传封面音乐
-(void)toModifyCover{
    PersonCoverController *vc = [[PersonCoverController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//查看个人名片
-(void)toLookPersonCard{
    NewMyPersonCardController *vc = [[NewMyPersonCardController alloc]init];
    vc.agencyId = [NSString stringWithFormat:@"%ld",self.userModel.agencyId];
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - 查看别人资料
- (void)lookOtherInfo {
    
    [self.view hudShow];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"agency/getAgencyById.do"];
    NSDictionary *paramDic = @{@"agencyId":@(self.agenceyId)
                               };
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            YSNLog(@"%@",responseObj);
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    NSDictionary *agencyDict = responseObj[@"agency"];
                    self.userModel = [UserInfoModel yy_modelWithJSON:agencyDict];
                    self.userModel.homeTownName = @"";
                    
                    NSString *pidStr;
                    NSString *cidStr;
                    NSString *didStr;
                    
                    PModel *temppmodel;
                    CModel *tempcmodel;
                    DModel *tempdmodel;
                    
                    NSMutableArray *tempPidArray = [NSMutableArray array];
                    NSMutableArray *tempCidArray = [NSMutableArray array];
                    NSMutableArray *tempDidArray = [NSMutableArray array];
                    
                    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"city_blej_tree" ofType:@"json"];
                    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
                    NSMutableArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                    if (self.userModel.hometownCityId) {
                        
                        
                        
                        for (NSDictionary *dict in jsonArr) {
                            
                            PModel *pmodel = [PModel yy_modelWithJSON:dict];
                            [tempPidArray addObject:pmodel];
                        }
                        
                        for (PModel *pmodel in tempPidArray) {
                            if ([pmodel.regionId integerValue]==(NSInteger)self.userModel.hometownProvinceId) {
                                pidStr = pmodel.name;
                                temppmodel = pmodel;
                                
                                break;
                            }
                        }
                        
                        CGFloat regionId = self.userModel.hometownProvinceId;
                        if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000)//四个直辖市
                        {
                            //                        cidStr = pidStr;
                            NSInteger temInt = (NSInteger)self.userModel.hometownCountyId;
                            if (temInt==-1||temInt==0) {
                                for (NSDictionary *dict in temppmodel.cities) {
                                    
                                    CModel *cmodel = [CModel yy_modelWithJSON:dict];
                                    [tempCidArray addObject:cmodel];
                                }
                                
                                for (CModel *cmodel in tempCidArray) {
                                    if ([cmodel.regionId integerValue]==(NSInteger)self.userModel.hometownProvinceId) {
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
                                    if ([dmodel.regionId integerValue]==(NSInteger)self.userModel.hometownCityId) {
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
                                    if ([cmodel.regionId integerValue]==(NSInteger)self.userModel.hometownCityId) {
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
                                    if ([dmodel.regionId integerValue]==(NSInteger)self.userModel.hometownCountyId) {
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
                                if ([cmodel.regionId integerValue]==(NSInteger)self.userModel.hometownCityId) {
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
                                if ([dmodel.regionId integerValue]==(NSInteger)self.userModel.hometownCountyId) {
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
                        self.userModel.homeTownName = [NSString stringWithFormat:@"%@ %@ %@",pidStr,cidStr,didStr];
                        
                    }
                    
                    
                    [self.personTableView reloadData];
                }
                    
                default:
//                    [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

-(void)getJob:(NSNotificationCenter*)sender{
            
    [self.personTableView reloadData];
    
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//从json文件得到地址列表
//-(void)getRegionList{
//    
//    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"city_blej_tree" ofType:@"json"];
//    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
//    NSMutableArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//    
//    for (NSDictionary *dict in jsonArr) {
//        
//        PModel *pmodel = [PModel yy_modelWithJSON:dict];
//        if (![self.firstArray containsObject:pmodel]) {
//            [self.firstArray addObject:pmodel];
//        }
//    }
//    
//    [self getBJList];
//}

//-(void)getBJList{
//    
//    PModel *BJModel = [self.firstArray firstObject];
//    
//    [self.secondArray removeAllObjects];
//    for (NSDictionary *dict in BJModel.cities) {
//        
//        CModel *cmodel = [CModel yy_modelWithJSON:dict];
//        
//        if (![self.secondArray containsObject:cmodel]) {
//            [self.secondArray addObject:cmodel];
//        }
//    }
//    
//    [self getBJDistrict];
//}
//
//-(void)getBJDistrict{
//    
//    CModel *cmodel = [self.secondArray firstObject];
//    
//    [self.thirdArray removeAllObjects];
//    
//    for (NSDictionary *dict in cmodel.counties) {
//        
//        DModel *dmodel = [DModel yy_modelWithJSON:dict];
//        
//        if (![self.thirdArray containsObject:dmodel]) {
//            [self.thirdArray addObject:dmodel];
//        }
//    }
//    
//    [self.pickerView reloadAllComponents];
//}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.fromIndex == 0) {
        self.userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        [self.personTableView reloadData];
    }
    
    

}


#pragma mark  发送消息  单聊
-(void)peopleChat{
    
    
#if DELETEHUANXIN
    // (@"注释掉环信")
    [[PublicTool defaultTool] publicToolsHUDStr:@"该功能暂缓开通" controller:self sleep:1.0];
#else
    // (@"打开环信代码")
    BOOL isLoggedIn = [EMClient sharedClient].isLoggedIn;
    if (!isLoggedIn) {
        UserInfoModel *model = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
        EMError *EMerror = [[EMClient  sharedClient]loginWithUsername:model.huanXinId password:model.huanXinPassword];
        
        if (!EMerror) {
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        }
    }
    
    
    SiteGroupChatViewController *chat = [[SiteGroupChatViewController alloc]initWithConversationChatter:self.userModel.huanXinId conversationType:EMConversationTypeChat];
    
    chat.chatTitle = self.userModel.trueName;
    [self.navigationController pushViewController:chat animated:YES];
    
#endif
    

}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
