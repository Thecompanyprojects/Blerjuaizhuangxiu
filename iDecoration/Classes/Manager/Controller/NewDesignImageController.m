//
//  NewDesignImageController.m
//  iDecoration
//
//  Created by Apple on 2017/7/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "NewDesignImageController.h"
#import "HRColorUtil.h"

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "AddLinkController.h"
#import "EditMuchUseController.h"
#import "MuchUseModel.h"

#define toolbarHolderHeight 75

@interface UIWebView (HackishAccessoryHiding)
    @property (nonatomic, assign) BOOL hidesInputAccessoryView;
    @end

@implementation UIWebView (HackishAccessoryHiding)
    
    static const char * const hackishFixClassName = "UIWebBrowserViewMinusAccessoryView";
    static Class hackishFixClass = Nil;
    
- (UIView *)hackishlyFoundBrowserView {
    UIScrollView *scrollView = self.scrollView;
    
    UIView *browserView = nil;
    for (UIView *subview in scrollView.subviews) {
        if ([NSStringFromClass([subview class]) hasPrefix:@"UIWebBrowserView"]) {
            browserView = subview;
            break;
        }
    }
    return browserView;
}
    
- (id)methodReturningNil {
    return nil;
}
    
- (void)ensureHackishSubclassExistsOfBrowserViewClass:(Class)browserViewClass {
    if (!hackishFixClass) {
        Class newClass = objc_allocateClassPair(browserViewClass, hackishFixClassName, 0);
        newClass = objc_allocateClassPair(browserViewClass, hackishFixClassName, 0);
        IMP nilImp = [self methodForSelector:@selector(methodReturningNil)];
        class_addMethod(newClass, @selector(inputAccessoryView), nilImp, "@@:");
        objc_registerClassPair(newClass);
        
        hackishFixClass = newClass;
    }
}
    
- (BOOL) hidesInputAccessoryView {
    UIView *browserView = [self hackishlyFoundBrowserView];
    return [browserView class] == hackishFixClass;
}
    
- (void) setHidesInputAccessoryView:(BOOL)value {
    UIView *browserView = [self hackishlyFoundBrowserView];
    if (browserView == nil) {
        return;
    }
    [self ensureHackishSubclassExistsOfBrowserViewClass:[browserView class]];
    
    if (value) {
        object_setClass(browserView, hackishFixClass);
    }
    else {
        Class normalClass = objc_getClass("UIWebBrowserView");
        object_setClass(browserView, normalClass);
    }
    [browserView reloadInputViews];
}
    
@end

@interface NewDesignImageController ()<UIWebViewDelegate,UITextViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate,MPMediaPickerControllerDelegate,UIAlertViewDelegate>{
    CGFloat textviewH;
    CGFloat keyBoardH;
    BOOL keyBoardIsPop;//键盘是否弹出
    BOOL textTypeIsPop;//字体样式选择框是否弹出
    BOOL textSizeIsPop;//字体大小选择框是否弹出
    BOOL textAlignmentIsPop;//居中选择框是否弹出
    BOOL colorIsPop;//颜色选择框是否弹出
    
    BOOL isBold;//加粗
    BOOL isTilt;//斜线
    BOOL isUnderLine;//下划线
    NSInteger textSizeTag;//1:small 2:nor 3:big  默认：2
    NSInteger textAlignmentTag; //1:left  2:mid  3:right 默认：1
    
    NSInteger colorTag;// 1:black  2:gray 3:red 4:（255，136，47） 5:green 6:blue 7:(181,80,181)
    NSInteger clickTag;// 1:type 2:size 3:Alignment
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UITextView *sourceView;
@property (nonatomic, strong) UIView *toolbarHolder;

@property (nonatomic, strong) UIButton *selectAllBtn;//全选
@property (nonatomic, strong) UIView *addLinkV;//添加链接
@property (nonatomic, strong) UIButton *muchUseBtn;//常用语
@property (nonatomic, strong) UIImageView *linkImgV;
@property (nonatomic, strong) UILabel *linkLabel;

@property (nonatomic, strong) UIView *lineV;//
@property (nonatomic, strong) UIButton *revokeBtn;//撤销
@property (nonatomic, strong) UIButton *advanceBtn;//前进
@property (nonatomic, strong) UIButton *boldBtn;//粗体，斜体，下划线
@property (nonatomic, strong) UIButton *fontBtn;//字体
@property (nonatomic, strong) UIButton *typesetBtn;//居中，左，右
@property (nonatomic, strong) UIButton *colorBtn;//颜色
@property (nonatomic, strong) UIButton *keyBoadDismissBtn;//键盘消失

@property (nonatomic, strong) UIView *popView;//
@property (nonatomic, strong) UIView *colorPopView;
@property (nonatomic, strong) UIView *muchUseView;//常用语的view

@property (nonatomic, strong) UIButton *moreBoldBtn;//粗体
@property (nonatomic, strong) UIButton *moreItalicBtn;//斜体
@property (nonatomic, strong) UIButton *moreUnderlineBtn;//下划线

@property (nonatomic, strong) UIButton *smallSizeBtn;//small
@property (nonatomic, strong) UIButton *norSizeBtn;//nor
@property (nonatomic, strong) UIButton *bigSizeBtn;//big

@property (nonatomic, strong) UIButton *leftBtn;//left
@property (nonatomic, strong) UIButton *midBtn;//mid
@property (nonatomic, strong) UIButton *rightBtn;//right
@property (nonatomic, strong) NSMutableArray *muchUseArray;
@property (nonatomic, copy) NSString *html;


@end

@implementation NewDesignImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.fromTag==1) {
        self.title = @"本案设计";
    }
    else if (self.fromTag == 4 || self.fromTag ==3){
        self.title = @"编辑文字";
    }
    else{
        self.title = @"编辑活动";
    }
    
    [self requestMuchUseData];
    [self setUI];
    self.muchUseArray = [NSMutableArray array];
    
    textSizeTag = 2;
    textAlignmentTag = 1;
    colorTag = 1;
    
    [self refreshLinkVStatus];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
}


-(void)setUI{

    [self.view addSubview:self.webView];
    [self.view addSubview:self.toolbarHolder];
    
    [self.toolbarHolder addSubview:self.selectAllBtn];
    [self.toolbarHolder addSubview:self.muchUseBtn];
    
    [self.toolbarHolder addSubview:self.addLinkV];
    
    if(!self.nodeImgStr||self.nodeImgStr.length<=0){
       //隐藏链接
        self.addLinkV.hidden = YES;
    }else{
        self.addLinkV.hidden = NO;
    }
    
    [self.toolbarHolder addSubview:self.lineV];
    
    [self.toolbarHolder addSubview:self.boldBtn];
    [self.toolbarHolder addSubview:self.fontBtn];
    [self.toolbarHolder addSubview:self.typesetBtn];
    [self.toolbarHolder addSubview:self.colorBtn];
    [self.toolbarHolder addSubview:self.keyBoadDismissBtn];

    
    NSURL* url = [NSURL URLWithString:@"http://www.baidu.com"];//创建URL

    if (self.editOrAdd == 2) {
        self.html = @"";
    }
    else if (self.editOrAdd == 1) {
        if (self.isDesignCaseListModel) {
           self.html = self.model.htmlContent;
        }else{
         self.html = self.artDesignModel.htmlContent;
        }
    }
    else{
        self.html = @"";
    }
    NSString *html = self.html;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"editor" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    NSString *source = [[NSBundle mainBundle] pathForResource:@"ZSSRichTextEditor" ofType:@"js"];
    NSString *jsString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:source] encoding:NSUTF8StringEncoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!--editor-->" withString:jsString];
    if ([self.html  isEqual:@""] || self.html ==nil) {
        
    }else{
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!--content-->" withString:html];
    }
    [self.webView loadHTMLString:htmlString baseURL:url];
    
    [self setRightItembtn];
    
    
    
}

#pragma mark - 请求常用语接口

