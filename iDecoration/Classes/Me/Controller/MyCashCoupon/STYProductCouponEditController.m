//
//  STYProductCouponEditController.m
//  iDecoration
//
//  Created by sty on 2018/2/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "STYProductCouponEditController.h"
#import "DesignCaseListHeadCell.h"
#import "DesignCaseListMidCell.h"
#import "DesignCaseListModel.h"
#import "TZImagePickerController.h"
#import "NSObject+CompressImage.h"
#import "HKImageClipperViewController.h"
#import "LocalMusicController.h"
#import "AddDesignFullLook.h"
#import "AddVideoLinkViewController.h"
#import "SDCycleScrollView.h"
#import "SetwWatermarkController.h"
#import "ActivityChangeMainTitleController.h"
#import "EditGoodsParameterViewController.h"

#import "GoodsParamterModel.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ASProgressPopUpView.h"

#import "VrCommenCell.h"

#import "SSPopup.h"

@interface STYProductCouponEditController ()<UITableViewDelegate,UITableViewDataSource,DesignCaseListMidCellDelegate,DesignCaseListHeadCellDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,SSPopupDelegate,ASProgressPopUpViewDataSource,UIActionSheetDelegate,UITextFieldDelegate,SDCycleScrollViewDelegate,VrCommenCellDelegate>{
    NSMutableDictionary *hiddenStateDict; //
    BOOL bottomCellIsHidden; //yes:显示加号。//no:显示添加图片
    
    BOOL isHaveVR; //no:没有全景 yes：有全景
    NSInteger addVideoType; //1:添加封面视频 2:添加节点视频
    
    NSIndexPath *addPath;// 添加图片到第几个cell前面
    NSIndexPath *modifyPath;// 修改的是第几个cell的图片
    NSInteger addVidelTag;//添加视频到第几个前面 (-1:放到最后一个)
    
    NSInteger addTextTag;//添加文字到第几个前面（-1，放到最后一个）
    NSInteger modifyTextTag;//修改的是第几个文字
    
    BOOL isHaveDefaultLogo;//  默认图不一样 no:有默认图(edit)  yes：有默认图(defaultLogo)
    
    NSInteger upTag;//1:选取本地视频上传。2:拍摄视频上传
    
    NSString *_videoPath;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *MidCellHDict;//


@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) SDCycleScrollView *adScrollView;
@property (nonatomic, strong) UIButton *upLoadMusicBtn;//上传音乐
@property (nonatomic, strong) UIButton *editCoverBtn;//编辑封面

@property (nonatomic, strong) UIView *bigGroundV;
@property (nonatomic, strong) UIView *bottombackGroundV;
@property (nonatomic, strong) UIButton *bottomaddBtn;

@property (nonatomic, strong) UIView *hiddenV;//隐藏或显示的view
@property (nonatomic, strong) UIButton *addTextBtn;
@property (nonatomic, strong) UIButton *addPhotoBtn;
@property (nonatomic, strong) UIButton *addVideoBtn;



@property (nonatomic, strong) UIView *bottomMusicStyleV;//底部音乐播放模式选择
@property (nonatomic, strong) UILabel *musicLeftL;
@property (nonatomic, strong) UILabel *musicRightL;
@property (nonatomic, strong) UIImageView *bottomRow;

//进度条
@property (nonatomic, strong) ASProgressPopUpView *progress;
@property (nonatomic, strong) UIView *backShadowV;

@property (nonatomic, strong) UIButton *successBtn;
@end

@implementation STYProductCouponEditController


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

-(NSMutableArray *)paramArray{
    if (!_paramArray) {
        _paramArray = [NSMutableArray array];
    }
    return _paramArray;
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
    
    self.title = @"礼品编辑";
    self.bannerImgArray = [NSMutableArray array];
    self.coverImgArray = [NSMutableArray array];
    
    NSInteger count = self.dataArray.count;
    hiddenStateDict = [NSMutableDictionary dictionary];
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    bottomCellIsHidden = YES;
    isHaveVR = NO;
    [self setUI];
    
}

