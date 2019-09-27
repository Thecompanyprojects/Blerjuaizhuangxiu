//
//  ProdcutDetailInfoController.m
//  iDecoration
//
//  Created by sty on 2018/3/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ProdcutDetailInfoController.h"

#import "CLPlayerView.h"
#import "SDCycleScrollView.h"
#import "TZImagePickerController.h"
#import "NSObject+CompressImage.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ASProgressPopUpView.h"
#import "ASProgressPopUpView.h"
#import "SSPopup.h"

#import "GoodsParameterView.h"
#import "GoodsParamterModel.h"

#import "ProdcutDetailInfoCell.h"
#import "STYCouponSelectModel.h"
#import "senceWebViewController.h"

@interface ProdcutDetailInfoController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,SDCycleScrollViewDelegate, CLPlayerViewDelegate,GoodsParameterViewDelegate>{
    STYCouponSelectModel *_model;
    
    CGFloat _cellTwoH;//全景vr的高度
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SDCycleScrollView *adScrollView; // 轮播图

@property (nonatomic, weak) CLPlayerView *videoPlayerView; // 视频播放器
@property (nonatomic, weak) CLPlayerView *detailVideoPlayerView; // 详情视频播放器
@property (nonatomic, weak) CLPlayerView *musicPlayerView; // 音乐播放
@property (nonatomic, assign) BOOL isPlayingMusic;//是否正在播放音乐

@property (nonatomic, strong) UIImageView *videoPlayImgV;//视频的播放按钮
@property (nonatomic, strong) UILabel *musicNameL;//音乐名称
@property (nonatomic, strong) UIButton *musicPlayBtn;//音乐的播放按钮

@property (nonatomic, strong) UILabel *productNameL;//产品名称
@property (nonatomic, strong) UILabel *productPriceL;//产品价格

@property (nonatomic, strong) NSMutableArray *dataArray;//
@property (nonatomic, strong) NSMutableDictionary *cellHDict;//详情的高度
@property (nonatomic, strong) NSMutableArray *parameterArray;

// 商品参数
@property (nonatomic, strong) GoodsParameterView *paramererView;

@end

@implementation ProdcutDetailInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"礼品详情";
    
    [self setUI];
    [self getData];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)parameterArray {
    if (!_parameterArray) {
        _parameterArray = [NSMutableArray array];
    }
    return _parameterArray;
}


-(NSMutableDictionary *)cellHDict{
    if (!_cellHDict) {
        _cellHDict = [NSMutableDictionary dictionary];
    }
    return _cellHDict;
}

