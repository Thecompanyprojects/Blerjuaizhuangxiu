//
//  changeshareVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "changeshareVC.h"

@interface changeshareVC ()<UITextViewDelegate>
@property (nonatomic,strong) UILabel *toplab;
@property (nonatomic,strong) UITextView *shareText;
@property (nonatomic,strong) UIButton *submitBtn;
@end

@implementation changeshareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"编辑资料";
    [self.view addSubview:self.toplab];
    [self.view addSubview:self.shareText];
    [self.view addSubview:self.submitBtn];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupUI
{
    [self.toplab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(14);
        make.top.equalTo(self.view).with.offset(kNaviBottom+12);
        make.right.equalTo(self.view).with.offset(-14);
    }];
    [self.shareText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(14);
        make.top.equalTo(self.toplab.mas_bottom).with.offset(12);
        make.height.mas_offset(73);
        make.right.equalTo(self.view).with.offset(-14);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(150);
        make.height.mas_offset(20);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.shareText.mas_bottom).with.offset(20);
    }];
}

#pragma mark - getters

-(UILabel *)toplab
{
    if(!_toplab)
    {
        _toplab = [[UILabel alloc] init];
        _toplab.text = @"030303";
        _toplab.font = [UIFont systemFontOfSize:12];
    }
    return _toplab;
}


-(UITextView *)shareText
{
    if(!_shareText)
    {
        _shareText = [[UITextView alloc] init];
        _shareText.delegate = self;
        _shareText.backgroundColor = [UIColor hexStringToColor:@"D8D8D8"];
    }
    return _shareText;
}



-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.backgroundColor = [UIColor hexStringToColor:@"24B664"];
        [_submitBtn setTitle:@"确认修改" forState:normal];
    }
    return _submitBtn;
}



@end
