//
//  MemberViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/3/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "MemberViewController.h"
#import "TitleTableViewCell.h"
#import "EnterTableViewCell.h"
#import "AddressNameTableViewCell.h"
#import "MessageNotiTableViewCell.h"
#import "SiteGroupChatViewController.h"
#import "ConstructionMemberModel.h"
#import "MemberSelectController.h"

#import "ManagerViewController.h"
#import "NewMyPersonCardController.h"
#import "MyConstructionSiteViewController.h"
#import "MainMaterialMemberModel.h"

@interface MemberViewController ()<UITableViewDelegate,UITableViewDataSource,TitleTableViewCellDelegate,UIAlertViewDelegate,chatdelegate>{
    CGFloat _cellH;
    BOOL isShowSucessBtn;
    
    BOOL isEdit;//是否是编辑状态
    NSInteger MeJobId;//当前人在工地的职位id
}

@property (nonatomic, strong) UITableView *memberTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *deleteArray;
@property (nonatomic, strong) UIButton *deleteBtn;

//存放移除人员环信ID
@property(nonatomic,strong)NSMutableArray *huanxinIDArray;

@end

@implementation MemberViewController


-(NSMutableArray *)huanxinIDArray{

    if (_huanxinIDArray == nil) {
        _huanxinIDArray = [NSMutableArray array];
    }
    
    return _huanxinIDArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    self.deleteArray = [NSMutableArray array];
    isEdit = NO;
    [self createUI];
    [self createTableView];
    [self requestJoinList];
    isShowSucessBtn = NO;
}
-(void)createUI{
    self.title = @"参与人员";
    self.view.backgroundColor = Bottom_Color;
    

    //施工日志添加人员
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestJoinList) name:@"AddmemberOfContrution" object:nil];
    
    //主材日志添加人员
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestJoinList) name:@"AddmemberOfMaterial" object:nil];
    
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"确定" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(successDelete) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn = editBtn;
    self.deleteBtn.hidden = YES;
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.deleteBtn];
}

