//
//  ZCHMyPersonCardController.m
//  iDecoration
//
//  Created by 赵春浩 on 2017/12/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHMyPersonCardController.h"
#import "SiteModel.h"
#import "BeautifulArtListModel.h"
#import "ZCHCaseAndBeautyController.h"
#import "DecorateInfoNeedView.h"
#import "BLEJBudgetGuideController.h"
#import "DecorateNeedViewController.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
#import "DecorateCompletionViewController.h"
#import "BLEJCalculatorGetTempletByCompanyId.h"
#import "BLEJCalculatorBaseAndSuppleListModel.h"
#import "ZCHBudgetGuideConstructionCaseModel.h"
#import "CompanyDetailViewController.h"
#import "ShopDetailViewController.h"
#import "ZCHCalculatorItemsModel.h"
#import "BLRJCalculatortempletModelAllCalculatorcompanyData.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"

@interface ZCHMyPersonCardController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *editBtn;

@property (strong, nonatomic) NSMutableDictionary *cardDic;
@property (strong, nonatomic) NSMutableDictionary *companyDic;

@property (strong, nonatomic) UIImageView *topImageView;
@property (strong, nonatomic) UITextView *textView;

// 选择完照片之后的bgView
@property (strong, nonatomic) UIView *imageBgView;
@property (strong, nonatomic) NSData *imageData;

// 存储要保存的图片url
@property (strong, nonatomic) NSMutableString *imageUrl;

@property (strong, nonatomic) NSMutableArray *caseArr;
@property (strong, nonatomic) NSMutableArray *beautyArr;
@property (strong, nonatomic) NSMutableArray *areaArr;

@property (strong, nonatomic) UIView *shadowView;
@property (strong, nonatomic) UIView *bottomShareView;
@property (strong, nonatomic) UIView *TwoDimensionCodeView;
// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@property (strong, nonatomic) UIButton *shareBtn;

@property (strong, nonatomic) NSMutableArray *phoneArr;
@property (nonatomic, strong) DecorateInfoNeedView *infoView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *collectionBtn;

// 新添加的模板
@property (strong, nonatomic) NSMutableArray *suppleListArr;
// 基础模板
@property (strong, nonatomic) NSMutableArray *baseItemsArr;
// 基础模板中的其他信息
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *calculatorTempletModel;
// 预算报价的顶部图片
@property (strong, nonatomic) NSMutableArray *topCalculatorImageArr;
// 预算报价的底部图片
@property (strong, nonatomic) NSMutableArray *bottomCalculatorImageArr;
// 施工案例
@property (strong, nonatomic) NSMutableArray *constructionCase;
@property (assign, nonatomic) NSInteger code;

@end

@implementation ZCHMyPersonCardController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"名 片";
    self.dataArray = [NSMutableArray array];
    self.imageUrl = [NSMutableString string];
    self.companyDic = [NSMutableDictionary dictionary];
    self.caseArr = [NSMutableArray array];
    self.beautyArr = [NSMutableArray array];
    self.areaArr = [NSMutableArray array];
    
    self.phoneArr = [NSMutableArray array];
    
    self.suppleListArr = [NSMutableArray array];
    self.baseItemsArr = [NSMutableArray array];
    self.topCalculatorImageArr = [NSMutableArray array];
    self.bottomCalculatorImageArr = [NSMutableArray array];
    self.constructionCase = [NSMutableArray array];
    self.code = -1;
    
    self.view.backgroundColor = White_Color;
    [self setUpUI];
    [self getData];
}

- (void)setUpUI {
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    if (self.isMe) {
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    } else {
        [editBtn setTitle:@"分享" forState:UIControlStateNormal];
    }
    
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(didClickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.editBtn = editBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    CGFloat naviBottom = kSCREEN_HEIGHT - self.navigationController.navigationBar.bottom - 50;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom) style:UITableViewStylePlain];
    self.tableView.backgroundColor = White_Color;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
    [self.view addSubview:self.tableView];
    
    // 单独处理这里的返回按钮(因为需要返回到根控制器)
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
    if (self.isMe) {
        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, BLEJHeight - 50, BLEJWidth, 50)];
        [shareBtn setBackgroundColor:kMainThemeColor];
        [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(didClickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.shareBtn = shareBtn;
        self.shareBtn.hidden = YES;
        [self.view addSubview:shareBtn];
    }
}

#pragma mark - 分享按钮的点击事件
- (void)didClickShareBtn:(UIButton *)btn {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomShareView.blej_y = BLEJHeight - (BLEJWidth * 0.5 + 70);
        self.shadowView.hidden = NO;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 返回按钮的点击事件
- (void)back {
    
    [self.view endEditing:YES];
    if ([self.editBtn.titleLabel.text isEqualToString:@"完成"]) {
        
        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"您还没有保存，是否继续退出？" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
        [alertView show];
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 编辑按钮的点击事件
- (void)didClickEditBtn:(UIButton *)btn {
    
    if ([btn.titleLabel.text isEqualToString:@"分享"]) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomShareView.blej_y = BLEJHeight - (BLEJWidth * 0.5 + 70);
            self.shadowView.hidden = NO;
        } completion:^(BOOL finished) {
            
        }];
        return;
    }
    
    if ([btn.titleLabel.text isEqualToString:@"编辑"]) {
        
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        self.tableView.frame = CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, BLEJHeight - self.navigationController.navigationBar.bottom);
        self.shareBtn.hidden = YES;
        [self.tableView reloadData];
    } else {
        
        if ([self.cardDic objectForKey:@"coverMap"] && ![[self.cardDic objectForKey:@"coverMap"] isEqualToString:@""]) {
            [self secondSave];
        } else {
            [self firstSave];
        }
    }
    
//    [btn setTitle:([btn.titleLabel.text isEqualToString:@"编辑"] ? @"完成" : @"编辑") forState:UIControlStateNormal];
    
//    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.cardDic == nil) {
        return 0;
    } else if ([self.cardDic objectForKey:@"coverMap"] && ![[self.cardDic objectForKey:@"coverMap"] isEqualToString:@""] && ([self.editBtn.titleLabel.text isEqualToString:@"编辑"] || [self.editBtn.titleLabel.text isEqualToString:@"分享"])) {
        return 3;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.cardDic objectForKey:@"coverMap"] && ![[self.cardDic objectForKey:@"coverMap"] isEqualToString:@""] && ([self.editBtn.titleLabel.text isEqualToString:@"编辑"] || [self.editBtn.titleLabel.text isEqualToString:@"分享"])) {
        if (self.isMe) {
            self.shareBtn.hidden = NO;
        }
        if (indexPath.row == 0) {
            
            UITableViewCell *photoCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, kSCREEN_WIDTH * 0.6)];
            photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, kSCREEN_WIDTH * 0.6)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.cardDic[@"coverMap"]] placeholderImage:nil];
            self.topImageView = nil;
            [photoCell.contentView addSubview:imageView];
            
            UIButton *caseBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 50, kSCREEN_WIDTH * 0.6 - 30 - 5, 50, 30)];
            caseBtn.layer.cornerRadius = 5;
            [caseBtn setBackgroundColor:[UIColor lightGrayColor]];
            [caseBtn setTitleColor:White_Color forState:UIControlStateNormal];
            [caseBtn addTarget:self action:@selector(didClickCaseBtn:) forControlEvents:UIControlEventTouchUpInside];
            [caseBtn setTitle:@"案例" forState:UIControlStateNormal];
            caseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            if (self.caseArr.count == 0) {
                caseBtn.hidden = YES;
            } else {
                caseBtn.hidden = NO;
            }
            
            [imageView addSubview:caseBtn];
            
            UIButton *beautyBtn = [[UIButton alloc] initWithFrame:CGRectMake(caseBtn.left, caseBtn.top - 33, caseBtn.width, caseBtn.height)];
            beautyBtn.layer.cornerRadius = 5;
            [beautyBtn setBackgroundColor:[UIColor lightGrayColor]];
            [beautyBtn setTitleColor:White_Color forState:UIControlStateNormal];
            [beautyBtn addTarget:self action:@selector(didClickBeautyBtn:) forControlEvents:UIControlEventTouchUpInside];
            [beautyBtn setTitle:@"美文" forState:UIControlStateNormal];
            beautyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            if (self.beautyArr.count == 0) {
                beautyBtn.hidden = YES;
            } else {
                beautyBtn.hidden = NO;
            }
            [imageView addSubview:beautyBtn];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, beautyBtn.top, BLEJWidth - 100, 70)];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.font = [UIFont boldSystemFontOfSize:16];
            nameLabel.textColor = [UIColor grayColor];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.text = self.cardDic[@"trueName"];
            [photoCell.contentView addSubview:nameLabel];
            
            return photoCell;
        }
        if (indexPath.row == 1) {
            
            UITableViewCell *photoCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 80)];
            photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
