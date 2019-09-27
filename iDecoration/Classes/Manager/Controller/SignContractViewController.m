//
//  SignContractViewController.m
//  iDecoration
//
//  Created by RealSeven on 2017/4/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SignContractViewController.h"
#import "YPCommentView.h"
#import "TZImagePickerController.h"
#import "ASProgressPopUpView.h"
#import "NSObject+CompressImage.h"
#import "SetwWatermarkController.h"
#import "MuchUseModel.h"
#import "EditMuchUseController.h"
#import "AlertView.h"

#define MAXPHOTOCOUNT 18
#define kIsEmptyString(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

@interface SignContractViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate,UITextViewDelegate,ASProgressPopUpViewDataSource,AlertViewDelegate>{
    CGFloat textviewH;
    CGFloat keyBoardH;
}

//@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *signTableView;

@property (nonatomic, strong)UITextView *contentTV;
@property (nonatomic, strong)UILabel *placeholderSL;
@property (nonatomic, strong)UIView *lineSecondV;

@property (nonatomic, strong) ASProgressPopUpView *progress;
@property (nonatomic, strong) UIView *backShadowV;

@property (nonatomic,strong)YPPhotosView *photosView;
@property (nonatomic,strong)NSMutableArray *imgArr;

//图片上传完的url
@property (nonatomic,strong)NSString *imgUrlStr;
@property (nonatomic, assign) BOOL isHaveDeleteTag;//是否已经删除过
@property (nonatomic,strong) UIButton *phraseBtn;
@property (nonatomic,strong) NSMutableArray *muchUseArray;
@property (nonatomic,strong) NSMutableArray *muchUseArray2;
@property (nonatomic,copy) NSString *changyongyutype;//0 公司常用语  1 系统常用语
@property (nonatomic,strong) AlertView *alert;
@end

@implementation SignContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isHaveDeleteTag = NO;
    [self creatUI];
    self.changyongyutype = @"0";
    
    self.muchUseArray = [NSMutableArray array];
    self.muchUseArray2 = [NSMutableArray array];
    [self requestMuchUseData];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    


}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    keyBoardH = height;
    [UIView animateWithDuration:0.3 animations:^{
        self.phraseBtn.transform =CGAffineTransformMakeTranslation(0, -height-20);
    }];
}
//键盘退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
}

-(void)creatUI{
    self.view.backgroundColor = White_Color;
    self.imgUrlStr = @"";
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"提交" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(success) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentTV];
    [self.contentTV addSubview:self.placeholderSL];
    [self.scrollView addSubview:self.lineSecondV];
    [self configurPhotosView];
    
    self.phraseBtn.frame = CGRectMake(kSCREEN_WIDTH-50, kSCREEN_HEIGHT, 50, 20);
    [self.view addSubview:self.phraseBtn];
    self.alert = [AlertView GlodeBottomView];
    self.alert.delegate = self;

    self.alert.isshow = YES;
    [self.alert.tableView reloadData];
}

