//
//  AddLocalMusicController.m
//  iDecoration
//
//  Created by sty on 2017/9/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "AddLocalMusicController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AddLocalMusicCell.h"
#import "ZCHPublicWebViewController.h"

#import "ASProgressPopUpView.h"


#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "TSLibraryImport.h"
//#import "lame.h"



@interface AddLocalMusicController ()<UITableViewDelegate,UITableViewDataSource,ASProgressPopUpViewDelegate,ASProgressPopUpViewDataSource>{

    NSInteger selectTag;
}
@property (nonatomic, strong) NSMutableArray *songArray;//歌名
@property (nonatomic, strong) NSMutableArray *singerArray;//歌手
@property (nonatomic, strong) NSMutableArray *assetUrlArray;
@property (nonatomic, strong) NSMutableArray *assetUr;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UIView *bottomLineV;
@property (nonatomic, strong) UILabel *upLabel;


@property (nonatomic, strong) UIView *backShadowV;

@property (nonatomic, strong) ASProgressPopUpView *progress;


@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *item;

@end

@implementation AddLocalMusicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"上传音乐";
    selectTag = -1;
    self.songArray = [NSMutableArray array];
    self.singerArray = [NSMutableArray array];
    self.assetUrlArray = [NSMutableArray array];
    self.assetUr = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.bottomV];
    [self.bottomV addSubview:self.bottomLineV];
    [self.bottomV addSubview:self.upLabel];
    
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    self.editBtn = editBtn;
    [self.editBtn addTarget:self action:@selector(successBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn];
    [self.view addSubview:self.backShadowV];
    [self.view addSubview:self.progress];
    self.backShadowV.hidden = YES;
    self.progress.hidden = YES;
    
    [self queryLocalMusic];
    
//    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];

    
}


//-(void)playFinished:(NSNotification *)not{
//    YSNLog(@"success");
//}

//观察者回调
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    //注意这里查看的是self.player.status属性
//    if ([keyPath isEqualToString:@"status"]) {
//        switch (self.player.status) {
//            case AVPlayerStatusUnknown:
//            {
//                NSLog(@"未知转态");
//                
//            }
//                break;
//            case AVPlayerStatusReadyToPlay:
//            {
//                NSLog(@"准备播放");
//
//                
//                [self.player play];
//            }
//                break;
//            case AVPlayerStatusFailed:
//            {
//                NSLog(@"加载失败");
//            }
//                break;
//            default:
//                break;
//        }
//    }
//}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.songArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ideitifier = @"AddLocalMusicCell";
    AddLocalMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BOOL isshow = NO;
    if (indexPath.row!=selectTag) {
        isshow = NO;
    }
    else{
        isshow = YES;
    }
    [cell configWith:self.songArray[indexPath.row] singer:self.singerArray[indexPath.row] isShowSelect:isshow];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSInteger temTag = selectTag;
    selectTag = indexPath.row;
    [self.tableView reloadData];
//    NSURL *url = self.assetUr[indexPath.row];
//
//    
//    if (temTag==-1) {
//        
//        AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
//        [self.player replaceCurrentItemWithPlayerItem:songItem];
//        
//        [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//        [self.player play];
//        
//    }
//    
//    else{
//        if (temTag==selectTag) {
//            //选的是同一首歌 判断是播放还是停止
//            //正在播放--让它停止
//            //停止--让他播放
//            if (self.player.rate==1.0) {
//                [self.player pause];
//                [self removeObserver:self forKeyPath:@"status"];
//            }
//            else{
//                AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
//                [self.player replaceCurrentItemWithPlayerItem:songItem];
//                
//                [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//                [self.player play];
//            }
//        }
//        else{
//            //选的不是同一首歌，停止上一首，播放选定的
//            [self.player pause];
//            [self removeObserver:self forKeyPath:@"status"];
//            
//            AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
//            [self.player replaceCurrentItemWithPlayerItem:songItem];
//            
//            [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//            [self.player play];
//        }
//    }
    

}




-(void)queryLocalMusic{
    MPMediaQuery *everything = [[MPMediaQuery alloc]init];
    MPMediaPropertyPredicate *albumNamePredicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic] forProperty:MPMediaItemPropertyMediaType];
    [everything addFilterPredicate:albumNamePredicate];
    
    NSArray *itemsFrom = [everything items];
    