//            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.companyDic[@"companyLogo"]] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
            [photoCell.contentView addSubview:imageView];
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 5, imageView.top, BLEJWidth - imageView.right - 15, imageView.height * 0.5)];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.font = [UIFont systemFontOfSize:14];
            nameLabel.text = self.companyDic[@"companyName"];
            [photoCell.contentView addSubview:nameLabel];
            
            UILabel *jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, nameLabel.width, nameLabel.height)];
            jobLabel.textAlignment = NSTextAlignmentLeft;
            jobLabel.font = [UIFont systemFontOfSize:14];
            jobLabel.text = self.companyDic[@"typeName"];
            [photoCell.contentView addSubview:jobLabel];
            
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, BLEJWidth, 5)];
            bottomView.backgroundColor = kBackgroundColor;
            [photoCell.contentView addSubview:bottomView];
            return photoCell;
        }
        if (indexPath.row == 2) {
            
            CGSize size = [self.cardDic[@"indu"] boundingRectWithSize:CGSizeMake(BLEJWidth - 20, MAXFLOAT) withFont:[UIFont systemFontOfSize:14]];
            UITableViewCell *photoCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, size.height + 20)];
            photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, BLEJWidth - 20, size.height)];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:14];
            label.numberOfLines = 0;
            label.text = self.cardDic[@"indu"];
            [photoCell.contentView addSubview:label];
            return photoCell;
        }
        
    } else if ([self.cardDic objectForKey:@"coverMap"] && ![[self.cardDic objectForKey:@"coverMap"] isEqualToString:@""] && [self.editBtn.titleLabel.text isEqualToString:@"完成"]) {
        if (indexPath.row == 0) {
            
            UITableViewCell *photoCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, kSCREEN_WIDTH * 0.6)];
            photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, kSCREEN_WIDTH * 0.6)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            imageView.userInteractionEnabled = YES;
            self.topImageView = imageView;
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.cardDic[@"coverMap"]] placeholderImage:nil];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTopImage:)];
            [imageView addGestureRecognizer:tap];
            
            [photoCell.contentView addSubview:imageView];
            
//            UIButton *caseBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 50, 200 - 30 - 5, 50, 30)];
//            caseBtn.layer.cornerRadius = 5;
//            [caseBtn setBackgroundColor:[UIColor lightGrayColor]];
//            [caseBtn setTitleColor:White_Color forState:UIControlStateNormal];
//            [caseBtn addTarget:self action:@selector(didClickCaseBtn:) forControlEvents:UIControlEventTouchUpInside];
//            [caseBtn setTitle:@"案例" forState:UIControlStateNormal];
//            caseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//            caseBtn.hidden = YES;
//            [imageView addSubview:caseBtn];
//            
//            UIButton *beautyBtn = [[UIButton alloc] initWithFrame:CGRectMake(caseBtn.left, caseBtn.top - 33, caseBtn.width, caseBtn.height)];
//            beautyBtn.layer.cornerRadius = 5;
//            [beautyBtn setBackgroundColor:[UIColor lightGrayColor]];
//            [beautyBtn setTitleColor:White_Color forState:UIControlStateNormal];
//            [beautyBtn addTarget:self action:@selector(didClickBeautyBtn:) forControlEvents:UIControlEventTouchUpInside];
//            [beautyBtn setTitle:@"美文" forState:UIControlStateNormal];
//            beautyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//            beautyBtn.hidden = YES;
//            [imageView addSubview:beautyBtn];
//            
//            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, beautyBtn.top, BLEJWidth - 100, 70)];
//            nameLabel.textAlignment = NSTextAlignmentLeft;
//            nameLabel.font = [UIFont boldSystemFontOfSize:16];
//            nameLabel.textColor = [UIColor grayColor];
//            nameLabel.textAlignment = NSTextAlignmentCenter;
//            nameLabel.text = self.cardDic[@"trueName"];
//            nameLabel.hidden = YES;
//            [photoCell.contentView addSubview:nameLabel];
            
            return photoCell;
        }
//        if (indexPath.row == 1) {
//
//            UITableViewCell *photoCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 80)];
//            photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
//            //            imageView.contentMode = UIViewContentModeScaleAspectFit;
//            [imageView sd_setImageWithURL:[NSURL URLWithString:self.companyDic[@"companyLogo"]] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
//            [photoCell.contentView addSubview:imageView];
//
//            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 5, imageView.top, BLEJWidth - imageView.right - 15, imageView.height * 0.5)];
//            nameLabel.textAlignment = NSTextAlignmentLeft;
//            nameLabel.font = [UIFont systemFontOfSize:14];
//            nameLabel.text = self.companyDic[@"companyName"];
//            [photoCell.contentView addSubview:nameLabel];
//
//            UILabel *jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, nameLabel.width, nameLabel.height)];
//            jobLabel.textAlignment = NSTextAlignmentLeft;
//            jobLabel.font = [UIFont systemFontOfSize:14];
//            jobLabel.text = self.companyDic[@"typeName"];
//            [photoCell.contentView addSubview:jobLabel];
//
//            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, BLEJWidth, 5)];
//            bottomView.backgroundColor = kBackgroundColor;
//            [photoCell.contentView addSubview:bottomView];
//            return photoCell;
//        }
        if (indexPath.row == 1) {
            
//            CGSize size = [self.cardDic[@"indu"] boundingRectWithSize:CGSizeMake(BLEJWidth - 20, MAXFLOAT) withFont:[UIFont systemFontOfSize:14]];
//            UITableViewCell *photoCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, size.height + 10)];
//            photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, BLEJWidth - 20, BLEJHeight - self.navigationController.navigationBar.bottom - 200 - 80 - 20)];
//            textView.backgroundColor = kBackgroundColor;
//            textView.font = [UIFont systemFontOfSize:14];
//            textView.layer.cornerRadius = 5;
//            textView.text = self.cardDic[@"indu"];
//            [photoCell.contentView addSubview:textView];
            
            UITableViewCell *photoCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight - self.navigationController.navigationBar.bottom - kSCREEN_WIDTH * 0.6)];
            photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            //            photoCell.contentView.backgroundColor = kBackgroundColor;
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 10)];
            bottomView.backgroundColor = kBackgroundColor;
            [photoCell.contentView addSubview:bottomView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, bottomView.bottom, BLEJWidth, 44)];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:16];
            label.text = @"编辑您的经历";
            [photoCell.contentView addSubview:label];
            
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, label.bottom, BLEJWidth - 20, BLEJHeight - self.navigationController.navigationBar.bottom - kSCREEN_WIDTH * 0.6 - 44 - 20 - 50)];
            textView.backgroundColor = kBackgroundColor;
            textView.layer.cornerRadius = 5;
            textView.font = [UIFont systemFontOfSize:14];
            textView.text = self.cardDic[@"indu"];
            [photoCell.contentView addSubview:textView];
            self.textView = textView;
            return photoCell;
            
            return photoCell;
        }
        
    } else {
        
        self.shareBtn.hidden = YES;
        [self.editBtn setTitle:@"完成" forState:UIControlStateNormal];
        if (indexPath.row == 0) {
            
            UITableViewCell *photoCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, kSCREEN_WIDTH * 0.6)];
            photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((BLEJWidth - 100) * 0.5, (kSCREEN_WIDTH * 0.6 - 130) * 0.5, 100, 100)];
            imageView.image = [UIImage imageNamed:@"personCard"];
