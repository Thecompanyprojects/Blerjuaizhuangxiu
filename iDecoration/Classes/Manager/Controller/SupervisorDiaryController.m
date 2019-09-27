//
//  SupervisorDiaryController.m
//  iDecoration
//
//  Created by Apple on 2017/5/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SupervisorDiaryController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "SupervisionModel.h"
#import "YPCommentView.h"
#import "TZImagePickerController.h"
#import "SupervisorDiaryCell.h"


#import "SupervisorDiaryCellTwo.h"

#import "ASProgressPopUpView.h"
#import "NSObject+CompressImage.h"

//#import "ACEExpandableTextCell.h"


@interface SupervisorDiaryController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,SupervisorDiaryCellDelegate,SupervisorDiaryCellTwoDelegate,UIAlertViewDelegate>
{
    NSInteger _deleteTag;
    NSInteger _contentTag;
    NSInteger _changeTag;
    BOOL isHavePwoer;   //no:没有权限 yes：有权限
    BOOL editOrSuccess; //no:未编辑状态 yes：编辑状态
    
    CGFloat imgOrgialH;
    CGFloat imgOrgialW;
    
    BOOL isFirstEdit;//是否第一次编辑
    
    NSInteger upInfoORContentImg; //1:添加的是信息的图片 2:添加的是内容的图片
    
    CGFloat cellH;
}

@property (nonatomic, strong) UIButton *successBtn;
@property (nonatomic, strong) UILabel *placeHolderL;
//@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *infoL;
@property (nonatomic, strong) UIScrollView *topSrcV;
@property (nonatomic, strong) UIView *lineOneV;

@property (nonatomic, strong) UIView *bottomV;

@property (nonatomic, strong) ASProgressPopUpView *progress;
@property (nonatomic, strong) UIView *backShadowV;

@property (nonatomic, strong) NSMutableArray *tempInfoArray;
@property (nonatomic, strong) NSMutableArray *tempContentArray;
@property (nonatomic, strong) NSMutableArray *supervisionInfoArray;//监理信息
@property (nonatomic, strong) NSMutableArray *supervisionContentArray;//监理内容

@property (nonatomic,strong)YPPhotosView *photosView;
@property (nonatomic, strong) NSMutableArray *editArray;
@property (nonatomic, strong) NSMutableArray *deleteArray;
@property (nonatomic, strong) NSMutableArray *addArray;

@property (nonatomic,strong)NSMutableArray *imgArr;

@property (nonatomic,strong)NSMutableArray *imgOrUrlArr;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) NSMutableArray *arrayH;

@property (nonatomic, strong) UIButton *continueBtn;

@end

@implementation SupervisorDiaryController

- (NSMutableArray *)imgArr
{
    if (_imgArr == nil) {
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}

- (NSMutableArray *)imgOrUrlArr
{
    if (_imgOrUrlArr == nil) {
        _imgOrUrlArr = [NSMutableArray array];
    }
    return _imgOrUrlArr;
}

- (NSMutableArray *)arrayH
{
    if (_arrayH == nil) {
        _arrayH = [NSMutableArray array];
    }
    return _arrayH;
}

- (NSMutableDictionary *)dict
{
    if (_dict == nil) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imgOrgialH = 0;
    imgOrgialW = 0 ;
    self.automaticallyAdjustsScrollViewInsets = false;
    self.supervisionInfoArray = [NSMutableArray array];
    self.supervisionContentArray = [NSMutableArray array];
    self.tempInfoArray = [NSMutableArray array];
    self.tempContentArray = [NSMutableArray array];
    
    self.editArray = [NSMutableArray array];
    self.deleteArray = [NSMutableArray array];
    self.addArray = [NSMutableArray array];
    editOrSuccess = NO;
    [self creatUI];
}

-(void)creatUI{
    self.view.backgroundColor = White_Color;
    self.title = @"监理日志";
    UIButton *successBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    successBtn.frame = CGRectMake(0, 0, 44, 44);
    [successBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [successBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    successBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    successBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    successBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    successBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [successBtn addTarget:self action:@selector(success) forControlEvents:UIControlEventTouchUpInside];
    self.successBtn = successBtn;
    self.successBtn.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.successBtn];
    [self.view addSubview:self.tableView];
    [self judgeSuperversonJob];
//    [self.view addSubview:self.scrollView];
//    [self.scrollView addSubview:self.infoL];
//    [self.scrollView addSubview:self.topSrcV];
//    [self.topSrcV addSubview:self.photosView];
//    [self.scrollView addSubview:self.lineOneV];
//    
//    [self.scrollView addSubview:self.bottomV];
    
    // 单独处理这里的返回按钮(因为需要返回到根控制器)
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
    
    
}

-(void)back{
    if (editOrSuccess) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出编辑"
                                                        message:@"是否确定退出编辑？"
                                                       delegate:self
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是",nil];
        [alert show];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)dealloc{
    //    [super dealloc];
    
//    [[SDImageCache sharedImageCache] clearDisk];
//    
//    [[SDImageCache sharedImageCache] clearMemory];//可有可无
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tempContentArray.count;
//    return 3;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kSCREEN_WIDTH/3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (!isHavePwoer) {
        return 0;
    }else{
        if (!editOrSuccess){
            return 0;
        }else{
            return 30;
        }
        
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    
    if (!_infoL) {
        _infoL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, kSCREEN_WIDTH/3)];
                _infoL.textColor = COLOR_BLACK_CLASS_3;
                _infoL.font = [UIFont systemFontOfSize
                               :14];
                _infoL.backgroundColor = COLOR_BLACK_CLASS_0;
                //        companyJob.backgroundColor = Red_Color;
                _infoL.textAlignment = NSTextAlignmentCenter;
                _infoL.text = @"监\n理\n信\n息";
                _infoL.numberOfLines = 4;
    }
    [view addSubview:self.infoL];
    
    if (!_topSrcV) {
        _topSrcV = [[UIScrollView alloc]initWithFrame:CGRectMake(40, 0, kSCREEN_WIDTH-40, self.infoL.height)];
    }
    
    
    [view addSubview:self.topSrcV];
    
    if (!_photosView) {
        _photosView = [[YPPhotosView alloc]initWithFrame:CGRectMake(0, 0, self.topSrcV.width, self.topSrcV.height)];
    }
    [self.topSrcV addSubview:self.photosView];
    
    if (!_lineOneV) {
                _lineOneV = [[UIView alloc]initWithFrame:CGRectMake(0, self.infoL.bottom-1, kSCREEN_WIDTH, 1)];
                _lineOneV.backgroundColor = COLOR_BLACK_CLASS_0;
            }
    [view addSubview:self.lineOneV];
    view.backgroundColor = White_Color;
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
    lineV.backgroundColor = COLOR_BLACK_CLASS_0;
    [view addSubview:lineV];
    if (!_continueBtn) {
        _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueBtn.frame = CGRectMake(kSCREEN_WIDTH-100, lineV.bottom, 80, 29);
        [_continueBtn setTitle:@"继续添加" forState:UIControlStateNormal];
        _continueBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_continueBtn setTitleColor:Blue_Color forState:UIControlStateNormal];
        _continueBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        [_continueBtn addTarget:self action:@selector(continueAddContent) forControlEvents:UIControlEventTouchUpInside];
//        _addBtn.layer.masksToBounds = YES;
//        _addBtn.layer.cornerRadius = 5;
//        _addBtn.layer.borderWidth = 1.0;
//        _addBtn.layer.borderColor = COLOR_BLACK_CLASS_9.CGColor;
    }
    [view addSubview:self.continueBtn];
    
    
    
    if (!isHavePwoer) {
        self.continueBtn.hidden = YES;
        lineV.hidden = YES;
    }else{
        if (!editOrSuccess){
            self.continueBtn.hidden = YES;
            lineV.hidden = YES;
        }else{
            self.continueBtn.hidden = NO;
            lineV.hidden = NO;
        }
        
    }
    view.backgroundColor = White_Color;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str = [NSString stringWithFormat:@"%ld",indexPath.row];
