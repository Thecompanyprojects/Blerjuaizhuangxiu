//
//  myteamVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "myteamVC.h"
#import "myteamModel.h"
#import "myteamsectionView.h"
#import "myteamCell.h"
#import "myteamheadView.h"
#import "dockingchooseVC.h"


@interface myteamVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UILabel *bottomLab;
@property (nonatomic,strong) myteamheadView *headView;
@property (nonatomic,strong) UIView *headView2;
@property (nonatomic,copy) NSString *trueName;
@property (nonatomic,copy) NSString *photo;

@end

static NSString *myteamidentfid = @"myteamidentfid";

@implementation myteamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的团队";
   
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    [self.view addSubview:self.bottomLab];
    
    [self setupUI];
    [self loaddataforpromote];
    
    self.table.tableHeaderView = self.headView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//分销员数据
-(void)loaddataforpromote
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
    NSDictionary *para = @{@"agencyId":agencyId,@"createCode":createCode};
    NSString *url = [BASEURL stringByAppendingString:POST_spreadManTeam];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSDictionary *data = [responseObj objectForKey:@"data"];
            
            NSDictionary *middleManInfo = [responseObj objectForKey:@"middleManInfo"];
            self.createCode = [middleManInfo objectForKey:@"createCode"];
            self.trueName = [middleManInfo objectForKey:@"trueName"];
            self.photo = [middleManInfo objectForKey:@"photo"];
            
            [self.headView setdata:self.trueName andcreateCode:self.createCode];
            [self.headView.infoimg sd_setImageWithURL:[NSURL URLWithString:self.photo] placeholderImage:[UIImage imageNamed:@"defaultman"]];
            
            
            NSMutableArray *teamList1 = [NSMutableArray new];;
            NSMutableArray *teamList2 = [NSMutableArray new];
            NSMutableArray *teamList3 = [NSMutableArray new];
            
            if ([[data objectForKey:@"teamList1"] isKindOfClass:[NSArray class]]) {
                teamList1 = [data objectForKey:@"teamList1"];
            }
            else
            {
                id teamlist001 = [data objectForKey:@"teamList1"];
                [teamList1 addObject:teamlist001];
            }
            
            
            
            if ([[data objectForKey:@"teamList2"] isKindOfClass:[NSArray class]]) {
                teamList2 = [data objectForKey:@"teamList2"];
            }
            else 
            {
                id teamlist002 = [data objectForKey:@"teamList2"];
                [teamList2 addObject:teamlist002];
            }
            
            if ([[data objectForKey:@"teamList3"] isKindOfClass:[NSArray class]]) {
                teamList3 = [data objectForKey:@"teamList3"];
            }
            else
            {
                id teamlist003 = [data objectForKey:@"teamList3"];
                [teamList3 addObject:teamlist003];
            }
     
            NSMutableArray *namearr1 = [NSMutableArray new];
            NSMutableArray *namearr2 = [NSMutableArray new];
            NSMutableArray *namearr3 = [NSMutableArray new];
            
            NSMutableArray *photoarr1 = [NSMutableArray new];
            NSMutableArray *photoarr2 = [NSMutableArray new];
            NSMutableArray *photoarr3 = [NSMutableArray new];
            
            NSMutableArray *isLevelarr1 = [NSMutableArray new];
            NSMutableArray *isLevelarr2 = [NSMutableArray new];
            NSMutableArray *isLevelarr3 = [NSMutableArray new];
            
            for (int i = 0; i<teamList1.count; i++) {
                NSDictionary *dic = [teamList1 objectAtIndex:i];
                
                NSString* name = [dic objectForKey:@"trueName"];
                //NSString* agencyId = [dic objectForKey:@"agencyId"];
                NSString* photo = [dic objectForKey:@"photo"];
                NSString* isLevel = [dic objectForKey:@"isLevel"];
                
                [namearr1 addObject:name];
                [photoarr1 addObject:photo];
                [isLevelarr1 addObject:isLevel];
            }
      
            for (int i = 0; i<teamList2.count; i++) {
                NSDictionary *dic = [teamList2 objectAtIndex:i];
                
                NSString* name = [dic objectForKey:@"trueName"];
                //NSString* agencyId = [dic objectForKey:@"agencyId"];
                NSString* photo = [dic objectForKey:@"photo"];
                NSString* isLevel = [dic objectForKey:@"isLevel"];
                [namearr2 addObject:name];
                [photoarr2 addObject:photo];
                [isLevelarr2 addObject:isLevel];
            }
    
            for (int i = 0; i<teamList3.count; i++) {
                NSDictionary *dic = [teamList3 objectAtIndex:i];
                
                NSString* name = [dic objectForKey:@"trueName"];
                //NSString* agencyId = [dic objectForKey:@"agencyId"];
                NSString* photo = [dic objectForKey:@"photo"];
                NSString* isLevel = [dic objectForKey:@"isLevel"];
                [namearr3 addObject:name];
                [photoarr3 addObject:photo];
                [isLevelarr3 addObject:isLevel];
            }
            
            self.dataArray = [NSMutableArray array];
                
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
            

            for (int i = 0; i<groupNames.count; i++) {
                NSMutableArray *name = [groupNames objectAtIndex:i];
                NSMutableArray *arr2 = [dataarr2 objectAtIndex:i];
                NSMutableArray *arr3 = [dataarr3 objectAtIndex:i];

                myteamModel *group1 = [[myteamModel alloc] initWithItem:name andphone:arr2 andleave:arr3 andcheckStatusarr:nil andagencyidarr:nil andisChange:nil andisThreeLevelarr:nil andcreateCodearr:nil];
                
                [self.dataArray addObject:group1];
            }

            [self.table reloadData];

        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)setupUI
{
    [self.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(14);
        make.bottom.equalTo(self.view);
        make.height.mas_offset(20);
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

-(UILabel *)bottomLab
{
    if(!_bottomLab)
    {
        _bottomLab = [[UILabel alloc] init];
        _bottomLab.textAlignment = NSTextAlignmentCenter;
        _bottomLab.font = [UIFont systemFontOfSize:12];
        _bottomLab.textColor = [UIColor hexStringToColor:@"CFCFCF"];
        _bottomLab.text = @"北京比邻而居科技有限公司支持";
    }
    return _bottomLab;
}


-(UIView *)headView2
{
    if(!_headView2)
    {
        _headView2 = [[UIView alloc] init];
        _headView2.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 60);
        UILabel *lab = [[UILabel alloc] init];
        [_headView2 addSubview:lab];
        lab.frame = CGRectMake(20, 20, kSCREEN_WIDTH-40, 20);
        lab.text = @"分销员申请记录";
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor darkGrayColor];
    }
    return _headView2;
}

