//
//  DesignImageViewController.m
//  iDecoration
//
//  Created by RealSeven on 2017/4/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DesignImageViewController.h"
#import "DesignTitleHeaderView.h"
#import "ExplainTableViewCell.h"
#import "ConstructionImageTableViewCell.h"
#import "UploadImageApi.h"
#import "GTMBase64.h"
#import "ZZPhotoController.h"
#import "CaseDesignModel.h"
#import "YPCommentView.h"
#import "TZImagePickerController.h"
#import "DesignIntroduceCell.h"
#import "ASProgressPopUpView.h"
#import "NSObject+CompressImage.h"

float progressFloat = 0.0f;

#define NormalAnimation(_inView,_duration,_option,_frames)            [UIView transitionWithView:_inView duration:_duration options:_option animations:^{ _frames    }

@interface DesignImageViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ConstructionImageTableViewCellDelegate,DesignIntroduceCellDelegate,UIAlertViewDelegate,ASProgressPopUpViewDataSource>
{
    NSInteger _addDesignPORDesign;//1:添加的是设计师的图片 2:添加的是设计的图片
    NSInteger _editOrAdd;//1:这是编辑  2:这是添加
    
    NSIndexPath* _designPth;
    BOOL isHavePower;//是否有权限
    
    BOOL editOrSuccess; //no:未编辑状态 yes：编辑状态
    
    CGFloat DesignIntroduceCellH;
    CGFloat DesignerCellH;//
    CGFloat constructCellH;//
    NSInteger lookTag;//是否可见 是否所有人可见(0:所有人可见,1:部分人可见)
    
}

@property (nonatomic, strong)UIButton *successBtn;

@property (nonatomic, strong) UITableView *designTableView;
@property (nonatomic, copy) NSString *explainStr;
@property (nonatomic, copy) NSString *designPersonImgStr;

@property (nonatomic, copy) NSString *designPersonImgV;//设计师说明图片
@property (nonatomic, strong) NSMutableArray *constructionImgV;//施工图数组
@property (nonatomic, strong) NSMutableArray *designImgV;//设计说明数组

@property (nonatomic, strong) NSMutableArray *tempConstructionImgV;//临时施工图数组
@property (nonatomic, strong) NSMutableArray *tempDesignImgV;//临时设计说明数组

@property (nonatomic, strong) NSMutableDictionary *DesignIntroHDict;//设计说明cellh字典
@property (nonatomic, strong) UIView *backgroundV;
@property (nonatomic, strong) UIView *hideV;


@property (nonatomic, strong) ASProgressPopUpView *progress;
@property (nonatomic, strong) UIView *backShadowV;



//底部的cctv图
@property (nonatomic, strong)UIView *bottomLogoV;
@property (nonatomic, strong)UIImageView *bottomLogoImg;

@property (nonatomic, strong) NSArray *imageArr;
@end

@implementation DesignImageViewController

-(NSArray*)imageArr{
    
    if (!_imageArr) {
        _imageArr = [NSArray array];
    }
    return _imageArr;
}


-(NSMutableArray*)constructionImgV{
    
    if (!_constructionImgV) {
        _constructionImgV = [NSMutableArray array];
    }
    return _constructionImgV;
}

-(NSMutableArray*)designImgV{
    
    if (!_designImgV) {
        _designImgV = [NSMutableArray array];
    }
    return _designImgV;
}

-(NSMutableArray*)tempConstructionImgV{
    
    if (!_tempConstructionImgV) {
        _tempConstructionImgV = [NSMutableArray array];
    }
    return _tempConstructionImgV;
}

-(NSMutableArray*)tempDesignImgV{
    
    if (!_tempDesignImgV) {
        _tempDesignImgV = [NSMutableArray array];
    }
    return _tempDesignImgV;
}

-(NSMutableDictionary*)DesignIntroHDict{
    
    if (!_DesignIntroHDict) {
        _DesignIntroHDict = [NSMutableDictionary dictionary];
    }
    return _DesignIntroHDict;
}

-(NSArray*)assetArray{
    
    if (!_assetArray) {
        _assetArray = [NSArray array];
    }
    return _assetArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    // 这里统一设置键盘处理
    //    manager.toolbarDoneBarButtonItemText = @"完成";
    //    manager.toolbarTintColor = kMainThemeColor;
    manager.enable = NO;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = NO;//这个是它自带键盘工具条开关
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    // 这里统一设置键盘处理
    manager.toolbarDoneBarButtonItemText = @"完成";
    manager.toolbarTintColor = kMainThemeColor;
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = YES;//这个是它自带键盘工具条开关
    

}

-(void)createUI{
    
    self.title = @"本案设计";
    self.view.backgroundColor = Bottom_Color;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.isComplate) {
        //完工，没权限
        isHavePower = NO;
    }
    else{
        isHavePower = self.isPower;
    }
    editOrSuccess = NO;
    lookTag = 0;
    
    UIButton *successBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    successBtn.frame = CGRectMake(0, 0, 44, 44);
    [successBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [successBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    successBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    successBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    successBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    successBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [successBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
    self.successBtn = successBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.successBtn];
    
    // 单独处理这里的返回按钮(因为需要返回到根控制器)
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
    if (isHavePower) {
        self.successBtn.hidden = NO;
    }
    else{
        self.successBtn.hidden = YES;
    }
    
//    [self getDesignPower];
    
    self.designPersonImgV = @"";
    
    [self createTableView];
    [self requestData];
}

-(NSArray*)getImageFromAsset:(NSArray*)assetArr{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (PHAsset *asset in assetArr) {
        
        [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            [arr addObject:result];
        }];
    }
    
    UIImage *image = [UIImage imageNamed:@"jia1"];
    
    if (![arr containsObject:image]) {
        [arr addObject:image];
    }
    
    return arr;
}

