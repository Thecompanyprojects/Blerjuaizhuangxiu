//
//  GoodsEditViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsEditViewController.h"
#import "SDCycleScrollView.h"
#import "LocalMusicController.h"
#import "TZImagePickerController.h"
#import "GoodsEditTopSubView.h"
#import "GoodsEditCell.h"
#import "EditTextViewController.h"
#import "GoodsEditModel.h"
#import "BatchMangerMoveToGroupViewController.h"
#import "ClassifyModel.h"
#import "AddDesignFullLook.h"
#import "ASProgressPopUpView.h"
#import "EditGoodsParameterViewController.h"
#import "NewEditGoodsParameterViewController.h"
#import "GoodsParamterModel.h"
#import "AddVideoLinkViewController.h"
#import "EditGoodsPriceViewController.h"
#import "GoodsPriceModel.h"
#import "SSPopup.h"
#import "ZCHPublicWebViewController.h"

@interface GoodsEditViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, UITextFieldDelegate, GoodsEditCellDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, ASProgressPopUpViewDataSource> {
    BOOL bottomCellIsHidden; //yes:显示加号。//no:显示添加图片
    NSMutableDictionary *hiddenStateDict; //
    BOOL isHaveVR; //no:没有全景 yes：有全景

    NSInteger upTag;//1:选取本地视频上传。2:拍摄视频上传
     NSString *_videoPath; // 拍摄的视频 存入沙盒地址
}

@property (nonatomic, strong) NSMutableDictionary *MidCellHDict;//


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic ,strong) UIView *headerView;
@property (nonatomic, strong) SDCycleScrollView *adScrollView;
@property (nonatomic, strong) UIButton *addMusicBtn;

@property (nonatomic, strong) NSString *detailVideoURL; // 详情的视频地址  详情中只有一个视频
@property (nonatomic, assign) BOOL isDetailVideo; // 是否是详情选择视频
@property (nonatomic, assign) BOOL isLastVideo; // 上传时是否是最后一个
@property (nonatomic, strong) NSIndexPath *videoIndexP; // 详情视频在第几个index
@property (nonatomic, strong) GoodsEditModel *videoModel; // 详情视频的model

@property (nonatomic, strong) UILabel *adFlagLabel;





//上传视频的进度条
@property (nonatomic, strong) ASProgressPopUpView *progress;
@property (nonatomic, strong) UIView *backShadowV;


// 最后一个加号
@property (nonatomic, strong) UIView *sectionFooterView;
@property (nonatomic, strong) UIView *bottombackGroundV;
@property (nonatomic, strong) UIButton *bottomaddBtn;

@property (nonatomic, strong) UIView *VRview;//添加VR
@property (nonatomic, strong) UIButton *VRBtn;
@property (nonatomic, strong) UILabel *VRLabel;

@property (nonatomic, strong) UILabel *VRTitleL;//全景描述
@property (nonatomic, strong) UIButton *VRdeleteBtn;
@property (nonatomic, strong) UIImageView *VRPlacholdV;//全景的默认占位图


@property (nonatomic, strong) UIView *hiddenV;//隐藏或显示的view
@property (nonatomic, strong) UIButton *addTextBtn;
@property (nonatomic, strong) UIButton *addPhotoBtn;
@property (nonatomic, strong) UIButton *addVideoBtn;

@property (nonatomic, strong) UIView *bottomMusicStyleV;//底部音乐播放模式选择
@property (nonatomic, strong) UILabel *musicLeftL;
@property (nonatomic, strong) UILabel *musicRightL;
@property (nonatomic, strong) UIImageView *bottomRow;

@property (nonatomic, strong) UIImageView *delegeVidoIV;

@end

@implementation GoodsEditViewController
#pragma mark - LifeMethod

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    [self addSuspendedButton];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品编辑";

    self.adImageArray = [NSMutableArray array];
    
    
    NSInteger count = self.dataArray.count;
    hiddenStateDict = [NSMutableDictionary dictionary];
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    

    [self setupUI];
    
    if (_isFromDetail) {
        if (self.musicName == nil || [self.musicName isEqualToString:@""]) {
            [self.addMusicBtn setTitle:@"添加音乐" forState:UIControlStateNormal];
        } else {
            [self.addMusicBtn setTitle:self.musicName forState:UIControlStateNormal];
        }

        NSMutableArray *scrollImageArr = [NSMutableArray arrayWithArray:[self.adImgURLArray copy]];
        if (self.videoImageUrl!= nil && self.videoImageUrl.length>0) {
            [scrollImageArr insertObject:self.videoImageUrl atIndex:0];
        }
        
        self.adScrollView.imageURLStringsGroup = scrollImageArr;
        self.adFlagLabel.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)scrollImageArr.count];
        
        
        
        
        GoodsEditTopSubView *topSubView = [self.headerView viewWithTag:1000 + 0];
        topSubView.textField.text = self.goodsName;
        // 补充说明
        GoodsEditTopSubView *topSubView2 = [self.headerView viewWithTag:1000 + 1];
        topSubView2.textField.text = self.moreExplain;
        //价格
        GoodsEditTopSubView *topSubView3 = [self.headerView viewWithTag:1000 + 2];
        topSubView3.textField.text = self.price;
        //参数
        GoodsEditTopSubView *topSubView4 = [self.headerView viewWithTag:1000 + 3];
        if (self.listArray.count > 0) {
            topSubView4.textField.text = ((GoodsParamterModel*)self.listArray.firstObject).name;
        }
        //服务
        GoodsEditTopSubView *topSubView5 = [self.headerView viewWithTag:1000 + 4];
        if (self.serviceArray.count > 0) {
            topSubView5.textField.text = ((GoodsParamterModel*)self.serviceArray.firstObject).name;
        }
        // 分组
        GoodsEditTopSubView *topSubView6 = [self.headerView viewWithTag:1000 + 5];
        topSubView6.textField.text = self.classifyModel.categoryName; // 分组
        
        self.VRTitleL.text = self.nameStr;
        [self.VRPlacholdV sd_setImageWithURL:[NSURL URLWithString:self.coverImgStr]];
        bottomCellIsHidden = YES;
        
        
        isHaveVR = self.nameStr.length > 0;
        
        
        for (int i = 0; i < self.dataArray.count; i ++) {
            GoodsEditModel *model = self.dataArray[i];
            if (model.videoUrl.length > 0) {
                self.detailVideoURL = model.videoUrl;
                self.videoModel = model;
                self.videoIndexP = [NSIndexPath indexPathForRow:i inSection:0];
                break;
            }
        }
        
        NSArray *QArray = @[@"点击播放",@"进入页面直接播放"];
        self.musicRightL.text = QArray[self.musicStyle];

    }
    
    
    if (self.videoImageUrl != nil && self.videoImageUrl.length > 0) {
        self.delegeVidoIV.hidden = NO;
    }
}

- (void)setupUI {
    [self headerView];
    [self tableView];
    
    [self.view addSubview:self.bottomMusicStyleV];
    [self.bottomMusicStyleV addSubview:self.musicLeftL];
    [self.bottomMusicStyleV addSubview:self.musicRightL];
    [self.bottomMusicStyleV addSubview:self.bottomRow];
    _musicStyle = _musicStyle > 0 ? _musicStyle : 0;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
    // 设置导航栏最右侧的按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightItemWithTitle:@"保存" target:self action:@selector(saveGoodsAction)];
}

#pragma mark - NormalMethod

