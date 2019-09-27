//
//  FlowersStoryViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "FlowersStoryViewController.h"
#import "PlaceHolderTextView.h"

@interface FlowersStoryViewController ()<UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelCountTF;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *labelCountTV;
@property (strong, nonatomic) NSString *type;
@property (weak, nonatomic) IBOutlet PlaceHolderTextView *textView;
@end

@implementation FlowersStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.title = @"鲜花";
    [self setupRightButton];
    self.textField.delegate = self;
    self.textView.delegate = self;
    self.textView.placeHolder = @"请编辑购买鲜花故事";
    self.textView.placeHolderColor = [UIColor hexStringToColor:@"c7c7cd"];
    [self.textField addTarget:self action:@selector(change:) forControlEvents:(UIControlEventEditingChanged)];
}

- (void)setupRightButton {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setTitle:@"完成" forState:(UIControlStateNormal)];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFixedSpace) target:nil action:nil];
    item.width = -7;
    self.navigationItem.rightBarButtonItems = @[item,rightItem];
    [rightButton addTarget:self  action:@selector(didTouchRightButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTouchRightButton {
    if (self.blockFinish) {
        self.type = @"0";
        if (self.textField.text.length && self.textView.text.length) {
            self.type = @"1";
        }
        self.blockFinish(@{@"type":self.type, @"title":self.textField.text, @"story":self.textView.text});
    }
    [self.navigationController popViewControllerAnimated:true];
}

- (void)change:(UITextField *)textField {
    self.labelCountTF.text = [NSString stringWithFormat:@"%lu/100",textField.text.length];
    if (textField.text.length >= 100) {
        [textField resignFirstResponder];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) return YES;
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 100) {
        [self.textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.labelCountTV.text = [NSString stringWithFormat:@"%lu/300",textView.text.length];
    if (textView.text.length > 300) {
        [textView setText:[textView.text substringToIndex:300]];
        [textView resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
