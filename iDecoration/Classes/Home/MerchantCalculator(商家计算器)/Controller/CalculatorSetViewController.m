//
//  CalculatorSetViewController.m
//  iDecoration
//
//  Created by zuxi li on 2018/3/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "CalculatorSetViewController.h"

#import "CalculatorSetTopView.h"
#import "BLEJBudgetTemplateGroupHeaderCell.h"
#import "ZCHSimpleBottomView.h"
#import "ZCHSimpleSettingCell.h"

static NSString *reuseIdentifier = @"ZCHSimpleSettingCell";
static NSString *reuseHeaderIdentifier = @"BLEJBudgetTemplateGroupHeaderCell";

@interface CalculatorSetViewController ()<UITableViewDelegate, UITableViewDataSource, BLEJBudgetTemplateGroupHeaderCellDelegate, ZCHSimpleSettingCellDelegate>

@property (nonatomic, strong) CalculatorSetTopView *topView;
@property(nonatomic, strong) UITableView *tableView;
// 记录分组标题中的减号是否被点击了
@property (strong, nonatomic) NSMutableArray *isGroupBtnClick;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CalculatorSetViewController
#pragma mark - LifeMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"简装设置";
    [self tableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NormalMethod


#pragma mark - UITableViewDelegate&DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 12;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCHSimpleSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.isShowMinusBtn = [[self.isGroupBtnClick[indexPath.section] objectForKey:@"isClick"] boolValue];
    cell.delegate = self;
    cell.indexpath = indexPath;
    NSArray *arr = @[@"test", @"test"];
//    [cell settingCellWithData:arr];
    //---假数据----
    CGFloat labelWidth = (BLEJWidth - 40) * 1 / 3;
    CGFloat labelHeight = 30;
    CGFloat margin = 10;
    for (int i = 0; i < arr.count; i ++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((i % 3 + 1) * margin + i % 3 * labelWidth, (i / 3 + 1) * margin + i / 3 * labelHeight, labelWidth, labelHeight)];
        label.userInteractionEnabled = YES;
        label.text = arr[i];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.layer.borderColor = [UIColor lightGrayColor].CGColor;
        label.layer.borderWidth = 0.5;
        [cell.contentView addSubview:label];
        
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(label.right - 20, label.top, 20, 20)];
        deleteBtn.tag = 6666 + i;
        [deleteBtn setImage:[UIImage imageNamed:@"deleteWhite"] forState:UIControlStateNormal];
        [cell.contentView addSubview:deleteBtn];
        if (cell.isShowMinusBtn) {
            
            deleteBtn.hidden = NO;
        } else {
            
            deleteBtn.hidden = YES;
        }
    }
    // ------
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    BLEJBudgetTemplateGroupHeaderCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeaderIdentifier];
    cell.isRotate = [[self.isGroupBtnClick[section] objectForKey:@"isClick"] boolValue];
    cell.title = @"基础模板";
    cell.budgetTemplateGroupHeaderCellDelegate = self;
    cell.sectionIndex = section;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - ZCHSimpleSettingCellDelegate代理方法(删除某一项)
- (void)didClickDeleteBtnWithIndexpath:(NSIndexPath *)indexpath andIndex:(NSInteger)index {
    
//    ZCHSimpleSettingRoomModel *model = self.dataArr[indexpath.section - 1];
//    [model.items removeObjectAtIndex:index];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.paramArr[indexpath.section - 1]];
//    NSMutableArray *arr = [NSMutableArray arrayWithArray:[dic objectForKey:@"items"]];
//    [arr removeObjectAtIndex:index];
//    [dic setObject:arr forKey:@"items"];
//    [self.paramArr replaceObjectAtIndex:indexpath.section - 1 withObject:dic];
    [self.tableView reloadTableViewWithRow:-1 andSection:indexpath.section];
}

#pragma mark - section视图按钮事件 BLEJBudgetTemplateGroupHeaderCellDelegate
- (void)didClickPlusBtnWithSection:(NSInteger)section {
    
}

// 点击-
- (void)didClickMinusBtnWithSection:(NSInteger)section andIsSelected:(BOOL)isSeleted {
    
    [self.isGroupBtnClick replaceObjectAtIndex:section withObject:@{@"isClick" : [NSString stringWithFormat:@"%d", isSeleted]}];
    
    [self.tableView reloadTableViewWithRow:-1 andSection:section];
}

#pragma mark - LazyMethod
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNaviBottom, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNaviBottom) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        _topView = [CalculatorSetTopView new];
        _tableView.tableHeaderView = _topView;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
         [self.tableView registerNib:[UINib nibWithNibName:@"BLEJBudgetTemplateGroupHeaderCell" bundle:nil] forHeaderFooterViewReuseIdentifier:reuseHeaderIdentifier];
        [self.tableView registerClass:[ZCHSimpleSettingCell class] forCellReuseIdentifier:reuseIdentifier];
    }
    return _tableView;
}

- (NSMutableArray *)isGroupBtnClick {
    if (_isGroupBtnClick == nil) {
        _isGroupBtnClick = [NSMutableArray array];
        for (int i = 0; i < 12; i++) {
            [_isGroupBtnClick addObject:@{@"isClick" : @"0"}];
        }
    }
    return _isGroupBtnClick;
}

@end
