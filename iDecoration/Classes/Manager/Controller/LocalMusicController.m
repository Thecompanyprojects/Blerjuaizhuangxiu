//
//  LocalMusicController.m
//  iDecoration
//
//  Created by sty on 2017/9/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "LocalMusicController.h"
#import "AddLocalMusicController.h"

#import "LocalMusicCell.h"
#import "LocalMusicModel.h"
#import <AVFoundation/AVFoundation.h>

#import "MusicManager.h"

@interface LocalMusicController ()<UITableViewDelegate,UITableViewDataSource,MusicManagerDelegate>{
    NSInteger _selectTag;
    
    BOOL _isHaveAdd;//是否已经添加了本地音乐
}
@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UIView *bottomLineV;
@property (nonatomic, strong) UILabel *upLabel;

@property (nonatomic, strong) UIButton *successBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *urlArray;


@property (nonatomic, strong) NSMutableArray *lateAddArray;//后加的url

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) MusicManager *manager;
@end

@implementation LocalMusicController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.title = @"音乐列表";
    self.dataArray = [NSMutableArray array];
    self.urlArray = [NSMutableArray array];
    self.lateAddArray = [NSMutableArray array];
    _selectTag = -1;
    [self creatUI];
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
    
    [self requestData];
//    [self.player.currentItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew) context:nil];
//    [self.player play];
    _isHaveAdd = NO;
    self.manager = [MusicManager manager];
    self.manager.delegate = self;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
}

-(void)creatUI{
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomV];
    [self.bottomV addSubview:self.bottomLineV];
    [self.bottomV addSubview:self.upLabel];
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    //注意这里查看的是self.player.status属性
//    if ([keyPath isEqualToString:@"status"]) {
//        switch (self.player.status) {
//            case AVPlayerStatusUnknown:
//            {
//                NSLog(@"未知转态");
//            }
//                break;
//            case AVPlayerStatusReadyToPlay:
//            {
//                NSLog(@"准备播放");
//                [self.player play];
//                bool isPaused = (self.player.timeControlStatus == AVPlayerTimeControlStatusPaused);
//                
//                bool isPlayAtSp = (self.player.timeControlStatus == AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate);
//                
//                
//                bool isPlaying = (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying);
//                YSNLog(@"%d--%d--%d",isPaused,isPlayAtSp,isPlaying);
//                
//                // 代理回调，开始初始化状态
////                if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayWithplayer:)]) {
////                    [self.delegate startPlayWithplayer:self.player];
////                }
////                AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:@"http://testimage.bilinerju.com/group1/M00/00/0B/rBHg0Fm1_4yAODCyAAFHTYcmdbg684.mp3"]];
////                // 播放当前资源
////                [self.player replaceCurrentItemWithPlayerItem:playerItem];
////                [self.player play];
//                
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

-(void)dealloc{
    
    [self.manager allDealloc];
    self.manager = nil;
    
    
    
}

-(void)back{
    [self.manager allDealloc];
    self.manager = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
//    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ideitifier = @"LocalMusicCell";
    LocalMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BOOL isshow = NO;
    if (indexPath.row!=_selectTag) {
        isshow = NO;
    }
    else{
        isshow = YES;
    }
//    [cell configWith:self.songArray[indexPath.row] singer:self.singerArray[indexPath.row] isShowSelect:isshow];
    [cell configData:self.dataArray[indexPath.row] isShowCheck:isshow];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSInteger tempInt = _selectTag;
    _selectTag = indexPath.row;
//    LocalMusicModel *model = self.dataArray[_selectTag];

    NSInteger cha = self.dataArray.count-self.lateAddArray.count;
//    if (_isHaveAdd&&indexPath.row>=cha) {
//        [self.manager pause];
//    }
//    else{
        self.manager.dataArray = self.urlArray;
        [self.manager prepareItemsWith:_selectTag];
//    }
    
    [self.tableView reloadData];
    
    
    
    
    

}

#pragma mark - action





