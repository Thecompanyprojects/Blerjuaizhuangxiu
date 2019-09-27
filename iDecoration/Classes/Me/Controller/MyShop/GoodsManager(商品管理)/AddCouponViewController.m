//
//  AddAllSubPromotionController.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "AddCouponViewController.h"
#import "AddPromotionCell.h"
#import "PromtionSubCell.h"
#import "WSDatePickerView.h"
#import "SelectGoodsController.h"
#import "GoodsListModel.h"

@interface AddCouponViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *finishiBtn;
@property (nonatomic, assign) BOOL haveSelectGoods; // 已经选择了商品
@property (nonatomic, strong) NSArray *selectGoodsImageArray;
@property (nonatomic, strong) NSArray *selectGoodsModelArray;



@property (nonatomic, strong) NSString *activityName;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *totalMoney;
@property (nonatomic, strong) NSString *subMoney;


@end

@implementation AddCouponViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].previousNextDisplayMode = IQPreviousNextDisplayModeAlwaysHide;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"添加推广";
    _haveSelectGoods = NO;
    
    self.activityName = @"";
    self.startTime = @"";
    self.endTime = @"";
    self.totalMoney = @"";
    self.subMoney = @"";
    
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
    
    NSString *ActivityName = self.activityName;
    if ([ActivityName isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入活动名称"];
        return;
    }

    NSString *starTime = self.startTime;
    if ([starTime isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入活动开始时间"];
        return;
    }
   
    NSString *endTime = self.endTime;
    if ([endTime isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入活动结束时间"];
        return;
    }
    
    if (self.isSectionGoods && self.selectGoodsModelArray.count == 0) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择活动商品"];
        return;
    }
    
    NSString *totalMoney = self.totalMoney;
    NSString *subMoney = self.subMoney;
    
    if ([totalMoney isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入券面金额"];
        return;
    }
    
    if ([subMoney isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入使用条件"];
        return;
    }
    
    if ([NSObject compareDate:starTime littlewithDate:endTime] != 1) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入大于开始的时间"];
        return;
    }
    
    starTime = [starTime stringByAppendingString:@":00"];
    endTime = [endTime stringByAppendingString:@":00"];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"merchandiesActivity/save.do"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:ActivityName forKey:@"activityName"];
    if (self.isSectionGoods) {
        [paramDic setObject:@(6) forKey:@"activityType"];
    } else {
        [paramDic setObject:@(5) forKey:@"activityType"];
    }
    [paramDic setObject:starTime forKey:@"startTime"];
    [paramDic setObject:endTime forKey:@"endTime"];
    [paramDic setObject:@(self.isSectionGoods) forKey:@"activityRange"];
    [paramDic setObject:@(0) forKey:@"consumeMoney"];
//    [paramDic setObject:@(totalMoney.doubleValue) forKey:@"discountMoney"];
    [paramDic setObject:totalMoney forKey:@"discountMoney"];
    [paramDic setObject:subMoney forKey:@"makeCondition"];
    [paramDic setObject:@(0) forKey:@"tcPrice"];
    [paramDic setObject:@(0) forKey:@"merSum"];
    [paramDic setObject:@(self.shopId.integerValue) forKey:@"merchantId"];
    if (self.isSectionGoods) {
        //部分商品
        [paramDic setObject:[self paramStringFromArray:self.selectGoodsModelArray] forKey:@"listAdd"];
        [paramDic setObject:@"[{\"merchandiesId\":\"\",\"merchandiesDisplay\":\"\"}]" forKey:@"merchandiesList"];
    } else {
        [paramDic setObject:@"[{\"merchandiesId\":\"\",\"merchandiesDisplay\":\"\"}]" forKey:@"listAdd"];
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
    vc.CompletionBlock = ^(NSArray *array) {
        _haveSelectGoods = YES;
        weakSelf.selectGoodsImageArray = array;
        [weakSelf.tableView reloadData];
    };
    vc.CompletionBlockWithGoodsModel = ^(NSArray *array) {
        weakSelf.selectGoodsModelArray = array;
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
    
    
    
    return YES;;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    AddPromotionCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (textField == cell.textField) {
        self.activityName = cell.textField.text;
    }
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    PromtionSubCell *subCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (textField == subCell.totalMoneyTF) {
        self.totalMoney = textField.text;
    }
    if (textField == subCell.subMoneyTF) {
        self.subMoney = textField.text;
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
        return 3;
    }
    if (section == 2) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 110;
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
        PromtionSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromtionSubCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"PromtionSubCell" owner:nil options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.totalMoneyTF.delegate = self;
        cell.totalMoneyTF.keyboardType = UIKeyboardTypeDecimalPad;
        cell.totalMoneyLabel.text = @"券面金额";
        cell.totalMoneyTF.text = self.totalMoney;
        
        cell.subMoneyTF.delegate = self;
        cell.subMoneyTF.keyboardType = UIKeyboardTypeDecimalPad;
        cell.subMoneyTF.placeholder = @"请填写金额";
        cell.subMonyLabel.text = @"使用条件";
        cell.subMoneyTF.text = self.subMoney;
        
        return cell;
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
            [cell.selectGoodsBtn setTitle:@"选择优惠商品" forState:UIControlStateNormal];
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
                cell.textField.text = _isSectionGoods ? @"限定适用" : @"全店适用";
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

