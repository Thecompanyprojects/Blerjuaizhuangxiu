//
//  BuildCaseViewController.m
//  iDecoration
//  施工案例
//  Created by Apple on 2017/5/3.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "BuildCaseViewController.h"
#import "BulidCaseModel.h"
#import "BuildCaseCell.h"
#import "ConstructionDiaryViewController.h"
#import "MainMaterialDiaryController.h"
#import "ConstructionDiaryTwoController.h"
#import "OwnerEvaluateModel.h"
#import "OwnerEvaluateCell.h"
#import "LYShareMenuView.h"
#import "ZYCShareView.h"
@interface BuildCaseViewController ()<UITableViewDelegate, UITableViewDataSource, BuildCaseCellDelegate, OwnerEvaluateCellDelegate,LYShareMenuViewDelegate>
{
    NSInteger _select;
}

@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UIImageView *photoImg;
@property (nonatomic, strong) UILabel *companyName;
// 案例
@property (nonatomic, strong) UILabel *constructionLabel;
@property (nonatomic, strong) UILabel *constructionNumLabel;
// 施工中
@property (nonatomic, strong) UILabel *displayLabel;
@property (nonatomic, strong) UILabel *dispalyNumLabel;
// 商品
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *numLabel3;
// 展现量
@property (nonatomic, strong) UILabel *label4;
@property (nonatomic, strong) UILabel *numLabel4;

@property (nonatomic, strong) NSMutableArray *dataArrayHavedFinished;
@property (nonatomic, strong) NSMutableArray *dataArrayNoFinished;

@property (strong, nonatomic) NSMutableArray *beSupportedCase;

@property (nonatomic, strong)UISegmentedControl *segmentedC;
@property (nonatomic, strong)UITableView *tableView;
@property (assign, nonatomic) NSInteger pageNumOne;
@property (assign, nonatomic) NSInteger pageNumTwo;
@property (strong, nonatomic)  NSMutableDictionary *Companydict;
// 业主评价
@property (nonatomic, strong) NSMutableArray *dataArray;
// 存储cell高度的
@property (strong, nonatomic) NSMutableArray *cellHeightArr;
@property (nonatomic,strong) LYShareMenuView *shareMenuView;
// QQ分享
@property (nonatomic,strong) TencentOAuth *tencentOAuth;

@property(nonatomic,strong)ZYCShareView *shareView;

@property (strong, nonatomic) UIView *TwoDimensionCodeView;
@end

@implementation BuildCaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"案例展示";
    
    self.dataArrayHavedFinished = [NSMutableArray array];
    self.dataArrayNoFinished = [NSMutableArray array];
    self.beSupportedCase = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.cellHeightArr = [NSMutableArray array];
    _Companydict =[NSMutableDictionary dictionary];
    _select = 1;
    self.view.backgroundColor = White_Color;
    [self setUI];
    self.pageNumOne = 1;
    self.pageNumTwo = 1;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (_select == 0) {
            self.pageNumTwo = 1;
        } else {
            self.pageNumOne = 1;
        }
        [self requestData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (_select == 0) {
            self.pageNumTwo ++;
        } else {
            self.pageNumOne ++;
        }
        [self requestData];
    }];
    [self requestDefaultData];
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"分享" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
  //  [self setupshare];
    
    
    self.shareView = [ZYCShareView sharedInstance];
    [self makeShareView];
    