-(void)setUI{
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //第一组头：轮播图 ，音乐，视频，礼品名称和价格
    //第一组：礼品参数（可跳转）
    //第二组头：礼品详情（四个字）
    //第二组：礼品全景（如果有的话）
    //第三组：礼品详情内容
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==1) {
        return 1;
    }
    else if (section==2) {
        return self.dataArray.count;
    }
    else{
       return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //第一组头：轮播图 ，音乐，视频，礼品名称和价格
    //第一组：礼品参数（可跳转）
    //第二组头：礼品详情（四个字）
    //第二组：礼品全景（如果有的话）
    //第三组：礼品详情内容
    if (indexPath.section==0) {
        return 50;
    }
    else if (indexPath.section==1) {
        return _cellTwoH;
    }
    else{
        NSString *keyStr = [NSString stringWithFormat:@"%ld",indexPath.row];
        CGFloat cellH = [[self.cellHDict objectForKey:keyStr] floatValue];
        return cellH;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //第一组头：轮播图 ，音乐，视频，礼品名称和价格
    //第一组：礼品参数（可跳转）
    //第二组头：礼品详情（四个字）
    //第二组：礼品全景（如果有的话）
    //第三组：礼品详情内容
    if (section==0) {
        return 265+50+50;
    }

    if (section==1) {
        return 50;
    }
    
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //第一组头：轮播图 ，音乐，视频，礼品名称和价格
    //第一组：礼品参数（可跳转）
    //第二组头：礼品详情（四个字）
    //第二组：礼品全景（如果有的话）
    //第三组：礼品详情内容
    if (section==0) {
        //265+50+50
        UIView *view = [[UIView alloc]init];
        [view addSubview:self.headerView];
        NSMutableArray *imgArray = [NSMutableArray array];
        if (_model.videoImg&&_model.viewImg.length>0) {
            [imgArray addObject:_model.videoImg];
        }
        NSArray *temArray = [_model.displayImg componentsSeparatedByString:@","];
        [imgArray addObjectsFromArray:temArray];
        self.adScrollView.imageURLStringsGroup = imgArray;
        
        
        if (_model.videoUrl&&_model.videoUrl.length>0) {
            self.videoPlayImgV.hidden = NO;
        }
        else{
            self.videoPlayImgV.hidden = YES;
        }
        
        if (_model.musicUrl&&_model.musicUrl.length>0) {
            self.musicPlayBtn.userInteractionEnabled = YES;
            _musicPlayerView.url = [NSURL URLWithString:_model.musicUrl];
        }
        
        else{
            self.musicPlayBtn.userInteractionEnabled = NO;
        }
        self.musicNameL.text = _model.musicName.length>0?_model.musicName:@"暂无";
        self.productNameL.text = _model.giftName;
        self.productPriceL.text = _model.price;
        
        return view;
    }
    if (section==1) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = White_Color;
        UILabel *produceDetailL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50)];
        produceDetailL.text = @"礼品详情";
        produceDetailL.textColor = COLOR_BLACK_CLASS_3;
        produceDetailL.font = NB_FONTSEIZ_NOR;
        produceDetailL.textAlignment = NSTextAlignmentCenter;
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 49, kSCREEN_WIDTH, 1)];
        lineV.backgroundColor = kSepLineColor;

        [view addSubview:produceDetailL];
        [view addSubview:lineV];
        return view;
    }
    return [[UITableViewHeaderFooterView alloc]init];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UITableViewHeaderFooterView alloc]init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //第一组头：轮播图 ，音乐，视频，礼品名称和价格
    //第一组：礼品参数（可跳转）
    //第二组头：礼品详情（四个字）
    //第二组：礼品全景（如果有的话）
    //第三组：礼品详情内容
    if (indexPath.section==0) {
        
        NSString * identifier= @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
//        cell.backgroundColor = [UIColor grayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 49, kSCREEN_WIDTH, 1)];
        lineV.backgroundColor = kSepLineColor;
        [cell addSubview:lineV];
        cell.textLabel.text = @"礼品参数";
        return cell;
        
    }
    else if (indexPath.section==1) {
        ProdcutDetailInfoCell *cell = [ProdcutDetailInfoCell cellWithTableView:tableView indexpath:indexPath];
        [cell configDataWith:_model.viewName imgStr:_model.viewImg];
        _cellTwoH = cell.cellH;
        return cell;
    }
    else if (indexPath.section==2) {
        ProdcutDetailInfoCell *cell = [ProdcutDetailInfoCell cellWithTableView:tableView indexpath:indexPath];
        NSDictionary *dict = self.dataArray[indexPath.row];
        NSString *contentStr = [dict objectForKey:@"content"];
        NSString *imgUrlStr = [dict objectForKey:@"imgUrl"];
        [cell configDataWith:contentStr imgStr:imgUrlStr];
        
        NSString *keyStr = [NSString stringWithFormat:@"%ld",indexPath.row];
        [self.cellHDict setObject:@(cell.cellH) forKey:keyStr];
        return cell;
    }
    
    else{
        return [[UITableViewCell alloc]init];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0){
        self.paramererView.topTitle = @"礼品参数";
        [self.paramererView.listArray removeAllObjects];
        [self.paramererView.promptArray removeAllObjects];
        self.paramererView.listArray = [self.parameterArray mutableCopy];
        [UIView animateWithDuration:0.25 animations:^{
            self.paramererView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
        }];
    }
    
    if (indexPath.section==1) {
        if (_model.viewUrl&&_model.viewUrl.length>0) {
            //全景vr
            senceWebViewController *vc = [[senceWebViewController alloc]init];
            vc.isFrom = YES;
            vc.webUrl = _model.viewUrl;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section==2) {
        NSDictionary *dict = self.dataArray[indexPath.row];
        NSString *mvUrl = [dict objectForKey:@"mvUrl"];
        if (mvUrl&&mvUrl.length>0) {
            [self detailVideoPlayWith:mvUrl];
        }
    }
}

