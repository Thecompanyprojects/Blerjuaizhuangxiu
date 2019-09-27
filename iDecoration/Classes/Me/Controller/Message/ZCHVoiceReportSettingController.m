//
//  ZCHVoiceReportSettingController.m
//  iDecoration
//
//  Created by 赵春浩 on 2017/11/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHVoiceReportSettingController.h"

@interface ZCHVoiceReportSettingController ()

@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@end

@implementation ZCHVoiceReportSettingController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 5)];
    // 1计算报价: calculatorReport 2客户预约: appointmentReport 3报名活动: activityReport
    switch ([self.type integerValue]) {
        case 1:
            
            self.title = @"家装计算器";
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"calculatorReport"]) {
                //    取
                BOOL calculatorReport = [[[NSUserDefaults standardUserDefaults] objectForKey:@"calculatorReport"] boolValue];
                self.switchBtn.on = calculatorReport;
            } else {
                
                self.switchBtn.on = YES;
            }
            break;
        case 2:
            
            self.title = @"客户预约";
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"appointmentReport"]) {
                //    取
                BOOL calculatorReport = [[[NSUserDefaults standardUserDefaults] objectForKey:@"appointmentReport"] boolValue];
                self.switchBtn.on = calculatorReport;
            } else {
                
                self.switchBtn.on = YES;
            }
            break;
        case 3:
            
            self.title = @"报名活动";
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"activityReport"]) {
                //    取
                BOOL calculatorReport = [[[NSUserDefaults standardUserDefaults] objectForKey:@"activityReport"] boolValue];
                self.switchBtn.on = calculatorReport;
            } else {
                
                self.switchBtn.on = YES;
            }
            break;
            
        default:
            break;
    }
}

- (IBAction)didClickSwitchBtn:(UISwitch *)sender {
    
    switch ([self.type integerValue]) {
        case 1:
            
            [[NSUserDefaults standardUserDefaults] setObject:@(sender.on) forKey:@"calculatorReport"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 2:
            
            [[NSUserDefaults standardUserDefaults] setObject:@(sender.on) forKey:@"appointmentReport"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case 3:
            
            [[NSUserDefaults standardUserDefaults] setObject:@(sender.on) forKey:@"activityReport"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        default:
            break;
    }
}




- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