#pragma mark - 配置图片选择View
-(void)configurPhotosView {
    
    self.lineSecondV.frame = CGRectMake(10, self.contentTV.bottom+5, 200, 0);
    _photosView = [[YPPhotosView alloc]initWithFrame:CGRectMake(0, self.lineSecondV.bottom+5, kSCREEN_WIDTH, kSCREEN_WIDTH/3+5)];
    _photosView.isShowZongAddBtn = YES;
    _photosView.isShowDeleteBtn = YES;
    [_photosView setYPPhotosView:@[[UIImage imageNamed:@"jia_kuang"]]];
    __weak SignContractViewController *weakSelf=self;
    _photosView.clickcloseImage = ^(NSInteger index){
        
        [weakSelf resetDeleteUIWith:index];
        
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
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MAXPHOTOCOUNT-weakSelf.imgArr.count delegate:nil];
        
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//            [weakSelf.imgArr addObjectsFromArray:photos];

            
                    SetwWatermarkController *vc = [[SetwWatermarkController alloc]init];
                    vc.fromTag = 3;
                    vc.imgArray = [photos copy];
                    vc.companyName = weakSelf.companyName;
                    vc.comanyLogoStr = weakSelf.companyLogo;
            
                    vc.setWaterBlock = ^(NSMutableArray *dataArray, NSInteger b) {
                        [weakSelf.imgArr addObjectsFromArray:dataArray];
                        //
                                    if (weakSelf.imgArr.count>=MAXPHOTOCOUNT) {
                                        weakSelf.photosView.isShowZongAddBtn = NO;
                                        [weakSelf.photosView setYPPhotosView:weakSelf.imgArr];
                                    }
                                    else{
                                        weakSelf.photosView.isShowZongAddBtn = YES;
                        
                                        NSArray *arr = [weakSelf.imgArr arrayByAddingObjectsFromArray:@[[UIImage imageNamed:@"jia_kuang"]]];
                        
                                        [weakSelf.photosView setYPPhotosView:arr];
                                    }
                        
                                    NSTimeInterval animationDuration = 0.30f;
                                    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
                                    [UIView setAnimationDuration:animationDuration];
                                    NSInteger a = weakSelf.imgArr.count;
                        
                                    if (weakSelf.isHaveDeleteTag) {
                                        //已经删除过
                        
                                        weakSelf.lineSecondV.frame = CGRectMake(10, self.contentTV.bottom+5, 200, 0);
                                    }
                                    else{
                                        if (a>1) {
                                            weakSelf.lineSecondV.frame = CGRectMake(10, self.contentTV.bottom+5, 200, 30);
                                        }
                                        else{
                                            weakSelf.lineSecondV.frame = CGRectMake(10, self.contentTV.bottom+5, 200, 0);
                                        }
                                    }
                        
                                    if (a <3) {
                                        [weakSelf resetFrame:1];
                                    }else if (a<6){
                                        [weakSelf resetFrame:2];
                                    }else if (a<9){
                                        [weakSelf resetFrame:3];
                                    }
                                    else if (a<12){
                                        [weakSelf resetFrame:4];
                                    }else if (a<15){
                                        [weakSelf resetFrame:5];
                                    }
                                    else{
                                        [weakSelf resetFrame:6];
                                    }
                                    [UIView commitAnimations];
                        
                        
                    };
                    [weakSelf.navigationController pushViewController:vc animated:YES];
//
        }];
        
        
        
        if (self.imgArr.count>(MAXPHOTOCOUNT-1)) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"最多上传18张图片" controller:weakSelf sleep:1.5];
            return ;
        }
        [weakSelf presentViewController:imagePickerVc animated:YES completion:nil];
        
        
    };
    
    _photosView.changeImage = ^(NSIndexPath *fromPath, NSIndexPath *toPath) {
        YSNLog(@"%ld",fromPath.item);
        YSNLog(@"%ld",toPath.item);
        [weakSelf changeImageLocationWith:fromPath.item toTag:toPath.item];
    };
    
    [self.scrollView addSubview:_photosView];
}

#pragma mark - action

-(void)resetFrame:(NSInteger)n{
    _photosView.frame = CGRectMake(0, self.lineSecondV.bottom+5, kSCREEN_WIDTH, kSCREEN_WIDTH/3*n);
    _photosView.collectionView.height = _photosView.height;
    CGFloat photobottom = self.photosView.bottom;
    if (photobottom<=(kSCREEN_HEIGHT-60)) {
        self.scrollView.contentSize = CGSizeMake(0, 0);
    }
    else{
        self.scrollView.contentSize = CGSizeMake(0, photobottom+20);
    }
}

#pragma mark - 改变图片图片位置之后重置photoview
-(void)changeImageLocationWith:(NSInteger)fromTag toTag:(NSInteger)toTag{
    [self.imgArr exchangeObjectAtIndex:fromTag withObjectAtIndex:toTag];
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.photosView.isShowZongAddBtn = YES;
    NSArray *arr = [self.imgArr arrayByAddingObjectsFromArray:@[[UIImage imageNamed:@"jia_kuang"]]];
    
    [self.photosView setYPPhotosView:arr];
    NSInteger a = self.imgArr.count;
    
    if (a <3) {
        [self resetFrame:1];
    }else if (a<6){
        [self resetFrame:2];
    }else if (a<9){
        [self resetFrame:3];
    }else if (a<12){
        [self resetFrame:4];
    }else if (a<15){
        [self resetFrame:5];
    }
    else{
        [self resetFrame:6];
    }
    [UIView commitAnimations];
}

#pragma mark - 删除图片之后重置photoview
-(void)resetDeleteUIWith:(NSInteger)tag{
    [self.imgArr removeObjectAtIndex:tag];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.photosView.isShowZongAddBtn = YES;
    NSArray *arr = [self.imgArr arrayByAddingObjectsFromArray:@[[UIImage imageNamed:@"jia_kuang"]]];
    
    [self.photosView setYPPhotosView:arr];
    NSInteger a = self.imgArr.count;

    if (a <3) {
        [self resetFrame:1];
    }else if (a<6){
        [self resetFrame:2];
    }else if (a<9){
        [self resetFrame:3];
    }else if (a<12){
        [self resetFrame:4];
    }else if (a<15){
        [self resetFrame:5];
    }
    else{
        [self resetFrame:6];
    }
    [UIView commitAnimations];
}

