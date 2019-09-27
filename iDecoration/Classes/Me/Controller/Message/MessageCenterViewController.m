//
//  MessageCenterViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "MessageCenterViewController.h"

#import "NeedDecorationViewController.h"
#import "SystemMessageViewController.h"
#import "RemindViewController.h"
#import "CompanyApplyViewController.h" 
#import "CalculateViewController.h"
#import "SNNavigationController.h"
#import "MeViewController.h"
#import <JPUSHService.h>
#import "ZCHCooperateMesController.h"
#import "UnionInviteMessageController.h"

#import "ActivityMessageViewController.h"
#import "ZCHUnionApplyMsgController.h"

@interface MessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
    [self createTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMessageNum) name:klognOutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMessageNum) name:kOutCompany object:nil];
    // 收到聊天消息 跟新消息数量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageNumData) name:kHXUpdateMessageNumberWhenRevievedMessage object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createUI{
    self.title = @"消息中心";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
//    [self getMessageNumData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getMessageNumData];
}

- (void)remakeLbael:(UILabel *)label {
    if ([label.text isEqualToString:@"99+"] || label.text.integerValue > 9) {
        CGSize size = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) withFont:[UIFont systemFontOfSize:13]];
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-24);
            make.size.mas_equalTo(CGSizeMake(size.width + 10, 20));
        }];
    }
    else {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-24);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
}