//    self.shareView.blockQRCode1st = ^{
//        [MobClick event:@"CompanyYellowPageShare"];
//        weakself.TwoDimensionCodeView.hidden = NO;
//        weakself.shadowView.hidden = YES;
//        weakself.bottomShareView.blej_y = BLEJHeight;
//        [UIView animateWithDuration:0.25 animations:^{
//            weakself.TwoDimensionCodeView.alpha = 1.0;
//            weakself.navigationController.navigationBar.alpha = 0;
//        }];
//    };
//    self.shareView.blockQRCode2nd = ^{
//        [MobClick event:@"CompanyYellowPageShare"];
//        weakself.TwoDimensionCodeView.hidden = NO;
//        weakself.shadowView.hidden = YES;
//        weakself.bottomShareView.blej_y = BLEJHeight;
//        [UIView animateWithDuration:0.25 animations:^{
//            weakself.TwoDimensionCodeView.alpha = 1.0;
//            weakself.navigationController.navigationBar.alpha = 0;
//        }];
//    };
}
- (void)makeShareView {
    WeakSelf(self);
    NSString *url = [NSString new];
    if (self.isCompany) {
        url = [NSString stringWithFormat:@"%@%@%@",@"company/case/",self.companyId,@".htm"];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@%@%@",@"store/case/",self.companyId,@".htm"];
    }
    
    NSString *shareUrl = [BASEURL stringByAppendingString:url];
    NSString *sharetitle = self.companyName.text;
    UIImage *shareImage = self.photoImg.image;
    
//    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%@.htm?origin=%@", self.companyID,self.origin]];
//    NSString *shareTitle = self.companyDic[@"companyName"];
//    NSString *shareDescription = self.companyDic[@"companyIntroduction"];
    
    self.shareView.URL = shareUrl;
    self.shareView.shareTitle = sharetitle;
//    self.shareView.shareCompanyIntroduction = shareDescription;
    self.shareView.shareCompanyLogoImage = shareImage;
//    self.shareView.companyName = self.companyName;
    
    self.shareView.blockQRCode1st = ^{
        [MobClick event:@"CompanyYellowPageShare"];
        weakself.TwoDimensionCodeView.hidden = NO;
     //   weakself.shadowView.hidden = YES;
     //   weakself.bottomShareView.blej_y = BLEJHeight;
        [UIView animateWithDuration:0.25 animations:^{
            weakself.TwoDimensionCodeView.alpha = 1.0;
            weakself.navigationController.navigationBar.alpha = 0;
        }];
    };
    self.shareView.blockQRCode2nd = ^{
       [[PublicTool defaultTool] publicToolsHUDStr:@"暂时不提供员工二维码" controller:weakself sleep:1.0];
    
//        [MobClick event:@"CompanyYellowPageShare"];
//        weakself.TwoDimensionCodeView.hidden = NO;
//     //   weakself.shadowView.hidden = YES;
//    //    weakself.bottomShareView.blej_y = BLEJHeight;
//        [UIView animateWithDuration:0.25 animations:^{
//            weakself.TwoDimensionCodeView.alpha = 1.0;
//            weakself.navigationController.navigationBar.alpha = 0;
//        }];
    };
}

// 点击二维码图片后生成的分享页面
- (void)addTwoDimensionCodeView {
    
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
    
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%@.htm", self.companyId]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow hudShow];
        });
        
        UIImage *shareImage;
        if (!self.photoImg.image) {
           // UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.Companydict[@"companyLogo"]]]];
            if (self.photoImg.image) {
                shareImage = self.photoImg.image;
                UIGraphicsBeginImageContext(CGSizeMake(300, 300));
                [shareImage drawInRect:CGRectMake(0,0,300,300)];
                shareImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            } else {
                shareImage = [UIImage imageNamed:@"shareDefaultIcon"];

            }
        } else {
            shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.Companydict[@"companyLogo"]]]];
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
    titleLabel.text = @"企业";
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
    companyNameLabel.text = self.companyName.text;
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

