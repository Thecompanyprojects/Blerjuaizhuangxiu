//
//  MyCompanyViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/3/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "MyCompanyViewController.h"
#import "GetCompanyListApi.h"
#import "MyCompanyHeadCell.h"
#import "MyCompanyMidCell.h"
#import "SubsidiaryModel.h"
#import "CreateCompanyViewController.h"
#import "CreatShopController.h"
#import "EditShopViewController.h"
#import "AreaListModel.h"
#import "ShopDetailController.h"
#import "HeadquartersAreaController.h"

#import "EditMyCompanyController.h"
#import <UITableView+FDIndexPathHeightCache.h>
#import "SSPopup.h"
#import "DateStatisticsViewController.h"
#import "DateStatisticsModel.h"
#import "VIPExperienceViewController.h"

@interface MyCompanyViewController ()<UITableViewDelegate,UITableViewDataSource,MyCompanyHeadCellDelegate,MyCompanyMidCellDelegate,UIAlertViewDelegate,SSPopupDelegate>
{
    BOOL isHaveCompany;//是否有第一个公司
    BOOL isShow; //中间cell的删除按钮是否显示
    
    NSInteger _tag;
    BOOL implement;//是否是执行经理 0 不是 1 是
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *areaListArray;
@property (nonatomic, strong) NSDictionary *headDit;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSString *jobId;//区分总经理还是经理还是别的
@property (nonatomic, strong) MyCompanyMidCell *midCell;
@property (nonatomic, copy) NSString *companyId;

// 数据统计所需数组  总公司的
@property (nonatomic, strong) NSMutableArray *headCompanyDateStaticArray;
// 子公司的
@property (nonatomic, strong) NSMutableArray *sonCompanyDateStaticArray;
@end

@implementation MyCompanyViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"我的公司";
    implement = NO;
    self.dataArray = [NSMutableArray array];
    self.areaListArray = [NSMutableArray array];
    self.headCompanyDateStaticArray = [NSMutableArray array];
    self.sonCompanyDateStaticArray = [NSMutableArray array];
    isShow = NO;
    [self creatUI];

    [self judgeRightbarItemState];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getCompanyList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *showShopClassPromptNum = [userDefaults stringForKey:@"showShopClassPromptNum"];
    if (!showShopClassPromptNum || showShopClassPromptNum.integerValue <= 3) {
        if (!showShopClassPromptNum) {
            showShopClassPromptNum = @"1";
        }
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"由于版本更新，为确保您店铺的分类正确，请您及时修改店铺类别" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {

        }];
        [alertC addAction:action2];
        [self presentViewController:alertC animated:YES completion:^{
            NSString *num = [NSString stringWithFormat:@"%ld", showShopClassPromptNum.integerValue + 1];
            [userDefaults setValue:num forKey:@"showShopClassPromptNum"];
            [userDefaults synchronize];
        }];
    }

}

-(void)creatUI{
    [self.view addSubview:self.tableView];
    
    UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newBtn.frame = CGRectMake(0, 0, 60, 44);
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newBtn setTitle:@"新店面" forState:UIControlStateNormal];

    newBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.rightBtn = newBtn;
    

    UIBarButtonItem *rightbarItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = rightbarItem;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCompanyList) name:@"requestCompanyList" object:nil];
}

-(void)newBtnClick{
    
   /* isShow = NO;
    [self.tableView reloadData];
  
    SSPopup* selection=[[SSPopup alloc]init];
    selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
    
    selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
    selection.SSPopupDelegate=self;
    [self.view  addSubview:selection];
    
    NSArray *QArray = @[@"装修公司", @"整装公司", @"新型装修",@"建材店铺"];
    self.rightBtn.userInteractionEnabled = NO;
    [selection CreateTableview:QArray withTitle:@"创建新店铺" setCompletionBlock:^(int tag) {}];
    selection.blockDidTouchCell = ^(NSInteger index) {
        [self pushToCreatShopControllerWithTag:index];
    };*/
    VIPExperienceViewController *controller = [VIPExperienceViewController new];
    SubsidiaryModel *model = [SubsidiaryModel new];
    controller.isNew = true;
    model.isCompany = false;
    controller.model = model;
    controller.model.companyId = self.companyId;
    controller.companyId = self.companyId;
    controller.model.areaList = self.areaListArray;
    controller.isHaveMainCompany = isHaveCompany;
    
    [self.navigationController pushViewController:controller animated:YES];
}

