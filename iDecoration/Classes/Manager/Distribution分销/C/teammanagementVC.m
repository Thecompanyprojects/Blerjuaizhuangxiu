//
//  teammanagementVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "teammanagementVC.h"
#import "myteamCell.h"
#import "myteamModel.h"
#import "myteamsectionView.h"
#import "dockingchooseVC.h"
#import "infodetailsVC.h"



@interface teammanagementVC ()<UITableViewDataSource,UITableViewDelegate,myTabVdelegate>
{
    BOOL isend;
}
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UIView *headview;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIButton *btn0;
@property (nonatomic,strong) UIButton *btn1;
@property (nonatomic,strong) NSString *typestr;
@end

static NSString *teammanagementidetfid = @"teammanagementidetfid";

@implementation teammanagementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"团队记录";
    self.typestr = @"0";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:@"change" object:nil];
    [self.view addSubview:self.table];
    self.dataSource = [NSMutableArray array];
    self.table.tableHeaderView = self.headview;
    self.table.tableFooterView = [UIView new];
    isend = YES;
    [self loaddata0];
}
-(void)notice:(id)sender{
    NSLog(@"%@",sender);
    [self loaddata1];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loaddata0
{
    [self.dataSource removeAllObjects];
    NSString *agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    //createCode
    NSString *createCode = @"";
    if (IsNilString(self.createCode)) {
        createCode = @"";
    }
    else
    {
        createCode = self.createCode;
    }
    
    NSDictionary *para = @{@"agencyId":agencyId,@"createCode":self.createCode};
    NSString *url = [BASEURL stringByAppendingString:POST_SHENQIQGJILU];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            id data = [responseObj objectForKey:@"data"];
            NSArray *listarr = [data objectForKey:@"spreadList"];
            NSMutableArray *namearr1 = [NSMutableArray new];
            NSMutableArray *photoarr1 = [NSMutableArray new];
            NSMutableArray *isLevelarr1 = [NSMutableArray new];
            NSMutableArray *checkStatus1 = [NSMutableArray new];
            NSMutableArray *agencyIdarr1 = [NSMutableArray new];
            for (int i = 0;i<listarr.count ; i++) {
                NSDictionary *dic = [listarr objectAtIndex:i];
                NSString *isLevel = [dic objectForKey:@"isLevel"];
                NSString *checkStatus = [dic objectForKey:@"checkStatus"];
                NSString* name = [dic objectForKey:@"trueName"];
                NSString* photo = [dic objectForKey:@"photo"];
                NSString *agencyId = [dic objectForKey:@"agencyId"];
                
                [namearr1 addObject:name];
                [photoarr1 addObject:photo];
                [isLevelarr1 addObject:isLevel];
                [checkStatus1 addObject:checkStatus];
                [agencyIdarr1 addObject:agencyId];
            }
            
            NSMutableArray *groupNames = [NSMutableArray array];
            [groupNames addObject:namearr1];
            
            NSMutableArray *dataarr2 = [NSMutableArray array];
            [dataarr2 addObject:photoarr1];
            
            NSMutableArray *dataarr3 = [NSMutableArray array];
            [dataarr3 addObject:isLevelarr1];
            
            NSMutableArray *dataarr4 = [NSMutableArray array];
            [dataarr4 addObject:checkStatus1];
            
            NSMutableArray *dataarr5 = [NSMutableArray array];
            [dataarr5 addObject:agencyIdarr1];
            
            for (int i = 0; i<groupNames.count; i++) {
                NSMutableArray *name = [groupNames objectAtIndex:i];
                NSMutableArray *arr2 = [dataarr2 objectAtIndex:i];
                NSMutableArray *arr3 = [dataarr3 objectAtIndex:i];
                NSMutableArray *arr4 = [dataarr4 objectAtIndex:i];
                NSMutableArray *arr5 = [dataarr5 objectAtIndex:i];
                
                 myteamModel *group1 = [[myteamModel alloc] initWithItem:name andphone:arr2 andleave:arr3 andcheckStatusarr:arr4 andagencyidarr:arr5 andisChange:nil andisThreeLevelarr:nil andcreateCodearr:nil];
        
                [self.dataSource addObject:group1];
                
               
            }
            [self.table reloadData];
          
        }
    } failed:^(NSString *errorMsg) {
        
    }];
    
}

