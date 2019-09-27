//
//  EditTextViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/20.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "EditTextViewController.h"

#define kMaxLength 20

@interface EditTextViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) UIButton *sureBtn;
@end

@implementation EditTextViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"编辑文字";
    
    [self textView];
    [self placeHolderLabel];
    [self sureBtn];
    self.textView.text = self.text;
    self.placeHolderLabel.hidden = self.textView.text.length > 0;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)sureAction {
    [self.textView resignFirstResponder];
}
#pragma mark - KeyBoaryNotification
- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.textView.frame =  CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - keyboardHeight - 40);
        self.sureBtn.frame = CGRectMake(kSCREEN_WIDTH - 40, kSCREEN_HEIGHT - keyboardHeight - 40, 40, 40);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.textView.frame =  CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
        self.sureBtn.frame = CGRectMake(kSCREEN_WIDTH - 40, kSCREEN_HEIGHT, 40, 40);
    }];
   
}


#pragma mark - UItextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.placeHolderLabel.hidden = textView.text.length > 0;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.completeBlock(textView.text);
}

// 限制提示文字长度
-(void)textViewEditChanged:(NSNotification *)obj{
    UITextView *textView = (UITextView *)obj.object;
    NSString *toBeString = textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage ; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textView.text = [toBeString substringToIndex:kMaxLength];
                [self.view endEditing:YES];
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"字数长度不要超过20字哦！"];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            textView.text = [toBeString substringToIndex:kMaxLength];
            [self.view endEditing:YES];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"字数长度不要超过20字哦！"];
        }
    }
}


- (UITextView *)textView  {
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64)];
        [self.view addSubview:_textView];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:16];
        
        if (_isMoreExplain) {
            // 判断文字是否超长
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:)name:@"UITextViewTextDidChangeNotification"
                                                      object:_textView];
        }
    }
    return _textView;
}

- (UILabel *)placeHolderLabel {
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] init];
        [self.view addSubview:_placeHolderLabel];
        [_placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textView).equalTo(4);
            make.top.equalTo(self.textView).equalTo(8);
        }];
        _placeHolderLabel.text = @"请输入文字";
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        _placeHolderLabel.font = [UIFont systemFontOfSize:16];
    }
    return _placeHolderLabel;
}
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_sureBtn];
        _sureBtn.frame = CGRectMake(kSCREEN_WIDTH - 40, kSCREEN_HEIGHT, 40, 40);
        [_sureBtn setTitle:@"完成" forState:(UIControlStateNormal)];
        [_sureBtn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
@end