-(void)setUI{
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
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.dataArray.count;
    }
    else{
        return 1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIImage *img = [UIImage imageNamed:DEFAULTLOGO];
//    self.adScrollView.imageURLStringsGroup = @[img];
    if (section==0) {
        UIView *view = [[UIView alloc]init];
        [view addSubview:self.headView];
        return view;
    }
    else{
//        UIView *view = [[UIView alloc]init];
//        view.backgroundColor = RGB(241, 242, 245);
        
        //        BOOL bottomCellIsHidden; //yes:显示加号。//no:显示添加图片
        
        
        [self.bottombackGroundV removeAllSubViews];
        
//        [view addSubview:self.bottombackGroundV];
        
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
        return self.bottombackGroundV;
    }
    
    return [[UITableViewHeaderFooterView alloc]init];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
//    if (section==1) {
//        UIView *view = [[UIView alloc]init];
//        view.backgroundColor = RGB(241, 242, 245);
//        //        view.backgroundColor = Red_Color;
//
//        //        BOOL bottomCellIsHidden; //yes:显示加号。//no:显示添加图片
//
//
//        [self.bottombackGroundV removeAllSubViews];
//
//        [view addSubview:self.bottombackGroundV];
//
//        [self.bottombackGroundV addSubview:self.bottomaddBtn];
//        [self.bottombackGroundV addSubview:self.hiddenV];
//        [self.hiddenV addSubview:self.addTextBtn];
//        [self.hiddenV addSubview:self.addPhotoBtn];
//        [self.hiddenV addSubview:self.addVideoBtn];
//        if (bottomCellIsHidden) {
//            self.bottomaddBtn.hidden = NO;
//            self.hiddenV.hidden = YES;
//            self.bottombackGroundV.frame = CGRectMake(0,0,kSCREEN_WIDTH,25);
//        }
//        else{
//            self.bottomaddBtn.hidden = YES;
//            self.hiddenV.hidden = NO;
//            self.bottombackGroundV.frame = CGRectMake(0,0,kSCREEN_WIDTH,40);
//        }
//
//        return view;
//    }
    return [[UITableViewHeaderFooterView alloc]init];

    
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 385;
    }
    else{
        CGFloat temH = 0;
        if (bottomCellIsHidden) {
            temH = 30;
        }
        else{
            temH = 40;
        }
        return temH;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
//        return 150;
    NSString *cellHkey = [NSString stringWithFormat:@"%ld",indexPath.row];
    CGFloat cellH = [[self.MidCellHDict objectForKey:cellHkey] floatValue];
    return cellH;
    }
    
    else{
        if (isHaveVR) {
            return 125;
        }
        else{
            return 50;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==0) {
//        DesignCaseListHeadCell *cell = [DesignCaseListHeadCell cellWithTableView:tableView];
//        cell.delegate = self;
//        cell.titleIsShow = YES;
//        [cell configWith:@"" titleTwo:@"" coverImg:self.coverImgUrl songName:self.musicName];
//        return cell;
//    }
//    else{
    
    if (indexPath.section==0) {
        DesignCaseListMidCell *cell = [DesignCaseListMidCell cellWithTableView:tableView path:indexPath];
        cell.delegate = self;
        NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        NSInteger temInt = [[hiddenStateDict objectForKey:key] integerValue];
        id data = self.dataArray[indexPath.row];
        if (temInt==1) {
            [cell configWith:YES data:data isHaveDefaultLogo:!isHaveDefaultLogo];
        }
        else{
            [cell configWith:NO data:data isHaveDefaultLogo:!isHaveDefaultLogo];
        }
        NSString *cellHkey = [NSString stringWithFormat:@"%ld",indexPath.row];
        [self.MidCellHDict setObject:@(cell.cellH) forKey:cellHkey];
        if (indexPath.row==0) {
            cell.moveUpBtn.hidden = YES;
        }
        else{
            cell.moveUpBtn.hidden = NO;
        }
        NSInteger count = self.dataArray.count;
        if (indexPath.row==(count-1)) {
            cell.moveDownBtn.hidden = YES;
        }
        else{
            cell.moveDownBtn.hidden = NO;
        }
        
        return cell;
    }
    else{
        VrCommenCell *cell = [VrCommenCell cellWithTableView:tableView indexpath:indexPath];
        cell.delegate = self;
        [cell configCrib:self.nameStr imgStr:self.coverImgStr isHaveVR:isHaveVR];
        return cell;
    }
    
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==1) {
        [self addToVR];
    }
    
}

