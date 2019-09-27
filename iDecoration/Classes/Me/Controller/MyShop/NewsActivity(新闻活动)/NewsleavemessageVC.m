//
//  NewsleavemessageVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/27.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "NewsleavemessageVC.h"
#import "WJGtextView.h"

@interface NewsleavemessageVC ()<UITextViewDelegate>
@property (nonatomic,strong) WJGtextView *textView;
@property (nonatomic,strong) UIButton *submitBtn;
@end

#define MAX_LIMIT_NUMS 200

@implementation NewsleavemessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"美文留言";
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.textView];
    [self.view addSubview:self.submitBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters


-(WJGtextView *)textView
{
    if(!_textView)
    {
        _textView = [[WJGtextView alloc] init];
        _textView.frame = CGRectMake(10, kNaviBottom+10, kSCREEN_WIDTH-20, 80);
        _textView.delegate = self;
        _textView.customPlaceholder = @"留言将筛选后显示，对所有人可见";
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.numberlabel.text = @"0/200";
    }
    return _textView;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.backgroundColor = Main_Color;
        _submitBtn.frame = CGRectMake(20,  kNaviBottom+110, kSCREEN_WIDTH-40, 46);
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = 5;
        [_submitBtn setTitle:@"提交" forState:normal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_submitBtn addTarget:self action:@selector(submitbtnclick) forControlEvents:UIControlEventTouchUpInside];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:normal];
    }
    return _submitBtn;
}

#pragma mark - 实现方法

-(void)submitbtnclick
{
    
    if ([self.type isEqualToString:@"0"]) {
        [self liuyanclick];
    }
    else
    {
        [self huifuclick];
    }
 
}

#pragma mark - 美文留言

-(void)liuyanclick
{
    NSString *url = [BASEURL stringByAppendingString:Local_meiwenliuyan];
    NSString *content = @"";
    if (self.textView.text.length==0) {
        content = @"";
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入留言！" controller:self sleep:1.5];
        
        return;
    }
    else
    {
        content = self.textView.text;
    }
    NSDictionary *para = @{@"agencysId":self.agencysId,@"designsId":self.designsId,@"content":content};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        NSString *hud = [responseObj objectForKey:@"msg"];
        [[PublicTool defaultTool] publicToolsHUDStr:hud controller:self sleep:1.0];
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNewsActivityList" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 美文回复

-(void)huifuclick
{
    NSString *url = [BASEURL stringByAppendingString:Local_meiwenhuifu];
    NSString *content = @"";
    if (self.textView.text.length==0) {
        content = @"";
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入留言！" controller:self sleep:1.5];
        
        return;
    }
    else
    {
        content = self.textView.text;
    }
    NSString *agencysId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    
    NSDictionary *para = @{@"agencysId":agencysId,@"designsId":self.designsId,@"content":content,@"messageId":self.messageId};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        NSString *hud = [responseObj objectForKey:@"msg"];
        [[PublicTool defaultTool] publicToolsHUDStr:hud controller:self sleep:1.0];
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNewsActivityList" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 监听

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            self.textView.numberlabel.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    self.textView.numberlabel.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,  existTextNum),MAX_LIMIT_NUMS];
}


@end