-(void)createTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = Bottom_Color;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view addSubview:tableView];
    
    [tableView registerClass:[DesignTitleHeaderView class] forHeaderFooterViewReuseIdentifier:@"DesignTitleHeaderView"];
    [tableView registerClass:[ExplainTableViewCell class] forCellReuseIdentifier:@"ExplainTableViewCell"];
    [tableView registerClass:[ConstructionImageTableViewCell class] forCellReuseIdentifier:@"ConstructionImageTableViewCell"];
    
    self.designTableView = tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    if (section == 2) {
//        if (_editOrAdd==1) {
//            NSInteger count = self.tempDesignImgV.count;
//            return count;
//        }
//        else{
//            NSInteger count = self.designImgV.count;
//            return count;
//        }
        NSInteger count = self.tempDesignImgV.count;
        return count;
        
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 3) {
        return 5;
    }else{
        return 30;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==2) {
        return 60;
    }
    return 0.0000000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return DesignerCellH;
    }else if (indexPath.section == 1){
        
//        NSInteger row = 0;
//        
//        
//        if (self.tempConstructionImgV.count < 3) {
//            row = 1;
//        }else{
//            row = self.tempConstructionImgV.count/3 + 1;
//        }
//        
//        
//        
//        return row *(kSCREEN_WIDTH/3)+30;
        return constructCellH;
    }
    else{
        NSString *keyStr = [NSString stringWithFormat:@"%ld",indexPath.row];
        CGFloat hh = [[self.DesignIntroHDict objectForKey:keyStr] floatValue];
        return hh;
//        return DesignIntroduceCellH;
    }
    return 200;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        DesignTitleHeaderView *designHeader = (DesignTitleHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DesignTitleHeaderView"];
        designHeader.titleLabel.text = @"设计师说明";
        
        return designHeader;
    }
    
    if (section == 1) {
        DesignTitleHeaderView *designHeader = (DesignTitleHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DesignTitleHeaderView"];
        designHeader.titleLabel.text = @"施工图";
        
        return designHeader;
    }
    
    if (section == 2) {
        DesignTitleHeaderView *designHeader = (DesignTitleHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DesignTitleHeaderView"];
        designHeader.titleLabel.text = @"设计说明";
        
        return designHeader;
    }
    
    return [[UITableViewHeaderFooterView alloc]init];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==2) {
        if (!_bottomLogoV) {
            _bottomLogoV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 60)];
        }
        if (!_bottomLogoImg) {
            _bottomLogoImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kSCREEN_WIDTH, 40)];
            [_bottomLogoV addSubview:_bottomLogoImg];
        }
