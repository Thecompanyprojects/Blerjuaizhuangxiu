//
//  infodetailsVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "infodetailsVC.h"
#import "myteamCell.h"
#import "myteamModel.h"
#import "myteamsectionView.h"
#import "myinfoeadView.h"

@interface infodetailsVC ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isshow;
}
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSDictionary *agency;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) myinfoeadView *headView;
@end

@implementation infodetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    isshow = NO;
    [self.view addSubview:self.table];
    self.agency = [NSDictionary dictionary];
    
    self.table.tableHeaderView = self.headView;
    if (self.createCode.length!=0) {
        self.headView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 180);
        [self.headView.topLab setHidden:YES];
        [self.headView.leftImg setHidden:YES];
        [self.headView.rightImg setHidden:YES];
    }
    else
    {
        self.headView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 340);
        [self.headView.topLab setHidden:NO];
        [self.headView.leftImg setHidden:NO];
        [self.headView.rightImg setHidden:NO];
    }
    self.table.tableFooterView = [UIView new];
    
    if (self.createCode.length!=0) {
        [self getuserinfo];
        [self loaddata];
    }
    else
    {
        [self getuserinfo];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getuserinfo
{
    NSString *url = [BASEURL stringByAppendingString:GetUserInfoUrl];
    NSDictionary *para = @{@"agencyId":self.agencyId};
    self.agency = [NSDictionary dictionary];
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            self.agency = [responseObj objectForKey:@"agency"];
            
            [self.headView setdata:self.agency];
        }
        [self.table reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)loaddata
{
    NSString *url = [BASEURL stringByAppendingString:GET_INFOTUIGUANGYUAN];
    [self.dataSource removeAllObjects];
    NSDictionary *para = @{@"agencyId":self.agencyId,@"createCode":self.createCode};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {

 
            isshow = YES;
            
            NSMutableArray *namearr1 = [NSMutableArray new];
            NSMutableArray *namearr2 = [NSMutableArray new];
            
            NSMutableArray *photoarr1 = [NSMutableArray new];
            NSMutableArray *photoarr2 = [NSMutableArray new];
            
            NSMutableArray *isLevelarr1 = [NSMutableArray new];
            NSMutableArray *isLevelarr2 = [NSMutableArray new];
            
            id data = [responseObj objectForKey:@"data"];
            NSArray *listarr1 = [data objectForKey:@"upTeamList"];
            NSArray *listarr2 = [data objectForKey:@"downTeamList"];
            
            for (int i = 0;i<listarr1.count ; i++) {
                NSDictionary *dic = [listarr1 objectAtIndex:i];
                NSString *isLevel = [dic objectForKey:@"isLevel"];
                isLevel = @"1";
                NSString* name = [dic objectForKey:@"trueName"];
                NSString* photo = [dic objectForKey:@"photo"];
                
                [namearr1 addObject:name];
                [photoarr1 addObject:photo];
                [isLevelarr1 addObject:isLevel];
            }
            for (int i = 0;i<listarr2.count ; i++) {
                NSDictionary *dic = [listarr2 objectAtIndex:i];
                NSString *isLevel = [dic objectForKey:@"isLevel"];
                isLevel = @"2";
                NSString* name = [dic objectForKey:@"trueName"];
                NSString* photo = [dic objectForKey:@"photo"];
                
                [namearr2 addObject:name];
                [photoarr2 addObject:photo];
                [isLevelarr2 addObject:isLevel];
            }
            
            NSMutableArray *groupNames = [NSMutableArray array];
            
            [groupNames addObject:namearr1];
            [groupNames addObject:namearr2];

            
            NSMutableArray *dataarr2 = [NSMutableArray array];
            [dataarr2 addObject:photoarr1];
            [dataarr2 addObject:photoarr2];

            
            NSMutableArray *dataarr3 = [NSMutableArray array];
            [dataarr3 addObject:isLevelarr1];
            [dataarr3 addObject:isLevelarr2];
            
            for (int i = 0; i<groupNames.count; i++) {
                NSMutableArray *name = [groupNames objectAtIndex:i];
                NSMutableArray *arr2 = [dataarr2 objectAtIndex:i];
                NSMutableArray *arr3 = [dataarr3 objectAtIndex:i];
               
                myteamModel *group1 = [[myteamModel alloc] initWithItem:name andphone:arr2 andleave:arr3 andcheckStatusarr:nil andagencyidarr:nil andisChange:nil andisThreeLevelarr:nil andcreateCodearr:nil];
                [self.dataSource addObject:group1];
            }

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
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom)];
        _table.dataSource = self;
        _table.delegate = self;
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

-(myinfoeadView *)headView
{
    if(!_headView)
    {
        _headView = [[myinfoeadView alloc] init];
       
    }
    return _headView;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.createCode.length==0) {
        return 0;
    }
    else
    {
        return self.dataSource.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    myteamModel *group = self.dataSource[section];
    return group.isFolded? 0: group.size;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    myteamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teammanagementidetfid"];
    if (!cell) {
        cell = [[myteamCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"teammanagementidetfid"];
    }
    myteamModel *group = self.dataSource[indexPath.section];
    NSArray *arr=group.items;
    NSString *name = arr[indexPath.row];
    NSArray *arr2 = group.phonearr;
    NSString *phone = arr2[indexPath.row];
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:phone]];
    cell.nameLab.text = name;
    [cell.btn0 setHidden:YES];
    [cell.btn1 setHidden:YES];
    [cell.typelab setHidden:YES];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    myteamsectionView *nameView=[[myteamsectionView alloc]init];
    NSString *str2 = @"";
    NSString *str1 = @"";
    if (section==0) {
        
        myteamModel *group = self.dataSource[section];
        NSString * str3 = [NSString stringWithFormat:@"%ld",group.size];
        str1 = [NSString stringWithFormat:@"%@%@%@",@"(",str3,@")"];
        str2 = @"上级分销员";
        nameView.leftImg.image = [UIImage imageNamed:@"会员"];
    }
    if (section==1) {
        myteamModel *group = self.dataSource[section];
        NSString * str3 = [NSString stringWithFormat:@"%ld",group.size];
        str1 = [NSString stringWithFormat:@"%@%@%@",@"(",str3,@")"];
        nameView.leftImg.image = [UIImage imageNamed:@"会员1"];
        str2 = @"下级分销员";
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@",str2,str1];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor darkGrayColor]
     
                          range:NSMakeRange(0, str2.length)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:Main_Color
     
                          range:NSMakeRange(str2.length, str1.length)];
    nameView.nameLab.attributedText = AttributedStr;
    
    //添加一个button用于响应点击事件（展开还是收起）
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, self.view.frame.size.width, 40);
    [nameView addSubview:button];
    button.tag = 200 + section;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //将显示展开还是收起的状态通过三角符号显示出来
    UIImageView *fuhao=[[UIImageView alloc]init];
    fuhao.tag=section;
    [nameView addSubview:fuhao];
    //根据模型里面的展开还是收起变换图片
    myteamModel *group = self.dataSource[section];
    if (group.isFolded==YES) {
        fuhao.image=[UIImage imageNamed:@"向右"];
        fuhao.frame = CGRectMake(kSCREEN_WIDTH-10-14, 14, 10, 18);
    }else{
        fuhao.image=[UIImage imageNamed:@"向下"];
        fuhao.frame = CGRectMake(kSCREEN_WIDTH-10-14, 18, 18, 10);
    }
    //返回nameView
    return nameView;
}

//button的响应点击事件
- (void) buttonClicked:(UIButton *) sender {
    //改变模型数据里面的展开收起状态
    myteamModel *group2 = self.dataSource[sender.tag - 200];
    group2.folded = !group2.isFolded;
    [self.table reloadData];
}


@end