// 头部视频播放
- (void)setupPlayerView:(UIView *)headerView {
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 265)];
    
    _videoPlayerView = playerView;
    [headerView addSubview:_videoPlayerView];
    _videoPlayerView.hidden = YES;
    _videoPlayerView.delegate = self;
    
    _videoPlayerView.progressBufferColor = Clear_Color;
    
    //    //重复播放，默认不播放
    _videoPlayerView.repeatPlay = YES;
    //    //当前控制器是否支持旋转，当前页面支持旋转的时候需要设置，告知播放器
    _videoPlayerView.isLandscape = NO;
    //    //设置等比例全屏拉伸，多余部分会被剪切
    _videoPlayerView.videoFillMode =VideoFillModeResizeAspect;
    _videoPlayerView.strokeColor = kMainThemeColor;
    //    //工具条消失时间，默认10s
    _videoPlayerView.toolBarDisappearTime = 3;
    //顶部工具条隐藏样式，默认不隐藏
    //    _playerView.topToolBarHiddenType = TopToolBarHiddenAll;
    //返回按钮点击事件回调,小屏状态才会调用，全屏默认变为小屏
    [_videoPlayerView backButton:^(UIButton *button) {
        //        NSLog(@"返回按钮被点击");
        //[_videoPlayerView destroyPlayer];
        [_videoPlayerView pausePlay];
        _videoPlayerView.hidden = YES;
        self.videoPlayImgV.hidden = NO;
    }];
    //播放完成回调
    [_videoPlayerView endPlay:^{
        //销毁播放器
        // [_videoPlayerView destroyPlayer];
        [_videoPlayerView pausePlay];
        _videoPlayerView.hidden = YES;
        self.videoPlayImgV.hidden = NO;
        
    }];
}

#pragma mark -播放视频（封面图的视频播放）
-(void)videoPlayGes:(UITapGestureRecognizer *)ges{
    // 停止音乐播放
    [_musicPlayerView pausePlay];
    [self.musicPlayBtn setImage:[UIImage imageNamed:@"music_play"] forState:UIControlStateNormal];
    _isPlayingMusic = NO;
    
    _videoPlayerView.url = [NSURL URLWithString:_model.videoUrl];
    self.videoPlayImgV.hidden = YES;
    _videoPlayerView.hidden = NO;
    [_videoPlayerView playVideo];
}

#pragma mark - 详情视频播放
-(void)detailVideoPlayWith:(NSString *)urlStr{
    if (![urlStr ew_isUrlString]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"视频地址不正确， 不能播放"];
        return;
    }
    
    CLPlayerView *playerView = [[CLPlayerView alloc] init];
    self.detailVideoPlayerView = playerView;
    [self.view addSubview:self.detailVideoPlayerView];
    [self.detailVideoPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(64);
        make.left.right.bottom.equalTo(0);
    }];
    self.detailVideoPlayerView.url = [NSURL URLWithString:urlStr];
    self.detailVideoPlayerView.hidden = NO;
    self.detailVideoPlayerView.repeatPlay = NO;
    self.detailVideoPlayerView.delegate = self;
    self.detailVideoPlayerView.isLandscape = NO;
    self.detailVideoPlayerView.videoFillMode = VideoFillModeResizeAspect;
    self.detailVideoPlayerView.strokeColor = [UIColor clearColor];
    self.detailVideoPlayerView.toolBarDisappearTime = 3;
    
    
    
    // 停止音乐播放
    [_musicPlayerView pausePlay];
    [self.musicPlayBtn setImage:[UIImage imageNamed:@"music_play"] forState:UIControlStateNormal];
    _isPlayingMusic = NO;
    
    // 停止头部视频播放
    [_videoPlayerView pausePlay];
    
    
    [self.detailVideoPlayerView backButton:^(UIButton *button) {
        
        [self.detailVideoPlayerView pausePlay];
        self.detailVideoPlayerView.hidden = YES;
//        self.vrPlayIV.hidden = NO;
        [self.detailVideoPlayerView destroyPlayer];
        [self.detailVideoPlayerView removeFromSuperview];
    }];
    [self.detailVideoPlayerView endPlay:^{
        [self.detailVideoPlayerView pausePlay];
        self.detailVideoPlayerView.hidden = YES;
//        self.vrPlayIV.hidden = NO;
        [self.detailVideoPlayerView destroyPlayer];
        [self.detailVideoPlayerView removeFromSuperview];
    }];
    [self.detailVideoPlayerView playVideo];
}