/*- (void)pushToCreatShopControllerWithTag:(NSInteger)tag {
    VIPExperienceViewController *controller = [VIPExperienceViewController new];
    SubsidiaryModel *model = [SubsidiaryModel new];
    controller.isNew = true;
    if (tag == 3) {
        model.isCompany = false;
    }else{
        model.isCompany = true;
        switch (tag) {
            case 0:
                model.typeName = @"装修公司";
                break;
            case 1:
                model.typeName = @"整装公司";
                break;
            case 2:
                model.typeName = @"新型装修";
                break;
            default:
                break;
        }
    }
    controller.model = model;
    controller.model.companyId = self.companyId;
    controller.companyId = self.companyId;
    controller.model.areaList = self.areaListArray;
    controller.isHaveMainCompany = isHaveCompany;

    [self.navigationController pushViewController:controller animated:YES];
}*/

-(void)disMissDoSomething{
    self.rightBtn.userInteractionEnabled = YES;
}

-(void)judgeRightbarItemState{

    [self.rightBtn addTarget:self action:@selector(newBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setTitle:@"新店面" forState:UIControlStateNormal];
}

-(void)finishDelete{
    
}

#pragma mark - uitableviewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }else{
        return self.dataArray.count + 1;

    }
}



- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110;
    } else if(indexPath.section == 1) {
        return 60;
    } else if(indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 60;
        } else {
            return UITableViewAutomaticDimension;
        }
    } else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MyCompanyHeadCell *cell = [MyCompanyHeadCell cellWithTableView:tableView];
        
        [cell configWith:self.headDit];
        cell.delegate = self;
        if ([self.jobId integerValue] == 1002||implement) {
            cell.editBtn.hidden = NO;
        }else{
            cell.editBtn.hidden = YES;
        }
        return cell;
    }
    else if (indexPath.section == 1){
        MyCompanyMidCell *cell = [MyCompanyMidCell cellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        self.midCell = [MyCompanyMidCell cellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        
        cell.contentL.text = @"公司号";
        
        [cell.leftImg setImage:[UIImage imageNamed:@"companyNumber1-0"]];
        cell.rightRow.hidden = YES;
        
        cell.companySign.hidden = NO;
        cell.companySign.text = [self.headDit objectForKey:@"companyNumber"];
        return cell;
    }
    
    else {
        MyCompanyMidCell *cell = [MyCompanyMidCell cellWithTableView:tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row==0) {
            cell.contentL.text = @"公司架构";
            [cell.leftImg setImage:[UIImage imageNamed:@"comFrame-0"]];
            cell.rightRow.hidden = YES;
        }

        else{
            SubsidiaryModel *data = self.dataArray[indexPath.row - 1];
            [cell configWith:data];
            cell.delegate = self;
            cell.tag = indexPath.row;
            cell.leftImg.hidden = YES;
            
            //加一个实心圆点
            UIImageView *circleImgV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30-8, 16, 16)];
            circleImgV.userInteractionEnabled = YES;
            circleImgV.layer.masksToBounds = YES;
            circleImgV.layer.cornerRadius = circleImgV.width/2;
            circleImgV.backgroundColor = RGB(119, 188, 247);
            [cell addSubview:circleImgV];
            
            if (isShow) {
                if ([data.headQuarters integerValue]==1) {
                    cell.deleteBtn.hidden = YES; //默认的总公司的分公司不能删除
                }else{
                    cell.deleteBtn.hidden = NO;
                }
            }else{
                cell.deleteBtn.hidden = YES;
            }
            
            if (!data.agencysId||data.agencysId.length<=0) {
                //不可点击
                cell.rightRow.hidden = YES;
            }
            else{
                cell.rightRow.hidden = NO;
            }
        }
        return cell;
    }

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
    }
    else if (indexPath.section == 1){
        
    }
    else {
        if (indexPath.row == 0) {
            
        }

        else {
            SubsidiaryModel *model = self.dataArray[indexPath.row - 1];
            if (!model.agencysId||model.agencysId.length<=0) {
                //不可点击
                NSString *message;
                if ([model.companyType isEqualToString:@"1018"] || [model.companyType isEqualToString:@"1065"] || [model.companyType isEqualToString:@"1064"]) {
                    message = @"您没有加入该公司！";
                }
                else{
                    message = @"您没有加入该店铺！";
                }
                [[PublicTool defaultTool] publicToolsHUDStr:message controller:self sleep:1.5];
            }else{
                ShopDetailController *vc = [[ShopDetailController alloc]init];
                vc.model = model;
                vc.jobId = self.jobId;
                vc.implement = implement;
                __weak typeof(self) weakSelf = self;
                vc.backRefreshBlock = ^() {
                    
                    [weakSelf getCompanyList];
                    
                };
                vc.sonCompanyDateModel = self.sonCompanyDateStaticArray[indexPath.row - 1];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
    }

}

- (void)getCompanyList {
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *requestString = [BASEURL stringByAppendingString:@"company/findCompanyList.do"];
    NSDictionary *dic = @{@"agencysId":@(user.agencyId)
                          };

    [NetManager afPostRequest:requestString parms:dic finished:^(id responseObj) {

        
        if ([responseObj[@"code"] isEqualToString:@"1000"]) {
            NSDictionary *dict = responseObj[@"data"];
            [self setDataWithDict:dict];
            NSArray *arr = [dict objectForKey:@"companyList"];
            
            if (!arr||!arr.count) {
                isHaveCompany = NO;
            }else{
                BOOL temBool = NO;
                for (NSDictionary *temDict in arr) {
                    // 是否是总公司
                    if ([[temDict objectForKey:@"headQuarters"] integerValue]==1) {
                        temBool = YES;
                        break;
                    }
                    else{
                        temBool = NO;
                    }
                }
                if (!temBool) {
                    isHaveCompany = NO;
                }else{
                    isHaveCompany = YES;
                }
                
            }
            
        }

    } failed:^(NSString *errorMsg) {
        YSNLog(@"%@",errorMsg);
    }];
}

-(void)setDataWithDict:(NSDictionary *)dict {
    
    self.companyId = [dict objectForKey:@"companyId"];
    self.jobId = [dict objectForKey:@"myJobType"];
    NSString *str = [dict objectForKey:@"implement"];
    if ([str isEqualToString:@"0"]) {
        implement = YES;
    }
    else
    {
        implement = NO;
    }
    if ([self.jobId integerValue]==1002||implement) {
        self.rightBtn.hidden = NO;
    }else{
        self.rightBtn.hidden = YES;
    }
    NSString *companyName = [dict objectForKey:@"companyName"];
    NSString *companySlogan = [dict objectForKey:@"companySlogan"];
    NSString *companyLogo = [dict objectForKey:@"companyLogo"];
    NSString *companyNumber = [dict objectForKey:@"companyNumber"];
    if (!companyNumber) {
        companyNumber = @"";
    }
    
    _headDit = [NSDictionary dictionaryWithObjectsAndKeys:companyName,@"companyName",companySlogan,@"companySlogan",companyLogo,@"companyLogo",companyNumber,@"companyNumber", nil];
    
    [self.dataArray removeAllObjects];
    NSArray *temArray = [NSArray yy_modelArrayWithClass:[SubsidiaryModel class] json:[dict objectForKey:@"companyList"]];
    [self.dataArray addObjectsFromArray:temArray];
    // 数据统计第一个 总公司数据
    DateStatisticsModel *model = [DateStatisticsModel new];
    [model yy_modelSetWithDictionary:dict[@"staticCounts"]];
    model.companyName = companyName;
    [self.headCompanyDateStaticArray addObject:model];
    // 数据统计  其他公司数据数组
    YSNLog(@"%@",[dict objectForKey:@"companyList"] );
    NSArray *dateArray = [NSArray yy_modelArrayWithClass:[DateStatisticsModel class] json:[dict objectForKey:@"companyList"]];
    [self.headCompanyDateStaticArray addObjectsFromArray:dateArray];
    [self.sonCompanyDateStaticArray addObjectsFromArray:dateArray];
    NSArray *temArray2 = [NSArray yy_modelArrayWithClass:[AreaListModel class] json:[dict objectForKey:@"areaList"]];
    [self.areaListArray addObjectsFromArray:temArray2];
    [self.tableView reloadData];
}

#pragma mark - MyCompanyHeadCellDelegate
- (void)editCompanyInfoOrDeleteCompany{
    EditMyCompanyController *vc = [[EditMyCompanyController alloc]init];
    vc.dict = _headDit;
    vc.dataArray = self.dataArray;
    vc.companyId = self.companyId;
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        SubsidiaryModel *data = self.dataArray[_tag-1];
        NSString *requestString = [BASEURL stringByAppendingString:@"company/deleteByCompanyId.do"];
        NSDictionary *dic = @{@"companyIds":data.companyId
                              };
        [NetManager afPostRequest:requestString parms:dic finished:^(id responseObj) {
            NSLog(@"%@",responseObj);
            if ([responseObj[@"code"] isEqualToString:@"1000"]) {
                [self getCompanyList];
                [[PublicTool defaultTool] publicToolsHUDStr:@"删除成功" controller:self sleep:1.0];
            }
        } failed:^(NSString *errorMsg) {
            YSNLog(@"%@",errorMsg);
        }];
    }
}

#pragma mark - setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,kSCREEN_WIDTH,kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

@end
