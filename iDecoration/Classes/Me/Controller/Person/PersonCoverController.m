//
//  PersonCoverController.m
//  iDecoration
//
//  Created by sty on 2018/1/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "PersonCoverController.h"
#import "CLPlayerView.h"
#import "SDCycleScrollView.h"
#import "TZImagePickerController.h"
#import "NSObject+CompressImage.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ASProgressPopUpView.h"
#import "LocalMusicController.h"
#import "AddVideoLinkViewController.h"


#import "PersonCardModel.h"

#import "ASProgressPopUpView.h"

#import "SSPopup.h"

// 音乐播放计时器
static NSString *CLPlayer_musicTimer = @"CLPlayer_musicTimer";

@interface PersonCoverController ()<UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,SDCycleScrollViewDelegate, CLPlayerViewDelegate,ASProgressPopUpViewDataSource,SSPopupDelegate>{
    
    NSString *_videoPath;
    
}


@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SDCycleScrollView *adScrollView; // 轮播图
@property (nonatomic, strong) UILabel *adFlagLabel;
@property (nonatomic, strong) UIView *musicView; // 歌曲视图
//@property (nonatomic, weak) CLPlayerView *videoPlayerView; // 视频播放器
@property (nonatomic, strong) UIButton *palyVideoBtn;

@property (nonatomic, strong) UIButton *deleteBtn;//删除视频按钮
@property (nonatomic, strong) UIButton *upLoadMusicBtn;//上传音乐
@property (nonatomic, strong) UIButton *editCoverBtn;//编辑封面

@property (nonatomic, weak) CLPlayerView *musicPlayerView; // 音乐播放
@property (nonatomic, strong) UIButton *playMusicBtn;
@property (nonatomic, strong) UILabel *musicNameLabel;
@property (nonatomic, strong) UILabel *musicTimeLabel;

@property (nonatomic, assign) BOOL isHaveMusic; // 是否有背景音乐
//@property (nonatomic, assign) BOOL isHaveVideo; // 是否有视频
@property (nonatomic, assign) BOOL isPlayingMusic;

@property (nonatomic, assign) NSInteger musicStyle;

//进度条
@property (nonatomic, strong) ASProgressPopUpView *progress;
@property (nonatomic, strong) UIView *backShadowV;

@property (nonatomic, strong) UIView *bottomMusicStyleV;//底部音乐播放模式选择
@property (nonatomic, strong) UILabel *musicLeftL;
@property (nonatomic, strong) UILabel *musicRightL;
@property (nonatomic, strong) UIImageView *bottomRow;

@property (nonatomic, strong) PersonCardModel *model;

@property (nonatomic, strong) NSMutableArray *bannerImgArray;
@property (nonatomic, strong) NSMutableArray *coverImgArray;//封面图数组
@end

@implementation PersonCoverController

-(NSMutableArray*)bannerImgArray{
    
    if (!_bannerImgArray) {
        _bannerImgArray = [NSMutableArray array];
    }
    return _bannerImgArray;
}

