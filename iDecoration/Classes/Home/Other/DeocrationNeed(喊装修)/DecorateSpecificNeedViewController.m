//
//  DecorateSpecificNeedViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DecorateSpecificNeedViewController.h"
#import "DecorateSpecificNeedCell.h"
#import "DecorateInfoNeedView.h"
#import "DecorateCompletionViewController.h"


@interface DecorateSpecificNeedViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;

// 选择的人口选择
@property (nonatomic, strong) NSMutableArray *selectedPeopleMultiArray;
// 选择的房屋面积
@property (nonatomic, strong) NSMutableArray *selectedHomeAreaMultiArray;
// 选择的装修预算
@property (nonatomic, strong) NSMutableArray *selectedBudgetMultiArray;
// 选择的风格
@property (nonatomic, strong) NSMutableArray *selectedStyleMultiArray;
// 选择的色调
@property (nonatomic, strong) NSMutableArray *selectedColorMultiArray;
// 选择的个性化需求
@property (nonatomic, strong) NSMutableArray *selectedSpecialNeedMultiArray;
// 房屋面积
@property (nonatomic, strong) UITextField *arearTF;
// 房屋面积
@property (nonatomic, assign) double area;

@property (nonatomic, strong) DecorateInfoNeedView *infoView;

//存放参数的字典
@property(nonatomic,strong)NSMutableDictionary *paramDict;

@end

@implementation DecorateSpecificNeedViewController

#pragma mark - lifeMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线预约";
    self.selectedPeopleMultiArray = [NSMutableArray array];
    self.selectedHomeAreaMultiArray = [NSMutableArray array];
    self.selectedBudgetMultiArray = [NSMutableArray array];
    self.selectedStyleMultiArray = [NSMutableArray array];
    self.selectedColorMultiArray = [NSMutableArray array];
    self.selectedSpecialNeedMultiArray = [NSMutableArray array];
    [self tableView];
    
    self.infoView = [[NSBundle mainBundle] loadNibNamed:@"DecorateInfoNeedView" owner:nil options:nil].lastObject;
    self.infoView.frame = self.view.frame;
    [self.infoView.finishButton addTarget:self action:@selector(finishiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.infoView];
    self.infoView.hidden = YES;
    
    MJWeakSelf;
    self.infoView.sendVertifyCodeBlock = ^{
        [weakSelf sendvertifyAction];
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].previousNextDisplayMode =IQPreviousNextDisplayModeAlwaysHide;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].previousNextDisplayMode =IQPreviousNextDisplayModeAlwaysShow;
}

#pragma mark - 下一步
- (void)nextStepAction {
    YSNLog(@"下一步%@", self.title);
    
    if (self.selectedPeopleMultiArray.count == 0) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择家庭人口结构类型"];
        return;
    }
    if (self.selectedHomeAreaMultiArray.count == 0) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择房屋面积"];
        return;
    }
//    if (self.area <= 0) {
//        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择输入房屋面积"];
//        return;
//    }
    if (self.selectedPeopleMultiArray.count == 0) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择家庭人口结构类型"];
        return;
    }
    if (self.selectedBudgetMultiArray.count == 0) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择您的装修预算"];
        return;
    }
    if (self.selectedStyleMultiArray.count == 0) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择您喜欢的风格"];
        return;
    }
    if (self.selectedColorMultiArray.count == 0) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择您喜欢的色调"];
        return;
    }
    if (self.selectedSpecialNeedMultiArray.count == 0) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择您的个性化需求"];
        return;
    }
    
    self.infoView.hidden = NO;
}


#pragma  mark - 发送验证码
- (void)sendvertifyAction {
    [self.infoView endEditing:YES];
    if (![self.infoView.phoneTF.text ew_justCheckPhone]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的手机号"];
        return;
    }
    
    NSString* url = [NSString stringWithFormat:@"%@%@", BASEURL, @"callDecoration/sendPhoneCode.do"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.infoView.phoneTF.text forKey:@"phone"];
    [param setObject:@(self.companyID.integerValue) forKey:@"companyId"];
    MJWeakSelf
    [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码发送成功"];
                [weakSelf timelessWithSecond:120 button:weakSelf.infoView.sendVertifyBtn];
                break;
            case 1001:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"当月已喊过装修"];
                break;
            default:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"预约失败或操作过于频繁"];
                break;
        }
    } failed:^(NSString *errorMsg) {
        
    }];

}

