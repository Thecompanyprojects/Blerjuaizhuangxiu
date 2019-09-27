//
//  chooseimplementVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "chooseimplementVC.h"
#import "CompanyPeopleInfoModel.h"
#import "chooseimplementCell.h"
#import <UIButton+LXMImagePosition.h>
#import "agreementVC.h"


@interface chooseimplementVC ()<UITableViewDataSource,UITableViewDelegate,myTabVdelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *agencysIdsArray;
@property (nonatomic,strong) NSMutableArray *choosearr;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *agreementBtn;
@property (nonatomic,strong) UIImageView *gantanimg;
@end

static NSString *chooseimplementidentfid = @"chooseimplementidentfid";
//saveImplement
@implementation chooseimplementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"编辑人员";
    
    self.agencysIdsArray = [NSMutableArray array];
    self.choosearr = [NSMutableArray array];
    
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"提交" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(editCompany) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    [self dataarr];
    [self.view addSubview:self.table];
    self.table.tableFooterView = self.footView;
    [self setlayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dataarr
{
    for (int i = 0; i<self.dataSource.count; i++) {
        CompanyPeopleInfoModel *model = self.dataSource[i];
       // NSString *str = model.implement;
        if ([model.implement isEqualToString:@"1"]) {
            [self.choosearr addObject:@"1"];
        }
        else
        {
            [self.choosearr addObject:@"0"];
        }
       // [self.choosearr addObject:@"0"];
    }
}

-(void)setlayout
{
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footView).with.offset(10);
        make.right.equalTo(self.footView).with.offset(-14);
        make.height.mas_offset(20);
    }];
    [self.gantanimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.agreementBtn);
        make.right.equalTo(self.agreementBtn.mas_left).with.offset(-6);
        make.width.mas_offset(16);
        make.height.mas_offset(16);
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


-(UIView *)footView
{
    if(!_footView)
    {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
        [_footView addSubview:self.agreementBtn];
        [_footView addSubview:self.gantanimg];
    }
    return _footView;
}

-(UIButton *)agreementBtn
{
    if(!_agreementBtn)
    {
        _agreementBtn = [[UIButton alloc] init];
        [_agreementBtn setTitle:@"执行经理说明" forState:normal];
        _agreementBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_agreementBtn setTitleColor:[UIColor hexStringToColor:@"FCC280"] forState:normal];
        [_agreementBtn addTarget:self action:@selector(agreementclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreementBtn;
}

-(UIImageView *)gantanimg
{
    if(!_gantanimg)
    {
        _gantanimg = [[UIImageView alloc] init];
        _gantanimg.image = [UIImage imageNamed:@"gantan"];
    }
    return _gantanimg;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    chooseimplementCell *cell = [tableView dequeueReusableCellWithIdentifier:chooseimplementidentfid];
    if (!cell) {
        cell = [[chooseimplementCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chooseimplementidentfid];
    }
    [cell setdata:self.dataSource[indexPath.row]];
    cell.delegate = self;
    [cell setchoose:self.choosearr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(void)myTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.table indexPathForCell:cell];
    NSString *str = self.choosearr[index.row];
    if ([str isEqualToString:@"0"]) {
        [self.choosearr replaceObjectAtIndex:index.row withObject:@"1"];
    }
    else
    {
        [self.choosearr replaceObjectAtIndex:index.row withObject:@"0"];
    }
    [self.table reloadData];
}

-(void)editCompany
{
    NSString *agencysIds = @"";
    for (int i = 0; i<self.choosearr.count; i++) {
        NSString *str = self.choosearr[i];
        if ([str isEqualToString:@"1"]) {
            CompanyPeopleInfoModel *model = self.dataSource[i];
            [self.agencysIdsArray addObject:model.agencysId];
        }
    }
    agencysIds = [self.agencysIdsArray componentsJoinedByString:@","];
    NSDictionary *para = @{@"agencysIds":agencysIds,@"companyId":self.companyId};
    NSString *url = [BASEURL stringByAppendingString:POST_saveImplement];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
            //创建通知对象
            NSNotification *notification = [NSNotification notificationWithName:@"zhixinjingli" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 协议跳转

-(void)agreementclick
{
    agreementVC *vc = [agreementVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