#pragma mark - 获取消息数量
- (void)getMessageNumData {
    
    
    if ([[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        UILabel *label = nil;
        NSIndexPath *indexPath = nil;
        UITableViewCell *cell = nil;
        
        __block NSInteger totalUnreadCount = 0;
        
#if DELETEHUANXIN
        // (@"注释掉环信")
#else
        // (@"打开环信代码")
        // 如果环信没有登录那么登录环信
        // 聊天消息
        BOOL isLoggedIn = [EMClient sharedClient].isLoggedIn;
        if (!isLoggedIn) {
            UserInfoModel *model = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
            EMError *EMerror = [[EMClient  sharedClient]loginWithUsername:model.huanXinId password:model.huanXinPassword];
            if (!EMerror) {
                [[EMClient sharedClient].options setIsAutoLogin:YES];
            }
        }
        NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
        for (EMConversation *conversation in conversations) {
            totalUnreadCount += conversation.unreadMessagesCount;
        }
#endif
       
        
        indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        label = [cell.contentView viewWithTag:1000 + indexPath.row];
        label.text = [NSString stringWithFormat:@"%ld", (long)totalUnreadCount];
        label.hidden = totalUnreadCount == 0;
        [self remakeLbael:label];
        
        
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
        // 测试数据
        //            NSDictionary *paramDic = @{
        //                                       @"agencyId":@(10386),
        //                                       };
        
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(NSDictionary *responseObj) {
            // 加载成功
            
            YSNLog(@"rssssssss%@", responseObj);
            NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
            if (code == 1000) {
                
                
                NSDictionary *numDic = [responseObj objectForKey:@"data"];
                // 喊装修数量
                NSInteger callDecoInt = [numDic[@"callDeco"] integerValue];
                // 系统消息数量
                NSInteger complainInt = [numDic[@"complain"] integerValue];
                // 计算器数量
                NSInteger calCountInt = [numDic[@"calCount"] integerValue];
                // 公司申请数量
                NSInteger companyApplyInt = [numDic[@"companyApply"] integerValue];
                // 企业申请数量
                NSInteger cooperateInt = [numDic[@"enterPriseCount"] integerValue];
                
                // 报名活动消息数量
                NSInteger activityNum = [numDic[@"signupMessageNum"] integerValue];
                // 联盟邀请数量
                NSInteger invatationSum = [numDic[@"invatationSum"] integerValue];
                // 联盟申请数量
                NSInteger unionApplyNum = [numDic[@"unionApplyNum"] integerValue];
                
                
                SNNavigationController *navi = self.tabBarController.viewControllers[3];
                MeViewController *meVC = navi.viewControllers[0];
                
                NSInteger messageNum = [numDic[@"total"] integerValue];
                messageNum += totalUnreadCount;
                // 消息数量添加 使用说明提示
                BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
                if (kHasUseExpalinUpdate && !isReade) {
                    messageNum += 1;
                }
                
                if (messageNum > 99) {
                    meVC.tabBarItem.badgeValue = @"99+";
                } else if (messageNum > 0) {
                    meVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", messageNum];
                } else {
                    meVC.tabBarItem.badgeValue = nil;
                }
                [UIApplication sharedApplication].applicationIconBadgeNumber = [numDic[@"total"] integerValue];
                if ([numDic[@"total"] integerValue] == 0) {
                    [JPUSHService resetBadge];
                }
                // 计算器
                UILabel *label = nil;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                label = [cell.contentView viewWithTag:1000 + indexPath.row];
                label.hidden = calCountInt== 0;
                
                //喊装修 客户预约
                indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                cell = [self.tableView cellForRowAtIndexPath:indexPath];
                label = [cell.contentView viewWithTag:1000 + indexPath.row];
                label.text = [NSString stringWithFormat:@"%ld", (long)callDecoInt];
                label.hidden = callDecoInt == 0;
                [self remakeLbael:label];
                
                //联盟邀请
                indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                cell = [self.tableView cellForRowAtIndexPath:indexPath];
                label = [cell.contentView viewWithTag:1000 + indexPath.row];
                label.text = [NSString stringWithFormat:@"%ld", (long)invatationSum];
                label.hidden = invatationSum == 0;
                [self remakeLbael:label];
                
                //联盟申请
                indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                cell = [self.tableView cellForRowAtIndexPath:indexPath];
                label = [cell.contentView viewWithTag:1000 + indexPath.row];
                label.text = [NSString stringWithFormat:@"%ld", (long)unionApplyNum];
                label.hidden = unionApplyNum == 0;
                [self remakeLbael:label];
                
                //报名活动
                indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
                cell = [self.tableView cellForRowAtIndexPath:indexPath];
                label = [cell.contentView viewWithTag:1000 + indexPath.row];
                label.text = [NSString stringWithFormat:@"%ld", (long)activityNum];
                label.hidden = activityNum == 0;
                [self remakeLbael:label];
                
                // 公司申请
                indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
                cell = [self.tableView cellForRowAtIndexPath:indexPath];
                label = [cell.contentView viewWithTag:1000 + indexPath.row];
                label.text = [NSString stringWithFormat:@"%ld", (long)companyApplyInt];
                label.hidden = companyApplyInt == 0;
                [self remakeLbael:label];
                // 系统消息
                indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
                cell = [self.tableView cellForRowAtIndexPath:indexPath];
                label = [cell.contentView viewWithTag:1000 + indexPath.row];
                label.text = [NSString stringWithFormat:@"%ld", (long)complainInt];
                label.hidden = complainInt == 0;
                [self remakeLbael:label];
                // 聊天消息
                
                // 合作企业消息
                indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
                cell = [self.tableView cellForRowAtIndexPath:indexPath];
                label = [cell.contentView viewWithTag:1000 + indexPath.row];
                label.text = [NSString stringWithFormat:@"%ld", (long)cooperateInt];
                label.hidden = cooperateInt == 0;
                [self remakeLbael:label];
                
                [UIApplication sharedApplication].applicationIconBadgeNumber = messageNum;
                if (messageNum == 0) {
                    [JPUSHService resetBadge];
                }
                
                
            } else if(code == 2000) {
                [self.view hiddleHud];
                [self.view showHudFailed:@"获取消息数量失败"];
            }else {
                [self.view hiddleHud];
                NSDictionary *numDic = [responseObj objectForKey:@"data"];
                NSInteger messageNum = [numDic[@"total"] integerValue];
                // 系统消息
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                UILabel *label = [cell.contentView viewWithTag:1000 + indexPath.row];
                label.text = [NSString stringWithFormat:@"%ld", (long)messageNum];
                label.hidden = messageNum == 0;
                [self remakeLbael:label];
            }

            
        } failed:^(NSString *errorMsg) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view hudShowWithText:NETERROR];
            });
        }];
        
        
    }else {
        // 消息数量添加 使用说明提示
        BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
        if (kHasUseExpalinUpdate && !isReade) {
            self.tabBarItem.badgeValue = @"1";
            [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
        }
        
    }
    
}

- (void)clearMessageNum {
    // 计算器
    UILabel *label = nil;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    label = [cell.contentView viewWithTag:1000 + indexPath.row];
    label.hidden = YES;
    //喊装修 客户预约
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    label = [cell.contentView viewWithTag:1000 + indexPath.row];
    label.hidden = YES;
    //联盟邀请
    indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    label = [cell.contentView viewWithTag:1000 + indexPath.row];
    label.hidden = YES;
    //联盟申请
    indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    label = [cell.contentView viewWithTag:1000 + indexPath.row];
    label.hidden = YES;
    //报名活动
    indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    label = [cell.contentView viewWithTag:1000 + indexPath.row];
    label.hidden = YES;
    // 公司申请
    indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    label = [cell.contentView viewWithTag:1000 + indexPath.row];
    label.hidden = YES;
    // 系统消息
    indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    label = [cell.contentView viewWithTag:1000 + indexPath.row];
    label.hidden = YES;
    // 对话消息
    indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    label = [cell.contentView viewWithTag:1000 + indexPath.row];
    label.hidden = YES;
    // 合作企业消息
    indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    label = [cell.contentView viewWithTag:1000 + indexPath.row];
    label.hidden = YES;
}

