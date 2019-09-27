//
//  EditMyBeatArtController.m
//  iDecoration
//
//  Created by sty on 2017/11/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "EditMyBeatArtController.h"
#import "DesignCaseListHeadCell.h"
#import "DesignCaseListMidCell.h"
#import "DesignCaseListBottomCell.h"

#import "NewDesignImageController.h"
#import "DesignCaseListModel.h"
#import "TZImagePickerController.h"
#import "VoteSetController.h"
#import "SelectBgmController.h"
#import "NSObject+CompressImage.h"
#import "VoteOptionModel.h"

#import "ChangeDesignTitleController.h"

#import "HKImageClipperViewController.h"

#import "ConstructionDiaryTwoController.h"
#import "NewDesignImageWebController.h"

#import "LocalMusicController.h"
#import "AddDesignFullLook.h"
#import "ChangeDesignTitleTwoController.h"
#import "UnionActivitySettingController.h"
#import "SetwWatermarkController.h"
#import "MyBeautifulArtController.h"

#import "AddVideoLinkViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ASProgressPopUpView.h"
#import "ZCHPublicWebViewController.h"

#import "VrCommenCell.h"
#import "VoteCommenCell.h"
#import "ActivityCommenCell.h"

#import "SSPopup.h"

@interface EditMyBeatArtController ()<UITableViewDelegate,UITableViewDataSource,DesignCaseListMidCellDelegate,DesignCaseListHeadCellDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,SSPopupDelegate,ASProgressPopUpViewDataSource,UIActionSheetDelegate,VrCommenCellDelegate,VoteCommenCellDelegate>

@end

@implementation EditMyBeatArtController

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)orialArray{
    if (!_orialArray) {
        _orialArray = [NSMutableArray array];
    }
    return _orialArray;
}

-(NSMutableArray *)optionList{
    if (!_optionList) {
        _optionList = [NSMutableArray array];
    }
    return _optionList;
}


-(NSMutableDictionary *)MidCellHDict{
    if (!_MidCellHDict) {
        _MidCellHDict = [NSMutableDictionary dictionary];
    }
    return _MidCellHDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isCaogao) {
        self.title = @"编辑";
    }
    else
    {
        self.title = @"编辑美文";
    }
    

    
    self.type = 2;
    NSInteger count = self.dataArray.count;
    hiddenStateDict = [NSMutableDictionary dictionary];
    if (!self.setDataArray) {
        self.setDataArray = [NSMutableArray array];
    }
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }

    if (self.actStartTimeStr.length<=0) {
        //没有活动
        self.isHaveSignUp = NO;
    }else{
        self.isHaveSignUp = YES;
    }
   
    
    bottomCellIsHidden = YES;
    if (self.nameStr&&self.nameStr.length>0) {
        self.isHaveVR = YES;
    }
    else{
        self.isHaveVR = NO;
    }

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomMusicStyleV];
    [self.bottomMusicStyleV addSubview:self.musicLeftL];
    [self.bottomMusicStyleV addSubview:self.musicRightL];
    [self.bottomMusicStyleV addSubview:self.bottomRow];
    
    NSArray *QArray = @[@"进入页面直接播放",@"点击播放"];
    self.musicRightL.text = QArray[self.musicStyle];
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    self.successBtn = editBtn;
    [self.successBtn addTarget:self action:@selector(successBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.successBtn];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    [self addSuspendedButton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveAddTextData:) name:@"ActivityaddTextDesign" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveEditTextData:) name:@"ActivityeditTextDesign" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveAddTextToBottomData:) name:@"ActivityaddTextToBottomDesign" object:nil];
    [self videojudge];
}

-(void)videojudge
{
    NSMutableArray *videoarr = [NSMutableArray array];
    for (int i = 0; i<self.dataArray.count; i++) {
        DesignCaseListModel *model = [[DesignCaseListModel alloc] init];
        model = [self.dataArray objectAtIndex:i];
        if (model.videoUrl.length==0) {
            
        }
        else
        {
            [videoarr addObject:model.videoUrl];
        }
    }
    NSString *textstr = [videoarr componentsJoinedByString:@","];

    if ([textstr containsString:@"bilinerju.com"]) {
        isFirstCamera = NO;
    }
    else
    {
        isFirstCamera = YES;
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return self.dataArray.count;
    }
    else {
        return 1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UITableViewHeaderFooterView alloc]init];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = RGB(241, 242, 245);

        [self.bottombackGroundV removeAllSubViews];
        
        [view addSubview:self.bottombackGroundV];
        
        [self.bottombackGroundV addSubview:self.bottomaddBtn];
        [self.bottombackGroundV addSubview:self.hiddenV];
        [self.hiddenV addSubview:self.addTextBtn];
        [self.hiddenV addSubview:self.addPhotoBtn];
        [self.hiddenV addSubview:self.addVideoBtn];
        if (bottomCellIsHidden) {
            self.bottomaddBtn.hidden = NO;
            self.hiddenV.hidden = YES;
            self.bottombackGroundV.frame = CGRectMake(0,0,kSCREEN_WIDTH,25);
        }
        else{
            self.bottomaddBtn.hidden = YES;
            self.hiddenV.hidden = NO;
            self.bottombackGroundV.frame = CGRectMake(0,0,kSCREEN_WIDTH,40);
        }
        
        return view;
    }
    return [[UITableViewHeaderFooterView alloc]init];
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0){
        return 0;
    }
    else if (section==1) {
        CGFloat temH = 0;
        if (bottomCellIsHidden) {
            temH = 25;
        }
        else{
            temH = 40;
        }
        return temH;
    }
    else{
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 290;
    }
    
    else if (indexPath.section==1){
        NSString *cellHkey = [NSString stringWithFormat:@"%ld",indexPath.row];
        CGFloat cellH = [[self.MidCellHDict objectForKey:cellHkey] floatValue];
        return cellH;
    }
    else if (indexPath.section==2){
        if (self.isHaveVR) {
            return 125;
        }
        else{
            return 50;
        }
    }
    
    else if (indexPath.section==3){
        if (self.isHaveVote) {
            return 125;
        }
        else{
            return 50;
        }
    }
    
    else{
        if (self.isHaveSignUp) {
            return 125;
        }
        else{
            if (!self.isFistr) {
                return 0;
            }
            else{
                return 50;
            }
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        DesignCaseListHeadCell *cell = [DesignCaseListHeadCell cellWithTableView:tableView];
        cell.delegate = self;
        if (!self.isHaveMusicButton) {
            cell.addMusicBtn.hidden = true;
        }
        [cell configWith:self.coverTitle titleTwo:self.coverTitleTwo coverImg:self.coverImgUrl songName:self.musicName];
        return cell;
    }else if(indexPath.section == 1){
        DesignCaseListMidCell *cell = [DesignCaseListMidCell cellWithTableView:tableView path:indexPath];
        cell.delegate = self;
        NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        NSInteger temInt = [[hiddenStateDict objectForKey:key] integerValue];
        id data = self.dataArray[indexPath.row];
        if (temInt==1) {
            [cell configWith:YES data:data isHaveDefaultLogo:!isHaveDefaultLogo];
        }else{
            [cell configWith:NO data:data isHaveDefaultLogo:!isHaveDefaultLogo];
        }
        NSString *cellHkey = [NSString stringWithFormat:@"%ld",indexPath.row];
        [self.MidCellHDict setObject:@(cell.cellH) forKey:cellHkey];
        if (indexPath.row==0) {
            cell.moveUpBtn.hidden = YES;
        }else{
            cell.moveUpBtn.hidden = NO;
        }
        NSInteger count = self.dataArray.count;
        if (indexPath.row==(count-1)) {
            cell.moveDownBtn.hidden = YES;
        }else{
            cell.moveDownBtn.hidden = NO;
        }
        return cell;
    }else if (indexPath.section==2) {
        VrCommenCell *cell = [VrCommenCell cellWithTableView:tableView indexpath:indexPath];
        cell.delegate = self;
        [cell configCrib:self.nameStr imgStr:self.coverImgStr isHaveVR:self.isHaveVR];
        return cell;
    }else if (indexPath.section==3) {
        VoteCommenCell *cell = [VoteCommenCell cellWithTableView:tableView indexpath:indexPath];
        cell.delegate = self;
        [cell configCrib:self.voteDescribe isHaveVote:self.isHaveVote];
        return cell;
    }else{
        ActivityCommenCell *cell = [ActivityCommenCell cellWithTableView:tableView indexpath:indexPath];
        [cell configWith:self.actStartTimeStr actEndTime:self.actEndTimeStr haveSignUp:self.haveSignUpStr signUpNum:self.signUpNumStr isHaveActivity:self.isHaveSignUp];
        if (!self.isHaveSignUp&&!self.isFistr) {
            cell.activitySignUpV.hidden = YES;
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==2) {
        [self addToVR];
    }
    if (indexPath.section==3) {
        [self addToVote];
    }
    if (indexPath.section==4) {
        [self addToActivity];
    }
}

-(void)back{
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否退出编辑" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存到草稿箱",@"确定", nil];
//    alertView.tag = 200;
//
//    [alertView show];
        
    if (self.isCaogao) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否退出编辑" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 200;
        
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否退出编辑" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存到草稿箱",@"确定", nil];
        alertView.tag = 200;
        
        [alertView show];
    }

}