- (void)back {
    TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"是否退出编辑？" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self SuspendedButtonDisapper];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)isButtonTouched{
    ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
    VC.titleStr = @"使用说明";
    VC.webUrl = kEditGoodsExplainURL;
    VC.isAddBaseUrl = YES;
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)backAfterSave {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)paramString {
    NSMutableDictionary *multiDict = [NSMutableDictionary dictionary];
    NSMutableString *paramString = [NSMutableString string];
    [paramString appendString:@"["];
    
    for (int i = 0; i < self.dataArray.count; i ++) {
        GoodsEditModel *model = self.dataArray[i];
        // "content":"","imgUrl":
        if (model.contentText == nil) {
            model.contentText = @"";
        }
        if (model.imgUrl == nil) {
            model.imgUrl = @"";
        }
        if (model.videoUrl == nil) {
            model.videoUrl = @"";
        }
        [multiDict setObject:model.contentText forKey:@"content"];
        [multiDict setObject:model.imgUrl forKey:@"imgUrl"];
        [multiDict setObject:model.videoUrl forKey:@"mvUrl"];
        
        NSString *dictStr = [self dictionaryToJson:multiDict];
        [paramString appendString:dictStr];
        if (i != self.dataArray.count - 1) {
            [paramString appendString:@","];
        }
        [multiDict removeAllObjects];
    }
    
    [paramString appendString:@"]"];
    return paramString;
}

- (NSString *)standardPara {
    NSMutableDictionary *multiDict = [NSMutableDictionary dictionary];
    NSMutableString *paramString = [NSMutableString string];
    [paramString appendString:@"["];
    
    for (int i = 0; i < self.listArray.count; i ++) {
        GoodsParamterModel *model = self.listArray[i];
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
        if (i != self.listArray.count - 1) {
            [paramString appendString:@","];
        }
        [multiDict removeAllObjects];
    }
    
    [paramString appendString:@"]"];
    return paramString;
}

- (NSString *)servicePara {
    NSMutableDictionary *multiDict = [NSMutableDictionary dictionary];
    NSMutableString *paramString = [NSMutableString string];
    [paramString appendString:@"["];
    
    for (int i = 0; i < self.serviceArray.count; i ++) {
        GoodsParamterModel *model = self.serviceArray[i];
        if (model.name == nil) {
            model.name = @"";
        }
        if (model.describ == nil) {
            model.describ = @"";
        }
        [multiDict setObject:model.name forKey:@"serviceName"];
        [multiDict setObject:model.describ forKey:@"serviceContent"];
        
        NSString *dictStr = [self dictionaryToJson:multiDict];
        [paramString appendString:dictStr];
        if (i != self.serviceArray.count - 1) {
            [paramString appendString:@","];
        }
        [multiDict removeAllObjects];
    }
    
    [paramString appendString:@"]"];
    return paramString;
}

- (NSString *)pricePara {
    NSMutableDictionary *multiDict = [NSMutableDictionary dictionary];
    NSMutableString *paramString = [NSMutableString string];
    [paramString appendString:@"["];
 /*
  /名称
  @property (nonatomic, strong) NSString *name;
  //单位
  @property (nonatomic, strong) NSString *unit;
  //价格
  @property (nonatomic, strong) NSString *price;
  //库存
  @property (nonatomic, strong) NSString *num;
  //图片
  @property (nonatomic, strong) UIImage *image;
  //图片地址
  @property (nonatomic, strong) NSString *imageURL;
  */
    for (int i = 0; i < self.priceArray.count; i ++) {
        GoodsPriceModel *model = self.priceArray[i];
        if (model.name == nil) {
            model.name = @"";
        }
        if (model.price == nil) {
            model.price = @"";
        }
        if (model.unit == nil) {
            model.unit= @"";
        }
        if (model.num == nil) {
            model.num = @"";
        }
        if (model.imageURL == nil) {
            model.imageURL = @"";
        }
        [multiDict setObject:model.name forKey:@"typeName"];
        [multiDict setObject:model.price forKey:@"typePrice"];
        [multiDict setObject:model.unit forKey:@"typeUnit"];
        [multiDict setObject:model.num forKey:@"typeSum"];
        [multiDict setObject:model.imageURL forKey:@"typeDisplay"];
        
        NSString *dictStr = [self dictionaryToJson:multiDict];
        [paramString appendString:dictStr];
        if (i != self.priceArray.count - 1) {
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

- (NSString *)toJSONStringFromArray:(NSArray *)array {
    NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                   options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                     error:nil];
    if (data == nil) {
        return nil;
    }
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

// 保存
- (void)saveGoodsAction {
    if (self.adImgURLArray.count == 0) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请添加封面图"];
        return;
    }
    if (self.goodsName.length == 0 || self.goodsName == nil) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请添输入商品名称"];
        return;
    }

    if (self.priceArray.count == 0) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请添商品价格"];
        return;
    }

    [[UIApplication sharedApplication].keyWindow hudShow];
    NSString *paramStr = [self paramString];
    NSString *defaultURL = [BASEURL stringByAppendingString:@"merchandies/save.do"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:@(self.shopId.integerValue) forKey:@"merchantId"];
    [paramDic setObject:self.goodsName forKey:@"name"];

    // 商品参数
    if (self.listArray.count == 0) {
        [paramDic setObject:@"[{\"standardName\":\"\",\"standardContent\":\"\"}]" forKey:@"standard"];
    } else {
        [paramDic setObject:[self standardPara] forKey:@"standard"];
    }
    // 服务承诺
    if (self.serviceArray.count == 0) {
        [paramDic setObject:@"[{\"serviceName\":\"\",\"serviceContent\":\"\"}]" forKey:@"merchandiesService"];
    } else {
        [paramDic setObject:[self servicePara] forKey:@"merchandiesService"];
    }
    // 价格
    if (self.priceArray.count == 0) {
        [paramDic setObject:@"[{\"typeName\":\"\",\"typePrice\":\"\",\"typeUnit\"：\"\",\"typeSum\":\"\",\"typeDisplay\":\"\"}]" forKey:@"priceType"];
    } else {
        [paramDic setObject:[self pricePara] forKey:@"priceType"];
    }
     [paramDic setObject:self.price forKey:@"price"];
    [paramDic setObject:@(self.classifyModel.categoryID) forKey:@"categoryId"]; // 所属类别
    [paramDic setObject:@(2) forKey:@"isDisplay"];
    if (self.musicUrl == nil || self.musicUrl.length == 0) {
        self.musicUrl = @"";
    }
    if (self.musicName == nil || self.musicName.length == 0) {
        self.musicName = @"";
    }
    [paramDic setObject:self.musicUrl forKey:@"musicUrl"];
    [paramDic setObject:self.musicName forKey:@"musicName"];  // 没有加
    // 视频地址
    if (self.videoUrl == nil || self.videoUrl.length == 0) {
        self.videoUrl = @"";
        self.videoImageUrl = @"";
    }
    [paramDic setObject:self.videoUrl forKey:@"videoUrl"];
    // 视频图片的地址
    [paramDic setObject:self.videoImageUrl forKey:@"videoImg"];
    
    // 全景链接
    if (self.linkUrl == nil || self.linkUrl.length == 0) {
        self.linkUrl = @"";
        self.coverImgStr = @"";
        self.nameStr = @"";
    }
    [paramDic setObject:self.linkUrl forKey:@"viewUrl"];
    // 全景图片链接
    [paramDic setObject:self.coverImgStr forKey:@"viewImg"];
    //  全景名字
    [paramDic setObject:self.nameStr forKey:@"viewName"];
    // 封面图
     [paramDic setObject:[self toJSONStringFromArray:self.adImgURLArray] forKey:@"display"];
    
    if (self.dataArray.count == 0) {
        [paramDic setObject:@"[{\n  \"content\" : \"\",\n  \"mvUrl\" : \"\",\n  \"imgUrl\" : \"\"\n}]" forKey:@"listStr"];
    } else {
        [paramDic setObject:paramStr forKey:@"listStr"];
    }
    
    
    [paramDic setObject:self.videoImageUrl.length > 0? self.videoImageUrl: self.adImgURLArray.firstObject forKey:@"faceImg"];
    
    // 简短说明
    if (self.moreExplain == nil) {
        self.moreExplain = @"";
    }
    [paramDic setObject:self.moreExplain forKey:@"cutLine"];
    
    // isCheap 音乐是否自动播放（0：不自动播放，1：自动播放）
    [paramDic setObject:@(self.musicStyle) forKey:@"isCheap"];
    
     MJWeakSelf;
    
    // 编辑商品
    if (self.isFromDetail) {
        // 编辑商品保存走这里
        defaultURL = [BASEURL stringByAppendingString:@"merchandies/update.do"];
        [paramDic setObject:@(self.goodsID) forKey:@"id"];
        [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
            if (code == 1000) {
                [[UIApplication sharedApplication].keyWindow hiddleHud];
                if (weakSelf.EditingCompletionBlock) {
                    weakSelf.EditingCompletionBlock();
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kEditingGoodsCompletionNotificationIdentify object:nil];
                [weakSelf performSelector:@selector(backAfterSave) withObject:nil afterDelay:1.0];
            } else {
                [[UIApplication sharedApplication].keyWindow hiddleHud];
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"保存出错,请检查输入信息"];
            }
        } failed:^(NSString *errorMsg) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"保存出错,请检查输入信息"];
        }];
        return;
    }
    
    // 添加商品
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [weakSelf performSelector:@selector(backAfterSave) withObject:nil afterDelay:1.0];
            if (weakSelf.EditingCompletionBlock) {
                weakSelf.EditingCompletionBlock();
            }
        } else {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"保存出错， 请稍后再试"];
        }
        
        
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
    }];
}