-(void)requestMuchUseData{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"commonLanguage/getList.do"];
    
    
    NSDictionary *paramDic = @{@"agencysId":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                NSArray *caseArr = [[responseObj objectForKey:@"data"]objectForKey:@"list"];
                
                NSArray *arr = [NSArray yy_modelArrayWithClass:[MuchUseModel class] json:caseArr];
                [self.muchUseArray removeAllObjects];
                [self.muchUseArray addObjectsFromArray:arr];
            }
            else if (statusCode==1001){
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:1.5];
            }
            else if (statusCode==1002){
//                [[PublicTool defaultTool] publicToolsHUDStr:@"数据为空" controller:self sleep:1.5];
            }
            else if (statusCode==2000){
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 刷新链接按钮的状态
-(void)refreshLinkVStatus{
    if (!self.linkAddress||self.linkAddress.length<=0) {
        //没有链接
        self.addLinkV.frame = CGRectMake(kSCREEN_WIDTH-90, self.selectAllBtn.top, 80, self.selectAllBtn.height);
        self.linkImgV.frame = CGRectMake(7, _addLinkV.height/2-12/2, 12, 12);
        self.linkLabel.frame = CGRectMake(self.linkImgV.right, 0, _addLinkV.width-self.linkImgV.right, _addLinkV.height);
        self.linkLabel.text = @"添加链接";
    }
    
    else{
        if (!self.linkDescrib||self.linkDescrib.length<=0) {
            CGSize size = [self.linkAddress boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH/2-50, 20) withFont:NB_FONTSEIZ_SMALL];
            
            self.addLinkV.frame = CGRectMake(kSCREEN_WIDTH-12-size.width-20, self.selectAllBtn.top, 12+size.width+20, self.selectAllBtn.height);
            
            self.linkImgV.frame = CGRectMake(7, _addLinkV.height/2-12/2, 12, 12);
            
            self.linkLabel.frame = CGRectMake(self.linkImgV.right, 0, _addLinkV.width-self.linkImgV.right, _addLinkV.height);
            self.linkLabel.text = self.linkAddress;
        }
        else{
            CGSize size = [self.linkDescrib boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH/2, 20) withFont:NB_FONTSEIZ_SMALL];
            
            self.addLinkV.frame = CGRectMake(kSCREEN_WIDTH-12-size.width-20 - 10, self.selectAllBtn.top, 12+size.width+20, self.selectAllBtn.height);
            
            self.linkImgV.frame = CGRectMake(7, _addLinkV.height/2-12/2, 12, 12);
            
            self.linkLabel.frame = CGRectMake(self.linkImgV.right, 0, _addLinkV.width-self.linkImgV.right, _addLinkV.height);
            self.linkLabel.text = self.linkDescrib;
        }
    }
}
    
-(void)setRightItembtn{
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(success:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
}
    
-(void)success:(UIButton *)sender{
    NSString *htmlStr = [self getHTML];
    NSString *textStr = [self getText];
//    textStr = [textStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    textStr = [textStr ew_removeSpaces];
    NSString *temRow = [NSString stringWithFormat:@"%ld",self.row];
    if (self.fromTag==1) {
        if (self.editOrAdd==2) {
            if (textStr.length<=0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:textStr,@"textStr",htmlStr,@"htmlStr",temRow,@"row",self.linkAddress,@"link",self.linkDescrib,@"linkDescribe", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addTextDesign" object:nil userInfo:dict];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
        else if (self.editOrAdd == 1) {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:textStr,@"textStr",htmlStr,@"htmlStr",temRow,@"row",self.linkAddress,@"link",self.linkDescrib,@"linkDescribe", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"editTextDesign" object:nil userInfo:dict];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            if (textStr.length<=0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:textStr,@"textStr",htmlStr,@"htmlStr", self.linkAddress,@"link",self.linkDescrib,@"linkDescribe",nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addTextToBottomDesign" object:nil userInfo:dict];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    }
    else{
        if (self.editOrAdd==2) {
            if (textStr.length<=0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:textStr,@"textStr",htmlStr,@"htmlStr",temRow,@"row",self.linkAddress,@"link",self.linkDescrib,@"linkDescribe", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityaddTextDesign" object:nil userInfo:dict];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
        else if (self.editOrAdd == 1) {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:textStr,@"textStr",htmlStr,@"htmlStr",temRow,@"row",self.linkAddress,@"link",self.linkDescrib,@"linkDescribe", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityeditTextDesign" object:nil userInfo:dict];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            if (textStr.length<=0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:textStr,@"textStr",htmlStr,@"htmlStr", self.linkAddress,@"link",self.linkDescrib,@"linkDescribe",nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivityaddTextToBottomDesign" object:nil userInfo:dict];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    }
    
}
    


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
   
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    // 这里统一设置键盘处理
    //    manager.toolbarDoneBarButtonItemText = @"完成";
    //    manager.toolbarTintColor = kMainThemeColor;
    manager.enable = NO;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.shouldResignOnTouchOutside = NO;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = NO;//这个是它自带键盘工具条开关
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self getFoucs];
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}



#pragma mark - Keyboard status

- (void)keyboardWillShowOrHide:(NSNotification *)notification {
    
    // Orientation
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // User Info
    NSDictionary *info = notification.userInfo;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    int curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGRect keyboardEnd = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // Toolbar Sizes
    CGFloat sizeOfToolbar = self.toolbarHolder.frame.size.height;
    
    // Keyboard Size
    CGFloat keyboardHeight = UIInterfaceOrientationIsLandscape(orientation) ? keyboardEnd.size.width : keyboardEnd.size.height;
    keyBoardH = keyboardHeight;
    // Correct Curve
    UIViewAnimationOptions animationOptions = curve << 16;
    
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        
        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
            
            
            
            
            // Toolbar
            CGRect frame = self.toolbarHolder.frame;
            frame.origin.y = self.view.frame.size.height - (keyboardHeight + sizeOfToolbar);
            self.toolbarHolder.frame = frame;
            
            //scroll
            CGRect scrllFrame = self.scrollView.frame;
            scrllFrame.size.height = (self.view.frame.size.height - keyboardHeight) - sizeOfToolbar-64;
            self.scrollView.frame = scrllFrame;
            
            //webview
            
            CGRect webFrame = self.webView.frame;
            webFrame.size.height = (self.view.frame.size.height - keyboardHeight) - sizeOfToolbar-64;
            self.webView.frame = scrllFrame;

//            // Source View
            CGRect sourceFrame = self.sourceView.frame;
            sourceFrame.size.height = textviewH;
            self.sourceView.frame = sourceFrame;
            
        } completion:nil];
        
    } else {
        
        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
            
            self.scrollView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64-toolbarHolderHeight);
            self.sourceView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.scrollView.height);
            self.webView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64-toolbarHolderHeight);
            self.toolbarHolder.frame = CGRectMake(0, kSCREEN_HEIGHT-toolbarHolderHeight, kSCREEN_WIDTH, toolbarHolderHeight);

            
        } completion:nil];
        
    }
    
}

#pragma mark - UITextViewDelegate


#pragma mark - alertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==200) {
        if (buttonIndex==1) {
            [self.webView stringByEvaluatingJavaScriptFromString:@"document.activeElement.blur()"];
            
            [self.view endEditing:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        
    }
}



#pragma mark - action

-(void)back{
//    [self keyBoadDismissBtnClick:nil];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否退出编辑？"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = 200;
    
    [alertView show];
    
}

-(void)keyBoadDismissBtnClick:(UIButton *)sender{
//    if (keyBoardIsPop) {
//        [self.sourceView resignFirstResponder];
//    }
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.activeElement.blur()"];
    [self.sourceView resignFirstResponder];
    [self.view endEditing:YES];
    
    
    [self stylePopDismss];
    [self sizePopDismss];
    [self alignPopDismss];
    [self colorPopDismss];
    textTypeIsPop = NO;
    textSizeIsPop = NO;
    textAlignmentIsPop = NO;
    self.popView.hidden = YES;
    self.colorPopView.hidden = YES;
    
    self.selectAllBtn.hidden = NO;
    self.muchUseBtn.hidden = NO;
    self.addLinkV.hidden = NO;
    
    self.muchUseView.hidden = YES;
    
}

-(void)boldBtnClick:(UIButton *)sender{

    [self getFoucs];
    self.muchUseView.hidden = YES;
    textTypeIsPop = !textTypeIsPop;
    if (textTypeIsPop) {
        textSizeIsPop = NO;
        textAlignmentIsPop = NO;
        [self sizePopDismss];
        [self alignPopDismss];
        [self creatPopviewWithTag:1];
    }
    else{
        self.popView.hidden = YES;
        [self stylePopDismss];
        [self sizePopDismss];
        [self alignPopDismss];
        
        self.selectAllBtn.hidden = NO;
        self.muchUseBtn.hidden = NO;
        self.addLinkV.hidden = NO;
    }
    
}

-(void)sizeBtnClick:(UIButton *)sender{

    [self getFoucs];
    self.muchUseView.hidden = YES;
    textSizeIsPop = !textSizeIsPop;
    if (textSizeIsPop) {
        textTypeIsPop = NO;
        textAlignmentIsPop = NO;
        [self stylePopDismss];
        [self alignPopDismss];
        [self creatPopviewWithTag:2];
    }
    else{
        self.popView.hidden = YES;
        [self stylePopDismss];
        [self sizePopDismss];
        [self alignPopDismss];
        
        self.selectAllBtn.hidden = NO;
        self.muchUseBtn.hidden = NO;
        self.addLinkV.hidden = NO;
    }
}