//            imageView.contentMode = UIViewContentModeScaleAspectFit;
//            [imageView sd_setImageWithURL:[NSURL URLWithString:self.cardDic[@"coverMap"]] placeholderImage:nil];
            [photoCell.contentView addSubview:imageView];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom, BLEJWidth, 30)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:16];
            label.text = @"上传名牌封面图片";
            label.textColor = [UIColor lightGrayColor];
            [photoCell.contentView addSubview:label];
            
            UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, kSCREEN_WIDTH * 0.6)];
            topView.contentMode = UIViewContentModeScaleAspectFill;
            topView.layer.masksToBounds = YES;
            topView.userInteractionEnabled = YES;
            self.topImageView = topView;
//            [imageView sd_setImageWithURL:[NSURL URLWithString:self.cardDic[@"coverMap"]] placeholderImage:nil];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTopImage:)];
            [topView addGestureRecognizer:tap];
            [photoCell.contentView addSubview:topView];
            
            return photoCell;
        }
        if (indexPath.row == 1) {
            
            UITableViewCell *photoCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight - self.navigationController.navigationBar.bottom - kSCREEN_WIDTH * 0.6)];
            photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
//            photoCell.contentView.backgroundColor = kBackgroundColor;
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 10)];
            bottomView.backgroundColor = kBackgroundColor;
            [photoCell.contentView addSubview:bottomView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, bottomView.bottom, BLEJWidth, 44)];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:16];
            label.text = @"编辑您的经历";
            [photoCell.contentView addSubview:label];
            
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, label.bottom, BLEJWidth - 20, BLEJHeight - self.navigationController.navigationBar.bottom - kSCREEN_WIDTH * 0.6 - 44 - 20)];
            textView.backgroundColor = kBackgroundColor;
            textView.layer.cornerRadius = 5;
            textView.font = [UIFont systemFontOfSize:14];
            [photoCell.contentView addSubview:textView];
            self.textView = textView;
            return photoCell;
        }
    }
    return [[UITableViewCell alloc] init];
}

#pragma mark - 美文或者案例的点击事件
- (void)didClickBeautyBtn:(UIButton *)btn {// 美文
    
    ZCHCaseAndBeautyController *VC = [[ZCHCaseAndBeautyController alloc] init];
    VC.isCase = NO;
    VC.caseArr = self.caseArr;
    VC.beautyArr = self.beautyArr;
    VC.cardDic = self.cardDic;
    VC.companyDic = self.companyDic;
    VC.areaArr = self.areaArr;
    VC.agencyId = self.agencyId;
    __weak typeof(self) weakSelf = self;
    VC.block = ^(){
        [weakSelf getData];
    };
    VC.origin = @"2";
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didClickCaseBtn:(UIButton *)btn {// 案例
    
    ZCHCaseAndBeautyController *VC = [[ZCHCaseAndBeautyController alloc] init];
    VC.isCase = YES;
    VC.caseArr = self.caseArr;
    VC.beautyArr = self.beautyArr;
    VC.cardDic = self.cardDic;
    VC.companyDic = self.companyDic;
    VC.areaArr = self.areaArr;
    VC.agencyId = self.agencyId;
    __weak typeof(self) weakSelf = self;
    VC.block = ^(){
        [weakSelf getData];
    };
    VC.origin = @"2";
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        if ([self.cardDic objectForKey:@"coverMap"] && ![[self.cardDic objectForKey:@"coverMap"] isEqualToString:@""] && ([self.editBtn.titleLabel.text isEqualToString:@"编辑"] || [self.editBtn.titleLabel.text isEqualToString:@"分享"])) {
            
            if ([self.companyDic[@"companyType"] integerValue] == 1018 || [self.companyDic[@"companyType"] integerValue] == 1065 ||
                [self.companyDic[@"companyType"] integerValue] == 1064) {
                CompanyDetailViewController *VC = [[CompanyDetailViewController alloc] init];
                VC.companyID = self.companyDic[@"companyId"];
                VC.companyName = self.companyDic[@"companyName"];
                VC.origin = @"0";
                [self.navigationController pushViewController:VC animated:YES];
            } else {
                ShopDetailViewController *VC = [[ShopDetailViewController alloc] init];
                VC.shopID = self.companyDic[@"companyId"];
                VC.shopName = self.companyDic[@"companyName"];
                VC.origin = @"0";
                [self.navigationController pushViewController:VC animated:YES];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.cardDic objectForKey:@"coverMap"] && ![[self.cardDic objectForKey:@"coverMap"] isEqualToString:@""] && ([self.editBtn.titleLabel.text isEqualToString:@"编辑"] || [self.editBtn.titleLabel.text isEqualToString:@"分享"])) {
        
        if (indexPath.row == 0) {
            return kSCREEN_WIDTH * 0.6;
        } else if (indexPath.row == 1) {
            return 80;
        } else {
            CGSize size = [self.cardDic[@"indu"] boundingRectWithSize:CGSizeMake(BLEJWidth - 20, MAXFLOAT) withFont:[UIFont systemFontOfSize:14]];
            return size.height + 20;
        }
    } else if ([self.cardDic objectForKey:@"coverMap"] && ![[self.cardDic objectForKey:@"coverMap"] isEqualToString:@""] && [self.editBtn.titleLabel.text isEqualToString:@"完成"]) {
        
        if (indexPath.row == 0) {
            
            return kSCREEN_WIDTH * 0.6;
        } else {
            
            return BLEJHeight - self.navigationController.navigationBar.bottom - kSCREEN_WIDTH * 0.6;;
        }
    } else {
        if (indexPath.row == 0) {
            return kSCREEN_WIDTH * 0.6;
        } else {
            return BLEJHeight - self.navigationController.navigationBar.bottom - kSCREEN_WIDTH * 0.6;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

#pragma mark - 获取数据
- (void)getData {
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"businessCard/getByPersonId.do"];
    NSDictionary *param = @{
                            @"personId" : self.agencyId,
                            @"agencyId" : @(agencyid)
                            };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.caseArr removeAllObjects];
            [self.beautyArr removeAllObjects];
            self.cardDic = [NSMutableDictionary  dictionaryWithDictionary:responseObj[@"data"][@"model"]];
            self.companyDic = responseObj[@"data"][@"company"];
            if (self.cardDic[@"coverMap"] && ![self.cardDic[@"coverMap"] isEqualToString:@""]) {
                self.imageUrl = self.cardDic[@"coverMap"];
            }
            [self.caseArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[SiteModel class] json:responseObj[@"data"][@"conList"]]];
            [self.beautyArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[BeautifulArtListModel class] json:responseObj[@"data"][@"artList"]]];
            [self.areaArr removeAllObjects];
            for (NSDictionary *dict in responseObj[@"data"][@"areaList"]) {
                
                if (![self.areaArr containsObject:dict]) {
                    [self.areaArr addObject:dict];
                }
            }
            
            if (self.isMe) {
                
                if (self.shadowView == nil) {
                    [self addBottomShareView];
                }
            } else {
                
                if (self.bottomView == nil) {
                    [self addBottomView];
                    [self addBottomShareView];
                } else {
                    self.bottomView.hidden = NO;
                    self.collectionBtn.selected = ([self.cardDic[@"collectionId"] integerValue] == 0 ? NO : YES);
                }
                
                if ([self.companyDic[@"companyType"] integerValue] == 1018 || [self.companyDic[@"companyType"] integerValue] == 1065 ||
                    [self.companyDic[@"companyType"] integerValue] == 1064) {
                    [self getCalculatorData];
                } else {
                    
                }
            }
            
        } else {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
        }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
    }];
}

