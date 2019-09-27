//
//  UnionActivitySettingController.m
//  iDecoration
//
//  Created by sty on 2017/10/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "UnionActivitySettingController.h"
#import "UnionActivitySetCell.h"
#import "WSDatePickerView.h"
#import "ActivitySignUpSettingController.h"
#import "ActivityCostSettingController.h"
#import "CompanyMarginController.h"
#import "LocationViewController.h"

@interface UnionActivitySettingController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    NSInteger selectTag; //0:选择的是地点。1:选择的是截止类型
    
    NSInteger pointLineUpOrdown;// 线上活动还是线下活动 0:没选(其实也是线上) 1:线下 2:线上
    
    NSInteger timeType;//活动时间选择 0:活动结束之前 1:活动开始之前
    
    NSString *_startTimeStr;
    NSString *_endTimeStr;
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textF;
@property (nonatomic, strong) UITextField *signUpNumF;
@property (nonatomic, strong) UITextField *costTF;

@property (nonatomic, strong) UIView *shadowV;
@property (nonatomic, strong) UIView *bottomAtcionV;
@property (nonatomic, strong) UIButton *buttonOne;
@property (nonatomic, strong) UIButton *buttonTwo;

@property (nonatomic, copy) NSString *tempAddress;//临时的活动地址
@end

