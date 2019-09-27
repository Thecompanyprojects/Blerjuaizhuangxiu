//
//  BannerStoryViewController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "BannerStoryViewController.h"
#import "ZYCShareView.h"
#import <OpenShare/OpenShareHeader.h>
#import "SGQRCodeTool.h"
#import "FlowersStoryQRCodeViewController.h"

@interface BannerStoryViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIImageView *bannerImageView; // 锦旗
@property (nonatomic, strong) UILabel *sendNameLabel; // 送者名字
@property (nonatomic, strong) UILabel *acceptNameLabel; // 接收者名字
@property (nonatomic, strong) UILabel *timeLabel; // 时间
@property (nonatomic, strong) UILabel *rightCLabel; // 两行内容时右侧的内容
@property (nonatomic, strong) UILabel *leftCLabel; // 两行内容时左侧的内容
@property (nonatomic, strong) UILabel *middleCLabel; // 一行内容时的内容
@property (nonatomic, strong) UILabel *storyLabel; // 故事
@property (strong, nonatomic) ZYCShareView *shareView;
@end

@implementation BannerStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shareView = [ZYCShareView sharedInstance];
    [self makeShareView];
    self.navigationItem.title = @"锦旗故事";
    self.view.backgroundColor = kCustomColor(242, 242, 242);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self scrollView];
    [self topView];
    [self bottomView];
    if (self.model.story.length) {
        [self setupRightButton];
    }
    if (self.model.type.integerValue < 2000) { // 大锦旗
        self.bannerImageView.image = [UIImage imageNamed:@"bg_big_jinqi_one"];
        self.acceptNameLabel.text = self.model.receName;
        self.sendNameLabel.text = self.model.signName;
        self.timeLabel.text = [NSDate YearMonthDayWithTimeInterval:self.model.modified.doubleValue/1000.0];
        if ([self.model.type isEqualToString:@"2"]||[self.model.type isEqualToString:@"5"]) {
            self.middleCLabel.text = self.model.content;
        } else {
            if ([self.model.type isEqualToString:@"0"]||[self.model.type isEqualToString:@"3"]) {
                NSString *leftStr = [self.model.content substringFromIndex:self.model.content.length/2];
                NSString *rightStr = [self.model.content substringToIndex:self.model.content.length/2];
                self.leftCLabel.text = [NSString stringWithFormat:@"%@\n\n%@", [leftStr substringToIndex:leftStr.length/2], [leftStr substringFromIndex:leftStr.length/2]];
                self.rightCLabel.text = [NSString stringWithFormat:@"%@\n\n%@", [rightStr substringToIndex:rightStr.length/2], [rightStr substringFromIndex:rightStr.length/2]];
                
            } else {
                self.leftCLabel.text = [self.model.content substringFromIndex:self.model.content.length/2];
                self.rightCLabel.text = [self.model.content substringToIndex:self.model.content.length/2];
            }
            
        }
        self.storyLabel.text = self.model.story;
    } else { // 小锦旗
        self.scrollView.hidden = YES;
        
    }
    
    CGSize size = [self.model.story boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 30, CGFLOAT_MAX) withFont:[UIFont systemFontOfSize:14]];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).equalTo(0);
        make.left.equalTo(0);
        make.width.equalTo(kSCREEN_WIDTH);
        make.height.equalTo(size.height + 30 + 30);
    }];
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, kSCREEN_WIDTH + size.height + 30 + 30);
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(0);
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT));
        }];
        _scrollView.scrollEnabled = YES;
        _scrollView.backgroundColor = [UIColor whiteColor];
        
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}
- (UIView *)topView {
    if (_topView == nil) {
        _topView = [UIView new];
        [self.scrollView addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH, kSCREEN_WIDTH));
            make.top.equalTo(0);
            make.left.equalTo(0);
        }];
        _topView.backgroundColor =  [UIColor whiteColor];
        
        UIImageView *bgImageView = [UIImageView new];
        self.bannerImageView = bgImageView;
        [_topView addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.size.equalTo(CGSizeMake((kSCREEN_WIDTH-20)*53.0/68.0, kSCREEN_WIDTH - 20));
        }];
        bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        bgImageView.image = [UIImage imageNamed:@"bg_big_jinqi_one"];
        
        UILabel *sLabel = [UILabel new];
        [bgImageView addSubview:sLabel];
        sLabel.textColor = kCustomColor(254, 247, 2);
        sLabel.font = [UIFont systemFontOfSize:kSize(19)];
        [sLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kSize(37));
            make.right.equalTo(-kSize(45));
        }];
        sLabel.text = @"赠";
        
        UILabel *sendNameLabel = [UILabel new];
        self.acceptNameLabel = sendNameLabel;
        [bgImageView addSubview:sendNameLabel];
        sendNameLabel.textColor = kCustomColor(254, 247, 2);
        sendNameLabel.font = [UIFont systemFontOfSize:kSize(14)];
        sendNameLabel.numberOfLines = 0;
        [sendNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(sLabel);
            make.top.equalTo(sLabel.mas_bottom).equalTo(0);
            make.width.equalTo(kSize(14));
        }];
        sendNameLabel.textAlignment = NSTextAlignmentLeft;
        sendNameLabel.text = @"";
        
        UILabel *contentL1 = [UILabel new];
        self.rightCLabel = contentL1;
        [bgImageView addSubview:contentL1];
        contentL1.textColor = kCustomColor(254, 247, 2);
        contentL1.font = [UIFont systemFontOfSize:kSize(24)];
        contentL1.numberOfLines = 0;
        contentL1.textAlignment = NSTextAlignmentLeft;
        [contentL1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo((kSCREEN_WIDTH-20)*53.0/68.0/2.0 + 11);
            make.top.equalTo(sLabel.mas_bottom).equalTo(-kSize(25));
            make.width.equalTo(kSize(24));
            make.height.equalTo(kSCREEN_WIDTH - kSize(100));
        }];
        contentL1.text = @"";
        
        UILabel *contentL2 = [UILabel new];
        self.leftCLabel = contentL2;
        [bgImageView addSubview:contentL2];
        contentL2.textColor = kCustomColor(254, 247, 2);
        contentL2.font = [UIFont systemFontOfSize:kSize(24)];
        contentL2.numberOfLines = 0;
        [contentL2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentL1.mas_left).equalTo(-kSize(20));
            make.top.equalTo(sLabel.mas_bottom).equalTo(-kSize(25));
            make.width.equalTo(kSize(24));
            make.height.equalTo(kSCREEN_WIDTH - kSize(100));
        }];
        contentL2.text = @"";
        
        UILabel *contentL3 = [UILabel new];
        self.middleCLabel = contentL3;
        [bgImageView addSubview:contentL3];
        contentL3.textColor = kCustomColor(254, 247, 2);
        contentL3.font = [UIFont systemFontOfSize:kSize(24)];
        contentL3.numberOfLines = 0;
        [contentL3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(sLabel.mas_bottom).equalTo(-kSize(25));
            make.width.equalTo(kSize(24));
            make.height.equalTo(kSCREEN_WIDTH - kSize(100));
        }];
        contentL3.text = @"";
        contentL3.hidden = YES;
        
        UILabel *timeLabel = [UILabel new];
        self.timeLabel = timeLabel;
        [bgImageView addSubview:timeLabel];
        timeLabel.textColor = kCustomColor(254, 247, 2);
        timeLabel.font = [UIFont systemFontOfSize:kSize(8)];
        timeLabel.numberOfLines = 0;
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(kSize(46));
            make.width.equalTo(kSize(9));
            make.bottom.equalTo(-kSize(75));
        }];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.text = @"";
        
        UILabel *acceptLabel = [UILabel new];
        self.sendNameLabel = acceptLabel;
        [bgImageView addSubview:acceptLabel];
        acceptLabel.textColor = kCustomColor(254, 247, 2);
        acceptLabel.font = [UIFont systemFontOfSize:kSize(12)];
        acceptLabel.numberOfLines = 0;
        [acceptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(timeLabel.mas_right).equalTo(kSize(7));
            make.width.equalTo(kSize(13));
            make.bottom.equalTo(-kSize(64));
        }];
        acceptLabel.textAlignment = NSTextAlignmentRight;
        acceptLabel.text = @"";
    }
    return _topView;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [UIView new];
        [self.scrollView addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom).equalTo(0);
            make.left.equalTo(0);
            make.width.equalTo(kSCREEN_WIDTH);
            make.height.greaterThanOrEqualTo(50);
        }];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [UILabel new];
        [_bottomView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(0);
        }];
        label.text = @"锦旗--荣誉的象征";
        label.textColor = kCustomColor(51, 51, 51);
        label.font = [UIFont systemFontOfSize:16];
        
        UILabel *contentLabel = [UILabel new];
        [_bottomView addSubview:contentLabel];
        self.storyLabel = contentLabel;
        contentLabel.numberOfLines = 0;
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.right.equalTo(-15);
            make.top.equalTo(label.mas_bottom).equalTo(15);
            make.bottom.equalTo(-15);
        }];
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.textColor = kCustomColor(92, 92, 92);
        contentLabel.text = @"";
    }
    return _bottomView;
}