-(void)addMusicAction {
    LocalMusicController *vc = [[LocalMusicController alloc]init];
    vc.musicUrl = self.musicUrl;
    vc.songName = self.musicName;
    __weak typeof (self) wself = self;
    vc.localMusicBlock = ^(NSString *musicUrl, NSString *songName) {
        wself.musicUrl = musicUrl;
        wself.musicName = songName;
        [wself.addMusicBtn setTitle:songName forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
// 删除视频
- (void)deleteTopVideo:(UITapGestureRecognizer *)tapGR {
    YSNLog(@"delete");
    self.videoImageUrl = @"";
    self.videoImag = nil;
    self.videoUrl = @"";
    if (_isFromDetail) {
        self.adScrollView.imageURLStringsGroup = self.adImgURLArray;
        self.adFlagLabel.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)self.adImgURLArray.count];
    } else {
        [self.adImageArray removeObjectAtIndex:0];
        self.adScrollView.localizationImageNamesGroup = @[];
        self.adScrollView.localizationImageNamesGroup =  self.adImageArray;
        self.adFlagLabel.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)self.adImageArray.count];
    }
    self.delegeVidoIV.hidden = YES;
}
// 编辑封面
- (void)addAdImageAction {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"选择图片" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 delegate:nil];
        __weak typeof (self) weakSelf = self;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
            [NSObject uploadImgWith:photos completion:^(NSArray *imageURLArray) {
                YSNLog(@"%@", imageURLArray);
                weakSelf.adImgURLArray = [imageURLArray mutableCopy];
                
                if (_isFromDetail) {
                    NSMutableArray *scrollImageArr = [NSMutableArray arrayWithArray:imageURLArray];
                    if (self.videoImageUrl!= nil && self.videoImageUrl.length>0) {
                        [scrollImageArr insertObject:self.videoImageUrl atIndex:0];
                    }
                    self.adScrollView.imageURLStringsGroup = scrollImageArr;
                    self.adFlagLabel.text = [NSString stringWithFormat:@"1/%ld", scrollImageArr.count];
                } else {
                    [weakSelf.adImageArray removeAllObjects];
                    if (weakSelf.videoImag) {
                        [weakSelf.adImageArray addObject:weakSelf.videoImag];
                    }
                    [weakSelf.adImageArray addObjectsFromArray:photos];
                    weakSelf.adScrollView.localizationImageNamesGroup = @[];
                    weakSelf.adScrollView.localizationImageNamesGroup =  weakSelf.adImageArray;
                    weakSelf.adFlagLabel.text = [NSString stringWithFormat:@"1/%ld", weakSelf.adImageArray.count];
                }
                
                
            }];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"本地视频" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        upTag = 1;
        _isDetailVideo = NO;

        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.videoMaximumDuration = 31;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        NSString *requiredMediaType1 = (NSString *)kUTTypeMovie;
        //    NSString *requiredMediaType1 = @"public.movie";
        imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects:requiredMediaType1, nil];
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"拍摄视频" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        upTag = 2;
        _isDetailVideo = NO;
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoMaximumDuration = 31;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        imagePicker.showsCameraControls = YES;
        //    imagePicker.cameraOverlayView
        NSString *requiredMediaType1 = (NSString *)kUTTypeMovie;
        //    //    NSString *requiredMediaType1 = @"public.movie";
        imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects:requiredMediaType1, nil];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [alertC addAction:action3];
    [alertC addAction:action4];
    [self presentViewController:alertC animated:YES completion:nil];
}


