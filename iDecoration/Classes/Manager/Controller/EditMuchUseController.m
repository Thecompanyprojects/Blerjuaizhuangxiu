//
//  EditMuchUseController.m
//  iDecoration
//  编辑常用语
//  Created by sty on 2017/10/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "EditMuchUseController.h"
#import "EditMuchUseCell.h"
#import "SSPopup.h"
#import "MuchUseModel.h"
#import "phraseologyCell.h"
#import <SDAutoLayout.h>

@interface EditMuchUseController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIAlertViewDelegate>{
    NSInteger muchUseType; // 0:新建常用语 1:编辑常用语
    
    NSInteger editTag;//编辑的是那一个
    
    BOOL isshow;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UIButton *addMuchUseBtn;
@property (nonatomic, strong) UILabel *addMuchUseL;

@property (nonatomic, strong) UIView *shadowV;
@property (nonatomic, strong) UIView *addMuchUseAlertV;
@property (nonatomic, strong) UIView *bottomAtcionV;

@property (nonatomic, strong) UILabel *temAddL;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation EditMuchUseController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self.type isEqualToString:@"0"]) {
        self.title = @"编辑常用语";
    }
    else
    {
        if ([self.changyongyutype isEqualToString:@"0"]) {
            self.title = @"编辑公司常用语";
            
        }
        else
        {
            self.title = @"编辑系统常用语";
            [self.bottomV setHidden:YES];
        }
    }
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomV];
    [self.bottomV addSubview:self.addMuchUseBtn];
    [self.bottomV addSubview:self.addMuchUseL];
 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.shouldResignOnTouchOutside = NO;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = NO;//这个是它自带键盘工具条开关
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    // 这里统一设置键盘处理
    manager.toolbarDoneBarButtonItemText = @"完成";
    manager.toolbarTintColor = kMainThemeColor;
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = YES;//这个是它自带键盘工具条开关
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.muchUseArray.count;
    }
    else
    {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        return 50;
    }
    if (indexPath.section==1) {
        return [self cellHeightForIndexPath:indexPath cellContentViewWidth:kSCREEN_WIDTH tableView:self.tableView];
    }
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *view = [[UIView alloc]init];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kSCREEN_WIDTH-15, 60)];
        label.text = @"您可以在文字编辑时快速插入常用信息和短语";
        label.textColor = COLOR_BLACK_CLASS_9;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = NB_FONTSEIZ_NOR;
        label.numberOfLines = 0;
        [view addSubview:label];
        return view;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        EditMuchUseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditMuchUseCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MuchUseModel *model = self.muchUseArray[indexPath.row];
        cell.muchUseL.text = model.content;
        return cell;
    }
    if (indexPath.section==1) {
        phraseologyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"phraseologyCellidentfid"];
        cell = [[phraseologyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"phraseologyCellidentfid"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.submitbtn addTarget:self action:@selector(submitbtnclick) forControlEvents:UIControlEventTouchUpInside];
        [cell setdata:@"" andtype:self.changyongyutype andisshow:isshow];
        return cell;
    }
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        editTag = indexPath.row;
        [self showBottomActionView];
    }
}

#pragma mark - action

-(void)cancelBtnClick{
    self.textView.text = @"";
    [self shadowDismiss];
}

-(void)shadowDismiss{
    self.shadowV.hidden = YES;
    self.addMuchUseAlertV.hidden = YES;
    [self.textView endEditing:YES];
    self.bottomAtcionV.hidden = YES;
}

-(void)addMuchUseBtnClick:(UIButton *)btn{
    muchUseType = 0;
    [self showAlertView];
}

-(void)editBtnClick{
    muchUseType = 1;
    self.bottomAtcionV.hidden = YES;
    [self showAlertView];
}