////    CGFloat temH = 0;
////    NSDictionary *dict;
////    for (int i = 0; i<self.arrayH.count; i++) {
////        NSDictionary *temDict = self.arrayH[i];
////        if ([temDict.allKeys containsObject:str]) {
////            dict = temDict;
////            break;
////        }
////    }
//    temH = [[dict objectForKey:str] floatValue];
//    return temH;
//    if (self.dict) {
        NSString *tempstr = [self.dict objectForKey:str];
////        if (tempstr) {
            CGFloat temH = [tempstr floatValue];
            return temH;
////        }
//
//        
////    }
////    return 151;
    
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    return cellH;
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewAutomaticDimension;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SupervisorDiaryCell *cell = [SupervisorDiaryCell cellWithTableView:tableView indexpath:indexPath];
    cell.delegate = self;
    SupervisionModel *model = self.tempContentArray[indexPath.row];
    [cell configWith:model count:self.tempInfoArray.count indexPath:indexPath isPower:isHavePwoer isEdit:editOrSuccess];

    cellH = cell.cellH;
    
    
    NSString *keyStr = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    NSString *valueStr = [NSString stringWithFormat:@"%f",cellH];
    if ([[self.dict allKeys] containsObject:keyStr]) {
        [self.dict removeObjectForKey:keyStr];
    }
    
    [self.dict setObject:valueStr forKey:keyStr];
    
//    SupervisorDiaryCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:@"SupervisorDiaryCellTwo"];
//    cell.delegate = self;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.tableView = self.tableView;
//    [cell configWith:model count:self.tempInfoArray.count indexPath:indexPath isPower:isHavePwoer isEdit:editOrSuccess];
    
//    if (indexPath.row==self.tempContentArray.count-1) {
//        cell.lineV.hidden = NO;
//        
//        if (model.picture.length<=0&&model.contents.length<=0) {
//            cell.lineV.hidden =
//        }
//    }else{
//        cell.lineV.hidden = YES;
//    }
    

    
    
    return cell;
}

#pragma mark - SupervisorDiaryCellDelegate
-(void)changeContentPhoto:(NSInteger)tag{
    _changeTag = tag;
    [self imagePicker];
}

-(void)deleteContentPhoto:(NSInteger)tag{
    SupervisionModel *model = self.tempContentArray[tag];
    model.picture = @"";
    [self.tempContentArray replaceObjectAtIndex:tag withObject:model];
    ////    [self.tempContentArray removeObject:model];
    //一个cell刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:tag inSection:0];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    //一个section刷新
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView reloadData];
}

-(void)editContent:(NSInteger)tag content:(NSString *)content{
    SupervisionModel *model = self.tempContentArray[tag];
    model.contents = content;
    [self.tempContentArray replaceObjectAtIndex:tag withObject:model];;
    //一个cell刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:tag inSection:0];
//    SupervisorDiaryCellTwo *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    cell.saySomeNsH.constant = 200;
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];

    
}

#pragma mark - 配置图片选择View
-(void)configurPhotosView {
    __weak SupervisorDiaryController *weakSelf=self;
    //    [self.imgArr addObjectsFromArray:self.imgList];
    //
    NSMutableArray *tempArray = [NSMutableArray array];
    
    [tempArray addObjectsFromArray:self.imgOrUrlArr];
    [tempArray addObject:[UIImage imageNamed:@"jia1"]];
    

    
    //有权限，并且是编辑状态，才显示+按钮，和右上角的-按钮
    if (isHavePwoer&&editOrSuccess){
        _photosView.isShowAddBtn = YES;
        _photosView.isShowScrDeleteBtn = YES;
    }
    else{
        [tempArray removeLastObject];
        _photosView.isShowAddBtn = NO;
        _photosView.isShowScrDeleteBtn = NO;
    }
    
    _photosView.isRow = YES;
    
    [_photosView setYPPhotosView:tempArray];
    
    NSInteger a = tempArray.count;
    [weakSelf resetFrame:a];
    
    
    _photosView.clickcloseImage = ^(NSInteger index){
        [weakSelf.imgOrUrlArr removeObjectAtIndex:index];
        [weakSelf.tempInfoArray removeObjectAtIndex:index];
        NSTimeInterval animationDuration = 0.0f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        NSMutableArray *tempTwoArray = [NSMutableArray array];
        
        [tempTwoArray addObjectsFromArray:weakSelf.imgOrUrlArr];
        [tempTwoArray addObject:[UIImage imageNamed:@"jia1"]];
        
        //有权限，并且是编辑状态，才显示+按钮，和右上角的-按钮
        if (isHavePwoer&&editOrSuccess){
            weakSelf.photosView.isShowAddBtn = YES;
            weakSelf.photosView.isShowScrDeleteBtn = YES;
        }
        else{
            [tempArray removeLastObject];
            weakSelf.photosView.isShowAddBtn = NO;
            weakSelf.photosView.isShowScrDeleteBtn = NO;
        }
        [weakSelf.photosView setYPPhotosView:tempTwoArray];
        
        NSInteger countA = tempTwoArray.count;
        
        [weakSelf resetFrame:countA];
        [UIView commitAnimations];
    };
    
    _photosView.clicklookImage = ^(NSInteger index , NSArray *imageArr){
        
        YPImagePreviewController *yvc = [[YPImagePreviewController alloc]init];
        yvc.images = imageArr ;
        yvc.index = index ;
        UINavigationController *uvc = [[UINavigationController alloc]initWithRootViewController:yvc];
        [weakSelf presentViewController:uvc animated:YES completion:nil];
        
        
    };
    
    _photosView.clickChooseView = ^{
        // 调用相册
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9-weakSelf.imgArr.count delegate:nil];
        
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            upInfoORContentImg = 1;
            [weakSelf uploadImgWith:photos];
            
            //            NSLog(@"%ld",(unsigned long)weakSelf.imgArr.count);
            
        }];
        
        
        
        //        if (self.imgArr.count>8) {
        //            //            [weakSelf showToast:@"最多上传9张图片"];
        //            [[PublicTool defaultTool] publicToolsHUDStr:@"最多上传9张图片" controller:weakSelf sleep:1.5];
        //            return ;
        //        }
        [weakSelf presentViewController:imagePickerVc animated:YES completion:nil];
        
        
    };
    
    //    [self.scrollView addSubview:_photosView];
    //    self.scrollView.contentSize = CGSizeMake(0, self.scrollView.height+64+230);
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
    // 在parameters里存放照片以外的对象
    [self.view addSubview:self.backShadowV];
    [self.view addSubview:self.progress];
    self.backShadowV.alpha = 0.5f;
    self.progress.progress = 0.0;
    
    
    
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
        [self.progress removeFromSuperview];
        self.backShadowV.alpha = 0.0f;
        [self.backShadowV removeAllSubViews];
        
        YSNLog(@"```上传成功``` %@",responseObject);
        NSArray *arr = [responseObject objectForKey:@"imgList"];
        //        NSMutableArray *imgArr = [NSMutableArray array];
        //        [imgArr removeAllObjects];
        if (upInfoORContentImg == 1) {
            for (NSDictionary *dict in arr) {
                //            [imgArr addObject:[dict objectForKey:@"imgUrl"]];
                SupervisionModel *model = [[SupervisionModel alloc]init];
                model.picture = [dict objectForKey:@"imgUrl"];
                model.id = @"0";
                model.contents = @"";
                model.info = @"1";
                model.grade = @"";
                model.constructionId = [NSString stringWithFormat:@"%ld",self.consID];
                [self.tempInfoArray addObject:model];
            }
            [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传成功" controller:self sleep:1.5];
            [self.imgOrUrlArr addObjectsFromArray:imgArray];
            NSMutableArray *tempArray = [NSMutableArray array];
            
            
            [tempArray addObjectsFromArray:self.imgOrUrlArr];
            [tempArray addObject:[UIImage imageNamed:@"jia1"]];
            //有权限，并且是编辑状态，才显示+按钮，和右上角的-按钮
            if (isHavePwoer&&editOrSuccess){
                self.photosView.isShowAddBtn = YES;
                self.photosView.isShowScrDeleteBtn = YES;
            }
            else{
                [tempArray removeLastObject];
                self.photosView.isShowAddBtn = NO;
                self.photosView.isShowScrDeleteBtn = NO;
            }
            _photosView.isRow = YES;
            [_photosView setYPPhotosView:tempArray];
            NSTimeInterval animationDuration = 0.30f;
            [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
            [UIView setAnimationDuration:animationDuration];
            NSInteger a = tempArray.count;
            [self resetFrame:a];
            [UIView commitAnimations];
        }else{
            
            SupervisionModel *model = self.tempContentArray[_changeTag];
            NSDictionary *dict = arr[0];
            model.picture = [dict objectForKey:@"imgUrl"];
            [self.tempContentArray replaceObjectAtIndex:_changeTag withObject:model];
            
//            [self resetContentSrcV];
            //一个cell刷新
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_changeTag inSection:0];
            [UIView animateWithDuration:0 animations:^{
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
            
            
//            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
//            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//            [self.tableView reloadData];
            
        }
        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YSNLog(@"xxx上传失败xxx %@", error);
        
        [self.progress removeFromSuperview];
        self.backShadowV.alpha = 0.0f;
        [self.backShadowV removeAllSubViews];
        
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        
    }];
}