- (void)requestDefaultData {

    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/v2/findListByCompanyId.do"];
    NSDictionary *paramDic = @{@"companyId":self.companyId,
                               @"ccComplete":@(1),// 未交工
                               @"pageSize":@(8),
                               @"pageNumber":@(self.pageNumOne)
                               };
    
    NSDictionary *paramDic2 = @{@"companyId":self.companyId,
                               @"ccComplete":@(2),// 已交工
                               @"pageSize":@(8),
                               @"pageNumber":@(self.pageNumTwo)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                    if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]]) {
                        
                        NSDictionary *dic = responseObj[@"data"];
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[BulidCaseModel class] json:[dic objectForKey:@"list"]];
                        [self.dataArrayNoFinished addObjectsFromArray:arr];
                        if ([[dic objectForKey:@"list"] count] < 8) {
                            
                            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                        }
                        [self.tableView reloadData];
                    };
                    break;
                default:
                    break;
            }
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
    
    [NetManager afPostRequest:defaultApi parms:paramDic2 finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                    if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = responseObj[@"data"];
                 self.Companydict= [dic objectForKey:@"company"];
                        
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[BulidCaseModel class] json:[dic objectForKey:@"list"]];
                        
                        if (self.pageNumTwo == 1) {
                            [self.dataArrayHavedFinished addObjectsFromArray:arr];
                        }
                        //刷新数据
                        [self reloadDataWithDic:self.Companydict];
                        
                    };
                    break;
                    
                default:
                    break;
            }
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
    
    NSString *defaultEvaApi = [BASEURL stringByAppendingString:@"constructionEvaluate/getCompanyEva.do"];
    NSDictionary *paramEvaDic = @{@"companyId":self.companyId
                               };
    [NetManager afPostRequest:defaultEvaApi parms:paramEvaDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            [self.dataArray removeAllObjects];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                    if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = responseObj[@"data"];

                        
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[OwnerEvaluateModel class] json:[dic objectForKey:@"list"]];
                        [self.dataArray addObjectsFromArray:arr];
                        for (int i = 0; i < self.dataArray.count; i ++) {
                            
                            [self.cellHeightArr addObject:@"0"];
                        }
                    };
                    break;
                    
                default:
                    break;
            }
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}


- (void)requestData {
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/v2/findListByCompanyId.do"];
    
    NSInteger pageNum = _select == 0 ? self.pageNumTwo : self.pageNumOne;
    
    NSDictionary *paramDic;
    if (_select == 0) {
        paramDic = @{
                    @"companyId" : self.companyId,
                    @"ccComplete" : @(2),
                    @"pageSize" : @(8),
                    @"pageNumber" : @(pageNum)
                    };
    } else {
        
        paramDic = @{
            @"companyId" : self.companyId,
            @"ccComplete" : @(1),
            @"pageSize" : @(8),
            @"pageNumber" : @(pageNum)
            };
    }
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            if (pageNum == 1) {
                
                if (_select == 0) {
                    
                    [self.dataArrayHavedFinished removeAllObjects];
                } else {
                    
                    [self.dataArrayNoFinished removeAllObjects];
                }
            }
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            switch (statusCode) {
                case 1000:
                    
                    if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]]) {
                        
                        NSDictionary *dic = responseObj[@"data"];
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[BulidCaseModel class] json:[dic objectForKey:@"list"]];
                        if (_select == 0) {
                            [self.dataArrayHavedFinished addObjectsFromArray:arr];
                        } else {
                            
                            [self.dataArrayNoFinished addObjectsFromArray:arr];
                        }
                        if ([[dic objectForKey:@"list"] count] < 8 && self.tableView.mj_footer.isRefreshing) {
                            
                            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                            [self.tableView reloadData];
                            return;
                        }
                        [self.tableView reloadData];
                    };
                    break;
                    
                default:
                    break;
            }
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    } failed:^(NSString *errorMsg) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

#pragma mark - action

- (void)setUI {
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.topV;
}

- (void)reloadDataWithDic:(NSDictionary *)dict {
    
    self.companyName.text = [dict objectForKey:@"companyName"];

    self.constructionNumLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"caseTotla"]];
    self.dispalyNumLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"constructionTotal"]];
    self.numLabel3.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"merchandiesCount"]];
    self.numLabel4.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"displayNumbers"]];

    
    [self.photoImg sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"companyLogo"]] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
}