#pragma mark - 删除拖拽提示

-(void)deleteTip{
    self.isHaveDeleteTag = YES;
    self.lineSecondV.frame = CGRectMake(10, self.contentTV.bottom+5, 200, 0);
    
    NSInteger a = self.imgArr.count;
    [self resetFrame:a];
}

#pragma mark - action
-(void)success{
    [self.view endEditing:YES];
    NSString *temStr = self.contentTV.text;
    temStr = [temStr ew_removeSpaces];
    temStr = [temStr ew_removeSpacesAndLineBreaks];
    if (temStr.length == 0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"内容不能为空" controller:self sleep:1.5];
        return;
    }
    NSInteger countN = self.imgArr.count;
    if (countN==0) {
        self.imgUrlStr = @"";
        [self postData];
    }

    else{
        [self uploadImgWith:self.imgArr];
        
    }
}

#pragma mark - ASProgressPopUpView dataSource

// <ASProgressPopUpViewDataSource> is entirely optional
// it allows you to supply custom NSStrings to ASProgressPopUpView
- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *s;
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
        
        [self.progress removeFromSuperview];
        self.backShadowV.alpha = 0.0f;
        [self.backShadowV removeAllSubViews];
        
        YSNLog(@"```上传成功``` %@",responseObject);
        NSArray *arr = [responseObject objectForKey:@"imgList"];
        NSMutableArray *imgArr = [NSMutableArray array];
        [imgArr removeAllObjects];
        for (NSDictionary *dict in arr) {
            [imgArr addObject:[dict objectForKey:@"imgUrl"]];
        }
        if (imgArr.count == 1) {
            self.imgUrlStr = imgArr[0];
        }else{
            self.imgUrlStr = [imgArr componentsJoinedByString:@","];
        }
        
        YSNLog(@"%@",self.imgUrlStr);
        [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传成功" controller:self sleep:1.5];
        [self postData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YSNLog(@"xxx上传失败xxx %@", error);
        
        [self.progress removeFromSuperview];
        self.backShadowV.alpha = 0.0f;
        [self.backShadowV removeAllSubViews];
        
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        
    }];
}

-(void)uploadImageWithBase64Str:(NSString*)base64Str{
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"file/uploadFiles.do"];
    NSDictionary *paramDic = @{@"file":base64Str
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                {
                    if ([responseObj[@"imageUrl"] isKindOfClass:[NSString class]]) {
                        self.imgUrlStr = responseObj[@"imageUrl"];
                        
                    };
                    [self postData];
                
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

#pragma mark - 加完水印之后，重新上传图片

-(void)reUploadWaterPhotoWithImgArray:(NSMutableArray *)imgArray{
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
        
        [self.progress removeFromSuperview];
        self.backShadowV.alpha = 0.0f;
        [self.backShadowV removeAllSubViews];
        
        YSNLog(@"```上传成功``` %@",responseObject);
        NSArray *arr = [responseObject objectForKey:@"imgList"];
        NSMutableArray *imgArr = [NSMutableArray array];
        [imgArr removeAllObjects];
        for (NSDictionary *dict in arr) {
            [imgArr addObject:[dict objectForKey:@"imgUrl"]];
        }
        if (imgArr.count == 1) {
            self.imgUrlStr = imgArr[0];
        }else{
            self.imgUrlStr = [imgArr componentsJoinedByString:@","];
        }
        
        YSNLog(@"%@",self.imgUrlStr);
        [[PublicTool defaultTool] publicToolsHUDStr:@"图片上传成功" controller:self sleep:1.5];
        [self postData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YSNLog(@"xxx上传失败xxx %@", error);
        
        [self.progress removeFromSuperview];
        self.backShadowV.alpha = 0.0f;
        [self.backShadowV removeAllSubViews];
        
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        
    }];
}

#pragma mark - 新的新增节点的接口
-(void)postData{
    [self.view hudShow];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSMutableArray *imgArray = [NSMutableArray array];
    if (self.imgUrlStr.length<=0) {
        //没有图片
    }
    else{
        NSArray *temImgArray = [self.imgUrlStr componentsSeparatedByString:@","];
        for (int i =0; i<temImgArray.count; i++) {
            NSMutableDictionary *temDetailDict = [NSMutableDictionary dictionary];
            NSString *imgStr = temImgArray[i];
            [temDetailDict setObject:imgStr forKey:@"imgUrl"];
            [temDetailDict setObject:@(i) forKey:@"sort"];
            [imgArray addObject:temDetailDict];
        }
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:imgArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"journal/newSave.do"];
    NSDictionary *paramDic = @{@"content":self.contentTV.text,
                               @"cJobTypeId":@(self.cJobTypeIdStr),
                               @"agencysId":@(user.agencyId),
                               @"constructionId":@(self.constructionIdStr),
                               @"type":self.type,
                               @"likeNum":@(0),
                               @"addFlag":@(1),
                               @"isAdd":@(self.isAdd),
                               @"img":constructionStr2,
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"填写成功" controller:self sleep:1.5];
                    if (self.index == 1) {
                        
                        //添加施工日志节点通知
                        NSDictionary *dict = @{@"node":self.type};
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"addContructionNode" object:nil userInfo:dict];
                    }
                    else{
                        //添加主材日志节点通知
                        
                        NSDictionary *dict = @{@"node":self.type};
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"addMatieralNode" object:nil userInfo:dict];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
                    break;
                    //sty loading
                case 1001:{
                    [[PublicTool defaultTool] publicToolsHUDStr:@"对不起，你已经填写过该节点了" controller:self sleep:1.5];
                }
                    break;
                default:
                    break;
            }

        }
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.scrollView.contentSize = CGSizeMake(0, _photosView.bottom+20);
}

