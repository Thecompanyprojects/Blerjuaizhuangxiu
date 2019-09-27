//
//  OwnerDiaryController.m
//  iDecoration
//  //业主日志
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "OwnerDiaryController.h"
#import "OwnerDiaryCell.h"
#import "YPCommentView.h"
#import "TZImagePickerController.h"
#import "OwnerDiaryModel.h"

#import "ASProgressPopUpView.h"
#import "NSObject+CompressImage.h"

@interface OwnerDiaryController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,OwnerDiaryCellDelegate,ASProgressPopUpViewDataSource>{
    BOOL isHavePower;//是否是业主
    
    BOOL editOrSuccess; //no:未编辑状态 yes：编辑状态
    
    BOOL isFirstEdit;
    CGFloat textviewH;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;//原始数组
@property (nonatomic, strong) NSMutableArray *tempDataArray;//临时的数组
@property (nonatomic, strong) NSMutableDictionary *textviewHDict;

@property (nonatomic, strong) ASProgressPopUpView *progress;
@property (nonatomic, strong) UIView *backShadowV;

@property (nonatomic, strong)UIButton *successBtn;
@property (nonatomic, strong) UIButton *continueBtn;
@end

@implementation OwnerDiaryController

- (void)viewDidLoad {
    [super viewDidLoad];
    isHavePower = NO;
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    self.tempDataArray = [NSMutableArray array];
    self.textviewHDict = [NSMutableDictionary dictionary];
    [self creatUI];
//    [self judgeOwnerPower];
    
    if (self.isComplate) {
        isHavePower = NO;
        self.successBtn.hidden = YES;
    }
    else{
        isHavePower = self.isYezhu;
        if (!isHavePower) {
            self.successBtn.hidden = YES;
        }
        else{
            self.successBtn.hidden = NO;
        }
        
    }
    
    [self getOwnerList];
}

-(void)creatUI{
    self.view.backgroundColor = White_Color;
    self.title = @"业主日志";
    [self.view addSubview:self.tableView];
    
    UIButton *successBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    successBtn.frame = CGRectMake(0, 0, 44, 44);
    [successBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [successBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    successBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    successBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    successBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    successBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [successBtn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    self.successBtn = successBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.successBtn];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tempDataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *rowStr = [NSString stringWithFormat:@"%ld",indexPath.row];
    CGFloat temH = [[self.textviewHDict objectForKey:rowStr] floatValue];
    
    return temH;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (!isHavePower) {
        return 0;
    }else{
        if (!editOrSuccess) {
            return 0;
        }
        else{
            return 30;
        }
        
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footV = [[UIView alloc]init];
    if (!_continueBtn) {
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueBtn.frame = CGRectMake(kSCREEN_WIDTH-100, 0, 80, 30);
        [_continueBtn setTitle:@"继续添加" forState:UIControlStateNormal];
//        _continueBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_continueBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        _continueBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        _continueBtn.backgroundColor = White_Color;
        //                [_addressBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
        [_continueBtn addTarget:self action:@selector(continueBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [footV addSubview:self.continueBtn];
    
    if (!isHavePower) {
        self.continueBtn.hidden = YES;
    }else{
        if (!editOrSuccess) {
            self.continueBtn.hidden = YES;
        }
        else{
            self.continueBtn.hidden = NO;
        }
        
    }if (section==0) {
        return footV;
    }
    return [[UITableViewHeaderFooterView alloc]init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OwnerDiaryCell *cell = [OwnerDiaryCell cellWithTableView:tableView indexpath:indexPath];
    cell.delegate = self;
    cell.path = indexPath;
    OwnerDiaryModel *model = self.tempDataArray[indexPath.row];
    
    BOOL isShowAdd = NO;
    if (!isHavePower) {
        cell.photosView.isShowDeleteBtn = YES;
        cell.photosView.isShowZongAddBtn = NO;
        isShowAdd = NO;
        cell.saySomeV.userInteractionEnabled = NO;
//        cell.continueAddBtn.hidden = YES;
    }else{
        if (!editOrSuccess) {
            cell.photosView.isShowDeleteBtn = YES;
            cell.photosView.isShowZongAddBtn = NO;
            isShowAdd = NO;
            cell.saySomeV.userInteractionEnabled = NO;
//            cell.continueAddBtn.hidden = YES;
        }
        else{
            cell.photosView.isShowDeleteBtn = NO;
            cell.photosView.isShowZongAddBtn = YES;
            isShowAdd = YES;
            cell.saySomeV.userInteractionEnabled = YES;
        }
        
        
    }
    if (model.imgList.count>=9) {
        isShowAdd = NO;
    }
    
    [cell configWith:model isShowAdd:isShowAdd];
    textviewH = cell.cellH;
    
    NSString *rowStr = [NSString stringWithFormat:@"%ld",indexPath.row];
    if ([[self.textviewHDict allKeys] containsObject:rowStr]) {
        [self.textviewHDict removeObjectForKey:rowStr];
    }
    [self.textviewHDict setObject:@(textviewH) forKey:rowStr];
    
    
    return cell;
}

#pragma mark - OwnerDiaryCellDelegate

-(void)addPhotoWithPath:(NSIndexPath *)path{
    if (!isHavePower) {
        return;
    }
    __weak OwnerDiaryController *weakSelf=self;
    // 调用相册
    OwnerDiaryModel *model = weakSelf.tempDataArray[path.row];
    NSArray *picList = model.imgList;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9-picList.count delegate:nil];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [weakSelf uploadImgWith:photos row:path.row];
        
    }];
    
    
    
    if (picList.count>8) {
                //            [weakSelf showToast:@"最多上传9张图片"];
                [[PublicTool defaultTool] publicToolsHUDStr:@"最多上传9张图片" controller:weakSelf sleep:1.5];
                return ;
            }
    [weakSelf presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)deletePhotoWith:(NSInteger)deleteTag path:(NSIndexPath *)path{
    if (!isHavePower) {
        return;
    }
//    if (_editOrAdd==1) {
//        [self.tempConstructionImgV removeObjectAtIndex:deleteTag];
//    }
//    else{
//        [self.constructionImgV removeObjectAtIndex:deleteTag];
//    }
    OwnerDiaryModel *model = self.tempDataArray[path.row];
    NSArray *picList = model.imgList;
    NSMutableArray *temArray = [NSMutableArray arrayWithArray:picList];
    [temArray removeObjectAtIndex:deleteTag];
    NSArray *finallyArray = [temArray copy];
    
    model.imgList = finallyArray;
    
    [self.tempDataArray replaceObjectAtIndex:path.row withObject:model];
//    
//    //一个cell刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:path.row inSection:0];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}

-(void)lookPhoto:(NSInteger)index imgArray:(NSMutableArray *)imgArray path:(NSIndexPath *)path{
    
    __weak OwnerDiaryController *weakSelf=self;
    
    OwnerDiaryModel *model = weakSelf.tempDataArray[path.row];
    NSArray *picList = model.imgList;
    
    NSMutableArray *tempPicListArray = [NSMutableArray array];
    for (NSDictionary *dict in picList) {
        NSString *str = [dict objectForKey:@"picUrl"];
        [tempPicListArray addObject:str];
    }
    
    YPImagePreviewController *yvc = [[YPImagePreviewController alloc]init];
    NSArray *temArray = [tempPicListArray copy];
    yvc.images = temArray;
    yvc.index = index ;
    UINavigationController *uvc = [[UINavigationController alloc]initWithRootViewController:yvc];
    [weakSelf presentViewController:uvc animated:YES completion:nil];
}

-(void)saveContentWith:(NSIndexPath *)path content:(NSString *)content{
    YSNLog(@"%@%@",path,content);
    
    if (!isHavePower) {
        return;
    }
    OwnerDiaryModel *model = self.tempDataArray[path.row];
        model.content = content;
        [self.tempDataArray replaceObjectAtIndex:path.row withObject:model];
    
    
    //一个cell刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:path.row inSection:0];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}

-(void)continueBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    NSInteger count = self.tempDataArray.count;
    OwnerDiaryModel *model = self.tempDataArray[count-1];
    if (model.content.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请填写当前内容信息" controller:self sleep:1.5];
        return;
    }
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    OwnerDiaryModel *newModel = [[OwnerDiaryModel alloc]init];
    newModel.logId = @"0";
    newModel.content = @"";
    newModel.constructionId = [NSString stringWithFormat:@"%ld",(long)self.consID];
    newModel.agencysId = [NSString stringWithFormat:@"%ld",(long)user.agencyId];
    NSArray *picListArray = [NSArray array];
    newModel.imgList = picListArray;
    [self.tempDataArray addObject:newModel];
    
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}

//-(void)continueAddWithPath:(NSIndexPath *)path{
//    [self.view endEditing:YES];
//    OwnerDiaryModel *model = self.tempDataArray[path.row];
//    if (model.content.length<=0) {
//        [[PublicTool defaultTool] publicToolsHUDStr:@"请填写当前内容信息" controller:self sleep:1.5];
//        return;
//    }
//    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
//    OwnerDiaryModel *newModel = [[OwnerDiaryModel alloc]init];
//    newModel.logId = @"0";
//    newModel.content = @"";
//    newModel.constructionId = [NSString stringWithFormat:@"%ld",(long)self.consID];
//    newModel.agencysId = [NSString stringWithFormat:@"%ld",(long)user.agencyId];
//    NSArray *picListArray = [NSArray array];
//    newModel.imgList = picListArray;
//    [self.tempDataArray addObject:newModel];
//    
//    //一个section刷新
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//}

-(void)deleteModelWithPath:(NSIndexPath *)path{
    
    [self.tempDataArray removeObjectAtIndex:path.row];
    if (self.tempDataArray.count<=0) {
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        OwnerDiaryModel *newModel = [[OwnerDiaryModel alloc]init];
        newModel.logId = @"0";
        newModel.content = @"";
        newModel.constructionId = [NSString stringWithFormat:@"%ld",(long)self.consID];
        newModel.agencysId = [NSString stringWithFormat:@"%ld",(long)user.agencyId];
        NSArray *picListArray = [NSArray array];
        newModel.imgList = picListArray;
        [self.tempDataArray addObject:newModel];
    }
    
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}

#pragma mark - action

-(void)finishClick{
    [self.view endEditing:YES];
    
    if (editOrSuccess == NO) {
        editOrSuccess = YES;
        
        //有权限，并且是编辑状态，才显示+按钮，和右上角的-按钮
        
//        if (isHavePower&&editOrSuccess){
//            self.photosView.isShowAddBtn = YES;
//        }
//        else{
//            self.photosView.isShowAddBtn = NO;
//        }
        [self.successBtn setTitle:@"提交" forState:UIControlStateNormal];
        //        [self resetInfoScrV];
        [self.tableView reloadData];
    }
    else{
        [self postData];
    }
    
}

#pragma mark - 提交业主日志

-(void)postData{
    NSMutableArray *deleteArray = [NSMutableArray array];
    NSMutableArray *postArray = [NSMutableArray array];
    NSInteger count = self.tempDataArray.count;
    if (count<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请填写内容后提交" controller:self sleep:1.5];
        return;
    }
    
    
    
    
    BOOL isHaveContent = false;//是否存在有图片没内容的
    for (int i = 0; i<self.tempDataArray.count; i++) {
        OwnerDiaryModel *tempModel = self.tempDataArray[i];
        NSInteger count = tempModel.imgList.count;
        if (tempModel.content.length<=0&&count>0) {
            isHaveContent = YES;
            break;
        }
        else{
            isHaveContent = NO;
        }
    }
    if (isHaveContent) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"有图片的必须有内容哦" controller:self sleep:1.5];
        return;
    }
    
    NSMutableArray *temDeleteARR = [NSMutableArray array];
    for (int i = 0; i<self.tempDataArray.count; i++) {
        OwnerDiaryModel *tempModel = self.tempDataArray[i];
        NSArray *picArr = tempModel.imgList;
        if (tempModel.content.length<=0&&picArr.count<=0) {
            [temDeleteARR addObject:tempModel];
        }
    }
    
    [self.tempDataArray removeObjectsInArray:temDeleteARR];
    
    
    
    for (OwnerDiaryModel *model in self.tempDataArray) {
        NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
        NSString *picUrlStr = @"";
        if (model.imgList.count<=0) {
            picUrlStr = @"";
        }else{
            for (int i = 0; i<model.imgList.count; i++) {
                NSDictionary *dict = model.imgList[i];
                NSString *temStr = dict[@"picUrl"];
                if (i==0) {
                    picUrlStr = temStr;
                }else{
                    picUrlStr = [picUrlStr stringByAppendingString:[NSString stringWithFormat:@",%@",temStr]];
                }
            }
        }
        [addDict setObject:model.logId forKey:@"logId"];
        [addDict setObject:model.content forKey:@"content"];
        [addDict setObject:picUrlStr forKey:@"imgList"];
        [postArray addObject:addDict];
    }
    
    
    
    
    if (self.dataArray.count<=0) {
        
    }
    else{
        for (OwnerDiaryModel *tempModel in self.dataArray) {
            if (![self.tempDataArray containsObject:tempModel]) {
                [deleteArray addObject:tempModel];
            }
        }
    }
    
    if (deleteArray.count<=0) {
        
    }else{
        for (OwnerDiaryModel *tempModel in deleteArray) {
            NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
            [addDict setObject:tempModel.logId forKey:@"logId"];
            [addDict setObject:@"" forKey:@"content"];
            [addDict setObject:@"" forKey:@"imgList"];
            [postArray addObject:addDict];
        }
    }
    [self.view hudShow];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSDictionary *finallyDict = @{@"constructionId":@(self.consID),@"agencysId":@(user.agencyId),@"contents":postArray};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finallyDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSString *temUrl = @"http://192.168.1.175:8080/blej-api-blej/api/";
    NSString *defaultApi = [BASEURL stringByAppendingString:@"ownerLog/saveList.do"];

    NSDictionary *paramDic = @{@"jsonList":jsonStr
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"填写成功" controller:self sleep:1.5];
                    
//                    editOrSuccess = NO;
//                    [self.successBtn setTitle:@"编辑" forState:UIControlStateNormal];
//                    [self.tableView reloadData];
                    [self getOwnerList];
//                    [self.navigationController popViewControllerAnimated:YES];
                }
                    
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                default:
                    [[PublicTool defaultTool] publicToolsHUDStr:@"填写失败" controller:self sleep:1.5];
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        YSNLog(@"%@",errorMsg);
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - 是否是业主
//-(void)judgeOwnerPower{
//    NSString *defaultApi = [BASEURL stringByAppendingString:@"constructionPerson/getJobType.do"];
//    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
//    NSDictionary *paramDic = @{@"cpPersonId":@(user.agencyId),
//                               @"constructionId":@(self.consID)
//                               };
//    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
//        
//        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
//            
//            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
//            
//            switch (statusCode) {
//                case 1000:
//                    
//                {
//                    
//                    if (self.isComplate) {
//                        isHavePower = NO;
//                        self.successBtn.hidden = YES;
//                    }
//                    else{
//                        isHavePower = YES;
//                        self.successBtn.hidden = NO;
//                    }
//                }
//                    ////                    NSDictionary *dic = [NSDictionary ]
//                    break;
//                    
//                case 1001:
//                    
//                {
//                    isHavePower = NO;
//                    self.successBtn.hidden = YES;
//                }
//                    ////                    NSDictionary *dic = [NSDictionary ]
//                    break;
//                    
//                case 2000:
//                    
//                {
//                    [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
//                }
//                    ////                    NSDictionary *dic = [NSDictionary ]
//                    break;
//                    
//                default:
//                    break;
//            }
//            
//            
//            
//            
//            
//        }
//        
//        //        NSLog(@"%@",responseObj);
//    } failed:^(NSString *errorMsg) {
//        
//    }];
//}

#pragma mark - 获取业主日志

-(void)getOwnerList{
    [self.dataArray removeAllObjects];
    [self.tempDataArray removeAllObjects];
    [self.view hudShow];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"ownerLog/getByConstructionId.do"];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        YSNLog(@"%@",responseObj);
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    if ([responseObj[@"data"] isKindOfClass:[NSArray class]]){
                        NSArray *array = responseObj[@"data"];
                        
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[OwnerDiaryModel class] json:array];
                        [self.dataArray addObjectsFromArray:arr];
                        [self.tempDataArray addObjectsFromArray:self.dataArray];
                        
                        if (self.tempDataArray.count<=0) {
                            UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
                            OwnerDiaryModel *model = [[OwnerDiaryModel alloc]init];
                            model.logId = @"0";
                            model.content = @"";
                            model.constructionId = [NSString stringWithFormat:@"%ld",(long)self.consID];
                            model.agencysId = [NSString stringWithFormat:@"%ld",(long)user.agencyId];
                            NSArray *picListArray = [NSArray array];
                            model.imgList = picListArray;
                            [self.tempDataArray addObject:model];
                            
                            isFirstEdit = YES;
                            
                            editOrSuccess = YES;
                            [self.successBtn setTitle:@"提交" forState:UIControlStateNormal];
                        }
                        else{
                            isFirstEdit = NO;
                            
                            editOrSuccess = NO;
                            [self.successBtn setTitle:@"编辑" forState:UIControlStateNormal];
                        }
                        
                    }
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                default:
                    break;
            }
            
            [self.tableView reloadData];
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - ASProgressPopUpView dataSource

// <ASProgressPopUpViewDataSource> is entirely optional
// it allows you to supply custom NSStrings to ASProgressPopUpView
- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *s;
    //    if (progress < 0.2) {
    //        s = @"Just starting";
    //    } else if (progress > 0.4 && progress < 0.6) {
    //        s = @"About halfway";
    //    } else if (progress > 0.75 && progress < 1.0) {
    //        s = @"Nearly there";
    //    } else if (progress >= 1.0) {
    //        s = @"Complete";
    //    }
    NSString *temStr = [NSString stringWithFormat:@"%.2f",progress];
    NSInteger temInt = [temStr integerValue]*100;
    
    
    s = [NSString stringWithFormat:@"%ld",(long)temInt];
    s = [s stringByAppendingString:@"%"];
    s = [NSString stringWithFormat:@"%f",progress];
    return s;
}

// by default ASProgressPopUpView precalculates the largest popUpView size needed
// it then uses this size for all values and maintains a consistent size
// if you want the popUpView size to adapt as values change then return 'NO'
- (BOOL)progressViewShouldPreCalculatePopUpViewSize:(ASProgressPopUpView *)progressView;
{
    return NO;
}


#pragma mark - 图片上传
- (void)uploadImgWith:(NSArray *)imgArray row:(NSInteger)row{
    //    NSLog(@"名字:%@ 和身份证号:%@", name, idNum);
    // －－－－－－－－－－－－－－－－－－－－－－－－－－－－上传图片－－－－
    /*
     此段代码如果需要修改，可以调整的位置
     1. 把upload.php改成网站开发人员告知的地址
     2. 把name改成网站开发人员告知的字段名
     */
    // 查询条件
    //    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", idNum, @"idNumber", nil];
    
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"file/uploadFiles.do"];
    
    
    [self.view addSubview:self.backShadowV];
    [self.view addSubview:self.progress];
    self.backShadowV.alpha = 0.5f;
    self.progress.progress = 0.0;
    
    // 在parameters里存放照片以外的对象
    [manager POST:defaultApi parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < imgArray.count; i++) {
            
            UIImage *image = imgArray[i];
//            NSData *imageData = UIImageJPEGRepresentation(image, PHOTO_COMPRESS);
            NSData *imageData = [NSObject imageData:image];
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"]; //
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        YSNLog(@"---上传进度--- %@",uploadProgress);
        YSNLog(@"%f",uploadProgress.fractionCompleted);
        NSString *temStr = [NSString stringWithFormat:@"%.2f",uploadProgress.fractionCompleted];
        CGFloat progress = [temStr floatValue];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progress setProgress:progress animated:YES];
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        YSNLog(@"```上传成功``` %@",responseObject);
        
        [self.progress removeFromSuperview];
        self.backShadowV.alpha = 0.0f;
        [self.backShadowV removeAllSubViews];
        
        NSArray *arr = [responseObject objectForKey:@"imgList"];
        //        NSMutableArray *imgArr = [NSMutableArray array];
        //        [imgArr removeAllObjects];
        OwnerDiaryModel *model = self.tempDataArray[row];
        NSArray *picList = model.imgList;
        NSMutableArray *temppicList = [NSMutableArray arrayWithArray:picList];
        for (NSDictionary *dict in arr) {
            //            [imgArr addObject:[dict objectForKey:@"imgUrl"]];
            NSDictionary *tempDict = @{@"picUrl":[dict objectForKey:@"imgUrl"]};
            [temppicList addObject:tempDict];
            
        }
        NSArray *finallyArray = [temppicList copy];
        model.imgList = finallyArray;
        [self.tempDataArray replaceObjectAtIndex:row withObject:model];
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传成功" controller:self sleep:1.5];
        //        [self postData];
        //一个cell刷新
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YSNLog(@"xxx上传失败xxx %@", error);
        [self.progress removeFromSuperview];
        self.backShadowV.alpha = 0.0f;
        [self.backShadowV removeAllSubViews];
        
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}




-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,kSCREEN_WIDTH,kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = White_Color;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

-(ASProgressPopUpView *)progress{
    if (!_progress) {
        _progress = [[ASProgressPopUpView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/4, kSCREEN_HEIGHT/2, kSCREEN_WIDTH/2, 10)];
        _progress.font = [UIFont systemFontOfSize:16];
        _progress.popUpViewAnimatedColors = @[Main_Color];
        _progress.dataSource = self;
        [_progress showPopUpViewAnimated:YES];
    }
    return _progress;
}

-(UIView *)backShadowV{
    if (!_backShadowV) {
        _backShadowV = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_HEIGHT, kSCREEN_HEIGHT-64)];
        _backShadowV.backgroundColor = COLOR_BLACK_CLASS_0;
        _backShadowV.alpha = 0.5;
    }
    return _backShadowV;
}

@end