@implementation UnionActivitySettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动设置";
    
    if (!self.cost || [self.cost isEqualToString:@""]) {
        self.cost = @"0.00";
    }
    if (!self.costName) {
        self.costName = @"";
    }
    
    
    _startTimeStr = self.actStartTimeStr;
    _endTimeStr = self.actEndTimeStr;
    if ([self.activityPlace integerValue]==1||!self.activityPlace) {
        pointLineUpOrdown = 2;
    }
    else{
        pointLineUpOrdown = 1;
    }
    if ([self.activityEnd integerValue]==0) {
        timeType = 0;
    }
    else{
        timeType = 1;
    }
    
    [self.view addSubview:self.tableView];
    
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"保存" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(successBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // 公司活动有费用， 其他的活动没有费用
    if (self.activityType == ActivityTypeCompany) {
        if (pointLineUpOrdown==1) {
            return 7;
        }
        else{
            return 6;
        }
    } else {
        if (pointLineUpOrdown==1) {
            return 6;
        }
        else{
            return 5;
        }
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
        return [[UITableViewHeaderFooterView alloc]init];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UITableViewHeaderFooterView alloc]init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        UnionActivitySetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnionActivitySetCell"];
        __weak typeof(self) weakSelf = self;
        cell.startBtnBlock = ^{
            [weakSelf showStartTimePickerView];
        };
        cell.endBtnBlock = ^{
            [weakSelf showEndTimePickerView];
        };
        [cell setTime:_startTimeStr endTimeStr:_endTimeStr];
        return cell;
    }else{
        if (self.activityType == ActivityTypeCompany) {
            // 公司活动
            NSMutableArray *leftDataArray = [NSMutableArray array];
            NSMutableArray *rightDataArray = [NSMutableArray array];
            
            if (pointLineUpOrdown==0){
                // 没选
                NSArray *leftArray = @[@"地点",@"报名设置",@"报名截止", @"报名费用" ,@"报名人数"];
                NSArray *rightArray = @[@"请选择",@"",@"活动结束之前均可报名", self.cost,@""];
                [leftDataArray addObjectsFromArray:leftArray];
                
                NSArray *rightArrayTwo = @[@"请选择",@"",@"活动开始之前均可报名", self.cost ,@""];
                if (timeType==0) {
                    [rightDataArray addObjectsFromArray:rightArray];
                }
                else{
                    [rightDataArray addObjectsFromArray:rightArrayTwo];
                }
                
            }
            else if (pointLineUpOrdown==1) {
                //线下活动
                NSArray *leftArray = @[@"地点",@"",@"报名设置",@"报名截止", @"报名费用",@"报名人数"];
                NSArray *rightArray = @[@"线下活动",@"",@"",@"活动结束之前均可报名", self.cost,@""];
                [leftDataArray addObjectsFromArray:leftArray];
                NSArray *rightArrayTwo = @[@"线下活动",@"",@"",@"活动开始之前均可报名", self.cost,@""];
                if (timeType==0) {
                    [rightDataArray addObjectsFromArray:rightArray];
                }
                else{
                    [rightDataArray addObjectsFromArray:rightArrayTwo];
                }
            }
            else{
                //线上活动
                NSArray *leftArray = @[@"地点",@"报名设置",@"报名截止", @"报名费用",@"报名人数"];
                NSArray *rightArray = @[@"线上活动",@"",@"活动结束之前均可报名", self.cost,@""];
                [leftDataArray addObjectsFromArray:leftArray];
                NSArray *rightArrayTwo = @[@"线上活动",@"",@"活动开始之前均可报名", self.cost,@""];
                if (timeType==0) {
                    [rightDataArray addObjectsFromArray:rightArray];
                }
                else{
                    [rightDataArray addObjectsFromArray:rightArrayTwo];
                }
            }
            if (pointLineUpOrdown==1&&indexPath.row==2){
                NSString *cellIdendifier = @"pointLineUpOrdownCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdendifier];;
                }
                cell.contentView.backgroundColor = White_Color;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(15,0,kSCREEN_WIDTH-15-30-5,40)];
                textF.textColor = COLOR_BLACK_CLASS_3;
                textF.font = NB_FONTSEIZ_NOR;
                [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
                [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
                textF.placeholder = @"请设置地点";
                if (!_textF) {
                    _textF = textF;
                }
                textF.text = self.activityAddress;
                [cell addSubview:self.textF];
                
                UIButton *locationButton = [[UIButton alloc]initWithFrame:CGRectMake(textF.right, 5,  30, 30)];
                //            locationButton.centerY = leftL.centerY;
                locationButton.contentMode = UIViewContentModeScaleAspectFit;
                [locationButton  addTarget:self action:@selector(localionButtonAction) forControlEvents:UIControlEventTouchUpInside];
                [locationButton  setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
                [cell addSubview:locationButton];
                
                return cell;
            }
            else{
                NSString *cellIdendifier = @"cellTemp";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdendifier];;
                }
                cell.contentView.backgroundColor = White_Color;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = leftDataArray[indexPath.row-1];
                cell.detailTextLabel.text = rightDataArray[indexPath.row-1];
                cell.textLabel.font = NB_FONTSEIZ_NOR;
                cell.detailTextLabel.font = NB_FONTSEIZ_SMALL;
                
                if ((pointLineUpOrdown==1&&indexPath.row==6)||(pointLineUpOrdown!=1&&indexPath.row==5)){
                    cell.detailTextLabel.hidden = YES;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(100,0,kSCREEN_WIDTH-100-15,40)];
                    textF.textColor = COLOR_BLACK_CLASS_3;
                    textF.font = NB_FONTSEIZ_NOR;
                    textF.textAlignment = NSTextAlignmentRight;
                    [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
                    [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
                    textF.placeholder = @"无限制";
                    textF.keyboardType = UIKeyboardTypeNumberPad;
                    if (!self.signUpNumStr||self.signUpNumStr.length<=0||[self.signUpNumStr isEqualToString:@"无限制"]) {
                        self.signUpNumStr = @"";
                    }
                    textF.text = self.signUpNumStr;
                    if (!_signUpNumF) {
                        _signUpNumF = textF;
                    }
                    [cell addSubview:self.signUpNumF];
                }
                if ((pointLineUpOrdown==1&&indexPath.row==5)||(pointLineUpOrdown!=1&&indexPath.row==4)){
                    cell.detailTextLabel.hidden = YES;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(100,0,kSCREEN_WIDTH-100-15,40)];
                    textF.textColor = COLOR_BLACK_CLASS_3;
                    textF.font = NB_FONTSEIZ_NOR;
                    textF.textAlignment = NSTextAlignmentRight;
                    [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
                    [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
                    textF.placeholder = @"￥0.00";
                    textF.keyboardType = UIKeyboardTypeDecimalPad;
                    if (!self.cost||self.cost.length<=0||[self.cost isEqualToString:@"0.00"] || self.cost.doubleValue == 0) {
                        self.cost = @"0.00";
                        textF.text = @"";
                    } else {
                        textF.text = self.cost;
                    }
                    if (!_costTF) {
                        _costTF = textF;
                    }
                    [cell addSubview:self.costTF];

                }
                
                return cell;
            }
        } else{
            NSMutableArray *leftDataArray = [NSMutableArray array];
            NSMutableArray *rightDataArray = [NSMutableArray array];
            
            if (pointLineUpOrdown==0){
                // 没选
                NSArray *leftArray = @[@"地点",@"报名设置",@"报名截止",@"报名人数"];
                NSArray *rightArray = @[@"请选择",@"",@"活动结束之前均可报名",@""];
                [leftDataArray addObjectsFromArray:leftArray];
                
                NSArray *rightArrayTwo = @[@"请选择",@"",@"活动开始之前均可报名",@""];
                if (timeType==0) {
                    [rightDataArray addObjectsFromArray:rightArray];
                }
                else{
                    [rightDataArray addObjectsFromArray:rightArrayTwo];
                }
                
            }
            else if (pointLineUpOrdown==1) {
                //线下活动
                NSArray *leftArray = @[@"地点",@"",@"报名设置",@"报名截止",@"报名人数"];
                NSArray *rightArray = @[@"线下活动",@"",@"",@"活动结束之前均可报名",@""];
                [leftDataArray addObjectsFromArray:leftArray];
                NSArray *rightArrayTwo = @[@"线下活动",@"",@"",@"活动开始之前均可报名",@""];
                if (timeType==0) {
                    [rightDataArray addObjectsFromArray:rightArray];
                }
                else{
                    [rightDataArray addObjectsFromArray:rightArrayTwo];
                }
            }
            else{
                //线上活动
                NSArray *leftArray = @[@"地点",@"报名设置",@"报名截止",@"报名人数"];
                NSArray *rightArray = @[@"线上活动",@"",@"活动结束之前均可报名",@""];
                [leftDataArray addObjectsFromArray:leftArray];
                NSArray *rightArrayTwo = @[@"线上活动",@"",@"活动开始之前均可报名",@""];
                if (timeType==0) {
                    [rightDataArray addObjectsFromArray:rightArray];
                }
                else{
                    [rightDataArray addObjectsFromArray:rightArrayTwo];
                }
            }
            if (pointLineUpOrdown==1&&indexPath.row==2){
                NSString *cellIdendifier = @"pointLineUpOrdownCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdendifier];;
                }
                cell.contentView.backgroundColor = White_Color;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(15,0,kSCREEN_WIDTH-15-30-5,40)];
                textF.textColor = COLOR_BLACK_CLASS_3;
                textF.font = NB_FONTSEIZ_NOR;
                [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
                [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
                textF.placeholder = @"请设置地点";
                if (!_textF) {
                    _textF = textF;
                }
                textF.text = self.activityAddress;
                [cell addSubview:self.textF];
                
                UIButton *locationButton = [[UIButton alloc]initWithFrame:CGRectMake(textF.right, 5,  30, 30)];
                //            locationButton.centerY = leftL.centerY;
                locationButton.contentMode = UIViewContentModeScaleAspectFit;
                [locationButton  addTarget:self action:@selector(localionButtonAction) forControlEvents:UIControlEventTouchUpInside];
                [locationButton  setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
                [cell addSubview:locationButton];
                
                return cell;
            }
            else{
                NSString *cellIdendifier = @"cellTemp";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdendifier];;
                }
                cell.contentView.backgroundColor = White_Color;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = leftDataArray[indexPath.row-1];
                cell.detailTextLabel.text = rightDataArray[indexPath.row-1];
                cell.textLabel.font = NB_FONTSEIZ_NOR;
                cell.detailTextLabel.font = NB_FONTSEIZ_SMALL;
                
                if ((pointLineUpOrdown==1&&indexPath.row==5)||(pointLineUpOrdown!=1&&indexPath.row==4)){
                    cell.detailTextLabel.hidden = YES;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(100,0,kSCREEN_WIDTH-100-15,40)];
                    textF.textColor = COLOR_BLACK_CLASS_3;
                    textF.font = NB_FONTSEIZ_NOR;
                    textF.textAlignment = NSTextAlignmentRight;
                    [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
                    [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
                    textF.placeholder = @"无限制";
                    textF.keyboardType = UIKeyboardTypeNumberPad;
                    if (!self.signUpNumStr||self.signUpNumStr.length<=0||[self.signUpNumStr isEqualToString:@"无限制"]) {
                        self.signUpNumStr = @"";
                    }
                    textF.text = self.signUpNumStr;
                    if (!_signUpNumF) {
                        _signUpNumF = textF;
                    }
                    [cell addSubview:self.signUpNumF];
                }
                
                return cell;

            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        
    }
    if (indexPath.row==1) {
        selectTag=0;
        [self showBottomActionView];
    }
    if (indexPath.row==2) {
        if (pointLineUpOrdown==1) {
            //textf,不管
        }
        else{
            //报名设置
            ActivitySignUpSettingController *vc = [[ActivitySignUpSettingController alloc]init];
            
            vc.SignUpBlock = ^(NSMutableArray *array) {
                [self.setDataArray removeAllObjects];
                self.setDataArray = array;
            };
            vc.setDataArray = self.setDataArray;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.row==3) {
        if (pointLineUpOrdown==1) {
            //报名设置
            ActivitySignUpSettingController *vc = [[ActivitySignUpSettingController alloc]init];
            vc.SignUpBlock = ^(NSMutableArray *array) {
                [self.setDataArray removeAllObjects];
                self.setDataArray = array;
            };
            vc.setDataArray = self.setDataArray;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            //报名截止
            selectTag=1;
            [self showBottomActionView];
        }
    }
    if (indexPath.row == 4) {
        if (pointLineUpOrdown==1){
            //报名截止
            selectTag=1;
            [self showBottomActionView];
        }
        else{
            if (self.activityType == ActivityTypeCompany) {
                //报名费用
//                ActivityCostSettingController *setVC = [[ActivityCostSettingController alloc] initWithNibName:@"ActivityCostSettingController" bundle:nil];
//                setVC.cost = self.cost;
//                setVC.costName = self.costName;
//                setVC.finishBlock = ^(NSString *name, NSString *cost) {
//                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@", cost];
//                    self.cost = cost;
//                    self.costName = name;
//                };
//                [self.navigationController pushViewController:setVC animated:YES];
            } else {
                //报名人数
            }
            
        }
    }
    if (indexPath.row==5) {
        if (self.activityType == ActivityTypeCompany) {
            if (pointLineUpOrdown==1){
                //报名费用
//                ActivityCostSettingController *setVC = [[ActivityCostSettingController alloc] initWithNibName:@"ActivityCostSettingController" bundle:nil];
//                setVC.finishBlock = ^(NSString *name, NSString *cost) {
//                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@", cost];
//                    self.cost = cost;
//                    self.costName = name;
//                };
//                [self.navigationController pushViewController:setVC animated:YES];
                
            }
            else{
                //报名人数
            }
            
        } else {
              // 其他活动 
        }
        
        
    }
    
    
    
}


#pragma mark - action

-(void)successBtnClick:(UIButton *)btn {
    self.costTF.text = [self.costTF.text ew_removeSpaces];
    self.cost = self.costTF.text;
    if (self.cost.length<=0) {
        self.cost = @"0";
    }
    if (self.cost.doubleValue <= 0) {
        self.cost = @"0";
    }
    
    self.signUpNumF.text = [self.signUpNumF.text ew_removeSpaces];
    NSString *signUpStr = self.signUpNumF.text;
    if (signUpStr.length<=0) {
        signUpStr = @"0";
    }
    self.signUpNumStr = signUpStr;
    
    
    if (self.cost.doubleValue > 0) {
        NSString *defaultAPI = [BASEURL stringByAppendingString:@"company/companyMoney.do"];
        NSDictionary *paraDic = @{@"companyId": @(self.companyID)};
        [NetManager afPostRequest:defaultAPI parms:paraDic finished:^(id responseObj) {
            NSInteger code = [responseObj[@"code"] integerValue];
            if (code == 1000) {
                NSDictionary *dict = responseObj[@"data"][@"companyMoney"];
                // 总金额 = 冻结的金额和非冻结的金额
                NSString *companyActivityBond = dict[@"companyActivityBond"];
                // 冻结的金额
                NSString *frozenActivityMoney = dict[@"frozenActivityMoney"];
                double canUseMoney = companyActivityBond.doubleValue - frozenActivityMoney.doubleValue;
                if (canUseMoney >= self.cost.doubleValue * self.signUpNumStr.doubleValue) {
                    [self successBtnBackClick:btn];
                } else {
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您的保证金余额不足，请充值"];
                    
//                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"您的保证金余额不足，请充值" preferredStyle:(UIAlertControllerStyleAlert)];
//                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//                        
//                    }];
//                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去充值" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//                        CompanyMarginController *vc = [[CompanyMarginController alloc ] initWithNibName:@"CompanyMarginController" bundle:nil];
//                        vc.companyId = [NSString stringWithFormat:@"%ld", self.companyID];
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }];
//                    [alertC addAction:action];
//                    [alertC addAction:action2];
//                    [self presentViewController:alertC animated:YES completion:nil];
                }
                
            }
            if (code == 1004) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您的公司未认证或认证已过期，请前去认证"];
            }
        } failed:^(NSString *errorMsg) {
        }];
    } else {
        [self successBtnBackClick:btn];
    }
}