-(NSMutableArray*)coverImgArray{
    
    if (!_coverImgArray) {
        _coverImgArray = [NSMutableArray array];
    }
    return _coverImgArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人封面";
//    self.bannerImgArray = [NSMutableArray array];
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(successBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    [self setUI];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
    [self requestInfo];
    
}

-(void)back{
    [self.musicPlayerView destroyPlayer];
//    self.musicPlayerView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUI{
    
    
    
    [self.view addSubview:self.headerView];
    
    self.adFlagLabel.hidden = YES;
    
    
    [self.view addSubview:self.bottomMusicStyleV];
    [self.bottomMusicStyleV addSubview:self.musicLeftL];
    [self.bottomMusicStyleV addSubview:self.musicRightL];
    [self.bottomMusicStyleV addSubview:self.bottomRow];
    
}

-(void)initData{
    self.musicUrl = self.model.music;
    self.musicName = self.model.musicName;
    self.videlUrl = self.model.video;
    self.videlImgUrl = self.model.videoImg;
    self.musicStyle = self.model.autoPlay;
    
    [self.bannerImgArray removeAllObjects];
    [self.coverImgArray removeAllObjects];
    if (self.videlImgUrl&&self.videlImgUrl.length>0) {
        [self.bannerImgArray addObject:self.videlImgUrl];
    }
    if (self.model.coverMap.length>0) {
        NSArray *array = [self.model.coverMap componentsSeparatedByString:@","];
        
        
        [self.coverImgArray addObjectsFromArray:array];
    }
    
    
    [self.bannerImgArray addObjectsFromArray:self.coverImgArray];
    self.adScrollView.imageURLStringsGroup = self.bannerImgArray;
    
    //音乐
    if (!self.musicUrl||self.musicUrl.length<=0) {
        //没有音乐
        self.musicNameLabel.text = @"暂无音乐";
        self.playMusicBtn.userInteractionEnabled = NO;
    }
    else{
        self.musicNameLabel.text = self.musicName;
        self.playMusicBtn.userInteractionEnabled = YES;
    }
    
    //视频
    if (!self.videlUrl||self.videlUrl.length<=0) {
        self.palyVideoBtn.hidden = YES;
        self.deleteBtn.hidden = YES;
    }
    else{
        self.palyVideoBtn.hidden = NO;
        self.deleteBtn.hidden = NO;
    }
    
    
    NSArray *QArray = @[@"点击播放",@"进入页面直接播放"];
    self.musicRightL.text = QArray[self.model.autoPlay];
}

#pragma mark - 查询名片信息

-(void)requestInfo{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *temStr = [NSString stringWithFormat:@"businessCard/%ld/%ld.do",user.agencyId,user.agencyId];
    NSString *defaultApi = [BASEURL stringByAppendingString:temStr];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{
//                               @"agencyId":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
//                [[PublicTool defaultTool] publicToolsHUDStr:@"创建成功" controller:self sleep:1.5];
                NSDictionary *cardDict = [[responseObj objectForKey:@"data"] objectForKey:@"cardModel"];
                
                self.model = [PersonCardModel yy_modelWithJSON:cardDict];
                [self initData];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - action

-(void)uploadMusicBtnClick:(UIButton *)btn{
    LocalMusicController *vc = [[LocalMusicController alloc]init];
    vc.musicUrl = self.musicUrl;
    vc.songName = self.musicName;
    __weak typeof (self) wself = self;
    vc.localMusicBlock = ^(NSString *musicUrl, NSString *songName) {
        wself.musicUrl = musicUrl;
        wself.musicName = songName;
        
        wself.musicNameLabel.text = self.musicName;
        wself.playMusicBtn.userInteractionEnabled = YES;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 更换音乐播放模式
-(void)changeMusicStyle{
    
    NSArray *QArray = @[@"点击播放",@"进入页面直接播放"];
    
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

-(void)editCoverBtnClick:(UIButton *)btn{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"选择图片" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 delegate:nil];
        __weak typeof (self) weakSelf = self;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
            
            [NSObject uploadImgWith:photos completion:^(NSArray *imageURLArray) {
                YSNLog(@"%@", imageURLArray);
                [weakSelf.bannerImgArray removeAllObjects];
                
                
                if (weakSelf.videlImgUrl&&weakSelf.videlImgUrl.length>0) {
                    [weakSelf.bannerImgArray addObject:weakSelf.videlImgUrl];
                    weakSelf.deleteBtn.hidden = NO;
                }
                else{
                    weakSelf.deleteBtn.hidden = YES;
                }
                
                [weakSelf.coverImgArray removeAllObjects];
                
                [weakSelf.coverImgArray addObjectsFromArray:imageURLArray];
                [weakSelf.bannerImgArray addObjectsFromArray:weakSelf.coverImgArray];
                
//                weakSelf.adScrollView.localizationImageNamesGroup = photos;
                weakSelf.adScrollView.imageURLStringsGroup = self.bannerImgArray;
            }];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"本地视频" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self selectVideo];
        
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"拍摄视频" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self takeVideo];
        
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [alertC addAction:action3];
    [alertC addAction:action4];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - 上传视频

-(void)selectVideo{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.videoMaximumDuration = 15;
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
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
    imagePicker.videoMaximumDuration = 15;
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    imagePicker.showsCameraControls = YES;
    //    imagePicker.cameraOverlayView
    NSString *requiredMediaType1 = (NSString *)kUTTypeMovie;
    //    //    NSString *requiredMediaType1 = @"public.movie";
    imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects:requiredMediaType1, nil];
    [self presentViewController:imagePicker animated:YES completion:nil];
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
        
        
        
        //                if (upTag==1) {
        //
        //                }
        //                if (upTag==2) {
        //                    //需要先存到手机相册
        //                    if (videoPath) {
        //
        //                        ALAssetsLibrary *libraryTwo = [[ALAssetsLibrary alloc] init];
        //                        [libraryTwo writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:outPath]
        //                                                       completionBlock:^(NSURL *assetURL, NSError *error) {
        //                                                           if (error) {
        //                                                               YSNLog(@"保存失败");
        //                                                           } else {
        //                                                               YSNLog(@"保存成功");
        //
        //                                                               [[NSFileManager defaultManager] removeItemAtPath:_videoPath error:nil];//取消之后就删除，以免占用手机硬盘空间（沙盒）
        //                                                           }
        //                                                       }];
        //
        //                    }
        //
        //                }
        [picker dismissViewControllerAnimated:YES completion:^{}];
    }
    
    
}

//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
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
            
            
            
            //            NSString *imgUrl = [responseObject objectForKey:@"imgUrl"];
            
            
            NSString *imgUrl = [responseObject objectForKey:@"imgUrl"];
            NSString *viodeUrl = [responseObject objectForKey:@"videoUrl"];
            __weak typeof(self) weakSelf = self;
            weakSelf.videlUrl = viodeUrl;
                        weakSelf.videlImgUrl = imgUrl;
            
            
            
                        [weakSelf.bannerImgArray removeAllObjects];
            
                        if (weakSelf.videlImgUrl&&weakSelf.videlImgUrl.length>0) {
                            [weakSelf.bannerImgArray addObject:weakSelf.videlImgUrl];
                            weakSelf.deleteBtn.hidden = NO;
                        }
            
                        [weakSelf.bannerImgArray addObjectsFromArray:weakSelf.coverImgArray];
            
                        weakSelf.adScrollView.imageURLStringsGroup = self.bannerImgArray;
            
            
            
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


#pragma mark - 删除视频

-(void)deleteVideo:(UIButton *)btn{
    __weak typeof(self) weakSelf = self;
    weakSelf.videlUrl = @"";
    weakSelf.videlImgUrl = @"";
    
    
    
    [weakSelf.bannerImgArray removeAllObjects];
    
    weakSelf.deleteBtn.hidden = YES;
    weakSelf.palyVideoBtn.hidden = YES;
    [weakSelf.bannerImgArray addObjectsFromArray:weakSelf.coverImgArray];
    
    weakSelf.adScrollView.imageURLStringsGroup = self.bannerImgArray;
}

#pragma mark - 视频播放按钮的隐藏与否


-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    if (self.videlImgUrl&&self.videlImgUrl.length>0&&index==0){
        self.palyVideoBtn.hidden = NO;
        self.deleteBtn.hidden = NO;
    }
    else{
        self.palyVideoBtn.hidden = YES;
        self.deleteBtn.hidden = YES;
    }
}

// 播放 音乐
- (void)playMusic:(UIButton *)sender {
    _isPlayingMusic = !_isPlayingMusic;
    if (_isPlayingMusic) {
        // 停止视频播放
//        [_videoPlayerView pausePlay];
        
        self.musicPlayerView.url = [NSURL URLWithString:self.musicUrl];
        [sender setImage:[UIImage imageNamed:@"music_pause"] forState:UIControlStateNormal];
        [_musicPlayerView playVideo];
        
        //当前时长
        //计时器，循环执行 设置音乐播放时间
        [[CLGCDTimerManager sharedManager] scheduledDispatchTimerWithName:CLPlayer_musicTimer
                                                             timeInterval:1.0f
                                                                delaySecs:0
                                                                    queue:dispatch_get_main_queue()
                                                                  repeats:YES
                                                                   action:^{
                                                                       [self setMusicTime];
                                                                   }];
        [[CLGCDTimerManager sharedManager] startTimer:CLPlayer_musicTimer];
        
        
    } else {
        [sender setImage:[UIImage imageNamed:@"music_play"] forState:UIControlStateNormal];
        [_musicPlayerView pausePlay];
        [[CLGCDTimerManager sharedManager] suspendTimer:CLPlayer_musicTimer];
    }
    
    
}

-(void)playVideoAction{
    [[PublicTool defaultTool] publicToolsHUDStr:@"编辑时暂不支持播放" controller:self sleep:1.5];
}

// 设置音乐时间
- (void)setMusicTime {
    NSString *str = [self.musicPlayerView playerCurrentTime];
    if ([str isEqualToString:@"00:00"]) {
        self.musicTimeLabel.text = @"缓冲中。。。";
    } else {
        self.musicTimeLabel.text = [self.musicPlayerView playerCurrentTime];
    }
    
//    YSNLog(@"88888  %@", [self.musicPlayerView playerCurrentTime]);
}

-(void)successBtnClick:(UIButton *)btn{
    if (self.musicPlayerView.state == CLPlayerStatePlaying){
        [self.musicPlayerView pausePlay];
    }
    if (self.coverImgArray.count<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"至少上传一张封面" controller:self sleep:1.5];
        return;
    }
    
    NSString *coverMustrStr = [[self.coverImgArray copy]componentsJoinedByString:@","];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"businessCard/save.do"];
    
    NSInteger temCardId = self.model.cardId?self.model.cardId:0;
    NSInteger temScanNum = self.model.scanNumbers?self.model.scanNumbers:0;
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"agencyId":@(user.agencyId),
                               @"companyId":@(self.model.companyId)?@(self.model.companyId):@(0),
                               @"video":self.videlUrl?self.videlUrl:@"",
                               @"videoImg":self.videlImgUrl?self.videlImgUrl:@"",
                               @"autoPlay":@(self.musicStyle),
                               @"music":self.musicUrl?self.musicUrl:@"",
                               
                               @"coverMap":coverMustrStr,
                               @"cardId":@(temCardId),
                               @"scanNumbers":@(temScanNum),
                               @"musicName":self.musicName?self.musicName:@""
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"修改成功" controller:self sleep:1.5];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"personCoverEditSucess" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
    
}