#pragma mark - 点击顶部图片换图片(相机 相册)
- (void)didClickTopImage:(UITapGestureRecognizer *)tap {
    
    // 先结束页面的编辑状态
    [self.view endEditing:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"相机", nil];
    actionSheet.tag = 10001;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 10001) {
        if (buttonIndex == 0 && [TTHelper checkPhotoLibraryAuthorizationStatus]) {
            
            //初始化UIImagePickerController
            UIImagePickerController *pickerImageVC = [[UIImagePickerController alloc]init];
            // 获取方式1：通过相册（呈现全部相册) UIImagePickerControllerSourceTypePhotoLibrary
            // 获取方式2，通过相机              UIImagePickerControllerSourceTypeCamera
            // 获取方法3，通过相册（呈现全部图片）UIImagePickerControllerSourceTypeSavedPhotosAlbum
            pickerImageVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            // 允许编辑，即放大裁剪
            pickerImageVC.allowsEditing = NO;
            // 自代理
            pickerImageVC.delegate = self;
            // 页面跳转
            [self presentViewController:pickerImageVC animated:YES completion:nil];
        } else if (buttonIndex == 1 && [TTHelper checkCameraAuthorizationStatus]) {
            // 通过相机的方式
            UIImagePickerController *pickerImageVC = [[UIImagePickerController alloc] init];
            // 获取方式:通过相机
            pickerImageVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerImageVC.allowsEditing = NO;
            pickerImageVC.delegate = self;
            pickerImageVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:pickerImageVC animated:YES completion:^{
                
                [pickerImageVC.view layoutIfNeeded];
            }];
        } else {
            
        }
    }
    
    if (actionSheet.tag == 10002) {
        
        if (self.phoneArr.count == 1) {
            if (buttonIndex == 0) {
                
                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArr[0]];
                UIWebView *callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            } else {
                
            }
        } else if (self.phoneArr.count == 2) {
            
            if (buttonIndex == 0) {
                
                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArr[0]];
                UIWebView *callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            } else if (buttonIndex == 1) {
                
                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArr[1]];
                UIWebView *callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            } else {
                
            }
        } else if (self.phoneArr.count == 3) {
            
            if (buttonIndex == 0) {
                
                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArr[0]];
                UIWebView *callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            } else if (buttonIndex == 1) {
                
                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArr[1]];
                UIWebView *callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            } else if (buttonIndex == 2) {
                
                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneArr[2]];
                UIWebView *callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            } else {
                
            }
        }
    }
}

#pragma mark - PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *image = [self turnImageWithInfo:info];
    self.imageData = [NSObject imageData:image];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
        view.backgroundColor = Black_Color;
        [picker.view addSubview:view];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:image];
        CGSize size = [self calculateImageSizeWithSize:image.size];
        iconView.size = CGSizeMake(size.width, size.height);
        iconView.center = view.center;
        self.imageBgView = view;
        [view addSubview:iconView];

        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight - 50, BLEJWidth, 50)];
        bottomView.backgroundColor = [Black_Color colorWithAlphaComponent:0.3];
        [view addSubview:bottomView];

        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        [cancelBtn setBackgroundColor:[UIColor clearColor]];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.textColor = White_Color;
        [cancelBtn addTarget:self action:@selector(didClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:cancelBtn];

        UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(BLEJWidth - 100, 0, 100, 50)];
        [confirmBtn setBackgroundColor:[UIColor clearColor]];
        [confirmBtn setTitle:@"使用照片" forState:UIControlStateNormal];
        confirmBtn.titleLabel.textColor = White_Color;
        [confirmBtn addTarget:self action:@selector(didClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:confirmBtn];
    } else {

        if ([self.imageData length] >0) {
            self.imageData = [GTMBase64 encodeData:self.imageData];
        }
        NSString *imageStr = [[NSString alloc] initWithData:self.imageData encoding:NSUTF8StringEncoding];
        [self uploadImageWithBase64Str:imageStr];
    }
}

#pragma mark - 计算图片按照比例显示
- (CGSize)calculateImageSizeWithSize:(CGSize)size {
    
    CGSize finalSize;
    if (size.width / BLEJWidth > size.height / BLEJHeight) {
        
        finalSize.width = size.width * BLEJWidth / size.width;
        finalSize.height = size.height * BLEJWidth / size.width;
    } else {
        
        finalSize.width = size.width * BLEJHeight / size.height;
        finalSize.height = size.height * BLEJHeight / size.height;
    }
    return finalSize;
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

#pragma mark - 选择完照片之后的确定与取消
- (void)didClickCancelBtn:(UIButton *)btn {// 取消

    [self.imageBgView removeFromSuperview];
}

- (void)didClickConfirmBtn:(UIButton *)btn {// 确定

    if ([self.imageData length] >0) {
        self.imageData = [GTMBase64 encodeData:self.imageData];
    }
    NSString *imageStr = [[NSString alloc] initWithData:self.imageData encoding:NSUTF8StringEncoding];
    [self uploadImageWithBase64Str:imageStr];
}

#pragma mark - 上传图片
- (void)uploadImageWithBase64Str:(NSString *)base64Str {

    [self dismissViewControllerAnimated:YES completion:nil];
    UploadImageApi *uploadApi = [[UploadImageApi alloc]initWithImgStr:base64Str type:@"png"];
    [self.view hudShow:@"上传图片中..."];
    [uploadApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [self.view textHUDHiddle];
        NSDictionary *dic = request.responseJSONObject;
        NSString *code = [dic objectForKey:@"code"];

        if ([code isEqualToString:@"1000"]) {

            self.imageUrl = dic[@"imageUrl"];
            self.topImageView.image = [UIImage imageWithData:[GTMBase64 decodeData:self.imageData]];
        } else {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"图片上传失败"];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view textHUDHiddle];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"图片上传失败, 请稍后重试"];
    }];
}

#pragma mark - 首次保存
- (void)firstSave {
    
    if (!self.imageUrl || [self.imageUrl isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请上传名片封面图"];
        return;
    }
    
    if (self.textView) {
        
        NSString *str = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *strTwo = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if ([strTwo isEqualToString:@""]) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请填写您的经历"];
            return;
        }
    } else {
        return;
    }
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"businessCard/save.do"];
    NSDictionary *param = @{
                            @"agencyId" : @(agencyid),
                            @"indu" : self.textView.text,
                            @"coverMap" : self.imageUrl
                            };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
            self.shareBtn.hidden = NO;
            self.tableView.frame = CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, BLEJHeight - self.navigationController.navigationBar.bottom - 50);
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"保存失败"];
        }
        [self getData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
    }];
}

#pragma mark - 编辑保存
- (void)secondSave {
    
    if (!self.imageUrl || [self.imageUrl isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请上传名片封面图"];
        return;
    }
    
    if (self.textView) {
        
        NSString *str = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *strTwo = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if ([strTwo isEqualToString:@""]) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请填写您的经历"];
            return;
        }
    } else {
        return;
    }
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"businessCard/update.do"];
    NSDictionary *param = @{
                            @"agencyId" : @(agencyid),
                            @"indu" : self.textView.text,
                            @"coverMap" : self.imageUrl,
                            @"cardId" : @([self.cardDic[@"cardId"] integerValue])
                            };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
            self.shareBtn.hidden = NO;
            self.tableView.frame = CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, BLEJHeight - self.navigationController.navigationBar.bottom - 50);
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"保存失败"];
        }
        [self getData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
    }];
}

