//
//  EditBannerViewController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "EditBannerViewController.h"
#import "PlaceHolderTextView.h"
#import "AppleIAPManager.h"
#import "LoginViewController.h"
#import "JinQiViewController.h"

@interface EditBannerViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIScrollView *templateScrollView;

@property (nonatomic, strong) UIImageView *bannerImageView; // 锦旗
@property (nonatomic, strong) UILabel *sendNameLabel; // 送者名字
@property (nonatomic, strong) UILabel *acceptNameLabel; // 接收者名字
@property (nonatomic, strong) UILabel *timeLabel; // 时间
@property (nonatomic, strong) UILabel *rightCLabel; // 两行内容时右侧的内容
@property (nonatomic, strong) UILabel *leftCLabel; // 两行内容时左侧的内容
@property (nonatomic, strong) UILabel *middleCLabel; // 一行内容时的内容

@property (nonatomic, strong) UILabel *zhuLabel;

@property (nonatomic, strong) UITextField *acceptTF;
@property (nonatomic, strong) UITextField *sendTF;
@property (nonatomic, strong) UITextField *contentTF;
@property (nonatomic, strong) PlaceHolderTextView *leaveWordsTV;
@property (nonatomic, strong) PlaceHolderTextView *bannerStoryTV;

@property (nonatomic, assign)NSInteger type; // 默认0

@property (nonatomic, strong) NSString *bannerID;
@property (nonatomic, strong) NSMutableDictionary *paramDic;
@end

@implementation EditBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑锦旗";
    self.paramDic =[[NSMutableDictionary alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self scrollView];
    [self topView];
    [self bottomView];
    [self buildBtn];
    [self templateScrollView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _type = 0;
    self.bannerID = @"";

    UIBarButtonItem *rightItem = [UIBarButtonItem rightItemWithTitle:@"去支付" target:self action:@selector(finishiAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
  
}

#pragma mark 保存数据 获取pennentId 锦旗i
- (void)finishiAction {
//    if (![self showAction]) {
//        return;
//    }
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"pennant/save.do"];
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    // 参数的type：解释
    /*
     大锦旗：1000 ~ 1005 六个
     小锦旗： 2000 ~
     */
    NSInteger bannerType = 1000 + _type;
    [self.paramDic setObject:@(userModel.agencyId) forKey:@"agencyId"];
    [self.paramDic setObject:self.agencyId?:@(0) forKey:@"personId"];
        [self.paramDic setObject:@(bannerType) forKey:@"type"];
        [self.paramDic setObject:self.sendTF.text.length>0?self.sendTF.text:@(userModel.agencyId) forKey:@"signName"];
        [self.paramDic setObject:self.acceptTF.text.length>0?self.acceptTF.text:(self.isSendToCompany?
         self.companyId:self.agencyId )forKey:@"receName"];
        [self.paramDic setObject: self.bannerStoryTV.text.length > 0?self.bannerStoryTV.text: @"留言内容" forKey:@"story"];
        [self.paramDic setObject:self.leaveWordsTV.text.length > 0?self.leaveWordsTV.text:@"故事内容" forKey:@"leaveWord"];
        [self.paramDic setObject:self.contentTF.text.length > 0?self.contentTF.text:@"工艺精湛  服务一流" forKey:@"content"];
        [self.paramDic setObject:@(0) forKey: @"id"];
        [self.paramDic setObject:self.companyId ?:@(0) forKey:@"companyId"];
        [self.paramDic setObject:self.isSendToCompany?@(1):@(0) forKey: @"receiveType"];
    
 
//       _paramDic = @{
//                                   @"agencyId": @(userModel.agencyId),
//                                   @"personId": self.agencyId,
//                                   @"type": @(bannerType),
//                                   @"signName": self.sendTF.text?:self.sendTF.placeholder,
//                                   @"receName": self.acceptTF.text?:self.acceptTF.placeholder,
//                                   @"story": self.bannerStoryTV.text.length > 0?self.bannerStoryTV.text: @"留言",
//                                   @"leaveWord": self.leaveWordsTV.text?:self.leaveWordsTV.placeHolder,
//                                   @"content": self.contentTF.text?:self.contentTF.placeholder,
//                                   @"id": @(0),
//                                   @"companyId":self.companyId,
//                                   @"receiveType": self.isSendToCompany?@(1):@(0) //接收人类型（0:送给个人，1:送给公司）
//                                   };
   
    
    [NetManager afPostRequest:defaultApi parms:self.paramDic finished:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1000) {
            self.bannerID = [NSString stringWithFormat:@"%ld", [responseObj[@"data"][@"pennantId"] integerValue]];
          
          
            JinQiViewController *jinqi =[[JinQiViewController alloc]init];
            if (self.isSendToCompany) {
                jinqi.companyId =self.companyId;
            }else{
                 jinqi.agencyId=self.agencyId;
            }
            jinqi.penentID =self.bannerID;
          
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[JinQiViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                  }
            }
            
           
        
         
         
           
        }
    } failed:^(NSString *errorMsg) {
        
    }];
    
    
}