- (void) timelessWithSecond:(NSInteger)s button:(UIButton *)btn {
    __block int timeout = (int)s; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout <= 0) { //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
                btn.backgroundColor = kMainThemeColor;
            });
            
        } else {
            
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [btn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                btn.userInteractionEnabled = NO;
                btn.backgroundColor = kDisabledColor;
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
}
#pragma mark - 完成
- (void)finishiAction {
    
    if ([self.infoView.nameTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入您的姓名"];
        return;
    }
    if (![self.infoView.phoneTF.text ew_checkPhoneNumber]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的联系方式"];
        return;
    }
    if (self.infoView.vertifyCodeTF.text.length != 6) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入6位数的验证码"];
        return;
    }
    if ([self.infoView.areaTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择您的装修的区域"];
        return;
    }
    if ([self.infoView.timeTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择您要装修的时间"];
        return;
    }
    
    self.infoView.hidden = YES;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.selectedPeopleMultiArray.firstObject forKey:@"familyStructure"];
    [dic setObject:self.selectedHomeAreaMultiArray.firstObject forKey:@"area"];
//    [dic setObject:@(self.area) forKey:@"area"];
    [dic setObject:self.selectedBudgetMultiArray.firstObject forKey:@"budget"];
    NSString *style = [self.selectedStyleMultiArray componentsJoinedByString:@","];
    [dic setObject:style forKey:@"style"];
    NSString *color = [self.selectedColorMultiArray componentsJoinedByString:@","];
    [dic setObject:color forKey:@"tone"];
    NSString *special = [self.selectedSpecialNeedMultiArray componentsJoinedByString:@","];
    [dic setObject:special forKey:@"individualization"];
    [dic setObject:self.infoView.phoneTF.text forKey:@"phone"];
    [dic setObject:self.infoView.nameTF.text forKey:@"fullName"];
    [dic setObject:@(self.companyID.integerValue) forKey:@"companyId"];
    [dic setObject:self.infoView.timeTF.text forKey:@"houseDate"];
    [dic setObject:@(self.infoView.provinceNum.integerValue) forKey:@"province"];
    [dic setObject:@(self.infoView.cityNum.integerValue) forKey:@"city"];
    [dic setObject:@(self.infoView.countyNum.integerValue) forKey:@"county"];
    NSString *imgStr = [self.imageURLArray componentsJoinedByString:@","];
    
    [dic setObject:imgStr.length > 0 ? imgStr : @"" forKey:@"img"];
    [dic setObject:@(0) forKey:@"type"];
    [dic setObject:self.infoView.areaTF.text forKey:@"address"];
    [dic setObject:self.infoView.vertifyCodeTF.text forKey:@"phoneCode"];
    self.paramDict = dic;
    YSNLog(@"param: %@", dic);
    [self upDataRequest:dic];
}

-(void)upDataRequest:(NSDictionary *)dic {
    [[UIApplication sharedApplication].keyWindow hudShow];
    __weak typeof(self)  weakSelf = self;
    NSString *url = [BASEURL stringByAppendingString:@"callDecoration/save.do"];
    [NetManager  afGetRequest:url parms:dic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        YSNLog(@"%@",responseObj);
        switch ([responseObj[@"code"] integerValue]) {
                //喊装修成功
            case 1000:
            {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您已提交成功请等待回复"];
                // 睡一秒
                [NSThread sleepForTimeInterval:1];
                
                DecorateCompletionViewController *completionVC = [[DecorateCompletionViewController alloc] init];
                completionVC.dataDic = responseObj[@"data"];
                completionVC.companyType = @"1018";
                [self.navigationController pushViewController:completionVC animated:YES];
                break;
            }
            case 1001:
                break;
                //            本月已喊过装修
            case 1002:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您本月已经预约过了"];
                break;
                //            不在装修区域
            case 1003:
                [self replySubmit];
                break;
                //             该区域暂无接单公司
            case 1004:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该区域暂无接单公司"];
                break;
            case 2000:
            {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"预约修失败，稍后重试"];
                break;
            }
            case 2001:
            {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码错误"];
                break;
            }
            default:
                break;
        }
        
    } failed:^(NSString *errorMsg) {
        [weakSelf.view hiddleHud];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"网络出错"];
    }];
}

