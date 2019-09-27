//
//  STYCouponSelectController.m
//  iDecoration
//
//  Created by sty on 2018/2/7.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "STYCouponSelectController.h"
#import "AddMerchanCell.h"
#import "STYCouponSelectModel.h"
#import "STYProductCouponEditController.h"

@interface STYCouponSelectController ()<UITableViewDelegate,UITableViewDataSource,AddMerchanCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) NSMutableDictionary *selectDict;
@property (nonatomic, copy) NSString *numberstr;
@end

@implementation STYCouponSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"礼品";
    
    self.dataArray = [NSMutableArray array];
    self.selectDict = [NSMutableDictionary dictionary];
    
    [self.dataArray removeAllObjects];
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(successBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    [self setUI];
    [self requestData];
}

-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomV];
    [self.view addSubview:self.addBtn];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 88;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddMerchanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddMerchanCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.circleBtn.tag = indexPath.row;
    cell.delegate = self;
    BOOL isSelect = NO;
    NSString *str = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSInteger tag = [[self.selectDict objectForKey:str] integerValue];
    if (!tag) {
        isSelect = NO;
    }
    else{
        isSelect = YES;
    }
    [cell configData:self.dataArray[indexPath.row] isSelect:isSelect];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//是否允许编辑，默认值是YES
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"是否确认删除该礼品?" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [self deleteCouponWithIndex:indexPath];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return [NSArray arrayWithObjects:deleteAction, nil];
}

#pragma mark - 删除
- (void)deleteCouponWithIndex:(NSIndexPath *)index {
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    STYCouponSelectModel *model = self.dataArray[index.row];
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"gift/getDelete.do"];
    NSDictionary *param = @{
                            @"giftId" : model.giftId,
                            @"agencyId":@(user.agencyId)
                            };
    [[UIApplication sharedApplication].keyWindow hudShow:@"删除中..."];
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow textHUDHiddle];
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.dataArray removeObjectAtIndex:index.row];
        }
        else if (responseObj && [responseObj[@"code"] integerValue] == 1001) {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"被添加到了礼品券中不能删除" controller:self sleep:1.5];
        }else {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1.5];
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow textHUDHiddle];
    }];
}

#pragma mark - action

-(void)addBtnClick:(UIButton *)btn{
    STYProductCouponEditController *vc = [[STYProductCouponEditController alloc]init];
    vc.companyId = self.companyId;
    vc.block = ^{
        [self requestData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)successBtnClick{
    NSArray *keyArray = [self.selectDict allKeys];
    if (keyArray.count<=0||self.dataArray.count<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请选择礼品" controller:self sleep:1.5];
        return;
    }
    
    NSMutableArray *selectArray = [NSMutableArray array];
    for (int i = 0; i<self.dataArray.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        NSInteger tag = [[self.selectDict objectForKey:str] integerValue];
        if (tag) {
            NSString *temStr = [NSString stringWithFormat:@"%d",i];
            [selectArray addObject:temStr];
        }
    }
    if (selectArray.count<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请选择礼品" controller:self sleep:1.5];
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in selectArray) {
        NSInteger tag = [str integerValue];
        STYCouponSelectModel *model = self.dataArray[tag];
        [array addObject:model];
    }
    
    [self resetGiftWith:array];
    
}

#pragma mark - AddMerchanCellDelegate

-(void)number:(NSString *)numstr andcell:(UITableViewCell *)cell
{
    NSIndexPath *index = [_tableView indexPathForCell:cell];
    STYCouponSelectModel *model = self.dataArray[index.row];
    model.numbers = numstr;
    NSInteger num = [numstr integerValue];
    NSNumber *intnum = @(num);
    
    [self.dataArray replaceObjectAtIndex:index.row withObject:model];
    NSString *keystr = [NSString stringWithFormat:@"%ld",index.row];
    [self.selectDict setObject:intnum forKey:keystr];
    
}

-(void)selectClick:(NSInteger)tag
{
    NSString *str = [NSString stringWithFormat:@"%ld",tag];
    NSInteger selectTag = [[self.selectDict objectForKey:str] integerValue];
    __weak typeof(self) weakSelf = self;
    if (!selectTag) {
        STYCouponSelectModel *model = self.dataArray[tag];
        model.numbers = @"1";
        [self.selectDict setObject:@(1) forKey:str];
        [weakSelf.dataArray replaceObjectAtIndex:tag withObject:model];
        NSIndexPath *path = [NSIndexPath indexPathForRow:tag inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    }
    else{
        [self.selectDict setObject:@(0) forKey:str];
        NSIndexPath *path = [NSIndexPath indexPathForRow:tag inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - 重新编辑礼品券中的礼品

-(void)resetGiftWith:(NSMutableArray *)array{
    NSMutableArray *detailsArray = [NSMutableArray array];
    
//    NSInteger count = array.count;
    for (STYCouponSelectModel *model in array) {
        NSMutableDictionary *temDetailDict = [NSMutableDictionary dictionary];
        [temDetailDict setObject:model.giftId?model.giftId:@"0" forKey:@"giftId"];
        [temDetailDict setObject:model.numbers?model.numbers:@"0" forKey:@"numbers"];
        
        [detailsArray addObject:temDetailDict];
    }
    
    
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:detailsArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    constructionStr2 = [constructionStr2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"coupongift/resetgifts.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"couponId":self.couponId,
                               @"agencyId":@(user.agencyId),
                               @"gifts":constructionStr2
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                if (self.arrayBlock) {
                    self.arrayBlock(array);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 查询礼品列表

-(void)requestData{

    NSString *defaultApi = [BASEURL stringByAppendingString:@"gift/getList.do"];
    
    if (!self.couponId||self.couponId.length<=0) {
        self.couponId = @"0";
    }
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"companyId":self.companyId,
                               @"couponId":self.couponId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                NSArray *listArray = responseObj[@"data"][@"list"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[STYCouponSelectModel class] json:listArray];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:arr];
                if (self.dataArray.count<=0) {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"暂无礼品" controller:self sleep:1.5];
                }
                else{
                    for (int i = 0; i<self.dataArray.count; i++) {
                        STYCouponSelectModel *model = self.dataArray[i];
                        if ([model.ccgId integerValue]>0) {
                            NSString *str = [NSString stringWithFormat:@"%d",i];
                            [self.selectDict setObject:@(1) forKey:str];
                        }
                    }
                }
                [self.tableView reloadData];
                
                
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
        
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - lazy

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar.bottom,kSCREEN_WIDTH,kSCREEN_HEIGHT-self.navigationController.navigationBar.bottom-50) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        [_tableView registerNib:[UINib nibWithNibName:@"AddMerchanCell" bundle:nil] forCellReuseIdentifier:@"AddMerchanCell"];
    }
    return _tableView;
}

-(UIView *)bottomV{
    if (!_bottomV) {
        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-51, kSCREEN_WIDTH, 1)];
        _bottomV.backgroundColor = kSepLineColor;
    }
    return _bottomV;
}

-(UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(0,self.bottomV.bottom,kSCREEN_WIDTH,50);

        _addBtn.backgroundColor = White_Color;
        [_addBtn setTitle:@"添加礼品" forState:UIControlStateNormal];
        _addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_addBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        _addBtn.titleLabel.font = NB_FONTSEIZ_BIG;
        [_addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setImage:[UIImage imageNamed:@"greenAddBtn"] forState:UIControlStateNormal];

    }
    return _addBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