#pragma mark - 添加底部视图
- (void)addBottomView {
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight - 50, BLEJWidth, 50)];
    bottomView.backgroundColor = White_Color;
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    if ([self.companyDic[@"companyType"] integerValue] == 1018 || [self.companyDic[@"companyType"] integerValue] == 1065 ||
        [self.companyDic[@"companyType"] integerValue] == 1064) {
        
        UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, bottomView.height)];
        [phoneBtn setImage:[UIImage imageNamed:@"bottomPhone"] forState:UIControlStateNormal];
        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [phoneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [phoneBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
        [phoneBtn addTarget:self action:@selector(didClickPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:phoneBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(phoneBtn.right, 0, 1, bottomView.height)];
        line.backgroundColor = kBackgroundColor;
        [bottomView addSubview:line];
        
        // 242 105 71
        UIButton *collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(phoneBtn.width + 1, 0, 80, bottomView.height)];
        [collectionBtn setImage:[UIImage imageNamed:@"noSelectCollection"] forState:UIControlStateNormal];
        [collectionBtn setImage:[UIImage imageNamed:@"selectCollection"] forState:UIControlStateSelected];
        collectionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [collectionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [collectionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
        [collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [collectionBtn setTitle:@"已收藏" forState:UIControlStateSelected];
        [collectionBtn addTarget:self action:@selector(didClickCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.collectionBtn = collectionBtn;
        self.collectionBtn.selected = ([self.cardDic[@"collectionId"] integerValue] == 0 ? NO : YES);
        [bottomView addSubview:collectionBtn];
        
        UIButton *priceBtn = [[UIButton alloc] initWithFrame:CGRectMake(collectionBtn.right, 0, (BLEJWidth - collectionBtn.right) * 0.5, bottomView.height)];
        priceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        priceBtn.backgroundColor = kCustomColor(242, 105, 71);
        [priceBtn setTitleColor:White_Color forState:UIControlStateNormal];
        [priceBtn setTitle:@"免费报价" forState:UIControlStateNormal];
        [priceBtn addTarget:self action:@selector(didClickPriceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:priceBtn];
        
        UIButton *houseBtn = [[UIButton alloc] initWithFrame:CGRectMake(priceBtn.right, 0, priceBtn.width, bottomView.height)];
        houseBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        houseBtn.backgroundColor = kMainThemeColor;
        [houseBtn setTitleColor:White_Color forState:UIControlStateNormal];
        [houseBtn setTitle:@"在线预约" forState:UIControlStateNormal];
//        [houseBtn addTarget:self action:@selector(didClickHouseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [houseBtn addTarget:self action:@selector(didClickAppointmentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:houseBtn];
        
    } else {
        
        UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, bottomView.height)];
        [phoneBtn setImage:[UIImage imageNamed:@"bottomPhone"] forState:UIControlStateNormal];
        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [phoneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [phoneBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
        [phoneBtn addTarget:self action:@selector(didClickPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:phoneBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(phoneBtn.right, 0, 1, bottomView.height)];
        line.backgroundColor = kBackgroundColor;
        [bottomView addSubview:line];
        
        UIButton *collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(phoneBtn.width + 1, 0, 100, bottomView.height)];
        [collectionBtn setImage:[UIImage imageNamed:@"noSelectCollection"] forState:UIControlStateNormal];
        [collectionBtn setImage:[UIImage imageNamed:@"selectCollection"] forState:UIControlStateSelected];
        collectionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [collectionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [collectionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
        [collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [collectionBtn setTitle:@"已收藏" forState:UIControlStateSelected];
        [collectionBtn addTarget:self action:@selector(didClickCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.collectionBtn = collectionBtn;
        self.collectionBtn.selected = ([self.cardDic[@"collectionId"] integerValue] == 0 ? NO : YES);
        [bottomView addSubview:collectionBtn];
        
        UIButton *appointmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(collectionBtn.right, 0, BLEJWidth - collectionBtn.right, bottomView.height)];
        appointmentBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        appointmentBtn.backgroundColor = kMainThemeColor;
        [appointmentBtn setTitleColor:White_Color forState:UIControlStateNormal];
        [appointmentBtn setTitle:@"在线预约" forState:UIControlStateNormal];
        [appointmentBtn addTarget:self action:@selector(didClickAppointmentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:appointmentBtn];
    }
}

#pragma mark - 底部视图的点击事件
- (void)didClickPhoneBtn:(UIButton *)btn {// 电话咨询
    
    [self.phoneArr removeAllObjects];
    
    if (!(!self.companyDic || self.companyDic[@"companyLandline"] == nil || [self.companyDic[@"companyLandline"] isEqualToString:@""])) {
        [self.phoneArr addObject:self.companyDic[@"companyLandline"]];
    }
    
    if (!(!self.companyDic || self.companyDic[@"companyPhone"] == nil || [self.companyDic[@"companyPhone"] isEqualToString:@""])) {
        [self.phoneArr addObject:self.companyDic[@"companyPhone"]];
    }
    if (!(!self.cardDic || self.cardDic[@"phone"] == nil || [self.cardDic[@"phone"] isEqualToString:@""])) {
        
        [self.phoneArr addObject:self.cardDic[@"phone"]];
    }
    if (self.phoneArr.count == 0) {
        return;
    }
    
    if (self.phoneArr.count == 2) {
        if ([self.phoneArr[0] isEqualToString:self.phoneArr[1]]) {
            [self.phoneArr removeLastObject];
        }
    }
    if (self.phoneArr.count == 3) {
        if ([self.phoneArr[1] isEqualToString:self.phoneArr[2]]) {
            [self.phoneArr removeLastObject];
        }
    }
    
    UIActionSheet *actionSheet;
    actionSheet.tag = 10002;
    if (self.phoneArr.count == 1) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], nil];
    } else if (self.phoneArr.count == 2) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], self.phoneArr[1], nil];
    } else if (self.phoneArr.count == 3) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], self.phoneArr[1], self.phoneArr[2], nil];
    }
    
    [actionSheet showInView:self.view];
}

- (void)didClickAppointmentBtn:(UIButton *)btn {// 预约
    
    self.infoView = [[NSBundle mainBundle] loadNibNamed:@"DecorateInfoNeedView" owner:nil options:nil].lastObject;
    self.infoView.frame = self.view.frame;
    [self.infoView.finishButton addTarget:self action:@selector(finishiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.infoView];
    // 店铺和公司的界面区别
    [self.infoView.areaTF removeFromSuperview];
    [self.infoView.timeTF removeFromSuperview];
    self.infoView.tipLabel.text = @"本公司业务人员会与您电话沟通，请确保电话畅通！     ";
//    self.infoView.tipLabelHeight.constant = 30;
    self.infoView.protocolImageTopToPhoneTFCon.constant = 6;
    
    MJWeakSelf;
    self.infoView.sendVertifyCodeBlock = ^{
        [weakSelf sendvertifyAction];
    };
    self.infoView.hidden = NO;
    
    // 在线预约浏览量
    [NSObject needDecorationStatisticsWithConpanyId:self.companyDic[@"companyId"]];
    
}

- (void)didClickPriceBtn:(UIButton *)btn {// 装修
    
    // 装修报价
    if (self.code == 1000) {
        
      
            
            BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
            VC.baseItemsArr = self.baseItemsArr;
            VC.suppleListArr = self.suppleListArr;
            VC.calculatorModel = self.calculatorTempletModel;
            VC.constructionCase = self.constructionCase;
            VC.companyID = self.companyDic[@"companyId"];
            VC.topImageArr = self.topCalculatorImageArr;
            VC.bottomImageArr = self.bottomCalculatorImageArr;
            VC.isConVip = self.companyDic[@"conVip"];
            [self.navigationController pushViewController:VC animated:YES];
//          if ([self.calculatorTempletModel.templetStatus isEqualToString:@"2"]) {
//        } else {
//
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司没有设置简装/精装报价"];
//        }
    } else if (self.code == -1) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"网络不畅，请稍后重试"];
    } else {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司没有设置模板"];
    }
}

- (void)didClickHouseBtn:(UIButton *)btn {// 量房
    
    DecorateNeedViewController *decoration = [[DecorateNeedViewController alloc]init];
    decoration.companyID = self.companyDic[@"companyId"];
    decoration.areaList = self.areaArr;
    decoration.companyType = @"1018";
    [self.navigationController pushViewController:decoration animated:YES];
}

#pragma mark - 收藏按钮的点击事件
- (void)didClickCollectionBtn:(UIButton *)btn {// 收藏(取消)
    
    BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
    if (!isLogin) { // 未登录
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请登录后再收藏"];
        
    } else {
        if (btn.selected) {
            
            [self unCollectionShopOrCompany];
        } else {
            
            [self saveShopOrCompany];
        }
        
    }
}


#pragma mark 在线咨询
- (void)callOthers {
    
    [self.phoneArr removeAllObjects];
    
    if (!(!self.companyDic || self.companyDic[@"companyLandline"] == nil || [self.companyDic[@"companyLandline"] isEqualToString:@""])) {
        [self.phoneArr addObject:self.companyDic[@"companyLandline"]];
    }
    
    if (!(!self.companyDic || self.companyDic[@"companyPhone"] == nil || [self.companyDic[@"companyPhone"] isEqualToString:@""])) {
        [self.phoneArr addObject:self.companyDic[@"companyPhone"]];
    }
    if (!(!self.cardDic || self.cardDic[@"phone"] == nil || [self.cardDic[@"phone"] isEqualToString:@""])) {
        [self.phoneArr addObject:self.cardDic[@"phone"]];
    }
    if (self.phoneArr.count == 0) {
        return;
    }
    UIActionSheet *actionSheet;
    actionSheet.tag = 10002;
    if (self.phoneArr.count == 1) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], nil];
    } else if (self.phoneArr.count == 2) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], self.phoneArr[1], nil];
    } else if (self.phoneArr.count == 3) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:self.phoneArr[0], self.phoneArr[1], self.phoneArr[2], nil];
    }
    
    [actionSheet showInView:self.view];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:self.phone style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self callPhone:self.phone];