-(void)createTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = Bottom_Color;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:tableView];
    
    [tableView registerNib:[UINib nibWithNibName:@"EnterTableViewCell" bundle:nil] forCellReuseIdentifier:@"EnterTableViewCell"];
    [tableView registerNib:[UINib nibWithNibName:@"AddressNameTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressNameTableViewCell"];
    [tableView registerNib:[UINib nibWithNibName:@"MessageNotiTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageNotiTableViewCell"];
    
    self.memberTableView = tableView;

}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else{
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==2) {
        return 120;
    }
    else{
        return 5;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return _cellH;
    }else if (indexPath.section == 1){
        return 150;
    }else{
        return 44;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==2) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = White_Color;
        
        UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [quitBtn setFrame:CGRectMake(kSCREEN_WIDTH/8, 40, kSCREEN_WIDTH/4*3, 44)];
        [quitBtn setFrame:CGRectMake(8, 40, kSCREEN_WIDTH-16, 44)];
        [quitBtn setTitle:@"退出工地" forState:UIControlStateNormal];
        [quitBtn setTitleColor:White_Color forState:UIControlStateNormal];
        quitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [quitBtn setBackgroundColor:[UIColor redColor]];
        quitBtn.layer.cornerRadius = 5;
        [quitBtn addTarget:self action:@selector(quitContruction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:quitBtn];
        
        return view;
    }
    return [[UITableViewHeaderFooterView alloc]init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   // __weak MemberViewController *weakSelf = self;
    
    if (indexPath.section == 0) {
        
        TitleTableViewCell *cell = [TitleTableViewCell cellWithTableView:tableView ];
        if (self.index==1) {
            cell.isShow = isShowSucessBtn;
            cell.isShowReduceBtn = !isShowSucessBtn;
            
//            bool isLogin = [[PublicTool defaultTool]publicToolsJudgeIsLogined];
            //交工之后，不显示添加和删除按钮
            if (self.isComplete) {
                cell.isShowReduceBtn = NO;
            }
            
            [cell configWith:self.dataArray];
            cell.delegate = self;
            _cellH = cell.cellH;
        }
        else{
            cell.isShow = isShowSucessBtn;
            cell.isShowReduceBtn = !isShowSucessBtn;
            
            //交工之后，不显示添加和删除按钮
            if (self.isComplete) {
                cell.isShowReduceBtn = NO;
            }
            
            bool isLogin = [[PublicTool defaultTool]publicToolsJudgeIsLogined];
            //
            [cell configWith:self.dataArray isLogin:isLogin ccComplete:self.isComplete isExit:YES cJobTypeId:MeJobId];
            cell.delegate = self;
            _cellH = cell.cellH;
            
        }
        return cell;
        
    }else if (indexPath.section == 1){
        
        EnterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EnterTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.delegate = self;
        
        return cell;
      
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 4) {
    
            MessageNotiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageNotiTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"消息免打扰";
            MJWeakSelf;
            cell.switchBlock = ^(BOOL isOn) {
                // 这个方法使屏蔽推送的消息
#if DELETEHUANXIN
                // (@"注释掉环信")
#else
                //(@"打开环信代码")
                EMError *emError;
                emError = [[EMClient sharedClient].groupManager ignoreGroupPush:weakSelf.groupid ignore:isOn];
                if (emError) {
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"群主不能屏蔽消息"];
                }
                // 屏蔽群消息
                if (isOn) {
                    [[EMClient sharedClient].groupManager blockGroup:weakSelf.groupid completion:^(EMGroup *aGroup, EMError *aError) {
                        if (aError) {
                            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"群主不能屏蔽消息"];
                        }
                    }];
                    
                } else {
                    [[EMClient sharedClient].groupManager unblockGroup:weakSelf.groupid completion:^(EMGroup *aGroup, EMError *aError) {
                        if (aError) {
                            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"群主不能屏蔽消息"];
                        }
                    }];
                }
#endif
                
            };
            return cell;
            
        }else{
            
            AddressNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressNameTableViewCell"];
            NSArray *titleArray = @[@"工地名称",@"查找聊天记录",@"聊天文件",@"清空聊天记录"];
            cell.textLabel.text = titleArray[indexPath.row];
            
            // 工地名称
            if (indexPath.row != 0) {
                cell.nameLabel.hidden = YES;
            }else{
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.nameLabel.text = @"";
                UILabel *LogoName = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, kSCREEN_WIDTH-120, 44)];
                LogoName.text = self.socialName;
                LogoName.textColor = COLOR_BLACK_CLASS_9;
                LogoName.font = NB_FONTSEIZ_NOR;
                LogoName.textAlignment = NSTextAlignmentLeft;
                [cell addSubview:LogoName];
            }
            
            return cell;
        }
        
        
    }
    
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        if (indexPath.row == 0 || indexPath.row == 4) {
            return;
        }
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"敬请期待"];
    }
}

#pragma mark - 进入聊天的界面
- (void)enterChat{
    #warning !!!!
    #warning !!!!
    #warning !!!!
#define KHIDDEN 1
//#if DELETEHUANXIN
#if KHIDDEN
    // (@"注释掉环信")
    [[PublicTool defaultTool] publicToolsHUDStr:@"此功能暂缓开通" controller:self sleep:1.0];
#else
    // (@"打开环信代码")
    if (isEdit) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"删除人员未保存" controller:self sleep:1.5];
    }else{
        if (self.groupid.length > 0) {
            //登录环信账号
            BOOL isLoggedIn = [EMClient sharedClient].isLoggedIn;
            if (!isLoggedIn) {
                UserInfoModel *model = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
                EMError *EMerror = [[EMClient  sharedClient]loginWithUsername:model.huanXinId password:model.huanXinPassword];
                if (!EMerror) {
                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                }
            }
            EMGroup *group = [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:self.groupid error:nil];
            SiteGroupChatViewController *message = [[SiteGroupChatViewController alloc] initWithConversationChatter:self.groupid conversationType:EMConversationTypeGroupChat];
            message.chatTitle = group.subject;
            message.deleteConversationIfNull = false;
            [self.navigationController pushViewController:message animated:YES];
        }else{
            // 没有创建群组， 创建群组拉经理进入公司
            NSString *groupID = [self creatGroup:self.socialName];
            [self uploadHuanXinID:groupID];
            if (groupID.integerValue > 0) {
                self.groupid = groupID;
                NSMutableArray *peopleHXIDarray = [NSMutableArray array];
                for (ConstructionMemberModel *model in self.dataArray) {
                    [peopleHXIDarray addObject:model.huanXinId?:@""];
                }
                EMError *error = nil;
                // 添加人员
                EMGroup *group = [[EMClient sharedClient].groupManager  addOccupants:peopleHXIDarray  toGroup:groupID welcomeMessage:nil error:&error];
                if (error) {
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"人员未添加到群组， 暂时不能聊天"];
                    return;
                } else {
                    // 进入群聊天
                    SiteGroupChatViewController  *message = [[SiteGroupChatViewController alloc]initWithConversationChatter:groupID conversationType:EMConversationTypeGroupChat];
                    message.chatTitle = group.subject;
                    message.deleteConversationIfNull = false;
                    [self.navigationController pushViewController:message animated:YES];
                }
            } else {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"还没有创建群组， 暂时不能聊天"];
                return;
            }
            
        }
    }
