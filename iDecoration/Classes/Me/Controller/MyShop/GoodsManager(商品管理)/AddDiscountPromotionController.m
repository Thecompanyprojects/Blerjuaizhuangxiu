//
//  AddAllSubPromotionController.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "AddDiscountPromotionController.h"
#import "AddPromotionCell.h"
#import "WSDatePickerView.h"
#import "SelectGoodsController.h"
#import "GoodsListModel.h"


@interface AddDiscountPromotionController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *finishiBtn;
@property (nonatomic, assign) BOOL haveSelectGoods; // 已经选择了商品
//@property (nonatomic, strong) NSArray *selectGoodsImageArray;
@property (nonatomic, strong) NSMutableArray *selectedGoodsModelArray; // 商品数据数组

@property (nonatomic, strong) NSString *activityName; // 活动名称
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *oldPrice;
@property (nonatomic, strong) NSString *discountPrice; // 折扣数
@property (nonatomic, strong) NSString *presentPrice; // 一口价
@end

@implementation AddDiscountPromotionController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].previousNextDisplayMode = IQPreviousNextDisplayModeAlwaysHide;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"添加推广";
    self.selectedGoodsModelArray = [NSMutableArray array];
    _haveSelectGoods = NO;
    
    self.activityName = @"";
    self.startTime = @"";
    self.endTime = @"";
    self.oldPrice = @"";
    self.discountPrice = @"";
    self.presentPrice = @"";
    
    [self tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].previousNextDisplayMode = IQPreviousNextDisplayModeAlwaysShow;
}

#pragma mark - NormalMethod

