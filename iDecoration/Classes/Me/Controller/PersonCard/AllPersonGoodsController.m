//
//  AllPersonGoodsController.m
//  iDecoration
//
//  Created by sty on 2018/1/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "AllPersonGoodsController.h"
#import "PersonGoodListModel.h"
#import "AllPersonGoodsCell.h"
#import "GoodsDetailViewController.h"

@interface AllPersonGoodsController ()<UITableViewDelegate,UITableViewDataSource,AllPersonGoodsCellDelegat>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation AllPersonGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"全部商品";
    
    self.dataArray = [NSMutableArray array];
    
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
    [self creatUI];
    [self requestAllArt];
}

-(void)creatUI{
    
    self.view.backgroundColor = White_Color;
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    //        return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 160;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllPersonGoodsCell *cell = [AllPersonGoodsCell cellWithTableView:tableView indexpath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    BOOL isSelect = NO;
    
    cell.circleBtn.tag = indexPath.row;
    cell.delegate = self;
    [cell configData:self.dataArray[indexPath.row]];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    GoodsDetailViewController *vc = [[GoodsDetailViewController alloc] init];
    
    PersonGoodListModel *model = self.dataArray[indexPath.row];
    //    YSNLog(@"%@",model);
    vc.goodsID = model.id;
    vc.shopID = [self.companyDict objectForKey:@"companyId"];
    vc.origin = @"0";
    vc.fromBack = NO;
    vc.shopid = [self.companyDict objectForKey:@"companyId"];
    vc.companyType = [self.companyDict objectForKey:@"companyType"];
    vc.phone = [self.companyDict objectForKey:@"companyPhone"];
    vc.telPhone = [self.companyDict objectForKey:@"companyLandline"];
    
    NSString *merchanStr = [NSString stringWithFormat:@"%@",model.merchantId];
    NSDictionary *dicTwo= [NSDictionary dictionaryWithObjectsAndKeys:merchanStr,@"merchandiesId",
                           [self.companyDict objectForKey:@"companyLandline"]?[self.companyDict objectForKey:@"companyLandline"]:@"",@"companyLandline",
                           [self.companyDict objectForKey:@"companyPhone"]?[self.companyDict objectForKey:@"companyPhone"]:@"",@"companyPhone",
                           [self.companyDict objectForKey:@"companyId"]?[self.companyDict objectForKey:@"companyId"]:@"",@"companyId",
                           [self.companyDict objectForKey:@"companyType"]?[self.companyDict objectForKey:@"companyType"]:@"",@"companyType",
                           nil];
    
    vc.dataDic = dicTwo;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - AllPersonGoodsCellDelegate

-(void)circleBtnDo:(NSInteger)tag{
    PersonGoodListModel *model = self.dataArray[tag];

    if (model.isCardDisPlay) {
        //已选中--直接删
        model.isCardDisPlay = 0;
        [self.dataArray replaceObjectAtIndex:tag withObject:model];
        NSIndexPath *path = [NSIndexPath indexPathForRow:tag inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    }
    else{
        //未选中
        //判断是否超过6个。超过6个：提示最多选6个  不超过：直接添加
        NSInteger haveSelectCount = 0;
        for (PersonGoodListModel *tempModel in self.dataArray) {
            if (tempModel.isCardDisPlay) {
                haveSelectCount = haveSelectCount+1;
            }
        }
        if (haveSelectCount>=6) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"不能超过6个" controller:self sleep:1.5];
        }
        else{
            model.isCardDisPlay = 1;
            [self.dataArray replaceObjectAtIndex:tag withObject:model];

            NSIndexPath *path = [NSIndexPath indexPathForRow:tag inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark - 提交数据

-(void)successBtnClick{
    //    NSInteger haveSelectCount = 0;

    //案例个数不能为0
    NSMutableArray *haveSelectArray = [NSMutableArray array];
    for (PersonGoodListModel *tempModel in self.dataArray) {
        if (tempModel.isCardDisPlay) {
            [haveSelectArray addObject:tempModel];
        }
    }
    if (haveSelectArray.count<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请先选择商品" controller:self sleep:1.5];
        return;
    }

    //连成串
    NSMutableArray *designIdsArray = [NSMutableArray array];
    for (PersonGoodListModel *tempModel in haveSelectArray) {

        [designIdsArray addObject:@(tempModel.id)];
    }
    NSString *haveSelectStr = [designIdsArray componentsJoinedByString:@","];

    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"businessCard/saveMerchandies.do"];

    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"agencyId":@(user.agencyId), @"merchandiesIds":haveSelectStr
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {


        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"添加成功" controller:self sleep:1.5];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PersonAddGoodsSucess" object:nil];

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

#pragma mark - 查询店铺所有商品

-(void)requestAllArt{
    [self.view endEditing:YES];
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    //    NSString *temStr = self.searchTF.text;
    //    temStr = [temStr ew_removeSpaces];
    //    temStr = [temStr ew_removeSpacesAndLineBreaks];
    //    if (!temStr||temStr.length<=0) {
    //        temStr = @"";
    //    }
    NSString *defaultURL = [BASEURL stringByAppendingString:@"businessCard/getMerchandies.do"];
    NSDictionary *paramDic = @{
                               @"companyId":self.companyId?self.companyId:@"",
                               @"agencyId": @(userModel.agencyId),
                               @"isEdit": @(1)
                               };
    MJWeakSelf;
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            NSArray *array = [[responseObj objectForKey:@"data"] objectForKey:@"merchandiesList"];
//            //
            [weakSelf.dataArray removeAllObjects];
//            //            //
            [weakSelf.dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[PersonGoodListModel class] json:array]];
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

@end