-(void)resetInfoScrV{
    [self.topSrcV removeAllSubViews];
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.topSrcV.height, self.topSrcV.height)];
    imgV.image = [UIImage imageNamed:@"jia1"];
    imgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto)];
    [imgV addGestureRecognizer:ges];
    
    //    [self.topSrcV addSubview:imgV];
    if (self.tempInfoArray.count<=0) {
        imgV.frame = CGRectMake(5, 5, self.topSrcV.height-10, self.topSrcV.height-10);
        [self.topSrcV addSubview:imgV];
        if (!isHavePwoer) {
            imgV.hidden = YES;
        }else{
            if (!editOrSuccess) {
                imgV.hidden = YES;
            }
            else{
                imgV.hidden = NO;
            }
            imgV.hidden = NO;
        }
    }
    else{
        CGFloat leftx = 5;
        NSInteger count = self.tempInfoArray.count;
        for (int i = 0; i<count; i++) {
            SupervisionModel *model = self.tempInfoArray[i];
            UIImageView *temV = [[UIImageView alloc]initWithFrame:CGRectMake(leftx, 5, self.topSrcV.height-10, self.topSrcV.height-10)];
            [temV sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:DefaultIcon]];
            leftx = (self.topSrcV.height+5)*(i+1);
            [self.topSrcV addSubview:temV];
            
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.frame = CGRectMake(temV.right-15, 5, 15, 15);
            deleteBtn.layer.masksToBounds = YES;
            deleteBtn.layer.cornerRadius = 7.5;
            [deleteBtn setImage:[UIImage imageNamed:@"shanchutupian"] forState:UIControlStateNormal];
            _deleteTag = i;
            [deleteBtn addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchUpInside];
            [self.topSrcV addSubview:deleteBtn];
            if (!isHavePwoer) {
                imgV.hidden = YES;
                deleteBtn.hidden = YES;
            }else{
                if (!editOrSuccess){
                    imgV.hidden = YES;
                    deleteBtn.hidden = YES;
                }else{
                    imgV.hidden = NO;
                    deleteBtn.hidden = NO;
                }
                
            }
        }
        CGFloat rightX = leftx+self.topSrcV.height;
        if (rightX>=(kSCREEN_WIDTH-40)) {
            self.topSrcV.contentSize = CGSizeMake(rightX+20, self.topSrcV.height);
        }
        else{
            self.topSrcV.contentSize = CGSizeMake(rightX, self.topSrcV.height);
        }
        imgV.frame = CGRectMake(leftx, 5, self.topSrcV.height-10, self.topSrcV.height-10);
        [self.topSrcV addSubview:imgV];
    }
    
    
    
}

-(void)resetContentSrcV{
    [self.bottomV removeAllSubViews];
    NSInteger count = self.tempContentArray.count;
    if (count==0) {
        SupervisionModel *model = [[SupervisionModel alloc]init];
        model.picture = @"";
        model.id = @"0";
        model.contents = @"";
        model.info = @"0";
        model.grade = @"";
        model.constructionId = [NSString stringWithFormat:@"%ld",self.consID];
        [self.tempContentArray addObject:model];
        
        UITextView *contentV = [[UITextView alloc]initWithFrame:CGRectMake(5, 0, kSCREEN_WIDTH-10, 50)];
        contentV.textColor = COLOR_BLACK_CLASS_3;
        contentV.font = NB_FONTSEIZ_NOR;
        contentV.delegate = self;
        contentV.tag = 0;
        
        UILabel *contenL = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, contentV.width-5*2, 20)];
        contenL.textColor = COLOR_BLACK_CLASS_9;
        contenL.font = [UIFont systemFontOfSize
                        :14];
        //        companyJob.backgroundColor = Red_Color;
        contenL.text = @"说点什么吧";
        contenL.textAlignment = NSTextAlignmentLeft;
//        self.placeHolderL = contenL;
        [self.bottomV addSubview:contentV];
        [contentV addSubview:contenL];
        
        
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, contentV.bottom, 80, 80)];
        imgV.image = [UIImage imageNamed:@"jia1"];
        imgV.userInteractionEnabled = YES;
        imgV.layer.borderWidth = 1.0;
        imgV.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
        _contentTag = 0;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addContentPhoto)];
        [imgV addGestureRecognizer:ges];
        [self.bottomV addSubview:imgV];
        
        
//        if (isHavePwoer&&editOrSuccess){
//            
//        }
        
        
        if (!isHavePwoer) {
            contentV.hidden = YES;
            imgV.hidden = YES;
            contentV.userInteractionEnabled = NO;
        }else{
            if (!editOrSuccess){
                contentV.hidden = YES;
                imgV.hidden = YES;
                contentV.userInteractionEnabled = NO;
            }else{
                contentV.hidden = NO;
                imgV.hidden = NO;
                contentV.userInteractionEnabled = YES;
            }
            
        }
        
    }
    else{
        CGFloat hh = 0;
        for (int i = 0; i<self.tempContentArray.count; i++) {
            SupervisionModel *model = self.tempContentArray[i];
            
            UITextView *contentV = [[UITextView alloc]initWithFrame:CGRectMake(5, hh, kSCREEN_WIDTH-10, 50)];
            contentV.textColor = COLOR_BLACK_CLASS_3;
            contentV.font = NB_FONTSEIZ_NOR;
            contentV.tag = i;
            contentV.delegate = self;
            UILabel *contenL = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, contentV.width-5*2, 20)];
            contenL.textColor = COLOR_BLACK_CLASS_9;
            contenL.font = [UIFont systemFontOfSize
                            :14];
            //        companyJob.backgroundColor = Red_Color;
            contenL.text = @"说点什么吧";
            contenL.textAlignment = NSTextAlignmentLeft;
            
            contentV.text = model.contents;
            