- (void)textViewDidChange:(UITextView *)textView
{
    @try{
        
        
        if (self.contentTV.text.length == 0) {
            self.placeholderSL.hidden = NO;
        }else{
            self.placeholderSL.hidden = YES;
        }
        
        
        
        CGFloat width = CGRectGetWidth(self.contentTV.frame);
        CGFloat height = CGRectGetHeight(self.contentTV.frame);
        CGSize newSize = [self.contentTV sizeThatFits:CGSizeMake(width,MAXFLOAT)];
        
        CGRect newFrame = self.contentTV.frame;
        if (newSize.height<height) {
            
            if (newSize.height<50) {
                newSize.height=50;
            }
            newFrame.size = CGSizeMake(fmax(width, newSize.width), newSize.height);
        }
        else{
            newFrame.size = CGSizeMake(fmax(width, newSize.width), fmax(height, newSize.height));
        }
        
        CGFloat cha = 0;
        if (newFrame.size.height!=textviewH) {
            if (newFrame.size.height>textviewH) {
                cha = newFrame.size.height-textviewH;
                self.scrollView.contentSize = CGSizeMake(0, _photosView.bottom+20+cha);
            }
            else{
                cha = textviewH-newFrame.size.height;
                self.scrollView.contentSize = CGSizeMake(0, _photosView.bottom+20-cha);
            }
        }
        
        
        self.contentTV.frame= newFrame;
        textviewH = newFrame.size.height;
        if (!self.isHaveDeleteTag&&self.imgArr.count>=2) {
            self.lineSecondV.frame = CGRectMake(0, self.contentTV.bottom+5, kSCREEN_WIDTH, 30);
        }
        else{
            self.lineSecondV.frame = CGRectMake(0, self.contentTV.bottom+5, kSCREEN_WIDTH, 0);
        }
        self.photosView.top = self.lineSecondV.bottom+5;

        
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
    
    
    
}



-(void)textViewDidEndEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.phraseBtn.transform =CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        
    }];
    
    if (self.contentTV.text.length == 0) {
        self.placeholderSL.hidden = NO;
    }else{
        self.placeholderSL.hidden = YES;
    }
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    CGFloat photobottom = self.photosView.bottom;
    
    if (photobottom<=(kSCREEN_HEIGHT-60)) {
        self.scrollView.contentSize = CGSizeMake(0, 0);
    }
    else{
        self.scrollView.contentSize = CGSizeMake(0, photobottom+20);
    }
}

#pragma mark - setter


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64)];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}


-(UITextView *)contentTV{
    if (!_contentTV) {
        _contentTV = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH-10, 40)];
        _contentTV.delegate = self;
        _contentTV.textColor = COLOR_BLACK_CLASS_3;
        _contentTV.font = NB_FONTSEIZ_NOR;
        _contentTV.delegate = self;
        textviewH = 40;
        _contentTV.textContainerInset = UIEdgeInsetsMake(15,0, 10, 20);
        _contentTV.scrollEnabled = NO;
    }
    return _contentTV;
}

