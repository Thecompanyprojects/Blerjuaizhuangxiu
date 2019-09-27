//
//  CategoryViewController.m
//  iDecoration
//
//  Created by RealSeven on 2017/4/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryTableViewCell.h"
#import "GetShopTypeApi.h"
#import "CategoryModel.h"

@interface CategoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSIndexPath *_selIndex;//单选，当前选中的行
    NSInteger _selRow;
}

@property (nonatomic, strong) UITableView *categoryTableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *idArray;

@end

@implementation CategoryViewController

-(NSMutableArray*)titleArray{
    
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

-(NSMutableArray*)idArray{
    
    if (!_idArray) {
        _idArray = [NSMutableArray array];
    }
    return _idArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"类别";
    if (self.index == 1) {
        self.title = @"职位类别";
    }
    [self createTableView];
}
- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = Bottom_Color;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"CategoryTableViewCell"];
    
    self.categoryTableView = tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArray.count;
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
    
    if (self.index == 1) {
        CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configData:self.titleArray[indexPath.row]];
        
        if (_selIndex == indexPath) {
            [cell.selectImageView setImage:[UIImage imageNamed:@"circle_shi"]];
        }else{
            [cell.selectImageView setImage:[UIImage imageNamed:@"circle_kong"]];
        }
        
        
        
        return cell;
    }
    else{
        CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.titleArray[indexPath.row];
        
        if (_selIndex == indexPath) {
            [cell.selectImageView setImage:[UIImage imageNamed:@"circle_shi"]];
        }else{
            [cell.selectImageView setImage:[UIImage imageNamed:@"circle_kong"]];
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.index == 1) {
        NSString *job = self.titleArray[indexPath.row];
        NSString *idJob = self.idArray[indexPath.row];
        NSDictionary *dic = @{@"job":job,@"idJob":idJob};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"companyPeopleAddNoti" object:nil userInfo:dic];
        
        CategoryTableViewCell *selCell = (CategoryTableViewCell*)[tableView cellForRowAtIndexPath:_selIndex];
        [selCell.selectImageView setImage:[UIImage imageNamed:@"circle_kong"]];
        
        _selIndex = indexPath;
        
        CategoryTableViewCell *newCell = (CategoryTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        [newCell.selectImageView setImage:[UIImage imageNamed:@"circle_shi"]];
        
        if (_selIndex == indexPath) {
            [newCell.selectImageView setImage:[UIImage imageNamed:@"circle_shi"]];
            _selRow = indexPath.row;
            
            [[NSUserDefaults standardUserDefaults] setInteger:_selRow forKey:@"selRow"];
        }else{
            [newCell.selectImageView setImage:[UIImage imageNamed:@"circle_kong"]];
        }
    }
    else{
        CategoryModel *model = self.titleArray[indexPath.row];
        NSDictionary *dict = [model yy_modelToJSONObject];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"categoryNoti" object:nil userInfo:dict];
        
        CategoryTableViewCell *selCell = (CategoryTableViewCell*)[tableView cellForRowAtIndexPath:_selIndex];
        [selCell.selectImageView setImage:[UIImage imageNamed:@"circle_kong"]];
        
        _selIndex = indexPath;
        
        CategoryTableViewCell *newCell = (CategoryTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        [newCell.selectImageView setImage:[UIImage imageNamed:@"circle_shi"]];
        
        if (_selIndex == indexPath) {
            [newCell.selectImageView setImage:[UIImage imageNamed:@"circle_shi"]];
            _selRow = indexPath.row;
            
            [[NSUserDefaults standardUserDefaults] setInteger:_selRow forKey:@"selRow"];
        }else{
            [newCell.selectImageView setImage:[UIImage imageNamed:@"circle_kong"]];
        }
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (self.index == 1) {
        if (self.comOrShop == 1) {
            //公司
            NSArray *arr = @[@"经理",@"客服",@"工程监理",@"主材部",@"辅材部",@"业务员",@"设计师",@"项目经理／工长",@"工程部"];
            [self.titleArray removeAllObjects];
            [self.titleArray addObjectsFromArray:arr];
            
            NSArray *arrID = @[@"1003",@"1005",@"1006",@"1007",@"1008",@"1009",@"1010",@"1011",@"1023"];
            [self.idArray removeAllObjects];
            [self.idArray addObjectsFromArray:arrID];
        }else{
            NSArray *arr = @[@"店面经理",@"店员",@"设计师",@"业务员",@"安装工",@"测量员"];
            [self.titleArray removeAllObjects];
            [self.titleArray addObjectsFromArray:arr];
            
            NSArray *arrID = @[@"1027",@"1028",@"1029",@"1030",@"1031",@"1033"];
            [self.idArray removeAllObjects];
            [self.idArray addObjectsFromArray:arrID];
        }
        
        for (int i = 0; i<self.idArray.count; i++) {
            NSString *jobId = self.idArray[i];
            NSInteger idint = [jobId integerValue];
            if (self.defaultJobId==idint) {
                _selIndex = [NSIndexPath indexPathForRow:i inSection:0];
                return;
            }
        }
        
        
        [self.categoryTableView reloadData];
    }
    else{
    
    GetShopTypeApi *getApi = [[GetShopTypeApi alloc]init];
    [getApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSInteger code = [[request.responseJSONObject objectForKey:@"code"] integerValue];
        if (code == 1000) {
            NSArray *typeArr = [request.responseJSONObject objectForKey:@"list"];
            
            for (NSDictionary *dict in typeArr) {
                
                CategoryModel *model = [CategoryModel yy_modelWithJSON:dict];
                
                if (![self.titleArray containsObject:model]) {
                    [self.titleArray addObject:model];
                }
            }
            
            if (self.dic) {
                
                if ((![self.dic[@"type"] isEqualToString:@"1018"] || ![self.dic[@"type"] isEqualToString:@"1064"] || ![self.dic[@"type"] isEqualToString:@"1065"]) && !self.isNewBuild) {
                    [self.titleArray removeObjectAtIndex:0];
                }
                if ((![self.dic[@"type"] isEqualToString:@"1018"] || ![self.dic[@"type"] isEqualToString:@"1064"] || ![self.dic[@"type"] isEqualToString:@"1065"]) && self.isNewBuild) {
                    [self.titleArray removeObjectAtIndex:0];
                }
                for (int i = 0; i < self.titleArray.count; i ++) {
                    if ([((CategoryModel *)self.titleArray[i]).typeNo isEqualToString:self.dic[@"type"]]) {
                        
                        _selRow = i;
                        _selIndex = [NSIndexPath indexPathForRow:_selRow inSection:0];
                        CategoryTableViewCell *cell = [self.categoryTableView cellForRowAtIndexPath:_selIndex];
                        [cell.selectImageView setImage:[UIImage imageNamed:@"circle_shi"]];
                    }
                }
            } else {
                
                _selRow = [[NSUserDefaults standardUserDefaults] integerForKey:@"selRow"];
                
                _selIndex = [NSIndexPath indexPathForRow:_selRow inSection:0];
                CategoryTableViewCell *cell = [self.categoryTableView cellForRowAtIndexPath:_selIndex];
                [cell.selectImageView setImage:[UIImage imageNamed:@"circle_shi"]];
            }
            
            [self.categoryTableView reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}


- (void)dealloc {
    
    
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