//            self.placeHolderL = contenL;
                        if (contentV.text.length>0) {
            contenL.hidden = YES;
                        }
                        else{
                            contenL.hidden = NO;
                        }
            [self.bottomV addSubview:contentV];
            [contentV addSubview:contenL];
            
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, contentV.bottom, 10, 10)];
            UIImage *placeHolderimage = [UIImage imageNamed:@"jia1"];
            imgV.userInteractionEnabled = YES;
            imgV.layer.borderWidth = 1.0;
            imgV.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
            _contentTag = i;
            imgV.tag = i;
//            [imgV sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:placeHolderimage];
            
            
            
            UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePhoto:)];
            [imgV addGestureRecognizer:ges];
            [self.bottomV addSubview:imgV];
            
            
            UIButton *deleteContentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteContentBtn.frame = CGRectMake(imgV.right-20, imgV.top-15, 30, 30);
            deleteContentBtn.layer.masksToBounds = YES;
            deleteContentBtn.layer.cornerRadius = 15;
            //            deleteContentBtn.layer.borderWidth = 1.0;
            //            deleteContentBtn.layer.borderColor = COLOR_BLACK_CLASS_9.CGColor;
            [deleteContentBtn setImage:[UIImage imageNamed:@"del02.png"] forState:UIControlStateNormal];
            deleteContentBtn.tag = i;
            [deleteContentBtn addTarget:self action:@selector(deleteContent:) forControlEvents:UIControlEventTouchUpInside];
            [self.bottomV addSubview:deleteContentBtn];
            
            if (model.picture.length<=0) {
                //没有图片  -- 判断有没有权限 --没有权限--隐藏+   ---有权限判断是不是编辑状态 --是，显示+号，不是--隐藏
                if (!isHavePwoer) {
                    imgV.hidden = YES;
                    imgV.frame = CGRectMake(10, contentV.bottom, kSCREEN_WIDTH-20, 10);
                    
                }
                else{
                    if (!editOrSuccess) {
                        imgV.hidden = YES;
                        imgV.frame = CGRectMake(10, contentV.bottom, kSCREEN_WIDTH-20, 10);
                    }
                    else{
                        imgV.hidden = NO;
                        imgV.image = placeHolderimage;
                        imgV.frame = CGRectMake(10, contentV.bottom, 80,80);
                    }
                }
                deleteContentBtn.hidden = YES;
            }else{
                imgV.hidden = NO;
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                
                NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:model.picture]];
                SDImageCache *cache = [SDImageCache sharedImageCache];
                UIImage *cachedImage = [cache imageFromDiskCacheForKey:key];
                
                if (cachedImage) {
                    imgV.image = cachedImage;
                    [imgV sizeToFit];
                    CGFloat orgialH = imgV.height;
                    CGFloat orgialW = imgV.width;
                    
                    CGFloat nowH = orgialH*(kSCREEN_WIDTH-20)/orgialW;
                    imgV.frame = CGRectMake(10, contentV.bottom, kSCREEN_WIDTH-20, nowH);
                    deleteContentBtn.frame = CGRectMake(imgV.right-20, imgV.top-15, 30, 30);
                }
                
                else{
                    
                    NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.picture]];
                    UIImage *image = [[UIImage alloc]initWithData:data];
                    if (!image) {
                        image = [UIImage imageNamed:@"carousel"];
                    }
                    imgV.image = image;
                    CGFloat orgialH = imgV.height;
                    CGFloat orgialW = imgV.width;
                    
                    CGFloat nowH = orgialH*(kSCREEN_WIDTH-20)/orgialW;
                    imgV.frame = CGRectMake(10, contentV.bottom, kSCREEN_WIDTH-20, nowH);
                    deleteContentBtn.frame = CGRectMake(imgV.right-20, imgV.top-15, 30, 30);
                    
                    [[SDImageCache sharedImageCache] storeImage:image forKey:key];
                    //                    [SDImageCache sharedImageCache] remove
                }
                
                
                
                
                if (!isHavePwoer) {
                    deleteContentBtn.hidden = YES;
                }
                else{
                    if (!editOrSuccess) {
                        deleteContentBtn.hidden = YES;
                    }
                    else{
                        deleteContentBtn.hidden = NO;
                    }
                }
            }
            
            
            
//            hh = (50+imgV.height)*(i+1);
            hh = imgV.bottom+20;
            
            if (!isHavePwoer) {
                imgV.userInteractionEnabled = NO;
                contentV.userInteractionEnabled = NO;
            }else{
                if (!editOrSuccess){
                    contentV.userInteractionEnabled = NO;
                    imgV.userInteractionEnabled = NO;
                }else{
                    contentV.userInteractionEnabled = YES;
                    imgV.userInteractionEnabled = YES;
                }
                
            }
        }
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, hh+10, kSCREEN_WIDTH, 1)];
        lineV.backgroundColor = COLOR_BLACK_CLASS_0;
        
        [self.bottomV addSubview:lineV];
        
        UILabel *contuinueAddL = [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-100, hh+20, 80, 20)];
        contuinueAddL.textColor = Blue_Color;
        contuinueAddL.text = @"继续添加";
        contuinueAddL.font = [UIFont systemFontOfSize
                              :14];
        contuinueAddL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapTag = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(continueAddContent)];
        [contuinueAddL addGestureRecognizer:tapTag];
        //        companyJob.backgroundColor = Red_Color;
        contuinueAddL.textAlignment = NSTextAlignmentCenter;
        
        [self.bottomV addSubview:contuinueAddL];
        
        if (!isHavePwoer) {
            contuinueAddL.hidden = YES;
            lineV.hidden = YES;
        }else{
            if (!editOrSuccess){
            contuinueAddL.hidden = YES;
                lineV.hidden = YES;
            }else{
            contuinueAddL.hidden = NO;
                lineV.hidden = NO;
            }
            
        }
        
        CGFloat bottovHHH = self.scrollView.height-self.infoL.height-1;
        if ((hh+20+20)>=bottovHHH) {
            self.bottomV.frame = CGRectMake(0, self.lineOneV.bottom, kSCREEN_WIDTH, hh+40);
            self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, hh+40+20+self.topSrcV.height);
        }else{
            self.bottomV.frame = CGRectMake(0, self.lineOneV.bottom, kSCREEN_WIDTH, self.scrollView.height-self.infoL.height-1);
            self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, self.scrollView.height);
        }
    }
}

#pragma mark - UITextViewDelegate

//-(void)textViewDidChange:(UITextView *)textView{
//    YSNLog(@"%ld",(long)textView.tag);
//    for (UIView *labelV in textView.subviews) {
//        if ([labelV isKindOfClass:[UILabel class]]) {
//            
//            if (textView.text.length) {
//                labelV.hidden = YES;
//            }
//            else{
//                labelV.hidden = NO;
//            }
//            }
//        }
//    
//}
//
//-(void)textViewDidEndEditing:(UITextView *)textView{
//    //    YSNLog(@"%ld",(long)textView.tag);
//    NSInteger tag = textView.tag;
//    YSNLog(@"%ld",tag);
//    for (UIView *labelV in textView.subviews) {
//        if ([labelV isKindOfClass:[UILabel class]]) {
//            
//            if (textView.text.length) {
//                labelV.hidden = YES;
//            }
//            else{
//                labelV.hidden = NO;
//            }
//        }
//    }
//    SupervisionModel *model = self.tempContentArray[tag];
//    model.contents = textView.text;
//    [self.tempContentArray replaceObjectAtIndex:tag withObject:model];
//    [self resetContentSrcV];
//}