-(UILabel *)placeholderSL{
    if (!_placeholderSL) {
        _placeholderSL = [[UILabel alloc]initWithFrame:CGRectMake(5, 13, 150, 20)];
        _placeholderSL.textColor = HEX_COLOR(0xc5c5c5);
        _placeholderSL.text = @"这一刻的想法";
        _placeholderSL.font = NB_FONTSEIZ_NOR;
    }
    return _placeholderSL;
}



-(UIView *)lineSecondV{
    if (!_lineSecondV) {
        _lineSecondV = [[UIView alloc]initWithFrame:CGRectMake(10, self.contentTV.bottom+5, 200, 30)];
        _lineSecondV.backgroundColor = HEX_COLOR(0xF5F5F5);
        _lineSecondV.layer.masksToBounds = YES;
        _lineSecondV.layer.cornerRadius = 5;
        
        UILabel *LogoName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 160, 30)];
        LogoName.text = @"按住图片拖拽可调整顺序";
        LogoName.textColor = COLOR_BLACK_CLASS_3;
        LogoName.font = NB_FONTSEIZ_NOR;
        LogoName.textAlignment = NSTextAlignmentCenter;
        [_lineSecondV addSubview:LogoName];
        
        UIButton *successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        successBtn.frame = CGRectMake(LogoName.right,0,30,30);
        successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [successBtn setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
        [successBtn addTarget:self action:@selector(deleteTip) forControlEvents:UIControlEventTouchUpInside];
        [_lineSecondV addSubview:successBtn];

    }
    return _lineSecondV;
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

