//
//  ZCHJobListView.m
//  iDecoration
//
//  Created by 赵春浩 on 17/6/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHJobListView.h"
#import "JobNameTableViewCell.h"
#import "GetJobListApi.h"
#import "JobModel.h"

@interface ZCHJobListView ()<UITableViewDelegate, UITableViewDataSource, JobNameTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *jobsArray;

@end


@implementation ZCHJobListView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.jobsArray = [NSMutableArray array];
        [self registerNib:[UINib nibWithNibName:@"JobNameTableViewCell" bundle:nil] forCellReuseIdentifier:@"JobNameTableViewCell"];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        [self getJobList];
    }
    return self;
}

- (void)getJobList {
    
    GetJobListApi *jobApi = [[GetJobListApi alloc]init];
    [jobApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSDictionary *dict = request.responseJSONObject;
        
        NSInteger code = [[dict objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
            
            NSArray *jobArr = [dict objectForKey:@"list"];
            for (NSDictionary *dict in jobArr) {
                
                JobModel *model = [JobModel yy_modelWithJSON:dict];
                [self.jobsArray addObject:model];
            }
            
            [self reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.jobsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JobNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobNameTableViewCell"];
    cell.delegate = self;
    cell.indexPath = indexPath;
    JobModel *model = self.jobsArray[indexPath.row];
    cell.titleLabel.text = model.cJobTypeName;
    if (([cell.titleLabel.text isEqualToString:self.jobName] && self.jobName != nil) || (self.jobName == nil && indexPath.row == 4)) {
        
        cell.selectBtn.selected = YES;
    } else {
        
        cell.selectBtn.selected = NO;
    }
    
    return cell;
}

- (void)didClickSelectedBtn:(UIButton *)btn withIndexpath:(NSIndexPath *)indexpath {
    
    JobModel *model = self.jobsArray[indexpath.row];
    self.jobName = model.cJobTypeName;
    NSDictionary *dict = [model yy_modelToJSONObject];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jobNoti" object:nil userInfo:dict];
}


@end