#pragma mark - 获取监理权限
-(void)judgeSuperversonJob{
    NSString *defaultApi = [BASEURL stringByAppendingString:@"constructionPerson/getJobName.do"];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID),
                               @"agencyId":@(user.agencyId),
                               @"nodeNumber":@(3004),
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
//                    self.successBtn.hidden = NO;
                    
                    if (self.isComplete) {
                        isHavePwoer = NO;
                    }
                    else{
                        isHavePwoer = YES;
                    }
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                case 1001:
                    
                {
//                    self.successBtn.hidden = YES;
                    isHavePwoer  = NO;
                    
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                case 2000:
                    
                {
                    //                    [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                default:
                    break;
            }
            
            
            [self getsupervisionDiar];
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 获取监理日志详情
-(void)getsupervisionDiar{
    [self.imgOrUrlArr removeAllObjects];
    [self.supervisionInfoArray removeAllObjects];
    [self.supervisionContentArray removeAllObjects];
    [self.tempInfoArray removeAllObjects];
    [self.tempContentArray removeAllObjects];
    
    [self.view hudShow];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"supervision/getRecords.do"];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                    if ([responseObj[@"supervisionInfo"] isKindOfClass:[NSArray class]]) {
                        NSArray *array = responseObj[@"supervisionInfo"];
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[SupervisionModel class] json:array];
                        [self.supervisionInfoArray addObjectsFromArray:arr];
                        
                        if (self.supervisionInfoArray.count>0) {
                            for (SupervisionModel *model in self.supervisionInfoArray) {
                                [self.imgOrUrlArr addObject:model.picture];
                            }
                        }
                        
                    };
                    
                    if ([responseObj[@"supervisionContent"] isKindOfClass:[NSArray class]]) {
                        NSArray *array = responseObj[@"supervisionContent"];
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[SupervisionModel class] json:array];
                        [self.supervisionContentArray addObjectsFromArray:arr];
                    };
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                case 1001:
                    
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
            
            
            [self.tempInfoArray addObjectsFromArray:self.supervisionInfoArray];
            [self.tempContentArray addObjectsFromArray:self.supervisionContentArray];
            
            
            
            if (self.tempInfoArray.count<=0&&self.tempContentArray.count<=0) {
                isFirstEdit = YES;
            }
            else{
                isFirstEdit = NO;
            }
            
            if (isFirstEdit) {
                if (isHavePwoer) {
                    self.successBtn.hidden = NO;
                    [self.successBtn setTitle:@"提交" forState:UIControlStateNormal];
                    editOrSuccess = YES;
                }
                else{
                    self.successBtn.hidden = YES;
                    editOrSuccess = NO;
                }
            }
            else{
                if (isHavePwoer) {
                    self.successBtn.hidden = NO;
                    [self.successBtn setTitle:@"编辑" forState:UIControlStateNormal];
                    editOrSuccess = NO;
                    
                }
                else{
                    self.successBtn.hidden = YES;
                    editOrSuccess = NO;
                }
            }
            

            
            NSInteger count = self.tempContentArray.count;
            if (count==0) {
                SupervisionModel *model = [[SupervisionModel alloc]init];
                model.picture = @"";
                model.id = @"0";
                model.contents = @"";
                model.info = @"0";
                model.grade = @"";
                model.constructionId = [NSString stringWithFormat:@"%ld",self.consID];
                [self.tempContentArray addObject:model];
            }
            [self.tableView reloadData];
            [self configurPhotosView];
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - action

