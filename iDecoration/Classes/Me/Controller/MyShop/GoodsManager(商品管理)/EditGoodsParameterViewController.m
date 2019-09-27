//
//  EditGoodsParameterViewController.m
//  iDecoration
//
//  Created by zuxi li on 2018/1/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "EditGoodsParameterViewController.h"
#import "EditGoodsParameterCell.h"
#import "GoodsParamterModel.h"
#import "CustomParameterItemView.h"

#define kParamNameLength 8
@interface EditGoodsParameterViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate, CustomParameterItemViewDelegate, EditGoodsParameterCellDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong)  CustomParameterItemView *customerItemView;
@end

@implementation EditGoodsParameterViewController
#pragma mark - lifeMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.listArray.count == 0) {
        for (int i = 0; i < self.defaultTitleArray.count; i ++) {
            NSString *nameStr = self.defaultTitleArray[i];
            GoodsParamterModel *model1 = [GoodsParamterModel newModel];
            model1.name = nameStr;
            [self.listArray addObject:model1];
        }
    }
    
    [self createUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - NormalMehtod

-(void)createUI{
    self.title = self.topTitle;
    // 返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
    // 设置导航栏最右侧的按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightItemWithTitle:@"保存" target:self action:@selector(saveGoodsAction)];
    
    [self tableView];
}

- (void)back {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"退出编辑" message:@"是否确定退出编辑？" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"是" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - 保存点击事件
- (void)saveGoodsAction {
    [self.view endEditing:YES];
    
    __block BOOL iscomplete = YES;
    [self.listArray enumerateObjectsUsingBlock:^(GoodsParamterModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = [model.describ ew_removeSpacesAndLineBreaks];
        if ([str isEqualToString:@""]) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请填写描述"];
            iscomplete = NO;
            *stop = YES;
            return ;
        }
    }];
    
    if (iscomplete) {
        if (self.completeBlock) {
            self.completeBlock([self.listArray copy]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 添加更多
- (void)addMoreAction {
    [self.view endEditing:YES];
    
//    EditGoodsParameterCell *preCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.listArray.count - 1]];
//    
//    if ([preCell.nameTF.text isEqualToString:@""]) {
//        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请填写名称"];
//        return;
//    }
//    if ([preCell.describeTV.text isEqualToString:@""]) {
//        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请填写描述"];
//        return;
//    }
    
    
//    GoodsParamterModel *model = [GoodsParamterModel newModel];
//    [self.listArray addObject:model];
//    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:self.listArray.count - 1] withRowAnimation:(UITableViewRowAnimationFade)];
//
//    EditGoodsParameterCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.listArray.count - 1]];
//    [cell.nameTF becomeFirstResponder];
    
    
    self.customerItemView.listArray = self.listArray;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.customerItemView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.customerItemView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
    }];
}

#pragma mark - textViewDelegate
// textview 高度变化
- (void)textViewDidChange:(UITextView *)textView {
    NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:textView.tag];
    EditGoodsParameterCell *cell = [self.tableView cellForRowAtIndexPath:indexP];
    cell.describeTVPlaceHolder.hidden = textView.text.length > 0;
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), CGFLOAT_MAX)];
    CGFloat height = size.height;
    if (height <= 20) {
        cell.describeTVHeight.constant = 20;
    }else{
        cell.describeTVHeight.constant = height;
    }
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];

}



- (void)textViewDidEndEditing:(UITextView *)textView {
    GoodsParamterModel *model = self.listArray[textView.tag];
    model.describ = textView.text;
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
            if (toBeString.length > kParamNameLength) {
                textField.text = [toBeString substringToIndex:kParamNameLength];
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
        if (toBeString.length > kParamNameLength) {
            textField.text = [toBeString substringToIndex:kParamNameLength];
            [textField endEditing:YES];
            // 超长保存前30个字
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"字数长度不要超过8字哦！"];
        }
    }
}