#pragma mark - lazy

-(UIView *)headerView{
    if (!_headerView){
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_WIDTH, 330)];
        _headerView.backgroundColor = kSepLineColor;
        CGFloat headerViewHeight = 0;
        
        self.adScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 265) delegate:self placeholderImage:nil];
        self.adScrollView.autoScroll = NO;
        self.adScrollView.showPageControl = YES;
        self.adScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        self.adScrollView.backgroundColor = Black_Color;
        
        [_headerView addSubview:self.adScrollView];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(_headerView.width-40,10,20,20);
        [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteVideo:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteBtn = deleteBtn;
        [_headerView addSubview:self.deleteBtn];
        
        self.adFlagLabel = [UILabel new];
        [self.adScrollView addSubview:self.adFlagLabel];
        [self.adFlagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-16);
            make.left.equalTo(32);
            make.height.equalTo(24);
            make.width.equalTo(40);
        }];
        self.adFlagLabel.textColor = [UIColor whiteColor];
        self.adFlagLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.adFlagLabel.font = [UIFont systemFontOfSize:14];
        self.adFlagLabel.layer.cornerRadius = 12;
        self.adFlagLabel.layer.masksToBounds = YES;
        self.adFlagLabel.textAlignment = NSTextAlignmentCenter;
        self.adFlagLabel.text = @"1/5";
