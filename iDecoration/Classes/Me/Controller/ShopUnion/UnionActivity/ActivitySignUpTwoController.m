//
//  ActivitySignUpTwoController.m
//  iDecoration
//
//  Created by sty on 2017/11/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ActivitySignUpTwoController.h"

@interface ActivitySignUpTwoController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *nameTextF;
@property (nonatomic, strong) UITextField *phoneTextF;
@property (nonatomic, strong) UITextField *codeTextF;//验证码
@property (nonatomic, strong) UIButton *codeBtn;//发送验证码按钮
@end

@implementation ActivitySignUpTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动";
    [self creatUI];
}

-(void)creatUI{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH,kSCREEN_HEIGHT-64)];
    self.scrollView.backgroundColor = White_Color;
    [self.view addSubview:self.scrollView];
    NSMutableArray *temArray = [NSMutableArray array];
    
    NSArray *arr = @[@"姓名",@"手机"];
    [temArray addObjectsFromArray:arr];
    [temArray addObjectsFromArray:self.customStrArray];
    CGFloat textFTop = 15;
    for (int i=0; i<temArray.count; i++) {
        UILabel *LogoName = [[UILabel alloc]initWithFrame:CGRectMake(20, textFTop, kSCREEN_WIDTH-40, 25)];
        LogoName.text = temArray[i];
        LogoName.textColor = COLOR_BLACK_CLASS_3;
        LogoName.font = NB_FONTSEIZ_NOR;
        LogoName.textAlignment = NSTextAlignmentLeft;
        if (i>=2) {
            NSInteger boolTag = [self.customBoolArray[i-2] integerValue];
            if (!boolTag) {
                //非必填，提示
                NSString *str = [NSString stringWithFormat:@"%@(非必填)",temArray[i]];
                LogoName.text = str;
            }
        }
        [self.scrollView addSubview:LogoName];
        UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(LogoName.left,LogoName.bottom,LogoName.width,30)];
        textF.textColor = COLOR_BLACK_CLASS_3;
        textF.backgroundColor = RGB(242, 242, 242);
        textF.font = NB_FONTSEIZ_NOR;
        [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
        [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
//        textF.layer.masksToBounds = YES;
//        textF.layer.cornerRadius = 5;
//        textF.layer.borderWidth = 1.0;
//        textF.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
        textF.text = @"";
        if (i==0) {
            
//            textF.placeholder = @"请输入你的姓名";
            //                textF.tag = 1000;
            //                textF.delegate = self;
            if (!_nameTextF) {
                self.nameTextF = textF;
            }
            [self.scrollView addSubview:self.nameTextF];
        }
        else if (i==1) {
//            textF.placeholder = @"请输入你的手机号";
            //                textF.tag = 1001;
            //                textF.delegate = self;
            if (!_phoneTextF) {
                self.phoneTextF = textF;
            }
            [self.scrollView addSubview:self.phoneTextF];
        }
        else{
//            NSString *str = [NSString stringWithFormat:@"请输入%@",temArray[i]];
//            textF.placeholder = str;
            textF.tag = i-2;
            textF.delegate = self;
            [self.scrollView addSubview:textF];
        }
        
        textFTop = textFTop+10+30+25;
    }
    
    
    
    
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(20,textFTop+10,(self.scrollView.width-40),40)];
    tempView.layer.masksToBounds = YES;
    tempView.layer.cornerRadius = 5;
    tempView.layer.borderWidth = 1.0;
    tempView.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
    [self.scrollView addSubview:tempView];
    UITextField *textF = [[UITextField alloc]initWithFrame:CGRectMake(0,0,(tempView.width)/5*3,40)];
    textF.textColor = COLOR_BLACK_CLASS_3;
    textF.font = [UIFont systemFontOfSize:16];
    [textF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
    [textF setValue:NB_FONTSEIZ_NOR forKeyPath:@"_placeholderLabel.font"];
    textF.tag = 1002;
    //        textF.layer.masksToBounds = YES;
    //        textF.layer.cornerRadius = 5;
    //        textF.layer.borderWidth = 1.0;
    //        textF.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
    
    if (!_codeTextF) {
        _codeTextF = textF;
    }
    [tempView addSubview:self.codeTextF];
    
    UIButton *successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    successBtn.frame = CGRectMake(textF.right,textF.top,(tempView.width)/5*2,textF.height);
    successBtn.backgroundColor = Main_Color;
    [successBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [successBtn setTitleColor:White_Color forState:UIControlStateNormal];
    successBtn.titleLabel.font = NB_FONTSEIZ_BIG;
    self.codeBtn = successBtn;
    [self.codeBtn addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //        successBtn.layer.masksToBounds = YES;
    //        successBtn.layer.cornerRadius = 5;
    [tempView addSubview:self.codeBtn];
    
    UIButton *tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tipBtn.frame = CGRectMake(self.scrollView.width-200,tempView.bottom+10,200,30);
    tipBtn.backgroundColor = White_Color;
    [tipBtn setTitle:@"报名后可凭验证码参加活动" forState:UIControlStateNormal];
    tipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [tipBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
    tipBtn.titleLabel.font = NB_FONTSEIZ_SMALL;
    [self.scrollView addSubview:tipBtn];
    
    
    UIButton *signUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpBtn.frame = CGRectMake(20,tipBtn.bottom+50,self.scrollView.width-40,40);
    signUpBtn.backgroundColor = Main_Color;
    [signUpBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    signUpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [signUpBtn setTitleColor:White_Color forState:UIControlStateNormal];
    signUpBtn.titleLabel.font = NB_FONTSEIZ_BIG;
    signUpBtn.layer.masksToBounds = YES;
    signUpBtn.layer.cornerRadius = 5;
    [signUpBtn addTarget:self action:@selector(requestSignUp) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:signUpBtn];
    
    
    
    if (signUpBtn.bottom>self.scrollView.height) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, textFTop);
    }
    else{
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.scrollView.height);
    }
}

#pragma mark - 发送验证码
-(void)codeBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    self.phoneTextF.text = [self.phoneTextF.text ew_removeSpaces];
    if (self.phoneTextF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"手机号不能为空" controller:self sleep:2.0];
        return;
    }
    if (![self.phoneTextF.text ew_justCheckPhone]||self.phoneTextF.text.length>11) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"手机号格式不正确" controller:self sleep:2.0];
        return;
    }
    NSString *phone = self.phoneTextF.text;