-(void)successBtnBackClick:(UIButton *)btn{
    
    if (_startTimeStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"开始时间不能为空" controller:self sleep:2.0];
        return;
    }
    if (_endTimeStr.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"结束时间不能为空" controller:self sleep:2.0];
        return;
    }
    
    NSString *currentStr = [self getCurrentTimes];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
//    NSDate *date = [dateFormatter dateFromString:currentStr];
//    NSDate *tempStart = [dateFormatter dateFromString:_startTimeStr];
//    NSDate *tempEnd = [dateFormatter dateFromString:_endTimeStr];
//
//    NSDate *currentDate = [self tDateWith:date];
//    NSDate *startDate = [self tDateWith:tempStart];
//    NSDate *endDate = [self tDateWith:tempEnd];
    
    //1:前一个的时间早。-1:前一个的时间晚。0:一样
    NSInteger a = [self compareDate:_startTimeStr withDate:currentStr];
    NSInteger b = [self compareDate:_endTimeStr withDate:currentStr];
    NSInteger c = [self compareDate:_startTimeStr withDate:_endTimeStr];
    
    
    
    
    if (self.isFistr) {
        //第一次：开始必须大于等于当前时间，结束时间必须大于等于开始时间
        if (a==1) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"开始必须大于等于当前时间" controller:self sleep:2.0];
            return;
        }
        if (c==-1) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"结束时间必须大于等于开始时间" controller:self sleep:2.0];
            return;
        }
        
    }
    else{
        //不是第一次：不限制开始时间，结束时间必须大于等于当前时间并且必须大于等于开始时间
        if (b==1) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"结束时间必须大于等于当前时间" controller:self sleep:2.0];
            return;
        }
        if (c==-1) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"结束时间必须大于等于开始时间" controller:self sleep:2.0];
            return;
        }
    }
    
    self.textF.text = [self.textF.text ew_removeSpaces];
    if (pointLineUpOrdown==1&&self.textF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"地点不能为空" controller:self sleep:2.0];
        return;
    }
    
    if (self.activyty.length<=0) {
        self.activyty = @"0";
    }
    
    NSString *activityPlace;
    if (pointLineUpOrdown!=1) {
        activityPlace = @"1";
    }
    else{
        activityPlace = @"0";
    }
    
    NSString *comStr;
    NSMutableArray *tempArray = [NSMutableArray array];
    if (self.setDataArray.count<=0) {
        
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:tempArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        constructionStr2 = [constructionStr2 ew_removeSpaces];
        constructionStr2 = [constructionStr2 ew_removeSpacesAndLineBreaks];
        comStr = constructionStr2;
    }
    else{
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:self.setDataArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        constructionStr2 = [constructionStr2 ew_removeSpaces];
        constructionStr2 = [constructionStr2 ew_removeSpacesAndLineBreaks];
        comStr = constructionStr2;
    }
    YSNLog(@"%@",comStr);
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.activyty forKey:@"activyty"];
    [dict setObject:_startTimeStr forKey:@"startTime"];
    [dict setObject:_endTimeStr forKey:@"endTime"];
    [dict setObject:activityPlace forKey:@"activityPlace"];
    
    if (pointLineUpOrdown!=1) {
        [dict setObject:@"" forKey:@"activityAddress"];
    }
    else{
        [dict setObject:self.textF.text forKey:@"activityAddress"];
    }
    
    NSString *timeTypeStr = [NSString stringWithFormat:@"%ld",timeType];
    [dict setObject:timeTypeStr forKey:@"activityEnd"];
    [dict setObject:self.signUpNumStr forKey:@"activityPerson"];
    [dict setObject:comStr forKey:@"custom"];
    [dict setObject:self.setDataArray forKey:@"dataArray"];
    
    NSString *longitudeStr;
    if (!self.longitude||self.longitude==0) {
        longitudeStr = @"";
    }
    else{
        longitudeStr = [NSString stringWithFormat:@"%f",self.longitude];
    }
    
    NSString *latitudeStr;
    if (!self.lantitude||self.lantitude==0) {
        latitudeStr = @"";
    }
    else{
        latitudeStr = [NSString stringWithFormat:@"%f",self.lantitude];
    }
    
    [dict setObject:longitudeStr forKey:@"longitude"];
    [dict setObject:latitudeStr forKey:@"latitude"];
    