-(void)deleteBtnClick{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确认删除该常用语？"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}



-(void)showAlertView{
    if (!_shadowV) {
        _shadowV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _shadowV.backgroundColor = COLOR_BLACK_CLASS_9;
        _shadowV.alpha = 0.5;
        _shadowV.userInteractionEnabled = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:_shadowV];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shadowDismiss)];
        [_shadowV addGestureRecognizer:ges];
        
    }
    if (!_addMuchUseAlertV) {
        _addMuchUseAlertV = [[UIView alloc]initWithFrame:CGRectMake(10, kSCREEN_HEIGHT-self.keyBoardH-10-200, kSCREEN_WIDTH-20, 200)];
        _addMuchUseAlertV.backgroundColor = White_Color;
        _addMuchUseAlertV.layer.masksToBounds = YES;
        _addMuchUseAlertV.layer.cornerRadius = 10;
        [[UIApplication sharedApplication].keyWindow addSubview:_addMuchUseAlertV];
        
        UILabel *temAddL = [[UILabel alloc]initWithFrame:CGRectMake(0,0,self.addMuchUseAlertV.width, 60)];
        temAddL.text = @"新建常用语";
        temAddL.textColor = COLOR_BLACK_CLASS_3;
        temAddL.textAlignment = NSTextAlignmentCenter;
        temAddL.font = NB_FONTSEIZ_NOR;
        self.temAddL = temAddL;
        [self.addMuchUseAlertV addSubview:self.temAddL];
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(30, temAddL.bottom, self.addMuchUseAlertV.width-60, 70)];
        textView.delegate = self;
        
        textView.textColor = COLOR_BLACK_CLASS_3;
        textView.font = NB_FONTSEIZ_NOR;
        textView.backgroundColor = COLOR_BLACK_CLASS_0;
        self.textView = textView;
        [self.addMuchUseAlertV addSubview:self.textView];
        
        UIView *lineOne = [[UIView alloc]initWithFrame:CGRectMake(0, self.textView.bottom+20, self.addMuchUseAlertV.width, 1)];
        lineOne.backgroundColor = COLOR_BLACK_CLASS_0;
        [self.addMuchUseAlertV addSubview:lineOne];
        
        UIView *lineTwo = [[UIView alloc]initWithFrame:CGRectMake(self.addMuchUseAlertV.width/2-0.5, lineOne.bottom, 1, self.addMuchUseAlertV.height-lineOne.bottom)];
        lineTwo.backgroundColor = COLOR_BLACK_CLASS_0;
        [self.addMuchUseAlertV addSubview:lineTwo];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0,lineOne.bottom,lineTwo.left,lineTwo.height);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        cancelBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.addMuchUseAlertV addSubview:cancelBtn];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(cancelBtn.right+1,lineOne.bottom,cancelBtn.width,cancelBtn.height);
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        sureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        sureBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.addMuchUseAlertV addSubview:sureBtn];
        
    }
    
    self.shadowV.hidden = NO;
    self.addMuchUseAlertV.hidden = NO;
    [self.textView becomeFirstResponder];
    if (!muchUseType) {
        self.temAddL.text = @"新建常用语";
        self.textView.text = @"";
    }
    else{
        self.temAddL.text = @"编辑常用语";
        MuchUseModel *model = self.muchUseArray[editTag];
        self.textView.text = model.content;
    }
}

-(void)showBottomActionView{
    if (!_shadowV) {
        _shadowV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _shadowV.backgroundColor = COLOR_BLACK_CLASS_9;
        _shadowV.alpha = 0.5;
        _shadowV.userInteractionEnabled = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:_shadowV];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shadowDismiss)];
        [_shadowV addGestureRecognizer:ges];
        
    }
    self.shadowV.hidden = NO;
    if (!_bottomAtcionV) {
        _bottomAtcionV = [[UIView alloc]initWithFrame:CGRectMake(10, kSCREEN_HEIGHT-80-10, kSCREEN_WIDTH-20, 80)];
        _bottomAtcionV.backgroundColor = White_Color;
        _bottomAtcionV.layer.masksToBounds = YES;
        _bottomAtcionV.layer.cornerRadius = 10;
        [[UIApplication sharedApplication].keyWindow addSubview:_bottomAtcionV];
        
        
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editBtn.frame = CGRectMake(20,0,self.bottomAtcionV.width-20,self.bottomAtcionV.height/2-0.5);
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        editBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomAtcionV addSubview:editBtn];
        
        
        UIView *lineOne = [[UIView alloc]initWithFrame:CGRectMake(0, editBtn.bottom, self.addMuchUseAlertV.width, 1)];
        lineOne.backgroundColor = COLOR_BLACK_CLASS_0;
        [self.bottomAtcionV addSubview:lineOne];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(editBtn.left,lineOne.bottom+1,editBtn.width,self.bottomAtcionV.height/2-0.5);
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        deleteBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(editBtn.left,lineOne.bottom+1,editBtn.width,self.bottomAtcionV.height/2-0.5);
        [addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [addBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
        addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self.changyongyutype isEqualToString:@"0"]) {
            [self.bottomAtcionV addSubview:deleteBtn];
        }
        else
        {
            [self.bottomAtcionV addSubview:addBtn];
        }
    }
    self.bottomAtcionV.hidden = NO;
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self deletMuchUse];
    }
}

-(void)addBtnClick
{
    muchUseType = 0;
    [self showAlertView];
}

#pragma mark - 提交数据-添加常用语

-(void)sucessAddMuchUse{
    [self.textView endEditing:YES];
    self.textView.text = [self.textView.text ew_removeSpaces];
    if (self.textView.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"常用语不能为空" controller:self sleep:2.0];
        return;
    }
    [self shadowDismiss];
    [[UIApplication sharedApplication].keyWindow hudShow];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"commonLanguage/save.do"];
    
    NSString *companyId = @"";
    NSString *nodeId = @"";
    
    if (IsNilString(self.nodeId)) {
        nodeId = @"";
    }
    else
    {
        nodeId = self.nodeId;
    }
    
    if (IsNilString(self.companyId)) {
        companyId = @"";
    }
    else
    {
        companyId = self.companyId;
    }
    
    NSDictionary *paramDic = @{@"content":self.textView.text,
                               @"agencysId":@(user.agencyId),
                               @"type":self.type,
                               @"nodeId":nodeId,
                               @"companyId":companyId
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                self.textView.text = @"";
                [[PublicTool defaultTool] publicToolsHUDStr:@"添加成功" controller:self sleep:2.0];
                [self requestMuchUseData];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:2.0];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            
        }

    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        YSNLog(@"%@",errorMsg);
    }];
}

