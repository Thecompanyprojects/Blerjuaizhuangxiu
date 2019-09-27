//
//  DecoreAreaSelectController.m
//  iDecoration
//
//  Created by Apple on 2017/5/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DecoreAreaSelectController.h"
#import "XLTableViewCell.h"
#import "AreaListModel.h"

@interface DecoreAreaSelectController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *heveSelectArray;
@end

@implementation DecoreAreaSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self creatUI];
}

-(void)creatUI{
    self.title = @"选择区域";
    NSMutableArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"haveSelect"];
    [self.heveSelectArray addObjectsFromArray:arr];
    [self.view addSubview:self.tableView];
    
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"确定" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(didClickEditBtnBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
}

-(void)didClickEditBtnBtn{
    if (!self.heveSelectArray.count) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请选择区域" controller:self sleep:1.5];
    }
    else{
        //存入本地
        [[NSUserDefaults standardUserDefaults] setObject:self.heveSelectArray forKey:@"haveSelect"];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

-(NSMutableArray *)heveSelectArray{
    if (!_heveSelectArray) {
        _heveSelectArray = [NSMutableArray array];
    }
    return _heveSelectArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.areaArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XLTableViewCell *cell = [XLTableViewCell cellWithTableView:tableView cellStyle:3];
    AreaListModel *model = self.areaArray[indexPath.row];
    
    [cell configCell:@{@"leftLabel":model.retion, @"rightImage":@"meixuanzhong", @"rightImageShow":@"yes"}];
    
    if (self.heveSelectArray.count) {
        BOOL iscontain = [self.heveSelectArray containsObject:@(indexPath.row)];
        if (iscontain) {
            [cell configCell:@{@"leftLabel":model.retion, @"rightImage":@"xuanzhong", @"rightImageShow":@"yes"}];
        }else{
            [cell configCell:@{@"leftLabel":model.retion, @"rightImage":@"meixuanzhong", @"rightImageShow":@"yes"}];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.heveSelectArray.count) {
        [self.heveSelectArray addObject:@(indexPath.row)];
    }
    else{
        BOOL isExit = NO;
//        for (NSString *str in self.heveSelectArray) {
//            NSInteger n = [str integerValue];
//            if (n == indexPath.row) {
//                [self.heveSelectArray removeObject:str];
//            }
//        }
        for (int i = 0; i<self.heveSelectArray.count; i++) {
            NSInteger n = [self.heveSelectArray[i] integerValue];
            if (n == indexPath.row) {
                [self.heveSelectArray removeObject:self.heveSelectArray[i]];
                isExit = YES;
                break;
            }
            else{
                isExit = NO;
            }
        }
        if (!isExit) {
            [self.heveSelectArray addObject:@(indexPath.row)];
        }
    }
    [self.tableView reloadData];
}

- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.shouldGroupAccessibilityChildren = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = White_Color;
        _tableView.tableFooterView = [[UIView alloc]init];
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        [_tableView addHeaderWithTarget:self action:@selector(loadNewData)];
        //        [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    }
    return _tableView;
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
