//
//  PanoramaViewController.m
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "PanoramaViewController.h"
#import "addFullsenceViewController.h"
#import "senceWebViewController.h"
#import "fullSenceCollectionViewCell.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "senceModel.h"
#import "DecorateNeedViewController.h"
#import "DecorateInfoNeedView.h"
#import "DecorateCompletionViewController.h"
#import "BLEJBudgetGuideController.h"
#import <UIButton+LXMImagePosition.h>

@interface PanoramaViewController ()<cellDelegate, LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout, UIActionSheetDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic,strong)UICollectionView  *collection;
//存放数据
@property(nonatomic,strong)NSMutableArray *dataArray;
// 右上角编辑按钮
@property(nonatomic,strong)UIButton *selectBtn;
//顶部添加按钮
@property(nonatomic,strong)UIButton *addbtn;

// 公司名称
@property (nonatomic, copy) NSString *companyName;
// 公司logo
@property (nonatomic, copy) NSString *companyLogo;
// 是否可以移动
@property (nonatomic, assign) BOOL isCanMove;
@property (strong, nonatomic) NSMutableArray *phoneArr;
@property (nonatomic, strong) DecorateInfoNeedView *infoView;



@end

@implementation PanoramaViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData:self.shopID];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"全景展示";
    // 设置右侧按钮
    self.view.backgroundColor = [UIColor whiteColor];
    self.phoneArr = [NSMutableArray array];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setTitle:@"完成" forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(editorAction:) forControlEvents:UIControlEventTouchUpInside];
    self.selectBtn = btn;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    

    
    self.isCanMove = NO;
    
    if (self.tag == 1000) {
        // 企业跳转来
        [self  creatTableView:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 50)];
        self.selectBtn.hidden = YES;

        [self addBottomView];
        
    }
    
    else if (self.tag == 0){
        //个人中心”跳转来
        //添加全景的权限是公司中的人员都可以添加和编辑，删除权限只有总经理和经理，店铺全景也是这样
        
        self.selectBtn.hidden = NO;
        self.addbtn.hidden = NO;
        [self  creatTableView:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 37 * hightScale - 64)];
        [self creatFootView];
    }
    
    else {
        // 工地
        //添加编辑全景的权限是总经理和经理和设计师，删除权限只有总经理和经理,并且没有交工
        NSString *impl = [[NSUserDefaults standardUserDefaults] objectForKey:@"impl"];
        NSString *implstr = [NSString stringWithFormat:@"%@",impl];
        if (([self.jobId integerValue] == 1002 || [self.jobId integerValue] == 1003 || [self.jobId integerValue] == 1027||[self.jobId integerValue] == 1029||[implstr isEqualToString:@"1"]||[self.jobId integerValue] == 1010)&&!self.isComplete) {
            //有权限
            self.selectBtn.hidden = NO;
            self.addbtn.hidden = NO;
            [self  creatTableView:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 37 * hightScale - 64)];
            [self creatFootView];
        } else {
            //无权限
            self.selectBtn.hidden = YES;
            [self  creatTableView:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 50)];

            [self addBottomView];
        }
        
        
    }

}


- (void)editorAction:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"编辑"] && self.dataArray.count == 0) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"还未上传全景"];
        [self.addbtn setHidden:NO];
        return;
    }
    
    sender.selected = !sender.selected;
    self.isCanMove = !self.isCanMove;
    if (sender.selected) {
        
        self.addbtn.hidden = YES;
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"按住图片拖拽可调整顺序"];
        
    } else {
    
        self.addbtn.hidden = NO;
        // 上传全景顺序
        [self uploadSortedData];
    }
    
    [self.collection  reloadData];

}