-(void)sureBtnClick{
    if (!muchUseType) {
        [self sucessAddMuchUse];
    }
    else{
        [self requestEditMuchUse];
    }
}

#pragma mark - 提交数据-删除常用语

-(void)deletMuchUse{
    [self shadowDismiss];
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"commonLanguage/delete.do"];
    MuchUseModel *model = self.muchUseArray[editTag];
    NSInteger languageId = [model.languageId integerValue];
    NSDictionary *paramDic = @{@"languageId":@(languageId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                self.textView.text = @"";
                [self requestMuchUseData];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:2.0];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            
        }
        
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 查询常用语
-(void)requestMuchUseData{
    if (self.upLoadMuchUseBlock) {
        self.upLoadMuchUseBlock(1);
    }
UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
NSString *defaultApi = [BASEURL stringByAppendingString:@"commonLanguage/getList.do"];
    
NSDictionary *paramDic = @{@"agencysId":@(user.agencyId),@"nodeId":self.nodeId,@"companyId":self.companyId
                           };
[NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
    
    if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
        
        NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
        if (statusCode==1000) {
            
            if ([self.changyongyutype isEqualToString:@"0"]) {
                NSArray *caseArr = [[responseObj objectForKey:@"data"]objectForKey:@"list"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[MuchUseModel class] json:caseArr];
                
                NSArray *caseArr2 = [[responseObj objectForKey:@"data"]objectForKey:@"companyList"];
                NSArray *arr2 = [NSArray yy_modelArrayWithClass:[MuchUseModel class] json:caseArr2];
                
                [self.muchUseArray removeAllObjects];
                [self.muchUseArray addObjectsFromArray:arr];
                [self.muchUseArray addObjectsFromArray:arr2];
                [self.tableView reloadData];
            }
            else
            {
                NSArray *caseArr = [[responseObj objectForKey:@"data"]objectForKey:@"systemList"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[MuchUseModel class] json:caseArr];
                
                [self.muchUseArray removeAllObjects];
                [self.muchUseArray addObjectsFromArray:arr];
                [self.tableView reloadData];
            }
  
        }
        else if (statusCode==1001){
            [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:2.0];
        }
        else if (statusCode==1002){
            [[PublicTool defaultTool] publicToolsHUDStr:@"数据为空" controller:self sleep:2.0];
        }
        else if (statusCode==2000){
            [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
        }
        else{
            [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
        }
        
    }

} failed:^(NSString *errorMsg) {
    YSNLog(@"%@",errorMsg);
}];
}

#pragma mark - 提交数据-修改常用语

-(void)requestEditMuchUse{
    [self.textView endEditing:YES];
    self.textView.text = [self.textView.text ew_removeSpaces];
    if (self.textView.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"常用语不能为空" controller:self sleep:2.0];
        return;
    }
    [self shadowDismiss];
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"commonLanguage/update.do"];
    MuchUseModel *model = self.muchUseArray[editTag];
    NSInteger languageId = [model.languageId integerValue];
    NSDictionary *paramDic = @{@"content":self.textView.text,
                               @"languageId":@(languageId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                self.textView.text = @"";
                [self requestMuchUseData];
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:2.0];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            
        }

    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        YSNLog(@"%@",errorMsg);
    }];
}
    
#pragma mark - lazy

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64-60) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = Bottom_Color;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"EditMuchUseCell" bundle:nil] forCellReuseIdentifier:@"EditMuchUseCell"];
    }
    return _tableView;
}

-(UIView *)bottomV{
    if (!_bottomV) {
        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-60, kSCREEN_WIDTH, 60)];
        _bottomV.backgroundColor = White_Color;
    }
    return _bottomV;
}

-(UIButton *)addMuchUseBtn{
    if (!_addMuchUseBtn) {
        _addMuchUseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addMuchUseBtn.frame = CGRectMake(kSCREEN_WIDTH/2-20, 5, 40, 40);
        [_addMuchUseBtn setImage:[UIImage imageNamed:@"edit_addMuchUse"] forState:UIControlStateNormal];
        [_addMuchUseBtn addTarget:self action:@selector(addMuchUseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addMuchUseBtn;
}
-(UILabel *)addMuchUseL{
    if (!_addMuchUseL) {
        _addMuchUseL = [[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH/2-50, self.addMuchUseBtn.bottom, 100, 15)];
        _addMuchUseL.text = @"新建常用语";
        _addMuchUseL.textColor = COLOR_BLACK_CLASS_6;
        _addMuchUseL.textAlignment = NSTextAlignmentCenter;
        _addMuchUseL.font = NB_FONTSEIZ_SMALL;
    }
    return _addMuchUseL;
}

#pragma mark - 切换

-(void)submitbtnclick
{
    isshow = !isshow;
    [self.tableView reloadData];
}

@end
