//
//  BatchMangerMoveToGroupViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/15.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "BatchMangerMoveToGroupViewController.h"
#import "GroupManagerCell.h"
#import "ClassifyModel.h"
#import "GoodsListModel.h"


@interface BatchMangerMoveToGroupViewController ()<UITableViewDelegate, UITableViewDataSource>

// 商品类别数组
@property (nonatomic, strong) NSMutableArray *classifyTitleArray;

// 商品类别列表
@property (nonatomic, strong) UITableView *classifyTableView;
// 底部视图
@property (nonatomic, strong) UIView *bottomView;

@end

static NSString *cellReusedIdentified = @"cellReusedIdentified";
@implementation BatchMangerMoveToGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.title = _isEditing ? @"分组" : @"分组管理";
    [self setupUI];
    
    [self getClassifyData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NormalMethod
- (void)setupUI {
    [self classifyTableView];
}

// 获取分组数据
- (void)getClassifyData {
    NSString *defaultURL = [BASEURL stringByAppendingString:@"merchandies/getCategoryList.do"];
    NSDictionary *paramDic = @{
                               @"merchantId": self.shopId
                               };
    MJWeakSelf;
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            NSArray *array = [responseObj objectForKey:@"categoryList"];
            [weakSelf.classifyTitleArray removeAllObjects];
            
            [weakSelf.classifyTitleArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ClassifyModel class] json:array]];
            [self.classifyTableView reloadData];
            
        } else {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"产品类别加载失败"];
        }
        
        
    } failed:^(NSString *errorMsg) {
        
    }];
}


- (void)moveGoodToCategoryWithCategoryID:(NSInteger)categoryId {
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSString *defaultURL = [BASEURL stringByAppendingString:@"merchandies/updateMerchandiesBatch.do"];
    
    NSMutableDictionary *multiDict = [NSMutableDictionary dictionary];
    NSMutableString *paramString = [NSMutableString string];
    [paramString appendString:@"["];
    
    for (int i = 0; i < self.deleteArray.count; i ++) {
        GoodsListModel *model = self.deleteArray[i];
        
        [multiDict setObject:@(model.goodsID) forKey:@"id"];
        [multiDict setObject:model.name forKey:@"name"];
        
        NSString *dictStr = [self dictionaryToJson:multiDict];
        [paramString appendString:dictStr];
        if (i != self.deleteArray.count - 1) {
            [paramString appendString:@","];
        }
        [multiDict removeAllObjects];
    }
    
    [paramString appendString:@"]"];
    
    NSDictionary *paramDic = @{
                               @"listStr": paramString,
                               @"categoryId": @(categoryId)
                               };
    MJWeakSelf;
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
    
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"（商品分组）分组成功"];
            [weakSelf performSelector:@selector(back) withObject:nil afterDelay:1.0];
        } else {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"操作失败， 请稍后再试"];
        }

    } failed:^(NSString *errorMsg) {
        
        
    }];
}

- (void)back {
    if (self.CompleteBlock) {
        self.CompleteBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classifyTitleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusedIdentified forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.deleteButton.hidden = YES;
    cell.moveUpButton.hidden = YES;
    cell.moveDownButton.hidden = YES;
    ClassifyModel *model = self.classifyTitleArray[indexPath.row];
    cell.titleLabel.text = model.categoryName;
    cell.indexPath = indexPath;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return !(indexPath.row==0 || indexPath.row == 1);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassifyModel *model = self.classifyTitleArray[indexPath.row];
    
    if (_isEditing) {
        if (self.EditingCompleteBlock) {
            self.EditingCompleteBlock(model);
        }
        [self back];
        return;
    }
    [self moveGoodToCategoryWithCategoryID:model.categoryID];
    
    
}


#pragma mark - LazyMethod
- (NSMutableArray *)classifyTitleArray {
    if (!_classifyTitleArray) {
        _classifyTitleArray = [NSMutableArray array];
    }
    return _classifyTitleArray;
}
- (UITableView *)classifyTableView {
    if (!_classifyTableView) {
        _classifyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_classifyTableView];
        _classifyTableView.backgroundColor = kBackgroundColor;
        [_classifyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(64);
            make.bottom.equalTo(0);
        }];
        _classifyTableView.tableFooterView = [UIView new];
        _classifyTableView.delegate = self;
        _classifyTableView.dataSource = self;
        [_classifyTableView registerNib:[UINib nibWithNibName:@"GroupManagerCell" bundle:nil] forCellReuseIdentifier:cellReusedIdentified];
    }
    return _classifyTableView;
}

@end