-(void)alignmentBtnClick:(UIButton *)sender{

    [self getFoucs];
    self.muchUseView.hidden = YES;
    textAlignmentIsPop = !textAlignmentIsPop;
    if (textAlignmentIsPop) {
        textTypeIsPop = NO;
        textSizeIsPop = NO;
        [self stylePopDismss];
        [self sizePopDismss];
        [self creatPopviewWithTag:3];
    }
    else{
        self.popView.hidden = YES;
        [self stylePopDismss];
        [self sizePopDismss];
        [self alignPopDismss];
        
        self.selectAllBtn.hidden = NO;
        self.muchUseBtn.hidden = NO;
        self.addLinkV.hidden = NO;
    }
}

-(void)colorBtnClick:(UIButton *)sender{

    [self getFoucs];
    self.muchUseView.hidden = YES;
    colorIsPop = !colorIsPop;
    [self creatColorPopView];
}

#pragma mark - muchUseView

-(void)muchUseBtnClick:(UIButton *)btn{
    if (!_muchUseView) {
        _muchUseView = [[UIView alloc]initWithFrame:CGRectMake(10, 100, kSCREEN_WIDTH/4*3, kSCREEN_HEIGHT-keyBoardH-100-46-5-40)];
        _muchUseView.backgroundColor = White_Color;
                _muchUseView.layer.masksToBounds = YES;
                _muchUseView.layer.cornerRadius = 5;
                _muchUseView.layer.borderColor = COLOR_BLACK_CLASS_0.CGColor;
                _muchUseView.layer.borderWidth = 1.0f;
        [self.view addSubview:self.muchUseView];
        self.muchUseView.hidden=YES;
    }
    if (self.muchUseView.hidden==YES) {
        self.muchUseView.hidden = NO;
        if (!keyBoardIsPop) {
            [self getFoucs];
        }
        
        [self.muchUseView removeAllSubViews];

        
        UILabel *lab0 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.muchUseView.width/2-30-40, 40)];
        lab0.text = @"常用语";
      
        lab0.font = [UIFont systemFontOfSize:11];
        lab0.textColor = [UIColor blackColor];
        [self.muchUseView addSubview:lab0];
        
        
        
        
        UIButton *muchUseB = [UIButton buttonWithType:UIButtonTypeCustom];
        muchUseB.frame = CGRectMake(self.muchUseView.width-30, 5, 30, 30);
        [muchUseB setImage:[UIImage imageNamed:@"edit_muchUse"] forState:UIControlStateNormal];
      
        [muchUseB addTarget:self action:@selector(gomuchUseVC) forControlEvents:UIControlEventTouchUpInside];
        [self.muchUseView addSubview:muchUseB];
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, lab0.bottom, self.muchUseView.width, 1)];
        lineV.backgroundColor = COLOR_BLACK_CLASS_0;
        [self.muchUseView addSubview:lineV];
        if (self.muchUseArray.count<=0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"暂无常用语" controller:self sleep:1.5];
        }
        else{
            UIScrollView *muchUseScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, lineV.bottom, self.muchUseView.width, self.muchUseView.height-lineV.height)];
            [self.muchUseView addSubview:muchUseScrollV];
            CGFloat labelTop = 0;
            for (int i=0; i<self.muchUseArray.count; i++) {
                
                UIButton *labelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                labelBtn.frame = CGRectMake(15, labelTop, muchUseScrollV.width-15-5, 40);
                MuchUseModel *model = self.muchUseArray[i];
                [labelBtn setTitle:model.content forState:UIControlStateNormal];
                [labelBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                labelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                labelBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                labelBtn.tag = i;
                [labelBtn addTarget:self action:@selector(pasteMuchUse:) forControlEvents:UIControlEventTouchUpInside];
                UIView *lineTemp = [[UIView alloc]initWithFrame:CGRectMake(15, labelBtn.bottom, muchUseScrollV.width, 1)];
                lineTemp.backgroundColor = COLOR_BLACK_CLASS_0;
                
                [muchUseScrollV addSubview:labelBtn];
                [muchUseScrollV addSubview:lineTemp];
                labelTop = labelTop+labelBtn.height+1;
                
            }
            
            muchUseScrollV.contentSize = CGSizeMake(muchUseScrollV.width, labelTop+41);
        }
        
        
        
    }
    else{
        self.muchUseView.hidden = YES;
    }
    
}