//    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"sms/getSignUpSms.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"phone":phone,
                               @"activityName":_activityName,
                               @"address":_activityAdress,
                               @"activityId":self.activityId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"验证码发送成功" controller:self sleep:2.0];
                
                __block int timeout = 120; //倒计时时间
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_timer, ^{
                    
                    if(timeout <= 0) { //倒计时结束，关闭
                        
                        dispatch_source_cancel(_timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置界面的按钮显示 根据自己需求设置
                            [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                            self.codeBtn.userInteractionEnabled = YES;
                            self.codeBtn.backgroundColor = Main_Color;
                        });
                        
                    } else {
                        
                        int seconds = timeout;
                        NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置界面的按钮显示 根据自己需求设置
                            //NSLog(@"____%@",strTime);
                            [UIView beginAnimations:nil context:nil];
                            [UIView setAnimationDuration:1];
                            [self.codeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                            [UIView commitAnimations];
                            self.codeBtn.userInteractionEnabled = NO;
                            self.codeBtn.backgroundColor = kDisabledColor;
                        });
                        timeout--;
                    }
                });
                
                dispatch_resume(_timer);
                
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"发送失败" controller:self sleep:2.0];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"今天的短信数量已达到最大限制" controller:self sleep:2.0];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"发送短信出错" controller:self sleep:2.0];
            }
            else if (statusCode==2001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"短信模版解释异常，请重新发送" controller:self sleep:2.0];
            } else if(statusCode == 1003) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"您的手机号已经报名成功" controller:self sleep:2.0];
            } else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"发送短信出错" controller:self sleep:2.0];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"发送短信出错" controller:self sleep:2.0];
        YSNLog(@"%@",errorMsg);
    }];
    
}