//    NSMutableArray *finallyArray = [NSMutableArray array];
    
    if (itemsFrom.count>0) {
        for (MPMediaItem *song in itemsFrom) {
            NSURL *songUrl = [song valueForProperty:MPMediaItemPropertyAssetURL];
            
            if (songUrl) {
//                NSString *songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
                [self.assetUrlArray addObject:song];
                [self.assetUr addObject:songUrl];
                
                NSString *song1 = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
                [self.songArray addObject:song1];
                NSString *songArtist = [song valueForProperty:MPMediaItemPropertyArtist];
                if (!songArtist||songArtist.length<=0) {
                    songArtist = @"未知歌手";
                }
                [self.singerArray addObject:songArtist];
                
                
            }
            
        }
        if (self.songArray.count<=0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
        }
        else{
            [self.tableView reloadData];
        }
    }
    
    else{
        [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
    }
    
}

#pragma mark - action

-(void)bottomVClick:(UITapGestureRecognizer *)ges{
    
    ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
    VC.titleStr = @"同步音乐";
    VC.webUrl = @"resources/html/tongbuyinyue.html";
    [self.navigationController pushViewController:VC animated:YES];
    
}

-(void)successBtnClick:(UIButton *)btn{
    if (selectTag==-1) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请先选择歌曲" controller:self sleep:1.5];
        return;
    }
    self.backShadowV.hidden = NO;
    self.progress.hidden = NO;
    
    self.backShadowV.alpha = 0.5f;
    self.progress.progress = 0.0;
    self.editBtn.userInteractionEnabled = NO;
//    [self convertToMp3:self.assetUrlArray[selectTag]];
    MPMediaItem *song = self.assetUrlArray[selectTag];
    NSURL*url = [song valueForProperty:MPMediaItemPropertyAssetURL];
    NSString *title = [song valueForProperty:MPMediaItemPropertyTitle];
    [self exportAssetAtURL:url withTitle:title];
}

#pragma mark - 转换音乐
- (void)exportAssetAtURL:(NSURL*)assetURL withTitle:(NSString*)title {
    
    // create destination URL
    NSString* ext = [TSLibraryImport extensionForAssetURL:assetURL];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSURL* outURL = [[NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:title]] URLByAppendingPathExtension:ext];
    // we're responsible for making sure the destination url doesn't already exist
    [[NSFileManager defaultManager] removeItemAtURL:outURL error:nil];
    
    // create the import object
    TSLibraryImport* import = [[TSLibraryImport alloc] init];

    [import importAsset:assetURL toURL:outURL completionBlock:^(TSLibraryImport* import) {
        /*
         * If the export was successful (check the status and error properties of
         * the TSLibraryImport instance) you know have a local copy of the file
         * at `outURL` You can get PCM samples for processing by opening it with
         * ExtAudioFile. Yay!
         *
         * Here we're just playing it with AVPlayer
         */
        if (import.status != AVAssetExportSessionStatusCompleted) {
            // something went wrong with the import
            NSLog(@"Error importing: %@", import.error);
            import = nil;
            self.editBtn.userInteractionEnabled = YES;
            return;
        }
        
        if (import.status == AVAssetExportSessionStatusCompleted) {
            YSNLog(@"%@",outURL);
            [self upload:outURL];
        }
        
    }];
}









/*
 *  上传.mp3文件
 */
- (void)upload:(NSURL *)mp3Url
{

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
//    [self.view addSubview:self.backShadowV];
//    self.backShadowV.alpha = 0.5f;
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"file/uploadFile.do"];
    [manager POST:defaultApi parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //              application/octer-stream   audio/mpeg video/mp4   application/octet-stream
        
        /* url      :  本地文件路径
         * name     :  与服务端约定的参数
         * fileName :  自己随便命名的
         * mimeType :  文件格式类型 [mp3 : application/octer-stream application/octet-stream] [mp4 : video/mp4]
         */
        NSString *fileName = [NSString stringWithFormat:@"%@.mp3",self.songArray[selectTag]];
        [formData appendPartWithFileURL:mp3Url name:@"file" fileName:fileName mimeType:@"application/octet-stream" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        YSNLog(@"---上传进度--- %@",uploadProgress);
        YSNLog(@"%f",uploadProgress.fractionCompleted);
        NSString *temStr = [NSString stringWithFormat:@"%.2f",uploadProgress.fractionCompleted];
        CGFloat progress = [temStr floatValue];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progress setProgress:progress animated:YES];
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        

        NSLog(@"上传成功 %@",responseObject);
        NSString *str = [responseObject objectForKey:@"imageUrl"];
        YSNLog(@"%@",str);
        
        self.editBtn.userInteractionEnabled = YES;
        self.progress.hidden = YES;
        self.backShadowV.alpha = 0.0f;
        self.backShadowV.hidden = YES;
        
        NSString *songStr = self.songArray[selectTag];
        LocalMusicModel *model = [[LocalMusicModel alloc]init];
        model.picUrl = str;
        model.picTitle = songStr;
        
        if (self.addLocalMusicBlock) {
            self.addLocalMusicBlock(model);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        self.editBtn.userInteractionEnabled = YES;
        self.progress.hidden = YES;
        self.backShadowV.alpha = 0.0f;
        self.backShadowV.hidden = YES;
        
        NSLog(@"上传失败 %@",error);
    }];
}