//    }];
//    UIAlertAction *action3 = [UIAlertAction actionWithTitle:self.telPhone style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self callPhone:self.telPhone];
//    }];
//
//    [alert addAction:action1];
//
//    [alert addAction:action2];
//
//    if (self.telPhone.length > 0) {
//        [alert addAction:action3];
//    }
//
//    [self presentViewController:alert animated:YES completion:nil];
}

//- (void)callPhone:(NSString *)phone {
//
//    NSString *string = [NSString stringWithFormat:@"tel:%@",phone];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
//}

#pragma  mark - 发送验证码
- (void)sendvertifyAction {
    
    [self.infoView endEditing:YES];
    if (![self.infoView.phoneTF.text ew_justCheckPhone]) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的手机号"];
        return;
    }
    
    NSString* url = [NSString stringWithFormat:@"%@%@", BASEURL, @"callDecoration/sendPhoneCode.do"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.infoView.phoneTF.text forKey:@"phone"];
    [param setObject:self.companyDic[@"companyId"] forKey:@"companyId"];
    MJWeakSelf;
    [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
        
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码发送成功"];
                [weakSelf timelessWithSecond:120 button:weakSelf.infoView.sendVertifyBtn];
                break;
            case 1001:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"当月已喊过装修"];
                break;
            default:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"预约失败或操作过于频繁"];
                break;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)timelessWithSecond:(NSInteger)s button:(UIButton *)btn {
    
    __block int timeout = (int)s; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout <= 0) { //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
                btn.backgroundColor = kMainThemeColor;
            });
        } else {
            
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [btn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                btn.userInteractionEnabled = NO;
                btn.backgroundColor = kDisabledColor;
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
}

#pragma mark - 完成
- (void)finishiAction {
    
    if ([self.infoView.nameTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入您的姓名"];
        return;
    }
    if (![self.infoView.phoneTF.text ew_checkPhoneNumber]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的联系方式"];
        return;
    }
    if (self.infoView.vertifyCodeTF.text.length != 6) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入6位数的验证码"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.infoView.vertifyCodeTF.text forKey:@"phoneCode"];
    [dic setObject:self.infoView.phoneTF.text forKey:@"phone"];
    [dic setObject:self.infoView.nameTF.text forKey:@"fullName"];
    [dic setObject:self.companyDic[@"companyId"] forKey:@"companyId"];
    [dic setObject:self.companyDic[@"companyType"] forKey:@"companyType"];
    [dic setObject:@"0" forKey:@"province"];
    [dic setObject:@"0" forKey:@"county"];
    [dic setObject:@"0" forKey:@"city"];
    [self upDataRequest:dic];
}

- (void)upDataRequest:(NSMutableDictionary *)dic {
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    __weak typeof(self)  weakSelf = self;
    NSString *url = [BASEURL stringByAppendingString:@"callDecoration/save.do"];
    [NetManager  afGetRequest:url parms:dic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        
        switch ([responseObj[@"code"] integerValue]) {
                //喊装修成功
            case 1000:
            {
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您已提交成功请等待回复"];
                
                // 睡一秒
                [NSThread sleepForTimeInterval:1];
                
                DecorateCompletionViewController *completionVC = [[DecorateCompletionViewController alloc] init];
                completionVC.dataDic = responseObj[@"data"];
                completionVC.companyType = weakSelf.companyDic[@"companyType"];
                [self.navigationController pushViewController:completionVC animated:YES];
                break;
            }
            case 1001:
                break;
                //            本月已喊过装修
            case 1002:
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您本月已经预约过了"];
                break;
                //            不在装修区域
            case 1003:
                self.infoView.hidden = YES;
                [self replySubmit:dic];
                break;
                //             该区域暂无接单公司
            case 1004:
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该区域暂无接单公司"];
                break;
            case 2000:
            {
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"预约修失败，稍后重试"];
                break;
            }
            case 2001:
            {
                self.infoView.hidden = NO;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码错误"];
                break;
            }
            default:
                break;
        }
        
    } failed:^(NSString *errorMsg) {
        
        [weakSelf.view hiddleHud];
        self.infoView.hidden = NO;
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

#pragma mark   不在装修区域  是否继续提交
- (void)replySubmit:(NSMutableDictionary *)dic {
    //该地区不在装修公司服务区域，继续提交，我们会为您提供本地区优秀公司服务，是否继续提交？
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"该地区不在装修公司服务区域，继续提交，我们会为您提供本地区优秀公司服务，是否继续提交？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    __weak typeof(self)  weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"提交" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [dic setObject:@(1) forKey:@"type"];
        
        [weakSelf upDataRequest:dic];
    }];
    
    [aler addAction:action];
    [aler addAction:action1];
    [self presentViewController:aler animated:YES completion:nil];
}

#pragma mark - 获取计算器模板相关的内容
- (void)getCalculatorData {
    
    NSString *urlStr =[BASEURL stringByAppendingString:BLEJCalculatorGetTempletByCompanyIdUrl];
    NSString *agencyid=   [[NSUserDefaults standardUserDefaults ]objectForKey:@"alias"];
    
    //NSString *companyId = self.companyID;
    NSString *companyId = @"1398";
    NSDictionary *parameter = @{@"companyId":companyId};
    
    [NetManager afPostRequest:urlStr parms:parameter finished:^(id responseObj) {
        //        [self getDataWithType:@"1"];
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
            
            
            [self.baseItemsArr removeAllObjects];
            [self.suppleListArr removeAllObjects];
            
            
            
            NSDictionary *dictData= [responseObj objectForKey:@"data"];
            NSMutableArray *companyItemArray =[NSMutableArray array];
            companyItemArray=[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[BLRJCalculatortempletModelAllCalculatorTypes class] json:dictData[@"list"]]];
            for (BLRJCalculatortempletModelAllCalculatorTypes *dict in  companyItemArray) {
                
                if ( dict.templeteTypeNo  > 2000 &&dict.templeteTypeNo <3000) {
                    [self.baseItemsArr addObject:dict];
                }
                if (dict.templeteTypeNo  ==0) {
                    [self.suppleListArr addObject:dict];
                }
            }
            BLRJCalculatortempletModelAllCalculatorcompanyData* companyData=     [BLRJCalculatortempletModelAllCalculatorcompanyData yy_modelWithJSON:dictData[@"company"]];
            
            //   self.allCalculatorCompanyData=companyData;
            
            
            
            
            //如果baseitems数据为空，去本地取出数据
            NSString *strPath = [[NSBundle mainBundle] pathForResource:@"DefaultBaseItem" ofType:@"geojson"];
            NSData *JSONData = [NSData dataWithContentsOfFile:strPath];
            
            id jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *dicTemplet = [[jsonObject
                                                objectForKey:@"data"]objectForKey:@"templet"] ;
            if (self.suppleListArr.count ==0) {
                NSMutableArray *supplyArray = [NSMutableArray arrayWithArray:[[jsonObject
                                                                               objectForKey:@"data"] objectForKey:@"defaultSupplementItemsList"]];
                
                self.suppleListArr=[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ZCHCalculatorItemsModel class] json:supplyArray]];
            }
            if (self.baseItemsArr.count ==0){
                NSMutableArray *baseItemArray = [NSMutableArray arrayWithArray:[[jsonObject objectForKey:@"data"] objectForKey:@"defaultBaseItemsList"]];
                
                self.baseItemsArr=[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ZCHCalculatorItemsModel class] json:baseItemArray]];
                
            }
            
            
            
            
            //                if (self.allCalculatorCompanyData.calVip == nil || [self.allCalculatorCompanyData.calVip isEqualToString:@""]) {// 0表示不是会员  还没有开通200
            //                }
            
        }else{
            [[PublicTool defaultTool] publicToolsHUDStr:responseObj[@"msg"] controller:self sleep:1.5];
        }
        
       
        
    } failed:^(NSString *errorMsg) {
        [[PublicTool defaultTool] publicToolsHUDStr:errorMsg controller:self sleep:1.5];
    }];
}