//        _bottomLogoImg.image =[UIImage imageNamed:@"bottomLogo"];
//        [_bottomLogoImg sizeToFit];
//        _bottomLogoImg.left = kSCREEN_WIDTH/2-_bottomLogoImg.width/2;
//        _bottomLogoImg.top = 30-_bottomLogoImg.height/2;
        return _bottomLogoV;
    }
    else{
        return [[UITableViewHeaderFooterView alloc]init];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak DesignImageViewController *weakSelf = self;
    
    if (indexPath.section == 0) {
        
        ExplainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExplainTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        [cell.explainImageView sd_setImageWithURL:[NSURL URLWithString:self.designPersonImgV] placeholderImage:[UIImage imageNamed:@"jia-kong.png"]];
        [cell configWith:self.designPersonImgV];
        DesignerCellH = cell.cellH;
        
        
        if (isHavePower) {
            
            if (!editOrSuccess) {
                cell.explainImageView.userInteractionEnabled = NO;
            }
            else{
                cell.explainImageView.userInteractionEnabled = YES;
                cell.addBlock = ^{
                    
                    _addDesignPORDesign = 1;
                    [weakSelf imagePicker];
                    
                };
            }
            
        }
        else{
            cell.explainImageView.userInteractionEnabled = NO;
        }
        
       
        
        cell.delBlock = ^{
            
//            [weakSelf deleteImage];
        };
                
        return cell;
    }
    
    else if (indexPath.section == 1) {
        
        ConstructionImageTableViewCell *cell = [ConstructionImageTableViewCell cellWithTableView:tableView indexpath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
        
        if (!isHavePower) {
            
            cell.photosView.isShowDeleteBtn = YES;
            cell.photosView.isShowZongAddBtn = NO;
//            cell.photosView.isShowAddBtn = NO;
        }
        else{
            if (!editOrSuccess) {
                cell.photosView.isShowDeleteBtn = YES;
                cell.photosView.isShowZongAddBtn = NO;
//                cell.photosView.isShowAddBtn = NO;
            }
            else{
                cell.photosView.isShowDeleteBtn = NO;
                cell.photosView.isShowZongAddBtn = YES;
//                cell.photosView.isShowAddBtn = YES;
            }
        }
        

            [cell configWith:self.tempConstructionImgV isHavePower:isHavePower isEdit:editOrSuccess];
        constructCellH = cell.cellH;

        if (!isHavePower) {
            cell.addLabel.hidden = YES;
            
        }
        else{
            if (!editOrSuccess) {
                cell.addLabel.hidden = YES;
            }
            else{
                cell.addLabel.hidden = NO;
            }
        }
        return cell;
    }
    else{
        DesignIntroduceCell *cell = [DesignIntroduceCell cellWithTableView:tableView indexpath:indexPath];
//        if (_editOrAdd==1) {
            [cell configWith:self.tempDesignImgV[indexPath.row] isPower:isHavePower isEdit:editOrSuccess];
            DesignIntroduceCellH = cell.cellH;
            if (!isHavePower) {
                cell.supportL.hidden = YES;
                cell.continueAddBtn.hidden = YES;
                cell.deleteModelBtn.hidden = YES;
                cell.bottomV.hidden = YES;
                DesignIntroduceCellH = DesignIntroduceCellH-90;
                
            }
            else{
                if (!editOrSuccess) {
                    cell.supportL.hidden = YES;
                    cell.continueAddBtn.hidden = YES;
                    cell.deleteModelBtn.hidden = YES;
                    cell.bottomV.hidden = YES;
                    DesignIntroduceCellH = DesignIntroduceCellH-90;
                }
                else{
//                    cell.deleteModelBtn.hidden = NO;
                    NSInteger count = self.tempDesignImgV.count;
                    if (indexPath.row==(count-1)) {
                        cell.supportL.hidden = NO;
                        cell.continueAddBtn.hidden = NO;
                        cell.bottomV.hidden = NO;
                        
                        if (lookTag==0) {
                            cell.lookL.text = @"所有朋友可见";
                        }
                        else{
                            cell.lookL.text = @"仅本工地人员可见";
                        }
                    }
                    else{
                        cell.supportL.hidden = YES;
                        cell.continueAddBtn.hidden = YES;
                        cell.bottomV.hidden = YES;
                        DesignIntroduceCellH = DesignIntroduceCellH-90;
                    }
                }
            }
        NSString *keyStr = [NSString stringWithFormat:@"%ld",indexPath.row];
        [self.DesignIntroHDict setObject:@(DesignIntroduceCellH) forKey:keyStr];
        

        cell.delegate = self;
        
        
        if (!isHavePower) {
            
            cell.saySomeV.userInteractionEnabled = NO;
            cell.photoV.userInteractionEnabled = NO;
            
        }
        else{
            if (!editOrSuccess) {
//                cell.continueAddBtn.hidden = YES;
                cell.saySomeV.userInteractionEnabled = NO;
                cell.photoV.userInteractionEnabled = NO;
                cell.someL.hidden = YES;
            }
            else{
                cell.saySomeV.userInteractionEnabled = YES;
                cell.photoV.userInteractionEnabled = YES;
//                cell.someL.hidden = NO;
            }
        }
        
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - ConstructionImageTableViewCellDelegate

-(void)addPhoto{
    if (!isHavePower||!editOrSuccess) {
        return;
    }
    __weak DesignImageViewController *weakSelf=self;
    
    // 调用相册
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [weakSelf uploadImgWith:photos];
        
    }];
    
    
    
    //        if (self.imgArr.count>8) {
    //            //            [weakSelf showToast:@"最多上传9张图片"];
    //            [[PublicTool defaultTool] publicToolsHUDStr:@"最多上传9张图片" controller:weakSelf sleep:1.5];
    //            return ;
    //        }
    [weakSelf presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)deletePhotoWith:(NSInteger)deleteTag{
    if (!isHavePower||!editOrSuccess) {
        return;
    }
//    if (_editOrAdd==1) {
//        [self.tempConstructionImgV removeObjectAtIndex:deleteTag];
//    }
//    else{
//        [self.constructionImgV removeObjectAtIndex:deleteTag];
//    }
    
    [self.tempConstructionImgV removeObjectAtIndex:deleteTag];
    
    //一个cell刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
    [self.designTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)lookPhoto:(NSInteger)index imgArray:(NSArray *)imgArray{
    if (!isHavePower&&self.tempConstructionImgV.count<=0){
        return;
    }
    if (isHavePower&&self.tempConstructionImgV.count<=0) {
        return;
    }
    __weak DesignImageViewController *weakSelf=self;
    YPImagePreviewController *yvc = [[YPImagePreviewController alloc]init];
    yvc.images = imgArray ;
    yvc.index = index ;
    UINavigationController *uvc = [[UINavigationController alloc]initWithRootViewController:yvc];
    [weakSelf presentViewController:uvc animated:YES completion:nil];
}

#pragma mark - DesignIntroduceCellDelegate

-(void)deleteIntroductPhotoWith:(NSIndexPath *)path{
//    if (_editOrAdd == 1) {
//        CaseDesignModel *model = self.tempDesignImgV[path.row];
//        model.cdPicture = @"";
//        [self.tempDesignImgV replaceObjectAtIndex:path.row withObject:model];
//    }
//    else{
//        CaseDesignModel *model = self.designImgV[path.row];
//        model.cdPicture = @"";
//        [self.designImgV replaceObjectAtIndex:path.row withObject:model];
//    }
    
    CaseDesignModel *model = self.tempDesignImgV[path.row];
    model.cdPicture = @"";
    [self.tempDesignImgV replaceObjectAtIndex:path.row withObject:model];
    
    //一个cell刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:path.row inSection:2];
    [self.designTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)changeDesignPhoto:(NSIndexPath *)path{
    if (!isHavePower) {
        return;
    }
    
    _designPth = path;
    _addDesignPORDesign = 2;
    [self imagePicker];
}

-(void)saveContentWith:(NSIndexPath *)path content:(NSString *)content{
    YSNLog(@"%@%@",path,content);
    
    if (!isHavePower) {
        return;
    }
//    if (_editOrAdd == 1) {
//        CaseDesignModel *model = self.tempDesignImgV[path.row];
//        model.cdDesignComments = content;
//        [self.tempDesignImgV replaceObjectAtIndex:path.row withObject:model];
//    }
//    else{
//        CaseDesignModel *model = self.designImgV[path.row];
//        model.cdDesignComments = content;
//        [self.designImgV replaceObjectAtIndex:path.row withObject:model];
//    }
    
    CaseDesignModel *model = self.tempDesignImgV[path.row];
    model.cdDesignComments = content;
    [self.tempDesignImgV replaceObjectAtIndex:path.row withObject:model];
    
    
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
    [self.designTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    //一个cell刷新
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:path.row inSection:2];
//    [self.designTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)back{
    if (!editOrSuccess) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出编辑"
                                                        message:@"是否确定退出编辑？"
                                                       delegate:self
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是",nil];
//        alert.tag = 2000;
        [alert show];
    }
}

-(void)continueAdd{
    if (!isHavePower) {
        return;
    }
//    if (_editOrAdd==1) {
//        NSInteger count = self.tempDesignImgV.count;
//        CaseDesignModel *tempModel = self.tempDesignImgV[count-1];
//        if ((tempModel.cdDesignComments.length<=0)) {
//            [[PublicTool defaultTool] publicToolsHUDStr:@"请填写完当前设计说明" controller:self sleep:1.5];
//            return;
//        }
    
        CaseDesignModel *model = [[CaseDesignModel alloc]init];
        model.cdPicture = @"";
        model.id = @"";
        model.cdDesignComments = @"";
        //            model.contents = @"";
        //            model.info = @"1";
        //            model.grade = @"";
        //            model.constructionId = [NSString stringWithFormat:@"%ld",self.consID];
        [self.tempDesignImgV addObject:model];
//    }
    
//    else{
//        NSInteger count = self.designImgV.count;
//        CaseDesignModel *tempModel = self.designImgV[count-1];
//        if ((tempModel.cdPicture.length<=0)||(tempModel.cdDesignComments.length<=0)) {
//            [[PublicTool defaultTool] publicToolsHUDStr:@"请填写完当前设计说明" controller:self sleep:1.5];
//            return;
//        }
//        
//        CaseDesignModel *model = [[CaseDesignModel alloc]init];
//        model.cdPicture = @"";
//        model.id = @"";
//        model.cdDesignComments = @"";
//        //            model.contents = @"";
//        //            model.info = @"1";
//        //            model.grade = @"";
//        //            model.constructionId = [NSString stringWithFormat:@"%ld",self.consID];
//        [self.designImgV addObject:model];
//    }
    
    
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
    [self.designTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)bottomVSelect:(UITapGestureRecognizer *)ges{
    NSInteger tagT = ges.view.tag;
    if (tagT == 0) {
        //public
        lookTag = 0;
    }
    
    else{
        //privite
        lookTag = 1;
    }
    
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        
    } completion:^(BOOL finished) {
        [weakSelf.backgroundV removeFromSuperview];
        [weakSelf.hideV removeFromSuperview];
        NSInteger lastIndex = self.tempDesignImgV.count-1;
        //一个cell刷新
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:lastIndex inSection:2];
        [self.designTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

-(void)selectIsVail{
    self.backgroundV.alpha = 0.3;
    self.backgroundV.backgroundColor = Black_Color;
    [self.view addSubview:self.backgroundV];
    
    [self.view addSubview:self.hideV];
    [self.hideV removeAllSubViews];
    UIView *publicV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 49.5)];
    UILabel *publicL = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 30, 20)];
    publicL.textColor = COLOR_BLACK_CLASS_3;
    publicL.font = [UIFont systemFontOfSize
                     :14];
    publicL.text = @"公开";
    //        companyJob.backgroundColor = Red_Color;
    publicL.textAlignment = NSTextAlignmentLeft;
    
    UIImageView *selectpublicImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-30, 15, 20, 20)];
    selectpublicImgV.image = [UIImage imageNamed:@"pitch"];
    selectpublicImgV.layer.masksToBounds = YES;
    selectpublicImgV.layer.cornerRadius = selectpublicImgV.width/2;
    
    UILabel *allL = [[UILabel alloc]initWithFrame:CGRectMake(publicL.left, publicL.bottom, 200, 20)];
    allL.textColor = COLOR_BLACK_CLASS_9;
    allL.font = [UIFont systemFontOfSize
                    :12];
    //        companyJob.backgroundColor = Red_Color;
    allL.text = @"所有朋友可见";
    allL.textAlignment = NSTextAlignmentLeft;
    [publicV addSubview:publicL];
    [publicV addSubview:allL];
    [publicV addSubview:selectpublicImgV];
    
    publicV.tag = 0;
    UITapGestureRecognizer *gesOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomVSelect:)];
    [publicV addGestureRecognizer:gesOne];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, kSCREEN_WIDTH, 1)];
    lineV.backgroundColor = COLOR_BLACK_CLASS_0;
    
    
     UIView *priviteV = [[UIView alloc]initWithFrame:CGRectMake(0, lineV.bottom, kSCREEN_WIDTH, 49.5)];
    UILabel *priviteL = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 20)];
    priviteL.textColor = COLOR_BLACK_CLASS_3;
    priviteL.font = [UIFont systemFontOfSize
                    :14];
    priviteL.text = @"部分可见";
    //        companyJob.backgroundColor = Red_Color;
    priviteL.textAlignment = NSTextAlignmentLeft;
    
    UILabel *partL = [[UILabel alloc]initWithFrame:CGRectMake(priviteL.left, priviteL.bottom, 200, 20)];
    partL.textColor = COLOR_BLACK_CLASS_9;
    partL.font = [UIFont systemFontOfSize
                 :12];
    //        companyJob.backgroundColor = Red_Color;
    partL.text = @"仅本工地人员可见";
    partL.textAlignment = NSTextAlignmentLeft;
    
    UIImageView *priviteImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-30, 15, 20, 20)];
    priviteImgV.image = [UIImage imageNamed:@"pitch"];
    priviteImgV.layer.masksToBounds = YES;
    priviteImgV.layer.cornerRadius = priviteImgV.width/2;
    
    [priviteV addSubview:priviteL];
    [priviteV addSubview:partL];
    [priviteV addSubview:priviteImgV];
    
    if (lookTag==0) {
        selectpublicImgV.image = [UIImage imageNamed:@"pitch"];
        priviteImgV.image = [UIImage imageNamed:@"pitch0"];
    }
    else{
        selectpublicImgV.image = [UIImage imageNamed:@"pitch0"];
        priviteImgV.image = [UIImage imageNamed:@"pitch"];
    }
    
    priviteV.tag = 1;
    UITapGestureRecognizer *gesTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomVSelect:)];
    [priviteV addGestureRecognizer:gesTwo];
    
    [self.hideV addSubview:publicV];
    [self.hideV addSubview:lineV];
    [self.hideV addSubview:priviteV];
    
}