#endif
}

#pragma mark -  创建群组
#if DELETEHUANXIN
// (@"注释掉环信")

#else
// (@"打开环信代码")
- (NSString *)creatGroup:(NSString *)title{
    EMGroupOptions *setting = [[EMGroupOptions alloc]init];
    //设置群组的人员最大数量
    setting.maxUsersCount = 500;
    
    //设置群组的类型
    setting.style = EMGroupStylePrivateMemberCanInvite;
    
    setting.IsInviteNeedConfirm = NO;
    
    EMError *error = nil;
    
    //群组的名称为小区的名称
    BOOL isLoggedIn = [EMClient sharedClient].isLoggedIn;
    if (!isLoggedIn) {
        UserInfoModel *model = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
        EMError *EMerror = [[EMClient  sharedClient]loginWithUsername:model.huanXinId password:model.huanXinPassword];
        if (!EMerror) {
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        }
    }
    
    EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:title description:nil invitees:nil message:nil setting:setting error:&error];
    
    if (!error) {
        return  group.groupId;
    }else{
        return @"";
    }
    
    return 0;
}
#endif

#pragma mark - 和后台同步环信群ID
- (void)uploadHuanXinID:(NSString *)huanxinID {
    
    NSString *constructionID = [NSString stringWithFormat:@"%ld", self.consID];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *agencyID = [NSString stringWithFormat:@"%ld", user.agencyId];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/bindNewGroup.do"];
    NSDictionary *paramDic = @{@"constructionId": constructionID,
                               @"agencyId": agencyID,
                               @"chatGroupId":huanxinID
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        if ((NSInteger)responseObj[@"code"] == 1000) {
 
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}
#pragma mark - 退出工地
-(void)quitContruction{
//    if (self.isComplete) {
//        return;
//    }
    
    if (isEdit) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"删除人员未保存" controller:self sleep:1.5];
        return;
    }
    //UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    //判断当前人是否时经理，总经理，以上人员退出时，需要判断权限（还有店面经理）
    //否则直接退出
    
    if (MeJobId==1002||MeJobId==1003||MeJobId==1027) {
        //当前剩余的人数中，必须有经理（店面经理）或总经理才可以退出工地
        
        NSMutableArray *temArray = [NSMutableArray array];
        
        for (ConstructionMemberModel *model in self.dataArray) {
            NSInteger jobId = [model.cpLimitsId integerValue];
            if (jobId==1002||jobId==1003||jobId==1027) {
                [temArray addObject:model];
            }
        }
        
        if (temArray.count<=0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"请再添加一个经理或总经理后退出" controller:self sleep:1.5];
            return;
        }
        BOOL isHave = NO;
        for (ConstructionMemberModel *model in temArray) {
            if ([model.cJobTypeId integerValue]==1002||[model.cJobTypeId integerValue]==1003||[model.cJobTypeId integerValue]==1027||[model.cJobTypeId integerValue]) {
                isHave = YES;
                break;
            }
            else{
                isHave = NO;
            }
        }
        
        if (!isHave) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"请再添加一个经理或总经理后退出" controller:self sleep:1.5];
            return;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"确定要退出该工地吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"确定要退出该工地吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        [alert show];
    }
    
    
}