#pragma  mark - 分享 ↓
- (void)addBottomShareView {
    
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.shadowView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickShadowView:)];
    [self.shadowView addGestureRecognizer:tap];
    
    [self.view addSubview:self.shadowView];
    self.shadowView.hidden = YES;
    
    self.bottomShareView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth, kSCREEN_WIDTH/2.0 + 70)];
    self.bottomShareView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.shadowView addSubview:self.bottomShareView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, BLEJWidth - 40, 30)];
    titleLabel.text = @"分享给好友";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottomShareView addSubview:titleLabel];
    
    NSArray *imageNames = @[@"weixin-share", @"pengyouquan", @"qq", @"qqkongjian", @"erweima-0"];
    NSArray *names = @[@"微信好友", @"微信朋友圈", @"QQ好友", @"QQ空间", @"我的二维码"];
    for (int i = 0; i < 5; i ++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i%4 * BLEJWidth * 0.25, titleLabel.bottom + 20 + (i/4 * BLEJWidth * 0.25), BLEJWidth * 0.25, BLEJWidth * 0.25)];
        btn.tag = i;
        [btn addTarget:self action:@selector(didClickShareContentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [btn setTitle:names[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // 1. 得到imageView和titleLabel的宽、高
        CGFloat imageWith = btn.imageView.frame.size.width;
        CGFloat imageHeight = btn.imageView.frame.size.height;
        
        CGFloat labelWidth = 0.0;
        CGFloat labelHeight = 0.0;
        labelWidth = btn.titleLabel.intrinsicContentSize.width;
        labelHeight = btn.titleLabel.intrinsicContentSize.height;
        UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
        UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
        imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-5/2.0, 0, 0, -labelWidth);
        labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-5/2.0, 0);
        btn.titleEdgeInsets = labelEdgeInsets;
        btn.imageEdgeInsets = imageEdgeInsets;
        [self.bottomShareView addSubview:btn];
    }
}

- (void)didClickShadowView:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomShareView.blej_y = BLEJHeight;
    } completion:^(BOOL finished) {
        self.shadowView.hidden = YES;
    }];
}

- (void)didClickShareContentBtn:(UIButton *)btn {
    
    if (!self.cardDic || self.cardDic.allKeys.count == 0 ) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"图片还需完善"];
        return;
    }
    NSString *shareTitle = self.cardDic[@"trueName"];
    NSString *shareDescription = self.cardDic[@"indu"];
    if (shareTitle.length > 30) {
        shareTitle = [shareTitle substringToIndex:28];
    }
    if (shareDescription.length > 30) {
        shareDescription = [shareDescription substringToIndex:28];
    }
    UIImage *shareImage;
    NSData *shareData;
    
    if (self.topImageView == nil || self.topImageView.image == nil) {
        [[UIApplication sharedApplication].keyWindow hudShow];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.companyDic[@"companyLogo"]]]];
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (image) {
            shareImage = image;
            
            UIGraphicsBeginImageContext(CGSizeMake(300, 300));
            [shareImage drawInRect:CGRectMake(0,0,300,300)];
            shareImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSData *data=UIImageJPEGRepresentation(shareImage, 1.0);
            CGFloat scale = 32.0 / data.length;
            shareData  = UIImageJPEGRepresentation(shareImage, scale);
            
        } else {
            shareImage = [UIImage imageNamed:@"shareDefaultIcon"];
            shareData = UIImagePNGRepresentation(shareImage);
            
        }
    } else {
        shareImage = self.topImageView.image;
        
        NSData *data=UIImageJPEGRepresentation(shareImage, 1.0);
        if (data.length > 32) {
            UIGraphicsBeginImageContext(CGSizeMake(300, 300));
            [shareImage drawInRect:CGRectMake(0,0,300,300)];
            shareImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGFloat scale = 32.0 / data.length;
            shareData  = UIImageJPEGRepresentation(shareImage, scale);
            
        }
    }
    
    [self addTwoDimensionCodeView];
    switch (btn.tag) {
        case 0:
        {// 微信好友
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            [message setThumbImage:shareImage];
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            //            NSString *shareURL = WebPageUrl;
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/businessCard/%@.htm", self.agencyId]];
            
            
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];  // 返回YES 跳转成功
            
            YSNLog(@"issend: %d", isSend);
            if (isSend) {
                [MobClick event:@"CompanyYellowPageShare"];
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomShareView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                self.shadowView.hidden = YES;
            }];
        }
            break;
        case 1:
        {// 微信朋友圈
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            [message setThumbImage:shareImage];
            //            [message setThumbImage:[UIImage imageNamed:@"top_default"]];
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            //            NSString *shareURL = WebPageUrl;
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/businessCard/%@.htm", self.agencyId]];
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"CompanyYellowPageShare"];
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomShareView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                self.shadowView.hidden = YES;
            }];
        }
            break;
        case 2:
        {// QQ好友
            if ([TencentOAuth iphoneQQInstalled]) {
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                //从contentObj中传入数据，生成一个QQReq
                //                NSString *shareURL = WebPageUrl;
                //                NSString *shareURL = @"https://www.baidu.com";
                
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/businessCard/%@.htm", self.agencyId]];
                
                NSURL *url = [NSURL URLWithString:shareURL];
                // title = 分享标题
                // description = 施工单位 小区名称
                
                
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"CompanyYellowPageShare"];
                }
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.bottomShareView.blej_y = BLEJHeight;
                } completion:^(BOOL finished) {
                    self.shadowView.hidden = YES;
                }];
            }
        }
            
            break;
        case 3:
        {// QQ空间
            if ([TencentOAuth iphoneQQInstalled]){
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                //从contentObj中传入数据，生成一个QQReq
                
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/businessCard/%@.htm", self.agencyId]];
                NSURL *url = [NSURL URLWithString:shareURL];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"CompanyYellowPageShare"];
                }
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.bottomShareView.blej_y = BLEJHeight;
                } completion:^(BOOL finished) {
                    self.shadowView.hidden = YES;
                }];
            }
        }
            break;
        case 4:
        {// 二维码
            [MobClick event:@"CompanyYellowPageShare"];
            self.TwoDimensionCodeView.hidden = NO;
            self.shadowView.hidden = YES;
            self.bottomShareView.blej_y = BLEJHeight;
            [UIView animateWithDuration:0.25 animations:^{
                
                self.TwoDimensionCodeView.alpha = 1.0;
                self.navigationController.navigationBar.alpha = 0;
            }];
        }
            break;
        default:
            break;
    }
}