// 添加全景VR
- (void)addVRAction {
    AddDesignFullLook *vc = [[AddDesignFullLook alloc]init];
    vc.coverImgStr = self.coverImgStr;
    vc.nameStr = self.nameStr;
    vc.linkUrl = self.linkUrl;
    vc.FullBlock = ^(NSString *coverImgStr, NSString *nameStr, NSString *linkUrl) {
        self.coverImgStr = coverImgStr;
        self.nameStr = nameStr;
        self.linkUrl = linkUrl;
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 上传视频
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
        // UIImagePickerControllerQualityTypeHigh
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputURL = [NSURL fileURLWithPath:outPath];
        //转换后的格式
        exportSession.outputFileType = AVFileTypeMPEG4;

        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            // 如果导出的状态为完成
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                YSNLog(@"sucess");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progress removeFromSuperview];
                    self.backShadowV.alpha = 0.0f;
                    [self.backShadowV removeAllSubViews];
                    
                    
                    NSData *outData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:outPath]];

                    CGFloat outDataF = outData.length/1024.f/1024.f;
                    YSNLog(@"float%f",outDataF);

                    [self upLoadVideoWith:outData andImage:nil angVideoPath:outPath completion:^(id response) {
                    }];
                    
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
    else{
        //自定义裁剪方式
//        UIImage*image = [self turnImageWithInfo:info];
//        CGSize tempSize = CGSizeMake(kSCREEN_WIDTH, 150);
//        HKImageClipperViewController *clipperVC = [[HKImageClipperViewController alloc]initWithBaseImg:image
//                                                                                         resultImgSize:tempSize clipperType:ClipperTypeImgMove];
//
//        __weak typeof(self)weakSelf = self;
//        clipperVC.cancelClippedHandler = ^(){
//            [picker dismissViewControllerAnimated:YES completion:nil];
//        };
//        clipperVC.successClippedHandler = ^(UIImage *clippedImage){
//            __strong typeof(self)strongSelf = weakSelf;
//
//            NSArray *arr = @[clippedImage];
//            [strongSelf uploadImgWith:arr type:1];
//
//
//            [picker dismissViewControllerAnimated:YES completion:nil];
//        };
//
//        [picker pushViewController:clipperVC animated:YES];
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


#pragma mark - 上传视频和图片
/**
 上传本地视频和图片

 @param videoData 视频Data
 @param image 图片 传nil为本地视频第一张图片
 @param path 本地图片路径
 @param completion 完成回调
 */
-(void)upLoadVideoWith:(NSData*)videoData andImage:(UIImage *)image angVideoPath:(NSString *)path completion:(void(^)(id response))completion{
    //此段代码如果需要修改，可以调整的位置
    //1. 把upload.php改成网站开发人员告知的地址
    //2. 把name改成网站开发人员告知的字段名
    
    // 查询条件
    //    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", idNum, @"idNumber", nil];
    
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"file/uploadViode.do"];
    //    NSString *defaultApi = [BASEURL stringByAppendingString:@"file/uploadFile.do"];
    
    
    
    [self.view addSubview:self.backShadowV];
    [self.view addSubview:self.progress];
    self.backShadowV.alpha = 0.5f;
    self.progress.progress = 0.0;
    
    // 在parameters里存放照片以外的对象
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
        [formData appendPartWithFileData:videoData name:@"file" fileName:fileName mimeType:@"video/quicktime"];
        
        // -------
        UIImage *uploadImage = nil;
        if (image == nil) {
            uploadImage = [NSObject getImageFromLocalVideoPath:path];
        } else {
            uploadImage = image;
        }
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
        
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];//取消之后就删除，以免占用手机硬盘空间（沙盒）
        
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        
        if (code==1000) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"视频上传成功" controller:self sleep:1.5];
            completion(responseObject);
            
            if (_isDetailVideo) {
                // 详情的视频
                self.detailVideoURL = [responseObject objectForKey:@"videoUrl"];
                NSString *imgUrl = [responseObject objectForKey:@"imgUrl"];
                NSString *viodeUrl = [responseObject objectForKey:@"videoUrl"];
                
                UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
                
                
                bottomCellIsHidden = YES;
                GoodsEditModel *model = [GoodsEditModel newModel];
                self.videoModel = model;
                if (image) {
                    model.image = image;
                }
                model.imgUrl = imgUrl;
                model.videoUrl = viodeUrl;
                
                if (_isLastVideo) {
                    [self.dataArray addObject:model];
                } else {
                    [self.dataArray insertObject:model atIndex:self.videoIndexP.row];
                }
                
                [hiddenStateDict removeAllObjects];
                NSInteger count = self.dataArray.count;
                for (int i = 0; i<count; i++) {
                    NSString *key = [NSString stringWithFormat:@"%d",i];
                    [hiddenStateDict setObject:@(1) forKey:key];
                }
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.videoIndexP.section];
                [UIView animateWithDuration:0 animations:^{
                    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                }];
                
                
            } else {
                // 头部的视频
                NSString *imgUrl = [responseObject objectForKey:@"imgUrl"];
                NSString *viodeUrl = [responseObject objectForKey:@"videoUrl"];
                
                
                if (_isFromDetail) {
                    NSMutableArray *scrollImageArr = [NSMutableArray arrayWithArray:self.adImgURLArray];
                    [scrollImageArr insertObject:imgUrl atIndex:0];
                    self.adScrollView.imageURLStringsGroup = scrollImageArr;
                    self.adFlagLabel.text = [NSString stringWithFormat:@"1/%ld", scrollImageArr.count];
                } else {
                    if (self.videoImag != nil && self.adImageArray.count > 0) {
                        [self.adImageArray removeObjectAtIndex:0];
                    }
                    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
                    if (image) {
                        self.videoImag = image;
                        [self.adImageArray insertObject:self.videoImag atIndex:0];
                        
                        self.adScrollView.localizationImageNamesGroup = @[];
                        self.adScrollView.localizationImageNamesGroup = self.adImageArray;
                        self.adFlagLabel.text = [NSString stringWithFormat:@"1/%ld", self.adScrollView.localizationImageNamesGroup.count];
                    }
                }
                
                self.videoUrl = viodeUrl;
                self.videoImageUrl = imgUrl;
                
                self.delegeVidoIV.hidden = NO;
                
            }
        }
        
        //        else if (code==1001){
        //            [[PublicTool defaultTool] publicToolsHUDStr:@"视频上传失败" controller:self sleep:1.5];
        //        }
        //        else if (code==1002){
        //            [[PublicTool defaultTool] publicToolsHUDStr:@"视频图片获取失败" controller:self sleep:1.5];
        //        }
        //        else if (code==1003){
        //            [[PublicTool defaultTool] publicToolsHUDStr:@"视频上传出现错误" controller:self sleep:1.5];
        //        }
        //        else if (code==1004){
        //            [[PublicTool defaultTool] publicToolsHUDStr:@"视频格式不对" controller:self sleep:1.5];
        //        }
        //        else if (code==1005){
        //            [[PublicTool defaultTool] publicToolsHUDStr:@"视频缩略图上传失败" controller:self sleep:1.5];
        //        }
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