-(void)createTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
    tableView.backgroundColor = White_Color;
    
    [self.view addSubview:tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"tableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"计算报价";
            cell.imageView.image = [UIImage imageNamed:@"calc"];
            
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor redColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(-24);
                make.size.height.mas_equalTo(12);
                make.size.width.mas_equalTo(12);
            }];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 6;
            label.layer.masksToBounds = YES;
            label.tag = 1000 + indexPath.row;
            label.hidden = YES;
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"客户预约";
            cell.imageView.image = [UIImage imageNamed:@"hanzhuangxiu"];
            
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor redColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(-24);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 10;
            label.layer.masksToBounds = YES;
            label.tag = 1000 + indexPath.row;
            label.hidden = YES;

        }
            break;
        case 2:
        {

            cell.textLabel.text = @"联盟邀请";
            cell.imageView.image = [UIImage imageNamed:@"msgyaoqing"];

            
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor redColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(-24);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 10;
            label.layer.masksToBounds = YES;
            label.tag = 1000 + indexPath.row;
            label.hidden = YES;
            
        }
            break;
        case 3:
        {
            
            cell.textLabel.text = @"联盟申请";
            cell.imageView.image = [UIImage imageNamed:@"msgshenqing"];
            
            
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor redColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(-24);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 10;
            label.layer.masksToBounds = YES;
            label.tag = 1000 + indexPath.row;
            label.hidden = YES;
            
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"报名活动";
            cell.imageView.image = [UIImage imageNamed:@"huodong"];
            
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor redColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(-24);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 10;
            label.layer.masksToBounds = YES;
            label.tag = 1000 + indexPath.row;
            label.hidden = YES;
            
        }
            break;
        case 5:
        {
            cell.textLabel.text = @"公司申请";
            cell.imageView.image = [UIImage imageNamed:@"gongsisheqing"];
            
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor redColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(-24);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 10;
            label.layer.masksToBounds = YES;
            label.tag = 1000 + indexPath.row;
            label.hidden = YES;

            
        }
            break;
        case 6:
        {
            cell.textLabel.text = @"系统消息";
            cell.imageView.image = [UIImage imageNamed:@"xitong"];
         
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor redColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(-24);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 10;
            label.layer.masksToBounds = YES;
            label.tag = 1000 + indexPath.row;
            label.hidden = YES;
        }
            break;
        case 7:
        {
            cell.textLabel.text = @"聊天消息";
            cell.imageView.image = [UIImage imageNamed:@"tixing"];
            
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor redColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(-24);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 10;
            label.layer.masksToBounds = YES;
            label.tag = 1000 + indexPath.row;
            label.hidden = YES;
            
            
        }
            break;
        case 8:
        {
            cell.textLabel.text = @"合作企业";
            cell.imageView.image = [UIImage imageNamed:@"cooperateMsg"];
            
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor redColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(-24);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 10;
            label.layer.masksToBounds = YES;
            label.tag = 1000 + indexPath.row;
            label.hidden = YES;
            
            
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            // 计算器
        {
            CalculateViewController *calculateVC = [[CalculateViewController alloc] init];
            [self.navigationController pushViewController:calculateVC animated:YES];
        }
            break;
        case 1:
        {
            NeedDecorationViewController *needVC = [[NeedDecorationViewController alloc]init];
            [self.navigationController pushViewController:needVC animated:YES];
        }
            break;
            // 联盟邀请
        case 2:
        {
            UnionInviteMessageController *needVC = [[UnionInviteMessageController alloc]init];
            [self.navigationController pushViewController:needVC animated:YES];
        }
            break;
            // 联盟申请
        case 3:
        {
            ZCHUnionApplyMsgController *vc = [[ZCHUnionApplyMsgController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        // 报名活动
        case 4:
        {
            ActivityMessageViewController *vc = [ActivityMessageViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
            // 公司申请
        {
            CompanyApplyViewController *companyApplyVC = [[CompanyApplyViewController alloc] init];
            [self.navigationController pushViewController:companyApplyVC animated:YES];
        }
            break;
        case 6:
        {
            SystemMessageViewController *systemVC = [[SystemMessageViewController alloc]init];
            [self.navigationController pushViewController:systemVC animated:YES];
        }
            break;
            
        case 7:
        {
            
            
            
#if DELETEHUANXIN
            // (@"注释掉环信")
            [[PublicTool defaultTool] publicToolsHUDStr:@"此功能暂缓开通" controller:self sleep:1.0];
#else
            // (@"打开环信代码")
            RemindViewController *remindVC = [[RemindViewController alloc]init];
            [self.navigationController pushViewController:remindVC animated:YES];
#endif
            

            
            
        }
            break;
        
        case 8:
            // 合作企业
        {
            ZCHCooperateMesController *cooperateMesVC = [[ZCHCooperateMesController alloc] init];
            [self.navigationController pushViewController:cooperateMesVC animated:YES];
        }
            break;
        
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