-(void)successBtnClick:(UIButton *)btn{
    if (_selectTag==-1) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请先选择音乐" controller:self sleep:1.5];
        return;
    }
    LocalMusicModel *model = self.dataArray[_selectTag];
    if (self.localMusicBlock) {
        self.localMusicBlock(model.picUrl, model.picTitle);
    }
    
    [self.manager allDealloc];
    self.manager = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(void)bottomVClick:(UITapGestureRecognizer *)ges{
    
    [self.manager allDealloc];
    AddLocalMusicController *vc = [[AddLocalMusicController alloc]init];
    __weak typeof (self) wself = self;
    vc.addLocalMusicBlock = ^(LocalMusicModel *model) {
        [wself.dataArray addObject:model];
        _selectTag = self.dataArray.count-1;
        [self.urlArray addObject:model.picUrl];
        [self.lateAddArray addObject:model.picUrl];
        _isHaveAdd = YES;
        [wself.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)requestData{
    [[UIApplication sharedApplication].keyWindow hudShow];
    [self.dataArray removeAllObjects];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"img/getMp3List.do"];
    
    
//    NSDictionary *paramDic = @{@"agencysId":@(user.agencyId)
//                               };
    [NetManager afPostRequest:defaultApi parms:nil finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                NSArray *caseArr = [[responseObj objectForKey:@"data"]objectForKey:@"list"];
                LocalMusicModel *model = [LocalMusicModel new];
                model.picUrl = @"";
                model.picTitle = @"无";
                [self.dataArray addObject:model];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[LocalMusicModel class] json:caseArr];
                [self.dataArray addObjectsFromArray:arr];
                
                
                
                if (self.musicUrl&&self.musicUrl.length>0) {
                    
                    if (self.dataArray.count<=0) {
                        LocalMusicModel *model = [[LocalMusicModel alloc]init];
                        model.picUrl = self.musicUrl;
                        model.picTitle = self.songName;
                        [self.dataArray addObject:model];
                    }
                    //判断musicURl 是否存在于后台返回的数据中
                    // 存在：找出_selectTag
                    // 不存在：添加到数组中。 _selectTag=self.dataArray.count-1
                    
                    
                    NSInteger dataCount = self.dataArray.count;
                    for (int i = 0; i<dataCount; i++) {
                        LocalMusicModel *tempModel = self.dataArray[i];
                        if ([tempModel.picUrl isEqualToString:self.musicUrl]) {
                            _selectTag = i;
                            break;
                        }
                        else{
                            _selectTag = -1;
                        }
                    }
                    
                    if (_selectTag==-1) {
                        LocalMusicModel *model = [[LocalMusicModel alloc]init];
                        model.picUrl = self.musicUrl;
                        model.picTitle = self.songName;
                        [self.dataArray addObject:model];
                        [self.lateAddArray addObject:model.picUrl];
                        _isHaveAdd = YES;
                        _selectTag = self.dataArray.count-1;
                    }
                    
                    
                }
                
                else{
                    _selectTag = -1;
                }
                
                for (LocalMusicModel *model in self.dataArray) {
                    [self.urlArray addObject:model.picUrl];
                }
                
                
                
                
            
                [self.tableView reloadData];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - lazy



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
        _upLabel.text = @"上传音乐";
    }
    return _upLabel;
}

//-(AVPlayer *)player{
//    if (_player==nil) {
////        AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:@"http://testimage.bilinerju.com/group1/M00/00/0B/rBHg0Fm1_4yAODCyAAFHTYcmdbg684.mp3"]];
////        _player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
//        _player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:@"http://testimage.bilinerju.com/group1/M00/00/0B/rBHg0Fm1_4yAODCyAAFHTYcmdbg684.mp3"]];
//    }
//    return _player;
//}

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
        [_tableView registerNib:[UINib nibWithNibName:@"LocalMusicCell" bundle:nil] forCellReuseIdentifier:@"LocalMusicCell"];
    }
    return _tableView;
}

@end
