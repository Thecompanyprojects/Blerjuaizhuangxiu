//
//  OwnerEvaluateController.m
//  iDecoration
//  业主评价
//  Created by Apple on 2017/5/3.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "OwnerEvaluateController.h"
#import "OwnerEvaluateModel.h"
#import "OwnerEvaluateCell.h"
#import "ConstructionDiaryViewController.h"

#import "ConstructionDiaryTwoController.h"

#import "MainMaterialDiaryController.h"

@interface OwnerEvaluateController ()<UITableViewDelegate, UITableViewDataSource, OwnerEvaluateCellDelegate>

@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UIImageView *photoImg;
@property (nonatomic, strong) UILabel *companyName;
@property (nonatomic, strong) UILabel *commentNum;
@property (nonatomic, strong) UILabel *commentNumL;
@property (nonatomic, strong) UILabel *caseNum;
@property (nonatomic, strong) UILabel *caseNumL;
@property (nonatomic, strong) UILabel *addressNum;
@property (nonatomic, strong) UILabel *addressNumL;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
// 存储cell高度的
@property (strong, nonatomic) NSMutableArray *cellHeightArr;

@end

@implementation OwnerEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"业主评价";
    self.dataArray = [NSMutableArray array];
    self.cellHeightArr = [NSMutableArray array];
    self.view.backgroundColor = kBackgroundColor;
    [self setUI];
    [self requestData];
}

#pragma mark - action

- (void)setUI {

    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.topV;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 10)];
    view.backgroundColor = kBackgroundColor;
    self.tableView.tableFooterView = view;
}

- (void)requestData {
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"constructionEvaluate/getCompanyEva.do"];
    NSDictionary *paramDic = @{@"companyId":self.companyId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            [self.dataArray removeAllObjects];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                    if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = responseObj[@"data"];
                        NSDictionary *dict = [dic objectForKey:@"company"];
                        
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[OwnerEvaluateModel class] json:[dic objectForKey:@"list"]];
                        [self.dataArray addObjectsFromArray:arr];
                        for (int i = 0; i < self.dataArray.count; i ++) {
                            
                            [self.cellHeightArr addObject:@"0"];
                        }
                        if (self.cellHeightArr.count == 0) {
                            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"暂时没有业主评价"];
                        }
                        //刷新数据
                        [self reloadDataWithDic:dict];
                    };
                    break;
                    
                default:
                    break;
            }
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
    }];
}


- (void)reloadDataWithDic:(NSDictionary *)dict {
    
    self.companyName.text = [dict objectForKey:@"companyName"];
    self.commentNumL.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"praiseTotal"]];
    self.caseNumL.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"caseTola"]];
    self.addressNumL.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"constructionTotal"]];
    [self.photoImg sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"companyLogo"]] placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
    
    [self.tableView reloadData];
    
}

#pragma mark - uitableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OwnerEvaluateCell *cell = [OwnerEvaluateCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.indexPath = indexPath;
    OwnerEvaluateModel *model = self.dataArray[indexPath.row];
    [cell configWith:model];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.cellHeightArr[indexPath.row] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OwnerEvaluateModel *model = self.dataArray[indexPath.row];
    
    if (model.constructionId && ![model.constructionId isEqualToString:@""] && ![model.constructionId isEqualToString:@"0"]&&model.constructionType.length!=0) {
        
        if ([model.constructionType isEqualToString:@"1"]) {
            MainMaterialDiaryController *mainDiaryVC = [[MainMaterialDiaryController alloc] init];
            mainDiaryVC.consID = [model.constructionId integerValue];
            [self.navigationController pushViewController:mainDiaryVC animated:YES];
        } else {
            ConstructionDiaryTwoController *constructionVC = [[ConstructionDiaryTwoController alloc] init];
            constructionVC.consID = [model.constructionId integerValue];
            [self.navigationController pushViewController:constructionVC animated:YES];
        }
        
        
        
       
    } else {
        
        [self.view hudShowWithText:@"该工地已不存在..."];
    }
}

#pragma mark - OwnerEvaluateCellDelegate方法
- (void)getCellHeight:(CGFloat)cellHeight andIndex:(NSIndexPath *)index {
    
    [self.cellHeightArr replaceObjectAtIndex:index.row withObject:[NSString stringWithFormat:@"%f", cellHeight]];
}