-(void)gomuchUseVC{
    EditMuchUseController *vc = [[EditMuchUseController alloc]init];
    self.muchUseView.hidden = YES;
    vc.muchUseArray = self.muchUseArray;
    vc.keyBoardH = keyBoardH;
    vc.type = self.type;
    
    vc.companyId = self.companyId;
    vc.upLoadMuchUseBlock = ^(NSInteger updateType) {
        if (updateType) {
            [self requestMuchUseData];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - colorPopView

-(void)creatColorPopView{
    if (!_colorPopView) {
        _colorPopView = [[UIView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-220-7, kSCREEN_HEIGHT-keyBoardH-46-5-40, 220, 40)];
        _colorPopView.backgroundColor = White_Color;
        [self.view addSubview:self.colorPopView];
    }
    if (colorIsPop==YES) {
        [self stylePopDismss];
        [self sizePopDismss];
        [self alignPopDismss];
        
        textTypeIsPop = NO;
        textSizeIsPop = NO;
        textAlignmentIsPop = NO;
        
        self.popView.hidden = YES;
        
        self.selectAllBtn.hidden = YES;
        self.muchUseBtn.hidden = YES;
        self.addLinkV.hidden = YES;
        
        self.colorPopView.hidden = NO;
        
        [self.colorPopView removeAllSubViews];
        _colorPopView.frame = CGRectMake(kSCREEN_WIDTH-220-7, kSCREEN_HEIGHT-keyBoardH-46-5-40, 220, 40);
        CGFloat leftX = 0;
        for (int i = 0; i<7; i++) {
            //        UIImageView *btn = [[UIImageView alloc]init];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            // 1:black  2:gray 3:red 4:（255，136，47） 5:green 6:blue 7:(181,80,181)
            if (i==0) {
                [btn setImage:[UIImage imageNamed:@"text_editor_color_1"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"text_editor_color_1_press"] forState:UIControlStateHighlighted];
                btn.frame = CGRectMake(leftX, 0, 40, self.colorPopView.height);
            }
            else if (i==1){
                [btn setImage:[UIImage imageNamed:@"text_editor_color_2"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"text_editor_color_2_press"] forState:UIControlStateHighlighted];
                btn.frame = CGRectMake(leftX, 0, 28, self.colorPopView.height);
            }
            else if (i==2){
                [btn setImage:[UIImage imageNamed:@"text_editor_color_3"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"text_editor_color_3_press"] forState:UIControlStateHighlighted];
                btn.frame = CGRectMake(leftX, 0, 28, self.colorPopView.height);
            }
            else if (i==3){
                [btn setImage:[UIImage imageNamed:@"text_editor_color_4"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"text_editor_color_4_press"] forState:UIControlStateHighlighted];
                btn.frame = CGRectMake(leftX, 0, 28, self.colorPopView.height);
            }
            else if (i==4){
                [btn setImage:[UIImage imageNamed:@"text_editor_color_5"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"text_editor_color_5_press"] forState:UIControlStateHighlighted];
                btn.frame = CGRectMake(leftX, 0, 28, self.colorPopView.height);
            }
            else if (i==5){
                [btn setImage:[UIImage imageNamed:@"text_editor_color_6"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"text_editor_color_6_press"] forState:UIControlStateHighlighted];
                btn.frame = CGRectMake(leftX, 0, 28, self.colorPopView.height);
            }
            else {
                [btn setImage:[UIImage imageNamed:@"text_editor_color_7"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"text_editor_color_7_press"] forState:UIControlStateHighlighted];
                btn.frame = CGRectMake(leftX, 0, 40, self.colorPopView.height);
            }
            
            leftX = leftX+btn.width;
            btn.tag = i+1;
            [btn addTarget:self action:@selector(subColorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.colorPopView addSubview:btn];
        }
    }
    else{
        self.selectAllBtn.hidden = NO;
        self.muchUseBtn.hidden = NO;
        self.addLinkV.hidden = NO;
        
        self.colorPopView.hidden = YES;
    }
    
}


-(void)creatPopviewWithTag:(NSInteger)tag{
    
    //1:style  2:size  3:agiment 4:color
    if (!_popView) {
        _popView = [[UIView alloc]init];
        [self.view addSubview:_popView];
        _popView.userInteractionEnabled = YES;
    }
    [_popView removeAllSubViews];
    _popView.hidden = NO;
    if (textTypeIsPop||textSizeIsPop||textAlignmentIsPop||colorIsPop) {
        self.selectAllBtn.hidden = YES;
        self.muchUseBtn.hidden = YES;
        self.addLinkV.hidden = YES;
    }
    else{
        self.selectAllBtn.hidden = NO;
        self.muchUseBtn.hidden = NO;
        self.addLinkV.hidden = NO;
    }
    self.colorPopView.hidden = YES;
    [self colorPopDismss];
    if (tag==1) {
//        [self sizePopDismss];
//        [self alignPopDismss];
//        
//        clickTag = 1;
        if (!_moreBoldBtn) {
            _moreBoldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
        }
        if (!_moreItalicBtn) {
            _moreItalicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
        }
        if (!_moreUnderlineBtn) {
            _moreUnderlineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
        }
        
        _popView.frame = CGRectMake(20, kSCREEN_HEIGHT-keyBoardH-46-40-10, 150, 40);
        _popView.backgroundColor = White_Color;
        _popView.centerX = self.boldBtn.centerX;
        _popView.layer.masksToBounds = YES;
        
        _moreBoldBtn.frame = CGRectMake(0, 0, _popView.width/3, _popView.height);
        _moreItalicBtn.frame = CGRectMake((_popView.width/3), 0, _popView.width/3, _popView.height);
        _moreUnderlineBtn.frame = CGRectMake((_popView.width/3)*2, 0, _popView.width/3, _popView.height);
        [self.popView addSubview:self.moreBoldBtn];
        [self.popView addSubview:self.moreItalicBtn];
        [self.popView addSubview:self.moreUnderlineBtn];
        [self.moreBoldBtn addTarget:self action:@selector(setBold) forControlEvents:UIControlEventTouchUpInside];
        
        [self.moreItalicBtn addTarget:self action:@selector(setItalic) forControlEvents:UIControlEventTouchUpInside];
        
        [self.moreUnderlineBtn addTarget:self action:@selector(setUnderline) forControlEvents:UIControlEventTouchUpInside];
        

        if (textTypeIsPop) {
            _popView.hidden = NO;
            
            
            if (isBold) {
                [self.moreBoldBtn setImage:[UIImage imageNamed:@"text_editor_b_enable"] forState:UIControlStateNormal];
            }
            else{
                [self.moreBoldBtn setImage:[UIImage imageNamed:@"text_editor_b"] forState:UIControlStateNormal];
            }
            
            
            if (isTilt) {
                [self.moreItalicBtn setImage:[UIImage imageNamed:@"text_editor_i_enable"] forState:UIControlStateNormal];
            }
            else{
                [self.moreItalicBtn setImage:[UIImage imageNamed:@"text_editor_i"] forState:UIControlStateNormal];
            }
            
            
            if (isUnderLine) {
                [self.moreUnderlineBtn setImage:[UIImage imageNamed:@"text_editor_u_enable"] forState:UIControlStateNormal];
            }
            else{
                [self.moreUnderlineBtn setImage:[UIImage imageNamed:@"text_editor_u"] forState:UIControlStateNormal];
            }
            
            
            if (isBold) {
                if (isTilt) {
                    if (isUnderLine) {
                        [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_italic_underline_press"] forState:UIControlStateNormal];
                    }
                    else{
                        [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_italic_press"] forState:UIControlStateNormal];
                    }
                }
                else{
                    if (isUnderLine) {
                        [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_underline_press"] forState:UIControlStateNormal];
                    }
                    else{
                        [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_press"] forState:UIControlStateNormal];
                    }
                }
            }
            else{
                if (isTilt) {
                    if (isUnderLine) {
                        [self.boldBtn setImage:[UIImage imageNamed:@"text_italic_underline_press"] forState:UIControlStateNormal];
                    }
                    else{
                        [self.boldBtn setImage:[UIImage imageNamed:@"text_italic_press"] forState:UIControlStateNormal];
                    }
                }
                else{
                    if (isUnderLine) {
                        [self.boldBtn setImage:[UIImage imageNamed:@"text_underline_press"] forState:UIControlStateNormal];
                    }
                    else{
                        [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_default_pressed"] forState:UIControlStateNormal];
                    }
                }
            }
            
        }
        else{
            _popView.hidden = NO;
            
//            [self stylePopDismss];
            
            
        }
        
        
    }
    
    
    if (tag==2) {
//        [self stylePopDismss];
//        [self alignPopDismss];
//        clickTag = 2;
        
        if (!_smallSizeBtn) {
            _smallSizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
        }
        if (!_norSizeBtn) {
            _norSizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
        }
        if (!_bigSizeBtn) {
            _bigSizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
        }
        [self.popView addSubview:_smallSizeBtn];
        [self.popView addSubview:_norSizeBtn];
        [self.popView addSubview:_bigSizeBtn];
        
        [self.smallSizeBtn addTarget:self action:@selector(heading5) forControlEvents:UIControlEventTouchUpInside];
        
        [self.norSizeBtn addTarget:self action:@selector(heading4) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bigSizeBtn addTarget:self action:@selector(heading3) forControlEvents:UIControlEventTouchUpInside];
        
        _popView.frame = CGRectMake(20, kSCREEN_HEIGHT-keyBoardH-46-40-10, 150, 40);
        _popView.backgroundColor = White_Color;
        _popView.centerX = self.fontBtn.centerX;
        _popView.layer.masksToBounds = YES;
        
        _smallSizeBtn.frame = CGRectMake(0, 0, _popView.width/3, _popView.height);
        _norSizeBtn.frame = CGRectMake((_popView.width/3), 0, _popView.width/3, _popView.height);
        _bigSizeBtn.frame = CGRectMake((_popView.width/3)*2, 0, _popView.width/3, _popView.height);
//        self.leftBtn.tag = 1;
//        self.midBtn.tag = 2;
//        self.rightBtn.tag = 3;
        
        if (textSizeIsPop) {
            _popView.hidden = NO;
            
            
            if (textSizeTag==1) {
                //smalll
                [self.smallSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_1_enable"] forState:UIControlStateNormal];
                [self.norSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_2"] forState:UIControlStateNormal];
                [self.bigSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_3"] forState:UIControlStateNormal];
                [self.fontBtn setImage:[UIImage imageNamed:@"text_large_small_press"] forState:UIControlStateNormal];
            }
            else if(textSizeTag==2){
                //nor
                [self.smallSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_1"] forState:UIControlStateNormal];
                [self.norSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_2_enable"] forState:UIControlStateNormal];
                [self.bigSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_3"] forState:UIControlStateNormal];
                [self.fontBtn setImage:[UIImage imageNamed:@"text_large_default_pressed"] forState:UIControlStateNormal];
            }
            else{
                //big
                [self.smallSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_1"] forState:UIControlStateNormal];
                [self.norSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_2"] forState:UIControlStateNormal];
                [self.bigSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_3_enable"] forState:UIControlStateNormal];
                [self.fontBtn setImage:[UIImage imageNamed:@"text_large_large_press"] forState:UIControlStateNormal];
            }
            
            
            
            
        }
        else{
            _popView.hidden = YES;
            
            
            
            [self sizePopDismss];
            
        }
        
        
    }
    
    if (tag==3) {
//        [self sizePopDismss];
//        [self stylePopDismss];
//        clickTag = 3;
        
        if (!_leftBtn) {
            _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
        }
        if (!_midBtn) {
            _midBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
        }
        if (!_rightBtn) {
            _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
        }
        [self.popView addSubview:_leftBtn];
        [self.popView addSubview:_midBtn];
        [self.popView addSubview:_rightBtn];
        [self.leftBtn addTarget:self action:@selector(alignLeft) forControlEvents:UIControlEventTouchUpInside];
        
        [self.midBtn addTarget:self action:@selector(alignCenter) forControlEvents:UIControlEventTouchUpInside];
        
        [self.rightBtn addTarget:self action:@selector(alignRight) forControlEvents:UIControlEventTouchUpInside];
        _popView.frame = CGRectMake(20, kSCREEN_HEIGHT-keyBoardH-46-40-10, 150, 40);
        _popView.backgroundColor = White_Color;
        _popView.centerX = self.typesetBtn.centerX;
        _popView.layer.masksToBounds = YES;
        
        _leftBtn.frame = CGRectMake(0, 0, _popView.width/3, _popView.height);
        _midBtn.frame = CGRectMake((_popView.width/3), 0, _popView.width/3, _popView.height);
        _rightBtn.frame = CGRectMake((_popView.width/3)*2, 0, _popView.width/3, _popView.height);
//        self.leftBtn.tag = 1;
//        self.midBtn.tag = 2;
//        self.rightBtn.tag = 3;
        if (textAlignmentIsPop) {
            _popView.hidden = NO;
            
            
            if (textAlignmentTag==1) {
                //left
                [self.leftBtn setImage:[UIImage imageNamed:@"text_editor_alien_l_enable"] forState:UIControlStateNormal];
                [self.midBtn setImage:[UIImage imageNamed:@"text_editor_alien_m"] forState:UIControlStateNormal];
                [self.rightBtn setImage:[UIImage imageNamed:@"text_editor_alien_r"] forState:UIControlStateNormal];
                [self.typesetBtn setImage:[UIImage imageNamed:@"text_center_default_pressed"] forState:UIControlStateNormal];
            }
            else if(textAlignmentTag==2){
                //mid
                [self.leftBtn setImage:[UIImage imageNamed:@"text_editor_alien_l"] forState:UIControlStateNormal];
                [self.midBtn setImage:[UIImage imageNamed:@"text_editor_alien_m_enable"] forState:UIControlStateNormal];
                [self.rightBtn setImage:[UIImage imageNamed:@"text_editor_alien_r"] forState:UIControlStateNormal];
                [self.typesetBtn setImage:[UIImage imageNamed:@"text_center_center_press"] forState:UIControlStateNormal];
            }
            else{
                //right
                [self.leftBtn setImage:[UIImage imageNamed:@"text_editor_alien_l"] forState:UIControlStateNormal];
                [self.midBtn setImage:[UIImage imageNamed:@"text_editor_alien_m"] forState:UIControlStateNormal];
                [self.rightBtn setImage:[UIImage imageNamed:@"text_editor_alien_r_enable"] forState:UIControlStateNormal];
                [self.typesetBtn setImage:[UIImage imageNamed:@"text_center_right_press"] forState:UIControlStateNormal];
            }
            
            
            
            
        }
        else{
            _popView.hidden = YES;
            [self alignPopDismss];
            
        }
        
        
    }

}

#pragma mark - 粘贴常用语

-(void)pasteMuchUse:(UIButton *)btn{
    MuchUseModel *model = self.muchUseArray[btn.tag];
    [self pasteContent:model.content];
}

#pragma mark - 样式的点击事件
-(void)styleResetSubviewWith:(UIButton *)btn{
    self.muchUseView.hidden = YES;
    if (clickTag==1) {
        
        if (btn.tag==0) {
            //粗体
            isBold = !isBold;
            if (isBold) {
                [self.leftBtn setImage:[UIImage imageNamed:@"text_editor_b_enable"] forState:UIControlStateNormal];
            }
            else{
                [self.leftBtn setImage:[UIImage imageNamed:@"text_editor_b"] forState:UIControlStateNormal];
            }
            [self setBold];
            
        }
        else if (btn.tag==1) {
            //斜线
            isTilt = !isTilt;
            if (isTilt) {
                //                _midImgV.image = [UIImage imageNamed:@"text_editor_i_enable"];
                [self.midBtn setImage:[UIImage imageNamed:@"text_editor_i_enable"] forState:UIControlStateNormal];
            }
            else{
                //                _midImgV.image = [UIImage imageNamed:@"text_editor_i"];
                [self.midBtn setImage:[UIImage imageNamed:@"text_editor_i"] forState:UIControlStateNormal];
            }
            [self setItalic];
        }
        else{
            //下划线
            isUnderLine = !isUnderLine;
            if (isUnderLine) {
                //                _rightImgV.image = [UIImage imageNamed:@"text_editor_u_enable"];
                [self.rightBtn setImage:[UIImage imageNamed:@"text_editor_u_enable"] forState:UIControlStateNormal];
            }
            else{
                //                _rightImgV.image = [UIImage imageNamed:@"text_editor_u"];
                [self.rightBtn setImage:[UIImage imageNamed:@"text_editor_u"] forState:UIControlStateNormal];
            }
            [self setUnderline];
        }
        
        if (isBold) {
            if (isTilt) {
                if (isUnderLine) {
                    [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_italic_underline_press"] forState:UIControlStateNormal];
                }
                else{
                    [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_italic_press"] forState:UIControlStateNormal];
                }
            }
            else{
                if (isUnderLine) {
                    [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_underline_press"] forState:UIControlStateNormal];
                }
                else{
                    [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_press"] forState:UIControlStateNormal];
                }
            }
        }
        else{
            if (isTilt) {
                if (isUnderLine) {
                    [self.boldBtn setImage:[UIImage imageNamed:@"text_italic_underline_press"] forState:UIControlStateNormal];
                }
                else{
                    [self.boldBtn setImage:[UIImage imageNamed:@"text_italic_press"] forState:UIControlStateNormal];
                }
            }
            else{
                if (isUnderLine) {
                    [self.boldBtn setImage:[UIImage imageNamed:@"text_underline_press"] forState:UIControlStateNormal];
                }
                else{
                    [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_default_pressed"] forState:UIControlStateNormal];
                }
            }
        }
        
    }
    else if (clickTag == 2){
        textSizeTag = btn.tag;
        if (textSizeTag==1) {
            //small
            
            [self.leftBtn setImage:[UIImage imageNamed:@"text_editor_text_size_1_enable"] forState:UIControlStateNormal];
            [self.midBtn setImage:[UIImage imageNamed:@"text_editor_text_size_2"] forState:UIControlStateNormal];
            [self.rightBtn setImage:[UIImage imageNamed:@"text_editor_text_size_3"] forState:UIControlStateNormal];
            [self.fontBtn setImage:[UIImage imageNamed:@"text_large_small_press"] forState:UIControlStateNormal];
            [self heading5];
        }
        else if (textSizeTag==2) {
            //nor
            [self.leftBtn setImage:[UIImage imageNamed:@"text_editor_text_size_1"] forState:UIControlStateNormal];
            [self.midBtn setImage:[UIImage imageNamed:@"text_editor_text_size_2_enable"] forState:UIControlStateNormal];
            [self.rightBtn setImage:[UIImage imageNamed:@"text_editor_text_size_3"] forState:UIControlStateNormal];
            [self.fontBtn setImage:[UIImage imageNamed:@"text_large_default_pressed"] forState:UIControlStateNormal];
            [self heading4];
        }
        else{
            //big
            [self.leftBtn setImage:[UIImage imageNamed:@"text_editor_text_size_1"] forState:UIControlStateNormal];
            [self.midBtn setImage:[UIImage imageNamed:@"text_editor_text_size_2"] forState:UIControlStateNormal];
            [self.rightBtn setImage:[UIImage imageNamed:@"text_editor_text_size_3_enable"] forState:UIControlStateNormal];
            [self.fontBtn setImage:[UIImage imageNamed:@"text_large_large_press"] forState:UIControlStateNormal];
            [self heading3];
        }
    }
    else {
        if (textAlignmentTag==1) {
            [self.leftBtn setImage:[UIImage imageNamed:@"text_editor_alien_l_enable"] forState:UIControlStateNormal];
            [self.midBtn setImage:[UIImage imageNamed:@"text_editor_alien_m"] forState:UIControlStateNormal];
            [self.rightBtn setImage:[UIImage imageNamed:@"text_editor_alien_r"] forState:UIControlStateNormal];
            [self.typesetBtn setImage:[UIImage imageNamed:@"text_center_default_pressed"] forState:UIControlStateNormal];
        }
        else if(textAlignmentTag==2){
            [self.leftBtn setImage:[UIImage imageNamed:@"text_editor_alien_l"] forState:UIControlStateNormal];
            [self.midBtn setImage:[UIImage imageNamed:@"text_editor_alien_m_enable"] forState:UIControlStateNormal];
            [self.rightBtn setImage:[UIImage imageNamed:@"text_editor_alien_r"] forState:UIControlStateNormal];
            [self.typesetBtn setImage:[UIImage imageNamed:@"text_center_center_press"] forState:UIControlStateNormal];
        }
        else{
            [self.leftBtn setImage:[UIImage imageNamed:@"text_editor_alien_l"] forState:UIControlStateNormal];
            [self.midBtn setImage:[UIImage imageNamed:@"text_editor_alien_m"] forState:UIControlStateNormal];
            [self.rightBtn setImage:[UIImage imageNamed:@"text_editor_alien_r_enable"] forState:UIControlStateNormal];
            [self.typesetBtn setImage:[UIImage imageNamed:@"text_center_right_press"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 颜色按钮的点击事件

-(void)subColorBtnClick:(UIButton *)btn{
    colorTag = btn.tag;
    [self colorPopDismss];
    self.colorPopView.hidden = YES;
    UIColor *color;
    if (btn.tag == 1) {
        color = Black_Color;
    }
    else if (btn.tag == 2){
        color = Gray_Color;
    }
    else if (btn.tag == 3){
        color = Red_Color;
    }
    else if (btn.tag == 4){
        color = RGB(240, 143, 53);
    }
    else if (btn.tag == 5){
        color = Green_Color;
    }
    else if (btn.tag == 6){
        color = Blue_Color;
    }
    else {
        color = Purple_Color;
    }
    
    [self setTextColor:color];
}


#pragma mark - stylePopDismss

-(void)stylePopDismss{
    if (isBold) {
        if (isTilt) {
            if (isUnderLine) {
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_italic_underline_normal"] forState:UIControlStateNormal];
            }
            else{
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_italic_normal"] forState:UIControlStateNormal];
            }
        }
        else{
            if (isUnderLine) {
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_underline_normal"] forState:UIControlStateNormal];
            }
            else{
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_normal"] forState:UIControlStateNormal];
            }
        }
    }
    else{
        if (isTilt) {
            if (isUnderLine) {
                [self.boldBtn setImage:[UIImage imageNamed:@"text_italic_underline_normal"] forState:UIControlStateNormal];
            }
            else{
                [self.boldBtn setImage:[UIImage imageNamed:@"text_italic_normal"] forState:UIControlStateNormal];
            }
        }
        else{
            if (isUnderLine) {
                [self.boldBtn setImage:[UIImage imageNamed:@"text_underline_normal"] forState:UIControlStateNormal];
            }
            else{
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_default_normal"] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - sizePopDismss

-(void)sizePopDismss{
    if (textSizeTag==1) {
        //smalll
        [self.fontBtn setImage:[UIImage imageNamed:@"text_large_small_normal"] forState:UIControlStateNormal];
    }
    else if(textSizeTag==2){
        //nor
        [self.fontBtn setImage:[UIImage imageNamed:@"text_large_normal"] forState:UIControlStateNormal];
    }
    else{
        //big
        [self.fontBtn setImage:[UIImage imageNamed:@"text_large_large_normal"] forState:UIControlStateNormal];
    }
}

#pragma mark - alignPopDismss

-(void)alignPopDismss{
    if (textAlignmentTag==1) {
        //left
        [self.typesetBtn setImage:[UIImage imageNamed:@"text_center_default_normal"] forState:UIControlStateNormal];
    }
    else if(textAlignmentTag==2){
        //mid
        [self.typesetBtn setImage:[UIImage imageNamed:@"text_center_center_normal"] forState:UIControlStateNormal];
    }
    else{
        //right
        [self.typesetBtn setImage:[UIImage imageNamed:@"text_center_right_normal"] forState:UIControlStateNormal];
    }
}

#pragma mark - colorPopDismss

-(void)colorPopDismss{
    [self.colorBtn setImage:[UIImage imageNamed:@"text_color_normal"] forState:UIControlStateNormal];
    colorIsPop = NO;
}
    
#pragma mark - 方法   
 
//粗体
- (void)setBold {
    NSString *trigger = @"zss_editor.setBold();";
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    
    isBold = !isBold;
    if (isBold) {
        [self.moreBoldBtn setImage:[UIImage imageNamed:@"text_editor_b_enable"] forState:UIControlStateNormal];
    }
    else{
        [self.moreBoldBtn setImage:[UIImage imageNamed:@"text_editor_b"] forState:UIControlStateNormal];
    }
    
    if (isBold) {
        if (isTilt) {
            if (isUnderLine) {
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_italic_underline_press"] forState:UIControlStateNormal];
            }
            else{
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_italic_press"] forState:UIControlStateNormal];
            }
        }
        else{
            if (isUnderLine) {
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_underline_press"] forState:UIControlStateNormal];
            }
            else{
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_press"] forState:UIControlStateNormal];
            }
        }
    }
    else{
        if (isTilt) {
            if (isUnderLine) {
                [self.boldBtn setImage:[UIImage imageNamed:@"text_italic_underline_press"] forState:UIControlStateNormal];
            }
            else{
                [self.boldBtn setImage:[UIImage imageNamed:@"text_italic_press"] forState:UIControlStateNormal];
            }
        }
        else{
            if (isUnderLine) {
                [self.boldBtn setImage:[UIImage imageNamed:@"text_underline_press"] forState:UIControlStateNormal];
            }
            else{
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_default_pressed"] forState:UIControlStateNormal];
            }
        }
    }
}

//斜体
- (void)setItalic {
    NSString *trigger = @"zss_editor.setItalic();";
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    
    isTilt = !isTilt;
    if (isTilt) {
        //                _midImgV.image = [UIImage imageNamed:@"text_editor_i_enable"];
        [self.moreItalicBtn setImage:[UIImage imageNamed:@"text_editor_i_enable"] forState:UIControlStateNormal];
    }
    else{
        //                _midImgV.image = [UIImage imageNamed:@"text_editor_i"];
        [self.moreItalicBtn setImage:[UIImage imageNamed:@"text_editor_i"] forState:UIControlStateNormal];
    }
    
    if (isBold) {
        if (isTilt) {
            if (isUnderLine) {
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_italic_underline_press"] forState:UIControlStateNormal];
            }
            else{
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_italic_press"] forState:UIControlStateNormal];
            }
        }
        else{
            if (isUnderLine) {
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_underline_press"] forState:UIControlStateNormal];
            }
            else{
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_press"] forState:UIControlStateNormal];
            }
        }
    }
    else{
        if (isTilt) {
            if (isUnderLine) {
                [self.boldBtn setImage:[UIImage imageNamed:@"text_italic_underline_press"] forState:UIControlStateNormal];
            }
            else{
                [self.boldBtn setImage:[UIImage imageNamed:@"text_italic_press"] forState:UIControlStateNormal];
            }
        }
        else{
            if (isUnderLine) {
                [self.boldBtn setImage:[UIImage imageNamed:@"text_underline_press"] forState:UIControlStateNormal];
            }
            else{
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_default_pressed"] forState:UIControlStateNormal];
            }
        }
    }
}

//下划线
- (void)setUnderline {
    NSString *trigger = @"zss_editor.setUnderline();";
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    
    
    isUnderLine = !isUnderLine;
    if (isUnderLine) {
        //                _rightImgV.image = [UIImage imageNamed:@"text_editor_u_enable"];
        [self.moreUnderlineBtn setImage:[UIImage imageNamed:@"text_editor_u_enable"] forState:UIControlStateNormal];
    }
    else{
        //                _rightImgV.image = [UIImage imageNamed:@"text_editor_u"];
        [self.moreUnderlineBtn setImage:[UIImage imageNamed:@"text_editor_u"] forState:UIControlStateNormal];
    }
    
    if (isBold) {
        if (isTilt) {
            if (isUnderLine) {
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_italic_underline_press"] forState:UIControlStateNormal];
            }
            else{
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_italic_press"] forState:UIControlStateNormal];
            }
        }
        else{
            if (isUnderLine) {
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_underline_press"] forState:UIControlStateNormal];
            }
            else{
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_press"] forState:UIControlStateNormal];
            }
        }
    }
    else{
        if (isTilt) {
            if (isUnderLine) {
                [self.boldBtn setImage:[UIImage imageNamed:@"text_italic_underline_press"] forState:UIControlStateNormal];
            }
            else{
                [self.boldBtn setImage:[UIImage imageNamed:@"text_italic_press"] forState:UIControlStateNormal];
            }
        }
        else{
            if (isUnderLine) {
                [self.boldBtn setImage:[UIImage imageNamed:@"text_underline_press"] forState:UIControlStateNormal];
            }
            else{
                [self.boldBtn setImage:[UIImage imageNamed:@"text_bold_default_pressed"] forState:UIControlStateNormal];
            }
        }
    }
}

//big
- (void)heading3 {
    textSizeTag = 3;
    NSString *trigger = @"zss_editor.setHeading('h3');";
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    
    [self.smallSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_1"] forState:UIControlStateNormal];
    [self.norSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_2"] forState:UIControlStateNormal];
    [self.bigSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_3_enable"] forState:UIControlStateNormal];
    [self.fontBtn setImage:[UIImage imageNamed:@"text_large_large_press"] forState:UIControlStateNormal];
    
    if (textAlignmentTag==1) {
        NSString *trigger = @"zss_editor.setJustifyLeft();";
        [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    }
    else if(textAlignmentTag==2){
        NSString *trigger = @"zss_editor.setJustifyCenter();";
        [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    }
    else{
        NSString *trigger = @"zss_editor.setJustifyRight();";
        [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    }
    
}

//normal
- (void)heading4 {
    textSizeTag = 2;
    NSString *trigger = @"zss_editor.setHeading('h4');";
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    
    
    [self.smallSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_1"] forState:UIControlStateNormal];
    [self.norSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_2_enable"] forState:UIControlStateNormal];
    [self.bigSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_3"] forState:UIControlStateNormal];
    [self.fontBtn setImage:[UIImage imageNamed:@"text_large_default_pressed"] forState:UIControlStateNormal];
    
    if (textAlignmentTag==1) {
        NSString *trigger = @"zss_editor.setJustifyLeft();";
        [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    }
    else if(textAlignmentTag==2){
        NSString *trigger = @"zss_editor.setJustifyCenter();";
        [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    }
    else{
        NSString *trigger = @"zss_editor.setJustifyRight();";
        [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    }
}

//small
- (void)heading5 {
    textSizeTag = 1;
    NSString *trigger = @"zss_editor.setHeading('h5');";
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    
    [self.smallSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_1_enable"] forState:UIControlStateNormal];
    [self.norSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_2"] forState:UIControlStateNormal];
    [self.bigSizeBtn setImage:[UIImage imageNamed:@"text_editor_text_size_3"] forState:UIControlStateNormal];
    [self.fontBtn setImage:[UIImage imageNamed:@"text_large_small_press"] forState:UIControlStateNormal];
    
    if (textAlignmentTag==1) {
        NSString *trigger = @"zss_editor.setJustifyLeft();";
        [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    }
    else if(textAlignmentTag==2){
        NSString *trigger = @"zss_editor.setJustifyCenter();";
        [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    }
    else{
        NSString *trigger = @"zss_editor.setJustifyRight();";
        [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    }
}

//alignLeft
- (void)alignLeft {
    textAlignmentTag = 1;
    NSString *trigger = @"zss_editor.setJustifyLeft();";
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    
    [self.leftBtn setImage:[UIImage imageNamed:@"text_editor_alien_l_enable"] forState:UIControlStateNormal];
    [self.midBtn setImage:[UIImage imageNamed:@"text_editor_alien_m"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"text_editor_alien_r"] forState:UIControlStateNormal];
    [self.typesetBtn setImage:[UIImage imageNamed:@"text_center_default_pressed"] forState:UIControlStateNormal];
}

//alignCenter
- (void)alignCenter {
    textAlignmentTag = 2;
    NSString *trigger = @"zss_editor.setJustifyCenter();";
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    
    [self.leftBtn setImage:[UIImage imageNamed:@"text_editor_alien_l"] forState:UIControlStateNormal];
    [self.midBtn setImage:[UIImage imageNamed:@"text_editor_alien_m_enable"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"text_editor_alien_r"] forState:UIControlStateNormal];
    [self.typesetBtn setImage:[UIImage imageNamed:@"text_center_center_press"] forState:UIControlStateNormal];
}

//alignRight
- (void)alignRight {
    textAlignmentTag = 3;
    NSString *trigger = @"zss_editor.setJustifyRight();";
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
    
    [self.leftBtn setImage:[UIImage imageNamed:@"text_editor_alien_l"] forState:UIControlStateNormal];
    [self.midBtn setImage:[UIImage imageNamed:@"text_editor_alien_m"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"text_editor_alien_r_enable"] forState:UIControlStateNormal];
    [self.typesetBtn setImage:[UIImage imageNamed:@"text_center_right_press"] forState:UIControlStateNormal];
}

-(void)setTextColor:(UIColor *)color{
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
    
    NSString *hex = [NSString stringWithFormat:@"#%06x",HexColorFromUIColor(color)];
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.setTextColor(\"%@\");", hex];
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
}

-(void)selectAllTtext{
    [self.webView stringByEvaluatingJavaScriptFromString:@"zss_editor.selectAllText();"];
}

-(void)getFoucs{
    [self.webView stringByEvaluatingJavaScriptFromString:@"zss_editor.focus();"];
}

-(void)pasteContent:(NSString *)str{
    [self.webView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.insertContent(\"%@\",\"%@\");",@"",str];
    [self.webView stringByEvaluatingJavaScriptFromString:trigger];
}

#pragma mark - 添加链接
-(void)addLinkClick:(UITapGestureRecognizer *)ges{
    self.muchUseView.hidden = YES;
    
    AddLinkController *vc = [[AddLinkController alloc]init];
    vc.linkAddress = self.linkAddress;
    vc.linkDescrib = self.linkDescrib;
    vc.myContructLink = self.myContructLink;
    vc.addLinkBlock = ^(NSString *linkUrl, NSString *linkDescrib) {
        self.linkAddress = linkUrl;
        self.linkDescrib = linkDescrib;
        [self refreshLinkVStatus];
    };
    [self.navigationController pushViewController:vc animated:YES];
}



- (void) convertToMp3: (MPMediaItem*)song

{
    
    NSURL*url = [song valueForProperty:MPMediaItemPropertyAssetURL];
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    NSFileManager*fileManager = [NSFileManager defaultManager];
    
    NSArray*dirs =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString*documentsDirectoryPath = [dirs objectAtIndex:0];
    
    NSLog(@"compatible presets for songAsset: %@",[AVAssetExportSession exportPresetsCompatibleWithAsset:songAsset]);
    
    NSArray*ar = [AVAssetExportSession exportPresetsCompatibleWithAsset: songAsset];
    
    NSLog(@"%@", ar);
    
    AVAssetExportSession*exporter = [[AVAssetExportSession alloc]
                                     
                                     initWithAsset: songAsset
                                     
                                     presetName:AVAssetExportPresetAppleM4A];
    
    NSLog(@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
    
    exporter.outputFileType=@"com.apple.m4a-audio";
    
    NSString*exportFile = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",[song valueForProperty:MPMediaItemPropertyTitle]]];
    
    NSError*error1;
    
    if([fileManager fileExistsAtPath:exportFile])
        
    {
        
        [fileManager removeItemAtPath:exportFile error:&error1];
        
    }
    
    NSURL*urlPath= [NSURL fileURLWithPath:exportFile];
    
    exporter.outputURL=urlPath;
    
    NSLog(@"---------%@",urlPath);
    
    // do the export
    
    [exporter exportAsynchronouslyWithCompletionHandler:^
     
    {
        
        NSData*data1 = [NSData dataWithContentsOfFile:exportFile];
        
        NSLog(@"==================data1:%@",data1);
        
        int exportStatus = exporter.status;
        
        switch(exportStatus) {
                
            case AVAssetExportSessionStatusFailed: {
                
                // log error to text view
                
                NSError*exportError = exporter.error;
                
                NSLog(@"AVAssetExportSessionStatusFailed: %@", exportError);
                
                break;
                
            }
                
            case AVAssetExportSessionStatusCompleted: {
                
                NSLog(@"AVAssetExportSessionStatusCompleted");
                
                break;
                
            }
                
            case AVAssetExportSessionStatusUnknown: {
                
                NSLog(@"AVAssetExportSessionStatusUnknown");
                
                break;
                
            }
                
            case AVAssetExportSessionStatusExporting: {
                
                NSLog(@"AVAssetExportSessionStatusExporting");
                
                break;
                
            }
                
            case AVAssetExportSessionStatusCancelled: {
                
                NSLog(@"AVAssetExportSessionStatusCancelled");
                
                break;
                
            }
                
            case AVAssetExportSessionStatusWaiting: {
                
                NSLog(@"AVAssetExportSessionStatusWaiting");
                
                break;
                
            }
                
            default:
                
            {NSLog(@"didn't get export status");
                
                break;
                
            }
                
        }
        
    }];
    
}



#pragma mark - Utilities
    
- (NSString *)removeQuotesFromHTML:(NSString *)html {
    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    html = [html stringByReplacingOccurrencesOfString:@"“" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"”" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"\r"  withString:@"\\r"];
//    html = [html stringByReplacingOccurrencesOfString:@"\n"  withString:@"\\n"];
    html = [html stringByReplacingOccurrencesOfString:@"\n"  withString:@""];
    return html;
}//end
    
    
- (NSString *)tidyHTML:(NSString *)html {
    html = [html stringByReplacingOccurrencesOfString:@"<br>" withString:@"<br />"];
    html = [html stringByReplacingOccurrencesOfString:@"<hr>" withString:@"<hr />"];
//    if (self.formatHTML) {
//        html = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"style_html('%@');", html]];
//    }
    return html;
}//end
    
    
- (NSString *)getHTML {
    
    NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:@"zss_editor.getHTML();"];
//    NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:@"zss_editor.getTEXT();"];
//    html = [self removeQuotesFromHTML:html];
    html = [self tidyHTML:html];
    
    [[NSUserDefaults standardUserDefaults] setObject:html forKey:@"htmlStr"];
    return html;
}

-(NSString *)getText{
    NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:@"zss_editor.getTEXT();"];
    return html;
}

#pragma mark - lazy

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_WIDTH, kSCREEN_HEIGHT-self.navigationController.navigationBar.bottom-toolbarHolderHeight)];
        //        _scrollView.backgroundColor = Red_Color;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = White_Color;
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

//-(UIWebView *)webView{
//    if (!_webView) {
//        <#statements#>
//    }
//}

-(UITextView *)sourceView{
    if (!_sourceView) {
//        _sourceView  = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
        _sourceView  = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, self.scrollView.height)];
        _sourceView.font = NB_FONTSEIZ_NOR;
        _sourceView.textColor = COLOR_BLACK_CLASS_3;
        _sourceView.delegate = self;
        _sourceView.backgroundColor = White_Color;
        _sourceView.textContainerInset = UIEdgeInsetsMake(5,0, 10, 15);
        
        NSString *signH = @"高兴";
        CGSize textSize = [signH boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                      context:nil].size;
        _sourceView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.scrollView.height);
        textviewH = self.scrollView.height;
    }
    return _sourceView;
}

-(UIWebView *)webView{
    if (!_webView) {
//        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64-toolbarHolderHeight)];
        _webView.delegate = self;
//            _webView.inputAccessoryView = YES;
        _webView.hidesInputAccessoryView = YES;
        _webView.scalesPageToFit = YES;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
        _webView.scrollView.bounces = NO;
        _webView.backgroundColor = [UIColor whiteColor];
        [_webView setKeyboardDisplayRequiresUserAction:NO];
    }
    return _webView;
}

-(UIView *)toolbarHolder{
    if (!_toolbarHolder) {
        _toolbarHolder = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-toolbarHolderHeight, kSCREEN_WIDTH, toolbarHolderHeight)];
        _toolbarHolder.backgroundColor = White_Color;
    }
    return _toolbarHolder;
}

-(UIButton *)selectAllBtn{
    if (!_selectAllBtn) {
        _selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectAllBtn.frame = CGRectMake(10, 0, 50, 20);
        _selectAllBtn.backgroundColor = Main_Color;
        [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        _selectAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_selectAllBtn setTitleColor:White_Color forState:UIControlStateNormal];
        _selectAllBtn.titleLabel.font = NB_FONTSEIZ_SMALL;
        _selectAllBtn.layer.masksToBounds = YES;
        _selectAllBtn.layer.cornerRadius = _selectAllBtn.height/2;
        //            _addressBtn.backgroundColor = Red_Color;
        //                [_addressBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
        //                [_addressBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
        
        [_selectAllBtn addTarget:self action:@selector(selectAllTtext) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectAllBtn;
}

-(UIButton *)muchUseBtn{
    if (!_muchUseBtn) {
        _muchUseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _muchUseBtn.frame = CGRectMake(kSCREEN_WIDTH/2-self.selectAllBtn.width/2, self.selectAllBtn.top, self.selectAllBtn.width, self.selectAllBtn.height);
        _muchUseBtn.backgroundColor = Main_Color;
        [_muchUseBtn setTitle:@"常用语" forState:UIControlStateNormal];
        _muchUseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_muchUseBtn setTitleColor:White_Color forState:UIControlStateNormal];
        _muchUseBtn.titleLabel.font = NB_FONTSEIZ_SMALL;
        _muchUseBtn.layer.masksToBounds = YES;
        _muchUseBtn.layer.cornerRadius = _muchUseBtn.height/2;
        //            _addressBtn.backgroundColor = Red_Color;
        //                [_addressBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
        //                [_addressBtn setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
        
        [_muchUseBtn addTarget:self action:@selector(muchUseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _muchUseBtn;
}

-(UIView *)addLinkV{
    if (!_addLinkV) {
        _addLinkV = [[UIView alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-90, self.selectAllBtn.top, 80, self.selectAllBtn.height)];
        _addLinkV.backgroundColor = Main_Color;
        _addLinkV.layer.masksToBounds = YES;
        _addLinkV.layer.cornerRadius = _addLinkV.height/2;
        
        UIImageView *leftImgV = [[UIImageView alloc]initWithFrame:CGRectMake(7, _addLinkV.height/2-12/2, 12, 12)];
        leftImgV.image = [UIImage imageNamed:@"link_small"];
//        leftImgV.backgroundColor = Red_Color;
        self.linkImgV = leftImgV;
        [_addLinkV addSubview:self.linkImgV];
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(leftImgV.right, 0, _addLinkV.width-leftImgV.right, _addLinkV.height)];
        label.textColor = White_Color;
        label.font = NB_FONTSEIZ_SMALL;
        label.text = @"添加链接";
        //        companyJob.backgroundColor = Red_Color;
        label.textAlignment = NSTextAlignmentCenter;
        
        self.linkLabel = label;
        [_addLinkV addSubview:self.linkLabel];
        
        _addLinkV.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addLinkClick:)];
        [_addLinkV addGestureRecognizer:ges];
    }
    return _addLinkV;
}

-(UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]initWithFrame:CGRectMake(0, self.selectAllBtn.bottom+10, kSCREEN_WIDTH, 1)];
        _lineV.backgroundColor = COLOR_BLACK_CLASS_0;
    }
    return _lineV;
}

-(UIButton *)revokeBtn{
    if (!_revokeBtn) {
        _revokeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _revokeBtn.frame = CGRectMake(15, self.lineV.bottom+8, 30, 30);
//        _revokeBtn.backgroundColor = Red_Color;
        [_revokeBtn setImage:[UIImage imageNamed:@"text_edit_button_undo"] forState:UIControlStateNormal];
    }
    return _revokeBtn;
}

-(UIButton *)advanceBtn{
    if (!_advanceBtn) {
        _advanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _advanceBtn.frame = CGRectMake(self.revokeBtn.right+kSCREEN_WIDTH/32, self.revokeBtn.top, 30, 30);
        //_advanceBtn.backgroundColor = Red_Color;
        [_advanceBtn setImage:[UIImage imageNamed:@"text_edit_button_redo"] forState:UIControlStateNormal];
    }
    return _advanceBtn;
}

-(UIButton *)boldBtn{
    if (!_boldBtn) {
        _boldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _boldBtn.frame = CGRectMake(kSCREEN_WIDTH/2-15, self.revokeBtn.top, 30, 30);
        //_boldBtn.backgroundColor = Red_Color;
        [_boldBtn addTarget:self action:@selector(boldBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_boldBtn setImage:[UIImage imageNamed:@"text_bold_default_normal"] forState:UIControlStateNormal];
    }
    return _boldBtn;
}


-(UIButton *)fontBtn{
    if (!_fontBtn) {
        _fontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fontBtn.frame = CGRectMake(self.boldBtn.right+kSCREEN_WIDTH/32, self.revokeBtn.top, 30, 30);
        //_fontBtn.backgroundColor = Red_Color;
        [_fontBtn addTarget:self action:@selector(sizeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_fontBtn setImage:[UIImage imageNamed:@"text_large_default_normal"] forState:UIControlStateNormal];
    }
    return _fontBtn;
}


-(UIButton *)typesetBtn{
    if (!_typesetBtn) {
        _typesetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _typesetBtn.frame = CGRectMake(self.fontBtn.right+kSCREEN_WIDTH/32, self.revokeBtn.top, 30, 30);
        //_typesetBtn.backgroundColor = Red_Color;
        [_typesetBtn setImage:[UIImage imageNamed:@"text_center_default_normal"] forState:UIControlStateNormal];
        [_typesetBtn addTarget:self action:@selector(alignmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _typesetBtn;
}


-(UIButton *)colorBtn{
    if (!_colorBtn) {
        _colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _colorBtn.frame = CGRectMake(self.typesetBtn.right+kSCREEN_WIDTH/32, self.revokeBtn.top, 30, 30);
        //_colorBtn.backgroundColor = Red_Color;
        [_colorBtn setImage:[UIImage imageNamed:@"text_color_normal"] forState:UIControlStateNormal];
        [_colorBtn addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _colorBtn;
}

-(UIButton *)keyBoadDismissBtn{
    if (!_keyBoadDismissBtn) {
        _keyBoadDismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _keyBoadDismissBtn.frame = CGRectMake(kSCREEN_WIDTH-30, self.revokeBtn.top, 30, 30);
//        _keyBoadDismissBtn.backgroundColor = Red_Color;
        [_keyBoadDismissBtn addTarget:self action:@selector(keyBoadDismissBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_keyBoadDismissBtn setImage:[UIImage imageNamed:@"keyboard_enable"] forState:UIControlStateNormal];
    }
    return _keyBoadDismissBtn;
}

#pragma mark - 常用语分类选择

-(void)changyongyubtn0click
{

}

-(void)changyongyubtn1click
{

}


@end