-(myteamheadView *)headView
{
    if(!_headView)
    {
        _headView = [[myteamheadView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 160)];
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseduijie)];
        [_headView.bgView addGestureRecognizer:tapGesture];
        [tapGesture setNumberOfTapsRequired:1];
    }
    return _headView;
}

#pragma mark - UITableViewDataSource&&UITableViewDelegate

- (void) loadDataModel {
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray array];
    }

}

#pragma mark UITableViewDataSource回调方法
//这是tabview创建多少组的回调
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
//这是每个组有多少联系人的回调
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    myteamModel *group = self.dataArray[section];
    return group.isFolded? 0: group.size;
}
//将tabview的cell与数据模型绑定起来
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    myteamCell *cell = [tableView dequeueReusableCellWithIdentifier:myteamidentfid];
    if (!cell) {
        cell = [[myteamCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myteamidentfid];
    }
    //将模型里的数据赋值给cell
    myteamModel *group = self.dataArray[indexPath.section];
    NSArray *arr=group.items;
    cell.nameLab.text = arr[indexPath.row];
    NSArray *phone = group.phonearr;
//    NSArray *checkStatusarr = group.checkStatusarr;
//    NSString *checkStatus = checkStatusarr[indexPath.row];
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:phone[indexPath.row]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.btn0 setHidden:YES];
    [cell.btn1 setHidden:YES];
    [cell.typelab setHidden:YES];
    return cell;
}

#pragma mark UITableViewDelegate回调方法

//对hearderView进行编辑
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    myteamsectionView *nameView=[[myteamsectionView alloc]init];
    NSString *str2 = @"";
    NSString *str1 = @"";
    if (section==0) {
        
        myteamModel *group = self.dataArray[section];
        NSString * str3 = [NSString stringWithFormat:@"%ld",group.size];
        str1 = [NSString stringWithFormat:@"%@%@%@",@"(",str3,@")"];
        str2 = @"一级分销员";
        nameView.leftImg.image = [UIImage imageNamed:@"会员"];
    }
    if (section==1) {
        myteamModel *group = self.dataArray[section];
        NSString * str3 = [NSString stringWithFormat:@"%ld",group.size];
        str1 = [NSString stringWithFormat:@"%@%@%@",@"(",str3,@")"];
        nameView.leftImg.image = [UIImage imageNamed:@"会员1"];
        str2 = @"二级分销员";
    }
    if (section==2) {
        myteamModel *group = self.dataArray[section];
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
    myteamModel *group = self.dataArray[section];
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
//设置headerView高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 46;
}
//设置cell的高度
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
//button的响应点击事件
- (void) buttonClicked:(UIButton *) sender {
    //改变模型数据里面的展开收起状态
    myteamModel *group2 = self.dataArray[sender.tag - 200];
    group2.folded = !group2.isFolded;
    [self.table reloadData];
}

#pragma mark - 实现方法

//对接人选择
-(void)chooseduijie
{
    
}

@end
