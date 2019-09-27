//
//  activityzoneCommentVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/1.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "activityzoneCommentVC.h"
#import "activityzoneModel.h"
#import "activityzoneCell1.h"
#import "activityzoneCell0.h"
#import "commentsCell1.h"
#import "NSMutableView.h"
#import "zonecommentModel.h"
#import "zonecommentCell.h"

@interface activityzoneCommentVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableView *NSview;
@property (nonatomic,copy) NSString *content;
@end

static NSString *activityzonecommentidentfid0 = @"activityzonecommentidentfid0";
static NSString *activityzonecommentidentfid1 = @"activityzonecommentidentfid1";
static NSString *activityzonecommentidentfid2 = @"activityzonecommentidentfid2";
static NSString *activityzonecommentidentfid3 = @"activityzonecommentidentfid3";

@implementation activityzoneCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    self.NSview = [[NSMutableView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT -50, kSCREEN_WIDTH, 50)];
    self.content = [NSString new];
    [self.NSview.sendBtn addTarget:self action:@selector(sendbtnclick) forControlEvents:UIControlEventTouchUpInside];
    self.NSview.textView.delegate = self;
    [self.view addSubview:self.NSview];
    [self loaddata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loaddata
{
    [self.dataSource removeAllObjects];
    NSString *url = [BASEURL stringByAppendingString:GET_designcommentlist];
    NSString *designsId = [NSString new];
    if (self.ishome) {
        designsId = [NSString stringWithFormat:@"%ld",self.homeModel.designsId];
    }
    else
    {
        designsId = [NSString stringWithFormat:@"%ld",self.zoneModel.designsId];
    }
    NSDictionary *para = @{@"designsId":designsId};
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[zonecommentModel class] json:responseObj[@"data"][@"list"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] init];
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        _table.frame = CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_WIDTH, naviBottom);
        _table.dataSource = self;
        _table.delegate = self;
        [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _table;
}

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    if (section==1) {
        return 1;
    }
    if (section==2) {
        return self.dataSource.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            activityzoneCell0 *cell = [tableView dequeueReusableCellWithIdentifier:activityzonecommentidentfid0];
            cell = [[activityzoneCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activityzonecommentidentfid0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
            if (self.ishome) {
                [cell setdata2:self.homeModel];
            }
            else
            {
                 [cell setdata:self.zoneModel];
            }
            return cell;
        }
        if (indexPath.row==1) {
            activityzoneCell1 *cell = [tableView dequeueReusableCellWithIdentifier:activityzonecommentidentfid1];
            cell = [[activityzoneCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activityzonecommentidentfid1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.homeModel) {
                [cell setdata2:self.homeModel];
            }
            else
            {
                [cell setdata:self.zoneModel];
            }
            return cell;
        }
    }
    if (indexPath.section==1) {
        commentsCell1 *cell = [tableView dequeueReusableCellWithIdentifier:activityzonecommentidentfid2];
        cell = [[commentsCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activityzonecommentidentfid2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataSource.count==0) {
            cell.numberLab.text = @"暂无评论";
        }
        else
        {
            cell.numberLab.text = [NSString stringWithFormat:@"%@%lu%@",@"评论(",(unsigned long)self.dataSource.count,@")"];
        }
        return cell;
    }
    if (indexPath.section==2) {
        zonecommentCell *cell = [tableView dequeueReusableCellWithIdentifier:activityzonecommentidentfid3];
        cell = [[zonecommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activityzonecommentidentfid3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setdata:self.dataSource[indexPath.row]];
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 70;
        }
        if (indexPath.row==1) {
            return 128;
        }
    }
    if (indexPath.section==1) {
         return [self cellHeightForIndexPath:indexPath cellContentViewWidth:kSCREEN_WIDTH tableView:self.table];
    }
    if (indexPath.section==2) {
        return [self cellHeightForIndexPath:indexPath cellContentViewWidth:kSCREEN_WIDTH tableView:self.table];
    }
    return 0.01f;
}
//结束编辑

- (void)textViewDidChange:(UITextView *)textView{
    NSString *content = textView.text;
    NSLog(@"content----%@",content);
    self.content = content;
}

-(void)sendbtnclick
{
    NSString *url = [BASEURL stringByAppendingString:Local_meiwenliuyan];
    NSString *designsId = [NSString new];
    if (self.ishome) {
         designsId = [NSString stringWithFormat:@"%ld",self.homeModel.designsId];
    }
    else
    {
         designsId = [NSString stringWithFormat:@"%ld",self.zoneModel.designsId];
    }
   
    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    if (self.content.length==0) {
        
    }
    else
    {
        NSDictionary *para = @{@"designsId":designsId,@"agencysId":agencysId,@"content":self.content};
        [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
            if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                [self loaddata];
                //创建通知对象
                NSNotification *notification = [NSNotification notificationWithName:@"activityzonecomment" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }
}

@end
