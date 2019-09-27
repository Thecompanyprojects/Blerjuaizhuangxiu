//
//  GroupManagerViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GroupManagerViewController.h"
#import "GroupManagerCell.h"
#import "ClassifyModel.h"

@interface GroupManagerViewController ()<UITableViewDelegate, UITableViewDataSource, GroupManagerCellDelegate, UITextFieldDelegate>

// 分类对象数组
@property (nonatomic, strong) NSMutableArray *classifyArray;
// 商品类别名称数组
@property (nonatomic, strong) NSMutableArray *classifyTitleArray;
// 商品类别列表
@property (nonatomic, strong) UITableView *classifyTableView;
// 底部视图
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, assign) BOOL isChangeSort;

@end

static NSString *cellReusedIdentified = @"cellReusedIdentified";
@implementation GroupManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"分组管理";
    
    _isChangeSort = NO;
    
    self.classifyTitleArray = [NSMutableArray array];
    self.classifyArray = [NSMutableArray array];
    
    [self getClassifyData];
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NormalMethod
- (void)setupUI {
    [self bottomView];
    [self classifyTableView];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
}

-(void)back{
    MJWeakSelf;
    if (_isChangeSort) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保存分组顺序的修改" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"保存" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self modifyGroupSort];
        }];
        [alertC addAction:cancel];
        [alertC addAction:sure];
        [self presentViewController:alertC animated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

// 获取分组数据
- (void)getClassifyData {
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSString *defaultURL = [BASEURL stringByAppendingString:@"merchandies/getCategoryList.do"];
    NSDictionary *paramDic = @{
                               @"merchantId": self.shopId
                               };
    MJWeakSelf;
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            NSArray *array = [responseObj objectForKey:@"categoryList"];
            [weakSelf.classifyArray removeAllObjects];
            [weakSelf.classifyArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ClassifyModel class] json:array]];
            
            // 把未分类从最后一个放到第一一个
            ClassifyModel *model = self.classifyArray.lastObject;
            [self.classifyArray removeLastObject];
            [self.classifyArray insertObject:model atIndex:0];
            
            [self.classifyTitleArray removeAllObjects];
            for (ClassifyModel *model in self.classifyArray) {
                [self.classifyTitleArray addObject:model.categoryName];
            }
            
            [self.classifyTableView reloadData];
        } else {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"产品类别加载失败"];
        }
        
        
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
    }];
}


- (void)modifyGroupSort {
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSString *defaultURL = [BASEURL stringByAppendingString:@"merchandies/updateCategorySort.do"];
    
    NSMutableDictionary *multiDict = [NSMutableDictionary dictionary];
    NSMutableString *paramString = [NSMutableString string];
    [paramString appendString:@"["];
    
    for (int i = 0; i < self.classifyArray.count; i ++) {
        ClassifyModel *model = self.classifyArray[i];
        
        [multiDict setObject:[NSString stringWithFormat:@"%d", i] forKey:@"sort"];
        [multiDict setObject:[NSString stringWithFormat:@"%ld", model.categoryID] forKey:@"id"];
       
        NSString *dictStr = [self dictionaryToJson:multiDict];
        [paramString appendString:dictStr];
        if (i != self.classifyArray.count - 1) {
            [paramString appendString:@","];
        }
        [multiDict removeAllObjects];
    }
    
    [paramString appendString:@"]"];
    
    NSDictionary *paramDic = @{
                               @"categoryList": paramString
                               };
    MJWeakSelf;
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            weakSelf.ClasifyBrushBloack();
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [[UIApplication sharedApplication].keyWindow showHudFailed:@"修改失败，请稍后重试"];
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
    }];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)addMore:(UITapGestureRecognizer *)tapGR {
    YSNLog(@"继续添加");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加分组" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入分组名称(不能超过8个字)";
        textField.delegate = self;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)name:@"UITextFieldTextDidChangeNotification"
                                                  object:textField];
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    MJWeakSelf;
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *nameTextField = alertController.textFields.firstObject;
        NSString *nameText = nameTextField.text;
        if (nameText.length <= 0) {
            [[UIApplication sharedApplication].keyWindow showHudFailed:@"请输入新的分组名称"];
            return ;
        }
        if (nameText.length >8) {
            [[UIApplication sharedApplication].keyWindow showHudFailed:@"亲，最多输入8个字哦"];
            return ;
        }
        
        [weakSelf addMoreActionWithName:nameText];
        
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
    
}

- (void)addMoreActionWithName:(NSString *)name {
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSString *defaultURL = [BASEURL stringByAppendingString:@"merchandies/addCategory.do"];
    NSDictionary *paramDic = @{
                               @"merchantId": self.shopId,
                               @"categoryName": name
                               };
     MJWeakSelf;
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {


            weakSelf.ClasifyBrushBloack();
            [weakSelf getClassifyData];
        } else {
            [[UIApplication sharedApplication].keyWindow showHudFailed:@"添加失败，请稍后重试"];
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        
    }];
}