#pragma mark - 创建tableView
-(void)creatTableView:(CGRect)frame{
    
    LXReorderableCollectionViewFlowLayout *flow = [[LXReorderableCollectionViewFlowLayout alloc]init];
    
    flow.itemSize = CGSizeMake((kSCREEN_WIDTH)/2.0 , ((kSCREEN_WIDTH)/2.0 - 20) * 3/5.0 + 60 );
    
    self.collection = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flow];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.alwaysBounceVertical = YES;
    self.collection.emptyDataSetSource = self;
    self.collection.emptyDataSetDelegate = self;
    [self.view addSubview:self.collection];
    
    self.collection.backgroundColor = [UIColor whiteColor];
    //cell 注册
    
    [self.collection  registerNib:[UINib nibWithNibName:@"fullSenceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"fullSence"];
}


-(void)creatFootView{

    UIButton  *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collection.frame), kSCREEN_WIDTH, 37 * hightScale)];
    [btn addTarget:self action:@selector(addFullSence:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"添加全景" forState:normal];
    [btn setImage:[UIImage imageNamed:@"jiahao_yuan"] forState:normal];
    [btn setImagePosition:LXMImagePositionLeft spacing:10];
    [btn setTitleColor:[UIColor darkGrayColor] forState:normal];
    self.addbtn = btn;
    [self.view addSubview:btn];

}



#pragma mark - UICollectionViewDelegate/DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    fullSenceCollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"fullSence" forIndexPath:indexPath];

    cell.model = self.dataArray[indexPath.row];
    if (indexPath.item%2 == 1) {
        [cell.rightLineView setHidden:YES];
    } else {
        [cell.rightLineView setHidden:NO];
    }
    
    cell.editorBtn.tag = indexPath.row  + 1000;
    cell.delBtn.tag = indexPath.row + 2000;
    
    if (self.selectBtn.selected) {
        cell.nameLabel.hidden = YES;
        cell.dispalyNumberLabel.hidden = YES;
        cell.dispalyNumberNameLabel.hidden = YES;
        
        if (self.tag == 0){
            //个人中心”跳转来
            //添加全景的权限是公司中的人员都可以添加和编辑，删除权限只有总经理和经理，店铺全景也是这样
            
            NSString *impl = [[NSUserDefaults standardUserDefaults] objectForKey:@"impl"];
            NSString *implstr = [NSString stringWithFormat:@"%@",impl];
            
            if ([self.jobId integerValue] == 1002 || [self.jobId integerValue] == 1003 || [self.jobId integerValue] == 1027||[implstr isEqualToString:@"1"]) {
                
                cell.delBtn.hidden = NO;
            } else {
                cell.delBtn.hidden = YES;
            }
            cell.editorBtn.hidden = NO;
        }
        else if (self.tag == 2000){
            //添加编辑全景的权限是总经理和经理和设计师，删除权限只有总经理和经理
            
            NSString *impl = [[NSUserDefaults standardUserDefaults] objectForKey:@"impl"];
            NSString *implstr = [NSString stringWithFormat:@"%@",impl];
            
            if ([self.jobId integerValue] == 1002 || [self.jobId integerValue] == 1003 || [self.jobId integerValue] == 1027||[implstr isEqualToString:@"1"]){
                cell.delBtn.hidden = NO;
                cell.editorBtn.hidden = NO;
            }
            else{
                
                
                NSString *impl = [[NSUserDefaults standardUserDefaults] objectForKey:@"impl"];
                NSString *implstr = [NSString stringWithFormat:@"%@",impl];
                
                
                //设计师有编辑的权限
                if ([self.jobId integerValue] == 1010 || [self.jobId integerValue] == 1029||[implstr isEqualToString:@"1"]){
                    cell.editorBtn.hidden = NO;
                }
                else{
                    cell.editorBtn.hidden = YES;
                }
            }
            
        }
        else{
            cell.delBtn.hidden = YES;
            cell.editorBtn.hidden = YES;
        }
        
        
        
    }else{
    
        cell.nameLabel.hidden = NO;
        cell.dispalyNumberLabel.hidden = NO;
        cell.dispalyNumberNameLabel.hidden = NO;
        cell.editorBtn.hidden = YES;
        cell.delBtn.hidden = YES;
    
    }
    
    cell.delegate = self;
    
    return cell;
}



- ( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section {
  
    return UIEdgeInsetsMake (0 ,0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

        senceModel *model = self.dataArray[indexPath.row];
    
        //全景图
    
        senceWebViewController *sence = [[senceWebViewController alloc]init];
        sence.model = model;
        sence.companyLogo = self.companyLogo;
        sence.companyName = self.companyName;
        [self.navigationController pushViewController:sence animated:YES];
    

}


#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    senceModel *model = self.dataArray[fromIndexPath.item];
    [self.dataArray removeObjectAtIndex:fromIndexPath.item];
    [self.dataArray insertObject:model atIndex:toIndexPath.item];
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.isCanMove;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    return self.isCanMove;
}

#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did end drag");
    [self.collection reloadData];
}



