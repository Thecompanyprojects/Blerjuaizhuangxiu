//
//  DistriburionpromoteVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DistriburionpromoteVC.h"
#import "promoteView.h"
#import "UIView+gesture.h"

//导航栏+状态栏高度
#define NAVIGATION_HEIGHT (CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(self.navigationController.navigationBar.frame))

@interface DistriburionpromoteVC ()
@property (nonatomic,strong) UIView *bgview;
@property (nonatomic,strong) UILabel *topLab0;
@property (nonatomic,strong) UILabel *toplab1;
@property (nonatomic,strong) promoteView *shareView;
@end

@implementation DistriburionpromoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"推广方式";
    [self.view addSubview:self.bgview];
    [self.view addSubview:self.topLab0];
    [self.view addSubview:self.toplab1];
    [self.view addSubview:self.shareView];
    [self setupUI];
    [self LongPressAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupUI
{
    [self.topLab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.view).with.offset(20+NAVIGATION_HEIGHT);
    }];
    [self.toplab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.topLab0.mas_bottom).with.offset(10);
    }];
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(27*WIDTH_SCALE);
        make.right.equalTo(self.view).with.offset(-27*WIDTH_SCALE);
        make.bottom.equalTo(self.view).with.offset(-30*HEIGHT_SCALE);;
        make.top.equalTo(self.toplab1.mas_bottom).with.offset(10*HEIGHT_SCALE);;
    }];
}

#pragma mark - getters

-(UIView *)bgview
{
    if(!_bgview)
    {
        _bgview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgview.backgroundColor = [UIColor hexStringToColor:@"3D3D3D"];
    }
    return _bgview;
}

-(UILabel *)topLab0
{
    if(!_topLab0)
    {
        _topLab0 = [[UILabel alloc] init];
        _topLab0.textAlignment = NSTextAlignmentCenter;
        _topLab0.font = [UIFont systemFontOfSize:17];
        _topLab0.textColor = [UIColor whiteColor];
        NSString *textString = @"我叫分销员专属二维码";
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:textString];
        [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor hexStringToColor:@"D6232D"] range:NSMakeRange(0, 5)];

        _topLab0.attributedText = str2;
        
    
        
    }
    return _topLab0;
}

-(UILabel *)toplab1
{
    if(!_toplab1)
    {
        _toplab1 = [[UILabel alloc] init];
        _toplab1.textAlignment = NSTextAlignmentCenter;
        _toplab1.font = [UIFont systemFontOfSize:17];
        _toplab1.text = @"长安图片可直接发送给好友";
        _toplab1.textColor = [UIColor whiteColor];
        
    }
    return _toplab1;
}


-(promoteView *)shareView
{
    if(!_shareView)
    {
        _shareView = [[promoteView alloc] init];
        _shareView.codeimg.image = [UIImage imageNamed:@"qcard"];
    }
    return _shareView;
}

#pragma mark - 实现方法


/**
 长按分享
 */
-(void)LongPressAction
{
    __weak typeof (self) weakSelf = self;
    [self.shareView setLongPressActionWithBlock:^{
        
        [weakSelf snapshot:weakSelf.shareView];
        
    }];
}


#pragma mark - 截屏

- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

@end