//    self.costTF.text = [self.costTF.text ew_removeSpaces];
//    self.cost = self.costTF.text;
//    if (self.cost.length<=0) {
//        self.cost = @"0";
//    }
//    if (self.cost.doubleValue <= 0) {
//        self.cost = @"0";
//    }
    [dict setObject:self.cost forKey:@"cost"];
    [dict setObject:self.costName forKey:@"costName"];
    
    if (self.dictBlock) {
        self.dictBlock(dict);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showBottomActionView{
    NSMutableArray *dataArray = [NSMutableArray array];
    NSArray *array =@[@"设置地点（线下活动）",@"线上活动"];
    NSArray *arrayTwo =@[@"活动结束之前均可报名",@"活动开始之前均可报名"];
    if (selectTag==0) {
        [dataArray addObjectsFromArray:array];
    }
    else{
        [dataArray addObjectsFromArray:arrayTwo];
    }
    if (!_shadowV) {
        _shadowV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _shadowV.backgroundColor = COLOR_BLACK_CLASS_9;
        _shadowV.alpha = 0.5;
        _shadowV.userInteractionEnabled = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:_shadowV];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shadowDismiss)];
        [_shadowV addGestureRecognizer:ges];
        
    }
    self.shadowV.hidden = NO;
    if (!_bottomAtcionV) {
        _bottomAtcionV = [[UIView alloc]initWithFrame:CGRectMake(10, kSCREEN_HEIGHT-80-10, kSCREEN_WIDTH-20, 80)];
        _bottomAtcionV.backgroundColor = White_Color;
        _bottomAtcionV.layer.masksToBounds = YES;
        _bottomAtcionV.layer.cornerRadius = 10;
        [[UIApplication sharedApplication].keyWindow addSubview:_bottomAtcionV];
        
        
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editBtn.frame = CGRectMake(20,0,self.bottomAtcionV.width-20,self.bottomAtcionV.height/2-0.5);
        [editBtn setTitle:dataArray[0] forState:UIControlStateNormal];
        [editBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        editBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        [editBtn addTarget:self action:@selector(actionOneClick) forControlEvents:UIControlEventTouchUpInside];
        self.buttonOne = editBtn;
        [self.bottomAtcionV addSubview:self.buttonOne];
        
        
        UIView *lineOne = [[UIView alloc]initWithFrame:CGRectMake(0, editBtn.bottom, self.bottomAtcionV.width, 1)];
        lineOne.backgroundColor = COLOR_BLACK_CLASS_0;
        [self.bottomAtcionV addSubview:lineOne];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(editBtn.left,lineOne.bottom+1,editBtn.width,self.bottomAtcionV.height/2-0.5);
        [deleteBtn setTitle:dataArray[1] forState:UIControlStateNormal];
        [deleteBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        deleteBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        [deleteBtn addTarget:self action:@selector(actionTwoClick) forControlEvents:UIControlEventTouchUpInside];
        self.buttonTwo = deleteBtn;
        [self.bottomAtcionV addSubview:self.buttonTwo];
        
    }
    
    self.bottomAtcionV.hidden = NO;
    [self.buttonOne setTitle:dataArray[0] forState:UIControlStateNormal];
    [self.buttonTwo setTitle:dataArray[1] forState:UIControlStateNormal];
    
}

-(void)shadowDismiss{
    self.shadowV.hidden = YES;
    self.bottomAtcionV.hidden = YES;
}

-(void)actionOneClick{
    if (selectTag==0) {
        pointLineUpOrdown = 1;
    }
    else{
        timeType = 0;
    }
    [self shadowDismiss];
    [self.tableView reloadData];
}

-(void)actionTwoClick{
    if (selectTag==0) {
        pointLineUpOrdown = 2;
        self.longitude = 0;
        self.lantitude = 0;
    }
    else{
        timeType = 1;
    }
    [self shadowDismiss];
    [self.tableView reloadData];
}

-(void)showStartTimePickerView{
    [self.view endEditing:YES];
    if (_startTimeStr&&_startTimeStr.length>0) {
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *scrollToDate = [minDateFormater dateFromString:_startTimeStr];
        
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute title:@"活动开始时间" scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
//            NSLog(@"选择的日期：%@",date);
            _startTimeStr = date;
//            [self.endTimeBtn setTitle:_timeStr forState:UIControlStateNormal];
//            [self.endTimeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
            [self.tableView reloadData];
            
        }];
        datepicker.dateLabelColor = COLOR_BLACK_CLASS_3;//年-月-日-时-分 颜色
        //    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
        //    datepicker.doneButtonColor = RGB(65, 188, 241);//确定按钮的颜色
        //    datepicker.yearLabelColor = [UIColor clearColor];//大号年份字体颜色
        [datepicker show];
    }
    else{
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute title:@"活动开始时间" CompleteBlock:^(NSDate *selectDate) {
            
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
//            NSLog(@"选择的日期：%@",date);
            _startTimeStr = date;
            [self.tableView reloadData];
//            [self.endTimeBtn setTitle:_timeStr forState:UIControlStateNormal];
//            [self.endTimeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
            
        }];
        datepicker.dateLabelColor = COLOR_BLACK_CLASS_3;//年-月-日-时-分 颜色
        //        datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
        //        datepicker.doneButtonColor = [UIColor orangeColor];//确定按钮的颜色
        [datepicker show];
    }
    
}

