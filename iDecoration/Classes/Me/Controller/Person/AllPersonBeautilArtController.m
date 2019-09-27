//
//  AllPersonBeautilArtController.m
//  iDecoration
//
//  Created by sty on 2018/1/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "AllPersonBeautilArtController.h"
#import "BeautifulArtCardModel.h"

#import "AllPersonBeautilArtCell.h"

#import "MyBeautifulArtShowController.h"
#import "NewsActivityShowController.h"

@interface AllPersonBeautilArtController ()<UITableViewDelegate,UITableViewDataSource,AllPersonBeautilArtCellDelegat>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableDictionary *selectDict;
@end

@implementation AllPersonBeautilArtController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全部文章";
    
    
    self.dataArray = [NSMutableArray array];
    self.selectDict = [NSMutableDictionary dictionary];
    
    if (self.isHavePower) {
        // 设置导航栏最右侧的按钮
        UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        editBtn.frame = CGRectMake(0, 0, 44, 44);
        [editBtn setTitle:@"完成" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        [editBtn addTarget:self action:@selector(successBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    }
    
    [self creatUI];
    [self requestAllArt];
}

-(void)creatUI{
    
    self.view.backgroundColor = White_Color;
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    //    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 100;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllPersonBeautilArtCell *cell = [AllPersonBeautilArtCell cellWithTableView:tableView indexpath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    BOOL isSelect = NO;

    cell.circleBtn.tag = indexPath.row;
    cell.delegate = self;
    [cell configData:self.dataArray[indexPath.row] isSelect:isSelect isHavePower:self.isHavePower];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BeautifulArtCardModel *model = self.dataArray[indexPath.row];
    if (model.type == 2) {
        //个人
        MyBeautifulArtShowController *vc = [[MyBeautifulArtShowController alloc]init];
        vc.designsId = model.designsId;
        vc.activityType = model.activityId?3:2;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (model.type == 3) {
        //公司
        
        NewsActivityShowController *VC = [[NewsActivityShowController alloc] init];
        VC.activityType = 2;
        VC.designsId = model.designsId;
        VC.activityType = model.activityId?3:2;
        VC.origin = @"2";
        //            VC.companyId = self.companyDic[@"companyId"];
        //            VC.companyName = self.companyDic[@"companyName"];
        //            VC.companyLogo = self.companyDic[@"companyLogo"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

#pragma mark - AllPersonBeautilArtCellDelegat

-(void)circleBtnDo:(NSInteger)tag{
    BeautifulArtCardModel *model = self.dataArray[tag];
    
    if (model.isDisplay) {
        //已选中--直接删
        model.isDisplay = 0;
        [self.dataArray replaceObjectAtIndex:tag withObject:model];
        NSIndexPath *path = [NSIndexPath indexPathForRow:tag inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    }
    else{
        //未选中
        //判断是否超过6个。超过6个：提示最多选6个  不超过：直接添加
        NSInteger haveSelectCount = 0;
        for (BeautifulArtCardModel *tempModel in self.dataArray) {
            if (tempModel.isDisplay) {
                haveSelectCount = haveSelectCount+1;
            }
        }
        if (haveSelectCount>=6) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"不能超过6个" controller:self sleep:1.5];
        }
        else{
            model.isDisplay = 1;
            [self.dataArray replaceObjectAtIndex:tag withObject:model];
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:tag inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark - 提交数据

-(void)successBtnClick{
    //    NSInteger haveSelectCount = 0;
    
    //美文个数不能为0
    NSMutableArray *haveSelectArray = [NSMutableArray array];
    for (BeautifulArtCardModel *tempModel in self.dataArray) {
        if (tempModel.isDisplay) {
            [haveSelectArray addObject:tempModel];
        }
    }
    if (haveSelectArray.count<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请先选择美文" controller:self sleep:1.5];
        return;
    }
    
    //连成串
    NSMutableArray *designIdsArray = [NSMutableArray array];
    for (BeautifulArtCardModel *tempModel in haveSelectArray) {
        
        [designIdsArray addObject:@(tempModel.designsId)];
    }
    NSString *haveSelectStr = [designIdsArray componentsJoinedByString:@","];
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"businessCard/saveDesigns.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"agencyId":@(user.agencyId), @"designIds":haveSelectStr
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"添加成功" controller:self sleep:1.5];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PersonAddBeautifulArtSucess" object:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"添加失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"添加失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 查询店铺所有美文

-(void)requestAllArt{
    [self.view endEditing:YES];
    //    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    //    NSString *temStr = self.searchTF.text;
    //    temStr = [temStr ew_removeSpaces];
    //    temStr = [temStr ew_removeSpacesAndLineBreaks];
    //    if (!temStr||temStr.length<=0) {
    //        temStr = @"";
    //    }
    NSString *defaultURL = [BASEURL stringByAppendingString:@"businessCard/getDesigns.do"];
    NSDictionary *paramDic = @{
                               @"agencyId": self.agencyId,
                               @"isEdit": @(1)
                               };
    MJWeakSelf;
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            NSArray *array = [[responseObj objectForKey:@"data"] objectForKey:@"designsList"];
            
            [weakSelf.dataArray removeAllObjects];
            //
            [weakSelf.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[BeautifulArtCardModel class] json:array]];
            if (weakSelf.dataArray.count == 0) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
            }
            
            [weakSelf.tableView reloadData];
        }
        
        //        else if(code==1001){
        //            [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
        //        }
        //        else if(code==1002){
        //            [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
        //        }
        else if(code==2000){
            [[PublicTool defaultTool] publicToolsHUDStr:@"服务器异常" controller:self sleep:1.5];
        }
        else {
            [[PublicTool defaultTool] publicToolsHUDStr:@"服务器异常" controller:self sleep:1.5];
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

-(UITableView *)tableView{
    if (!_tableView) {
        CGFloat navbottom = self.navigationController.navigationBar.bottom;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,navbottom+10,kSCREEN_WIDTH,kSCREEN_HEIGHT-navbottom) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
        
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
