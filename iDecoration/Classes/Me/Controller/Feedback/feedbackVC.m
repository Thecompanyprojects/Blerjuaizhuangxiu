//
//  feedbackVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/21.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "feedbackVC.h"
#import "FeedBackApi.h"
#import <sys/utsname.h>
#import "WJGtextView.h"

@interface feedbackVC ()<UITextViewDelegate>
@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;
@property (nonatomic,strong) WJGtextView *FeedTextView;
@end

@implementation feedbackVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    [self createUI];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // _FeedTextView.frame = CGRectMake(10, kNaviBottom+20, kSCREEN_WIDTH-20, 240);

    
}

- (void)createUI {
    
    self.title = @"意见反馈";
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"提交" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    
    [self.view addSubview:self.FeedTextView];
    
    if (KIsiPhoneX) {
        [self.FeedTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(10);
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).with.offset(98);
            make.height.mas_offset(240);
        }];
    }
    else
    {
        [self.FeedTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(10);
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).with.offset(74);
            make.height.mas_offset(240);
        }];
    }
    
    UILabel *kefu = [[UILabel alloc] init];
    kefu.font = [UIFont systemFontOfSize:12];
    kefu.textAlignment = NSTextAlignmentRight;
    kefu.text = @"客服QQ:3379607351";
    kefu.textColor = [UIColor darkGrayColor];
    [self.view addSubview:kefu];
    [kefu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.FeedTextView.mas_bottom).with.offset(10);
        make.height.mas_offset(16);
        make.right.equalTo(self.view).with.offset(-10);
        make.centerX.equalTo(self.view);
    }];
}

-(WJGtextView *)FeedTextView
{
    if(!_FeedTextView)
    {
        _FeedTextView = [[WJGtextView alloc] init];
        _FeedTextView.delegate = self;
        _FeedTextView.numberlabel.text = @"0/150";
        _FeedTextView.backgroundColor = [UIColor whiteColor];

        _FeedTextView.customPlaceholder = @"输入您宝贵的意见";
        _FeedTextView.customPlaceholderColor = [UIColor hexStringToColor:@"C7C7CD"];
    }
    return _FeedTextView;
}



- (void)textViewDidChange:(UITextView *)textView {

    if ([textView.text length] > 150) {
        
        textView.text = [textView.text substringToIndex:150];
        [textView resignFirstResponder];
        [self.view hudShowWithText:@"字数长度不要超过150字哦！"];
        
    } else {
        
        NSString *textContent = textView.text;
        NSUInteger existText = textContent.length;
        
        self.FeedTextView.numberlabel.text = [NSString stringWithFormat:@"%ld/150",existText];
    }
}

//提交按钮
- (void)submit:(UIBarButtonItem*)sender {
    
    if (self.FeedTextView.text.length == 0) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"请填写反馈内容" controller:self sleep:1.0];
        
        return;
    }
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    //    FeedBackApi *feedApi = [[FeedBackApi alloc]initWithPhone:user.phone content:self.FeedTextView.text trueName:user.trueName];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *phoneModel = [self iphoneType];
    NSString *source = [NSString stringWithFormat:@"iOS-%@-%@", appVersion, phoneModel];
    
    FeedBackApi *feedApi = [[FeedBackApi alloc] initWithPhone:user.phone content:self.FeedTextView.text trueName:user.trueName source:source];
    
    [feedApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSInteger code = [[request.responseJSONObject objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"反馈成功"];
            self.FeedTextView.text = nil;
            [self popBack];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}

- (NSString *)iphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}

- (void)popBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//销毁
- (void)dealloc {
    
    self.returnKeyHandler = nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}




@end