// 点击二维码图片后生成的分享页面
- (void)addTwoDimensionCodeView {
    
//    self.TwoDimensionCodeView = [[CodeView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
//    self.TwoDimensionCodeView.backgroundColor = White_Color;
//    [self.view addSubview:self.TwoDimensionCodeView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickShadowView:)];
//    [self.TwoDimensionCodeView addGestureRecognizer:tap];
//
//    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"resources/html/shangjiarizhi.jsp?constructionId=%ld", (long)self.consID]];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.siteModel.coverMap]];
//    UIImage *image = [UIImage imageWithData:data];
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.TwoDimensionCodeView.QRCodeImageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:image logoScaleToSuperView:0.3];
//        });
//    });
//    self.TwoDimensionCodeView.typeLabel.text = [NSString stringWithFormat:@"%@",self.siteModel.ccShareTitle];
//    self.TwoDimensionCodeView.areaLabel.text = self.siteModel.ccAreaName;
//    self.TwoDimensionCodeView.companyNameLabel.text = self.siteModel.companyName;
//    self.TwoDimensionCodeView.imageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.TwoDimensionCodeView.imageView.clipsToBounds = YES;
//    [self.TwoDimensionCodeView.imageView sd_setImageWithURL:[NSURL URLWithString:self.siteModel.coverMap]];
//    // 没有图片
//    if (self.siteModel.coverMap.length == 0) {
//        [self.TwoDimensionCodeView.labelView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(0);
//            make.bottom.equalTo(-(kSCREEN_HEIGHT - 62-20));
//            make.height.equalTo(62);
//        }];
//
//        [self.TwoDimensionCodeView.QRCodeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH*0.4, kSCREEN_WIDTH * 0.4));
//            make.centerX.equalTo(0);
//            make.centerY.equalTo(0);
//        }];
//
//        [self.TwoDimensionCodeView.visitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(0);
//            make.left.right.equalTo(0);
//            make.top.equalTo(self.TwoDimensionCodeView.labelView.mas_bottom);
//            make.bottom.equalTo(self.TwoDimensionCodeView.QRCodeImageView.mas_top);
//        }];
//    }
//    self.TwoDimensionCodeView.hidden = YES;
    
    self.TwoDimensionCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.TwoDimensionCodeView.backgroundColor = White_Color;
    [self.view addSubview:self.TwoDimensionCodeView];
    self.TwoDimensionCodeView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTwoDimensionCodeView:)];
    [self.TwoDimensionCodeView addGestureRecognizer:tap];

    UIImageView *codeView = [[UIImageView alloc] init];
    codeView.size = CGSizeMake(BLEJWidth - 40, BLEJWidth - 40);
    codeView.center = self.TwoDimensionCodeView.center;
    codeView.backgroundColor = [UIColor whiteColor];
    [self.TwoDimensionCodeView addSubview:codeView];

    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/businessCard/%@.htm", self.agencyId]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow hudShow];
        });

        UIImage *shareImage;
        if (self.topImageView == nil || self.topImageView.image == nil) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.cardDic[@"coverMap"]]]];
            if (image) {
                shareImage = image;
                UIGraphicsBeginImageContext(CGSizeMake(300, 300));
                [shareImage drawInRect:CGRectMake(0,0,300,300)];
                shareImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            } else {
                shareImage = [UIImage imageNamed:@"shareDefaultIcon"];

            }
        } else {
            shareImage = self.topImageView.image;
            NSData *data=UIImageJPEGRepresentation(shareImage, 1.0);
            if (data.length > 32) {
                UIGraphicsBeginImageContext(CGSizeMake(300, 300));
                [shareImage drawInRect:CGRectMake(0,0,300,300)];
                shareImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow hiddleHud];
        });

        dispatch_async(dispatch_get_main_queue(), ^{
            codeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:shareImage logoScaleToSuperView:0.25];

        });
    });

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, codeView.bottom + 20, BLEJWidth, 30)];
    label.text = @"截屏保存到相册:";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor darkGrayColor];
    [self.TwoDimensionCodeView addSubview:label];

    UILabel *labelBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, label.bottom + 10, BLEJWidth, 30)];
    labelBottom.text = @"在微信环境下按住图片识别二维码打开";
    labelBottom.textColor = [UIColor darkGrayColor];
    labelBottom.textAlignment = NSTextAlignmentCenter;
    labelBottom.font = [UIFont systemFontOfSize:16];
    [self.TwoDimensionCodeView addSubview:labelBottom];

    UILabel *titleLabel = [[UILabel alloc] init];
    [self.TwoDimensionCodeView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(codeView.mas_top).equalTo(-20);
        make.left.right.equalTo(0);
    }];
    titleLabel.text = @"名片";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor blackColor];

    UILabel *companyNameLabel = [[UILabel alloc] init];
    [self.TwoDimensionCodeView addSubview:companyNameLabel];
    [companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(titleLabel.mas_top).equalTo(-10);
        make.left.equalTo(codeView).equalTo(6);
        make.right.equalTo(codeView).equalTo(-6);
    }];
    companyNameLabel.text = self.cardDic[@"trueName"];
    companyNameLabel.textAlignment = NSTextAlignmentCenter;
    companyNameLabel.numberOfLines = 0;
    companyNameLabel.font = [UIFont systemFontOfSize:20];
    companyNameLabel.textColor = [UIColor blackColor];
    
    self.TwoDimensionCodeView.hidden = YES;
}

- (void)didClickTwoDimensionCodeView:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.TwoDimensionCodeView.alpha = 0;
        self.navigationController.navigationBar.alpha = 1;
    }completion:^(BOOL finished) {
        
        self.TwoDimensionCodeView.hidden = YES;
    }];
}
#pragma mark  分享 ↑


#pragma mark - 取消收藏
- (void)unCollectionShopOrCompany {
    
    NSString *defaultApi = [BASEURL stringByAppendingString:DELETE_SHOUCANG];
    NSDictionary *paramDic = @{
                               @"collectionId" : self.cardDic[@"collectionId"]
                               };
    
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                [self.cardDic setObject:@(0) forKey:@"collectionId"];
//                [self.cardDic setObject:@"0" forKey:@"collectionId"];
                [[PublicTool defaultTool] publicToolsHUDStr:@"已取消收藏" controller:self sleep:1.0];
                self.collectionBtn.selected = NO;
            }
                break;
            default:
                [[PublicTool defaultTool] publicToolsHUDStr:@"操作失败" controller:self sleep:1.0];
                break;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 收藏
- (void)saveShopOrCompany  {
    
    NSString *requestString = [BASEURL stringByAppendingString:@"collection/add.do"];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.cardDic[@"cardId"] forKey:@"relId"]; // 名片id
    [params setObject:@(user.agencyId) forKey:@"agencysId"]; // 用户ID
    [params setObject:@"2" forKey:@"type"];
    [NetManager afGetRequest:requestString parms:params finished:^(id responseObj) {
        
        if ([responseObj[@"code"] integerValue] == 1000) {
            
//            [self.cardDic setObject:[NSString stringWithFormat:@"%ld", [responseObj[@"collectionId"] integerValue]] forKey:@"collectionId"];
            [self.cardDic setObject:@([responseObj[@"collectionId"] integerValue]) forKey:@"collectionId"];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"收藏成功"];
            self.collectionBtn.selected = YES;
        } else if ([responseObj[@"code"] integerValue] == 1002) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"已经收藏过了"];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"收藏失败"];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