//对接人数据
-(void)loaddata1
{
    NSString *agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    //createCode
    NSString *createCode = @"";
    if (IsNilString(self.createCode)) {
        createCode = @"";
    }
    else
    {
        createCode = self.createCode;
    }
    
    NSDictionary *para = @{@"agencyId":agencyId};
    NSString *url = [BASEURL stringByAppendingString:POST_middelManTeam];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            self.dataSource= [NSMutableArray array];

            NSMutableArray *namearr1 = [NSMutableArray new];
            NSMutableArray *namearr2 = [NSMutableArray new];
            NSMutableArray *namearr3 = [NSMutableArray new];
            
            NSMutableArray *photoarr1 = [NSMutableArray new];
            NSMutableArray *photoarr2 = [NSMutableArray new];
            NSMutableArray *photoarr3 = [NSMutableArray new];
            
            NSMutableArray *isLevelarr1 = [NSMutableArray new];
            NSMutableArray *isLevelarr2 = [NSMutableArray new];
            NSMutableArray *isLevelarr3 = [NSMutableArray new];
            
            NSMutableArray *checkStatus1 = [NSMutableArray new];
            NSMutableArray *checkStatus2 = [NSMutableArray new];
            NSMutableArray *checkStatus3 = [NSMutableArray new];
            
            NSMutableArray *agencyIdarr1 = [NSMutableArray new];
            NSMutableArray *agencyIdarr2 = [NSMutableArray new];
            NSMutableArray *agencyIdarr3 = [NSMutableArray new];
            
            NSMutableArray *isChangearr1 = [NSMutableArray new];
            NSMutableArray *isChangearr2 = [NSMutableArray new];
            NSMutableArray *isChangearr3 = [NSMutableArray new];
            
            NSMutableArray *isThreeLevelarr1 = [NSMutableArray new];
            NSMutableArray *isThreeLevelarr2 = [NSMutableArray new];
            NSMutableArray *isThreeLevelarr3 = [NSMutableArray new];
            
            NSMutableArray *createCodearr1 = [NSMutableArray new];
            NSMutableArray *createCodearr2 = [NSMutableArray new];
            NSMutableArray *createCodearr3 = [NSMutableArray new];
            
            
            id data = [responseObj objectForKey:@"data"];
            NSArray *listarr = [data objectForKey:@"spreadList"];
            
            
            
            for (int i = 0;i<listarr.count ; i++) {
                NSDictionary *dic = [listarr objectAtIndex:i];
                NSString *isLevel = [dic objectForKey:@"isLevel"];
                NSString *checkStatus = [dic objectForKey:@"checkStatus"];
                NSString* name = [dic objectForKey:@"trueName"];
                NSString* photo = [dic objectForKey:@"photo"];
                NSString *agencyId = [dic objectForKey:@"agencyId"];
                NSString *isChange = [dic objectForKey:@"isChange"];
                NSString *isThreeLevel = [dic objectForKey:@"isThreeLevel"];
                NSString *createCode = [dic objectForKey:@"createCode"];
                
                if ([isLevel isEqualToString:@"1"]) {
                    [namearr1 addObject:name];
                    [photoarr1 addObject:photo];
                    [isLevelarr1 addObject:isLevel];
                    [checkStatus1 addObject:checkStatus];
                    [agencyIdarr1 addObject:agencyId];
                    [isChangearr1 addObject:isChange];
                    [isThreeLevelarr1 addObject:isThreeLevel];
                    [createCodearr1 addObject:createCode];
                }
                if ([isLevel isEqualToString:@"2"]) {
                    [namearr2 addObject:name];
                    [photoarr2 addObject:photo];
                    [isLevelarr2 addObject:isLevel];
                    [checkStatus2 addObject:checkStatus];
                    [agencyIdarr2 addObject:agencyId];
                    [isChangearr2 addObject:isChange];
                    [isThreeLevelarr2 addObject:isThreeLevel];
                    [createCodearr2 addObject:createCode];
                }
                if ([isLevel isEqualToString:@"3"]) {
                    [namearr3 addObject:name];
                    [photoarr3 addObject:photo];
                    [isLevelarr3 addObject:isLevel];
                    [checkStatus3 addObject:checkStatus];
                    [agencyIdarr3 addObject:agencyId];
                    [isChangearr3 addObject:isChange];
                    [isThreeLevelarr3 addObject:isThreeLevel];
                    [createCodearr3 addObject:createCode];
                }
            }
            
            NSMutableArray *groupNames = [NSMutableArray array];
            
            [groupNames addObject:namearr1];
            [groupNames addObject:namearr2];
            [groupNames addObject:namearr3];
            
            NSMutableArray *dataarr2 = [NSMutableArray array];
            [dataarr2 addObject:photoarr1];
            [dataarr2 addObject:photoarr2];
            [dataarr2 addObject:photoarr3];
            
            NSMutableArray *dataarr3 = [NSMutableArray array];
            [dataarr3 addObject:isLevelarr1];
            [dataarr3 addObject:isLevelarr2];
            [dataarr3 addObject:isLevelarr3];
            
            NSMutableArray *dataarr4 = [NSMutableArray array];
            [dataarr4 addObject:checkStatus1];
            [dataarr4 addObject:checkStatus2];
            [dataarr4 addObject:checkStatus3];
            
            NSMutableArray *dataarr5 = [NSMutableArray array];
            [dataarr5 addObject:agencyIdarr1];
            [dataarr5 addObject:agencyIdarr2];
            [dataarr5 addObject:agencyIdarr3];
            
            NSMutableArray *dataarr6 = [NSMutableArray array];
            [dataarr6 addObject:isChangearr1];
            [dataarr6 addObject:isChangearr2];
            [dataarr6 addObject:isChangearr3];
            
            NSMutableArray *dataarr7 = [NSMutableArray array];
            [dataarr7 addObject:isThreeLevelarr1];
            [dataarr7 addObject:isThreeLevelarr2];
            [dataarr7 addObject:isThreeLevelarr3];
            
            NSMutableArray *dataarr8 = [NSMutableArray array];
            [dataarr8 addObject:createCodearr1];
            [dataarr8 addObject:createCodearr2];
            [dataarr8 addObject:createCodearr3];
            
            
            for (int i = 0; i<groupNames.count; i++) {
                NSMutableArray *name = [groupNames objectAtIndex:i];
                NSMutableArray *arr2 = [dataarr2 objectAtIndex:i];
                NSMutableArray *arr3 = [dataarr3 objectAtIndex:i];
                NSMutableArray *arr4 = [dataarr4 objectAtIndex:i];
                NSMutableArray *arr5 = [dataarr5 objectAtIndex:i];
                NSMutableArray *arr6 = [dataarr6 objectAtIndex:i];
                NSMutableArray *arr7 = [dataarr7 objectAtIndex:i];
                NSMutableArray *arr8 = [dataarr8 objectAtIndex:i];
                
                myteamModel *group1 = [[myteamModel alloc] initWithItem:name andphone:arr2 andleave:arr3 andcheckStatusarr:arr4 andagencyidarr:arr5 andisChange:arr6 andisThreeLevelarr:arr7 andcreateCodearr:arr8];
                [self.dataSource addObject:group1];
            }
            
            [self.table reloadData];
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}