-(void)showEndTimePickerView{
    [self.view endEditing:YES];
    if (_endTimeStr&&_endTimeStr.length>0) {
        NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
        [minDateFormater setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *scrollToDate = [minDateFormater dateFromString:_endTimeStr];
        
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute title:@"活动结束时间" scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
//            NSLog(@"选择的日期：%@",date);
            _endTimeStr = date;
            [self.tableView reloadData];
            //            [self.endTimeBtn setTitle:_timeStr forState:UIControlStateNormal];
            //            [self.endTimeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
            
        }];
        datepicker.dateLabelColor = COLOR_BLACK_CLASS_3;//年-月-日-时-分 颜色
        //    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
        //    datepicker.doneButtonColor = RGB(65, 188, 241);//确定按钮的颜色
        //    datepicker.yearLabelColor = [UIColor clearColor];//大号年份字体颜色
        [datepicker show];
    }
    else{
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute title:@"活动结束时间" CompleteBlock:^(NSDate *selectDate) {
            
            NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
            NSLog(@"选择的日期：%@",date);
            _endTimeStr = date;
            [self.tableView reloadData];
            //            [self.endTimeBtn setTitle:_timeStr forState:UIControlStateNormal];
            //            [self.endTimeBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
            
        }];
        datepicker.dateLabelColor = COLOR_BLACK_CLASS_3;//年-月-日-时-分 颜色
        //        datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
        //        datepicker.doneButtonColor = [UIColor orangeColor];//确定按钮的颜色
        [datepicker show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 999) {
        if (buttonIndex == 1) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        }
    }
}

