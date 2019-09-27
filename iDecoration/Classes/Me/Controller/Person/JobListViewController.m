//
//  JobListViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/13.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "JobListViewController.h"
#import "JobNameTableViewCell.h"
#import "GetJobListApi.h"
#import "JobModel.h"

@interface JobListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *jobTableView;
@property (nonatomic, strong) NSMutableArray *jobsArray;

@end

@implementation JobListViewController

-(NSMutableArray*)jobsArray{
    
    if (!_jobsArray) {
        _jobsArray = [NSMutableArray array];
    }
    
    return _jobsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"职位角色";
    self.view.backgroundColor = White_Color;
    
    [self getJobList];
    [self createTableView];
}

-(void)getJobList{
    
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
            
            [self.jobTableView reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

-(void)createTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = White_Color;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:tableView];
    
    [tableView registerNib:[UINib nibWithNibName:@"JobNameTableViewCell" bundle:nil] forCellReuseIdentifier:@"JobNameTableViewCell"];
    
    self.jobTableView = tableView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.jobsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JobNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobNameTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    JobModel *model = self.jobsArray[indexPath.row];
    
    cell.titleLabel.text = model.cJobTypeName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JobModel *model = self.jobsArray[indexPath.row];
    
    NSDictionary *dict = [model yy_modelToJSONObject];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jobNoti" object:nil userInfo:dict];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