-(void)receiveAddTextData:(NSNotification *)not{
    YSNLog(@"%@",not);
    isHaveDefaultLogo = NO;
    NSDictionary *dict = not.userInfo;
    NSString *htmlStr = [dict objectForKey:@"htmlStr"];
    NSString *textStr = [dict objectForKey:@"textStr"];
    NSString *link = [dict objectForKey:@"link"];
    NSString *linkDescribe = [dict objectForKey:@"linkDescribe"];
    
    
    NSInteger row = [[dict objectForKey:@"row"] integerValue];
    DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
    model.detailsId = 0;
    model.imgUrl = @"";
    model.content = textStr;
    model.htmlContent = htmlStr;
    model.link = link;
    model.linkDescribe = linkDescribe;
    
    
    [self.dataArray insertObject:model atIndex:row];
    
    NSString *key = [NSString stringWithFormat:@"%lu",self.dataArray.count-1];
    [hiddenStateDict setObject:@(1) forKey:key];
    
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
}

-(void)receiveEditTextData:(NSNotification *)not{
    YSNLog(@"%@",not);
    isHaveDefaultLogo = NO;
    NSDictionary *dict = not.userInfo;
    NSString *htmlStr = [dict objectForKey:@"htmlStr"];
    NSString *textStr = [dict objectForKey:@"textStr"];
    NSInteger row = [[dict objectForKey:@"row"] integerValue];
    
    DesignCaseListModel *model = self.dataArray[row];;
    model.content = textStr;
    model.htmlContent = htmlStr;
    
    NSString *link = [dict objectForKey:@"link"];
    NSString *linkDescribe = [dict objectForKey:@"linkDescribe"];
    
    model.link = link;
    model.linkDescribe = linkDescribe;
    
    [self.dataArray replaceObjectAtIndex:row withObject:model];
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
}

-(void)isButtonTouched{
    ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
    VC.titleStr = @"使用说明";
    VC.webUrl = @"http://api.bilinerju.com/api/designs/5919/10094.htm";
    VC.isAddBaseUrl = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)receiveAddTextToBottomData:(NSNotification *)not{
    
    isHaveDefaultLogo = NO;
    
    YSNLog(@"%@",not);
    NSDictionary *dict = not.userInfo;
    NSString *htmlStr = [dict objectForKey:@"htmlStr"];
    NSString *textStr = [dict objectForKey:@"textStr"];
    DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
    model.detailsId = 0;
    model.imgUrl = @"";
    model.content = textStr;
    model.htmlContent = htmlStr;
    
    
    NSString *link = [dict objectForKey:@"link"];
    NSString *linkDescribe = [dict objectForKey:@"linkDescribe"];
    
    model.link = link;
    model.linkDescribe = linkDescribe;
    
    [self.dataArray addObject:model];
    
    
    
    NSString *key = [NSString stringWithFormat:@"%lu",self.dataArray.count-1];
    [hiddenStateDict setObject:@(1) forKey:key];
    
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark - DesignCaseListHeadCellDelegate

-(void)changeCoverTitle{
    ChangeDesignTitleController *vc = [[ChangeDesignTitleController alloc]init];
    __weak typeof (self) wself = self;
    vc.strBlock = ^(NSString *str) {
        self.coverTitle = str;
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [UIView animateWithDuration:0 animations:^{
            [wself.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    };
    vc.content = self.coverTitle;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)changeCoverTitleTwo{
    ChangeDesignTitleTwoController *vc = [[ChangeDesignTitleTwoController alloc]init];
    __weak typeof (self) wself = self;
    vc.strBlock = ^(NSString *str) {
        self.coverTitleTwo = str;
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [UIView animateWithDuration:0 animations:^{
            [wself.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    };
    vc.content = self.coverTitleTwo;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)changeCoverImg{
    UIImagePickerController * photoAlbum = [[UIImagePickerController alloc]init];
    photoAlbum.delegate = self;
    photoAlbum.allowsEditing = NO;
    photoAlbum.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:photoAlbum animated:YES completion:^{}];
}

-(void)addMusic{

    LocalMusicController *vc = [[LocalMusicController alloc]init];
    vc.musicUrl = self.musicUrl;
    vc.songName = self.musicName;
    __weak typeof (self) wself = self;
    vc.localMusicBlock = ^(NSString *musicUrl, NSString *songName) {
        wself.musicUrl = musicUrl;
        wself.musicName = songName;
        
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [UIView animateWithDuration:0 animations:^{
            [wself.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie]){
        NSURL *sourceUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        NSData *fileData = [NSData dataWithContentsOfFile:videoPath];
        CGFloat fileF = fileData.length/1024.f/1024.f;
        //压缩前的大小
        YSNLog(@"%f",fileF);
        
        
        
        [self.view addSubview:self.backShadowV];
        [self.view addSubview:self.progress];
        self.backShadowV.alpha = 0.5f;
        self.progress.progress = 0.0;
        //压缩地址保存到沙盒
        NSString *outPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld_compressedVideo.mp4",time(NULL)]];
        YSNLog(@"compressedVideoSavePath : %@",outPath);
        
        _videoPath = outPath;
        
        //转码配置
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
        AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputURL = [NSURL fileURLWithPath:outPath];
        //转换后的格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            // 如果导出的状态为完成
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                YSNLog(@"sucess");
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    
                    NSData *outData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:outPath]];
                    
                    CGFloat outDataF = outData.length/1024.f/1024.f;
                    YSNLog(@"float%f",outDataF);
                    UIImage *temImage = [self getImage:_videoPath];
                    
                    [self.progress removeFromSuperview];
                    self.backShadowV.alpha = 0.0f;
                    [self.backShadowV removeAllSubViews];
                    
                    [self upLoadVideoWith:outData img:temImage];
                    
                });
                
                
                
            }
            else if([exportSession status] == AVAssetExportSessionStatusFailed){
                YSNLog(@"%@",exportSession.error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progress removeFromSuperview];
                    self.backShadowV.alpha = 0.0f;
                    [self.backShadowV removeAllSubViews];
                });
            }
            else{
                YSNLog(@"当前压缩进度:%f",exportSession.progress);
                
                NSString *temStr = [NSString stringWithFormat:@"%.2f",exportSession.progress];
                CGFloat progress = [temStr floatValue];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progress setProgress:progress animated:YES];
                });
            }
            
            
        }];

        [picker dismissViewControllerAnimated:YES completion:^{}];
    }
    else{
        //自定义裁剪方式
        UIImage*image = [self turnImageWithInfo:info];
        CGSize tempSize = CGSizeMake(kSCREEN_WIDTH, 150);
        HKImageClipperViewController *clipperVC = [[HKImageClipperViewController alloc]initWithBaseImg:image
                                                                                         resultImgSize:tempSize clipperType:ClipperTypeImgMove];
        
        __weak typeof(self)weakSelf = self;
        clipperVC.cancelClippedHandler = ^(){
            [picker dismissViewControllerAnimated:YES completion:nil];
        };
        clipperVC.successClippedHandler = ^(UIImage *clippedImage){
            __strong typeof(self)strongSelf = weakSelf;
            
            NSArray *arr = @[clippedImage];
            [strongSelf uploadImgWith:arr type:1];
            
            
            [picker dismissViewControllerAnimated:YES completion:nil];
        };
        
        [picker pushViewController:clipperVC animated:YES];
    }
    
    
    
}

//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (UIImage *)turnImageWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //类型为 UIImagePickerControllerOriginalImage 时调整图片角度
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp) {
            // 原始图片可以根据照相时的角度来显示，但 UIImage无法判定，于是出现获取的图片会向左转90度的现象。
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    return image;
    
}