#pragma mark - setter
- (UIView *)topV {
    
    if (!_topV) {
        
        _topV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, BLEJWidth-20, 120)];
        _topV.backgroundColor = White_Color;
        _topV.layer.borderWidth = 8;
        _topV.layer.borderColor = kBackgroundColor.CGColor;
        [_topV addSubview:self.photoImg];
        [_topV addSubview:self.companyName];
        [_topV addSubview:self.caseNum];
        [_topV addSubview:self.caseNumL];
        [_topV addSubview:self.addressNum];
        [_topV addSubview:self.addressNumL];
        [_topV addSubview:self.commentNum];
        [_topV addSubview:self.commentNumL];
    }
    return _topV;
}

- (UIImageView *)photoImg {
    
    if (!_photoImg) {
        
        _photoImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, self.topV.height-15*2, self.topV.height-15*2)];
    }
    return _photoImg;
}

- (UILabel *)companyName {
    
    if (!_companyName) {
        
        _companyName = [[UILabel alloc]initWithFrame:CGRectMake(self.photoImg.right+10, self.photoImg.top, 200, 30)];
        _companyName.textColor = Black_Color;
        _companyName.font = [UIFont systemFontOfSize:20];
        _companyName.textAlignment = NSTextAlignmentLeft;
        _companyName.text = @"";
    }
    return _companyName;
}


- (UILabel *)caseNum {
    
    if (!_caseNum) {
        
        _caseNum = [[UILabel alloc]initWithFrame:CGRectMake(self.photoImg.right+10, self.photoImg.bottom-20, 40, 20)];
        _caseNum.textColor = Black_Color;
        _caseNum.font = [UIFont systemFontOfSize:14];
        _caseNum.textAlignment = NSTextAlignmentLeft;
        _caseNum.text = @"案例:";
    }
    return _caseNum;
}

- (UILabel *)caseNumL {
    
    if (!_caseNumL) {
        
        _caseNumL = [[UILabel alloc]initWithFrame:CGRectMake(self.commentNum.right+5, self.caseNum.top, 50, 20)];
        _caseNumL.textColor = [UIColor redColor];
        _caseNumL.font = [UIFont systemFontOfSize
                          :14];
        _caseNumL.textAlignment = NSTextAlignmentLeft;
        _caseNumL.text = @"0";
    }
    return _caseNumL;
}

- (UILabel *)addressNum {
    
    if (!_addressNum) {
        
        _addressNum = [[UILabel alloc]initWithFrame:CGRectMake(self.caseNumL.right, self.caseNumL.top, 40, 20)];
        _addressNum.textColor = Black_Color;
        _addressNum.font = [UIFont systemFontOfSize:14];
        _addressNum.textAlignment = NSTextAlignmentLeft;
        _addressNum.text = @"工地:";
    }
    return _addressNum;
}

- (UILabel *)addressNumL {
    
    if (!_addressNumL) {
        
        _addressNumL = [[UILabel alloc]initWithFrame:CGRectMake(self.addressNum.right+5, self.addressNum.top, 50, 20)];
        _addressNumL.textColor = [UIColor redColor];
        _addressNumL.font = [UIFont systemFontOfSize
                             :14];
        _addressNumL.textAlignment = NSTextAlignmentLeft;
        _addressNumL.text = @"0";
    }
    return _addressNumL;
}

- (UILabel *)commentNum {
    
    if (!_commentNum) {
        
        _commentNum = [[UILabel alloc]initWithFrame:CGRectMake(self.photoImg.right+10, self.caseNum.top-20-10, 40, 20)];
        _commentNum.textColor = Black_Color;
        _commentNum.font = [UIFont systemFontOfSize:14];
        _commentNum.textAlignment = NSTextAlignmentLeft;
        _commentNum.text = @"好评:";
    }
    return _commentNum;
}

- (UILabel *)commentNumL {
    
    if (!_commentNumL) {
        
        _commentNumL = [[UILabel alloc]initWithFrame:CGRectMake(self.commentNum.right + 5, self.commentNum.top, 50, 20)];
        _commentNumL.textColor = [UIColor redColor];
        _commentNumL.font = [UIFont systemFontOfSize
                             :14];
        _commentNumL.textAlignment = NSTextAlignmentLeft;
        _commentNumL.text = @"0";
    }
    return _commentNumL;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,kSCREEN_WIDTH,kSCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.rowHeight = 245;
    }
    return _tableView;
}


@end