#pragma mark -  数据请求
- (void)getData:(NSString *)ID {

    //参数为店铺的ID或工地id
    
    NSDictionary *dic;
    if (self.tag==2000) {
        dic = @{
                @"relId" : ID,
                @"type":@(17)
                };
    }
    else{
        dic = @{
                @"relId" : ID
                };
    }
    
    NSString *url = [BASEURL stringByAppendingString:@"img/getList.do"];
    self.dataArray = [NSMutableArray array];
    [NetManager afPostRequest:url parms:dic finished:^(id responseObj) {
        
        if ([responseObj[@"code"] integerValue] == 1000) {
           
            for (NSDictionary *dic in responseObj[@"data"][@"list"]) {
                
                senceModel *model = [[senceModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
                
            }
            
            NSDictionary *companyDict = responseObj[@"data"][@"company"];
            self.companyName = companyDict[@"companyName"];
            self.companyLogo = companyDict[@"companyLogo"];
        } else if ([responseObj[@"code"] integerValue] == 1002){
            
           [[PublicTool defaultTool] publicToolsHUDStr:@"还未上传全景" controller:self sleep:1];
        } else {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"查询出错" controller:self sleep:1];
        }
        
        [self.collection reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"网络出错。。。" controller:self sleep:1];
    }];

}



#pragma mark - CellDelegate
//编辑全景
-(void)editorCell:(NSInteger)tag{

    addFullsenceViewController *add = [[addFullsenceViewController alloc]init];
    add.model = self.dataArray[tag - 1000];
    [self.navigationController pushViewController:add animated:YES];
    
}
// 删除全景
-(void)deleteCell:(NSInteger)tag{

    
    senceModel *model = self.dataArray[tag - 2000];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除该全景后数据不可恢复，是否确认删除？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        if (self.tag==2000) {
//            [self getDeleteDataOfContrcton:model.picId index:tag-2000];
//        }
//        else{
//            [self getDeleteData:model.picId index:tag - 2000];
//        }
        
        [self getDeleteDataOfContrcton:model.picId index:tag-2000];
        
    }];
    
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}


//公司全景的删除接口
-(void)getDeleteData:(NSString *)ID index:(NSInteger )index{

    
    //参数为店铺的ID
    NSDictionary *dic = @{@"picId":ID,@"companyId":self.shopID};
    
    NSString *url = [BASEURL stringByAppendingString:@"img/delete.do"];
    
    
    [NetManager afPostRequest:url parms:dic finished:^(id responseObj) {
        
        YSNLog(@"%@",responseObj);
        NSInteger code = [responseObj[@"code"] integerValue];
        if (code == 1000) {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"删除成功" controller:self sleep:1.5];
            
            [self.dataArray removeObjectAtIndex:index];
            
        }
        else if (code == 1001) {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"图片id为空" controller:self sleep:1.5];
            
        }
        else if (code == 1002) {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"没有对应的id" controller:self sleep:1.5];
            
        }
        else if (code == 1003) {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"没有权限" controller:self sleep:1.5];
        }
        else if (code == 2000) {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1.5];
            
        }
        else{
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1];
        }

        [self.collection reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"网络出错。。。" controller:self sleep:1];
    }];
    
}

#pragma mark - 工地全景的删除接口

-(void)getDeleteDataOfContrcton:(NSString *)ID index:(NSInteger )index{
    //参数为店铺的ID
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSDictionary *dic = @{@"picId":ID,@"constructionId":self.shopID,@"agencysId":@(user.agencyId)};
    
    NSString *url = [BASEURL stringByAppendingString:@"img/deleteConstruction.do"];
    
    
    [NetManager afPostRequest:url parms:dic finished:^(id responseObj) {
        
        YSNLog(@"%@",responseObj);
        NSInteger code = [responseObj[@"code"] integerValue];
        if (code == 1000) {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"删除成功" controller:self sleep:1.5];
            
            [self.dataArray removeObjectAtIndex:index];
            
        }
        else if (code == 1001) {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
            
        }
        else if (code == 1002) {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"没有对应的数据" controller:self sleep:1.5];
            
        }
//        else if (code == 1003) {
//
//            [[PublicTool defaultTool] publicToolsHUDStr:@"没有权限" controller:self sleep:1.5];
//        }
        else if (code == 2000) {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1.5];
            
        }
        else{
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1];
        }
        
        [self.collection reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"网络出错。。。" controller:self sleep:1];
    }];
}