// 播放 音乐
- (void)playMusic:(UIButton *)sender {
    _isPlayingMusic = !_isPlayingMusic;
    if (_isPlayingMusic) {
        // 停止视频播放
        [_videoPlayerView pausePlay];
        
        //        self.musicPlayerView.url = [NSURL URLWithString:self.cardModel.music];
        [sender setImage:[UIImage imageNamed:@"music_pause"] forState:UIControlStateNormal];
        [_musicPlayerView playVideo];
        
        
        
        
    } else {
        [sender setImage:[UIImage imageNamed:@"music_play"] forState:UIControlStateNormal];
        [_musicPlayerView pausePlay];
    }
    
    
}



#pragma mark - 查询礼品详情
-(void)getData{
//    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"gift/getModel.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"giftId":self.giftId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
//                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                _model = [STYCouponSelectModel yy_modelWithJSON:responseObj[@"data"][@"model"]];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:_model.details];
                
                NSArray *array = [self stringToJSON:_model.params];
                
                if (array.count) {
                    [self.parameterArray removeAllObjects];
                    NSArray *temArray = [NSArray yy_modelArrayWithClass:[GoodsParamterModel class] json:array];
                    [self.parameterArray addObjectsFromArray:temArray];
                }
                
                [self.tableView reloadData];
            
                //音乐是否自动播放
                
                if ([_model.musicAutoplay integerValue]==1&&_model.musicUrl.length>0) {
                    //播放音乐
                    [self.musicPlayBtn setImage:[UIImage imageNamed:@"music_pause"] forState:UIControlStateNormal];
                    [_musicPlayerView playVideo];
                    _isPlayingMusic = YES;
                }
                
                
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
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        YSNLog(@"%@",errorMsg);
    }];
}

- (NSArray *)stringToJSON:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
                
            } else if([tmp isKindOfClass:[NSString class]]
                      || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp];
                
            } else {
                return nil;
            }
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar.bottom,kSCREEN_WIDTH,kSCREEN_HEIGHT-self.navigationController.navigationBar.bottom) style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.scrollEnabled = YES;
    }
    return _tableView;
}

-(UIView *)headerView{
    if (!_headerView) {
        //265+50+50
        CGFloat hh = 265+50+50;
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, hh)];
        _headerView.backgroundColor = White_Color;
        CGFloat headerViewHeight = 0;
        self.adScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 265) delegate:self placeholderImage:nil];
        self.adScrollView.autoScroll = NO;
        self.adScrollView.showPageControl = YES;
        self.adScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        self.adScrollView.backgroundColor = Black_Color;
        
        [_headerView addSubview:self.adScrollView];
        
        [self setupPlayerView:_headerView];
        
        CGFloat btnWH = 40;
        UIImageView *videoPlayImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-btnWH/2,self.adScrollView.height/2-btnWH/2,btnWH,btnWH)];
        
        videoPlayImgV.image = [UIImage imageNamed:@"video_play"];
        self.videoPlayImgV = videoPlayImgV;
        self.videoPlayImgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videoPlayGes:)];
        [self.videoPlayImgV addGestureRecognizer:ges];
        
        [_headerView addSubview:self.videoPlayImgV];
        
        
        CLPlayerView *musicPlauerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, self.adScrollView.bottom, kSCREEN_WIDTH, 50)];
        self.musicPlayerView = musicPlauerView;
        self.musicPlayerView.videoFillMode = VideoFillModeResizeAspect;
        self.musicPlayerView.repeatPlay = YES;
