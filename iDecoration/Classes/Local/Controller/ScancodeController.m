//
//  ScancodeController.m
//  iDecoration
//
//  Created by sty on 2018/3/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ScancodeController.h"
#import "XYMScanView.h"
#import <AVFoundation/AVFoundation.h>

#import "ZCHPublicWebViewController.h"
#import "STYRedResultController.h"
#import "STYSearchRedCodeController.h"

#import "PellTableViewSelect.h"

@interface ScancodeController ()<XYMScanViewDelegate>
@property (nonatomic,weak) XYMScanView *scanV;
@end

@implementation ScancodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"扫码二维码";
    
    XYMScanView *scanV = [[XYMScanView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.navigationController.navigationBar.bottom)];
    scanV.delegate = self;
    [self.view addSubview:scanV];
    _scanV = scanV;
    
    
    // 设置导航栏最右侧的按钮
    UIButton *moreBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    moreBtn.frame = CGRectMake(0, 0, 44, 44);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"threemorewithe"]];
    [moreBtn addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.centerY.equalTo(0);
        make.size.equalTo(CGSizeMake(25, 25));
    }];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, -12)];
    
    [moreBtn addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
}

#pragma mark - 三点按钮
- (void)moreBtnClicked:(UIButton *)sender {
    
    // 弹出的自定义视图
    NSArray *array = @[@"兑换码"];
    
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(self.view.bounds.size.width-100, 64, 120, 0) selectData:array images:nil action:^(NSInteger index) {
        
        NSString *contStr = array[index];
        if ([contStr isEqualToString:@"兑换码"]) {
            STYSearchRedCodeController *vc = [[STYSearchRedCodeController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        else  {
            
        }
        
    } animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getScanDataString:(NSString*)scanDataString{
    
    NSLog(@"二维码内容：%@",scanDataString);
    //    ScanResultViewController *scanResultVC = [[ScanResultViewController alloc]init];
    //    scanResultVC.view.backgroundColor = [UIColor whiteColor];
    //    scanResultVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //    scanResultVC.scanDataString = scanDataString;
    //    [self.navigationController pushViewController:scanResultVC animated:YES];
    
    
    STYRedResultController *vc = [[STYRedResultController alloc]init];
    vc.code = scanDataString;
    [self.navigationController pushViewController:vc animated:YES];
    
//    NSString *shareOneURL = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"cblejcouponcustomer/%@.do", scanDataString]];
    
    
}
@end