//-(void)deleteModelWith:(NSIndexPath *)path{
//    if (!isHavePower) {
//        return;
//    }
//    if (_editOrAdd==1) {
//        if (self.tempDesignImgV.count<=1) {
//            [[PublicTool defaultTool] publicToolsHUDStr:@"就剩1个，不能删了^_^" controller:self sleep:1.5];
//            return;
//        }
//        [self.tempDesignImgV removeObjectAtIndex:path.row];
//        
//    }else{
//        
//        if (self.designImgV.count<=1) {
//            [[PublicTool defaultTool] publicToolsHUDStr:@"就剩1个，不能删了^_^" controller:self sleep:1.5];
//            return;
//        }
//        [self.designImgV removeObjectAtIndex:path.row];
//    }
//    
//    //一个section刷新
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
//    [self.designTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//}

#pragma mark - 图片选择相关

-(void)imagePicker{
    
    UIImagePickerController * photoAlbum = [[UIImagePickerController alloc]init];
    photoAlbum.delegate = self;
    photoAlbum.allowsEditing = NO;
    photoAlbum.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:photoAlbum animated:YES completion:^{}];
}

//图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage * chooseImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
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
    [self.view hudShow];
    UploadImageApi *uploadApi = [[UploadImageApi alloc]initWithImgStr:base64Str type:@"png"];
    
    [uploadApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view hiddleHud];
        NSDictionary *dic = request.responseJSONObject;
        NSString *code = [dic objectForKey:@"code"];
        NSString *photoUrl = [dic objectForKey:@"imageUrl"];
        if ([code isEqualToString:@"1000"]) {
            
            if (_addDesignPORDesign == 1) {
                self.designPersonImgV = photoUrl;
                
                //一个cell刷新
//                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//                [self.designTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                [self.designTableView reloadData];
            }
            else{
                
//                if (_editOrAdd==1) {
//                    CaseDesignModel *model = self.tempDesignImgV[_designPth.row];
//                    model.cdPicture = photoUrl;
//                    [self.tempDesignImgV replaceObjectAtIndex:_designPth.row withObject:model];
//                }
//                else{
//                    CaseDesignModel *model = self.designImgV[_designPth.row];
//                    model.cdPicture = photoUrl;
//                    [self.designImgV replaceObjectAtIndex:_designPth.row withObject:model];
//                }
                CaseDesignModel *model = self.tempDesignImgV[_designPth.row];
                model.cdPicture = photoUrl;
                [self.tempDesignImgV replaceObjectAtIndex:_designPth.row withObject:model];

                
                //一个section刷新
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
                [self.designTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view hiddleHud];
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
- (void)uploadImgWith:(NSArray *)imgArray{
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
    
//    ASProgressPopUpView *progressTT = [[ASProgressPopUpView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/4, kSCREEN_HEIGHT/2, kSCREEN_WIDTH/2, 10)];
//    progressTT.font = [UIFont systemFontOfSize:16];
//    progressTT.popUpViewAnimatedColors = @[[UIColor redColor]];
//    progressTT.dataSource = self;
//    [progressTT showPopUpViewAnimated:NO];
//    
//    [self.view addSubview:progressTT];

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

//        [self progressTwoWith];

        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.progress removeFromSuperview];
        self.backShadowV.alpha = 0.0f;
        [self.backShadowV removeAllSubViews];
        YSNLog(@"```上传成功``` %@",responseObject);
        NSArray *arr = [responseObject objectForKey:@"imgList"];

        for (NSDictionary *dict in arr) {
            //            [imgArr addObject:[dict objectForKey:@"imgUrl"]];
            CaseDesignModel *model = [[CaseDesignModel alloc]init];
            model.cdPicture = [dict objectForKey:@"imgUrl"];
            model.id = @"0";
//            model.contents = @"";
//            model.info = @"1";
//            model.grade = @"";
//            model.constructionId = [NSString stringWithFormat:@"%ld",self.consID];
//            if (_editOrAdd == 1) {
//                [self.tempConstructionImgV addObject:model];
//            }
//            else
//            {
//                [self.constructionImgV addObject:model];
//            }
            
            [self.tempConstructionImgV addObject:model];
            
        }
        //        if (imgArr.count == 1) {
        //            self.imgUrlStr = imgArr[0];
        //        }else{
        //            self.imgUrlStr = [imgArr componentsJoinedByString:@","];
        //        }
        
        //        YSNLog(@"%@",self.imgUrlStr);
        [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传成功" controller:self sleep:1.5];
        //        [self postData];
        //一个cell刷新
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
        [self.designTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YSNLog(@"xxx上传失败xxx %@", error);
        
        [self.progress removeFromSuperview];
        self.backShadowV.alpha = 0.0f;
        [self.backShadowV removeAllSubViews];
        
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        
    }];
}

- (void)progressTwoWith
{
    
    if (self.progress.progress >= 1.0) {
        //        self.progressButton.selected = NO;
        //        self.progressButton.enabled = NO;
        [self.progress removeFromSuperview];
    }
    
//    float progress = progress ;
    if (progressFloat < 1.0) {
        
//        progress += _continuousButton.selected ? 0.005 : 0.1;
        
        [self.progress setProgress:progressFloat animated:YES];
//        [self.progressView2 setProgress:progress animated:!_continuousButton.selected];
        
//        [NSTimer scheduledTimerWithTimeInterval:0.05f
//                                         target:self
//                                       selector:@selector(progressTwoWith)
//                                       userInfo:nil
//                                        repeats:NO];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)finishClick:(UIBarButtonItem*)sender{
    [self.view endEditing:YES];
    
    if (!editOrSuccess) {
        [self.successBtn setTitle:@"提交" forState:UIControlStateNormal];
        editOrSuccess = YES;
        [self.designTableView reloadData];
    }
    else{
        
        if (_editOrAdd==1) {
            [self editCaseDesign];
        }
        else{
            [self addCaseDesign];
        }
    }
    
}

-(void)dismissBackV{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        
    } completion:^(BOOL finished) {
        [weakSelf.backgroundV removeFromSuperview];
        [weakSelf.hideV removeFromSuperview];
    }];
}