#pragma mark - action

-(void)back{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否退出编辑？"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = 200;
    
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==200) {
        if (buttonIndex==1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    if (alertView.tag==300) {
        if (buttonIndex==1) {
            isHaveVR = NO;
            self.coverImgStr = @"";
            self.nameStr = @"";
            self.linkUrl = @"";
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [UIView animateWithDuration:0 animations:^{
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
    }
    
}

-(void)successBtnClick:(UIButton *)btn{
    
    NSInteger coverCount = self.coverImgArray.count;
    if (!coverCount) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"至少上传一张封面图" controller:self sleep:1.5];
        return;
    }
    
    self.productNameStr = [self.productNameStr ew_removeSpaces];
    if (self.productNameStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"名称不能为空" controller:self sleep:1.5];
        return;
    }
    
    self.productPriceStr = [self.productPriceStr ew_removeSpaces];
    if (self.productPriceStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"价格不能为空" controller:self sleep:1.5];
        return;
    }
    
    
    [self pushData];
}



#pragma mark - action

#pragma mark - 新增或编辑礼品

-(void)pushData{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"gift/save.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    if (!self.giftId||self.giftId.length<=0) {
        self.giftId = @"0";
    }
    NSString *faceImg = self.coverImgArray.firstObject;
    NSString *displayImg = [self.coverImgArray componentsJoinedByString:@","];
    
    
    
    
    NSMutableArray *noDataArray = [NSMutableArray array];
    for (DesignCaseListModel *model in self.dataArray) {
        model.content = [model.content ew_removeSpacesAndLineBreaks];
        if ((model.imgUrl.length<=0&&model.videoUrl.length<=0)&&model.content.length<=0) {
            [noDataArray addObject:model];
        }
    }
    if (noDataArray.count>0) {
        [self.dataArray removeObjectsInArray:noDataArray];
    }