- (void)uploadData:(NSData *)mp3Url
{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    
    
    
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"file/uploadFile.do"];
    [manager POST:defaultApi parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //              application/octer-stream   audio/mpeg video/mp4   application/octet-stream
        
        /* url      :  本地文件路径
         * name     :  与服务端约定的参数
         * fileName :  自己随便命名的
         * mimeType :  文件格式类型 [mp3 : application/octer-stream application/octet-stream] [mp4 : video/mp4]
         */
        NSString *fileName = [NSString stringWithFormat:@"%@.mp3",self.songArray[selectTag]];
//        [formData appendPartWithFileURL:mp3Url name:@"file" fileName:fileName mimeType:@"application/octet-stream" error:nil];
        [formData appendPartWithFileData:mp3Url name:@"file" fileName:fileName mimeType:@"application/octet-stream"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        YSNLog(@"---上传进度--- %@",uploadProgress);
        YSNLog(@"%f",uploadProgress.fractionCompleted);
        NSString *temStr = [NSString stringWithFormat:@"%.2f",uploadProgress.fractionCompleted];
        CGFloat progress = [temStr floatValue];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progress setProgress:progress animated:YES];
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.editBtn.userInteractionEnabled = YES;
        self.progress.hidden = YES;
        self.backShadowV.alpha = 0.0f;
        self.backShadowV.hidden = YES;
        NSLog(@"上传成功 %@",responseObject);
        NSString *str = [responseObject objectForKey:@"imageUrl"];
        

        NSString *songStr = self.songArray[selectTag];
        LocalMusicModel *model = [[LocalMusicModel alloc]init];
        model.picUrl = str;
        model.picTitle = songStr;
        
        if (self.addLocalMusicBlock) {
            self.addLocalMusicBlock(model);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        self.editBtn.userInteractionEnabled = YES;
        self.progress.hidden = YES;
        self.backShadowV.alpha = 0.0f;
        self.backShadowV.hidden = YES;
        
        NSLog(@"上传失败 %@",error);
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

#pragma mark - lazy

-(AVPlayer *)player{
    if (!_player) {
        // AVPlayerItem是一个包装音乐资源的类，初始化时可以传入一个音乐的url
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@"http://xxxxxxxx"]];
        //通过AVPlayerItem初始化player
        _player = [[AVPlayer alloc] initWithPlayerItem:item];
    }
    return _player;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64-40) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = White_Color;
        //        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"AddLocalMusicCell" bundle:nil] forCellReuseIdentifier:@"AddLocalMusicCell"];
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

-(UIView *)bottomV{
    if (!_bottomV) {
        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-40, kSCREEN_WIDTH, 40)];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomVClick:)];
        _bottomV.userInteractionEnabled = YES;
        [_bottomV addGestureRecognizer:ges];
        _bottomV.backgroundColor = White_Color;
    }
    return _bottomV;
}

-(UIView *)bottomLineV{
    if (!_bottomLineV) {
        _bottomLineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
        _bottomLineV.backgroundColor = COLOR_BLACK_CLASS_0;
    }
    return _bottomLineV;
}

-(UILabel *)upLabel{
    if (!_upLabel) {
        _upLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 1, self.bottomV.width, self.bottomV.height-1)];
        _upLabel.textColor = COLOR_BLACK_CLASS_3;
        _upLabel.font = NB_FONTSEIZ_BIG;
        _upLabel.textAlignment = NSTextAlignmentCenter;
        _upLabel.text = @"如何从电脑同步音乐？";
    }
    return _upLabel;
}




@end