//        [self setupPlayerView:self.adScrollView];
        
        
        UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        uploadBtn.frame = CGRectMake(30,self.adScrollView.bottom-10-20,70,20);
        uploadBtn.backgroundColor = kSepLineColor;
        [uploadBtn setTitle:@"上传音乐" forState:UIControlStateNormal];
        uploadBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [uploadBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        uploadBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        uploadBtn.layer.masksToBounds = YES;
        uploadBtn.layer.cornerRadius = 5;
        [uploadBtn addTarget:self action:@selector(uploadMusicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.upLoadMusicBtn = uploadBtn;
        [self.headerView addSubview:self.upLoadMusicBtn];
        
        UIButton *modefyCoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        modefyCoverBtn.frame = CGRectMake(kSCREEN_WIDTH-70-30,self.upLoadMusicBtn.top,70,20);
        modefyCoverBtn.backgroundColor = kSepLineColor;
        [modefyCoverBtn setTitle:@"更改封面" forState:UIControlStateNormal];
        modefyCoverBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [modefyCoverBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        modefyCoverBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        modefyCoverBtn.layer.masksToBounds = YES;
        modefyCoverBtn.layer.cornerRadius = 5;
        [modefyCoverBtn addTarget:self action:@selector(editCoverBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.editCoverBtn = modefyCoverBtn;
        [self.headerView addSubview:self.editCoverBtn];
        
        UIButton *playVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.palyVideoBtn = playVideoBtn;
        playVideoBtn.frame = CGRectMake(kSCREEN_WIDTH/2-20, self.adScrollView.height/2-20, 40, 40);
        [self.headerView addSubview:playVideoBtn];
        [playVideoBtn setBackgroundImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
        [playVideoBtn addTarget:self action:@selector(playVideoAction) forControlEvents:UIControlEventTouchUpInside];
        
        // 歌曲视图
        UIView *musicView = [[UIView alloc] initWithFrame:CGRectMake(0, self.adScrollView.bottom + 5, kSCREEN_WIDTH, 60)];
        self.musicView = musicView;
        [_headerView addSubview:musicView];
        musicView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 8, 42, 42)];
        imageV.image = [UIImage imageNamed:@"CD"];
        [musicView addSubview:imageV];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        self.musicNameLabel = nameLabel;
        [musicView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageV.mas_top).equalTo(5);
            make.left.equalTo(imageV.mas_right).equalTo(8);
        }];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.text = @"歌曲名字";
        UILabel *timeLabel = [UILabel new];
        self.musicTimeLabel = timeLabel;
        [musicView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).equalTo(0);
            make.left.equalTo(imageV.mas_right).equalTo(8);
        }];
        timeLabel.font = [UIFont systemFontOfSize:14];
        timeLabel.text = @"00:00";
        
        CLPlayerView *musicPlauerView = [[CLPlayerView alloc] initWithFrame:musicView.frame];
        _musicPlayerView = musicPlauerView;
        _musicPlayerView.videoFillMode = VideoFillModeResizeAspect;
        _musicPlayerView.repeatPlay = YES;
        [musicView addSubview:_musicPlayerView];
        _musicPlayerView.hidden = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playMusicBtn = btn;
        [musicView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-16);
            make.centerY.equalTo(0);
            make.size.equalTo(CGSizeMake(30, 30));
        }];
        _isPlayingMusic = NO;
        [btn setImage:[UIImage imageNamed:@"music_play"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(playMusic:) forControlEvents:UIControlEventTouchUpInside];
        
        //        headerViewHeight =kSCREEN_WIDTH + 65;
//        _headerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 265);
        
        
    }
    return _headerView;
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

@end