#pragma mark - 报名接口
-(void)requestSignUp{
    [self.view endEditing:YES];
    self.nameTextF.text = [self.nameTextF.text ew_removeSpaces];
    if (self.nameTextF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"姓名不能为空" controller:self sleep:2.0];
        return;
    }
    self.phoneTextF.text = [self.phoneTextF.text ew_removeSpaces];
    if (self.phoneTextF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"手机号不能为空" controller:self sleep:2.0];
        return;
    }
    if (![self.phoneTextF.text ew_justCheckPhone]||self.phoneTextF.text.length>11) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"手机号格式不正确" controller:self sleep:2.0];
        return;
    }
    
    self.codeTextF.text = [self.codeTextF.text ew_removeSpaces];
    if (self.codeTextF.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"验证码不能为空" controller:self sleep:2.0];
        return;
    }
    
    if (self.dataArray.count<=0) {
        
    }
    else{
        //便利数组，是否有空项
        NSMutableArray *tagArray = [NSMutableArray array];
        for (int i = 0; i<self.dataArray.count; i++) {
            NSString *str = self.dataArray[i];
            str = [str ew_removeSpaces];
            if (str.length<=0) {
                NSString *temStr = [NSString stringWithFormat:@"%d",i];
                [tagArray addObject:temStr];
            }
        }
        if (tagArray.count>0) {
            //有空项--判断每一个空项是否应该必填
            bool isMust = NO;
            NSInteger mustNum = 0;//必填项名称的tag
            for (NSString *str in tagArray) {
                NSInteger temTag = [str integerValue];
                NSInteger mustTag = [self.customBoolArray[temTag]integerValue];
                if (mustTag==1) {
                    isMust = YES;//必添
                    mustNum = temTag;
                    break;
                }
                else{
                    isMust = NO;
                }
            }
            if (isMust) {
                NSString *str = [NSString stringWithFormat:@"%@必填",self.customStrArray[mustNum]];
                [[PublicTool defaultTool] publicToolsHUDStr:str controller:self sleep:2.0];
                return;
            }
            
        }
        else{
            
        }
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.nameTextF.text forKey:@"userName"];
    [dict setObject:self.phoneTextF.text forKey:@"userPhone"];
    [dict setObject:self.activityId forKey:@"activityId"];
    [dict setObject:self.codeTextF.text forKey:@"code"];
    
    NSMutableArray *temArray = [NSMutableArray array];
    if (self.customStrArray.count<=0) {
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:self.customStrArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        constructionStr2 = [constructionStr2 ew_removeSpaces];
        constructionStr2 = [constructionStr2 ew_removeSpacesAndLineBreaks];
        [dict setObject:constructionStr2 forKey:@"customs"];
    }
    else{
        
        for (int i = 0; i<self.customStrArray.count; i++) {
            NSMutableDictionary *temDict = [NSMutableDictionary dictionary];
            [temDict setObject:self.customStrArray[i] forKey:@"customName"];
            [temDict setObject:self.dataArray[i] forKey:@"customValue"];
            [temArray addObject:temDict];
        }
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:temArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        constructionStr2 = [constructionStr2 ew_removeSpaces];
        constructionStr2 = [constructionStr2 ew_removeSpacesAndLineBreaks];
        [dict setObject:constructionStr2 forKey:@"customs"];
    }
    
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *constructionStr2 = [[NSString alloc]initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    constructionStr2 = [constructionStr2 ew_removeSpaces];
    constructionStr2 = [constructionStr2 ew_removeSpacesAndLineBreaks];
    //    {"userName":"姓名","userPhone":"电话","activityId":"活动id","code":"验证码","customs":[{"customName":"自定义项名称","customValue":"自定义值"}]}
    
//    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"signUp/signUp.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];

    NSDictionary *paramDic = @{@"signJson":constructionStr2
                               ,@"origin":@"2"};

    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"报名成功" controller:self sleep:2.0];
                [self.navigationController popViewControllerAnimated:YES];
//                [self shadowDismiss];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:2.0];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数格式错误" controller:self sleep:2.0];
            }
            else if (statusCode==1003) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"验证码错误" controller:self sleep:2.0];
            }
            else if (statusCode==1004) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"验证码过期" controller:self sleep:2.0];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"报名失败" controller:self sleep:2.0];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"报名失败" controller:self sleep:2.0];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - textFieldDelegate

//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    NSInteger tag = textField.tag;
//    [self.dataArray replaceObjectAtIndex:tag withObject:textField.text];
//}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger tag = textField.tag;
    [self.dataArray replaceObjectAtIndex:tag withObject:textField.text];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger tag = textField.tag;
    [self.dataArray replaceObjectAtIndex:tag withObject:textField.text];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