- (void)setupRightButton {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setTitle:@"分享" forState:(UIControlStateNormal)];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFixedSpace) target:nil action:nil];
    item.width = -7;
    self.navigationItem.rightBarButtonItems = @[item,rightItem];
    [rightButton addTarget:self  action:@selector(didTouchRightButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTouchRightButton {
//    WeakSelf(self)
//    [self.shareView showShareView];
//    UserInfoModel *modelUser = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
//    NSString *shareURL = [NSString stringWithFormat:@"%@pennant/returnHtm/%@.htm",HTTP_BaseURL,self.model.bannerId];
//    OSMessage *msg = [[OSMessage alloc] init];
//    msg.title = modelUser.trueName;
//    msg.link = shareURL;
//    msg.desc = self.model.story;
//    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"锦旗_02"]);
//    msg.image = imageData;
//    self.shareView.blockQRCodeCompany = ^{
//
//    };
    [self.shareView share];
}

- (void)makeShareView {
    WeakSelf(self);
    UserInfoModel *modelUser = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *shareURL = [NSString stringWithFormat:@"%@pennant/returnHtm/%@.htm",HTTP_BaseURL,self.model.bannerId];
    self.shareView.URL = shareURL;
    self.shareView.shareTitle = modelUser.trueName;
    self.shareView.shareCompanyIntroduction = self.model.story;
    self.shareView.shareCompanyLogoImage = [UIImage imageNamed:@"锦旗_02"];
//    self.shareView.companyName = self.companyName.text;
    self.shareView.shareViewType = ZYCShareViewTypeCompanyOnly;
    self.shareView.blockQRCode1st = ^{
        FlowersStoryQRCodeViewController *controller = [FlowersStoryQRCodeViewController new];
        [controller.view setBackgroundColor:[UIColor whiteColor]];
        controller.title = @"锦旗故事";
        controller.labelTitle.text = @"锦旗--荣誉的象征";
        controller.imageViewQRCode.image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:shareURL imageViewWidth:100];
        controller.imageViewTop.image = [weakself convertViewToImage:weakself.topView];
        [weakself.navigationController pushViewController:controller animated:true];
    };
}

- (UIImage*)convertViewToImage:(UIView *)v {
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
