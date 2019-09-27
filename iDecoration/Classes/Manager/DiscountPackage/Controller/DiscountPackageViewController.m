//
//  DiscountPackageViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/7/24.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "DiscountPackageViewController.h"

@interface DiscountPackageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,assign) BOOL isFourYear;
@end

@implementation DiscountPackageViewController

#pragma mark lazy

- (DiscountPackageModel *)model {
    if (!_model) {
        _model = [DiscountPackageModel new];
    }
    return _model;
}

#pragma mark UI
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFourYear = NO;
    self.title = @"企业网会员";
    self.model.isMore = true;
    self.model.discountPackageDetail = @"黄页网 + 云管理 + 号码通";
    self.model.money = @"999元/年";
    [self createTableView];
}

- (void)createTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    DiscountPackageFooterView *footerView = [[[NSBundle mainBundle] loadNibNamed:@"DiscountPackageFooterView" owner:self options:nil] lastObject];
    footerView.button.layer.cornerRadius = 4.0f;
    footerView.button.layer.masksToBounds = true;
    [footerView setBackgroundColor:[UIColor clearColor]];
    footerView.blockDidTouchButton = ^(NSInteger tag) {
        [self didTouchButtonWithTag:tag];
    };
    self.tableView.tableFooterView = footerView;
}

#pragma mark tableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==0) {
        return 2;
    }
    if (section==1) {
        return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscountPackageTableViewCell *cell0 = [DiscountPackageTableViewCell cellWithTableView:tableView AndIndex:0];
    DiscountPackageTableViewCell *cell1 = [DiscountPackageTableViewCell cellWithTableView:tableView AndIndex:1];
    if (indexPath.section == 0) {

        if (indexPath.row==0) {
            cell0.labelTitle.text = @"999元/年";
            if (self.isFourYear) {
                cell0.button.selected = false;
            }
            else
            {
                cell0.button.selected = true;
            }
        }
        if (indexPath.row==1) {
            cell0.labelTitle.text = @"1998元/3年（买两年送一年）";
            if (self.isFourYear) {
                cell0.button.selected = true;
            }
            else
            {
                cell0.button.selected = false;
            }
        }
        [cell0.labelTitle setTextColor:[UIColor redColor]];
        cell0.labelDetail.text = @" ";
        
      
        return cell0;
    }else{
        if (indexPath.row == 0) {
            cell0.labelTitle.text = @"支付方式";
            cell0.labelDetail.hidden = true;
            cell0.button.hidden = true;
            return cell0;
        }else{
            if (self.model.isMore && indexPath.row == 2) {
                cell1.imageViewIcon.hidden = true;
                cell1.button.hidden = true;
                cell1.labelTitle.text = @"更多支付方式";
                cell1.labelTitle.textAlignment = NSTextAlignmentCenter;
            }else{
                cell1.labelTitle.text = KValueForKey(@"typeName");
                cell1.imageViewIcon.image = [UIImage imageNamed:KValueForKey(@"typeIcon")];
                cell1.button.selected = [KValueForKey(@"typeSelected") integerValue];
                cell1.labelTitle.textAlignment = NSTextAlignmentLeft;
            }
            return cell1;
        }
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==0) {
        if (indexPath.row==0) {
            self.isFourYear = false;
            [self.tableView reloadData];
        }
        if (indexPath.row==1) {
            self.isFourYear = true;
            [self.tableView reloadData];
        }
    }
    if (indexPath.section == 1) {
        if (self.model.isMore) {
            self.model.isMore = false;
        }else{
            [self.model.arrayPay enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary *dic = obj;
                if (idx == indexPath.row - 1 && indexPath.row > 0) {
                    dic[@"typeSelected"] = @"1";
                }else
                    dic[@"typeSelected"] = @"0";
            }];
        }
        [tableView reloadData];
    }
    
}

#pragma mark else
- (void)didTouchButtonWithTag:(NSInteger)tag {
    if (tag == 1) {//开通会员
        [self pay];
    }else{
        ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
        if (tag == 2) {//支付协议
            VC.titleStr = @"支付协议";
            VC.webUrl = @"resources/html/fufeixieyi.html";
        }
        if (tag == 3) {//增值服务协议
            VC.titleStr = @"增值服务协议";
            VC.webUrl = @"resources/html/huiyuanchengzhangjihuaxieyi.html";
        }
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)pay {
    NSString *agencyId = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];
    __block NSInteger index = 0;
    [self.model.arrayPay enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dic = obj;
        if ([dic[@"typeSelected"] isEqualToString:@"1"]) {
            index = idx;
        }
    }];
    switch (index) {
        case 0: {//支付宝
            NSString *defaultApi = [NSString new];
            if (self.isFourYear) {
                defaultApi = [BASEURL stringByAppendingString:@"aliPayPre/packageVip4.do"];
            }
            else
            {
                defaultApi = [BASEURL stringByAppendingString:@"aliPayPre/packageVip.do"];
            }
            
            NSDictionary *paramDic = @{@"companyId" : self.companyId,
                                       @"agencyId" : agencyId
                                       };
            [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
                if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
                    NSDictionary *dic = @{@"orderStr" : responseObj[@"data"][@"orderInfo"]};
                    [(AppDelegate *)([UIApplication sharedApplication].delegate) ALiPayWithDic:dic];
                    
                    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).appRootTabBarVC.selectedIndex = 0;
                    
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    SNTabBarController * main = [[SNTabBarController alloc] init];
                    appDelegate.window.rootViewController = main;
                    
                }
            } failed:^(NSString *errorMsg) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
            }];
        }
            break;
        case 1: {//微信
            NSString *param = [NSString new];
          
            if (self.isFourYear) {
                  param = [NSString stringWithFormat:@"companyPacVip4,%@,%d,%@", self.companyId, 3, agencyId];
            }
            else
            {
                  param = [NSString stringWithFormat:@"companyPacVip,%@,%d,%@", self.companyId, 3, agencyId];
            }
            NSString *defaultApi = [BASEURL stringByAppendingString:@"wxPay/pre.do"];
            NSDictionary *paramDic = @{@"attach":param};
            [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
                if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
                    NSDictionary *dic = @{@"partnerid" : responseObj[@"partnerid"], @"prepayid" : responseObj[@"prepayid"], @"package" : responseObj[@"package"], @"noncestr" : responseObj[@"noncestr"], @"timestamp" : @([responseObj[@"timestamp"] intValue]), @"sign" : responseObj[@"sign"]};
                    [(AppDelegate *)([UIApplication sharedApplication].delegate) WXPayWithDic:dic];
                    
                    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).appRootTabBarVC.selectedIndex = 0;
                    
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    SNTabBarController * main = [[SNTabBarController alloc] init];
                    appDelegate.window.rootViewController = main;
                    
                    
                }
            } failed:^(NSString *errorMsg) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
            }];
        }
            break;
        default:
            break;
    }
}
@end
