//
//  CelebrityInterviewsArticleViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/20.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "CelebrityInterviewsArticleViewController.h"
#import "CelebrityInterviewsArticleTableViewCell.h"

@interface CelebrityInterviewsArticleViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *arrayData;
@end

@implementation CelebrityInterviewsArticleViewController

#pragma mark UI
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文章专访";
    [self createTableView];
}

- (void)createTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = 0;
}

#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3 + self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 3) {
        CelebrityInterviewsArticleTableViewCell *cell = [CelebrityInterviewsArticleTableViewCell cellWithTableView:tableView AndIndex:indexPath.row];
        return cell;
    }
    return nil;
}

@end