#pragma mark - setter

-(UIView *)backgroundV{
    if (!_backgroundV) {
        _backgroundV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-100)];
        _backgroundV.backgroundColor = [UIColor grayColor];
        _backgroundV.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissBackV)];
        [_backgroundV addGestureRecognizer:ges];
    }
    return _backgroundV;
}

-(UIView *)hideV{
    if (!_hideV) {
        _hideV = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-100, kSCREEN_WIDTH, 100)];
        _hideV.backgroundColor = White_Color;
    }
    return _hideV;
}

#pragma mark - 获取本案设计权限

-(void)getDesignPower{
    NSString *defaultApi = [BASEURL stringByAppendingString:@"design/operatingAuthority.do"];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID),
                               @"userId":@(user.agencyId),
                               @"nodeNumber":@(3001),
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    isHavePower = YES;
                    self.successBtn.hidden = NO;
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                case 1001:
                    
                {
                    isHavePower = NO;
                    self.successBtn.hidden = YES;
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                case 2000:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
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

#pragma mark -查询本案设计

-(void)requestData{
    [self.constructionImgV removeAllObjects];
    [self.designImgV removeAllObjects];
    [self.tempConstructionImgV removeAllObjects];
    [self.tempDesignImgV removeAllObjects];
    
    [self.view hudShow];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"design/getDesignInfrom.do"];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    _editOrAdd = 1;
                    if ([responseObj[@"listArr"] isKindOfClass:[NSArray class]]) {
                        NSMutableArray *tempArray = [NSMutableArray array];
                        NSArray *array = responseObj[@"listArr"];
                        
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseDesignModel class] json:array];
                        [tempArray addObjectsFromArray:arr];
                        
                        for (CaseDesignModel *model in tempArray) {
                            //1:施工图，2：设计说明, 3:设计师说明
                            if ([model.typeFlag integerValue]==1) {
                                [self.constructionImgV addObject:model];
                            }
                            else if ([model.typeFlag integerValue]==2){
                                [self.designImgV addObject:model];
                            }
                            else{
                                self.designPersonImgV = model.cdPicture;
                            }
                        }
                        
                        [self.tempConstructionImgV addObjectsFromArray:self.constructionImgV];
                        if (self.designImgV.count<=0) {
                            CaseDesignModel *model = [[CaseDesignModel alloc]init];
                            model.cdPicture = @"";
                            model.id = @"";
                            model.cdDesignComments = @"";
                            //            model.contents = @"";
                            //            model.info = @"1";
                            //            model.grade = @"";
                            //            model.constructionId = [NSString stringWithFormat:@"%ld",self.consID];
                            [self.designImgV addObject:model];
                            lookTag = 0;
                        }
                        else
                        {
                            CaseDesignModel *model = self.designImgV[0];
                            NSString *shareFlag = model.shareFlag;
                            if (!shareFlag||shareFlag.length<=0) {
                                lookTag = 0;
                            }else{
                                lookTag = [shareFlag integerValue];
                            }
                        }
                        [self.tempDesignImgV addObjectsFromArray:self.designImgV];
                    };
                    
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                case 1001:
                    
                {
                    _editOrAdd = 2;
                    lookTag = 0;
//                    [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
                    
                    CaseDesignModel *model = [[CaseDesignModel alloc]init];
                    model.cdPicture = @"";
                    model.id = @"";
                    model.cdDesignComments = @"";
                    //            model.contents = @"";
                    //            model.info = @"1";
                    //            model.grade = @"";
                    //            model.constructionId = [NSString stringWithFormat:@"%ld",self.consID];
                    [self.tempDesignImgV addObject:model];
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                default:
                    break;
                    
                    
            }
            
            if (_editOrAdd==1) {
                //有数据
                editOrSuccess = NO;
                [self.successBtn setTitle:@"编辑" forState:UIControlStateNormal];
            }else{
                //无数据 -直接显示提交
                editOrSuccess = YES;
                [self.successBtn setTitle:@"提交" forState:UIControlStateNormal];
            }
            
            [self.designTableView reloadData];
        }
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - 新增本案设计