//    if (self.dataArray.count<=0) {
//        [[PublicTool defaultTool] publicToolsHUDStr:@"至少要有一项有内容" controller:self sleep:2.0];
//        return;
//    }
//
    //detail
    NSMutableArray *detailsArray = [NSMutableArray array];
    
        NSInteger arrayCount = self.dataArray.count;
    if (self.dataArray.count>0) {
        for (int i = 0; i<arrayCount; i++) {
            DesignCaseListModel *model = self.dataArray[i];
            NSMutableDictionary *temDetailDict = [NSMutableDictionary dictionary];
            [temDetailDict setObject:model.content forKey:@"content"];
            [temDetailDict setObject:model.imgUrl forKey:@"imgUrl"];
            [temDetailDict setObject:model.videoUrl?model.videoUrl:@"" forKey:@"mvUrl"];
            //            [temDetailDict setObject:@(i) forKey:@"sort"];
            
            [detailsArray addObject:temDetailDict];
        }
    }
    
    
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:detailsArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    constructionStr2 = [constructionStr2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    //礼品参数
    NSString *productParamStr;
    if (self.paramArray.count<=0) {
        productParamStr = @"[{\"standardName\":\"\",\"standardContent\":\"\"}]";
    }
    else{
        productParamStr = [self standardPara];
    }
    
    NSDictionary *paramDic = @{@"giftId":self.giftId,
                               @"price":self.productPriceStr.length>0?self.productPriceStr:@"",
                               @"giftName":self.productNameStr.length>0?self.productNameStr:@"",
                               @"params":productParamStr,
                               @"musicUrl":self.musicUrl.length>0?self.musicUrl:@"",
                               @"musicName":self.musicName.length>0?self.musicName:@"",
                               @"musicAutoplay":@(self.musicStyle),
                               @"videoUrl":self.videoUrl.length>0?self.videoUrl:@"",
                               @"videoImg":self.videoImgUrl.length>0?self.videoImgUrl:@"",
                               @"viewUrl":self.linkUrl.length>0?self.linkUrl:@"",
                               @"viewImg":self.coverImgStr.length>0?self.coverImgStr:@"",
                               @"viewName":self.nameStr.length>0?self.nameStr:@"",
                               @"companyId":self.companyId.length>0?self.companyId:@"",
                               @"displayImg":displayImg,
                               @"faceImg":faceImg,
                               @"details":constructionStr2
//                               @"musicUrl":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"创建成功" controller:self sleep:1.5];
                if (self.block) {
                    self.block();
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
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 上传音乐
-(void)uploadMusicBtnClick:(UIButton *)btn{
    LocalMusicController *vc = [[LocalMusicController alloc]init];
    vc.musicUrl = self.musicUrl;
    vc.songName = self.musicName;
    __weak typeof (self) wself = self;
    vc.localMusicBlock = ^(NSString *musicUrl, NSString *songName) {
        wself.musicUrl = musicUrl;
        wself.musicName = songName;
        
        [wself.upLoadMusicBtn setTitle:wself.musicName forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 上传视频

-(void)editCoverBtnClick:(UIButton *)btn{
    
    addVideoType = 1;
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"选择图片" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 delegate:nil];
        __weak typeof (self) weakSelf = self;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
            
            [NSObject uploadImgWith:photos completion:^(NSArray *imageURLArray) {
                YSNLog(@"%@", imageURLArray);
                [weakSelf.bannerImgArray removeAllObjects];
                
                
                if (weakSelf.videoImgUrl&&weakSelf.videoImgUrl.length>0) {
                    [weakSelf.bannerImgArray addObject:weakSelf.videoImgUrl];
//                    weakSelf.deleteBtn.hidden = NO;
                }
                else{
//                    weakSelf.deleteBtn.hidden = YES;
                }
                
                [weakSelf.coverImgArray removeAllObjects];
                [weakSelf.coverImgArray addObjectsFromArray:imageURLArray];
                [weakSelf.bannerImgArray addObjectsFromArray:weakSelf.coverImgArray];
            
                //                weakSelf.adScrollView.localizationImageNamesGroup = photos;
                weakSelf.adScrollView.imageURLStringsGroup = weakSelf.bannerImgArray;
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
        [picker dismissViewControllerAnimated:YES completion:^{}];
    }
    
    
}

//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
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
    
    
    if (bottomCellIsHidden) {
        return;
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

-(void)VRGes:(UITapGestureRecognizer *)ges{
    bottomCellIsHidden = YES;
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
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
        
        isHaveVR = YES;
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)addtextToBottom{
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
    
    ActivityChangeMainTitleController *vc = [[ActivityChangeMainTitleController alloc]init];
    __weak typeof (self) wself = self;
    vc.strBlock = ^(NSString *str) {
        DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
        model.imgUrl = @"";
        model.content = str;
        model.videoUrl = @"";
        
        
        [self.dataArray addObject:model];
        
        [hiddenStateDict removeAllObjects];
        NSString *key = [NSString stringWithFormat:@"%lu",self.dataArray.count-1];
        [hiddenStateDict setObject:@(1) forKey:key];
        
        //一个section刷新
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    };
    vc.content = @"";
    vc.tag = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addPhotosToBottom{
    isHaveDefaultLogo = YES;
    
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
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        //        [self uploadImgWith:photos type:4];
        
        SetwWatermarkController *vc = [[SetwWatermarkController alloc]init];
        vc.fromTag = 9;
        vc.editTag = 4;
        vc.imgArray = photos;
        vc.companyName = @"";
        vc.comanyLogoStr = @"";
        
        vc.setWaterBlock = ^(NSMutableArray *dataArray, NSInteger a) {
            [self replaceDataWith:dataArray type:a];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
    
}

-(void)addVideoToBottom{
    
    addVideoType = 2;
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
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
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
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    
    
    
    //    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

-(void)addTextCell:(NSIndexPath *)path{
    
    [self relaodHiddenDict];
    
    ActivityChangeMainTitleController *vc = [[ActivityChangeMainTitleController alloc]init];
    __weak typeof (self) wself = self;
    vc.strBlock = ^(NSString *str) {
        DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
        model.imgUrl = @"";
        model.content = str;
        model.videoUrl = @"";
        
        
        [self.dataArray insertObject:model atIndex:path.row];
        
        
        [self relaodHiddenDict];
    };
    vc.content = @"";
    vc.tag = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addPhotoCell:(NSIndexPath *)path{
    
    isHaveDefaultLogo = YES;
    [self relaodHiddenDict];
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        addPath = path;
        //        [self uploadImgWith:photos type:3];
        
        SetwWatermarkController *vc = [[SetwWatermarkController alloc]init];
        vc.fromTag = 9;
        vc.editTag = 3;
        vc.imgArray = photos;
        vc.companyName = @"";
        vc.comanyLogoStr = @"";
        
        vc.setWaterBlock = ^(NSMutableArray *dataArray, NSInteger a) {
            [self replaceDataWith:dataArray type:a];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

-(void)addVideoCell:(NSIndexPath *)path{
    
    addVideoType = 2;
    isHaveDefaultLogo = NO;
    bottomCellIsHidden = YES;
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
    addVidelTag = path.row;
    [self upLoadVideo];
}

-(void)changePhotoCell:(NSIndexPath *)path{
    
    [self relaodHiddenDict];
    DesignCaseListModel *model = self.dataArray[path.row];
    if ((model.videoUrl&&model.videoUrl.length>0)||(model.currencyUrl&&model.currencyUrl.length>0)) {
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
            
            
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
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
            vc.fromTag = 9;
            vc.editTag = 2;
            vc.imgArray = photos;
            vc.companyName = @"";
            vc.comanyLogoStr = @"";
            
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
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
}

-(void)editTextCell:(NSIndexPath *)path{
    [self relaodHiddenDict];
    ActivityChangeMainTitleController *vc = [[ActivityChangeMainTitleController alloc]init];
    __weak typeof (self) wself = self;
    vc.strBlock = ^(NSString *str) {
        DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
        model.content = str;
        
        
        [self.dataArray replaceObjectAtIndex:path.row withObject:model];
        
        [hiddenStateDict removeAllObjects];
        NSString *key = [NSString stringWithFormat:@"%lu",self.dataArray.count-1];
        [hiddenStateDict setObject:@(1) forKey:key];
        
        //一个section刷新
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    };
    DesignCaseListModel *model = self.dataArray[path.row];
    vc.content = model.content;
    vc.tag = 1;
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
    DesignCaseListMidCell *cellTwo = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:path.row - 1 inSection:0]];
    
    CGRect rectTwo = [cellTwo convertRect:cellTwo.bounds toView:self.tableView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        cell.frame = rectTwo;
        cellTwo.frame = rect;
    } completion:^(BOOL finished) {
        [self.dataArray exchangeObjectAtIndex:path.row withObjectAtIndex:path.row-1];
        [UIView animateWithDuration:0 animations:^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }];
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
    DesignCaseListMidCell *cellTwo = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:path.row + 1 inSection:0]];
    
    CGRect rectTwo = [cellTwo convertRect:cellTwo.bounds toView:self.tableView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        cell.frame = rectTwo;
        cellTwo.frame = rect;
    } completion:^(BOOL finished) {
        [self.dataArray exchangeObjectAtIndex:path.row withObjectAtIndex:path.row+1];
        //        [self.tableView reloadData];
        [UIView animateWithDuration:0 animations:^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }];
    }];
    
}


#pragma mark - 改变隐藏状态
-(void)relaodHiddenDict{
    bottomCellIsHidden = YES;
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - 添加全景
-(void)addToVR{
    bottomCellIsHidden = YES;
    
    AddDesignFullLook *vc = [[AddDesignFullLook alloc]init];
    vc.coverImgStr = self.coverImgStr;
    vc.nameStr = self.nameStr;
    vc.linkUrl = self.linkUrl;
    vc.FullBlock = ^(NSString *coverImgStr, NSString *nameStr, NSString *linkUrl) {
        self.coverImgStr = coverImgStr;
        self.nameStr = nameStr;
        self.linkUrl = linkUrl;
        
        isHaveVR = YES;
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - textFieldDelegate

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 1){
        
        YSNLog(@"产品参数");
        
        EditGoodsParameterViewController *vc = [EditGoodsParameterViewController new];
        vc.defaultTitleArray = @[@"礼品品牌", @"型号"];
        vc.topTitle = @"礼品参数";
        [self.paramArray enumerateObjectsUsingBlock:^(GoodsParamterModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.name == nil || [obj.name isEqualToString:@""]) {
                [self.paramArray removeObject:obj];
            }
        }];
        vc.listArray = [self.paramArray mutableCopy];
        vc.completeBlock = ^(NSArray *listArray) {
            [self.paramArray removeAllObjects];
            [self.paramArray addObjectsFromArray:listArray];
            textField.text = ((GoodsParamterModel*)listArray.firstObject).name;
        };
        [self.navigationController pushViewController:vc animated:YES];
        
        return NO;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSInteger tag = textField.tag;
    if (tag==0) {
        self.productNameStr = textField.text;
    }
    else if (tag==1){
        self.productParamStr = textField.text;
        
        
    }
    else{
        self.productPriceStr = textField.text;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger tag = textField.tag;
    if (tag==0) {
        self.productNameStr = textField.text;
    }
    else if (tag==1){
        self.productParamStr = textField.text;
    }
    else{
        self.productPriceStr = textField.text;
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
            
            
            
            //            NSString *imgUrl = [responseObject objectForKey:@"imgUrl"];
            
            NSString *imgUrl = [responseObject objectForKey:@"imgUrl"];
            NSString *viodeUrl = [responseObject objectForKey:@"videoUrl"];
            if (addVideoType==1) {
                
                __weak typeof(self) weakSelf = self;
                weakSelf.videoUrl = viodeUrl;
                weakSelf.videoImgUrl = imgUrl;
                
                
                
                [weakSelf.bannerImgArray removeAllObjects];
                
                if (weakSelf.videoImgUrl&&weakSelf.videoImgUrl.length>0) {
                    [weakSelf.bannerImgArray addObject:weakSelf.videoImgUrl];
                    //                weakSelf.deleteBtn.hidden = NO;
                }
                
                [weakSelf.bannerImgArray addObjectsFromArray:weakSelf.coverImgArray];
                
                weakSelf.adScrollView.imageURLStringsGroup = self.bannerImgArray;
            }
            
            if (addVideoType==2) {
                DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
                model.detailsId = 0;
                model.imgUrl = imgUrl;
                model.videoUrl = viodeUrl;
                model.currencyUrl = @"";
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
                
                
                
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
                [UIView animateWithDuration:0 animations:^{
                    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                }];
            }
            
            
            
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

#pragma mark - 上传视频

-(void)upLoadVideo{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"本地视频" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self selectVideo];
        
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"拍摄视频" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self takeVideo];
        
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertC addAction:action2];
    [alertC addAction:action3];
    [alertC addAction:action4];
    [self presentViewController:alertC animated:YES completion:nil];
    
    
//    AddVideoLinkViewController *vc = [[AddVideoLinkViewController alloc]init];
//
//    vc.AddLinkCompletionBlock = ^(NSString *coverImgStr, UIImage *coverImg, NSString *linkUrl, NSString *unionURL) {
//        DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
//        model.detailsId = 0;
//        model.imgUrl = coverImgStr;
//        model.videoUrl = linkUrl;
//        model.currencyUrl = unionURL;
//        model.content = @"";
//        model.htmlContent = @"";
//        if (addVidelTag==-1) {
//            [self.dataArray addObject:model];
//        }
//        else{
//            [self.dataArray insertObject:model atIndex:addVidelTag];
//        }
//        bottomCellIsHidden = YES;
//        [hiddenStateDict removeAllObjects];
//        NSInteger count = self.dataArray.count;
//        for (int i = 0; i<count; i++) {
//            NSString *key = [NSString stringWithFormat:@"%d",i];
//            [hiddenStateDict setObject:@(1) forKey:key];
//        }
//
//
//
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
//        [UIView animateWithDuration:0 animations:^{
//            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
//        }];
//    };
//    [self.navigationController pushViewController:vc animated:YES];
    
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
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
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
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
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
        
        //        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        //        [UIView animateWithDuration:0 animations:^{
        //            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        //        }];
        [self.tableView reloadData];
    }
}

- (NSString *)standardPara {
    NSMutableDictionary *multiDict = [NSMutableDictionary dictionary];
    NSMutableString *paramString = [NSMutableString string];
    [paramString appendString:@"["];
    
    for (int i = 0; i < self.paramArray.count; i ++) {
        GoodsParamterModel *model = self.paramArray[i];
        if (model.name == nil) {
            model.name = @"";
        }
        if (model.describ == nil) {
            model.describ = @"";
        }
        [multiDict setObject:model.name forKey:@"standardName"];
        [multiDict setObject:model.describ forKey:@"standardContent"];
        
        NSString *dictStr = [self dictionaryToJson:multiDict];
        [paramString appendString:dictStr];
        if (i != self.paramArray.count - 1) {
            [paramString appendString:@","];
        }
        [multiDict removeAllObjects];
    }
    
    [paramString appendString:@"]"];
    return paramString;
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - lazy

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


-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 385)];
        _headView.backgroundColor = RGB(241, 242, 245);
        self.adScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 265) delegate:self placeholderImage:nil];
        self.adScrollView.autoScroll = NO;
        self.adScrollView.showPageControl = YES;
        self.adScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        self.adScrollView.backgroundColor = Black_Color;
        
//        UIImage *img = [UIImage imageNamed:DEFAULTLOGO];
//        self.adScrollView.imageURLStringsGroup = @[img];

        [_headView addSubview:self.adScrollView];
        
        
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
        [self.headView addSubview:self.upLoadMusicBtn];

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
        [self.headView addSubview:self.editCoverBtn];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.adScrollView.bottom, self.headView.width, 120)];
        [self.headView addSubview:view];
        NSArray *leftArray = @[@"礼品名称",@"礼品参数",@"市场参考价"];
                NSArray *rightArray = @[@"请输入礼品名称／型号(必填项)",@"",@"请输入价格(必填项)"];
                for (int i = 0; i<leftArray.count; i++) {
                    UILabel *LogoName = [[UILabel alloc]initWithFrame:CGRectMake(15, 40*i, 80, 40)];
                    LogoName.text = leftArray[i];
                    LogoName.textColor = COLOR_BLACK_CLASS_3;
                    LogoName.font = NB_FONTSEIZ_NOR;
                    LogoName.textAlignment = NSTextAlignmentLeft;
                    [view addSubview:LogoName];
        
                    UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(LogoName.right+10, LogoName.top, kSCREEN_WIDTH-LogoName.right-20, LogoName.height)];
                    textF.delegate = self;
                    textF.tag = i;
                    textF.textColor = COLOR_BLACK_CLASS_3;
                    textF.placeholder = rightArray[i];
                    textF.font = NB_FONTSEIZ_NOR;
                    [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
                    [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
                    [view addSubview:textF];
        
        
                    if (i==0) {
                        textF.text = self.productNameStr;
                    }
                    else if (i==1){
                        textF.text = self.productParamStr;
                    }
                    else{
                        textF.text = self.productPriceStr;
                        textF.keyboardType = UIKeyboardTypeNumberPad;
                    }
        
                    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0,LogoName.bottom-0.5, kSCREEN_WIDTH, 0.5)];
                    lineV.backgroundColor = kSepLineColor;
                    [view addSubview:lineV];
                }
        
    }
    return _headView;
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
        _bottomaddBtn.frame = CGRectMake(kSCREEN_WIDTH/2-13, 7, 26, 15);
        //        _addBtn.backgroundColor = Red_Color;
        [_bottomaddBtn setImage:[UIImage imageNamed:@"edit_insert_normal"] forState:UIControlStateNormal];
        [_bottomaddBtn addTarget:self action:@selector(bottomaddBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomaddBtn;
}

-(UIView *)hiddenV{
    if (!_hiddenV) {
        //        _hiddenV = [[UIView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-54*3/2, 5, 54*3, 30)];
        
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



@end