- (void)modifyClassifyName:(ClassifyModel *)model indexPath:(NSIndexPath *)indexPath {
    NSString *defaultURL = [BASEURL stringByAppendingString:@"merchandies/editCategoryByModel.do"];
    NSDictionary *paramDic = @{
                               @"id": @(model.categoryID),
                               @"categoryName": model.categoryName
                               };
    MJWeakSelf;
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            self.classifyTitleArray[indexPath.row] = model.categoryName;
            [weakSelf.classifyTableView reloadData];
            weakSelf.ClasifyBrushBloack();
        } else {
            [[UIApplication sharedApplication].keyWindow showHudFailed:@"修改失败，请稍后重试"];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string ew_JudgeTheillegalCharacter:string] && ![string isEqualToString:@""]) {
        [textField resignFirstResponder];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"不支持特殊字符"];
        return NO;
    }
    return YES;
}

// 限制提示文字长度
-(void)textFieldEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage ; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 8) {
                textField.text = [toBeString substringToIndex:8];
                [textField endEditing:YES];
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"字数长度不要超过8字哦！"];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 8) {
            textField.text = [toBeString substringToIndex:8];
            [textField endEditing:YES];
            // 超长保存前30个字
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"字数长度不要超过8字哦！"];
        }
    }
}


#pragma mark - GroupManagerCellDelegate
- (void)groupManagerCell:(GroupManagerCell *)cell delegateActionAtIndex:(NSIndexPath *)indexPath {
    
    NSString *defaultURL = [BASEURL stringByAppendingString:@"merchandies/deleteCategoryById.do"];
    ClassifyModel *model = self.classifyArray[indexPath.row];
    NSDictionary *paramDic = @{
                               @"id": @(model.categoryID)
                               };
    MJWeakSelf;
    [NetManager afGetRequest:defaultURL parms:paramDic finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        if (code == 1000) {
            [weakSelf.classifyTitleArray removeObjectAtIndex:indexPath.row];
            [weakSelf.classifyArray removeObjectAtIndex:indexPath.row];
            [weakSelf.classifyTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
            [weakSelf.classifyTableView reloadData];
            weakSelf.ClasifyBrushBloack();
        } else {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"删除失败，稍后再试"];
        }
        
        
    } failed:^(NSString *errorMsg) {
        
    }];
    
    
    
}
- (void)groupManagerCell:(GroupManagerCell *)cell moveUpActionFromIndex:(NSIndexPath *)indexPath {
    _isChangeSort = YES;
    id obj = self.classifyTitleArray[indexPath.row];
    [self.classifyTitleArray removeObjectAtIndex:indexPath.row];
    [self.classifyTitleArray insertObject:obj atIndex:indexPath.row - 1];
    
    [self.classifyArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:indexPath.row - 1];
    

    NSIndexPath *indexP = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0];
    GroupManagerCell *toCell = [self.classifyTableView cellForRowAtIndexPath:indexP];
    [self.classifyTableView moveRowAtIndexPath:indexPath toIndexPath:indexP];
    cell.indexPath = indexP;
    toCell.indexPath = indexPath;