- (void)segmentedClick:(UISegmentedControl *)seg {
    
    _select = seg.selectedSegmentIndex;
    if (_select != 2) {
       
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            if (_select == 0) {
                self.pageNumTwo = 1;
            } else {
                self.pageNumOne = 1;
            }
            [self requestData];
        }];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            if (_select == 0) {
                self.pageNumTwo ++;
            } else {
                self.pageNumOne ++;
            }
            [self requestData];
        }];
        
        self.tableView.mj_footer.state = MJRefreshStateIdle;

    } else {
        
        self.tableView.mj_header = nil;
        self.tableView.mj_footer = nil;
        _select = 2;
    }
    [self.tableView reloadData];
}

#pragma mark - uitableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_select == 0) {
        
        return self.dataArrayHavedFinished.count;
    } else if (_select == 1) {
        
        return self.dataArrayNoFinished.count;
    } else {
        
        return self.dataArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_select != 2) {
        BuildCaseCell *cell = [BuildCaseCell cellWithTableView:tableView];
        BulidCaseModel *model;
        if (_select == 0) {
            model = self.dataArrayHavedFinished[indexPath.row];
        } else {
            model = self.dataArrayNoFinished[indexPath.row];
        }
        
        cell.beSelected = [self.beSupportedCase containsObject:model.constructionId];
        [cell configWith:model];
        cell.buildCaseCellDelegate = self;
        cell.index = indexPath.row;
        return cell;
    } else {
        
        OwnerEvaluateCell *cell = [OwnerEvaluateCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.indexPath = indexPath;
        OwnerEvaluateModel *model = self.dataArray[indexPath.row];
        [cell configWith:model];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.isConVIP) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"主人暂未开通云管理会员"];
        return;
    }
    if (_select != 2) {
        
        BulidCaseModel *model;
        if (_select == 0) {
            model = self.dataArrayHavedFinished[indexPath.row];
        } else {
            model = self.dataArrayNoFinished[indexPath.row];
        }
        if (model.constructionId && ![model.constructionId isEqualToString:@""] && ![model.constructionId isEqualToString:@"0"]) {
            NSString *constructionType = model.constructionType;
            
            if ([constructionType isEqualToString:@"0"]) {// 公司 跳转
 
                ConstructionDiaryTwoController *constructionVC = [[ConstructionDiaryTwoController alloc] init];
                constructionVC.consID = [model.constructionId integerValue];
                
                // 修改流量的数量
                BuildCaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                BulidCaseModel *model;
                if (_select == 0) {
                    model = self.dataArrayHavedFinished[indexPath.row];
                } else {
                    model = self.dataArrayNoFinished[indexPath.row];
                }
                // 修改model的浏览量
                NSInteger seeCount = cell.commentCountL.text.integerValue;
                model.scanCount = [NSString stringWithFormat:@"%ld", seeCount+1];
                cell.commentCountL.text = [NSString stringWithFormat:@"%ld", seeCount+1];
                
                [self addSeeNumWithConstrudtionId:model.constructionId];
                
                
                [self.navigationController pushViewController:constructionVC animated:YES];
            } else {
                
                MainMaterialDiaryController *constructionVC = [[MainMaterialDiaryController alloc] init];
                constructionVC.consID = [model.constructionId integerValue];
                
                // 修改流量的数量
                BuildCaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                BulidCaseModel *model;
                if (_select == 0) {
                    model = self.dataArrayHavedFinished[indexPath.row];
                } else {
                    model = self.dataArrayNoFinished[indexPath.row];
                }
                // 修改model的浏览量
                NSInteger seeCount = cell.commentCountL.text.integerValue;
                model.scanCount = [NSString stringWithFormat:@"%ld", seeCount+1];
                cell.commentCountL.text = [NSString stringWithFormat:@"%ld", seeCount+1];
                
                [self addSeeNumWithConstrudtionId:model.constructionId];
                
                
                [self.navigationController pushViewController:constructionVC animated:YES];
            }
        } else {
            
            [self.view showHudFailed:@"该工地已不存在..."];
        }
    } else {
        
        OwnerEvaluateModel *model = self.dataArray[indexPath.row];
        
        if (model.constructionId && ![model.constructionId isEqualToString:@""] && ![model.constructionId isEqualToString:@"0"]) {
            if (!self.isCompany) {
                ConstructionDiaryTwoController *constructionVC = [[ConstructionDiaryTwoController alloc] init];
                constructionVC.consID = [model.constructionId integerValue];
                [self.navigationController pushViewController:constructionVC animated:YES];
            } else {
                MainMaterialDiaryController *mainDiaryVC = [[MainMaterialDiaryController alloc] init];
                mainDiaryVC.consID = [model.constructionId integerValue];
                [self.navigationController pushViewController:mainDiaryVC animated:YES];
                
            
            }
        } else {
            
            [self.view hudShowWithText:@"该工地已不存在..."];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_select != 2) {
        
        BulidCaseModel *model;
        if (_select == 0) {
            model = self.dataArrayHavedFinished[indexPath.row];
        } else {
            model = self.dataArrayNoFinished[indexPath.row];
        }
        
        if (!model.cdPicture || [model.cdPicture isEqualToString:@""]) {
            
            return 110;
        }
        return 290;
    } else {
        
        return [self.cellHeightArr[indexPath.row] floatValue];
    }
}