#pragma mark   不在装修区域  是否继续提交
-(void)replySubmit{
    //该地区不在装修公司服务区域，继续提交，我们会为您提供本地区优秀公司服务，是否继续提交？
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"该地区不在装修公司服务区域，继续提交，我们会为您提供本地区优秀公司服务，是否继续提交？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    __weak typeof(self)  weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"提交" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.paramDict setObject:@(1) forKey:@"type"];
        
        [weakSelf upDataRequest:self.paramDict];
    }];
    
    
    [aler addAction:action];
    [aler addAction:action1];
    [self presentViewController:aler animated:YES completion:nil];
}

#pragma  mark - UITableViewDelegate/Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJWeakSelf;
    if (indexPath.section == 0) {
        DecorateSpecificNeedCell *cell = [[DecorateSpecificNeedCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleName = @"家庭人口结构（单选）";
        cell.isSingleSelected = YES;
        cell.selectedBtnTitleMulArray = self.selectedPeopleMultiArray;
        cell.buttonTitleArray = @[@"单身", @"情侣", @"亲子之家", @"退休老人2个", @"三代同堂"];
        cell.selectedBlock = ^(NSMutableArray *selectedArray) {
            weakSelf.selectedPeopleMultiArray = selectedArray;
            [weakSelf.arearTF resignFirstResponder];
        };
        return cell;
    } else if(indexPath.section == 1) {
        DecorateSpecificNeedCell *cell = [[DecorateSpecificNeedCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleName = @"房屋面积（单选）";
        cell.isSingleSelected = YES;
        cell.selectedBtnTitleMulArray = self.selectedHomeAreaMultiArray;
        cell.buttonTitleArray = @[ @"60平以下", @"60-80", @"80-120", @"120-180", @"180-230", @"230以上", @"别墅"];
        cell.selectedBlock = ^(NSMutableArray *selectedArray) {
            weakSelf.selectedHomeAreaMultiArray = selectedArray;
            [weakSelf.arearTF resignFirstResponder];
        };
        return cell;
    } else if (indexPath.section == 2) {
       DecorateSpecificNeedCell *cell = [[DecorateSpecificNeedCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleName = @"装修预算（单选）";
        cell.isSingleSelected = YES;
        cell.selectedBtnTitleMulArray = self.selectedBudgetMultiArray;
        cell.buttonTitleArray = @[ @"5万以下", @"5-10万", @"10-20万", @"20-30万", @"30万以上", @"不清楚"];
        cell.selectedBlock = ^(NSMutableArray *selectedArray) {
            weakSelf.selectedBudgetMultiArray = selectedArray;
            [weakSelf.arearTF resignFirstResponder];
        };
        return cell;
    }else if (indexPath.section == 3) {
        DecorateSpecificNeedCell *cell = [[DecorateSpecificNeedCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleName = @"喜欢的风格（多选）";
        cell.isSingleSelected = NO;
        cell.selectedBtnTitleMulArray = self.selectedStyleMultiArray;
        cell.buttonTitleArray = @[@"欧罗巴",@"北欧",@"中欧",@"简约",@"地中海",@"日式",@"韩式",@"馨尚",@"美式",@"说不清"];
        cell.selectedBlock = ^(NSMutableArray *selectedArray) {
            weakSelf.selectedStyleMultiArray = selectedArray;
            [weakSelf.arearTF resignFirstResponder];
        };
        return cell;
    }else if (indexPath.section == 4) {
        DecorateSpecificNeedCell *cell = [[DecorateSpecificNeedCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleName = @"喜欢的色调（多选）";
        cell.isSingleSelected = NO;
        cell.selectedBtnTitleMulArray = self.selectedColorMultiArray;
        cell.buttonTitleArray = @[@"白色",@"原木色",@"红色",@"暖色",@"明亮浅",@"说不清"];
        cell.selectedBlock = ^(NSMutableArray *selectedArray) {
            weakSelf.selectedColorMultiArray = selectedArray;
            [weakSelf.arearTF resignFirstResponder];
        };
        return cell;
    }else if (indexPath.section == 5) {
        DecorateSpecificNeedCell *cell = [[DecorateSpecificNeedCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleName = @"个性化需求（多选）";
        cell.isSingleSelected = NO;
        cell.selectedBtnTitleMulArray = self.selectedSpecialNeedMultiArray;
        cell.buttonTitleArray = @[@"地暖",@"衣帽间",@"中央空调",@"暖气",@"吧台",@"养宠物", @"增加储物空间"];
        cell.selectedBlock = ^(NSMutableArray *selectedArray) {
            weakSelf.selectedSpecialNeedMultiArray = selectedArray;
            [weakSelf.arearTF resignFirstResponder];
        };
        return cell;
    }
//    else if (indexPath.section == 1) {
//        UITableViewCell *cell = [[UITableViewCell alloc] init];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        UILabel *label = [UILabel new];
//        [cell.contentView addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(20);
//            make.top.equalTo(10);
//            make.bottom.equalTo(-10);
//            make.height.equalTo(20);
//        }];
//        label.font = [UIFont systemFontOfSize:14];
//        label.text = @"房屋面积";
//        label.textColor = [UIColor blackColor];
//
//        UILabel *label2 = [UILabel new];
//        [cell.contentView addSubview:label2];
//        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(-20);
//            make.centerY.equalTo(label);
//            make.height.equalTo(20);
//        }];
//        label2.font = [UIFont systemFontOfSize:14];
//        label2.text = @"m²";
//        label2.textColor = [UIColor blackColor];
//
//        UITextField *areaTF = [[UITextField alloc] init];
//        self.arearTF = areaTF;
//        areaTF.tag = 111;
//        [cell.contentView addSubview:areaTF];
//        [areaTF mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(label);
//            make.left.equalTo(label.mas_right).equalTo(0);
//            make.right.equalTo(label2.mas_left).equalTo(-8);
//        }];
//        areaTF.textAlignment = NSTextAlignmentRight;
//        areaTF.borderStyle = UITextBorderStyleNone;
//        areaTF.placeholder = @"请输入面积";
//        areaTF.font = [UIFont systemFontOfSize:14];
//        areaTF.keyboardType = UIKeyboardTypeDecimalPad;
//        if (self.area) {
//            areaTF.text = [NSString stringWithFormat:@"%.2f", self.area];
//        }
//        areaTF.delegate = self;
//
//        return cell;
//    }
    else {
        return [UITableViewCell new];
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 1) {
//        [self.arearTF becomeFirstResponder];
//    } else {
//        [self.arearTF resignFirstResponder];
//    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  CGFLOAT_MIN;
}

#pragma  mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.arearTF) {
        self.area = textField.text.doubleValue;
    }
    
}


#pragma mark - LazyMethod
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
//        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(0);
//            make.left.right.bottom.equalTo(0);
//        }];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.footerView;
        
        [_tableView registerClass:[DecorateSpecificNeedCell class] forCellReuseIdentifier:@"DecorateSpecificNeedCell"];
        
    }
    return _tableView;
}

- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 150)];
        _footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footerView addSubview:nextButton];
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.width.equalTo(kSCREEN_WIDTH/3.0 * 2);
            make.height.equalTo(40);
        }];
        [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [nextButton setTitle:@"下一步" forState:UIControlStateHighlighted];
        nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        nextButton.backgroundColor = kMainThemeColor;
        nextButton.layer.cornerRadius = 6;
        [nextButton addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _footerView;
}




@end
