//
//  AddLinkController.m
//  iDecoration
//
//  Created by sty on 2017/9/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "AddLinkController.h"
#import "PlaceHolderTextView.h"

@interface AddLinkController ()<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UILabel *addressL;
@property (nonatomic, strong) UITextField *addressTextF;
@property (nonatomic, strong) UIView *lineVOne;

@property (nonatomic, strong) UILabel *describL;
@property (nonatomic, strong) UITextField *describTextF;
@property (nonatomic, strong) UIView *lineVTwo;

@property (nonatomic, strong) UIButton *contructBtn;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic ,strong) UIButton *deleteBtn;
@end

@implementation AddLinkController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加链接";
    self.view.backgroundColor = White_Color;
    [self creatUI];
    self.myContructLink = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"resources/html/shigongrizhi1.jsp?constructionId=%ld", (long)self.consID]];
    
    
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"删除" forState:UIControlStateNormal];
    [editBtn setTitleColor:White_Color forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    self.deleteBtn = editBtn;
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.deleteBtn];
    
    if (!self.linkAddress||self.linkAddress.length<=0) {
        self.deleteBtn.hidden = YES;
    }
    else{
        self.deleteBtn.hidden = NO;
    }
}

-(void)creatUI{
    [self.view addSubview:self.addressL];
    [self.view addSubview:self.addressTextF];
    [self.view addSubview:self.lineVOne];

    [self.view addSubview:self.addBtn];
    
    
}

#pragma mark - action

-(void)addLinkClick:(UIButton *)btn{
    [self.view endEditing:YES];
    self.linkAddress = [self.linkAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.linkAddress.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"链接地址不能为空" controller:self sleep:1.5];
        return;
    }
    
    //BOOL isRight = [self.linkAddress ew_isUrlString];
    if (![self.linkAddress ew_isUrlString]) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"网址请以http://或https://开头" controller:self sleep:1.5];
        return;
    }
    
    if (self.addLinkBlock) {
        self.addLinkBlock(self.linkAddress, self.linkDescrib);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)linkMyContruct:(UIButton *)btn{
    self.linkAddress = self.myContructLink;
    self.addressTextF.text = self.linkAddress;
}

-(void)deleteBtnClick:(UIButton *)btn{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要删除链接吗？"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = 100;
    [alertView show];
}

#pragma mark - alertDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            self.linkAddress = @"";
            self.linkDescrib = @"";
            
            if (self.addLinkBlock) {
                self.addLinkBlock(self.linkAddress, self.linkDescrib);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - textFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==1) {
        self.linkAddress = textField.text;
    }
    if (textField.tag==2) {
        self.linkDescrib = textField.text;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag==1) {
        self.linkAddress = textField.text;
    }
    if (textField.tag==2) {
        self.linkDescrib = textField.text;
    }
    return YES;
}


#pragma mark - lazy

-(UILabel *)addressL{
    if (!_addressL) {
        _addressL = [[UILabel alloc]initWithFrame:CGRectMake(20, kNaviBottom+16, 80, 30)];
        _addressL.text = @"链接地址";
        _addressL.textColor = COLOR_BLACK_CLASS_3;
        _addressL.font = NB_FONTSEIZ_BIG;
    }
    return _addressL;
}

-(UITextField *)addressTextF{
    if (!_addressTextF) {
        
        _addressTextF = [[UITextField alloc] initWithFrame:CGRectMake(self.addressL.right+10,self.addressL.top,kSCREEN_WIDTH-self.addressL.right-10-25,self.addressL.height)];
        _addressTextF.placeholder = @"网址请以http://或https://开头";
        
        _addressTextF.font = NB_FONTSEIZ_BIG;
        _addressTextF.textColor = COLOR_BLACK_CLASS_3;
        
        _addressTextF.tag = 1;
        _addressTextF.text = self.linkAddress;

        [_addressTextF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
        [_addressTextF setValue:NB_FONTSEIZ_BIG forKeyPath:@"_placeholderLabel.font"];

        _addressTextF.delegate = self;
    }
    return _addressTextF;
}

-(UIView *)lineVOne{
    if (!_lineVOne) {
        _lineVOne = [[UIView alloc]initWithFrame:CGRectMake(15, self.addressL.bottom+5, kSCREEN_WIDTH-30, 1)];
        _lineVOne.backgroundColor = COLOR_BLACK_CLASS_0;
        
    }
    return _lineVOne;
}

-(UILabel *)describL{
    if (!_describL) {
        _describL = [[UILabel alloc]initWithFrame:CGRectMake(self.addressL.left, self.lineVOne.bottom+10, self.addressL.width, self.addressL.height)];
        _describL.text = @"链接描述";
        _describL.textColor = COLOR_BLACK_CLASS_3;
        _describL.font = NB_FONTSEIZ_BIG;
    }
    return _describL;
}

-(UITextField *)describTextF{
    if (!_describTextF) {
        
        _describTextF = [[UITextField alloc] initWithFrame:CGRectMake(self.describL.right+10,self.describL.top,kSCREEN_WIDTH-self.describL.right-10-25,self.describL.height)];
        _describTextF.placeholder = @"输入链接的文字描述";
        
        _describTextF.font = NB_FONTSEIZ_BIG;
        _describTextF.textColor = COLOR_BLACK_CLASS_3;
        _describTextF.tag = 2;
        
        _describTextF.text = self.linkDescrib;
        [_describTextF setValue:COLOR_BLACK_CLASS_9 forKeyPath:@"_placeholderLabel.textColor"];
        [_describTextF setValue:NB_FONTSEIZ_BIG forKeyPath:@"_placeholderLabel.font"];
        
        _describTextF.delegate = self;
    }
    return _describTextF;
}

-(UIView *)lineVTwo{
    if (!_lineVTwo) {
        _lineVTwo = [[UIView alloc]initWithFrame:CGRectMake(self.lineVOne.left, self.describL.bottom+5, kSCREEN_WIDTH-30, 1)];
        _lineVTwo.backgroundColor = COLOR_BLACK_CLASS_0;
        
    }
    return _lineVTwo;
}

-(UIButton *)contructBtn{
    if (!_contructBtn) {
        _contructBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _contructBtn.frame = CGRectMake(kSCREEN_WIDTH/2-100,self.lineVTwo.bottom+20,200,30);
        [_contructBtn setTitle:@"链接到我的工地" forState:UIControlStateNormal];
        [_contructBtn setTitleColor:Main_Color forState:UIControlStateNormal];
        _contructBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        _contructBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_contructBtn addTarget:self action:@selector(linkMyContruct:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _contructBtn;
}

-(UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _addBtn.frame = CGRectMake(self.lineVTwo.left,self.contructBtn.bottom+20,self.lineVTwo.width,40);
        _addBtn.frame = CGRectMake(self.addressL.left,self.addressL.bottom+40,self.lineVOne.width,50);
        [_addBtn setTitle:@"添 加" forState:UIControlStateNormal];
        [_addBtn setTitleColor:White_Color forState:UIControlStateNormal];
        _addBtn.backgroundColor = Main_Color;
        _addBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        _addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _addBtn.layer.masksToBounds = YES;
        _addBtn.layer.cornerRadius = 5;
        
        [_addBtn addTarget:self action:@selector(addLinkClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

@end
