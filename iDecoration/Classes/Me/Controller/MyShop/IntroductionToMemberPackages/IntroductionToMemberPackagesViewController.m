//
//  IntroductionToMemberPackagesViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/8/29.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "IntroductionToMemberPackagesViewController.h"
#import "ZYCShareView.h"
#import "IntroductionToMemberPackagesCollectionViewCell.h"
#import "IntroductionToMemberPackagesModel.h"

@interface IntroductionToMemberPackagesViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>
@property (strong, nonatomic) ZYCShareView *shareView;
@property (strong, nonatomic) UIButton *buttonShare;
@property (strong, nonatomic) UIButton *buttonPay;
@property (strong, nonatomic) NSMutableArray *arrayData;
@end

@implementation IntroductionToMemberPackagesViewController

- (void)Network {
    NSString *URL = @"agency/getListByCityId.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"companyId"] = self.companyId;
    [NetWorkRequest getJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        if ([result[@"code"] integerValue] == 1000) {
            self.arrayData = [NSArray yy_modelArrayWithClass:[IntroductionToMemberPackagesModel class] json:result[@"adviserList"]].mutableCopy;
        }
    } fail:^(id error) {

    }];
}

- (NSMutableArray *)arrayData {
    if (!_arrayData) {
        _arrayData = @[].mutableCopy;
    }
    return _arrayData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"同城套餐";
    [self Network];
    id obj = [UIApplication sharedApplication].keyWindow.subviews.lastObject;
    if ([NSStringFromClass([obj class]) isEqualToString:@"UIView"]) {
        [[UIApplication sharedApplication].keyWindow.subviews.lastObject removeFromSuperview];
    }
}

- (void)setUpUI {
    [super setUpUI];
    self.buttonPay = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:self.buttonPay];
    [self.buttonPay setTitle:@"开通" forState:(UIControlStateNormal)];
    [self.buttonPay setBackgroundColor:basicColor forState:(UIControlStateNormal)];
    [self.buttonPay setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.buttonPay addTarget:self action:@selector(didTouchButtonPay) forControlEvents:(UIControlEventTouchUpInside)];

    self.buttonShare = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:self.buttonShare];
    [self.buttonShare setTitle:@"分享" forState:(UIControlStateNormal)];
    [self.buttonShare setBackgroundColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.buttonShare setTitleColor:basicColor forState:(UIControlStateNormal)];
    [self.buttonShare addTarget:self action:@selector(didTouchButtonShare) forControlEvents:(UIControlEventTouchUpInside)];
    [self makeShareView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.offset(-50);
    }];
    [self.buttonShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.height.offset(50);
        make.width.offset(0.3*kSCREEN_WIDTH);
    }];
    [self.buttonPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(0);
        make.height.offset(50);
        make.width.offset(0.7*kSCREEN_WIDTH);
    }];
}

- (void)makeShareView {
    self.shareView = [ZYCShareView sharedInstance];
    self.shareView.URL = self.webUrl;
    self.shareView.shareTitle = @"同城套餐";
    self.shareView.shareCompanyIntroduction = [NSString stringWithFormat:@"线上线下同步运营，帮助商家在爱装修同城内稳步提升收单数量"];
    self.shareView.shareViewType = ZYCShareViewTypeNone;
}

- (void)didTouchButtonPay {
    if (self.arrayData.count) {
        [self makeExclusiveConsultantView];
    }
}

- (void)didTouchButtonShare {
    [self.shareView share];
}

- (void)makeExclusiveConsultantView {
    //ExclusiveConsultantBackgroundView
    UIView *ecViewBG = [UIView new];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BGHIDDEN:)];
    tap.delegate = self;
    [ecViewBG addGestureRecognizer:tap];
    ecViewBG.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:ecViewBG];
    ecViewBG.userInteractionEnabled = true;
    [ecViewBG setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    //Layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(kSCREEN_WIDTH - 80, 350);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //collectionview
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:layout];
    [ecViewBG addSubview:collectionView];
    collectionView.X = 40;
    collectionView.width = kSCREEN_WIDTH - 80;
    collectionView.Y = 150 * Yrang;
    collectionView.height = 350;
    collectionView.layer.cornerRadius = 4;
    collectionView.layer.masksToBounds = true;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = true;
    [collectionView registerNib:[UINib nibWithNibName:@"IntroductionToMemberPackagesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"IntroductionToMemberPackagesCollectionViewCell"];

    [collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IntroductionToMemberPackagesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IntroductionToMemberPackagesCollectionViewCell" forIndexPath:indexPath];
    IntroductionToMemberPackagesModel *model = self.arrayData[indexPath.item];
    cell.model = model;
    return cell;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view.subviews.count == 1) {
        return YES;
    }else
        return NO;
}

- (void)BGHIDDEN:(UITapGestureRecognizer *)sender {
    [sender.view removeFromSuperview];
}
@end
