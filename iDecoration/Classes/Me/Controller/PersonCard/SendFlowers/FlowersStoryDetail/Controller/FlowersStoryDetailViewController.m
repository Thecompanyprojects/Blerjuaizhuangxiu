//
//  FlowersStoryDetailViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/18.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "FlowersStoryDetailViewController.h"
#import "FlowersStoryDetailTableViewCell.h"
#import "FlowersListModel.h"
#import "ZYCShareView.h"
#import <OpenShare/OpenShareHeader.h>
#import "SGQRCodeTool.h"
#import "FlowersStoryQRCodeViewController.h"

@interface FlowersStoryDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ZYCShareView *shareView;
@end

@implementation FlowersStoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"鲜花故事";
    self.shareView = [ZYCShareView sharedInstance];
    [self makeShareView];
    [self createTableView];
    if (self.model.story.length) {
        [self setupRightButton];
    }
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStylePlain)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = 0;
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

- (void)viewWillLayoutSubviews {
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(padding.top); //with is an optional semantic filler
        make.left.equalTo(self.view.mas_left).with.offset(padding.left);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-padding.bottom);
        make.right.equalTo(self.view.mas_right).with.offset(-padding.right);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FlowersStoryDetailTableViewCell *cell0 = [FlowersStoryDetailTableViewCell cellWithTableView:tableView AndIndex:0];
    FlowersStoryDetailTableViewCell *cell1 = [FlowersStoryDetailTableViewCell cellWithTableView:tableView AndIndex:1];
    if (indexPath.row == 0) {
        return cell0;
    }else if (indexPath.row == 1) {
        cell1.labelTitle.text = @"鲜花-代表美好的祝福";
        [cell1.labelTitle setFont:[UIFont systemFontOfSize:16]];
        [cell1.labelTitle setTextColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00]];
    }else if (indexPath.row == 2) {
        cell1.labelTitle.text = self.model.story;
        [cell1.labelTitle setFont:[UIFont systemFontOfSize:14]];
        [cell1.labelTitle setTextColor:[UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00]];
    }
    return cell1;
}

- (void)didTouchRightButton {
    [self.shareView share];

}

- (void)makeShareView {
    WeakSelf(self);
    UserInfoModel *modelUser = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *shareURL = [NSString stringWithFormat:@"%@cblejflower/%@.htm",HTTP_BaseURL,self.model.flowerId];
    self.shareView.URL = shareURL;
    self.shareView.shareTitle = @"装修要花多少钱，点我10秒出报价";
    self.shareView.shareCompanyIntroduction = self.model.story;
    self.shareView.shareCompanyLogoImage = [UIImage imageNamed:@"img_small_xianhua_hongrenguan"];
    self.shareView.companyName = modelUser.trueName;
    self.shareView.blockQRCode1st = ^{
        FlowersStoryQRCodeViewController *controller = [FlowersStoryQRCodeViewController new];
        [controller.view setBackgroundColor:[UIColor whiteColor]];
        controller.labelTitle.text = @"鲜花-代表美好的祝福";
        controller.title = @"鲜花故事";
        controller.imageViewQRCode.image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:shareURL imageViewWidth:100];
        [weakself.navigationController pushViewController:controller animated:true];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