#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom) style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
    }
    return _table;
}


-(UIView *)headview
{
    if(!_headview)
    {
        _headview = [[UIView alloc] init];
        _headview.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 60);
        [_headview addSubview:self.btn0];
        [_headview addSubview:self.btn1];
    }
    return _headview;
}


-(UIButton *)btn0
{
    if(!_btn0)
    {
        _btn0 = [[UIButton alloc] init];
        _btn0.frame = CGRectMake(10, 10, 60, 30);
        [_btn0 setTitleColor:Main_Color forState:normal];
        _btn0.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn0 setTitle:@"申请记录" forState:normal];
        [_btn0 addTarget:self action:@selector(btn0click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn0;
}

-(UIButton *)btn1
{
    if(!_btn1)
    {
        _btn1 = [[UIButton alloc] init];
        _btn1.frame = CGRectMake(80, 10, 60, 30);
        [_btn1 setTitleColor:[UIColor darkGrayColor] forState:normal];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn1 setTitle:@"我的团队" forState:normal];
        [_btn1 addTarget:self action:@selector(btn1click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn1;
}


#pragma mark - UITableViewDataSource&&UITableViewDataSource

//这是tabview创建多少组的回调

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

//这是每个组有多少联系人的回调
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    myteamModel *group = self.dataSource[section];
    if ([self.typestr isEqualToString:@"0"]) {
        //return group.isFolded? 0: group.size;
        return group.size;
    }
    else
    {
        return group.isFolded? 0: group.size;
    }
}

//将tabview的cell与数据模型绑定起来
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    myteamCell *cell = [tableView dequeueReusableCellWithIdentifier:teammanagementidetfid];
    if (!cell) {
        cell = [[myteamCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:teammanagementidetfid];
    }
    cell.delegate = self;
    //将模型里的数据赋值给cell
    myteamModel *group = self.dataSource[indexPath.section];
    NSArray *arr=group.items;
    NSArray *isleave = group.isLevelarr;
    NSString *levelstr = isleave[indexPath.row];
    NSString *name = arr[indexPath.row];
    
    if ([self.typestr isEqualToString:@"0"]) {
        if ([levelstr isEqualToString:@"1"]) {
          
            cell.nameLab.text = [NSString stringWithFormat:@"%@%@",name,@"申请成为一级分销员"];
        }
        if ([levelstr isEqualToString:@"2"]) {

            cell.nameLab.text = [NSString stringWithFormat:@"%@%@",name,@"申请成为二级分销员"];
        }
        if ([levelstr isEqualToString:@"3"]) {
            
            cell.nameLab.text = [NSString stringWithFormat:@"%@%@",name,@"申请成为三级分销员"];
        }
    }
    else
    {
          cell.nameLab.text = arr[indexPath.row];
    }
    
    NSArray *phone = group.phonearr;
    
    if ([self.typestr isEqualToString:@"0"]) {
        group.folded = NO;
    }
    
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:phone[indexPath.row]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.typestr isEqualToString:@"0"]) {
        [cell.btn0 setHidden:NO];
        [cell.btn1 setHidden:NO];
    }
    else
    {
        [cell.btn0 setHidden:YES];
        [cell.btn1 setHidden:YES];
        if (isend) {
            cell.btn1.enabled =YES;
            
        }
        else
        {
            cell.btn1.enabled =NO;
        }
    }
    NSArray *isThreeLevelarr = group.isThreeLevelarr;
    NSString *isThreeLevel = isThreeLevelarr[indexPath.row];
    
    NSArray *isChangearr = group.isChangearr;
    NSString *isChange = isChangearr[indexPath.row];

    if ([isThreeLevel isEqualToString:@"1"]) {
        
        [cell.typelab setHidden:NO];
        //是否指派(0.默认值,1.待审核,2.审核通过)
        if ([isChange isEqualToString:@"1"]) {
            cell.typelab.text = @"待审核";
            cell.typelab.textColor = [UIColor redColor];
        }
        if ([isChange isEqualToString:@"0"]) {
            cell.typelab.text = @"指派";
            cell.typelab.textColor = [UIColor hexStringToColor:@"AEAEAE"];
        }
        
    }
    else
    {
        [cell.typelab setHidden:YES];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    myteamModel *group = self.dataSource[indexPath.section];
    NSArray *isThreeLevelarr = group.isThreeLevelarr;
    NSString *isThreeLevel = isThreeLevelarr[indexPath.row];
    
    NSArray *isChangearr = group.isChangearr;
    NSString *isChange = isChangearr[indexPath.row];
    
    NSArray *agencyidarr = group.agencyidarr;
    NSString *agencyid = agencyidarr[indexPath.row];

    if ([isThreeLevel isEqualToString:@"1"]) {
        //是否指派(0.默认值,1.待审核,2.审核通过)
        
        if ([isChange isEqualToString:@"0"]) {
            //指派
            dockingchooseVC *vc = [dockingchooseVC new];
            vc.useragencyId = agencyid;//推广员id
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}
//对hearderView进行编辑
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.typestr isEqualToString:@"0"]) {
        return [UIView new];
        
       /* myteamsectionView *nameView=[[myteamsectionView alloc]init];
        myteamModel *group = self.dataSource[section];
        NSString *str2 = @"";
        NSString *str1 = @"";
        NSString * str3 = [NSString stringWithFormat:@"%ld",group.size];
        str1 = [NSString stringWithFormat:@"%@%@%@",@"(",str3,@")"];
        str2 = @"推广员申请列表";
        nameView.leftImg.image = [UIImage imageNamed:@"会员"];
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
        myteamModel *group1 = self.dataSource[section];
        if (group1.isFolded==YES) {
            fuhao.image=[UIImage imageNamed:@"向右"];
            fuhao.frame = CGRectMake(kSCREEN_WIDTH-10-14, 14, 10, 18);
        }else{
            fuhao.image=[UIImage imageNamed:@"向下"];
            fuhao.frame = CGRectMake(kSCREEN_WIDTH-10-14, 18, 18, 10);
        }
        return nameView;*/
    }
    else
    {
        myteamsectionView *nameView=[[myteamsectionView alloc]init];
        NSString *str2 = @"";
        NSString *str1 = @"";
        if (section==0) {
            
            myteamModel *group = self.dataSource[section];
            NSString * str3 = [NSString stringWithFormat:@"%ld",group.size];
            str1 = [NSString stringWithFormat:@"%@%@%@",@"(",str3,@")"];
            str2 = @"一级分销员";
            nameView.leftImg.image = [UIImage imageNamed:@"会员"];
        }
        if (section==1) {
            myteamModel *group = self.dataSource[section];
            NSString * str3 = [NSString stringWithFormat:@"%ld",group.size];
            str1 = [NSString stringWithFormat:@"%@%@%@",@"(",str3,@")"];
            nameView.leftImg.image = [UIImage imageNamed:@"会员1"];
            str2 = @"二级分销员";
        }
        if (section==2) {
            myteamModel *group = self.dataSource[section];
            NSString * str3 = [NSString stringWithFormat:@"%ld",group.size];
            str1 = [NSString stringWithFormat:@"%@%@%@",@"(",str3,@")"];
            nameView.leftImg.image = [UIImage imageNamed:@"团队"];
            str2 = @"三级分销员";
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
  
}

//设置headerView高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.typestr isEqualToString:@"0"]) {
        return 0.01f;
    }
    else
    {
        return 46;
    }
//    return 46;
}
//设置cell的高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

//button的响应点击事件
- (void) buttonClicked:(UIButton *) sender {
    //改变模型数据里面的展开收起状态
    myteamModel *group2 = self.dataSource[sender.tag - 200];
    group2.folded = !group2.isFolded;
    [self.table reloadData];
}

#pragma mark - 实现方法

-(void)btn0click
{
    [self.btn1 setTitleColor:[UIColor darkGrayColor] forState:normal];
    [self.btn0 setTitleColor:Main_Color forState:normal];
    self.typestr = @"0";
    [self loaddata0];
}

-(void)btn1click
{
    [self.btn0 setTitleColor:[UIColor darkGrayColor] forState:normal];
    [self.btn1 setTitleColor:Main_Color forState:normal];
    self.typestr = @"1";
    [self loaddata1];
}

#pragma mark - 拒绝

-(void)myTabVClick1:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.table indexPathForCell:cell];
    myteamModel *group = self.dataSource[index.section];
    NSArray *arr=group.agencyidarr;
    //    cell.nameLab.text = arr[indexPath.row];
    NSString *spreadId = arr[index.row];//分销员id
    NSInteger strint = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    NSString *str = [NSString stringWithFormat:@"%ld",strint];
    NSString *agencyId = @"";
    if (IsNilString(str)) {
        agencyId = @"0";
    }
    else
    {
        agencyId = str;
    }
    NSString *applyStatus = @"2";
    NSDictionary *dic = @{@"agencyId":agencyId,@"spreadId":spreadId,@"applyStatus":applyStatus};
    NSString *url = [BASEURL stringByAppendingString:POST_updateApplyStatus];
    [NetManager afPostRequest:url parms:dic finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"处理成功" controller:self sleep:1.5];
            [self loaddata0];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 同意