- (BOOL)showAction {
    [self.view endEditing:YES];
    
    if ([self.contentTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入锦旗内容"];
        return NO;
    }
    if ([self.acceptTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入您赠送给的用户"];
        return NO;
    }
    if ([self.sendTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入您的署名"];
        return NO;
    }
    if ([self.leaveWordsTV.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入您要对TA说的话"];
        return NO;
    }
    
    if (_type == 2 || _type == 5) {
        if (self.contentTF.text.length >8) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"此模板内容最多8个字"];
            return NO;
        }
    } else {
        if (self.contentTF.text.length >16) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"此模板内容最多16个字"];
            return NO;
        }
        
        if (_type == 0 || _type == 3) {
            if (self.contentTF.text.length % 4 != 0) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"此模板内容字数需为4的倍数"];
                return NO;
            }
            
        } else {
            if (self.contentTF.text.length % 2 != 0) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"此模板内容字数需双数"];
                return NO;
            }
        }
        
    }
    
    self.sendNameLabel.text = self.sendTF.text;
    self.acceptNameLabel.text = self.acceptTF.text;
    if (_type == 2 || _type == 5) {
        self.middleCLabel.text = self.contentTF.text;
    } else {
        if (_type == 0 || _type == 3) {
            NSString *leftStr = [self.contentTF.text substringFromIndex:self.contentTF.text.length/2];
            NSString *rightStr = [self.contentTF.text substringToIndex:self.contentTF.text.length/2];
            self.leftCLabel.text = [NSString stringWithFormat:@"%@\n\n%@", [leftStr substringToIndex:leftStr.length/2], [leftStr substringFromIndex:leftStr.length/2]];
            self.rightCLabel.text = [NSString stringWithFormat:@"%@\n\n%@", [rightStr substringToIndex:rightStr.length/2], [rightStr substringFromIndex:rightStr.length/2]];
            
        } else {
            self.leftCLabel.text = [self.contentTF.text substringFromIndex:self.contentTF.text.length/2];
            self.rightCLabel.text = [self.contentTF.text substringToIndex:self.contentTF.text.length/2];
        }
    }
    
    return YES;
}

- (void)plateAction {
    [UIView animateWithDuration:0.25 animations:^{
       self.templateScrollView.Y = kSCREEN_HEIGHT - 200;
    }];
}

- (void)plateImageViewTapAction:(UITapGestureRecognizer *)tapGR {
    [UIView animateWithDuration:0.25 animations:^{
        self.templateScrollView.Y = kSCREEN_HEIGHT;
    }];
    UIImageView *imageV = (UIImageView *)tapGR.view;
    NSInteger tagValue = imageV.tag;
    _type= tagValue;
    if (tagValue == 2 || tagValue == 5) {
        self.zhuLabel.text = @"赠名最多12字，内容最多8字，留名最多12字";
        self.rightCLabel.hidden = YES;
        self.leftCLabel.hidden = YES;
        self.middleCLabel.hidden = NO;
    } else {
        self.zhuLabel.text = @"赠名最多12字，内容最多16字，留名最多12字";
        self.rightCLabel.hidden = NO;
        self.leftCLabel.hidden = NO;
        self.middleCLabel.hidden = YES;
    }
    
    switch (tagValue) {
        case 0:{
            self.bannerImageView.image = [UIImage imageNamed:@"bg_big_jinqi_one"];
            self.acceptNameLabel.text = @"XX科技有限公司";
            self.rightCLabel.text = @"团结友爱\n\n共同进退";
            self.leftCLabel.text = @"团结友爱\n\n共同进退";
            self.sendNameLabel.text = @"XX科技有限公司";
        }
            break;
        case 1:{
            self.bannerImageView.image = [UIImage imageNamed:@"bg_big_jinqi_one"];
            self.acceptNameLabel.text = @"XX科技有限公司";
            self.rightCLabel.text = @"专心服务";
            self.leftCLabel.text = @"快乐装修";
            self.sendNameLabel.text = @"XX科技有限公司";
        }
            break;
        case 2:{
            self.bannerImageView.image = [UIImage imageNamed:@"bg_big_jinqi_one"];
            self.acceptNameLabel.text = @"XX科技有限公司";
            self.middleCLabel.text = @"施工精湛";
            self.sendNameLabel.text = @"XX科技有限公司";
        }
            break;
        case 3:{
            self.bannerImageView.image = [UIImage imageNamed:@"bg_big_jinqi_two"];
            self.acceptNameLabel.text = @"XX科技有限公司";
            self.rightCLabel.text = @"团结友爱\n\n共同进退";
            self.leftCLabel.text = @"团结友爱\n\n共同进退";
            self.sendNameLabel.text = @"XX科技有限公司";
        }
            break;
        case 4:{
            self.bannerImageView.image = [UIImage imageNamed:@"bg_big_jinqi_two"];
            self.acceptNameLabel.text = @"XX科技有限公司";
            self.rightCLabel.text = @"专心服务";
            self.leftCLabel.text = @"快乐装修";
            self.sendNameLabel.text = @"XX科技有限公司";
        }
            break;
        case 5:{
            self.bannerImageView.image = [UIImage imageNamed:@"bg_big_jinqi_two"];
            self.acceptNameLabel.text = @"XX科技有限公司";
            self.middleCLabel.text = @"施工精湛";
            self.sendNameLabel.text = @"XX科技有限公司";
        }
            break;
        default:
            break;
    }
    
    
}

