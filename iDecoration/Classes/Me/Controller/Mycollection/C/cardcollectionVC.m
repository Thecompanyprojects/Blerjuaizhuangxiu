//
//  cardcollectionVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/14.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "cardcollectionVC.h"
#import "collectionidcardCell.h"
#import "CollectionModel.h"
#import "NewMyPersonCardController.h"

@interface cardcollectionVC ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation cardcollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    [self layoutUI];
    [self loaddata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutUI
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).with.offset(-44);
    }];
}

-(void)loaddata
{
    NSString *url = [BASEURL stringByAppendingString:IDCARD_SHOUCANG];
    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSDictionary *para = @{@"agencysId":agencysId};
    [self.dataSource removeAllObjects];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            NSDictionary *dataDict = [responseObj objectForKey:@"data"];
            NSArray *listArray = [dataDict objectForKey:@"list"];
           
            [self.dataSource addObjectsFromArray:[NSArray yy_modelArrayWithClass:[CollectionModel class] json:listArray]];
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
        _table.dataSource = self;
        _table.delegate = self;
        _table.emptyDataSetDelegate = self;
        _table.emptyDataSetSource = self;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    collectionidcardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newscell"];
    cell = [[collectionidcardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newscell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setdata:self.dataSource[indexPath.row]];
    //添加长按手势
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    longPressGesture.minimumPressDuration=1.5f;//设置长按 时间
    [cell addGestureRecognizer:longPressGesture];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 97;
}

-(void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //成为第一响应者，需重写该方法
        [self becomeFirstResponder];
        
        CGPoint location = [longRecognizer locationInView:self.table];
        NSIndexPath * indexPath = [self.table indexPathForRowAtPoint:location];
        //可以得到此时你点击的哪一行
        CollectionModel *model = self.dataSource[indexPath.row];
        //在此添加你想要完成的功能
        NSString *collectionId = [NSString stringWithFormat:@"%ld",model.collectionId];
        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"取消收藏" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *para = @{@"collectionId":collectionId};
            NSString *url = [BASEURL stringByAppendingString:DELETE_SHOUCANG];
            [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
                if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                    [self loaddata];
                    [[PublicTool defaultTool] publicToolsHUDStr:@"取消收藏成功" controller:self sleep:1.5];
                }
            } failed:^(NSString *errorMsg) {
                
            }];
        }];
        [control addAction:action0];
        [control addAction:action1];
        [self presentViewController:control animated:YES completion:^{
            
        }];
        
    }
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionModel *model = self.dataSource[indexPath.row];
    NewMyPersonCardController *vc = [NewMyPersonCardController new];
    vc.agencyId = model.personId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无名片收藏";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}


@end