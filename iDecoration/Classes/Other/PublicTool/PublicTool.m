//
//  PublicTool.m
//  iDecoration
//
//  Created by RealSeven on 17/2/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "PublicTool.h"
#import "UserInfoModel.h"
#import "LoginViewController.h"

@implementation PublicTool

//单例类的静态实例对象，因对象需要唯一性，故只能是static类型

static PublicTool *defaultTool = nil;

//单例模式对外的唯一接口，用到的dispatch_once函数在一个应用程序内只会执行一次，且dispatch_once能确保线程安全

+(PublicTool*)defaultTool{
    

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (defaultTool == nil) {
            
            defaultTool = [[self alloc] init];
        }
    });
   
    return defaultTool;
}

//覆盖该方法主要确保当用户通过[[Singleton alloc] init]创建对象时对象的唯一性，alloc方法会调用该方法，只不过zone参数默认为nil，因该类覆盖了allocWithZone方法，所以只能通过其父类分配内存，即[super allocWithZone:zone]

+(id)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        if (defaultTool == nil) {
            defaultTool = [super allocWithZone:zone];
        }
    });
    
    return defaultTool;
}

//自定义初始化方法
-(instancetype)init{
    
    if (self = [super init]) {
        
    }
    return self;
}

//覆盖该方法主要确保当用户通过copy方法产生对象时对象的唯一性
-(id)copy{
    
    return self;
}

//覆盖该方法主要确保当用户通过mutableCopy方法产生对象时对象的唯一性
-(id)mutableCopy{
    return self;
}

#pragma mark -- 正则匹配手机号
-(BOOL)publicToolsCheckTelNumber:(NSString*)telNumber
{
    
//    NSString *phoneRegex = @"1[3|4|5|6|7|8|9|][0-9]{9}";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
// return [phoneTest evaluateWithObject:telNumber];
    NSString *str1 = [telNumber substringToIndex:1];//截取掉下标1之前的字符串
    if (telNumber.length==11&&[str1 isEqualToString:@"1"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}



#pragma mark -- textField添加leftView
-(void)publicToolsAddLeftViewWithTextField:(UITextField*)textField{
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, textField.frame.size.height)];
    leftView.backgroundColor = [UIColor clearColor];
    
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark -- 弹出确定提示

-(void)publicToolsSureAlertInfo:(NSString *)info controller:(UIViewController *)controller{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:info preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:sureAction];
    
    [controller presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark -- 检测字符串是否英文及数字组合
-(BOOL)publicToolsCheckStrIsWordsWithNumber:(NSString*)str{
    
    NSString *pattern = @"^[A-Za-z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    
    return isMatch;
}

#pragma mark -- 提示自动消失
-(void)publicToolsHUDStr:(NSString *)HUDStr controller:(UIViewController*)controller sleep:(CGFloat)second{
    
    MBProgressHUD * HUD = [[MBProgressHUD alloc]initWithView:controller.view];
//    HUD.frame = CGRectMake(0, kSCREEN_HEIGHT/2-30, kSCREEN_WIDTH, 60);
//    HUD.labelText = HUDStr;
    HUD.mode = MBProgressHUDModeText;
    HUD.detailsLabelText = HUDStr;
    HUD.detailsLabelFont = [UIFont systemFontOfSize:16];
    HUD.margin = 10.f;
    HUD.yOffset = BLEJHeight/2-100;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(second);
    } completionBlock:^{
        [HUD removeFromSuperview];
        
    }];
    
    [controller.view addSubview:HUD];

}

#pragma mark -- 得到保存用户信息的Model
- (UserInfoModel*)publicToolsGetUserInfoModelFromDict {
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT];
//    NSMutableDictionary *dict22 = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    UserInfoModel *user = [UserInfoModel yy_modelWithJSON:dict];
    
    return user;
}

#pragma mark -- 判断用户是否登陆
-(BOOL)publicToolsJudgeIsLogined{
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT];
    
    UserInfoModel *user = [UserInfoModel yy_modelWithJSON:dict];
    
    BOOL isLogined;
    
    if (user.agencyId) {
        
        isLogined = YES;
        
    }else{
        isLogined = NO;
    }
    
    return isLogined;
}

#pragma mark --通过时间戳得到日期字符串
-(NSString*)getDateFormatStrFromTimeStamp:(NSString*)timeStamp{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/ 1000.0];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

- (NSString*)getDateFormatStrFromTimeStampWithSeconds:(NSString*)timeStamp {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/ 1000.0];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

- (NSString*)getDateFormatStrFromTimeStampWithMin:(NSString*)timeStamp {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/ 1000.0];
    NSString *dateString = [dateFormatter stringFromDate:date];

    return dateString;
}

- (NSString*)newgetDateFormatStrFromTimeStampWithMin:(NSString*)timeStamp {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"MM月dd日HH:mm"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]/ 1000.0];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

- (BOOL)accurateVerifyIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = (int)value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}

@end


