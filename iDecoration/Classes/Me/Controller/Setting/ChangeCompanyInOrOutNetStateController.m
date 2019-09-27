//
//  ChangeCompanyInOrOutNetStateController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ChangeCompanyInOrOutNetStateController.h"
#import "InOutCompanyModel.h"

@interface ChangeCompanyInOrOutNetStateController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *currentSelectedBtn;
@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation ChangeCompanyInOrOutNetStateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"切换工地";
    
    [self scrollView];
    _selectIndex = 0;
    
}

- (void)seletCompany:(UIButton *)sender {
    if (self.currentSelectedBtn == sender) {
        return;
    }
    sender.selected = YES;
    self.currentSelectedBtn.selected = !self.currentSelectedBtn.selected;
    self.currentSelectedBtn = sender;
    _selectIndex = sender.tag;
}

- (void)finishiAction {
    UserInfoModel *model = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    if (_selectIndex == self.listArray.count) {
        // 切换到公共网络
        NSString *defaultApi = [BASEURL stringByAppendingString:@"companyAgencys/toOuterNet.do"];
        NSDictionary *param = @{
                                @"agencyId": @(model.agencyId)
                                };
        [NetManager afPostRequest:defaultApi parms:param finished:^(id responseObj) {
            if ([responseObj[@"code"]integerValue] == 1000) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"已切换到外网"];
                [self performSelector:@selector(back) withObject:nil afterDelay:1.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingChangeNet" object:nil];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    } else {
        // 切换到内网
        InOutCompanyModel *inoutModel = self.listArray[_selectIndex];
        NSString *defaultApi = [BASEURL stringByAppendingString:@"companyAgencys/toInnerNet.do"];
        NSDictionary *param = @{
                                @"agencyId": @(model.agencyId),
                                @"companyId": inoutModel.companyId
                                };
        [NetManager afPostRequest:defaultApi parms:param finished:^(id responseObj) {
            if ([responseObj[@"code"]integerValue] == 1000) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"已切换到内网"];
                [self performSelector:@selector(back) withObject:nil afterDelay:1.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingChangeNet" object:nil];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(self.navigationController.navigationBar.bottom);
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT - kNaviBottom));
        }];
        
        UIView *lastView = nil;
        for (int i = 0; i < self.listArray.count; i ++) {
            UIView *view = [UIView new];
            [_scrollView addSubview:view];
            view.frame = CGRectMake(0, i * (70 + 10), kSCREEN_WIDTH, 80);
            UILabel *nameLabel = [UILabel new];
            [view addSubview:nameLabel];
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(12);
                make.top.equalTo(12);
            }];
            UserInfoModel *usermodel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
            nameLabel.text = [NSString stringWithFormat:@"户主：%@", usermodel.trueName];
            nameLabel.font = [UIFont systemFontOfSize:16];
            
            UILabel *companyNameLabel = [UILabel new];
            [view addSubview:companyNameLabel];
            [companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(12);
                make.bottom.equalTo(-12);
            }];
            InOutCompanyModel *model = self.listArray[i];
            companyNameLabel.text = model.companyName;
            companyNameLabel.font = [UIFont systemFontOfSize:16];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [view addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(-12);
                make.centerY.equalTo(0);
                make.size.equalTo(CGSizeMake(44, 44));
            }];
            [btn setImage:[UIImage imageNamed:@"pitch0"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"pitch"] forState:UIControlStateSelected];
        
//            if (i == 0) {
//                btn.selected = YES;
//                self.currentSelectedBtn = btn;
//            }
            
            if (model.innerAndOuterSwitch.integerValue == 0) {
                btn.selected = YES;
                self.currentSelectedBtn = btn;

            }
            btn.tag = i;
            [btn addTarget:self action:@selector(seletCompany:) forControlEvents:UIControlEventTouchUpInside];
            lastView = view;
        }
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame), kSCREEN_WIDTH, 60)];
        [_scrollView addSubview:bottomView];
        UIView *lineView = [UIView new];
        [bottomView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(12);
            make.right.equalTo(-12);
            make.height.equalTo(1);
        }];
        lineView.backgroundColor = [UIColor lightGrayColor];
        UILabel *cLabel = [UILabel new];
        [bottomView addSubview:cLabel];
        [cLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(12);
            make.centerY.equalTo(0);
        }];
        cLabel.text = @"切换到公共网络";
        cLabel.font = [UIFont systemFontOfSize:16];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottomView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-12);
            make.centerY.equalTo(0);
            make.size.equalTo(CGSizeMake(44, 44));
        }];
        [btn setImage:[UIImage imageNamed:@"pitch0"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"pitch"] forState:UIControlStateSelected];
        btn.tag = self.listArray.count;
        [btn addTarget:self action:@selector(seletCompany:) forControlEvents:UIControlEventTouchUpInside];
//        if (self.isOutNet) {
//            self.currentSelectedBtn = btn;
//            btn.selected = YES;
//        }
        __block BOOL hasInnerNet = NO;
        [self.listArray enumerateObjectsUsingBlock:^(InOutCompanyModel  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.innerAndOuterSwitch.integerValue == 0) {
                // 有公司在内网
                hasInnerNet = YES;
            }
        }];
        if (!hasInnerNet) {
            self.currentSelectedBtn = btn;
            btn.selected = YES;
        }
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scrollView addSubview:finishBtn];
        [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-12);
            make.left.equalTo(12);
            make.top.equalTo(bottomView.mas_bottom).equalTo(30);
            make.height.equalTo(44);
            make.width.equalTo(kSCREEN_WIDTH - 24);
        }];
        [finishBtn addTarget:self action:@selector(finishiAction) forControlEvents:UIControlEventTouchUpInside];
        finishBtn.backgroundColor = kMainThemeColor;
        [finishBtn setTitle:@"完    成" forState:UIControlStateNormal];
        [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        finishBtn.layer.cornerRadius = 4;
        finishBtn.layer.masksToBounds = YES;
    }
    return _scrollView;
}
@end