#pragma mark - 定位获取地址

- (void)localionButtonAction {
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        
        //定位功能可用
        LocationViewController *locationVC = [[LocationViewController alloc] init];
        NSString *addressDetailStr;
        if (self.activityAddress.length<=0||[self.activityAddress isEqualToString:@"线上活动"]) {
            addressDetailStr = @"";
        }
        else{
            addressDetailStr = self.activityAddress;
        }
        
//        NSString *addressStr = self.addressStr.length > 0 ? self.addressStr: @"";
        locationVC.address = addressDetailStr;
        locationVC.longitude = self.longitude;
        locationVC.latitude  = self.lantitude;
        MJWeakSelf;
        locationVC.locationBlock = ^(NSString *addressName, double lantitude, double longitude){
            weakSelf.activityAddress = addressName;
            weakSelf.tempAddress = addressName;//临时的位置
            
            weakSelf.longitude = longitude;
            weakSelf.lantitude = lantitude;
            weakSelf.textF.text = addressName;
        };
        [self.navigationController pushViewController:locationVC animated:YES];
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        //定位不能用
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"位置不可用"
                                                        message:@"请到 手机设置->爱装修->位置 进行设置"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = 999;
        [alert show];
        
    }
    
    
    
}

//获取当前的时间

-(NSString*)getCurrentTimes{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];

    //现在时间,你可以输出来看下是什么格式

    NSDate *datenow = [NSDate date];


    //----------将nsdate按formatter格式转成nsstring

    NSString *currentTimeString = [formatter stringFromDate:datenow];

    YSNLog(@"currentTimeString =  %@",currentTimeString);

    return currentTimeString;

}

- (NSDate *)tDateWith:(NSDate *)date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
//    NSLog(@"%@", localeDate);
    return localeDate;
}

-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dt1 = [[NSDate alloc]init];
    NSDate *dt2 = [[NSDate alloc]init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case(NSOrderedAscending): ci=1;break;
            //date02比date01小
        case(NSOrderedDescending): ci=-1;break;
            //date02=date01
        case NSOrderedSame: ci=0;break;
        default: YSNLog(@"erorr dates %@, %@", dt2, dt1);break;
    }
    return ci;
}



-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = kBackgroundColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"UnionActivitySetCell" bundle:nil] forCellReuseIdentifier:@"UnionActivitySetCell"];
        
        //        _tableView.tableFooterView = [[UIView alloc] init];
        //        _tableView.separatorColor = kSepLineColor;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