-(void)success{
    if (editOrSuccess == NO) {
        editOrSuccess = YES;
        
        NSMutableArray *tempArray = [NSMutableArray array];
        [tempArray addObjectsFromArray:self.imgOrUrlArr];
        [tempArray addObject:[UIImage imageNamed:@"jia1"]];
        //有权限，并且是编辑状态，才显示+按钮，和右上角的-按钮
        if (isHavePwoer&&editOrSuccess){
            self.photosView.isShowAddBtn = YES;
            self.photosView.isShowScrDeleteBtn = YES;
        }
        else{
            [tempArray removeLastObject];
            self.photosView.isShowAddBtn = NO;
            self.photosView.isShowScrDeleteBtn = NO;
        }
        _photosView.isRow = YES;
        _photosView.isShowScrDeleteBtn = YES;
        [_photosView setYPPhotosView:tempArray];
        
        NSInteger a = tempArray.count;
        [self resetFrame:a];
        [self.successBtn setTitle:@"提交" forState:UIControlStateNormal];
//        [self resetInfoScrV];
//        [self resetContentSrcV];
        [self.tableView reloadData];
    }
    
    else {
        //        editOrSuccess = NO;
        //        [self.successBtn setTitle:@"编辑" forState:UIControlStateNormal];
        
        [self.view endEditing:YES];
        NSString *addStr = @"";
        NSString *deleteStr = @"";
        NSString *editStr = @"";
        //    NSMutableArray *addArray = [NSMutableArray array];
        //    NSMutableArray *deleteArray = [NSMutableArray array];
        //    NSMutableArray *editArray = [NSMutableArray array];
        [self.addArray removeAllObjects];
        [self.deleteArray removeAllObjects];
        [self.editArray removeAllObjects];
        //当前数组与原始数组做比较，找出1.新添加的 2。删除的 3.编辑的
        
        NSInteger infoNum = self.tempInfoArray.count;
        NSInteger contentNum = self.tempContentArray.count;
        if (infoNum<=0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"监理信息不能为空" controller:self sleep:1.5];
            return;
        }
        
//        if (contentNum>0) {
//            SupervisionModel *model = self.tempContentArray[contentNum-1];
//            if ((model.contents.length<=0)) {
//                [[PublicTool defaultTool] publicToolsHUDStr:@"监理内容不能为空" controller:self sleep:1.5];
//                return;
//            }
//        }
        
        //把数组中内容和图片为空的都剔除掉
        NSMutableArray *temDeleteArray = [NSMutableArray array];
        for (int i = 0; i<contentNum; i++) {
            SupervisionModel *model = self.tempContentArray[i];
            if (model.contents.length<=0&&model.picture.length<=0) {
                [temDeleteArray addObject:model];
            }
        }
        [self.tempContentArray removeObjectsInArray:temDeleteArray];
        
        if ((self.supervisionInfoArray.count<=0)&&(self.supervisionContentArray.count<=0)) {
            //都为空
            //[{"id":"28","contents":null,"picture":"http://image.bilinerju.com/group1/M00/00/94/cH5AcVkRrVaAYzMbAABJKDNS1hk010.jpg","info":0,"constructionId":1217,"grade":0}]
            
            for (SupervisionModel *model in self.tempInfoArray) {
                NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
                
                [addDict setObject:model.id forKey:@"id"];
                [addDict setObject:model.contents forKey:@"contents"];
                [addDict setObject:model.picture forKey:@"picture"];
                [addDict setObject:@"1" forKey:@"info"];
                [addDict setObject:@(self.consID) forKey:@"constructionId"];
                [addDict setObject:@"" forKey:@"grade"];
                [self.addArray addObject:addDict];
            }
            
            for (SupervisionModel *model in self.tempContentArray) {
                NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
                
                [addDict setObject:model.id forKey:@"id"];
                [addDict setObject:model.contents forKey:@"contents"];
                [addDict setObject:model.picture forKey:@"picture"];
                [addDict setObject:@"0" forKey:@"info"];
                [addDict setObject:@(self.consID) forKey:@"constructionId"];
                [addDict setObject:@"" forKey:@"grade"];
                [self.addArray addObject:addDict];
            }
            
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.addArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            addStr = jsonStr;
            addStr = [addStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSData *jsonDataDelete = [NSJSONSerialization dataWithJSONObject:self.deleteArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStrDelete = [[NSString alloc]initWithData:jsonDataDelete encoding:NSUTF8StringEncoding];
            deleteStr = jsonStrDelete;
            deleteStr = [deleteStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSData *jsonDataEdit = [NSJSONSerialization dataWithJSONObject:self.editArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStrEdit = [[NSString alloc]initWithData:jsonDataEdit encoding:NSUTF8StringEncoding];
            editStr = jsonStrEdit;
            editStr = [editStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            
        }
        else if((self.supervisionInfoArray.count<=0)&&(self.supervisionContentArray.count>0)){
            //原数组信息为空 内容不为空
            for (SupervisionModel *model in self.tempInfoArray) {
                NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
                
                [addDict setObject:model.id forKey:@"id"];
                [addDict setObject:model.contents forKey:@"contents"];
                [addDict setObject:model.picture forKey:@"picture"];
                [addDict setObject:@"1" forKey:@"info"];
                [addDict setObject:@(self.consID) forKey:@"constructionId"];
                [addDict setObject:@"" forKey:@"grade"];
                [self.addArray addObject:addDict];
            }
            
            //获取新添加的元素--遍历新数组的每一个元素的id是否等于0
            for (SupervisionModel *model in self.tempContentArray){
                if ([model.id integerValue]==0) {
                    NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
                    
                    [addDict setObject:model.id forKey:@"id"];
                    [addDict setObject:model.contents forKey:@"contents"];
                    [addDict setObject:model.picture forKey:@"picture"];
                    [addDict setObject:@"0" forKey:@"info"];
                    [addDict setObject:@(self.consID) forKey:@"constructionId"];
                    [addDict setObject:@"" forKey:@"grade"];
                    [self.addArray addObject:addDict];
                }
            }
            
            //获取删除的元素--遍历旧数组的每一个元素是否存在于新数组中
            for (SupervisionModel *model in self.supervisionContentArray) {
                if (![self.tempContentArray containsObject:model]) {
                    NSMutableDictionary *deleteDict = [NSMutableDictionary dictionary];
                    
                    [deleteDict setObject:model.id forKey:@"id"];
                    [deleteDict setObject:model.contents forKey:@"contents"];
                    [deleteDict setObject:model.picture forKey:@"picture"];
                    [deleteDict setObject:@"0" forKey:@"info"];
                    [deleteDict setObject:@(self.consID) forKey:@"constructionId"];
                    [deleteDict setObject:@"" forKey:@"grade"];
                    [self.deleteArray addObject:deleteDict];
                }
            }
            
            //        //因为信息为空，所有每一个信息的元素都放到删除数组里面
            //        for (SupervisionModel *model in self.supervisionInfoArray) {
            //            NSMutableDictionary *deleteDict = [NSMutableDictionary dictionary];
            //
            //            [deleteDict setObject:model.id forKey:@"id"];
            //            [deleteDict setObject:@"" forKey:@"contents"];
            //            [deleteDict setObject:model.picture forKey:@"picture"];
            //            [deleteDict setObject:@"0" forKey:@"info"];
            //            [deleteDict setObject:@(self.consID) forKey:@"constructionId"];
            //            [deleteDict setObject:@"" forKey:@"grade"];
            //            [self.deleteArray addObject:deleteDict];
            //        }
            
            //获取编辑的元素  遍历新数组，判断新数组的每一个元素，只要不是新增的，就是编辑的
            for (SupervisionModel *model in self.tempContentArray) {
                if (!([model.id integerValue]==0)) {
                    NSMutableDictionary *editDict = [NSMutableDictionary dictionary];
                    
                    [editDict setObject:model.id forKey:@"id"];
                    [editDict setObject:model.contents forKey:@"contents"];
                    [editDict setObject:model.picture forKey:@"picture"];
                    [editDict setObject:@"0" forKey:@"info"];
                    [editDict setObject:@(self.consID) forKey:@"constructionId"];
                    [editDict setObject:@"" forKey:@"grade"];
                    [self.editArray addObject:editDict];
                }
            }
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.addArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            addStr = jsonStr;
            addStr = [addStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSData *jsonDataDelete = [NSJSONSerialization dataWithJSONObject:self.deleteArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStrDelete = [[NSString alloc]initWithData:jsonDataDelete encoding:NSUTF8StringEncoding];
            deleteStr = jsonStrDelete;
            deleteStr = [deleteStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSData *jsonDataEdit = [NSJSONSerialization dataWithJSONObject:self.editArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStrEdit = [[NSString alloc]initWithData:jsonDataEdit encoding:NSUTF8StringEncoding];
            editStr = jsonStrEdit;
            editStr = [editStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
        }
        
        else if((self.supervisionInfoArray.count>0)&&(self.supervisionContentArray.count<=0)){
            //原数组信息不为空 内容为空
            for (SupervisionModel *model in self.tempContentArray) {
                NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
                
                [addDict setObject:model.id forKey:@"id"];
                [addDict setObject:model.contents forKey:@"contents"];
                [addDict setObject:model.picture forKey:@"picture"];
                [addDict setObject:@"0" forKey:@"info"];
                [addDict setObject:@(self.consID) forKey:@"constructionId"];
                [addDict setObject:@"" forKey:@"grade"];
                [self.addArray addObject:addDict];
            }
            
            //获取新添加的元素--遍历新数组的每一个元素的id是否等于0
            for (SupervisionModel *model in self.tempInfoArray){
                if ([model.id integerValue]==0) {
                    NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
                    
                    [addDict setObject:model.id forKey:@"id"];
                    [addDict setObject:model.contents forKey:@"contents"];
                    [addDict setObject:model.picture forKey:@"picture"];
                    [addDict setObject:@"1" forKey:@"info"];
                    [addDict setObject:@(self.consID) forKey:@"constructionId"];
                    [addDict setObject:@"" forKey:@"grade"];
                    [self.addArray addObject:addDict];
                }
            }
            
            //获取删除的元素--遍历旧数组的每一个元素是否存在于新数组中
            for (SupervisionModel *model in self.supervisionInfoArray) {
                if (![self.tempInfoArray containsObject:model]) {
                    NSMutableDictionary *deleteDict = [NSMutableDictionary dictionary];
                    
                    [deleteDict setObject:model.id forKey:@"id"];
                    [deleteDict setObject:model.contents forKey:@"contents"];
                    [deleteDict setObject:model.picture forKey:@"picture"];
                    [deleteDict setObject:@"1" forKey:@"info"];
                    [deleteDict setObject:@(self.consID) forKey:@"constructionId"];
                    [deleteDict setObject:@"" forKey:@"grade"];
                    [self.deleteArray addObject:deleteDict];
                }
            }
            
            //        //因为信息为空，所有每一个信息的元素都放到删除数组里面
            //        for (SupervisionModel *model in self.supervisionInfoArray) {
            //            NSMutableDictionary *deleteDict = [NSMutableDictionary dictionary];
            //
            //            [deleteDict setObject:model.id forKey:@"id"];
            //            [deleteDict setObject:@"" forKey:@"contents"];
            //            [deleteDict setObject:model.picture forKey:@"picture"];
            //            [deleteDict setObject:@"0" forKey:@"info"];
            //            [deleteDict setObject:@(self.consID) forKey:@"constructionId"];
            //            [deleteDict setObject:@"" forKey:@"grade"];
            //            [self.deleteArray addObject:deleteDict];
            //        }
            
            //获取编辑的元素  遍历新数组，判断新数组的每一个元素，只要不是新增的，就是编辑的
            for (SupervisionModel *model in self.tempInfoArray) {
                if (!([model.id integerValue]==0)) {
                    NSMutableDictionary *editDict = [NSMutableDictionary dictionary];
                    
                    [editDict setObject:model.id forKey:@"id"];
                    [editDict setObject:model.contents forKey:@"contents"];
                    [editDict setObject:model.picture forKey:@"picture"];
                    [editDict setObject:@"1" forKey:@"info"];
                    [editDict setObject:@(self.consID) forKey:@"constructionId"];
                    [editDict setObject:@"" forKey:@"grade"];
                    [self.editArray addObject:editDict];
                }
            }
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.addArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            addStr = jsonStr;
            addStr = [addStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSData *jsonDataDelete = [NSJSONSerialization dataWithJSONObject:self.deleteArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStrDelete = [[NSString alloc]initWithData:jsonDataDelete encoding:NSUTF8StringEncoding];
            deleteStr = jsonStrDelete;
            deleteStr = [deleteStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSData *jsonDataEdit = [NSJSONSerialization dataWithJSONObject:self.editArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStrEdit = [[NSString alloc]initWithData:jsonDataEdit encoding:NSUTF8StringEncoding];
            editStr = jsonStrEdit;
            editStr = [editStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
        }
        
        else if((self.supervisionInfoArray.count>0)&&(self.supervisionContentArray.count>0)){
            //原数组信息不为空 内容也不为空
            //获取新添加的元素--遍历新数组的每一个元素的id是否等于0
            for (SupervisionModel *model in self.tempContentArray){
                if ([model.id integerValue]==0) {
                    NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
                    
                    [addDict setObject:model.id forKey:@"id"];
                    [addDict setObject:model.contents forKey:@"contents"];
                    [addDict setObject:model.picture forKey:@"picture"];
                    [addDict setObject:@"0" forKey:@"info"];
                    [addDict setObject:@(self.consID) forKey:@"constructionId"];
                    [addDict setObject:@"" forKey:@"grade"];
                    [self.addArray addObject:addDict];
                }
            }
            
            //获取新添加的元素--遍历新数组的每一个元素的id是否等于0
            for (SupervisionModel *model in self.tempInfoArray){
                if ([model.id integerValue]==0) {
                    NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
                    
                    [addDict setObject:model.id forKey:@"id"];
                    [addDict setObject:model.contents forKey:@"contents"];
                    [addDict setObject:model.picture forKey:@"picture"];
                    [addDict setObject:@"1" forKey:@"info"];
                    [addDict setObject:@(self.consID) forKey:@"constructionId"];
                    [addDict setObject:@"" forKey:@"grade"];
                    [self.addArray addObject:addDict];
                }
            }
            
            
            
            //获取删除的元素--遍历旧数组的每一个元素是否存在于新数组中
            for (SupervisionModel *model in self.supervisionInfoArray) {
                if (![self.tempInfoArray containsObject:model]) {
                    NSMutableDictionary *deleteDict = [NSMutableDictionary dictionary];
                    
                    [deleteDict setObject:model.id forKey:@"id"];
                    [deleteDict setObject:@"" forKey:@"contents"];
                    [deleteDict setObject:model.picture forKey:@"picture"];
                    [deleteDict setObject:@"1" forKey:@"info"];
                    [deleteDict setObject:@(self.consID) forKey:@"constructionId"];
                    [deleteDict setObject:@"" forKey:@"grade"];
                    [self.deleteArray addObject:deleteDict];
                }
            }
            
            //获取删除的元素--遍历旧数组的每一个元素是否存在于新数组中
            for (SupervisionModel *model in self.supervisionContentArray) {
                if (![self.tempContentArray containsObject:model]) {
                    NSMutableDictionary *deleteDict = [NSMutableDictionary dictionary];
                    
                    [deleteDict setObject:model.id forKey:@"id"];
                    [deleteDict setObject:@"" forKey:@"contents"];
                    [deleteDict setObject:model.picture forKey:@"picture"];
                    [deleteDict setObject:@"0" forKey:@"info"];
                    [deleteDict setObject:@(self.consID) forKey:@"constructionId"];
                    [deleteDict setObject:@"" forKey:@"grade"];
                    [self.deleteArray addObject:deleteDict];
                }
            }
            
            
            //获取编辑的元素  遍历新数组，判断新数组的每一个元素，只要不是新增的，就是编辑的
            for (SupervisionModel *model in self.tempInfoArray) {
                if (!([model.id integerValue]==0)) {
                    NSMutableDictionary *editDict = [NSMutableDictionary dictionary];
                    
                    [editDict setObject:model.id forKey:@"id"];
                    [editDict setObject:model.contents forKey:@"contents"];
                    [editDict setObject:model.picture forKey:@"picture"];
                    [editDict setObject:@"1" forKey:@"info"];
                    [editDict setObject:@(self.consID) forKey:@"constructionId"];
                    [editDict setObject:@"" forKey:@"grade"];
                    [self.editArray addObject:editDict];
                }
            }
            
            //获取编辑的元素  遍历新数组，判断新数组的每一个元素，只要不是新增的，就是编辑的
            for (SupervisionModel *model in self.tempContentArray) {
                if (!([model.id integerValue]==0)) {
                    NSMutableDictionary *editDict = [NSMutableDictionary dictionary];
                    
                    [editDict setObject:model.id forKey:@"id"];
                    [editDict setObject:model.contents forKey:@"contents"];
                    [editDict setObject:model.picture forKey:@"picture"];
                    [editDict setObject:@"0" forKey:@"info"];
                    [editDict setObject:@(self.consID) forKey:@"constructionId"];
                    [editDict setObject:@"" forKey:@"grade"];
                    [self.editArray addObject:editDict];
                }
            }
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.addArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            addStr = jsonStr;
            addStr = [addStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSData *jsonDataDelete = [NSJSONSerialization dataWithJSONObject:self.deleteArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStrDelete = [[NSString alloc]initWithData:jsonDataDelete encoding:NSUTF8StringEncoding];
            deleteStr = jsonStrDelete;
            deleteStr = [deleteStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSData *jsonDataEdit = [NSJSONSerialization dataWithJSONObject:self.editArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStrEdit = [[NSString alloc]initWithData:jsonDataEdit encoding:NSUTF8StringEncoding];
            editStr = jsonStrEdit;
            editStr = [editStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
        }
        
        else{
            
        }
        
        
        
        [self.view hudShow];
        //        NSString *str = @"http://192.168.0.186:8080/blej-api-blej/api/";
        NSString *defaultApi = [BASEURL stringByAppendingString:@"supervision/saveRecords.do"];
        NSDictionary *paramDic = @{@"listDel":deleteStr,
                                   @"listAdd":addStr,
                                   @"listUpdate":editStr
                                   };
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
            [self.view hiddleHud];
            if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
                
                NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
                
                switch (statusCode) {
                    case 1000:
                        
                    {
                        editOrSuccess = NO;
                        [self.successBtn setTitle:@"编辑" forState:UIControlStateNormal];
                        //        [self.successBtn setTitle:@"编辑" forState:UIControlStateNormal];
                        [[PublicTool defaultTool] publicToolsHUDStr:@"修改成功" controller:self sleep:1.5];
////                        [self.navigationController popViewControllerAnimated:YES];
//
//                        [self resetContentSrcV];
//                        
//                        
//                        
//                        NSMutableArray *tempArray = [NSMutableArray array];
//                        [tempArray addObjectsFromArray:self.imgOrUrlArr];
//
//                            self.photosView.isShowAddBtn = NO;
//                            self.photosView.isShowScrDeleteBtn = NO;
//
//                        _photosView.isRow = YES;
//
//                        [_photosView setYPPhotosView:tempArray];
//                        
//                        NSInteger a = tempArray.count;
//                        [self resetFrame:a];
                        [self getsupervisionDiar];
                        
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
    
}

-(void)resetFrame:(NSInteger)n{
    
    _photosView.collectionView.height = self.topSrcV.height;
    //    _photosView.collectionView.width = self.topSrcV.height;
    //    self.scrollView.contentSize = CGSizeMake(0, _photosView.bottom+100);
    CGFloat ww = self.topSrcV.height*(n)+20;
//    self.photosView.frame = CGRectMake(self.infoL.right, 0, kSCREEN_WIDTH-self.infoL.width, 200);
    self.topSrcV.contentSize = CGSizeMake(ww, self.topSrcV.height);
    self.photosView.scrollView.contentSize = CGSizeMake(ww, self.topSrcV.height);
}

//-(void)changePhoto:(UIGestureRecognizer *)ges{
//    _changeTag = [ges view].tag;
//    [self imagePicker];
//}

//-(void)addContentPhoto{
//    [self imagePicker];
//}

-(void)continueAddContent{
    
    SupervisionModel *modelOne = self.tempContentArray.lastObject;
//    NSString *pic = modelOne.picture;
    NSString *contentStr = modelOne.contents;
    if (!(contentStr.length)) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请填上一个日志的内容" controller:self sleep:1.5];
    }
    else{
        SupervisionModel *model = [[SupervisionModel alloc]init];
        model.picture = @"";
        model.id = @"0";
        model.contents = @"";
        model.info = @"0";
        model.grade = @"";
        model.constructionId = [NSString stringWithFormat:@"%ld",self.consID];
        [self.tempContentArray addObject:model];
        //    [self.tempContentArray replaceObjectAtIndex:_contentTag withObject:model];
        
//        [self resetContentSrcV];
        [self.tableView reloadData];
    }
    
}

-(void)addPhoto{
//    _addInfoORContent = 1;
//    [self imagePicker];
}

-(void)deletePhoto{
    SupervisionModel *model = self.tempInfoArray[_deleteTag];
    [self.tempInfoArray removeObject:model];
    self.bottomV.frame = CGRectMake(0, self.lineOneV.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.infoL.height-1);
//    [self resetInfoScrV];
}

//-(void)deleteContent:(UIButton *)sender{
//    SupervisionModel *model = self.tempContentArray[sender.tag];
//    model.picture = @"";
//    [self.tempContentArray replaceObjectAtIndex:sender.tag withObject:model];
////    [self.tempContentArray removeObject:model];
//    [self resetContentSrcV];
//}

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
    
    NSArray *array = @[chooseImage];
    
//    NSData *imageData = UIImageJPEGRepresentation(chooseImage, 0.5);
    
//    if ([imageData length] >0) {
//        imageData = [GTMBase64 encodeData:imageData];
//    }
//    NSString *imageStr = [[NSString alloc]initWithData:imageData encoding:NSUTF8StringEncoding];
    
//    [self uploadImageWithBase64Str:imageStr];
    upInfoORContentImg = 2;
    [self uploadImgWith:array];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}



-(void)uploadImageWithBase64Str:(NSString*)base64Str{
    
    UploadImageApi *uploadApi = [[UploadImageApi alloc]initWithImgStr:base64Str type:@"png"];
    
    [uploadApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSDictionary *dic = request.responseJSONObject;
        NSString *code = [dic objectForKey:@"code"];
        
        if ([code isEqualToString:@"1000"]) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传成功" controller:self sleep:1.5];
            NSString *photoUrl = [dic objectForKey:@"imageUrl"];
//            if (_addInfoORContent == 1) {
//                SupervisionModel *model = [[SupervisionModel alloc]init];
//                model.picture = photoUrl;
//                model.id = @"0";
//                model.contents = @"";
//                model.info = @"1";
//                model.grade = @"";
//                model.constructionId = [NSString stringWithFormat:@"%ld",self.consID];
//                [self.tempInfoArray addObject:model];
//                
//                
//                [self resetInfoScrV];
//            }
//            else{
                SupervisionModel *model = self.tempContentArray[_changeTag];
                model.picture = photoUrl;
                //                model.id = @"0";
                ////                model.contents = @"";
                //                model.info = @"0";
                //                model.grade = @"";
                //                model.constructionId = [NSString stringWithFormat:@"%ld",self.consID];
                //                [self.tempContentArray addObject:model];
                [self.tempContentArray replaceObjectAtIndex:_changeTag withObject:model];
                
                [self resetContentSrcV];
//            }
            
            
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _tableView.contentInset = UIEdgeInsetsZero;
    _tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

#pragma mark - setter

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
//        _tableView.estimatedRowHeight = 200;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
//        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
//        self.automaticallyAdjustsScrollViewInsets
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"SupervisorDiaryCellTwo" bundle:nil] forCellReuseIdentifier:@"SupervisorDiaryCellTwo"];
        _tableView.backgroundColor = White_Color;
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


//- (UIScrollView *)scrollView
//{
//    if (!_scrollView) {
//        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64)];
//        //        _scrollView.backgroundColor = Red_Color;
//        
//        _scrollView.delegate = self;
//        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.showsVerticalScrollIndicator = NO;
//    }
//    return _scrollView;
//}
//
//-(UILabel *)infoL{
//    if (!_infoL) {
//        _infoL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, kSCREEN_WIDTH/3)];
//        _infoL.textColor = COLOR_BLACK_CLASS_3;
//        _infoL.font = [UIFont systemFontOfSize
//                       :14];
//        _infoL.backgroundColor = COLOR_BLACK_CLASS_0;
//        //        companyJob.backgroundColor = Red_Color;
//        _infoL.textAlignment = NSTextAlignmentCenter;
//        _infoL.text = @"监\n理\n信\n息";
//        _infoL.numberOfLines = 4;
//    }
//    return _infoL;
//}
//
//-(UIScrollView *)topSrcV{
//    if (!_topSrcV) {
//        _topSrcV = [[UIScrollView alloc]initWithFrame:CGRectMake(40, 0, kSCREEN_WIDTH-40, self.infoL.height)];
//        //        _topSrcV.backgroundColor = COLOR_BLACK_CLASS_0;
//    }
//    return _topSrcV;
//}
//
//-(UIView *)lineOneV{
//    if (!_lineOneV) {
//        _lineOneV = [[UIView alloc]initWithFrame:CGRectMake(0, self.infoL.bottom, kSCREEN_WIDTH, 1)];
//        _lineOneV.backgroundColor = COLOR_BLACK_CLASS_0;
//    }
//    return _lineOneV;
//}
//
//-(UIView *)bottomV{
//    if (!_bottomV) {
//        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, self.lineOneV.bottom, kSCREEN_WIDTH, self.scrollView.height-self.infoL.height-1)];
//        //        _bottomV.backgroundColor = COLOR_BLACK_CLASS_0;
//    }
//    return _bottomV;
//}
//
//-(YPPhotosView *)photosView{
//    if (!_photosView) {
//        _photosView = [[YPPhotosView alloc]initWithFrame:CGRectMake(0, 0, self.topSrcV.width, self.topSrcV.height)];
//    }
//    return _photosView;
//}


@end