#pragma mark - CustomParameterItemViewDelegate
- (void)parameterItemViewAddItemAction:(CustomParameterItemView *)parameterItemView {
    // 修改分组名称
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加自定义项" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入项目名称(不能超过8个字)";
        textField.delegate = self;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)name:@"UITextFieldTextDidChangeNotification"
                                                  object:textField];
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *nameTextField = alertController.textFields.firstObject;
        NSString *nameText = nameTextField.text;
        if (nameText.length <= 0) {
            [[UIApplication sharedApplication].keyWindow showHudFailed:@"请输入新项目的名称"];
            return ;
        }

        NSString * str = [nameText ew_removeSpacesAndLineBreaks];
        if ([str isEqualToString:@""]) {
            [[UIApplication sharedApplication].keyWindow showHudFailed:@"新项目的名称不能只是空格"];
            return ;
        }
        
        GoodsParamterModel *model = [GoodsParamterModel newModel];
        model.name = nameText;
        [parameterItemView.listArray addObject:model];
        [parameterItemView layoutSubviews];
        
//        [self.listArray addObject:model];
        [self.tableView reloadData];
        
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)parameterItemViewDeleteItemAction:(CustomParameterItemView *)parameterItemView atIndex:(NSInteger)index {
    [self.listArray removeObjectAtIndex:index];
    [parameterItemView layoutSubviews];
    [self.tableView reloadData];
}

#pragma  mark - EditGoodsParameterCellDelegate
-  (void)editGoodsParameterCellDeleteAction:(EditGoodsParameterCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    GoodsParamterModel *model = self.listArray[indexPath.section];
    [self deleteActionWithModel:model atIndexPath:indexPath];
    
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    EditGoodsParameterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditGoodsParameterCell"];
//    if (cell == nil) {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"EditGoodsParameterCell" owner:nil options:nil].firstObject;
//        cell.selectionStyle =UITableViewCellSelectionStyleNone;
//    }
//
//
//    cell.nameTF.delegate = self;
//    cell.nameTF.tag = indexPath.section;
//    cell.describeTV.delegate = self;
//    cell.describeTV.tag = indexPath.section;
//    cell.tableView = self.tableView;
//
//    GoodsParamterModel *model = self.listArray[indexPath.section];
//    [cell setName:model.name andDescribe:model.describ];
    
    EditGoodsParameterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditGoodsParameterCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"EditGoodsParameterCell" owner:nil options:nil][2];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }

    cell.delegate = self;
    cell.describeTV.delegate = self;
    cell.describeTV.tag = indexPath.section;
    cell.tableView = self.tableView;
    
    GoodsParamterModel *model = self.listArray[indexPath.section];
    [cell setNewParamName:model.name andDescribe:model.describ];

    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ((indexPat.section == 2 && indexPat.row == 1) || indexPat.section == 3) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UITableViewHeaderFooterView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsParamterModel *model = self.listArray[indexPath.section];
    //删除
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self deleteActionWithModel:model atIndexPath:indexPath];
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    return @[deleteRowAction];
}

- (void)deleteActionWithModel:(GoodsParamterModel *)model atIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    [self.listArray removeObjectAtIndex:indexPath.section];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:(UITableViewRowAnimationFade)];
    
}


#pragma LazyMethod
-(NSMutableArray*)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = Bottom_Color;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 80)];
        _tableView.tableFooterView = footerView;
        UIButton *addMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [footerView addSubview:addMoreBtn];
        [addMoreBtn addTarget:self action:@selector(addMoreAction) forControlEvents:UIControlEventTouchUpInside];
        [addMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.size.equalTo(CGSizeMake(180, 50));
        }];
        [addMoreBtn setTitle:@"＋添加自定义填写项" forState:(UIControlStateNormal)];
        addMoreBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [addMoreBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
    }
    return _tableView;
}


- (CustomParameterItemView *)customerItemView {
    if (_customerItemView== nil) {
        _customerItemView= [[CustomParameterItemView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64)];
        _customerItemView.delegate = self;
        [self.view addSubview:_customerItemView];
        [self.view sendSubviewToBack:self.tableView];
        
        MJWeakSelf;
        _customerItemView.finishBlock = ^(CustomParameterItemView *promptView) {
            weakSelf.listArray= promptView.listArray;
            [weakSelf.tableView reloadData];
            [UIView animateWithDuration:0.25 animations:^{
                promptView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
            }];
        };

    }
    return _customerItemView;
}
@end
