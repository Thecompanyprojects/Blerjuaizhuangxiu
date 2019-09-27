//
//  EditMyBeatArtController.h
//  iDecoration
//
//  Created by sty on 2017/11/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
@class ASProgressPopUpView;
@interface EditMyBeatArtController : SNViewController{
    NSMutableDictionary *hiddenStateDict; //
    BOOL bottomCellIsHidden; //yes:显示加号。//no:显示添加图片
    CGFloat bottomCellH;
    NSIndexPath *addPath;// 添加图片到第几个cell前面
    NSIndexPath *modifyPath;// 修改的是第几个cell的图片
    NSInteger addVidelTag;//添加视频到第几个前面 (-1:放到最后一个)
    BOOL isHaveDefaultLogo;//  默认图不一样 no:有默认图(edit)  yes：有默认图(defaultLogo)
    NSInteger upTag;//1:选取本地视频上传。2:拍摄视频上传
    NSString *_videoPath;
    BOOL isFirstCamera; //是否为第一次拍摄视频内容   yes :是 no：否
}
@property (assign, nonatomic) BOOL isHaveVote; //no:没有投票 //yes:有投票
@property (assign, nonatomic) BOOL isHaveVR; //no:没有全景 yes：有全景
@property (assign, nonatomic) BOOL isHaveSignUp; //no:没有活动报名 yes：有活动报名
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *MidCellHDict;//
@property (nonatomic, strong) UIView *bottombackGroundV;
@property (nonatomic, strong) UIButton *bottomaddBtn;
@property (nonatomic, strong) UIView *hiddenV;//隐藏或显示的view
@property (nonatomic, strong) UIButton *addTextBtn;
@property (nonatomic, strong) UIButton *addPhotoBtn;
@property (nonatomic, strong) UIButton *addVideoBtn;
@property (nonatomic, strong) UIButton *successBtn;
@property (nonatomic, strong) UIView *bottomMusicStyleV;//底部音乐播放模式选择
@property (nonatomic, strong) UILabel *musicLeftL;
@property (nonatomic, strong) UILabel *musicRightL;
@property (nonatomic, strong) UIImageView *bottomRow;
@property (nonatomic, strong) ASProgressPopUpView *progress;//进度条
@property (nonatomic, strong) UIView *backShadowV;
@property (nonatomic, assign) BOOL isFistr;//是否是第一次添加
@property (nonatomic, assign) BOOL isComplate;//是否交工
@property (nonatomic, assign) BOOL isPower;
@property (assign, nonatomic) BOOL isHaveMusicButton;//是否有添加音乐按钮
@property (nonatomic, copy) NSString *voteType;//投票类型
@property (nonatomic, copy) NSString *voteDescribe;//投票描述
@property (nonatomic, strong) NSMutableArray *optionList;//投票数组
@property (nonatomic, copy) NSString *endTime;//截止时间
@property (nonatomic, copy) NSString *coverTitle;//封面标题
@property (nonatomic, copy) NSString *coverTitleTwo;//封面副标题
@property (nonatomic, copy) NSString *coverImgUrl;//封面图片
@property (nonatomic, strong) NSMutableArray *orialArray;//原始数组
@property (nonatomic, strong) NSMutableArray *dataArray;//临时数组
@property (nonatomic, copy) NSString *musicUrl;//音乐地址
@property (nonatomic, copy) NSString *musicName;//音乐名称
@property (nonatomic, assign) NSInteger designId;
@property (nonatomic, copy) NSString *companyName; // 公司名称 ，生成二维码用
@property (nonatomic, copy) NSString *companyLogo; // 公司logo ，生成二维码用
@property (nonatomic, copy) NSString *myContructLink;//我的工地链接
@property (nonatomic, copy) NSString *coverImgStr;//全景封面
@property (nonatomic, copy) NSString *nameStr;//全景名称
@property (nonatomic, copy) NSString *linkUrl;//全景链接
@property (nonatomic, assign) NSInteger unionId;//联盟id
@property (nonatomic, strong) NSMutableArray *setDataArray;
@property (nonatomic, copy) NSString *actId;//活动id
@property (nonatomic, copy) NSString *actStartTimeStr;//活动开始时间
@property (nonatomic, copy) NSString *actEndTimeStr;//活动结束时间
@property (nonatomic, copy) NSString *longitude;//活动经纬度
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *signUpNumStr;//活动总人数 0：不限制
@property (nonatomic, copy) NSString *haveSignUpStr;//活动报名人数
@property (nonatomic, copy) NSString *customStr;//自定义项
@property (nonatomic, copy) NSString *activityPlace;//0:线下，1：线上
@property (nonatomic, copy) NSString *activityAddress;//活动地址
@property (nonatomic, copy) NSString *activityEnd;//0:活动结束之前截止报名，1：活动开始前截止报名
@property (nonatomic, assign) NSInteger musicStyle;//0:自动播放 1:点击播放
@property (assign, nonatomic) NSInteger type;//类型（0:本案设计1：联盟活动2：个人美文3：新闻资讯 4:非企业会员,5:精英推荐）

@property (nonatomic,assign) BOOL isCaogao;
@property (nonatomic,copy) NSString *draftId;

- (NSString *)jsonfrom;
- (void)pushData;
- (void)back;

@end
