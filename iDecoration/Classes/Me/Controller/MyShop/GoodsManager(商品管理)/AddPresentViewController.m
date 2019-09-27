//
//  AddAllSubPromotionController.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "AddPresentViewController.h"
#import "AddPromotionCell.h"
#import "PromtionSubCell.h"
#import "WSDatePickerView.h"
#import "SelectGoodsController.h"
#import "GoodsListModel.h"

@interface AddPresentViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *finishiBtn;
@property (nonatomic, assign) BOOL isSelectePresentGoods; // 去选择商品时  是否是去选中赠品
@property (nonatomic, assign) BOOL haveSelectGoods; // 已经选择了商品
@property (nonatomic, assign) BOOL haveSelectPresent; // 已经选择zengp
@property (nonatomic, strong) NSArray *selectGoodsImageArray;
@property (nonatomic, strong) NSArray *selectGoodsModelArray;
@property (nonatomic, strong) NSArray *selectPresentImageArray;
@property (nonatomic, strong) NSArray *selectPresentModelArray;


@property (nonatomic, strong) NSString *totalMoney; // 活动金额


@property (nonatomic, strong) NSString *activityName;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *presentNum; // 库存


@end

@implementation AddPresentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].previousNextDisplayMode = IQPreviousNextDisplayModeAlwaysHide;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"添加推广";
    _haveSelectGoods = NO;
    _isSelectePresentGoods = NO;
    _haveSelectPresent = NO;
    
    self.activityName = @"";
    self.startTime = @"";
    self.endTime = @"";
    self.totalMoney = @"";
    self.presentNum = @"";
    
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
    
    NSIndexPath *indexPath;
    AddPromotionCell *cell;
    if ([self.activityName isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入活动名称"];
        return;
    }
    
    if ([self.startTime isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入活动开始时间"];
        return;
    }
    
    if ([self.endTime isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入活动结束时间"];
        return;
    }

    if (self.isSectionGoods && !_haveSelectGoods) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输活动商品"];
        return;
    }
    if ([self.totalMoney isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入活动金额"];
        return;
    }
    if (!_haveSelectPresent) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择赠品"];
        return;
    }
    
    
    if ([self.presentNum isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入库存数量"];
        return;
    }
    
    NSString *starTime = self.startTime;
    NSString *endTime = self.endTime;

    if ([NSObject compareDate:starTime littlewithDate:endTime] != 1) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入大于开始的时间"];
        return;
    }
    
    starTime = [starTime stringByAppendingString:@":00"];
    endTime = [endTime stringByAppendingString:@":00"];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"merchandiesActivity/save.do"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:self.activityName forKey:@"activityName"];
    if (self.isSectionGoods) {
        [paramDic setObject:@(2) forKey:@"activityType"];
    } else {
        [paramDic setObject:@(1) forKey:@"activityType"];
    }
    
    [paramDic setObject:starTime forKey:@"startTime"];
    [paramDic setObject:endTime forKey:@"endTime"];
    [paramDic setObject:@(self.isSectionGoods) forKey:@"activityRange"];
//    [paramDic setObject:@(self.totalMoney.doubleValue) forKey:@"consumeMoney"];
    [paramDic setObject:self.totalMoney forKey:@"consumeMoney"];
    [paramDic setObject:@(0) forKey:@"discountMoney"];
    [paramDic setObject:@"" forKey:@"makeCondition"];
    [paramDic setObject:@(0) forKey:@"tcPrice"];
    [paramDic setObject:@(self.presentNum.integerValue) forKey:@"merSum"];
    [paramDic setObject:@(self.shopId.integerValue) forKey:@"merchantId"];
    if (self.isSectionGoods) {
        //部分商品
        [paramDic setObject:[self paramStringFromArray:self.selectGoodsModelArray] forKey:@"listAdd"];
        [paramDic setObject:[self paramStringFromArray:self.selectPresentModelArray] forKey:@"merchandiesList"];
    } else {
        [paramDic setObject:[self paramStringFromArray:self.selectPresentModelArray] forKey:@"listAdd"];
        [paramDic setObject:@"[{\"merchandiesId\":\"\",\"merchandiesDisplay\":\"\"}]" forKey:@"merchandiesList"];
    }

    

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
//        [multiDict setObject:[NSString stringWithFormat:@"%ld", model.goodsID] forKey:@"merchandiesId"];
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
    _isSelectePresentGoods = NO;
    SelectGoodsController *vc = [SelectGoodsController new];
    vc.shopId = self.shopId;
    MJWeakSelf;
    vc.CompletionBlock = ^(NSArray *array) {
        _haveSelectGoods = (array.count > 0);
        weakSelf.selectGoodsImageArray = array;
        [weakSelf.tableView reloadData];
    };
    vc.CompletionBlockWithGoodsModel = ^(NSArray *array) {
        weakSelf.selectGoodsModelArray = array;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectPresentGoodsAction {
    _isSelectePresentGoods = YES;
    SelectGoodsController *vc = [SelectGoodsController new];
    vc.shopId = self.shopId;
    MJWeakSelf;
    vc.CompletionBlock = ^(NSArray *array) {
        _haveSelectPresent = (array.count > 0);
        weakSelf.selectPresentImageArray = array;
        [weakSelf.tableView reloadData];
    };
    vc.CompletionBlockWithGoodsModel = ^(NSArray *array) {
        weakSelf.selectPresentModelArray = array;
    };
    [self.navigationController pushViewController:vc animated:YES];
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
    
    if (_haveSelectPresent) {
        return YES;
    } else {
        PromtionSubCell *presentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        if (presentCell.subMoneyTF == textField) {
            [self.view endEditing:YES];
            [textField resignFirstResponder];
            
            [self selectPresentGoodsAction];
            
            return NO;
        }
    }
    
    
    return YES;;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
//    PromtionSubCell *subCell = [self.tableView cellForRowAtIndexPath:indexPath];
//    if (textField == subCell.totalMoneyTF) {
//        self.totalMoney = subCell.totalMoneyTF.text;
//    }
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    AddPromotionCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (textField == cell.textField) {
        self.activityName = cell.textField.text;
    }
    
    if (_haveSelectPresent) {
        PromtionSubCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        if (textField == cell.totalMoneyTF) {
            self.totalMoney = textField.text;
        }
        if (textField == cell.subMoneyTF) {
            self.presentNum = textField.text;
        }
    } else {
        PromtionSubCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        if (textField == cell.totalMoneyTF) {
            self.totalMoney = textField.text;
        }
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
        return _isSectionGoods ? 4 : 3;
    }
    if (section == 2) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return _haveSelectGoods|| _haveSelectPresent ? 180 : 110;
    } else if(indexPath.section == 1 && indexPath.row == 3) {
        return 80;
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
    if (indexPath.section == 2) {
        if (_haveSelectPresent) {
            PromtionSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromtionSubBottomHaveGoodCell"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"PromtionSubCell" owner:nil options:nil][3];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell.rightBtn addTarget:self action:@selector(selectPresentGoodsAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.scrollView removeAllSubViews];
            for (int i = 0; i < self.selectPresentImageArray.count; i ++) {
                UIImageView *imageV = [[UIImageView alloc] initWithImage:self.selectPresentImageArray[i]];
                [cell.scrollView addSubview:imageV];
                imageV.frame = CGRectMake(i * (55 + 5), 0, 55, 55);
            }
            cell.scrollView.contentSize = CGSizeMake(60 * self.selectPresentImageArray.count, 55);
            
            cell.totalMoneyTF.keyboardType = UIKeyboardTypeDecimalPad;
            cell.totalMoneyTF.delegate = self;
            cell.totalMoneyTF.text = self.totalMoney;
            
            cell.subMoneyTF.keyboardType = UIKeyboardTypeDecimalPad;
            cell.subMoneyTF.text = self.presentNum;
            cell.subMoneyTF.delegate = self;
            return cell;
        } else {
            PromtionSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromtionSubCell"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"PromtionSubCell" owner:nil options:nil][0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.totalMoneyTF.delegate = self;
            cell.totalMoneyTF.keyboardType = UIKeyboardTypeDecimalPad;
            cell.subMonyLabel.text = @"送赠品";
            cell.subMoneyTF.delegate = self;
            cell.subMoneyTF.placeholder = @"请选择商品";
            
            return cell;
        }
        
    } else if(indexPath.section == 1 && indexPath.row == 3) {
        if (_haveSelectGoods) {
            PromtionSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromtionSubCellHaveGoods"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"PromtionSubCell" owner:nil options:nil][2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell.rightBtn addTarget:self action:@selector(selectGoodsAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.scrollView removeAllSubViews];
            //            cell.scrollView.contentSize = cell.scrollView.frame.size;
            for (int i = 0; i < self.selectGoodsImageArray.count; i ++) {
                UIImageView *imageV = [[UIImageView alloc] initWithImage:self.selectGoodsImageArray[i]];
                [cell.scrollView addSubview:imageV];
                imageV.frame = CGRectMake(i * (55 + 5), 0, 55, 55);
            }
            cell.scrollView.contentSize = CGSizeMake(60 * self.selectGoodsImageArray.count, 55);
            cell.numLabel.text = [NSString stringWithFormat:@"共%uld件", self.selectGoodsImageArray.count];
            return cell;
        } else {
            PromtionSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromtionSubCellNotGoods"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"PromtionSubCell" owner:nil options:nil][1];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell.selectGoodsBtn setTitle:@"选择满送商品" forState:UIControlStateNormal];
            [cell.selectGoodsBtn addTarget:self action:@selector(selectGoodsAction) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
    } else {
        AddPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddPromotionCell"];
        if (cell == nil) {
            cell = [[AddPromotionCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"AddPromotionCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.nameLabel.text = @"活动名称";
            cell.textField.placeholder = @"请输入活动名称";
            cell.textField.delegate = self;
            cell.textField.text = self.activityName;
        }
        if (indexPath.section == 1) {
            cell.nameLabel.text = @[@"开始时间", @"结束时间", @"活动范围"][indexPath.row];
            cell.textField.placeholder = @[@"请选择开始时间", @"请选择结束时间", @""][indexPath.row];
            cell.textField.delegate = self;
            if (indexPath.row == 2) {
                cell.textField.text = _isSectionGoods ? @"部分商品满送" : @"全店满送";
                cell.textField.userInteractionEnabled = NO;
            }
            if (indexPath.row == 0) {
                cell.textField.text = self.startTime;
                cell.textField.userInteractionEnabled = YES;
            }
            if (indexPath.row == 1) {
                cell.textField.text = self.endTime;
                cell.textField.userInteractionEnabled = YES;
            }
        }
        
        return cell;
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