#pragma mark - SDCycleScrollViewDelegate
/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    self.adFlagLabel.text = [NSString stringWithFormat:@"%ld/%ld", index + 1, cycleScrollView.localizationImageNamesGroup.count];
    
    if (cycleScrollView.localizationImageNamesGroup.count == 0) {
        NSInteger count = self.adImgURLArray.count;
        if (self.videoImageUrl!= nil && self.videoImageUrl.length > 0) {
            count += 1;
        }
        self.adFlagLabel.text = [NSString stringWithFormat:@"%ld/%ld", index + 1, count];
    }
    
    
    if (index == 0) {
        if (self.videoImageUrl != nil && self.videoImageUrl.length > 0) {
            self.delegeVidoIV.hidden = NO;
        } else {
            self.delegeVidoIV.hidden = YES;
        }
    } else {
        self.delegeVidoIV.hidden = YES;
    }
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 10001) {
        YSNLog(@"补充说明");
        EditTextViewController *vc = [EditTextViewController new];
        vc.isMoreExplain = YES;
        vc.text = textField.text;
        vc.completeBlock = ^(NSString *text) {
            textField.text = text;
            self.moreExplain = text;
        };
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    if (textField.tag == 10002) {
        YSNLog(@"价格");
        EditGoodsPriceViewController *vc = [EditGoodsPriceViewController new];
        
        vc.priceArray = [self.priceArray mutableCopy];
        
        vc.completeBlock = ^(NSArray *priceArray) {
            [self.priceArray removeAllObjects];
            [self.priceArray addObjectsFromArray:priceArray];
            self.price = @"";
            textField.text = @"";
            if (priceArray.count > 0) {
                GoodsPriceModel *model = priceArray.firstObject;
                self.price = model.price;
                textField.text = model.price;
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    if (textField.tag == 10003) {
        YSNLog(@"产品参数");
        
//        EditGoodsParameterViewController *vc = [EditGoodsParameterViewController new];
//        vc.defaultTitleArray = @[@"商品品牌", @"型号"];
//        vc.topTitle = @"商品参数";
//        vc.isImplementOrGeneralManager = self.implement && (self.agencJob == 1002);
//        vc.isImplementOrGeneralManager = NO;
//        vc.regularArray = [@[@"执行经理", @"总经理",@"执行经理", @"总经理",@"执行经理", @"总经理"] mutableCopy]; // 执行经理或总尽力定义的参数 需要从后台获取数据
//
//        [self.listArray enumerateObjectsUsingBlock:^(GoodsParamterModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.name == nil || [obj.name isEqualToString:@""]) {
//                [self.listArray removeObject:obj];
//            }
//        }];
//        vc.listArray = [self.listArray mutableCopy];
//        vc.completeBlock = ^(NSArray *listArray) {
//            [self.listArray removeAllObjects];
//            [self.listArray addObjectsFromArray:listArray];
//            textField.text = ((GoodsParamterModel*)listArray.firstObject).name;
//        };
//        [self.navigationController pushViewController:vc animated:YES];
        
        NewEditGoodsParameterViewController *vc = [NewEditGoodsParameterViewController new];
        vc.defaultTitleArray = @[@"商品品牌", @"型号"];
        vc.topTitle = @"商品参数";
        vc.isImplementOrGeneralManager = self.implement && (self.agencJob == 1002);
        
        NSMutableArray *regularArray = [@[]mutableCopy]; //  [@[@"执行经理1", @"总经理1",@"执行经理2", @"总经理2"] mutableCopy]; // 执行经理或总尽力定义的参数 需要从后台获取数据
        vc.regularArray = regularArray;
        if (regularArray.count > 0) {
            vc.defaultTitleArray = [regularArray copy];
        }
        
        [self.listArray enumerateObjectsUsingBlock:^(GoodsParamterModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.name == nil || [obj.name isEqualToString:@""]) {
                [self.listArray removeObject:obj];
            }
        }];
        vc.listArray = [self.listArray mutableCopy];
        vc.completeBlock = ^(NSArray *listArray) {
            [self.listArray removeAllObjects];
            [self.listArray addObjectsFromArray:listArray];
            textField.text = ((GoodsParamterModel*)listArray.firstObject).name;
        };
        [self.navigationController pushViewController:vc animated:YES];

        return NO;
    }
    if (textField.tag == 10004) {
        YSNLog(@"服务");
        EditGoodsParameterViewController *vc = [EditGoodsParameterViewController new];
        vc.topTitle = @"服务承诺";
        vc.defaultTitleArray = @[@"免费送货", @"免费安装"];
        [self.serviceArray enumerateObjectsUsingBlock:^(GoodsParamterModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.name == nil || [obj.name isEqualToString:@""]) {
                [self.serviceArray removeObject:obj];
            }
        }];
        vc.listArray = [self.serviceArray mutableCopy];
        vc.completeBlock = ^(NSArray *listArray) {
            [self.serviceArray removeAllObjects];
            [self.serviceArray addObjectsFromArray:listArray];
            textField.text = ((GoodsParamterModel*)listArray.firstObject).name;
        };
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    if (textField.tag == 10005) {
        YSNLog(@"分组");
        BatchMangerMoveToGroupViewController *groupVC = [[BatchMangerMoveToGroupViewController alloc] init];
        groupVC.shopId = self.shopId;
        groupVC.isEditing = YES;
        groupVC.EditingCompleteBlock = ^(ClassifyModel *classifyModel) {
            textField.text = classifyModel.categoryName;
            self.classifyModel = classifyModel;
        };
        [self.navigationController pushViewController:groupVC animated:YES];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 10000) {
        self.goodsName = textField.text;
    }
    if (textField.tag == 10002) {
        self.price = textField.text;
    }
}

// 限制提示文字长度
-(void)nameTextFieldEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage ; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 22) {
                textField.text = [toBeString substringToIndex:22];
                [textField endEditing:YES];
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"单位长度不要超过22字哦！"];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 22) {
            textField.text = [toBeString substringToIndex:22];
            [textField endEditing:YES];
            // 超长保存前30个字
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"单位长度不要超过22字哦！"];
        }
    }
}

#pragma mark - 更换音乐播放模式
-(void)changeMusicStyle{
    
    if (self.musicUrl == nil || [self.musicUrl isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请先选择音乐"];
        return;
    }
    NSArray *QArray = @[@"点击播放", @"进入页面直接播放"];
    
    SSPopup* selection=[[SSPopup alloc]init];
    selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
    
    selection.frame = CGRectMake(0,64,kSCREEN_WIDTH,kSCREEN_HEIGHT-64);
//    selection.SSPopupDelegate=self;
    [self.view addSubview:selection];
    //    self.editBtn.userInteractionEnabled = NO;
    
    [selection CreateTableview:QArray withTitle:@"" setCompletionBlock:^(int tag) {
        self.musicStyle = tag;
        
        self.musicRightL.text = QArray[self.musicStyle];
    }];
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


#pragma mark - GoodsEditCellDelegate
-(void)changeHiddenState:(NSIndexPath *)path {
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
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:(UITableViewRowAnimationFade)];
    }];
}
-(void)changeToHidden:(NSIndexPath *)path {
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
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:path.section];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