#pragma mark  添加全景图片

- (void)addFullSence:(UIButton *)btn {
    
    
    addFullsenceViewController *full = [[addFullsenceViewController alloc]init];
    full.shopid = self.shopID;
    full.model = nil;
    full.fromTag = self.tag;
    [self.navigationController pushViewController:full animated:YES];
    
    
}

#pragma mark - 上传顺序
- (void)uploadSortedData {
    
    NSMutableString *paramString = [NSMutableString string];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [paramString appendString:@"["];
    for (int i = 0; i < self.dataArray.count; i ++) {
        senceModel *model = self.dataArray[i];
        [dict setObject:model.picId forKey:@"picId"];
        [dict setObject:[NSString stringWithFormat:@"%d", i + 1] forKey:@"sort"];
        NSString *dictStr = [self dictionaryToJson:dict];
        [paramString appendString:dictStr];
        [paramString appendString:@","];
        [dict removeAllObjects];
    }
    paramString = [[paramString substringToIndex:(paramString.length - 1)] mutableCopy];
    [paramString appendString:@"]"];
    
    NSString *url = [BASEURL stringByAppendingString:@"img/upImgSort.do"];
    NSDictionary *dic = @{@"imgList":paramString};
//    YSNLog(@"paraDic: %@", dic);
    [NetManager afPostRequest:url parms:dic finished:^(id responseObj) {
        
//        YSNLog(@"%@",responseObj);
        if ([responseObj[@"code"] integerValue] == 1000) {
            YSNLog(@"----");
        }else{
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"修改失败，重试一次吧"];
        }
        
        [self.collection reloadData];
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - 添加底部视图
- (void)addBottomView {
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight - 50, BLEJWidth, 50)];
    bottomView.backgroundColor = White_Color;
    [self.view addSubview:bottomView];
    
   
        
        UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, bottomView.height)];
        [phoneBtn setImage:[UIImage imageNamed:@"bottomPhone"] forState:UIControlStateNormal];
        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [phoneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [phoneBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
        [phoneBtn addTarget:self action:@selector(didClickPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:phoneBtn];
        
        UIButton *priceBtn = [[UIButton alloc] initWithFrame:CGRectMake(phoneBtn.right, 0, (BLEJWidth - phoneBtn.right) * 0.5, bottomView.height)];
        priceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        priceBtn.backgroundColor = kCustomColor(242, 105, 71);
        [priceBtn setTitleColor:White_Color forState:UIControlStateNormal];
        [priceBtn setTitle:@"免费报价" forState:UIControlStateNormal];
        [priceBtn addTarget:self action:@selector(didClickPriceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:priceBtn];
        
        UIButton *houseBtn = [[UIButton alloc] initWithFrame:CGRectMake(priceBtn.right, 0, priceBtn.width, bottomView.height)];
        houseBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        houseBtn.backgroundColor = kMainThemeColor;
        [houseBtn setTitleColor:White_Color forState:UIControlStateNormal];
        [houseBtn setTitle:@"在线预约" forState:UIControlStateNormal];

        [houseBtn addTarget:self action:@selector(didClickAppointmentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:houseBtn];
//       if ([self.companyType isEqualToString:@"1018"] || [self.companyType isEqualToString:@"1065"] || [self.companyType isEqualToString:@"1064"]) {
//    } else {
//        
//        UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, bottomView.height)];
//        [phoneBtn setImage:[UIImage imageNamed:@"bottomPhone"] forState:UIControlStateNormal];
//        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [phoneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [phoneBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
//        [phoneBtn addTarget:self action:@selector(didClickPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [bottomView addSubview:phoneBtn];
//        
//        UIButton *appointmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(phoneBtn.right, 0, BLEJWidth - phoneBtn.right, bottomView.height)];
//        appointmentBtn.titleLabel.font = [UIFont systemFontOfSize:18];
//        appointmentBtn.backgroundColor = kMainThemeColor;
//        [appointmentBtn setTitleColor:White_Color forState:UIControlStateNormal];
//        [appointmentBtn setTitle:@"在线预约" forState:UIControlStateNormal];
//        [appointmentBtn addTarget:self action:@selector(didClickAppointmentBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [bottomView addSubview:appointmentBtn];
//    }
}

#pragma mark - 底部视图的点击事件
- (void)didClickPhoneBtn:(UIButton *)btn {// 电话咨询
    
    [self.phoneArr removeAllObjects];
    
    NSString *landLine = [self.dataDic objectForKey:@"companyLandline"];
    NSString *managerLine = [self.dataDic objectForKey:@"companyPhone"];
    
    if (!(!landLine || [landLine isKindOfClass:[NSNull class]] || [landLine isEqualToString:@""])) {
        [self.phoneArr addObject:landLine];
    }
    if (!(!managerLine || [managerLine isKindOfClass:[NSNull class]] || [managerLine isEqualToString:@""])) {
        [self.phoneArr addObject:managerLine];
    }
    
    if (self.phoneArr.count == 0) {
        return;
    }
    UIActionSheet *actionSheet;
    if (self.phoneArr.count == 1) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], nil];
    } else {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], self.phoneArr[1], nil];
    }
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (self.phoneArr.count == 1) {
        if (buttonIndex == 0) {
            
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArr[0]];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        } else {
            
        }
    } else {
        
        if (buttonIndex == 0) {
            
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArr[0]];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        } else if (buttonIndex == 1) {
            
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArr[1]];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        } else {
            
        }
    }
}