#pragma UIScrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        [UIView animateWithDuration:0.25 animations:^{
            self.templateScrollView.Y = kSCREEN_HEIGHT;
        }];
    }
}

- (void)buildBtn {
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showBtn setTitle:@"预览" forState:UIControlStateNormal];
    [showBtn setBackgroundColor:kMainThemeColor];
    [showBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:showBtn];
    [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.top.equalTo(kSCREEN_WIDTH - 50);
        make.size.equalTo(CGSizeMake(46, 46));
    }];
    showBtn.layer.cornerRadius = 23;
    showBtn.layer.masksToBounds = YES;
    showBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [showBtn addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *plateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [plateBtn setTitle:@"模板" forState:UIControlStateNormal];
    [plateBtn setBackgroundColor:kCustomColor(250, 250, 250)];
    [plateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:plateBtn];
    [plateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.top.equalTo(showBtn.mas_bottom).equalTo(15);
        make.size.equalTo(CGSizeMake(46, 46));
    }];
    plateBtn.layer.cornerRadius = 23;
    plateBtn.layer.masksToBounds = YES;
    plateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [plateBtn addTarget:self action:@selector(plateAction) forControlEvents:UIControlEventTouchUpInside];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(0);
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT - kNaviBottom));
        }];
        _scrollView.scrollEnabled = YES;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, kSCREEN_WIDTH + 48 + 41 * 4 + 90 * 2);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
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
        sendNameLabel.text = @"北京比邻而居科技有限公司";

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
        contentL1.text = @"团结友爱共同成长";

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
        contentL2.text = @"团结友爱共同成长";

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
        contentL3.text = @"团结友爱共同成长";
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
        timeLabel.text = @"二零一七年十一月二十一日";

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
        acceptLabel.text = @"亿邦装品";
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
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH, 48 + 41 * 4 + 90 * 2));
        }];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIView *expalinView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 48)];
        [_bottomView addSubview:expalinView];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16, 16, 16)];
        imageV.image = [UIImage imageNamed:@"icon_banner_zhushi"];
        [expalinView addSubview:imageV];
        UILabel *expalinLabel = [UILabel new];
        [expalinView addSubview:expalinLabel];
        [expalinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageV.mas_right).equalTo(10);
            make.right.equalTo(10);
            make.centerY.equalTo(0);
        }];
        expalinLabel.font = [UIFont systemFontOfSize:15];
        expalinLabel.textColor = kCustomColor(152, 152, 152);
        expalinView.backgroundColor = kCustomColor(242, 242, 242);
        expalinLabel.text = @"赠名最多12字，内容最多16字，留名最多12字";
        self.zhuLabel = expalinLabel;

        NSArray *nameArray = @[@"赠名", @"内容", @"署名", @"日期", @"留言", @"故事"];
        NSArray *placeArray = @[@"请输入您赠给的用户(必填项)", @"请输入您要输入的内容(必填项)", @"请输入您的署名(必填项)", @"", @"请输入您想对他(她)说的话(必填项)", @"请填写购买锦旗的故事"];
        for (int i = 0; i <4; i ++) {
            UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(0, expalinView.bottom + i * (41), kSCREEN_WIDTH, 41)];
            cView.backgroundColor = [UIColor whiteColor];
            [_bottomView addSubview:cView];

            UIView *lineView = [UIView new];
            [cView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(0);
                make.height.equalTo(1);
            }];
            lineView.backgroundColor = kCustomColor(242, 242, 242);

            UILabel *nameL = [UILabel new];
            [cView addSubview:nameL];
            [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(15);
                make.centerY.equalTo(0);
            }];
            nameL.font = [UIFont systemFontOfSize:15];
            nameL.textColor = kCustomColor(103, 103, 103);
            nameL.text = nameArray[i];

            UITextField *tf = [[UITextField alloc] init];
            [cView addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(nameL.mas_right).equalTo(13);
                make.top.equalTo(0);
                make.bottom.equalTo(-1);
                make.width.equalTo(kSCREEN_WIDTH - 15 - 13 - 15 - nameL.width);
            }];
            tf.borderStyle = UITextBorderStyleNone;
            tf.placeholder = placeArray[i];
            if (i == 3) {
                tf.userInteractionEnabled = NO;
                tf.text = [NSDate curentYearMonthDay];
                
            }
            tf.textColor = kCustomColor(103, 103, 103);
            tf.font = [UIFont systemFontOfSize:15];
            if (i == 0) {
                self.acceptTF = tf;
            }
            if (i == 1) {
                self.contentTF = tf;
            }
            if (i == 2) {
                self.sendTF = tf;
            }
        }
        for (int i = 0; i < 2; i ++) {
            UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(0, expalinView.bottom + 4 * (41) + i * 90, kSCREEN_WIDTH, 90)];
            cView.backgroundColor = [UIColor whiteColor];
            [_bottomView addSubview:cView];

            UIView *lineView = [UIView new];
            [cView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(0);
                make.height.equalTo(1);
            }];
            lineView.backgroundColor = kCustomColor(242, 242, 242);

            UILabel *nameL = [UILabel new];
            [cView addSubview:nameL];
            [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(15);
                make.centerY.equalTo(0);
            }];
            nameL.font = [UIFont systemFontOfSize:15];
            nameL.textColor = kCustomColor(103, 103, 103);
            nameL.text = nameArray[i + 4];

            PlaceHolderTextView *pTV = [[PlaceHolderTextView alloc] init];
            [cView addSubview:pTV];
            [pTV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(nameL.mas_right).equalTo(13);
                make.right.equalTo(-15);
                make.top.equalTo(0);
                make.bottom.equalTo(-1);
            }];
            pTV.font = [UIFont systemFontOfSize:15];
            pTV.textColor = kCustomColor(103, 103, 103);
            pTV.placeHolder = placeArray[i + 4];
            if (i == 0) {
                self.leaveWordsTV = pTV;
            }
            if (i == 2) {
                self.bannerStoryTV = pTV;
            }
        }
        
        
    }
    return _bottomView;
}