- (void)backAction {
    if (self.CompletionBlock) {
        self.CompletionBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishAction {
    
    if ([self.activityName isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入活动名称"];
        return;
    }

    if (self.startTime == nil || [self.startTime isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入活动开始时间"];
        return;
    }

    if (self.endTime== nil || [self.endTime isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入活动结束时间"];
        return;
    }
    
    if (!_haveSelectGoods) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择套餐商品"];
        return;
    }
    
    if ([self.discountPrice isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入折扣数"];
        return;
    }
    
    if ([self.presentPrice isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入套餐价格"];
        return;
    }
    
    
    NSString *startT = [self.startTime copy];
    NSString *endT = [self.endTime copy];
    if ([NSObject compareDate:startT littlewithDate:endT] != 1) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入大于开始的时间"];
        return;
    } else {
        startT = [startT stringByAppendingString:@":00"];
        endT = [endT stringByAppendingString:@":00"];
    }
    
    
    
    if (self.selectedGoodsModelArray.count > 5) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"套餐商品不能大于5个"];
        return;
    }
    
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"merchandiesActivity/save.do"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:self.activityName forKey:@"activityName"];
    [paramDic setObject:@(7) forKey:@"activityType"];
    [paramDic setObject:startT forKey:@"startTime"];
    [paramDic setObject:endT forKey:@"endTime"];
    [paramDic setObject:@(1) forKey:@"activityRange"];
//    [paramDic setObject:@(self.oldPrice.doubleValue) forKey:@"consumeMoney"];
//    [paramDic setObject:@(self.discountPrice.doubleValue) forKey:@"discountMoney"];
//    [paramDic setObject:@(self.presentPrice.doubleValue) forKey:@"tcPrice"];
    [paramDic setObject:self.oldPrice forKey:@"consumeMoney"];
    [paramDic setObject:self.discountPrice forKey:@"discountMoney"];
    [paramDic setObject:self.presentPrice forKey:@"tcPrice"];
    
    [paramDic setObject:@"" forKey:@"makeCondition"];
    [paramDic setObject:@(0) forKey:@"merSum"];
    [paramDic setObject:@(self.shopId.integerValue) forKey:@"merchantId"];
    
    [paramDic setObject:[self paramStringFromArray:self.selectedGoodsModelArray] forKey:@"listAdd"];

    
    [paramDic setObject:@"[{\"merchandiesId\":\"\",\"merchandiesDisplay\":\"\"}]" forKey:@"merchandiesList"];
    
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        NSInteger code = [responseObj[@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"添加成功"];
                [self performSelector:@selector(backAction) withObject:nil afterDelay:1.0];
            }
                break;
                
            default:
            {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"添加失败， 稍后再试"];
            }
                break;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (NSString *)paramStringFromArray:(NSArray<GoodsListModel *> *)goodsArray {
    NSMutableDictionary *multiDict = [NSMutableDictionary dictionary];
    NSMutableString *paramString = [NSMutableString string];
    [paramString appendString:@"["];
    
    for (int i = 0; i < goodsArray.count; i ++) {
        GoodsListModel *model = goodsArray[i];
        // "content":"","imgUrl":
        [multiDict setObject:@(model.goodsID) forKey:@"merchandiesId"];
        [multiDict setObject:model.display forKey:@"merchandiesDisplay"];
        
        
        NSString *dictStr = [self dictionaryToJson:multiDict];
        [paramString appendString:dictStr];
        if (i != goodsArray.count - 1) {
            [paramString appendString:@","];
        }
        [multiDict removeAllObjects];
    }
    
    [paramString appendString:@"]"];
    return paramString;
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


// 去选择商品
- (void)selectGoodsAction {
    SelectGoodsController *vc = [SelectGoodsController new];
    vc.shopId = self.shopId;
    MJWeakSelf;
    vc.CompletionBlockWithGoodsModel = ^(NSArray *array) {
        [weakSelf.selectedGoodsModelArray addObjectsFromArray:array];
        _haveSelectGoods = (weakSelf.selectedGoodsModelArray .count > 0);
        self.discountPrice = @"";
        self.presentPrice = @"";
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteGoods:(UIButton *)sender {
    [self.selectedGoodsModelArray removeObjectAtIndex:sender.tag];
    self.discountPrice = @"";
    self.presentPrice = @"";
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:(UITableViewRowAnimationFade)];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    AddPromotionCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (cell.textField == textField) {
        [self.view endEditing:YES];
        [textField resignFirstResponder];
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute title:@"开始时间" scrollToDate:[NSDate date] CompleteBlock:^(NSDate *selectDate) {
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            textField.text = date;
            self.startTime = date;
        }];
        datepicker.dateLabelColor = COLOR_BLACK_CLASS_3;//年-月-日-时-分 颜色
        [datepicker show];
        return NO;
    }
    AddPromotionCell *endCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    if (endCell.textField == textField) {
        [self.view endEditing:YES];
        [textField resignFirstResponder];
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute title:@"结束时间" scrollToDate:[NSDate date] CompleteBlock:^(NSDate *selectDate) {
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            textField.text = date;
            self.endTime = date;
        }];
        datepicker.dateLabelColor = COLOR_BLACK_CLASS_3;//年-月-日-时-分 颜色
        [datepicker show];
        return NO;
    }
    if (!_haveSelectGoods) {
        AddPromotionCell *endCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        if (endCell.textField == textField) {
            [self.view endEditing:YES];
            [textField resignFirstResponder];
            [self selectGoodsAction];
            return NO;
        }
    }
    
    
    return YES;;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    AddPromotionCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.textField == textField) {
        self.activityName = textField.text;
    }
    
    
    indexPath = [NSIndexPath indexPathForRow:2 inSection:2];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.textField == textField) {
        if (textField.text.doubleValue > self.oldPrice.doubleValue) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"折扣数不能大于套餐原价"];
            textField.text = @"";
            return;
        }
        self.discountPrice = textField.text;
        
        indexPath = [NSIndexPath indexPathForRow:3 inSection:2];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.textField.text = [NSString stringWithFormat:@"%.2f", self.oldPrice.doubleValue - self.discountPrice.doubleValue];
        self.presentPrice = cell.textField.text;
    }
    
    indexPath = [NSIndexPath indexPathForRow:3 inSection:2];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.textField == textField) {
        if (textField.text.doubleValue > self.oldPrice.doubleValue) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"套餐价不能大于套餐原价"];
            textField.text = @"";
            return;
        }
        self.presentPrice = textField.text;
        
        indexPath = [NSIndexPath indexPathForRow:2 inSection:2];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.textField.text = [NSString stringWithFormat:@"%.2f", self.oldPrice.doubleValue - self.presentPrice.doubleValue];
        self.discountPrice = cell.textField.text;
    }
    
}
#pragma mark - UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 2;
    }
    if (section == 2) {
        return _haveSelectGoods ? 4 : 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if (_haveSelectGoods) {
            if (indexPath.row == 0) {
                if (self.selectedGoodsModelArray.count == 5) {
                    return 40 +  5 * 98;
                } else {
                    return self.selectedGoodsModelArray.count * (98) + 40 + 38;
                }
            } else {
                return 44;
            }
        } else {
            return 44;
        }
    } else {
        return 44;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 || indexPath.section == 1) {
        AddPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddPromotionCell"];
        if (cell == nil) {
            cell = [[AddPromotionCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"AddPromotionCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.nameLabel.text = @"活动名称";
            cell.textField.placeholder = @"请输入活动名称";
            cell.textField.delegate = self;
            cell.textField.textColor = [UIColor blackColor];
            if (self.activityName != nil && self.activityName.length > 0) {
                cell.textField.text = self.activityName;
            }
        }
        if (indexPath.section == 1) {
            cell.nameLabel.text = @[@"开始时间", @"结束时间"][indexPath.row];
            cell.textField.placeholder = @[@"请选择开始时间", @"请选择结束时间"][indexPath.row];
            cell.textField.delegate = self;
            cell.textField.textColor = [UIColor blackColor];
            if (indexPath.row== 0) {
                if (self.startTime != nil && self.startTime.length > 0) {
                    cell.textField.text = self.startTime;
                }
            }
            if (indexPath.row== 1) {
                if (self.endTime != nil && self.endTime.length > 0) {
                    cell.textField.text = self.endTime;
                }
            }
        }
        return cell;
    }if (indexPath.section == 2) {
        if (!_haveSelectGoods) {
            AddPromotionCell *cell = [[AddPromotionCell alloc] init];
            cell.nameLabel.text = @"套餐商品";
            cell.textField.placeholder = @"请选择（最多5个）";
            cell.textField.delegate = self;
            return cell;
        } else {
            // 选择商品了
            if (indexPath.row == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, 80, 20)];
                [cell.contentView addSubview:nameLabel];
                nameLabel.font = [UIFont systemFontOfSize:16];
                nameLabel.text = @"套餐商品";
                
                for ( int i = 0; i < self.selectedGoodsModelArray.count; i ++) {
                    GoodsListModel *model = self.selectedGoodsModelArray[i];
                    UIView * goodsView = [[UIView alloc] initWithFrame:CGRectMake(16, i * (90 + 8) + 40, kSCREEN_WIDTH - 32, 90)];
                    [cell.contentView addSubview:goodsView];
                    goodsView.layer.borderWidth = 1;
                    goodsView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
                    [goodsView addSubview:imageView];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:model.display]];
                    
                    UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH - 32 - 40, 0, 1, 90)];
                    lineView.backgroundColor = [UIColor lightGrayColor];
                    [goodsView addSubview:lineView];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, kSCREEN_WIDTH - 32 - 90 - 40, 20)];
                    [goodsView addSubview:label];
                    label.font = [UIFont systemFontOfSize:16];
                    label.text = model.name;
                    
                    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, kSCREEN_WIDTH - 32 - 90 - 40, 20)];
                    [goodsView addSubview:priceLabel];
                    priceLabel.textColor = [UIColor redColor];
                    priceLabel.font = [UIFont systemFontOfSize:14];
                    priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
                    
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH - 32 - 40, 0, 40, 90)];
                    [goodsView addSubview:btn];
                    btn.tag = i;
                    [btn setImage:[UIImage imageNamed:@"prompt_delete"] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(deleteGoods:) forControlEvents:UIControlEventTouchUpInside];
                }
                if (self.selectedGoodsModelArray.count < 5) {
                    UIButton * addMoreBtn  = [[UIButton alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH/2.0 - 50, 40 + self.selectedGoodsModelArray.count * (98), 100, 30)];
                    [cell.contentView addSubview:addMoreBtn];
                    [addMoreBtn setTitle:@"继续添加" forState:UIControlStateNormal];
                    addMoreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [addMoreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    addMoreBtn.layer.borderWidth = 1;
                    addMoreBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    addMoreBtn.layer.cornerRadius = 4;
                    addMoreBtn.layer.masksToBounds = YES;
                     [addMoreBtn addTarget:self action:@selector(selectGoodsAction) forControlEvents:UIControlEventTouchUpInside];
                }
                return cell;
            } else {
                AddPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddPromotionCellSectionTwo"];
                if (cell == nil) {
                    cell = [[AddPromotionCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"AddPromotionCellSectionTwo"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.nameLabel.text = @[@"套餐原价", @"套餐折扣", @"套餐价格"][indexPath.row - 1];
                cell.textField.placeholder = @[@"请输入原价", @"请填写折扣数", @"请填写一口价"][indexPath.row - 1];
                cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                if (indexPath.row == 1) {
                    cell.textField.userInteractionEnabled = NO;
                    cell.textField.textColor = [UIColor redColor];
                    CGFloat sumPrice = 0;
                    for (int i = 0; i < self.selectedGoodsModelArray.count; i ++) {
                        GoodsListModel *model = self.selectedGoodsModelArray[i];
                        sumPrice += model.price.floatValue;
                    }
                    cell.textField.text = [NSString stringWithFormat:@"%.2f", sumPrice];
                    self.oldPrice = [NSString stringWithFormat:@"%.2f", sumPrice];
                }
                if (indexPath.row == 2) {
                    cell.textField.userInteractionEnabled = YES;
                    cell.textField.textColor = [UIColor blackColor];
                    if (self.discountPrice != nil) {
                        cell.textField.text = self.discountPrice;
                    }
                }
                if (indexPath.row == 3) {
                    cell.textField.userInteractionEnabled = YES;
                    cell.textField.textColor = [UIColor blackColor];
                    if (self.presentPrice != nil) {
                        cell.textField.text = self.presentPrice;
                    }
                }
                cell.textField.delegate = self;
                return cell;
            }
        }
    }
    return [UITableViewCell new];
}

#pragma mark - LazyMethod

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
        footerView.backgroundColor = kBackgroundColor;
        _tableView.tableFooterView = footerView;
        _finishiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [footerView addSubview:_finishiBtn];
        [_finishiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH- 32, 40));
        }];
        [_finishiBtn setTitle:@"完        成" forState:(UIControlStateNormal)];
        [_finishiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishiBtn setBackgroundColor:kMainThemeColor];
        _finishiBtn.layer.cornerRadius = 4;
        _finishiBtn.layer.masksToBounds = YES;
        [_finishiBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _tableView;
}

@end