#pragma mark - 删除工人
-(void)successDelete{
    
    NSString *jsonStr = @"";
    if (self.deleteArray.count<=0) {
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.deleteArray options:NSJSONWritingPrettyPrinted error:nil];
//        jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        isEdit = NO;
        isShowSucessBtn = NO;
        self.deleteBtn.hidden = YES;
        [self.memberTableView reloadData];
        [self.deleteArray removeAllObjects];

    }else{
        //[{"id":"2589","rongUserId":"88e1890f-b6bf-498e-90db-05ed57f377e8"},{"id":"2585","rongUserId":"010161"}]
        NSMutableArray *temArray = [NSMutableArray array];
        for (ConstructionMemberModel *model in self.deleteArray) {
            NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
            
            [addDict setObject:model.id forKey:@"id"];
//            [addDict setObject:model.rongUserId forKey:@"rongUserId"];
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
            [self.view hiddleHud];
            
            YSNLog(@"%@",responseObj);
            if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
                
                NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
                
                switch (statusCode) {
                    case 10000:
                        
                    {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"删除成功" controller:self sleep:
                         1.5];
                        
                        
#if DELETEHUANXIN
                        // (@"注释掉环信")
                        
#else
                        // 移除工地的人同时在群组中删除
                        // 判断是否登录状态， 非登录状态登录
                        BOOL isLoggedIn = [EMClient sharedClient].isLoggedIn;
                        if (!isLoggedIn) {
                            UserInfoModel *model = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
                            EMError *EMerror = [[EMClient  sharedClient]loginWithUsername:model.huanXinId password:model.huanXinPassword];
                            if (!EMerror) {
                                [[EMClient sharedClient].options setIsAutoLogin:YES];
                            }
                        }
                        EMError *error = nil;
                        
                        [[EMClient sharedClient].groupManager removeOccupants:self.huanxinIDArray fromGroup:self.groupid error:&error];
                        
                        YSNLog(@"把人员从聊天群删除  %@", error);
                        
#endif
                        
                        
                        isEdit = NO;
                        isShowSucessBtn = NO;
                        self.deleteBtn.hidden = YES;
                        [self.memberTableView reloadData];
                        [self.deleteArray removeAllObjects];
                    }
                        ////                    NSDictionary *dic = [NSDictionary ]
                        break;
                        
                    case 10001:
                        
                    {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1.5];
                    }
                        ////                    NSDictionary *dic = [NSDictionary ]
                        break;
                        
                    default:
                        break;
                }
            }
            //        NSLog(@"%@",responseObj);
        } failed:^(NSString *errorMsg) {
            [self.view hiddleHud];
            [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        }];
    }
}


#pragma mark - TitleTableViewCellDelegate

-(void)addPeople{
    if (self.isComplete) {
        return;
    }
    MemberSelectController *vc = [[MemberSelectController alloc]init];
    vc.consID = self.consID;
    vc.index = self.index;
    
    
    vc.groupid = self.groupid;
    vc.companyFlag = self.companyFlag;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)reducePeople{
    if (self.isComplete) {
        return;
    }
    isShowSucessBtn = YES;
    isEdit = YES;
    self.deleteBtn.hidden = NO;
    [self.memberTableView reloadData];
}

-(void)deleteWith:(NSInteger)tag{
    if (self.isComplete) {
        return;
    }
    ConstructionMemberModel *model = self.dataArray[tag];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"participant/delOperatingAuthority.do"];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID),
                               @"userId":@(user.agencyId),
                               @"nodeNumber":@(3002),
                               @"participanId":model.cJobTypeId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 10000:
                    
                {
                    [self.dataArray removeObject:model];
                    [self.deleteArray addObject:model];
                    
                    //从群组中移除
                    [self.huanxinIDArray addObject:model.huanXinId];
                    [self.memberTableView reloadData];
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                case 10001:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"你没有操作权限" controller:self sleep:1.5];
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                default:
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)lookDetailInfo:(NSInteger)tag{
    
    if (isEdit) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"删除人员未保存" controller:self sleep:1.5];
        return;
    }
    
    ConstructionMemberModel *model = self.dataArray[tag];
    NewMyPersonCardController *vc = [[NewMyPersonCardController alloc]init];
    vc.agencyId = model.cpPersonId;
