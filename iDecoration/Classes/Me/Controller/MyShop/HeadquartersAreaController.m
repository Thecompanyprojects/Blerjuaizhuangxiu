//
//  HeadquartersAreaController.m
//  iDecoration
//  装修区域
//  Created by Apple on 2017/5/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "HeadquartersAreaController.h"

@interface HeadquartersAreaController ()
@property (nonatomic, strong) UILabel *addressL;
@property (nonatomic, strong) UIView *lineV;
@end

@implementation HeadquartersAreaController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    
}

- (void)creatUI {
    self.navigationItem.title = @"装修区域";
    self.view.backgroundColor = White_Color;
    [self.view addSubview:self.addressL];
    [self.view addSubview:self.lineV];
    
    
}

#pragma mark - action

-(void)setAreaBtn{
    for (int i = 0; i<9; i++) {
        
    }
}

#pragma mark - setter

-(UILabel *)addressL{
    if (!_addressL) {
        _addressL = [[UILabel alloc]initWithFrame:CGRectMake(30, 64+10, kSCREEN_WIDTH-30*2, 30)];
        _addressL.textColor = COLOR_BLACK_CLASS_3;
        _addressL.font = [UIFont systemFontOfSize
                         :14];
        _addressL.text = @"北京市";
//        _addressL.backgroundColor = Red_Color;
        _addressL.textAlignment = NSTextAlignmentLeft;
    }
    return _addressL;
}

-(UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]initWithFrame:CGRectMake(0, self.addressL.bottom+5, kSCREEN_WIDTH, 2)];
        _lineV.backgroundColor = [UIColor grayColor];
    }
    return _lineV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