//        [musicView addSubview:_musicPlayerView];
        self.musicPlayerView.hidden = YES;
        [_headerView addSubview:self.musicPlayerView];
        
        UIImageView *defaultImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.adScrollView.bottom+15, 20, 20)];
        defaultImg.image = [UIImage imageNamed:@"CD"];
        [_headerView addSubview:defaultImg];
        
        UILabel *musicNameL = [[UILabel alloc]initWithFrame:CGRectMake(defaultImg.right+5,self.adScrollView.bottom+15,kSCREEN_WIDTH-defaultImg.right-5-30,20)];
        musicNameL.text = @"暂无";
        musicNameL.textColor = COLOR_BLACK_CLASS_3;
        musicNameL.font = NB_FONTSEIZ_NOR;
        musicNameL.textAlignment = NSTextAlignmentLeft;
        self.musicNameL = musicNameL;

        [_headerView addSubview:self.musicNameL];
        
        UIButton *musicPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        musicPlayBtn.frame = CGRectMake(kSCREEN_WIDTH-30,musicNameL.top,20,20);

        [musicPlayBtn setImage:[UIImage imageNamed:@"music_play"] forState:UIControlStateNormal];
        self.musicPlayBtn = musicPlayBtn;
        [self.musicPlayBtn addTarget:self action:@selector(playMusic:) forControlEvents:UIControlEventTouchUpInside];
        
        [_headerView addSubview:self.musicPlayBtn];
        
        UIView *lineOneV = [[UIView alloc]initWithFrame:CGRectMake(0, musicNameL.bottom+15, kSCREEN_WIDTH, 1)];
        lineOneV.backgroundColor = kSepLineColor;
        [_headerView addSubview:lineOneV];
        
        UILabel *productNameL = [[UILabel alloc]initWithFrame:CGRectMake(10, lineOneV.bottom, kSCREEN_WIDTH-10, 20)];
        productNameL.text = @"联盟LOGO";
        productNameL.textColor = COLOR_BLACK_CLASS_3;
        productNameL.font = NB_FONTSEIZ_NOR;
        productNameL.textAlignment = NSTextAlignmentLeft;
        self.productNameL = productNameL;
        [_headerView addSubview:self.productNameL];
        
        UILabel *productPriceL = [[UILabel alloc]initWithFrame:CGRectMake(productNameL.left, productNameL.bottom, productNameL.width, 30)];
        productPriceL.text = @"$43";
        productPriceL.textColor = Red_Color;
        productPriceL.font = NB_FONTSEIZ_NOR;
        productPriceL.textAlignment = NSTextAlignmentLeft;
        self.productPriceL = productPriceL;
        [_headerView addSubview:self.productPriceL];
        
        UIView *lineTwoV = [[UIView alloc]initWithFrame:CGRectMake(0, productPriceL.bottom-1, kSCREEN_WIDTH, 1)];
        lineTwoV.backgroundColor = kSepLineColor;
        [_headerView addSubview:lineTwoV];
    }
    return _headerView;
}

- (GoodsParameterView *)paramererView {
    if (_paramererView == nil) {
        _paramererView = [[GoodsParameterView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64)];
        _paramererView.delegate = self;
        [self.view addSubview:_paramererView];
        [self.view sendSubviewToBack:self.tableView];
        
        _paramererView.finishBlock = ^(GoodsParameterView *paramView) {
            [UIView animateWithDuration:0.25 animations:^{
                paramView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
            }];
        };
    }
    return _paramererView;
}

@end