- (NSMutableArray *)imgArr
{
    if (_imgArr == nil) {
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}


-(UIButton *)phraseBtn
{
    if(!_phraseBtn)
    {
        _phraseBtn = [[UIButton alloc] init];
        [_phraseBtn setTitle:@"常用语" forState:normal];
        _phraseBtn.backgroundColor = Main_Color;
        _phraseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_phraseBtn addTarget:self action:@selector(muchUseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phraseBtn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - muchUseView

-(void)muchUseBtnClick{

    if ([self.changyongyutype isEqualToString:@"0"]) {
        [self muchviewshow:self.muchUseArray];
    }
    else
    {
         [self muchviewshow:self.muchUseArray2];
    }
}

-(void)muchviewshow:(NSArray *)dataarr
{
    NSMutableArray *arr = [NSMutableArray new];
    for (int i=0; i<dataarr.count; i++)
    {
        MuchUseModel *model = dataarr[i];
        [arr addObject:model.content];
    }
    self.alert.titleArray = arr;
    [self.alert.tableView reloadData];
    [self.alert show];
}

-(void)clickButton:(NSInteger)index
{
    if ([self.changyongyutype isEqualToString:@"0"]) {
        MuchUseModel *model = self.muchUseArray[index];
        [self updateTextViewTextInsertedString:model.content];
    }
    else
    {
        MuchUseModel *model = self.muchUseArray2[index];
        [self updateTextViewTextInsertedString:model.content];
    }
}

#pragma mark - 请求常用语接口

-(void)requestMuchUseData{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"commonLanguage/getList.do"];
    
    if (IsNilString(_nodeId)) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"节点已经失效" controller:self sleep:1.5];
        return;
    }
    
    NSDictionary *paramDic = @{@"agencysId":@(user.agencyId),@"nodeId":_nodeId,@"companyId":self.companyId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                
                NSArray *caseArr3 = [[responseObj objectForKey:@"data"]objectForKey:@"list"];//个人常用语
                NSArray *arr3 = [NSArray yy_modelArrayWithClass:[MuchUseModel class] json:caseArr3];
                
                NSArray *caseArr = [[responseObj objectForKey:@"data"]objectForKey:@"companyList"];//公司常用语
                NSArray *arr = [NSArray yy_modelArrayWithClass:[MuchUseModel class] json:caseArr];
                
                NSArray *caseArr2 = [[responseObj objectForKey:@"data"]objectForKey:@"systemList"];//系统常用语
                NSArray *arr2 = [NSArray yy_modelArrayWithClass:[MuchUseModel class] json:caseArr2];
                
                [self.muchUseArray removeAllObjects];
                [self.muchUseArray addObjectsFromArray:arr];
                [self.muchUseArray addObjectsFromArray:arr3];
                
                
                [self.muchUseArray2 removeAllObjects];
                [self.muchUseArray2 addObjectsFromArray:arr2];
                
            }
            else if (statusCode==1001){
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
            }
            else if (statusCode==1002){
                //                [[PublicTool defaultTool] publicToolsHUDStr:@"数据为空" controller:self sleep:1.5];
            }
            else if (statusCode==2000){
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark -- 更新插入数据到光标处

- (void)updateTextViewTextInsertedString:(NSString *)text {
    
    if (kIsEmptyString(text)) {
        return;
    }
    
    // 获得光标所在的位置
    NSUInteger location = self.contentTV.selectedRange.location;
    if (location == NSNotFound || location >= self.contentTV.text.length) {
        if (kIsEmptyString(self.contentTV.text)) {
            text = [text substringFromIndex:0];
        }
        
        NSString *currentText = self.contentTV.text;
        if (kIsEmptyString(currentText)) {
            currentText = @"";
        }
        self.contentTV.text = [NSString stringWithFormat:@"%@%@",
                               currentText,
                               text];
        [self textViewDidChange:self.contentTV];
        return;
    }
    
//    // 如果光标之前没有内容，去掉前面的逗号
//    if (kIsEmptyString([self.contentTV.text substringToIndex:location])) {
//        if ([text hasPrefix:@""]) {
//            if (text.length == 1) {
//                text = @"";
//            } else {
//                text = [text substringFromIndex:1];
//            }
//        }
//    }
    
    if (kIsEmptyString(self.contentTV.text)) {
        self.contentTV.text = text;
        [self textViewDidChange:self.contentTV];
        return;
    }
    if (!kIsEmptyString([self.contentTV.text substringFromIndex:location])) {
        text = [NSString stringWithFormat:@"%@", text];
    }
    NSString *preText = [self.contentTV.text substringToIndex:location];
    if (kIsEmptyString(preText)) {
        preText = @"";
    }
    NSString *lastText = [self.contentTV.text substringFromIndex:location];
    if (kIsEmptyString(lastText)) {
        lastText = @"";
    }
    NSString *result = [NSString stringWithFormat:@"%@%@%@",
                        preText,
                        text,
                        lastText];
    
    self.contentTV.text = result;
    [self textViewDidChange:self.contentTV];
    // 调整光标
    self.contentTV.selectedRange = NSMakeRange(location + text.length + 1, 1);
}

#pragma mark -- 切换常用语

-(void)leftclick
{
    self.alert.isshow = YES;
    [self.alert.tableView reloadData];
    self.changyongyutype = @"0";
    [self muchviewshow:self.muchUseArray];

}

-(void)rightclick
{
    self.changyongyutype = @"1";
    [self muchviewshow:self.muchUseArray2];
    
    NSString *impl = [[NSUserDefaults standardUserDefaults] objectForKey:@"impl"];
    NSString *str = [NSString stringWithFormat:@"%@",impl];
    
    //判断是否展示系统常用语
    if ([str isEqualToString:@"1"]||[self.agencysJob isEqualToString:@"1003"]||[self.agencysJob isEqualToString:@"1002"]) {
        self.alert.isshow = YES;
    }
    else
    {
        self.alert.isshow = NO;
    }
    [self.alert.tableView reloadData];

    
}

//公司常用语
-(void)changyongyu0btnclick
{
    self.changyongyutype = @"0";
    [self muchviewshow:self.muchUseArray];
  
}

//系统常用语
-(void)changyongyu1btnclick
{

    self.changyongyutype = @"1";
    [self muchviewshow:self.muchUseArray2];
}

-(void)pushclick
{
     [self.alert dissMIssView];
    
    EditMuchUseController *vc = [[EditMuchUseController alloc]init];
    vc.nodeId = self.nodeId;
    vc.agencysJob = self.agencysJob;
    if ([self.changyongyutype isEqualToString:@"0"]) {
        vc.muchUseArray = self.muchUseArray;
        vc.type = @"2";
        vc.companyId = self.companyId;
        vc.changyongyutype = @"0";
    }
    else
    {
        vc.muchUseArray = self.muchUseArray2;
        vc.type = @"2";
        vc.changyongyutype = @"1";
        vc.companyId = self.companyId;
    }
    vc.keyBoardH = keyBoardH;
    vc.upLoadMuchUseBlock = ^(NSInteger updateType) {
        if (updateType) {
            [self requestMuchUseData];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
   
}

@end