-(void)addCaseDesign{
    if (self.designPersonImgV.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"设计师说明不能为空" controller:self sleep:1.5];
        return;
    }
    
    NSMutableArray *tempDeleteArray = [NSMutableArray array];
    for (CaseDesignModel *model in self.tempDesignImgV) {
        if (model.cdPicture.length<=0&&model.cdDesignComments.length<=0) {
            [tempDeleteArray addObject:model];
        }
    }
    
    [self.tempDesignImgV removeObjectsInArray:tempDeleteArray];
    
    if (self.tempDesignImgV.count<=0) {
        CaseDesignModel *model = [[CaseDesignModel alloc]init];
        model.cdPicture = @"";
        model.id = @"";
        model.cdDesignComments = @"";
        //            model.contents = @"";
        //            model.info = @"1";
        //            model.grade = @"";
        //            model.constructionId = [NSString stringWithFormat:@"%ld",self.consID];
        [self.tempDesignImgV addObject:model];
    }
    
    NSString *constructionStr3 = @"";
    if (self.tempDesignImgV.count<=0) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.designImgV options:NSJSONWritingPrettyPrinted error:nil];
        constructionStr3 = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        //设计说明
        NSMutableArray *designArr = [NSMutableArray array];
        for (CaseDesignModel *model in self.tempDesignImgV) {
            NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
            
            [addDict setObject:model.cdDesignComments forKey:@"cdDesignComments"];
            [addDict setObject:model.cdPicture forKey:@"cdPicture"];
            [designArr addObject:addDict];
        }
        NSData *jsonData3 = [NSJSONSerialization dataWithJSONObject:designArr options:NSJSONWritingPrettyPrinted error:nil];
        constructionStr3 = [[NSString alloc]initWithData:jsonData3 encoding:NSUTF8StringEncoding];
    }