- (UIScrollView *)templateScrollView {
    if (_templateScrollView == nil) {
        _templateScrollView = [UIScrollView new];
        [self.view addSubview:_templateScrollView];
        _templateScrollView.frame = CGRectMake(0, kSCREEN_HEIGHT - 200, kSCREEN_WIDTH, 200);
        _templateScrollView.backgroundColor = [UIColor whiteColor];
        CGFloat height = 160; // 模板锦旗高
        CGFloat widht = 160 * 53.0/68.0; // 模板锦旗宽
        NSArray *imageNameArr = @[@"img_small_jinqi_one", @"img_small_jinqi_three", @"img_small_jinqi_two", @"img_small_jinqi_four", @"img_small_jinqi_five", @"img_small_jinqi_six"];
        for (int i = 0; i < 6; i ++) {
            UIImageView *platView = [[UIImageView alloc] initWithFrame:CGRectMake(8+ i *(widht + 16), 20, widht, height)];
            [_templateScrollView addSubview:platView];
            platView.tag = i;
            platView.image = [UIImage imageNamed:imageNameArr[i]];
            platView.contentMode = UIViewContentModeScaleAspectFill;
            platView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(plateImageViewTapAction:)];
            [platView addGestureRecognizer:tapGR];
            
        }
        _templateScrollView.contentSize = CGSizeMake(6 * (widht + 16), 200);
        _templateScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _templateScrollView;
}
@end
