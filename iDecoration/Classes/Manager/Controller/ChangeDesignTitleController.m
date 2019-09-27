//
//  ChangeDesignTitleController.m
//  iDecoration
//
//  Created by sty on 2017/8/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ChangeDesignTitleController.h"
//#import "PlaceHolderTextView.h"

@interface ChangeDesignTitleController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeHolderL;
@end

@implementation ChangeDesignTitleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"修改主标题";
    self.view.backgroundColor = White_Color;
    [self.view addSubview:self.textView];
    [self.textView addSubview:self.placeHolderL];
    self.textView.text = self.content;
    if (!self.content||self.content.length<=0) {
        self.placeHolderL.hidden = NO;
    }
    else{
        self.placeHolderL.hidden = YES;
    }
    [self.textView becomeFirstResponder];
    
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(successBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
//    self.textView.text = self.content;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidChangeText:) name:UITextViewTextDidChangeNotification object:self.textView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    // 这里统一设置键盘处理
    //    manager.toolbarDoneBarButtonItemText = @"完成";
    //    manager.toolbarTintColor = kMainThemeColor;
    manager.enable = NO;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = NO;//这个是它自带键盘工具条开关
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    // 这里统一设置键盘处理
    manager.toolbarDoneBarButtonItemText = @"完成";
    manager.toolbarTintColor = kMainThemeColor;
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = YES;//这个是它自带键盘工具条开关
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)textViewDidChangeText:(NSNotification *)notification{
    static int kMaxLenth = 30;
    UITextView *textview = (UITextView *)notification.object;
    NSString *toBeString = textview.text;
    NSString *lang = [[[UIApplication sharedApplication] textInputMode] primaryLanguage];
    
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectRange = [textview markedTextRange];
        UITextPosition *position = [textview positionFromPosition:selectRange.start offset:0];
        // 没有高亮选择的字，表明输入结束,则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length>kMaxLenth) {
                
                // 截取子串
                textview.text = [toBeString substringToIndex:kMaxLenth];
                
                [self.view endEditing:YES];
                [[PublicTool defaultTool] publicToolsHUDStr:@"不超过30个字" controller:self sleep:1.5];
                
            }
        }
        else{
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            

        }
    }
    else
    {
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > kMaxLenth) {
            
            // 截取子串
            
            textview.text = [toBeString substringToIndex:kMaxLenth];
            
            [self.view endEditing:YES];
            [[PublicTool defaultTool] publicToolsHUDStr:@"不超过30个字" controller:self sleep:1.5];
        }
    }

}

#pragma mark - action

-(void)successBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    self.content = [self.content stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (!self.content||self.content.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"内容不能为空" controller:self sleep:1.5];
        return;
    }
    
    if (self.content.length<8) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"至少输入8个文字" controller:self sleep:1.5];
        return;
    }
    
    if (self.strBlock) {
        self.strBlock(self.content);
    }
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - lazy
-(UITextView *)textView{
    if (!_textView) {
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10,64,kSCREEN_WIDTH-20,kSCREEN_HEIGHT-64)];
        //                companyNameTextView.placeHolderFont = [UIFont systemFontOfSize:16];
        
        _textView.font = NB_FONTSEIZ_BIG;
        _textView.textColor = COLOR_BLACK_CLASS_3;
        _textView.delegate = self;
    }
    return _textView;
}

-(UILabel *)placeHolderL{
    if (!_placeHolderL) {
        _placeHolderL = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, self.textView.width-3, 30)];
        _placeHolderL.text = @"标题最少输入8字符，最多不能超过30字符";
        _placeHolderL.font = NB_FONTSEIZ_BIG;
        _placeHolderL.textColor = COLOR_BLACK_CLASS_9;
    }
    return _placeHolderL;
}

#pragma mark - textviewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length<=0) {
        self.placeHolderL.hidden = NO;
    }
    else{
        self.placeHolderL.hidden = YES;
    }
    
    self.content = textView.text;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length<=0) {
        self.placeHolderL.hidden = NO;
    }
    else{
        self.placeHolderL.hidden = YES;
    }
    self.content = textView.text;
}



@end