//    cell.deleteButton.hidden = (indexP.row==0 || indexP.row == 1);
//    cell.moveUpButton.hidden = (indexP.row == 2 || indexP.row==0 || indexP.row == 1);
//    cell.moveDownButton.hidden = (indexP.row == (self.classifyTitleArray.count  - 1) || indexP.row==0 || indexP.row == 1);
//    toCell.deleteButton.hidden = (indexPath.row==0 || indexPath.row == 1);
//    toCell.moveUpButton.hidden = (indexPath.row == 2 || indexPath.row==0 || indexPath.row == 1);
//    toCell.moveDownButton.hidden = (indexPath.row == (self.classifyTitleArray.count  - 1) || indexPath.row==0 || indexPath.row == 1);
    
    cell.deleteButton.hidden = (indexP.row==0);
    cell.moveUpButton.hidden = (indexP.row==0 || indexP.row == 1);
    cell.moveDownButton.hidden = (indexP.row == (self.classifyTitleArray.count  - 1) || indexP.row==0);
    toCell.deleteButton.hidden = (indexPath.row==0);
    toCell.moveUpButton.hidden = (indexPath.row==0 || indexPath.row == 1);
    toCell.moveDownButton.hidden = (indexPath.row == (self.classifyTitleArray.count  - 1) || indexPath.row==0);

}
- (void)groupManagerCell:(GroupManagerCell *)cell moveDownActionFromIndex:(NSIndexPath *)indexPath {
    _isChangeSort = YES;
    
    id obj = self.classifyTitleArray[indexPath.row];
    [self.classifyTitleArray removeObjectAtIndex:indexPath.row];
    [self.classifyTitleArray insertObject:obj atIndex:indexPath.row +1];
    
    [self.classifyArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:indexPath.row + 1];
    
    NSIndexPath *indexP = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
    GroupManagerCell *toCell = [self.classifyTableView cellForRowAtIndexPath:indexP];
    [self.classifyTableView moveRowAtIndexPath:indexPath toIndexPath:indexP];
    cell.indexPath = indexP;
    toCell.indexPath = indexPath;

//    cell.deleteButton.hidden = (indexP.row==0 || indexP.row == 1);
//    cell.moveUpButton.hidden = (indexP.row == 2 || indexP.row==0 || indexP.row == 1);
//    cell.moveDownButton.hidden = (indexP.row == (self.classifyTitleArray.count  - 1) || indexP.row==0 || indexP.row == 1);
//    toCell.deleteButton.hidden = (indexPath.row==0 || indexPath.row == 1);
//    toCell.moveUpButton.hidden = (indexPath.row == 2 || indexPath.row==0 || indexPath.row == 1);
//    toCell.moveDownButton.hidden = (indexPath.row == (self.classifyTitleArray.count  - 1) || indexPath.row==0 || indexPath.row == 1);
    
    cell.deleteButton.hidden = (indexP.row==0);
    cell.moveUpButton.hidden = (indexP.row==0 || indexP.row == 1);
    cell.moveDownButton.hidden = (indexP.row == (self.classifyTitleArray.count  - 1) || indexP.row==0);
    toCell.deleteButton.hidden = (indexPath.row==0);
    toCell.moveUpButton.hidden = (indexPath.row==0 || indexPath.row == 1);
    toCell.moveDownButton.hidden = (indexPath.row == (self.classifyTitleArray.count  - 1) || indexPath.row==0);

    
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
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.deleteButton.hidden = (indexPath.row==0 || indexPath.row == 1);
//    cell.moveUpButton.hidden = (indexPath.row == 2 || indexPath.row==0 || indexPath.row == 1);
//    cell.moveDownButton.hidden = (indexPath.row == (self.classifyTitleArray.count  - 1) || indexPath.row==0 || indexPath.row == 1);
    
    cell.deleteButton.hidden = (indexPath.row==0 );
    cell.moveUpButton.hidden = (indexPath.row==0 || indexPath.row == 1);
    cell.moveDownButton.hidden = (indexPath.row == (self.classifyTitleArray.count  - 1) || indexPath.row==0);
    
    cell.titleLabel.text = self.classifyTitleArray[indexPath.row];
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
    
    // 修改分组名称
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入分组名称(不能超过8个字)";
        textField.delegate = self;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)name:@"UITextFieldTextDidChangeNotification"
                                                  object:textField];
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    MJWeakSelf;
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *nameTextField = alertController.textFields.firstObject;
        NSString *nameText = nameTextField.text;
        if (nameText.length <= 0) {
            [[UIApplication sharedApplication].keyWindow showHudFailed:@"请输入新的分组名称"];
            return ;
        }
        if (nameText.length >8) {
            [[UIApplication sharedApplication].keyWindow showHudFailed:@"亲，最多输入8个字哦"];
            return ;
        }
        
        ClassifyModel *model = self.classifyArray[indexPath.row];
        model.categoryName = nameText;
        [weakSelf modifyClassifyName:model indexPath:indexPath];
        
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
}


#pragma mark - LazyMethod
- (UITableView *)classifyTableView {
    if (!_classifyTableView) {
        _classifyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_classifyTableView];
        _classifyTableView.backgroundColor = kBackgroundColor;
        [_classifyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(64);
            make.bottom.equalTo(self.bottomView.mas_top).equalTo(0);
        }];
        _classifyTableView.tableFooterView = [UIView new];
        _classifyTableView.delegate = self;
        _classifyTableView.dataSource = self;
        [_classifyTableView registerNib:[UINib nibWithNibName:@"GroupManagerCell" bundle:nil] forCellReuseIdentifier:cellReusedIdentified];
    }
    return _classifyTableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 44, kSCREEN_WIDTH, 44)];
        [self.view addSubview:_bottomView];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]init];
        [_bottomView addSubview:label];
        label.text = @"添加分组";
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = kMainThemeColor;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.centerX.equalTo(20);
        }];
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenAddBtn"]];
        [_bottomView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.centerX.equalTo(-30);
            make.size.equalTo(CGSizeMake(24, 24));
        }];
        _bottomView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addMore:)];
        [_bottomView addGestureRecognizer:tapGR];
    }
    return _bottomView;
}
@end