- (void)didClickAppointmentBtn:(UIButton *)btn {// 预约
    
//    DecorateNeedViewController *vc = [[DecorateNeedViewController alloc] init];
//    vc.companyType = self.companyType;
//    vc.companyID = self.shopID;
//    [self.navigationController pushViewController:vc animated:YES];
    
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
    
    // 在线预约浏览量
    [NSObject needDecorationStatisticsWithConpanyId:self.shopID];
}

- (void)didClickPriceBtn:(UIButton *)btn {// 装修
    
    // 装修报价
    if (self.code == 1000) {
        
      
            
            BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
            VC.origin = self.origin;
            VC.baseItemsArr = self.baseItemsArr;
            VC.suppleListArr = self.suppleListArr;
        VC.calculatorModel= self.calculatorModel;
            VC.constructionCase = self.constructionCase;
            VC.companyID = self.shopID;
            VC.topImageArr = self.topCalculatorImageArr;
            VC.bottomImageArr = self.bottomCalculatorImageArr;
            VC.isConVip = self.companyDic[@"conVip"];
            [self.navigationController pushViewController:VC animated:YES];
//          if ([self.calculatorTempletModel.templetStatus isEqualToString:@"2"]) {
//        } else {
//
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司没有设置简装/精装报价"];
//        }
    } else if (self.code == -1) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"网络不畅，请稍后重试"];
    } else {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司没有设置模板"];
    }
}

- (void)didClickHouseBtn:(UIButton *)btn {// 量房
    
    DecorateNeedViewController *decoration = [[DecorateNeedViewController alloc]init];
    decoration.companyID = self.shopID;
    decoration.areaList = self.areaList;
    decoration.companyType = self.companyType;
    [self.navigationController pushViewController:decoration animated:YES];
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
    [param setObject:self.dataDic[@"companyId"] forKey:@"companyId"];
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
    [dic setObject:self.dataDic[@"companyId"] forKey:@"companyId"];
    [dic setObject:self.dataDic[@"companyType"] forKey:@"companyType"];
    [dic setObject:@(proType) forKey:@"proType"];
    [dic setObject:@"0" forKey:@"agencyId"];
    [dic setObject:@"0" forKey:@"callPage"];
    [self upDataRequest:dic];
}

- (void)upDataRequest:(NSMutableDictionary *)dic {
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    __weak typeof(self)  weakSelf = self;
      [dic setObject:self.origin?:@"0" forKey:@"origin"];
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
                completionVC.companyType = weakSelf.dataDic[@"companyType"];
                NSString *constructionType = weakSelf.companyDic[@"constructionType"];
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
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"预约修失败，稍后重试"];
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

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂未上传全景内容";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
@end