-(void)myTabVClick2:(UITableViewCell *)cell
{
    isend = NO;
    
    NSIndexPath *index = [self.table indexPathForCell:cell];
    myteamModel *group = self.dataSource[index.section];
    NSArray *arr=group.agencyidarr;
    
    NSString *spreadId = arr[index.row];//分销员id
    NSInteger strint = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    NSString *str = [NSString stringWithFormat:@"%ld",strint];
    NSString *agencyId = @"";
    if (IsNilString(str)) {
        agencyId = @"0";
    }
    else
    {
        agencyId = str;
    }
    NSString *applyStatus = @"1";
    NSDictionary *dic = @{@"agencyId":agencyId,@"spreadId":spreadId,@"applyStatus":applyStatus};
    NSString *url = [BASEURL stringByAppendingString:POST_updateApplyStatus];
    [NetManager afPostRequest:url parms:dic finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"处理成功" controller:self sleep:1.5];
            [self loaddata0];
        }
        isend = YES;
    } failed:^(NSString *errorMsg) {
        isend = YES;
    }];
}

#pragma mark - 查看详情

-(void)myTabVClick3:(UITableViewCell *)cell
{
    infodetailsVC *vc = [infodetailsVC new];
    NSIndexPath *index = [self.table indexPathForCell:cell];
    myteamModel *group = self.dataSource[index.section];
    NSArray *arr=group.agencyidarr;
    NSString *spreadId = arr[index.row];//分销员id
    NSArray *arr3 = group.createCodearr;
    vc.agencyId = spreadId;
    if ([self.typestr isEqualToString:@"0"]) {
        vc.createCode = @"";
    }
    else
    {
         vc.createCode = arr3[index.row];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"change" object:nil];
}

@end