-(void)addPhotoCell:(NSIndexPath *)path {
    bottomCellIsHidden = YES;

    
    MJWeakSelf;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        [NSObject uploadImgWith:photos completion:^(NSArray *imageURLArray) {
            
            NSMutableArray *array = [NSMutableArray array];
            for (int i= 0; i < photos.count; i ++) {
                GoodsEditModel *model = [GoodsEditModel newModel];
                model.image = photos[i];
                model.imgUrl = imageURLArray[i];
                model.contentText = @"";
                
                [array addObject:model];
            }
            NSIndexSet *helpIndex = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(path.row, [array count])];
            [weakSelf.dataArray insertObjects:[array copy] atIndexes:helpIndex];
            
            [hiddenStateDict removeAllObjects];
            NSInteger count = weakSelf.dataArray.count;
            for (int i = 0; i<count; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                [hiddenStateDict setObject:@(1) forKey:key];
            }
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:path.section];
            [UIView animateWithDuration:0 animations:^{
                [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        }];
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

-(void)changePhotoCell:(NSIndexPath *)path {
    bottomCellIsHidden = YES;
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    
    GoodsEditModel *model = self.dataArray[path.row];
    
    MJWeakSelf;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        [NSObject uploadImgWith:photos completion:^(NSArray *imageURLArray) {
            UIImage *image = photos[0];
            model.image = image;
            model.imgUrl = imageURLArray[0];
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:path.section];
            [UIView animateWithDuration:0 animations:^{
                [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        }];
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

-(void)editTextCell:(NSIndexPath *)path {
    bottomCellIsHidden = YES;
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:path.section];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    __block GoodsEditModel *model = self.dataArray[path.row];
    MJWeakSelf;
    EditTextViewController *vc = [EditTextViewController new];
    vc.text = model.contentText;
    vc.completeBlock = ^(NSString *text) {
        model.contentText = text;
        [UIView animateWithDuration:0 animations:^{
            [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)addTextCell:(NSIndexPath *)path {

    bottomCellIsHidden = YES;
    GoodsEditModel *model = [GoodsEditModel newModel];
    [self.dataArray insertObject:model atIndex:path.row];
    
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:path.section];
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    
    MJWeakSelf;
    EditTextViewController *vc = [EditTextViewController new];
    vc.completeBlock = ^(NSString *text) {
        GoodsEditModel *model = weakSelf.dataArray[path.row];
        model.contentText = text;
        [UIView animateWithDuration:0 animations:^{
            [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)addVideoCell:(NSIndexPath *)path {
    if ([self.dataArray containsObject:self.videoModel]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"已经上传过视频了， 详情页最多传一个视频"];
        return;
    }
    _isDetailVideo = YES;
    _isLastVideo = NO;
    self.videoIndexP = path;

    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"本地视频" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        upTag = 1;

        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.videoMaximumDuration = 31;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        NSString *requiredMediaType1 = (NSString *)kUTTypeMovie;
        //    NSString *requiredMediaType1 = @"public.movie";
        imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects:requiredMediaType1, nil];
        [self presentViewController:imagePicker animated:YES completion:nil];

    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"拍摄视频" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        upTag = 2;
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoMaximumDuration = 31;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        imagePicker.showsCameraControls = YES;
        //    imagePicker.cameraOverlayView
        NSString *requiredMediaType1 = (NSString *)kUTTypeMovie;
        //    //    NSString *requiredMediaType1 = @"public.movie";
        imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects:requiredMediaType1, nil];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"第三方视频链接" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self addVideoURLActionAtCell:path];
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertC addAction:action2];
    [alertC addAction:action3];
//    [alertC addAction:action4];
    [alertC addAction:action5];
    [self presentViewController:alertC animated:YES completion:nil];
}

// 添加外部视频链接
- (void)addVideoURLActionAtCell:(NSIndexPath *)path {
    
    self.videoIndexP = path;
    MJWeakSelf;
    AddVideoLinkViewController * addVideoVC = [AddVideoLinkViewController new];

    addVideoVC.AddLinkCompletionBlock = ^(NSString *coverImgStr, UIImage *coverImg, NSString *linkUrl, NSString *unionURL) {
        
        // 详情的视频
        weakSelf.detailVideoURL = linkUrl;
        UIImage *image = coverImg;
        
        bottomCellIsHidden = YES;
        GoodsEditModel *model = [GoodsEditModel newModel];
        self.videoModel = model;
        if (image) {
            model.image = image;
        }
        model.imgUrl = coverImgStr;
        model.videoUrl = linkUrl;
        
        [self.dataArray insertObject:model atIndex:self.videoIndexP.row];
        if (_isLastVideo) {
            [self.dataArray addObject:model];
        } else {
            [self.dataArray insertObject:model atIndex:self.videoIndexP.row];
       }
        
        [hiddenStateDict removeAllObjects];
        NSInteger count = self.dataArray.count;
        for (int i = 0; i<count; i++) {
            NSString *key = [NSString stringWithFormat:@"%d",i];
            [hiddenStateDict setObject:@(1) forKey:key];
        }
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.videoIndexP.section];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
        
    };
    [self.navigationController pushViewController:addVideoVC animated:YES];
    
}
-(void)removePhotoCell:(NSIndexPath *)path {
//    if (self.dataArray.count<=1) {
//        [[PublicTool defaultTool] publicToolsHUDStr:@"至少要保留一张图片" controller:self sleep:1.5];
//        return;
//    }
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

-(void)moveCellToUp:(NSIndexPath *)path {
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    GoodsEditCell *cell = [self.tableView cellForRowAtIndexPath:path];
    
    CGRect rect = [cell convertRect:cell.bounds toView:self.tableView];
    GoodsEditCell *cellTwo = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:path.row - 1 inSection:0]];
    
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
-(void)moveCellToDown:(NSIndexPath *)path {
    [hiddenStateDict removeAllObjects];
    NSInteger count = self.dataArray.count;
    for (int i = 0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [hiddenStateDict setObject:@(1) forKey:key];
    }
    
    GoodsEditCell *cell = [self.tableView cellForRowAtIndexPath:path];
    
    CGRect rect = [cell convertRect:cell.bounds toView:self.tableView];
    GoodsEditCell *cellTwo = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:path.row + 1 inSection:0]];
    
    CGRect rectTwo = [cellTwo convertRect:cellTwo.bounds toView:self.tableView];
    

    
    [UIView animateWithDuration:0.25 animations:^{
        
        cell.frame = rectTwo;
        cellTwo.frame = rect;
    } completion:^(BOOL finished) {
        [self.dataArray exchangeObjectAtIndex:path.row withObjectAtIndex:path.row+1];
        [UIView animateWithDuration:0 animations:^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }];
    }];
}


#pragma mark - UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsEditCell *cell = [GoodsEditCell cellWithTableView:tableView path:indexPath];
    cell.delegate = self;
    NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSInteger temInt = [[hiddenStateDict objectForKey:key] integerValue];
    id data = self.dataArray[indexPath.row];
    if (temInt==1) {
        [cell configWith:YES data:data isHaveDefaultLogo:YES];
    }
    else{
        [cell configWith:NO data:data isHaveDefaultLogo:YES];
    }
    NSString *cellHkey = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellHkey = [NSString stringWithFormat:@"%ld",indexPath.row];
    CGFloat cellH = [[self.MidCellHDict objectForKey:cellHkey] floatValue];
    return cellH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        if (bottomCellIsHidden) {
            if (!isHaveVR) {
               return 60+30+80;
            }
            else{
                return 60+30+80+75;
            }
        }
        else{
            if (!isHaveVR) {
                return 75+30+80;
            }
            else{
                return 75+30+80+75;
            }
        }
        
    }
    else{
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section==0) {
        
        
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = RGB(241, 242, 245);
        //        view.backgroundColor = Red_Color;
        
        //        BOOL bottomCellIsHidden; //yes:显示加号。//no:显示添加图片
        //        BOOL isHaveVote; //no:没有投票 //yes:有投票
        
        [self.bottombackGroundV removeAllSubViews];
        [self.VRview removeAllSubViews];
        [view addSubview:self.bottombackGroundV];
        
        [self.bottombackGroundV addSubview:self.bottomaddBtn];
        [self.bottombackGroundV addSubview:self.hiddenV];
        [self.hiddenV addSubview:self.addTextBtn];
        [self.hiddenV addSubview:self.addPhotoBtn];
        [self.hiddenV addSubview:self.addVideoBtn];
        
        
        [self.bottombackGroundV addSubview:self.VRview];
        [self.VRview addSubview:self.VRBtn];
        [self.VRview addSubview:self.VRLabel];
        [self.VRview addSubview:self.VRdeleteBtn];
        [self.VRview addSubview:self.VRPlacholdV];
        [self.VRview addSubview:self.VRTitleL];
        
        
        if (bottomCellIsHidden) {
            self.bottomaddBtn.hidden = NO;
            self.hiddenV.hidden = YES;
            
            {
                
                if (!isHaveVR) {
                    self.VRdeleteBtn.hidden = YES;
                    self.VRPlacholdV.hidden = YES;
                    self.VRTitleL.hidden = YES;
                    
                    self.VRBtn.hidden = NO;
                    self.VRLabel.hidden = NO;
                    
                    
                    self.bottombackGroundV.frame = CGRectMake(0,0,kSCREEN_WIDTH,150+80);
                    self.VRview.frame = CGRectMake(5, self.bottomaddBtn.bottom+5, kSCREEN_WIDTH-10, 50);
                    
                }
                else{
                    self.VRdeleteBtn.hidden = NO;
                    self.VRPlacholdV.hidden = NO;
                    self.VRTitleL.hidden = NO;
                    
                    self.VRBtn.hidden = YES;
                    self.VRLabel.hidden = YES;
                    
                    self.bottombackGroundV.frame = CGRectMake(0,0,kSCREEN_WIDTH,150+80+75);
                    self.VRview.frame = CGRectMake(5, self.bottomaddBtn.bottom+5, kSCREEN_WIDTH-10, 125);
                }
            }
            
        }
        else{
            self.bottomaddBtn.hidden = YES;
            self.hiddenV.hidden = NO;
            
            {
                
                
                
                if (!isHaveVR) {
                    self.VRdeleteBtn.hidden = YES;
                    self.VRPlacholdV.hidden = YES;
                    self.VRTitleL.hidden = YES;
                    
                    self.VRBtn.hidden = NO;
                    self.VRLabel.hidden = NO;
                    
                    self.bottombackGroundV.frame = CGRectMake(0,0,kSCREEN_WIDTH,165+80);
                    self.VRview.frame = CGRectMake(5, self.hiddenV.bottom+5, kSCREEN_WIDTH-10, 50);
                }
                else{
                    self.VRdeleteBtn.hidden = NO;
                    self.VRPlacholdV.hidden = NO;
                    self.VRTitleL.hidden = NO;
                    
                    self.VRBtn.hidden = YES;
                    self.VRLabel.hidden = YES;
                    
                    self.bottombackGroundV.frame = CGRectMake(0,0,kSCREEN_WIDTH,165+80+75);
                    self.VRview.frame = CGRectMake(5, self.hiddenV.bottom+5, kSCREEN_WIDTH-10, 125);
                }
                
            }
            
            
        }
        
        
        self.VRBtn.frame = CGRectMake(self.VRview.width/2-80, self.VRview.height/2-10.5, 30, 21);
        self.VRLabel.frame = CGRectMake(self.VRBtn.right+5, self.VRBtn.top, 120, self.VRBtn.height);
        
        CGFloat widthTwo = self.VRview.height-self.VRdeleteBtn.bottom*2;
        self.VRPlacholdV.frame = CGRectMake(self.VRdeleteBtn.right, self.VRdeleteBtn.bottom, widthTwo, widthTwo);
        self.VRTitleL.frame = CGRectMake(self.VRPlacholdV.right+10,self.VRPlacholdV.top,self.VRview.width-self.VRPlacholdV.right-10,21);
        
        [self.VRPlacholdV sd_setImageWithURL:[NSURL URLWithString:self.coverImgStr] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        self.VRTitleL.text = self.nameStr;
        
        return view;
    } else {
        return [[UITableViewHeaderFooterView alloc]init];
    }
    
}

#pragma mark - 底部添加事件
-(void)bottomaddBtnClick:(UIButton *)btn{
    bottomCellIsHidden = !bottomCellIsHidden;
    
    
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

-(void)backGroundVGes:(UITapGestureRecognizer *)ges{
    
    
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

-(void)addtextToBottom{
    bottomCellIsHidden = YES;
    GoodsEditModel *model = [GoodsEditModel newModel];
    [self.dataArray addObject:model];
    
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
    
    
    MJWeakSelf;
    EditTextViewController *vc = [EditTextViewController new];
    vc.completeBlock = ^(NSString *text) {
        GoodsEditModel *model = [weakSelf.dataArray lastObject];
        model.contentText = text;
        [UIView animateWithDuration:0 animations:^{
            [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addPhotosToBottom{
    bottomCellIsHidden = YES;
    
    
    MJWeakSelf;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        [NSObject uploadImgWith:photos completion:^(NSArray *imageURLArray) {
            
            NSMutableArray *array = [NSMutableArray array];
            for (int i= 0; i < photos.count; i ++) {
                GoodsEditModel *model = [GoodsEditModel newModel];
                model.image = photos[i];
                model.imgUrl = imageURLArray[i];
                model.contentText = @"";
                
                [array addObject:model];
            }
            [weakSelf.dataArray addObjectsFromArray:[array copy]];
            
            [hiddenStateDict removeAllObjects];
            NSInteger count = weakSelf.dataArray.count;
            for (int i = 0; i<count; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                [hiddenStateDict setObject:@(1) forKey:key];
            }
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [UIView animateWithDuration:0 animations:^{
                [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
        }];
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

-(void)addVideoToBottom{
    if ([self.dataArray containsObject:self.videoModel]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"已经上传过视频了， 详情页最多传一个视频"];
        return;
    }
    _isDetailVideo = YES;
    _isLastVideo = YES;
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"本地视频" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        upTag = 1;

        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.videoMaximumDuration = 31;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        NSString *requiredMediaType1 = (NSString *)kUTTypeMovie;
        //    NSString *requiredMediaType1 = @"public.movie";
        imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects:requiredMediaType1, nil];
        [self presentViewController:imagePicker animated:YES completion:nil];

    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"拍摄视频" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        upTag = 2;
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoMaximumDuration = 31;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        imagePicker.showsCameraControls = YES;
        //    imagePicker.cameraOverlayView
        NSString *requiredMediaType1 = (NSString *)kUTTypeMovie;
        //    //    NSString *requiredMediaType1 = @"public.movie";
        imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects:requiredMediaType1, nil];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"第三方视频链接" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        MJWeakSelf;
        AddVideoLinkViewController * addVideoVC = [AddVideoLinkViewController new];
        addVideoVC.AddLinkCompletionBlock = ^(NSString *coverImgStr, UIImage *coverImg, NSString *linkUrl, NSString *unionURL) {
            
            // 详情的视频
            weakSelf.detailVideoURL = linkUrl;
            UIImage *image = coverImg;
            bottomCellIsHidden = YES;
            GoodsEditModel *model = [GoodsEditModel newModel];
            self.videoModel = model;
            if (image) {
                model.image = image;
            }
            model.imgUrl = coverImgStr;
            model.videoUrl = linkUrl;
            
            [self.dataArray addObject:model];
            
            [hiddenStateDict removeAllObjects];
            NSInteger count = self.dataArray.count;
            for (int i = 0; i<count; i++) {
                NSString *key = [NSString stringWithFormat:@"%d",i];
                [hiddenStateDict setObject:@(1) forKey:key];
            }
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.videoIndexP.section];
            [UIView animateWithDuration:0 animations:^{
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            }];
            
        };
        [self.navigationController pushViewController:addVideoVC animated:YES];

    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertC addAction:action2];
    [alertC addAction:action3];
    // 下一行打开可上传视频地址
//    [alertC addAction:action4];
    [alertC addAction:action5];
    [self presentViewController:alertC animated:YES completion:nil];

    
}

-(void)VRGes:(UITapGestureRecognizer *)ges{
    bottomCellIsHidden = self.dataArray.count > 0;;
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

- (void)removeBottomAction {
    
    bottomCellIsHidden = self.dataArray.count > 0;
    isHaveVR = NO;
    self.coverImgStr = @"";
    self.nameStr = @"";
    self.linkUrl = nil;
    
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


#pragma mark - LazyMethod
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableDictionary *)MidCellHDict{
    if (!_MidCellHDict) {
        _MidCellHDict = [NSMutableDictionary dictionary];
    }
    return _MidCellHDict;
}

-(NSMutableArray*)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableArray *)serviceArray {
    if (_serviceArray == nil) {
        _serviceArray = [NSMutableArray array];
    }
    return _serviceArray;
}

- (NSMutableArray *)priceArray {
    if (!_priceArray) {
        _priceArray = [NSMutableArray array];
    }
    return _priceArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
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
        //        _addBtn.backgroundColor = Red_Color;
        [_bottomaddBtn setImage:[UIImage imageNamed:@"edit_insert_normal"] forState:UIControlStateNormal];
        [_bottomaddBtn addTarget:self action:@selector(bottomaddBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomaddBtn;
}

-(UIView *)VRview{
    if (!_VRview) {
        _VRview = [[UIView alloc]initWithFrame:CGRectMake(5, self.bottomaddBtn.bottom+5, kSCREEN_WIDTH-10, 125)];
        _VRview.layer.masksToBounds = YES;
        _VRview.layer.cornerRadius = 10;
        //        _backView.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
        //        _backView.layer.borderWidth = 1.0f;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(VRGes:)];
        //        ges.numberOfTouches = 1;
        _VRview.userInteractionEnabled = YES;
        [_VRview addGestureRecognizer:ges];
        _VRview.backgroundColor = White_Color;
        
    }
    return _VRview;
}

-(UIButton *)VRBtn{
    if (!_VRBtn) {
        _VRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _VRBtn.frame = CGRectMake(self.VRview.width/2-80, self.VRview.height/2-10.5, 30, 21);
        [_VRBtn setTitle:@"VR" forState:UIControlStateNormal];
        [_VRBtn setTitleColor:White_Color forState:UIControlStateNormal];
        _VRBtn.layer.masksToBounds = YES;
        _VRBtn.layer.cornerRadius = 5;
        
        _VRBtn.backgroundColor = COLOR_BLACK_CLASS_3;
        _VRBtn.titleLabel.font = NB_FONTSEIZ_BIG;
    }
    return _VRBtn;
}

-(UILabel *)VRLabel{
    if (!_VRLabel) {
        _VRLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.VRBtn.right+5, self.VRBtn.top, 120, self.VRBtn.height)];
        _VRLabel.textColor = RGB(211, 192, 185);
        _VRLabel.textAlignment = NSTextAlignmentLeft;
        _VRLabel.font = NB_FONTSEIZ_BIG;
        _VRLabel.text = @"添加全景效果图";
    }
    return _VRLabel;
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


-(UIButton *)VRdeleteBtn{
    if (!_VRdeleteBtn) {
        _VRdeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _VRdeleteBtn.frame = CGRectMake(5, 5, 15, 15);
        
        //            _addressBtn.backgroundColor = Red_Color;
        [_VRdeleteBtn setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
        [_VRdeleteBtn addTarget:self action:@selector(removeBottomAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _VRdeleteBtn;
}

-(UIImageView *)VRPlacholdV{
    if (!_VRPlacholdV) {
        CGFloat width = self.VRview.height-self.VRdeleteBtn.bottom*2;
        _VRPlacholdV = [[UIImageView alloc]initWithFrame:CGRectMake(self.VRdeleteBtn.right, self.VRdeleteBtn.bottom, width, width)];
        _VRPlacholdV.image = [UIImage imageNamed:DefaultIcon];
    }
    return _VRPlacholdV;
}

-(UILabel *)VRTitleL{
    if (!_VRTitleL) {
        _VRTitleL = [[UILabel alloc]initWithFrame:CGRectMake(self.VRPlacholdV.right+10,self.VRPlacholdV.top,self.VRview.width-self.VRPlacholdV.right-10,21)];
        _VRTitleL.textColor = COLOR_BLACK_CLASS_3;
        _VRTitleL.font = NB_FONTSEIZ_NOR;
        _VRTitleL.text = @"添加全景";
        _VRTitleL.numberOfLines = 0;
        //        companyJob.backgroundColor = Red_Color;
        _VRTitleL.textAlignment = NSTextAlignmentLeft;
    }
    return _VRTitleL;
}



- (UIView *)headerView {
    if (!_headerView) {
        // 广告图的高
        CGFloat adHeight = kSCREEN_WIDTH*0.6;
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44*6 + adHeight)];
        
        _adScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, adHeight) delegate:self placeholderImage:nil];
        _adScrollView.autoScroll = NO;
        _adScrollView.showPageControl = NO;
        _adScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        _adScrollView.backgroundColor = [UIColor blackColor];
        [_headerView addSubview:_adScrollView];
        UIButton *addMinusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnHeight = 20;
        addMinusicBtn.frame = CGRectMake(8, adHeight-16-16, 80, btnHeight);
        self.addMusicBtn = addMinusicBtn;
        [_adScrollView addSubview:addMinusicBtn];
        addMinusicBtn.backgroundColor = [UIColor whiteColor];
        [addMinusicBtn setTitle:@"添加音乐" forState:(UIControlStateNormal)];
        [addMinusicBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        addMinusicBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        addMinusicBtn.layer.cornerRadius = 4;
        addMinusicBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        addMinusicBtn.layer.borderWidth = 1;
        addMinusicBtn.layer.masksToBounds = YES;
        [addMinusicBtn addTarget:self action:@selector(addMusicAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.adFlagLabel = [UILabel new];
        [_adScrollView addSubview:self.adFlagLabel];
        [self.adFlagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-16);
            make.centerX.equalTo(0);
        }];
        self.adFlagLabel.textColor = [UIColor whiteColor];
        self.adFlagLabel.font = [UIFont systemFontOfSize:14];
        
        UIButton *addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addImageBtn.frame = CGRectMake(kSCREEN_WIDTH - 80 - 8, adHeight - 16-16, 80, btnHeight);
        [_adScrollView addSubview:addImageBtn];
        [addImageBtn setTitle:@"编辑封面" forState:UIControlStateNormal];
        [addImageBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        addImageBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        addImageBtn.layer.cornerRadius = 4;
        addImageBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        addImageBtn.layer.borderWidth = 1;
        addImageBtn.layer.masksToBounds = YES;
        addImageBtn.backgroundColor = [UIColor whiteColor];
        [addImageBtn addTarget:self action:@selector(addAdImageAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *deleteIV = [[UIImageView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH - 38, 8, 30, 30)];
        deleteIV.hidden = YES;
        self.delegeVidoIV = deleteIV;
        [_adScrollView addSubview:deleteIV];
        deleteIV.image = [UIImage imageNamed:@"delete"];
        deleteIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *deleteVideoTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteTopVideo:)];
        [deleteIV addGestureRecognizer:deleteVideoTapGR];
        
        
//        NSArray *nameArray = @[@"产品名称", @"商品参数", @"价        格", @"分        组"];
//        NSArray *textFieldPlaceHolder = @[@"请输入产品名称/型号(必填项)", @"", @"请填写价格(必填项)", @"请选择分组(不选默认为未分类)"];
//        for (int i = 0; i < 4; i ++) {
//            GoodsEditTopSubView *topSubView = [[GoodsEditTopSubView alloc] initWithFrame:CGRectMake(0, adHeight + (i * 44), kSCREEN_WIDTH, 44) type:0];
//            [_headerView addSubview:topSubView];
//            if (i == 0 || i == 2) {
//                topSubView.imageV.hidden = YES;
//            }
//            topSubView.tag = 1000 + i;
//            topSubView.nameLabel.text = nameArray[i];
//            topSubView.textField.placeholder = textFieldPlaceHolder[i];
//            topSubView.textField.delegate = self;
//            topSubView.textField.tag = 10000 + i;
//            if (i == 2) {
//                topSubView.textField.keyboardType = UIKeyboardTypeDecimalPad;
//            }
//        }
        
        NSArray *nameArray = @[@"产品名称", @"补充说明", @"价        格", @"商品参数", @"服        务", @"分        组"];
        NSArray *textFieldPlaceHolder = @[@"请输入产品名称/型号(必填项)", @"请输入补充说明", @"请填写价格(必填项)", @"", @"", @"请选择分组(不选默认为未分类)"];
        for (int i = 0; i < 6; i ++) {
            GoodsEditTopSubView *topSubView = [[GoodsEditTopSubView alloc] initWithFrame:CGRectMake(0, adHeight + (i * 44), kSCREEN_WIDTH, 44) type:0];
            [_headerView addSubview:topSubView];
            if (i == 0 ||i == 1) {
                topSubView.imageV.hidden = YES;
            } else {
                topSubView.imageV.hidden = NO;
            }
            if (i == 0) {
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nameTextFieldEditChanged:)name:@"UITextFieldTextDidChangeNotification"
                                                          object:topSubView.textField];
            }
            topSubView.tag = 1000 + i;
            topSubView.nameLabel.text = nameArray[i];
            topSubView.textField.placeholder = textFieldPlaceHolder[i];
            topSubView.textField.delegate = self;
            topSubView.textField.tag = 10000 + i;
            if (i == 2) {
                topSubView.textField.keyboardType = UIKeyboardTypeDecimalPad;
            }
        }
        
        
    }
    return _headerView;
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
        _musicRightL.text = @"点击播放";
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

@end