#pragma mark - OwnerEvaluateCellDelegate方法
- (void)getCellHeight:(CGFloat)cellHeight andIndex:(NSIndexPath *)index {
    
    [self.cellHeightArr replaceObjectAtIndex:index.row withObject:[NSString stringWithFormat:@"%f", cellHeight]];
}


#pragma mark - 增加浏览量
- (void)addSeeNumWithConstrudtionId:(NSString *)constructionId  {
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/upLikeOrScanCount.do"];
    NSDictionary *paramDic = @{@"constructionId":@(constructionId.integerValue),
                               @"likeNum":@(0),
                               @"scanCount":@(2)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
    } failed:^(NSString *errorMsg) {
    }];
    
}

#pragma mark - topView
- (UIView *)topV {
    if (!_topV) {
        _topV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, BLEJWidth - 20, 170)];
        _topV.backgroundColor = White_Color;
        _topV.layer.borderWidth = 8;
        _topV.layer.borderColor = kBackgroundColor.CGColor;
        [_topV addSubview:self.segmentedC];
        
        self.photoImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 90, 90)];
        [_topV addSubview:self.photoImg];
        self.companyName = [UILabel new];
        [_topV addSubview:self.companyName];
        [self.companyName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.photoImg.mas_right).equalTo(10);
            make.top.equalTo(self.photoImg.mas_top).equalTo(13);
            make.right.equalTo(-10);
        }];
        self.companyName.textColor = Black_Color;
        self.companyName.font = [UIFont systemFontOfSize:20];
        self.companyName.textAlignment = NSTextAlignmentLeft;
        
        self.constructionLabel = [UILabel new];
        [_topV addSubview:self.constructionLabel];
        [self.constructionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.photoImg.mas_right).equalTo(10);
            make.top.equalTo(self.companyName.mas_bottom).equalTo(10);
        }];
        self.constructionLabel.textColor = Black_Color;
        self.constructionLabel.font = [UIFont systemFontOfSize:14];
        self.constructionLabel.text = @"案例:";
        
        self.constructionNumLabel = [UILabel new];
        [_topV addSubview:self.constructionNumLabel];
        [self.constructionNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.constructionLabel.mas_right).equalTo(5);
            make.centerY.equalTo(self.constructionLabel);
            make.width.equalTo(60);
        }];
        self.constructionNumLabel.textColor = [UIColor redColor];
        self.constructionNumLabel.font = [UIFont systemFontOfSize:14];
        
        self.displayLabel = [UILabel new];
        [_topV addSubview:self.displayLabel];
        [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.constructionNumLabel.mas_right).equalTo(4);
            make.centerY.equalTo(self.constructionLabel);
        }];
        self.displayLabel.textColor = Black_Color;
        self.displayLabel.font = [UIFont systemFontOfSize:14];
        self.displayLabel.text = @"施工中:";
        
        self.dispalyNumLabel = [UILabel new];
        [_topV addSubview:self.dispalyNumLabel];
        [self.dispalyNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.displayLabel.mas_right).equalTo(5);
            make.centerY.equalTo(self.constructionLabel);
        }];
        self.dispalyNumLabel.textColor = [UIColor redColor];
        self.dispalyNumLabel.font = [UIFont systemFontOfSize:14];
        
        // -------
        
        self.label3 = [UILabel new];
        [_topV addSubview:self.label3];
        [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.photoImg.mas_right).equalTo(10);
            make.top.equalTo(self.dispalyNumLabel.mas_bottom).equalTo(8);
        }];
        self.label3.textColor = Black_Color;
        self.label3.font = [UIFont systemFontOfSize:14];
        self.label3.text = @"商品:";
        
        self.numLabel3 = [UILabel new];
        [_topV addSubview:self.numLabel3];
        [self.numLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.label3.mas_right).equalTo(5);
            make.centerY.equalTo(self.label3);
            make.width.equalTo(60);
        }];
        self.numLabel3.textColor = [UIColor redColor];
        self.numLabel3.font = [UIFont systemFontOfSize:14];
        
        self.label4 = [UILabel new];
        [_topV addSubview:self.label4];
        [self.label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.numLabel3.mas_right).equalTo(4);
            make.centerY.equalTo(self.label3);
        }];
        self.label4.textColor = Black_Color;
        self.label4.font = [UIFont systemFontOfSize:14];
        self.label4.text = @"展现量:";
        
        self.numLabel4 = [UILabel new];
        [_topV addSubview:self.numLabel4];
        [self.numLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.label4.mas_right).equalTo(5);
            make.centerY.equalTo(self.label3);
        }];
        self.numLabel4.textColor = [UIColor redColor];
        self.numLabel4.font = [UIFont systemFontOfSize:14];
    }
    return _topV;
}