//    vc.fromIndex = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - alertviewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSMutableArray *tempersonArray = [NSMutableArray array];
        for (ConstructionMemberModel *model in self.dataArray) {
            NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
            if ([model.cpPersonId integerValue]==user.agencyId) {
                [addDict setObject:model.id forKey:@"id"];
//                [addDict setObject:model.rongUserId forKey:@"rongUserId"];
                [tempersonArray addObject:addDict];
            }
            
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tempersonArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString  *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSString *defaultApi = [BASEURL stringByAppendingString:@"participant/deleteById.do"];
        NSDictionary *paramDic = @{@"persionId":jsonStr
                                   };
        [self.view hudShow];
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
            [self.view hiddleHud];
            if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
                
                NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
                
                switch (statusCode) {
                    case 10000:
                        
                    {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"退出成功" controller:self sleep:2];
                        
#if DELETEHUANXIN
                        // (@"注释掉环信")
#else
                        //(@"打开环信代码")
                        //退出群组
                        UserInfoModel *model = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
                        BOOL isLoggedIn = [EMClient sharedClient].isLoggedIn;
                        if (!isLoggedIn) {
                            EMError *EMerror = [[EMClient  sharedClient]loginWithUsername:model.huanXinId password:model.huanXinPassword];
                            if (!EMerror) {
                                [[EMClient sharedClient].options setIsAutoLogin:YES];
                            }
                        }
                        //退出群组
                        EMError *error = nil;
                        [[EMClient sharedClient].groupManager  leaveGroup:self.groupid error:&error];
#endif

                        
                        //退出工地
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"QuitContructList" object:nil];
                        for (UIViewController *vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[ManagerViewController class]]||[vc isKindOfClass:[MyConstructionSiteViewController class]]) {
                                [self.navigationController popToViewController:vc animated:YES];
                            }
                        }
                    }
                        ////                    NSDictionary *dic = [NSDictionary ]
                        break;
                        
                    default:
                        [[PublicTool defaultTool] publicToolsHUDStr:@"退出失败" controller:self sleep:2];
                        break;
                }
                
                
                
                
                
            }
            
            //        NSLog(@"%@",responseObj);
        } failed:^(NSString *errorMsg) {
            [self.view hiddleHud];
            [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        }];
    }
}

#pragma mark - 查询参与人员列表

-(void)requestJoinList{
    [self.dataArray removeAllObjects];
    [self.view hudShow];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"participant/getParticipantList.do"];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID),
                               @"pageSize":@(100),
                               @"page":@(0)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        
        YSNLog(@"%@",responseObj);
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 10000:
                    
                {
                    NSArray *array = responseObj[@"pageBean"][@"recordList"];
                    [self.dataArray removeAllObjects];
                    if (self.index==1) {
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[ConstructionMemberModel class] json:array];
                        [self.dataArray addObjectsFromArray:arr];
                        
                        for (ConstructionMemberModel *model in self.dataArray) {
                            if ([model.cpPersonId integerValue]==user.agencyId) {
                                MeJobId = [model.cJobTypeId integerValue];
                                break;
                            }
                        }
                    }
                    else{
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[MainMaterialMemberModel class] json:array];
                        [self.dataArray addObjectsFromArray:arr];
                        
                        for (MainMaterialMemberModel *model in self.dataArray) {
                            if ([model.cpPersonId integerValue]==user.agencyId) {
                                MeJobId = [model.cJobTypeId integerValue];
                                break;
                            }
                        }
                    }
                    
                    
                }
                    break;
                    
                default:
                    break;
                    
            }
            
            
            
            [self.memberTableView reloadData];
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}
@end