#pragma mark - 图片上传
- (void)uploadImgWith:(NSArray *)imgArray type:(NSInteger)type{
    //1:修改封面图片 2:修改cell上的图片  3:插入图片  4:添加图片到最后
    
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
        
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *arr = [responseObject objectForKey:@"imgList"];
        
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            [dataArray addObject:[dict objectForKey:@"imgUrl"]];
        }
        
        if (type==1) {
            self.coverImgUrl = dataArray.firstObject;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [UIView animateWithDuration:0 animations:^{
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
        
        if (type==2) {
            DesignCaseListModel *model = self.dataArray[modifyPath.row];
            model.imgUrl = dataArray.firstObject;
            [self.dataArray replaceObjectAtIndex:modifyPath.row withObject:model];
            
            
            
            bottomCellIsHidden = YES;
            [hiddenStateDict removeAllObjects];
            NSInteger count = self.dataArray.count;
            for (int i = 0; i<count; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                [hiddenStateDict setObject:@(1) forKey:key];
            }
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [UIView animateWithDuration:0 animations:^{
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
        
        if (type==3) {
            for (int i = 0; i<dataArray.count; i++) {
                DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
                model.detailsId = 0;
                model.imgUrl = dataArray[i];
                model.content = @"";
                model.htmlContent = @"";
                [self.dataArray insertObject:model atIndex:addPath.row];
            }
            
            
            
            bottomCellIsHidden = YES;
            [hiddenStateDict removeAllObjects];
            NSInteger count = self.dataArray.count;
            for (int i = 0; i<count; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                [hiddenStateDict setObject:@(1) forKey:key];
            }
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [UIView animateWithDuration:0 animations:^{
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
        
        if (type==4) {
            for (int i = 0; i<dataArray.count; i++) {
                DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
                model.detailsId = 0;
                model.imgUrl = dataArray[i];
                model.content = @"";
                model.htmlContent = @"";
                [self.dataArray addObject:model];
            }
            
            
            
            bottomCellIsHidden = YES;
            [hiddenStateDict removeAllObjects];
            NSInteger count = self.dataArray.count;
            for (int i = 0; i<count; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                [hiddenStateDict setObject:@(1) forKey:key];
            }
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [UIView animateWithDuration:0 animations:^{
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YSNLog(@"xxx上传失败xxx %@", error);
        
        
        
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        
    }];
}

#pragma mark - DesignCaseListMidCellDelegete

-(void)changeHiddenState:(NSIndexPath *)path{
    NSString *key = [NSString stringWithFormat:@"%ld",(long)path.row];
    
    
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *temkey = [NSString stringWithFormat:@"%d",i];
        if ([temkey isEqualToString:key]) {
            NSInteger temInt = [[hiddenStateDict objectForKey:key] integerValue];
            if (temInt==1) {
                [hiddenStateDict setObject:@(0) forKey:key];
                bottomCellIsHidden = YES;
            }
            else{
                [hiddenStateDict setObject:@(1) forKey:key];
            }
        }
        else{
            [hiddenStateDict setObject:@(1) forKey:temkey];
        }
        
    }
    
    
    
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
    //    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

-(void)changeToHidden{
    
    NSInteger count = self.dataArray.count;
    bool isZk = false;//是否张开
    
    for (int i = 0; i<count; i++){
        NSString *key = [NSString stringWithFormat:@"%d",i];
        NSInteger temInt = [[hiddenStateDict objectForKey:key] integerValue];
        if (temInt==0) {
            //有张开
            isZk = YES;
            break;
        }
        else{
            //
            isZk = NO;
        }
    }
    
    if (isZk||!bottomCellIsHidden) {
        [hiddenStateDict removeAllObjects];
        
        for (int i = 0; i<count; i++) {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            [hiddenStateDict setObject:@(1) forKey:key];
        }
        bottomCellIsHidden = YES;
        //一个section刷新
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    
    
    
    //    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

-(void)addTextCell:(NSIndexPath *)path{
    
    isHaveDefaultLogo = NO;
    bottomCellIsHidden = YES;
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    NewDesignImageController *vc = [[NewDesignImageController alloc]init];
    vc.fromTag = 3;
    vc.editOrAdd = 2;
    vc.row = path.row;
    vc.nodeImgStr = @"";
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addPhotoCell:(NSIndexPath *)path{
    
    isHaveDefaultLogo = YES;
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        addPath = path;

        SetwWatermarkController *vc = [[SetwWatermarkController alloc]init];
        vc.fromTag = 7;
        vc.editTag = 3;
        vc.imgArray = photos;
        vc.companyName = self.companyName;
        vc.comanyLogoStr = self.companyLogo;
        
        vc.setWaterBlock = ^(NSMutableArray *dataArray, NSInteger a) {
            [self replaceDataWith:dataArray type:a];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

-(void)addVideoCell:(NSIndexPath *)path{
    isHaveDefaultLogo = NO;
    bottomCellIsHidden = YES;
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
    addVidelTag = path.row;
    [self upLoadVideo];
}


-(void)changePhotoCell:(NSIndexPath *)path{
    isHaveDefaultLogo = YES;
    DesignCaseListModel *model = self.dataArray[path.row];
    
    if ((model.videoUrl&&model.videoUrl.length>0)||(model.currencyUrl&&model.currencyUrl.length>0)){
        //视频
        
        AddVideoLinkViewController *vc = [[AddVideoLinkViewController alloc]init];
        
        vc.coverImgStr = model.imgUrl;
        vc.linkUrl = model.videoUrl;
        vc.unionURL = model.currencyUrl;
        
        vc.AddLinkCompletionBlock = ^(NSString *coverImgStr, UIImage *coverImg, NSString *linkUrl, NSString *unionURL) {
            //            DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
            //            model.detailsId = 0;
            model.imgUrl = coverImgStr;
            model.videoUrl = linkUrl;
            model.currencyUrl = unionURL;
            //            model.content = @"";
            //            model.htmlContent = @"";
            
            [self.dataArray replaceObjectAtIndex:path.row withObject:model];
            bottomCellIsHidden = YES;
            [hiddenStateDict removeAllObjects];
            NSInteger count = self.dataArray.count;
            for (int i = 0; i<count; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                [hiddenStateDict setObject:@(1) forKey:key];
            }
            
            
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [UIView animateWithDuration:0 animations:^{
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
        
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            modifyPath = path;
            //        [self uploadImgWith:photos type:2];
            
            SetwWatermarkController *vc = [[SetwWatermarkController alloc]init];
            vc.fromTag = 7;
            vc.editTag = 2;
            vc.imgArray = photos;
            vc.companyName = self.companyName;
            vc.comanyLogoStr = self.companyLogo;
            
            vc.setWaterBlock = ^(NSMutableArray *dataArray, NSInteger a) {
                [self replaceDataWith:dataArray type:a];
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
    
    
}

-(void)removePhotoCell:(NSIndexPath *)path{
    
    if (self.dataArray.count<=1) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"至少要保留一张图片" controller:self sleep:1.5];
        return;
    }
    [self.dataArray removeObjectAtIndex:path.row];
    
    bottomCellIsHidden = YES;
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
}

-(void)editTextCell:(NSIndexPath *)path{
    isHaveDefaultLogo = NO;
    bottomCellIsHidden = YES;
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    NewDesignImageController *vc = [[NewDesignImageController alloc]init];
    vc.fromTag = 3;
    vc.editOrAdd = 1;
    DesignCaseListModel *model = self.dataArray[path.row];
    vc.model = model;
    vc.row = path.row;
    vc.linkAddress = model.link;
    vc.linkDescrib = model.linkDescribe;
    vc.nodeImgStr = model.imgUrl;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)bottomaddBtnClick:(UIButton *)btn{
    bottomCellIsHidden = !bottomCellIsHidden;
    
    
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
}

-(void)backGroundVGes:(UITapGestureRecognizer *)ges{
    
    
    bottomCellIsHidden = YES;
    
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
}

-(void)addtextToBottom{
    isHaveDefaultLogo = NO;
    bottomCellIsHidden = YES;
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    NewDesignImageController *vc = [[NewDesignImageController alloc]init];
    vc.fromTag = 3;
    vc.editOrAdd = 0;
    vc.nodeImgStr = @"";
    vc.type = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addPhotosToBottom{
    isHaveDefaultLogo = YES;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        //        [self uploadImgWith:photos type:4];
        
        SetwWatermarkController *vc = [[SetwWatermarkController alloc]init];
        vc.fromTag = 7;
        vc.editTag = 4;
        vc.imgArray = photos;
        vc.companyName = self.companyName;
        vc.comanyLogoStr = self.companyLogo;
        
        vc.setWaterBlock = ^(NSMutableArray *dataArray, NSInteger a) {
            [self replaceDataWith:dataArray type:a];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
    
}

-(void)addVideoToBottom{
    isHaveDefaultLogo = NO;
    bottomCellIsHidden = YES;
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
    addVidelTag = -1;
    [self upLoadVideo];
    
    
}

#pragma mark - 添加全景
-(void)addToVR{
    bottomCellIsHidden = YES;
    
    
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    AddDesignFullLook *vc = [[AddDesignFullLook alloc]init];
    vc.coverImgStr = self.coverImgStr;
    vc.nameStr = self.nameStr;
    vc.linkUrl = self.linkUrl;
    vc.FullBlock = ^(NSString *coverImgStr, NSString *nameStr, NSString *linkUrl) {
        self.coverImgStr = coverImgStr;
        self.nameStr = nameStr;
        self.linkUrl = linkUrl;
        
        self.isHaveVR = YES;
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma 添加活动

-(void)addToActivity{
    bottomCellIsHidden = YES;
    
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    UnionActivitySettingController *vc = [[UnionActivitySettingController alloc]init];
    vc.activyty = self.actId;
    vc.actStartTimeStr = self.actStartTimeStr;
    vc.actEndTimeStr = self.actEndTimeStr;
    vc.signUpNumStr = self.signUpNumStr;
    vc.activityPlace = self.activityPlace;
    vc.activityAddress = self.activityAddress;
    vc.activityEnd = self.activityEnd;
    vc.setDataArray = self.setDataArray;
    vc.isFistr = self.isFistr;
    vc.activityType = ActivityTypePersonal;
    
    if (!self.latitude||self.latitude.length<=0) {
        vc.lantitude = 0;
    }
    else{
        vc.lantitude = [self.latitude doubleValue];
    }
    
    if (!self.longitude||self.longitude.length<=0) {
        vc.longitude = 0;
    }
    else{
        vc.longitude = [self.longitude doubleValue];
    }
    
    
    
    
    vc.dictBlock = ^(NSMutableDictionary *dict) {
        self.actStartTimeStr = [dict objectForKey:@"startTime"];
        self.actEndTimeStr = [dict objectForKey:@"endTime"];
        NSString *numStr = [dict objectForKey:@"activityPerson"];
        if ([numStr isEqualToString:@"0"]) {
            self.signUpNumStr = @"无限制";
        }
        else{
            self.signUpNumStr = numStr;
        }
        
        self.activityPlace = [dict objectForKey:@"activityPlace"];
        self.activityAddress = [dict objectForKey:@"activityAddress"];
        self.activityEnd = [dict objectForKey:@"activityEnd"];
        self.setDataArray = [dict objectForKey:@"dataArray"];
        _customStr = [dict objectForKey:@"custom"];
        self.longitude = [dict objectForKey:@"longitude"];
        self.latitude = [dict objectForKey:@"latitude"];
        
        self.isHaveSignUp = YES;
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:4];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 添加投票
-(void)addToVote{
    bottomCellIsHidden = YES;
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    VoteSetController *vc = [[VoteSetController alloc]init];
    vc.voteTheme = self.voteDescribe;
    vc.dateArray = self.optionList;
    vc.voteType = self.voteType;
    vc.timeStr = self.endTime;
    vc.isFistr = self.isFistr;
    
    __weak typeof (self) wself = self;
    vc.voteBlock = ^(NSString *voteTheme, NSMutableArray *optionArray, NSString *endTime, NSInteger voteType) {
        wself.voteDescribe = voteTheme;
        wself.optionList = optionArray;
        if (!endTime||endTime.length<=0) {
            endTime = @"";
        }
        wself.endTime = endTime;
        wself.voteType = [NSString stringWithFormat:@"%ld",voteType];
        
        
        self.isHaveVote = YES;
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)moveCellToUp:(NSIndexPath *)path{
    bottomCellIsHidden = YES;
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    DesignCaseListMidCell *cell = [self.tableView cellForRowAtIndexPath:path];
    
    CGRect rect = [cell convertRect:cell.bounds toView:self.tableView];
    DesignCaseListMidCell *cellTwo = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:path.row - 1 inSection:1]];
    
    CGRect rectTwo = [cellTwo convertRect:cellTwo.bounds toView:self.tableView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        cell.frame = rectTwo;
        cellTwo.frame = rect;
    } completion:^(BOOL finished) {
        [self.dataArray exchangeObjectAtIndex:path.row withObjectAtIndex:path.row-1];
        [self.tableView reloadData];
    }];

}

-(void)moveCellToDown:(NSIndexPath *)path{
    bottomCellIsHidden = YES;
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    DesignCaseListMidCell *cell = [self.tableView cellForRowAtIndexPath:path];
    
    CGRect rect = [cell convertRect:cell.bounds toView:self.tableView];
    DesignCaseListMidCell *cellTwo = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:path.row + 1 inSection:1]];
    
    CGRect rectTwo = [cellTwo convertRect:cellTwo.bounds toView:self.tableView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        cell.frame = rectTwo;
        cellTwo.frame = rect;
    } completion:^(BOOL finished) {
        [self.dataArray exchangeObjectAtIndex:path.row withObjectAtIndex:path.row+1];
                [self.tableView reloadData];
    }];

}


#pragma mark - 上传视频

-(void)upLoadVideo{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选取视频" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地视频", @"拍摄视频",@"网络视频", nil];
    
    [actionSheet showInView:self.view];
}

-(void)uploadVideoforweb
{
        AddVideoLinkViewController *vc = [[AddVideoLinkViewController alloc]init];
    
        vc.AddLinkCompletionBlock = ^(NSString *coverImgStr, UIImage *coverImg, NSString *linkUrl, NSString *unionURL) {
            DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
            model.detailsId = 0;
            model.imgUrl = coverImgStr;
            model.videoUrl = linkUrl;
            model.currencyUrl = unionURL;
            model.content = @"";
            model.htmlContent = @"";
            if (addVidelTag==-1) {
                [self.dataArray addObject:model];
            }
            else{
                [self.dataArray insertObject:model atIndex:addVidelTag];
            }
            bottomCellIsHidden = YES;
            [hiddenStateDict removeAllObjects];
            NSInteger count = self.dataArray.count;
            for (int i = 0; i<count; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                [hiddenStateDict setObject:@(1) forKey:key];
            }
    
    
    
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [UIView animateWithDuration:0 animations:^{
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        };
        [self.navigationController pushViewController:vc animated:YES];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        upTag = 1;
        if (isFirstCamera) {
            [self selectVideo];
        }
        else
        {
             [[PublicTool defaultTool] publicToolsHUDStr:@"已经上传过视频了，详情页最多传一个视频！" controller:self sleep:1.5];
        }


    } else if (buttonIndex == 1) {
        upTag = 2;
        if (isFirstCamera) {
             [self takeVideo];
        }
        else
        {
           
            [[PublicTool defaultTool] publicToolsHUDStr:@"已经上传过视频了，详情页最多传一个视频！" controller:self sleep:1.5];
        }

        
    }
    else if (buttonIndex == 2) {
        [self uploadVideoforweb];
    }
    else {
       
    }
}

-(void)selectVideo{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.videoMaximumDuration = 30;
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    NSString *requiredMediaType1 = (NSString *)kUTTypeMovie;
    //    NSString *requiredMediaType1 = @"public.movie";
    imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects:requiredMediaType1, nil];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)takeVideo{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.videoMaximumDuration = 30;
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    imagePicker.showsCameraControls = YES;
    //    imagePicker.cameraOverlayView
    NSString *requiredMediaType1 = (NSString *)kUTTypeMovie;
    //    //    NSString *requiredMediaType1 = @"public.movie";
    imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects:requiredMediaType1, nil];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - ASProgressPopUpView dataSource

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

#pragma mark - 添加完水印之后，替换数组

-(void)replaceDataWith:(NSMutableArray *)dataArray type:(NSInteger)type{
    if (type==2) {
        DesignCaseListModel *model = self.dataArray[modifyPath.row];
        model.imgUrl = dataArray.firstObject;
        [self.dataArray replaceObjectAtIndex:modifyPath.row withObject:model];
        
        
        
        bottomCellIsHidden = YES;
        [hiddenStateDict removeAllObjects];
        NSInteger count = self.dataArray.count;
        for (int i = 0; i<count; i++) {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            [hiddenStateDict setObject:@(1) forKey:key];
        }
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    
    if (type==3) {
        for (int i = 0; i<dataArray.count; i++) {
            DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
            model.detailsId = 0;
            model.imgUrl = dataArray[i];
            model.content = @"";
            model.htmlContent = @"";
            [self.dataArray insertObject:model atIndex:addPath.row];
        }
        
        
        
        bottomCellIsHidden = YES;
        [hiddenStateDict removeAllObjects];
        NSInteger count = self.dataArray.count;
        for (int i = 0; i<count; i++) {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            [hiddenStateDict setObject:@(1) forKey:key];
        }
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    
    if (type==4) {
        for (int i = 0; i<dataArray.count; i++) {
            DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
            model.detailsId = 0;
            model.imgUrl = dataArray[i];
            model.content = @"";
            model.htmlContent = @"";
            [self.dataArray addObject:model];
        }
        
        
        
        bottomCellIsHidden = YES;
        [hiddenStateDict removeAllObjects];
        NSInteger count = self.dataArray.count;
        for (int i = 0; i<count; i++) {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            [hiddenStateDict setObject:@(1) forKey:key];
        }
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

#pragma mark - 删除投票

-(void)deleteVote{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确认删除投票？"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    [alertView show];
}

#pragma mark - 删除全景
-(void)deleteVr{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确认删除全景？"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = 300;
    [alertView show];
}

#pragma mark -删除投票和全景
/*-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            self.isHaveVote = NO;
            self.voteDescribe = @"";
            [self.optionList removeAllObjects];
            self.endTime = @"";
            self.voteType = @"1";
            
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
            [UIView animateWithDuration:0 animations:^{
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
    }
        if (alertView.tag==200) {
            if (buttonIndex==1) {
                NSString *url = [BASEURL stringByAppendingString:POST_CAOGAOSAVE];
                NSString *draftContent = [self jsonfrom];
                NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
                
                NSString *draftId = @"";
                //NSString *designsId = [NSString stringWithFormat:@"%ld",self.designId];
                NSString *designsId = @"";
                NSDictionary *para = @{@"draftContent":draftContent,@"agencysId":agencysId,@"draftId":draftId,@"designsId":designsId};
                [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
                    if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"成功" controller:self.navigationController sleep:1.5];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } failed:^(NSString *errorMsg) {
                    
                }];
            }
            else if (buttonIndex==2) {
                BOOL isFromSetWater = NO;
                for (UIViewController *vc in self.navigationController.childViewControllers) {
                    if ([vc isKindOfClass:[SetwWatermarkController class]]) {
                        isFromSetWater = YES;
                        break;
                    }
                    else{
                        isFromSetWater = NO;
                    }
                }
                
                if (isFromSetWater){
                    for (UIViewController *vc in self.navigationController.childViewControllers) {
                        if ([vc isKindOfClass:[MyBeautifulArtController class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }
                }
                else{
                    [self SuspendedButtonDisapper];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
    
        }
    
    if (alertView.tag==300) {
        if (buttonIndex==1) {
            self.isHaveVR = NO;
            //            self.voteDescribe = @"";
            //            [self.optionList removeAllObjects];
            //            self.endTime = @"";
            //            self.voteType = @"1";
            self.coverImgStr = @"";
            self.nameStr = @"";
            self.linkUrl = @"";
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [UIView animateWithDuration:0 animations:^{
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
    }
}*/

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            self.isHaveVote = NO;
            self.voteDescribe = @"";
            [self.optionList removeAllObjects];
            self.endTime = @"";
            self.voteType = @"1";
            
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
            [UIView animateWithDuration:0 animations:^{
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
    }
    if (alertView.tag==200) {
        
        //保存草稿箱
        if (buttonIndex==1) {
            if (self.isCaogao) {
                
                BOOL isFromSetWater = NO;
                for (UIViewController *vc in self.navigationController.childViewControllers) {
                    if ([vc isKindOfClass:[SetwWatermarkController class]]) {
                        isFromSetWater = YES;
                        break;
                    }
                    else{
                        isFromSetWater = NO;
                    }
                }
                
                if (isFromSetWater){
                    for (UIViewController *vc in self.navigationController.childViewControllers) {
                        if ([vc isKindOfClass:[SetwWatermarkController class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }
                }
                else{
                    [self SuspendedButtonDisapper];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else{
                NSString *url = [BASEURL stringByAppendingString:POST_CAOGAOSAVE];
                NSString *draftContent = [self jsonfrom];
                NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
                NSString *draftId = @"";
                NSString *designsId = @"";
                NSDictionary *para = @{@"draftContent":draftContent,@"agencysId":agencysId,@"draftId":draftId,@"designsId":designsId};
                [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
                    if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"成功" controller:self.navigationController sleep:1.5];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } failed:^(NSString *errorMsg) {
                    
                }];
            }
            
        }
        else if (buttonIndex==2) {
            BOOL isFromSetWater = NO;
            for (UIViewController *vc in self.navigationController.childViewControllers) {
                if ([vc isKindOfClass:[SetwWatermarkController class]]) {
                    isFromSetWater = YES;
                    break;
                }
                else{
                    isFromSetWater = NO;
                }
            }
            
            if (isFromSetWater){
                for (UIViewController *vc in self.navigationController.childViewControllers) {
                    if ([vc isKindOfClass:[SetwWatermarkController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }
            else{
                [self SuspendedButtonDisapper];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    }
    
    if (alertView.tag==300) {
        if (buttonIndex==1) {
            self.isHaveVR = NO;

            self.coverImgStr = @"";
            self.nameStr = @"";
            self.linkUrl = @"";
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [UIView animateWithDuration:0 animations:^{
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
    }
    

}


#pragma mark - 上传视频的接口 （新接口,上传一个视频和视频的第一帧图片）

-(void)upLoadVideoWith:(NSData*)data img:(UIImage *)img{
    //此段代码如果需要修改，可以调整的位置
    //1. 把upload.php改成网站开发人员告知的地址
    //2. 把name改成网站开发人员告知的字段名
    
    // 查询条件
    //    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", idNum, @"idNumber", nil];
    
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    //    NSString *defaultApi = [BASEURL stringByAppendingString:@"file/videoImg.do"];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"file/uploadViode.do"];
    
    
    [self.view addSubview:self.backShadowV];
    [self.view addSubview:self.progress];
    self.backShadowV.alpha = 0.5f;
    self.progress.progress = 0.0;
    
    // 在parameters里存放照片以外的对象
    __weak typeof(self) weakSelf = self;
    [manager POST:defaultApi parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.video.mov", dateString];
        /*
         *该方法的参数
         1. appendPartWithFileData：要上传的照片[二进制流]
         2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
         3. fileName：要保存在服务器上的文件名
         4. mimeType：上传的文件的类型
         */
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"video/quicktime"];
        
        
        UIImage *uploadImage = img;
        if (uploadImage == nil) {
            uploadImage = [weakSelf getImage:_videoPath];
        }
        //        else {
        //            uploadImage = image;
        //        }
        NSData *imageData = [NSObject imageData:uploadImage];
        NSString *imageDateString = [formatter stringFromDate:[NSDate date]];
        NSString *imageFileName = [NSString  stringWithFormat:@"%@.jpg", imageDateString];
        [formData appendPartWithFileData:imageData name:@"file" fileName:imageFileName mimeType:@"image/jpeg"]; //
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSString *temStr = [NSString stringWithFormat:@"%.2f",uploadProgress.fractionCompleted];
        CGFloat progress = [temStr floatValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progress setProgress:progress animated:YES];
        });
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.progress removeFromSuperview];
        self.backShadowV.alpha = 0.0f;
        [self.backShadowV removeAllSubViews];
        
        [[NSFileManager defaultManager] removeItemAtPath:_videoPath error:nil];//取消之后就删除，以免占用手机硬盘空间（沙盒）
        
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        if (code==1000) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"视频上传成功" controller:self sleep:1.5];

            
            NSString *imgUrl = [responseObject objectForKey:@"imgUrl"];
            NSString *viodeUrl = [responseObject objectForKey:@"videoUrl"];

            DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
            model.detailsId = 0;
            model.imgUrl = imgUrl;
            model.videoUrl = viodeUrl;
            model.content = @"";
            model.htmlContent = @"";
            if (addVidelTag==-1) {
                [self.dataArray addObject:model];
            }
            else{
                [self.dataArray insertObject:model atIndex:addVidelTag];
            }
            bottomCellIsHidden = YES;
            [hiddenStateDict removeAllObjects];
            NSInteger count = self.dataArray.count;
            for (int i = 0; i<count; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                [hiddenStateDict setObject:@(1) forKey:key];
            }
            
            [self.tableView reloadData];
            
        }

        else{
            [[PublicTool defaultTool] publicToolsHUDStr:@"视频上传失败" controller:self sleep:1.5];
            
        }
        
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YSNLog(@"xxx上传失败xxx %@", error);
        [self.progress removeFromSuperview];
        self.backShadowV.alpha = 0.0f;
        [self.backShadowV removeAllSubViews];
        
        
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        [[NSFileManager defaultManager] removeItemAtPath:_videoPath error:nil];//取消之后就删除，以免占用手机硬盘空间（沙盒）
    }];
}

#pragma mark - 更换音乐播放模式
-(void)changeMusicStyle{
    
    NSArray *QArray = @[@"进入页面直接播放",@"点击播放"];
    
    SSPopup* selection=[[SSPopup alloc]init];
    selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
    
    selection.frame = CGRectMake(0,64,kSCREEN_WIDTH,kSCREEN_HEIGHT-64);
    selection.SSPopupDelegate=self;
    [self.view addSubview:selection];
    //    self.editBtn.userInteractionEnabled = NO;
    
    [selection CreateTableview:QArray withTitle:@"" setCompletionBlock:^(int tag) {
        self.musicStyle = tag;
        
        self.musicRightL.text = QArray[self.musicStyle];
    }];
}

-(void)successBtnClick:(UIButton *)btn{
    
//    self.coverTitle = [self.coverTitle ew_removeSpaces];
//    if (self.coverTitle.length<=0) {
//        [[PublicTool defaultTool] publicToolsHUDStr:@"请填写标题" controller:self sleep:1.5];
//        return;
//    }
//
//
//    [self pushData];
    if (_isCaogao) {
        NSString *url = [BASEURL stringByAppendingString:POST_CAOGAOSAVE];
        NSString *draftContent = [self jsonfrom];
        NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
        NSString *draftId = @"";
        if (IsNilString(self.draftId)) {
            draftId = @"";
        }
        else
        {
            draftId = self.draftId;
        }
        
        NSString *designsId = [NSString stringWithFormat:@"%ld",self.designId];
        NSDictionary *para = @{@"draftContent":draftContent,@"agencysId":agencysId,@"draftId":draftId,@"designsId":designsId};
        [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
            if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"成功" controller:self.navigationController sleep:1.5];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }
    else
    {
        self.coverTitle = [self.coverTitle ew_removeSpaces];
        if (self.coverTitle.length<=0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"请填写标题" controller:self sleep:1.5];
            return;
        }
        if (self.coverImgUrl.length==0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"请添加封面" controller:self sleep:1.5];
            return;
        }
        
        [self pushData];
    }
}

#pragma mark - 新增或者修改美文

-(NSString *)jsonfrom {
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *designDict = [NSMutableDictionary dictionary];
    
    
    NSMutableArray *detailsArray = [NSMutableArray array];
    
    NSMutableDictionary *voteDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *activityDict = [NSMutableDictionary dictionary];
    
    NSMutableArray *noDataArray = [NSMutableArray array];
    for (DesignCaseListModel *model in self.dataArray) {
        model.content = [model.content ew_removeSpacesAndLineBreaks];
        if  ((model.imgUrl.length<=0&&model.videoUrl.length<=0)&&model.content.length<=0) {
            [noDataArray addObject:model];
        }
    }
    if (noDataArray.count>0) {
        [self.dataArray removeObjectsInArray:noDataArray];
    }
    if (self.dataArray.count<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"至少要有一项有内容" controller:self sleep:2.0];
        return [NSString new];
    }
    
    
    self.coverTitleTwo = [self.coverTitleTwo ew_removeSpaces];
    if (!self.coverTitleTwo||self.coverTitleTwo.length<=0) {
        //        DesignCaseListModel *firstModel = self.dataArray.firstObject;
        self.coverTitleTwo = @"";
    }
    
    if (self.isFistr) {
        
        [designDict setObject:@(0) forKey:@"designId"];
        [designDict setObject:self.coverTitle forKey:@"designTitle"];
        [designDict setObject:self.coverTitleTwo forKey:@"designSubtitle"];
        [designDict setObject:@(self.musicStyle) forKey:@"musicPlay"];
        [designDict setObject:@(user.agencyId) forKey:@"agencysId"];
        [designDict setObject:@(0) forKey:@"constructionId"];
        [designDict setObject:self.coverImgUrl?:@"" forKey:@"coverMap"];
        
        
        [designDict setObject:self.musicName?self.musicName:@"" forKey:@"musicName"];
        [designDict setObject:self.musicUrl?self.musicUrl:@"" forKey:@"musicUrl"];
        
        [designDict setObject:self.coverImgStr?self.coverImgStr:@"" forKey:@"picUrl"];
        [designDict setObject:self.linkUrl?self.linkUrl:@"" forKey:@"picHref"];
        [designDict setObject:self.nameStr?self.nameStr:@"" forKey:@"picTitle"];
        
        
        
        // 第一次添加，不需要对比数据
        NSInteger arrayCount = self.dataArray.count;
        for (int i = 0; i<arrayCount; i++) {
            DesignCaseListModel *model = self.dataArray[i];
            NSMutableDictionary *temDetailDict = [NSMutableDictionary dictionary];
            [temDetailDict setObject:@(model.detailsId) forKey:@"detailsId"];
            [temDetailDict setObject:model.content forKey:@"content"];
            [temDetailDict setObject:model.htmlContent forKey:@"htmlContent"];
            [temDetailDict setObject:model.imgUrl forKey:@"imgUrl"];
            [temDetailDict setObject:model.videoUrl?model.videoUrl:@"" forKey:@"videoUrl"];
            [temDetailDict setObject:model.currencyUrl?model.currencyUrl:@"" forKey:@"currencyUrl"];
            [temDetailDict setObject:model.link?model.link:@"" forKey:@"link"];
            [temDetailDict setObject:model.linkDescribe?model.linkDescribe:@"" forKey:@"linkDescribe"];
            [temDetailDict setObject:@(i) forKey:@"sort"];
            
            [detailsArray addObject:temDetailDict];
        }
        
        
        
        
        if (!self.voteDescribe||self.voteDescribe.length<=0) {
            //没有投票
            
            [voteDict setObject:@"" forKey:@"voteDescribe"];
            [voteDict setObject:@"" forKey:@"voteEndTime"];
            [voteDict setObject:@(1) forKey:@"voteType"];
            
            
            NSMutableArray *optionArray = [NSMutableArray array];
            
            NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:optionArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
            constructionStr2 = [constructionStr2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [voteDict setObject:constructionStr2 forKey:@"option"];
        }
        
        else{
            [voteDict setObject:self.voteDescribe forKey:@"voteDescribe"];
            [voteDict setObject:self.endTime forKey:@"voteEndTime"];
            [voteDict setObject:self.voteType forKey:@"voteType"];
            
            
            NSMutableArray *optionArray = [NSMutableArray array];
            for (VoteOptionModel *model in self.optionList) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(model.voteId) forKey:@"voteId"];
                [dict setObject:model.voteOption forKey:@"voteOption"];
                [optionArray addObject:dict];
            }
            
            NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:optionArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
            constructionStr2 = [constructionStr2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [voteDict setObject:constructionStr2 forKey:@"option"];
        }
        if (self.isHaveSignUp) {
            [activityDict setObject:@"0" forKey:@"activityId"];
            NSString *startEndStr = [NSString stringWithFormat:@"%@:00",self.actStartTimeStr];
            [activityDict setObject:startEndStr forKey:@"startTime"];
            NSString *temEndStr = [NSString stringWithFormat:@"%@:00",self.actEndTimeStr];
            [activityDict setObject:temEndStr forKey:@"endTime"];
            [activityDict setObject:self.activityPlace?self.activityPlace:@"" forKey:@"activityPlace"];
            [activityDict setObject:self.activityAddress?self.activityAddress:@"" forKey:@"activityAddress"];
            [activityDict setObject:self.activityEnd?self.activityEnd:@"" forKey:@"activityEnd"];
            
            [activityDict setObject:self.longitude?self.longitude:@"" forKey:@"longitude"];
            [activityDict setObject:self.latitude?self.latitude:@"" forKey:@"latitude"];
            
            if (self.signUpNumStr.length<=0||[self.signUpNumStr isEqualToString:@"无限制"]||[self.signUpNumStr isEqualToString:@"0"]) {
                [activityDict setObject:@"0" forKey:@"activityPerson"];
            }
            else{
                [activityDict setObject:self.signUpNumStr?self.signUpNumStr:@"" forKey:@"activityPerson"];
            }
            [activityDict setObject:@(self.unionId) forKey:@"unionId"];
        }
        
        if (self.setDataArray.count<=0) {
            NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:self.setDataArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
            constructionStr2 = [constructionStr2 ew_removeSpaces];
            constructionStr2 = [constructionStr2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            [activityDict setObject:constructionStr2 forKey:@"custom"];
        }
        else{
            [activityDict setObject:_customStr forKey:@"custom"];
        }
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        [activityDict setObject:@(user.agencyId) forKey:@"agencysId"];
        [activityDict setObject:@(1) forKey:@"isLeader"];
        [activityDict setObject:@(0) forKey:@"createCompanyId"];
        
    }
    
    
    else{
        //不是第一次编辑
        [designDict setObject:@(self.designId) forKey:@"designId"];
        [designDict setObject:self.coverTitle forKey:@"designTitle"];
        [designDict setObject:self.coverTitleTwo forKey:@"designSubtitle"];
        [designDict setObject:@(self.musicStyle) forKey:@"musicPlay"];
        [designDict setObject:@(user.agencyId) forKey:@"agencysId"];
        [designDict setObject:@(0) forKey:@"constructionId"];
        [designDict setObject:self.coverImgUrl?:@"" forKey:@"coverMap"];
        [designDict setObject:self.musicName?self.musicName:@"" forKey:@"musicName"];
        [designDict setObject:self.musicUrl?self.musicUrl:@"" forKey:@"musicUrl"];
        
        [designDict setObject:self.coverImgStr?self.coverImgStr:@"" forKey:@"picUrl"];
        [designDict setObject:self.linkUrl?self.linkUrl:@"" forKey:@"picHref"];
        [designDict setObject:self.nameStr?self.nameStr:@"" forKey:@"picTitle"];
        
        //给数组排序
        
        NSInteger arrCount = self.dataArray.count;
        for (int i = 0; i<arrCount; i++) {
            DesignCaseListModel *model = self.dataArray[i];
            model.sort = i;
            [self.dataArray replaceObjectAtIndex:i withObject:model];
        }
        
        // 先获取新增的detail
        NSMutableArray *temAddDetailArray = [NSMutableArray array];
        for (DesignCaseListModel *model in self.dataArray) {
            if (model.detailsId==0) {
                [temAddDetailArray addObject:model];
            }
        }
        //获取删除的
        NSMutableArray *temDeleteDetailArray = [NSMutableArray array];
        for (DesignCaseListModel *model in self.orialArray) {
            if (![self.dataArray containsObject:model]) {
                model.content = @"";
                model.imgUrl = @"";
                model.videoUrl = @"";
                model.currencyUrl = @"";
                [temDeleteDetailArray addObject:model];
            }
        }
        //获取修改的
        NSMutableArray *temModifyDetailArray = [NSMutableArray array];
        for (DesignCaseListModel *model in self.dataArray) {
            if (model.detailsId!=0) {
                [temModifyDetailArray addObject:model];
            }
        }
        
        for (DesignCaseListModel *model in temModifyDetailArray) {
            NSMutableDictionary *temDetailDict = [NSMutableDictionary dictionary];
            [temDetailDict setObject:@(model.detailsId) forKey:@"detailsId"];
            [temDetailDict setObject:model.content forKey:@"content"];
            [temDetailDict setObject:model.htmlContent forKey:@"htmlContent"];
            [temDetailDict setObject:model.imgUrl forKey:@"imgUrl"];
            [temDetailDict setObject:model.videoUrl?model.videoUrl:@"" forKey:@"videoUrl"];
            [temDetailDict setObject:model.currencyUrl?model.currencyUrl:@"" forKey:@"currencyUrl"];
            [temDetailDict setObject:model.link?model.link:@"" forKey:@"link"];
            [temDetailDict setObject:model.linkDescribe?model.linkDescribe:@"" forKey:@"linkDescribe"];
            [temDetailDict setObject:@(model.sort) forKey:@"sort"];
            
            [detailsArray addObject:temDetailDict];
            
        }
        if (temDeleteDetailArray.count>0) {
            for (DesignCaseListModel *model in temDeleteDetailArray) {
                NSMutableDictionary *temDetailDict = [NSMutableDictionary dictionary];
                [temDetailDict setObject:@(model.detailsId) forKey:@"detailsId"];
                [temDetailDict setObject:model.content forKey:@"content"];
                [temDetailDict setObject:model.htmlContent forKey:@"htmlContent"];
                [temDetailDict setObject:model.imgUrl forKey:@"imgUrl"];
                [temDetailDict setObject:model.videoUrl?model.videoUrl:@"" forKey:@"videoUrl"];
                [temDetailDict setObject:model.currencyUrl?model.currencyUrl:@"" forKey:@"currencyUrl"];
                [temDetailDict setObject:model.link?model.link:@"" forKey:@"link"];
                [temDetailDict setObject:model.linkDescribe?model.linkDescribe:@"" forKey:@"linkDescribe"];
                [temDetailDict setObject:@(0) forKey:@"sort"];
                
                [detailsArray addObject:temDetailDict];
                
            }
        }
        if (temAddDetailArray.count>0) {
            for (DesignCaseListModel *model in temAddDetailArray) {
                NSMutableDictionary *temDetailDict = [NSMutableDictionary dictionary];
                [temDetailDict setObject:@(model.detailsId) forKey:@"detailsId"];
                [temDetailDict setObject:model.content forKey:@"content"];
                [temDetailDict setObject:model.htmlContent forKey:@"htmlContent"];
                [temDetailDict setObject:model.imgUrl forKey:@"imgUrl"];
                [temDetailDict setObject:model.videoUrl?model.videoUrl:@"" forKey:@"videoUrl"];
                [temDetailDict setObject:model.currencyUrl?model.currencyUrl:@"" forKey:@"currencyUrl"];
                [temDetailDict setObject:model.link?model.link:@"" forKey:@"link"];
                [temDetailDict setObject:model.linkDescribe?model.linkDescribe:@"" forKey:@"linkDescribe"];
                [temDetailDict setObject:@(model.sort) forKey:@"sort"];
                
                [detailsArray addObject:temDetailDict];
            }
        }
        
        
        if (!self.voteDescribe||self.voteDescribe.length<=0) {
            //没有投票
            
            [voteDict setObject:@"" forKey:@"voteDescribe"];
            [voteDict setObject:@"" forKey:@"voteEndTime"];
            [voteDict setObject:@(1) forKey:@"voteType"];
            
            
            NSMutableArray *optionArray = [NSMutableArray array];
            
            NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:optionArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
            constructionStr2 = [constructionStr2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [voteDict setObject:constructionStr2 forKey:@"option"];
        }
        
        else{
            [voteDict setObject:self.voteDescribe forKey:@"voteDescribe"];
            [voteDict setObject:self.endTime?self.endTime:@"" forKey:@"voteEndTime"];
            [voteDict setObject:self.voteType forKey:@"voteType"];
            
            
            NSMutableArray *optionArray = [NSMutableArray array];
            for (VoteOptionModel *model in self.optionList) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@(model.voteId) forKey:@"voteId"];
                [dict setObject:model.voteOption forKey:@"voteOption"];
                [optionArray addObject:dict];
            }
            
            NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:optionArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
            constructionStr2 = [constructionStr2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [voteDict setObject:constructionStr2 forKey:@"option"];
        }
        
        
        if (self.isHaveSignUp) {
            [activityDict setObject:self.actId forKey:@"activityId"];
            NSString *startEndStr = [NSString stringWithFormat:@"%@:00",self.actStartTimeStr];
            [activityDict setObject:startEndStr forKey:@"startTime"];
            NSString *temEndStr = [NSString stringWithFormat:@"%@:00",self.actEndTimeStr];
            [activityDict setObject:temEndStr forKey:@"endTime"];
            [activityDict setObject:self.activityPlace forKey:@"activityPlace"];
            [activityDict setObject:self.activityAddress forKey:@"activityAddress"];
            [activityDict setObject:self.activityEnd forKey:@"activityEnd"];
            
            [activityDict setObject:self.longitude?self.longitude:@"" forKey:@"longitude"];
            [activityDict setObject:self.latitude?self.latitude:@"" forKey:@"latitude"];
            
            if (self.signUpNumStr.length<=0||[self.signUpNumStr isEqualToString:@"无限制"]||[self.signUpNumStr isEqualToString:@"0"]) {
                [activityDict setObject:@"0" forKey:@"activityPerson"];
            }
            else{
                [activityDict setObject:self.signUpNumStr forKey:@"activityPerson"];
            }
            [activityDict setObject:@(self.unionId) forKey:@"unionId"];
        }
        
        if (self.setDataArray.count<=0) {
            NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:self.setDataArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
            constructionStr2 = [constructionStr2 ew_removeSpaces];
            constructionStr2 = [constructionStr2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            [activityDict setObject:constructionStr2 forKey:@"custom"];
        }
        else{
            [activityDict setObject:_customStr forKey:@"custom"];
        }
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        [activityDict setObject:@(user.agencyId) forKey:@"agencysId"];
        [activityDict setObject:@(1) forKey:@"isLeader"];
        
    }
    
    [dataDict setObject:designDict forKey:@"design"];
    [dataDict setObject:detailsArray forKey:@"details"];
    [dataDict setObject:voteDict forKey:@"vote"];
    if (self.isHaveSignUp) {
        [dataDict setObject:activityDict forKey:@"activity"];
    }
    
    
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return dataStr;
}

-(void)pushData{
 
    NSString *dataStr = [self jsonfrom];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"designs/saveBellesLettres.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"jsonList":dataStr,
                               @"type":@(self.type)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                if (self.isFistr) {
                    self.isFistr = NO;
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshBeatAteList" object:nil];
                    for (UIViewController *vc in self.navigationController.childViewControllers) {
                        if ([vc isKindOfClass:[MyBeautifulArtController class]]) {
                            [self.navigationController popToViewController:vc animated:YES];
                        }
                    }
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshBeatAteList" object:nil];
                    [self SuspendedButtonDisapper];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else if(statusCode==1001){
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
            }
            else if(statusCode==2000){
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
        }
                NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

// 获取视频的第一张图
-(UIImage *)getImage:(NSString *)videoURL{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64-50) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = RGB(241, 242, 245);
        //        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        [_tableView setEditing:YES animated:YES];
        
    }
    return _tableView;
}

-(UIView *)bottombackGroundV{
    if (!_bottombackGroundV) {
        _bottombackGroundV = [[UIView alloc]initWithFrame:CGRectMake(0,0,kSCREEN_WIDTH,60)];
        _bottombackGroundV.backgroundColor = RGB(241, 242, 245);
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backGroundVGes:)];
        //        ges.numberOfTouches = 1;
        _bottombackGroundV.userInteractionEnabled = YES;
        [_bottombackGroundV addGestureRecognizer:ges];
    }
    return _bottombackGroundV;
}

-(UIButton *)bottomaddBtn{
    if (!_bottomaddBtn) {
        _bottomaddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomaddBtn.frame = CGRectMake(kSCREEN_WIDTH/2-13, 5, 26, 15);
        [_bottomaddBtn setImage:[UIImage imageNamed:@"edit_insert_normal"] forState:UIControlStateNormal];
        [_bottomaddBtn addTarget:self action:@selector(bottomaddBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomaddBtn;
}

-(UIView *)hiddenV{
    if (!_hiddenV) {
        
        _hiddenV = [[UIView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-54*3/2, 5, 54*3, 30)];
        _hiddenV.layer.masksToBounds = YES;
        _hiddenV.layer.cornerRadius = 15;
        //        _hiddenV.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
        //        _hiddenV.layer.borderWidth = 1.0f;
        //        _hiddenV.backgroundColor = White_Color;
    }
    return _hiddenV;
}

-(UIButton *)addTextBtn{
    if (!_addTextBtn) {
        _addTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addTextBtn.frame = CGRectMake(0, 0, self.hiddenV.width/3, self.hiddenV.height);
        
        //            _addressBtn.backgroundColor = Red_Color;
        [_addTextBtn setImage:[UIImage imageNamed:@"edit_add_text_normal"] forState:UIControlStateNormal];
        [_addTextBtn setImage:[UIImage imageNamed:@"edit_add_text_pressed"] forState:UIControlStateHighlighted];
        
        [_addTextBtn addTarget:self action:@selector(addtextToBottom) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addTextBtn;
}

-(UIButton *)addPhotoBtn{
    if (!_addPhotoBtn) {
        _addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addPhotoBtn.frame = CGRectMake(self.addTextBtn.right, 0, self.hiddenV.width/3, self.hiddenV.height);
        
        //            _addressBtn.backgroundColor = Red_Color;
        [_addPhotoBtn setImage:[UIImage imageNamed:@"edit_add_image_normal"] forState:UIControlStateNormal];
        [_addPhotoBtn setImage:[UIImage imageNamed:@"edit_add_image_pressed"] forState:UIControlStateHighlighted];
        [_addPhotoBtn addTarget:self action:@selector(addPhotosToBottom) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addPhotoBtn;
}

-(UIButton *)addVideoBtn{
    if (!_addVideoBtn) {
        _addVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addVideoBtn.frame = CGRectMake(self.addPhotoBtn.right, 0, self.hiddenV.width/3, self.hiddenV.height);
        
        //            _addressBtn.backgroundColor = Red_Color;
        [_addVideoBtn setImage:[UIImage imageNamed:@"edit_add_video_normal"] forState:UIControlStateNormal];
        [_addVideoBtn setImage:[UIImage imageNamed:@"edit_add_videl_pressed"] forState:UIControlStateHighlighted];
        [_addVideoBtn addTarget:self action:@selector(addVideoToBottom) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addVideoBtn;
}

-(UIView *)bottomMusicStyleV{
    if (!_bottomMusicStyleV) {
        _bottomMusicStyleV = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-50, kSCREEN_WIDTH, 50)];
        _bottomMusicStyleV.backgroundColor = RGB(241, 242, 245);
        _bottomMusicStyleV.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeMusicStyle)];
        [_bottomMusicStyleV addGestureRecognizer:ges];
    }
    return _bottomMusicStyleV;
}

-(UILabel *)musicLeftL{
    if (!_musicLeftL) {
        _musicLeftL = [[UILabel alloc]initWithFrame:CGRectMake(15,0,100,self.bottomMusicStyleV.height)];
        _musicLeftL.textColor = COLOR_BLACK_CLASS_3;
        _musicLeftL.font = NB_FONTSEIZ_BIG;
        _musicLeftL.text = @"音乐播放模式";
        _musicLeftL.numberOfLines = 0;
        //        companyJob.backgroundColor = Red_Color;
        _musicLeftL.textAlignment = NSTextAlignmentLeft;
    }
    return _musicLeftL;
}

-(UILabel *)musicRightL{
    if (!_musicRightL) {
        _musicRightL = [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-180,0,150,self.bottomMusicStyleV.height)];
        _musicRightL.textColor = COLOR_BLACK_CLASS_3;
        _musicRightL.font = NB_FONTSEIZ_BIG;
        _musicRightL.text = @"进入页面直接播放";
        _musicRightL.numberOfLines = 0;
        //        companyJob.backgroundColor = Red_Color;
        _musicRightL.textAlignment = NSTextAlignmentRight;
    }
    return _musicRightL;
}

-(UIImageView *)bottomRow{
    if (!_bottomRow) {
        _bottomRow = [[UIImageView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-15, self.bottomMusicStyleV.height/2-13/2, 7.5, 13)];
        _bottomRow.image = [UIImage imageNamed:@"common_arrow_btn"];
    }
    return _bottomRow;
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
        _backShadowV = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_HEIGHT, kSCREEN_HEIGHT-64)];
        _backShadowV.backgroundColor = COLOR_BLACK_CLASS_0;
        _backShadowV.alpha = 0.5;
    }
    return _backShadowV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