- (UISegmentedControl *)segmentedC {
    
    if (!_segmentedC) {
        NSArray *segmentArray = [NSArray arrayWithObjects:@"已交工",@"未交工",@"业主评价", nil];
        _segmentedC = [[UISegmentedControl alloc]initWithItems:segmentArray];
        _segmentedC.frame = CGRectMake(kSCREEN_WIDTH/2-100, self.topV.height - 40, 200, 30);
        // COLOR_BLACK_CLASS_6
        _segmentedC.tintColor = kMainThemeColor;
        _segmentedC.selectedSegmentIndex = 1;
        [_segmentedC addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segmentedC;
}

- (UITableView *)tableView {
    
    if (!_tableView) {

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH,kSCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.rowHeight = 280;
    }
    return _tableView;
}

#pragma mark - BuildCaseCellDelegate方法(点赞回调)
- (void)didClickSupportBtn:(UIButton *)btn withIndex:(NSInteger)index {
    BulidCaseModel *model;
    if (_select == 0) {
        model = self.dataArrayHavedFinished[index];
    } else {
        model = self.dataArrayNoFinished[index];
    }
    model.likeNumber = [NSString stringWithFormat:@"%d", [model.likeNumber intValue] + 1];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/upLikeOrScanCount.do"];
    NSDictionary *paramDic = @{@"constructionId":model.constructionId,
                               @"likeNum":@(2),
                               @"scanCount":@(0)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            [self.beSupportedCase addObject:model.constructionId];
            }
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
    
}

- (LYShareMenuView *)shareMenuView{
    if (!_shareMenuView) {
        _shareMenuView = [[LYShareMenuView alloc] init];
        _shareMenuView.delegate = self;
    }
    return _shareMenuView;
}

-(void)setupshare
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self.shareMenuView];
    //配置item
    NSMutableArray *array = NSMutableArray.new;
    LYShareMenuItem *item0 = nil;
    item0 = [LYShareMenuItem shareMenuItemWithImageName:@"qq" itemTitle:@"QQ"];
    [array addObject:item0];
    
    LYShareMenuItem *item1 = nil;
    item1 = [LYShareMenuItem shareMenuItemWithImageName:@"qqkongjian" itemTitle:@"QQ空间"];
    [array addObject:item1];
    
    LYShareMenuItem *item2 = nil;
    item2 = [LYShareMenuItem shareMenuItemWithImageName:@"weixin-share" itemTitle:@"微信好友"];
    [array addObject:item2];
    
    LYShareMenuItem *item3 = nil;
    item3 = [LYShareMenuItem shareMenuItemWithImageName:@"pengyouquan" itemTitle:@"朋友圈"];
    [array addObject:item3];
    
    self.shareMenuView.shareMenuItems = [array copy];
}