//    NSInteger count = self.designImgV.count;
//    CaseDesignModel *model = self.designImgV[count-1];
//    if ((model.cdPicture.length<=0)||(model.cdDesignComments.length<=0)) {
//        [[PublicTool defaultTool] publicToolsHUDStr:@"请填写完设计说明" controller:self sleep:1.5];
//        return;
//    }
    
    NSString *constructionStr = @"";
    if(self.tempConstructionImgV.count<=0){
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.tempConstructionImgV options:NSJSONWritingPrettyPrinted error:nil];
        constructionStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    else{
        //施工图
        NSMutableArray *constructionArr = [NSMutableArray array];
        for (CaseDesignModel *model in self.tempConstructionImgV) {
            NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
            
            [addDict setObject:model.cdPicture forKey:@"cdPicture"];
            [constructionArr addObject:addDict];
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:constructionArr options:NSJSONWritingPrettyPrinted error:nil];
        constructionStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    
    //设计师说明
    NSMutableArray *designPersonArr = [NSMutableArray array];
        NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
        
        [addDict setObject:self.designPersonImgV forKey:@"cdPicture"];
        [designPersonArr addObject:addDict];
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:designPersonArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    
    
    [self.view hudShow];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"design/designSave.do"];
    NSDictionary *paramDic = @{@"constructionPlansStr":constructionStr,
                               @"desginContentStr":constructionStr3,
                               @"designerProfileStr":constructionStr2,
                               @"personnel":@(user.agencyId),
                               @"constructionId":@(self.consID),
                               @"whetherVisible":@(lookTag)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 10000:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"添加成功" controller:self sleep:1.5];
//                    [self.navigationController popViewControllerAnimated:YES];
                    [self.successBtn setTitle:@"编辑" forState:UIControlStateNormal];
                    editOrSuccess = NO;
                    _editOrAdd = 1;
                    
                    [self.designImgV addObjectsFromArray:self.tempDesignImgV];
                    [self.constructionImgV addObjectsFromArray:self.tempConstructionImgV];
                    [self.designTableView reloadData];
                }
                    break;
                    
                default:
                    [[PublicTool defaultTool] publicToolsHUDStr:@"添加失败" controller:self sleep:1.5];
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - 编辑本案设计

-(void)editCaseDesign{
    if (self.designPersonImgV.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"设计师说明不能为空" controller:self sleep:1.5];
        return;
    }
//    if(self.tempConstructionImgV.count<=0){
//        [[PublicTool defaultTool] publicToolsHUDStr:@"施工图不能为空" controller:self sleep:1.5];
//        return;
//    }
//    if (self.tempDesignImgV.count<=0) {
//        [[PublicTool defaultTool] publicToolsHUDStr:@"设计说明不能为空" controller:self sleep:1.5];
//        return;
//    }
    
