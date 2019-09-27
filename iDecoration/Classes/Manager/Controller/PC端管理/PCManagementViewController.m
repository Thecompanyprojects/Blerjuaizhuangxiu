//
//  PCManagementViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/7/4.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "PCManagementViewController.h"
#import "VIPExperienceTableViewCell.h"
@interface PCManagementViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PCManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PC端管理";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pc"]];
    imageView.width = kSCREEN_WIDTH;
    [self.scrollView addSubview:imageView];
    [self.scrollView setContentSize:imageView.bounds.size];
}

- (void)createTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VIPExperienceTableViewCell *cell = [VIPExperienceTableViewCell cellWithTableView:tableView AndIndex:4];
    [cell.imageView setImage:[UIImage imageNamed:@"pc"]];
    cell.imageView.contentMode = UIViewContentModeCenter;
    return cell;//UIViewContentModeCenter
}

@end