-(void)shareClick

{
    
    [self addTwoDimensionCodeView];
    [self.shareView share];

}

- (void)shareMenuView:(LYShareMenuView *)shareMenuView didSelecteShareMenuItem:(LYShareMenuItem *)shareMenuItem atIndex:(NSInteger)index{
    
    NSString *url = [NSString new];
    if (self.isCompany) {
        url = [NSString stringWithFormat:@"%@%@%@",@"company/case/",self.companyId,@".htm"];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@%@%@",@"store/case/",self.companyId,@".htm"];
    }
    
    NSString *shareUrl = [BASEURL stringByAppendingString:url];
    NSString *sharetitle = self.companyName.text;

    
    switch (index) {
        case 0:
        {
            // QQ好友
            if ([TencentOAuth iphoneQQInstalled]) {
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];

                UIImage *shareImage = self.photoImg.image;
                
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];
                NSURL *url = [NSURL URLWithString:shareUrl];

                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:sharetitle description:@"" previewImageData:data];

                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"CalculatorTemplateShare"];

                }
              
            }
        }
            break;
        case 1:
        {
            // QQ空间
            if ([TencentOAuth iphoneQQInstalled]){
                

                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                
                UIImage *shareImage = self.photoImg.image;
                
                // 把图片设置成正方形
                CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
                shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
                UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
                NSData *data = [self imageWithImage:img scaledToSize:CGSizeMake(300, 300)];
                NSURL *url = [NSURL URLWithString:shareUrl];
                
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:sharetitle description:@"" previewImageData:data];
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"CalculatorTemplateShare"];

                }
            }
        }
            break;
        case 2:
        {
            //微信好友

            WXMediaMessage *message = [WXMediaMessage message];
            message.title = sharetitle;
            message.description = @"";
            UIImage *shareImage = self.photoImg.image;
            // 把图片设置成正方形
            CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
            shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
            UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
            [message setThumbImage:img];

            WXWebpageObject *webPageObject = [WXWebpageObject object];
            webPageObject.webpageUrl = shareUrl;
            message.mediaObject = webPageObject;
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"CalculatorTemplateShare"];

            }

        }
            break;
        case 3:
        {
            // 微信朋友圈
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = sharetitle;
            message.description = @"";
            UIImage *shareImage = self.photoImg.image;
            // 把图片设置成正方形
            CGFloat width = shareImage.size.width > shareImage.size.height ? shareImage.size.height : shareImage.size.width;
            shareImage = [NSObject getSubImage:shareImage mCGRect:CGRectMake(0, 0, width, width) centerBool:YES];
            UIImage *img = [UIImage imageWithData:[self imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];
            [message setThumbImage:img];
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            webPageObject.webpageUrl = shareUrl;
            message.mediaObject = webPageObject;
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"CalculatorTemplateShare"];

            }

        }
            break;
        default:
            break;
    }
}

- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