//    NSInteger count = self.tempDesignImgV.count;
//    CaseDesignModel *model = self.tempDesignImgV[count-1];
//    if ((model.cdPicture.length<=0)||(model.cdDesignComments.length<=0)) {
//        [[PublicTool defaultTool] publicToolsHUDStr:@"请填写完设计说明" controller:self sleep:1.5];
//        return;
//    }
    
    
    
    NSString *constructionStr = @"";
    if(self.tempConstructionImgV.count<=0){
        if (self.constructionImgV.count<=0) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.tempConstructionImgV options:NSJSONWritingPrettyPrinted error:nil];
            constructionStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        else{
            NSMutableArray *constructionArr = [NSMutableArray array];
            
            //获取施工图删除的
            for (CaseDesignModel *model in self.constructionImgV) {
                
                    NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
                    
                    [addDict setObject:@"" forKey:@"cdPicture"];
                    [addDict setObject:model.id forKey:@"id"];
                    [addDict setObject:@"" forKey:@"cdDesignComments"];
                    [constructionArr addObject:addDict];
                
            }
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:constructionArr options:NSJSONWritingPrettyPrinted error:nil];
            constructionStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
    }
    else{
        //获取施工图新增的
        //施工图
        NSMutableArray *constructionArr = [NSMutableArray array];
        for (CaseDesignModel *model in self.tempConstructionImgV) {
            if (model.id.length<=0) {
                NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
                
                [addDict setObject:model.cdPicture forKey:@"cdPicture"];
                [addDict setObject:@"" forKey:@"id"];
                [addDict setObject:@"" forKey:@"cdDesignComments"];
                [constructionArr addObject:addDict];
            }
        }
        
        //获取施工图编辑的
        for (CaseDesignModel *model in self.tempConstructionImgV) {
            if (model.id.length>0) {
                NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
                
                [addDict setObject:model.cdPicture forKey:@"cdPicture"];
                [addDict setObject:model.id forKey:@"id"];
                [addDict setObject:@"" forKey:@"cdDesignComments"];
                [constructionArr addObject:addDict];
            }
        }
        
        //获取施工图删除的
        for (CaseDesignModel *model in self.constructionImgV) {
            if (![self.tempConstructionImgV containsObject:model]) {
                NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
                
                [addDict setObject:@"" forKey:@"cdPicture"];
                [addDict setObject:model.id forKey:@"id"];
                [addDict setObject:@"" forKey:@"cdDesignComments"];
                [constructionArr addObject:addDict];
            }
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:constructionArr options:NSJSONWritingPrettyPrinted error:nil];
        constructionStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
    NSMutableArray *tempDeleteArray = [NSMutableArray array];
    for (CaseDesignModel *model in self.tempDesignImgV) {
        if (model.cdPicture.length<=0&&model.cdDesignComments.length<=0) {
            [tempDeleteArray addObject:model];
        }
    }
    
    [self.tempDesignImgV removeObjectsInArray:tempDeleteArray];
    
    if (self.tempDesignImgV.count<=0) {
        CaseDesignModel *model = [[CaseDesignModel alloc]init];
        model.cdPicture = @"";
        model.id = @"";
        model.cdDesignComments = @"";
        //            model.contents = @"";
        //            model.info = @"1";
        //            model.grade = @"";
        //            model.constructionId = [NSString stringWithFormat:@"%ld",self.consID];
        [self.tempDesignImgV addObject:model];
    }
    
    NSString *constructionStr3 = @"";
    if (self.tempDesignImgV.count<=0) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.tempDesignImgV options:NSJSONWritingPrettyPrinted error:nil];
        constructionStr3 = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        
        //获取设计说明新增的
        //设计说明
        NSMutableArray *DesignArr = [NSMutableArray array];
        for (CaseDesignModel *model in self.tempDesignImgV) {
            if (model.id.length<=0) {
                NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
                
                [addDict setObject:model.cdPicture forKey:@"cdPicture"];
                [addDict setObject:@"" forKey:@"id"];
                [addDict setObject:model.cdDesignComments forKey:@"cdDesignComments"];
                [DesignArr addObject:addDict];
            }
        }
        
        //获取设计说明编辑的
        for (CaseDesignModel *model in self.tempDesignImgV) {
            if (model.id.length>0) {
                NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
                
                [addDict setObject:model.cdPicture forKey:@"cdPicture"];
                [addDict setObject:model.id forKey:@"id"];
                [addDict setObject:model.cdDesignComments forKey:@"cdDesignComments"];
                [DesignArr addObject:addDict];
            }
        }
        
        //获取设计说明删除的
        for (CaseDesignModel *model in self.designImgV) {
            if (![self.tempDesignImgV containsObject:model]) {
                NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
                
                [addDict setObject:@"" forKey:@"cdPicture"];
                [addDict setObject:model.id forKey:@"id"];
                [addDict setObject:@"" forKey:@"cdDesignComments"];
                [DesignArr addObject:addDict];
            }
        }
        
        NSData *jsonData3 = [NSJSONSerialization dataWithJSONObject:DesignArr options:NSJSONWritingPrettyPrinted error:nil];
        constructionStr3 = [[NSString alloc]initWithData:jsonData3 encoding:NSUTF8StringEncoding];
    }
    
    
    
    //设计师说明
    NSMutableArray *designPersonArr = [NSMutableArray array];
    NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
    
    [addDict setObject:self.designPersonImgV forKey:@"cdPicture"];
    [designPersonArr addObject:addDict];
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:designPersonArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    
    
    
    [self.view hudShow];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"design/designEditAndSave.do"];
    NSDictionary *paramDic = @{@"constructionPlansStr":constructionStr,
                               @"desginContentStr":constructionStr3,
                               @"designerProfileStr":constructionStr2,
                               @"personnel":@(user.agencyId),
                               @"constructionId":@(self.consID),
                               @"whetherVisible":@(lookTag)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 10000:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"修改成功" controller:self sleep:1.5];
//                    [self.navigationController popViewControllerAnimated:YES];
                    [self.successBtn setTitle:@"编辑" forState:UIControlStateNormal];
                    editOrSuccess = NO;
                    [self requestData];
//                    [self.designTableView reloadData];
                }
                    break;
                    
                default:
                    [[PublicTool defaultTool] publicToolsHUDStr:@"修改失败" controller:self sleep:1.5];
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
