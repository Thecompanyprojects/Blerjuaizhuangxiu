//
//  ActivityMessageViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/31.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ActivityMessageViewController.h"
#import "ZCHCalculatorPayController.h"
#import "ActivityMessageCell.h"

#import "NSObject+CompressImage.h"
#import "ZCHVoiceReportSettingController.h"
#import "EventdetailsVC.h"
#import "VipGroupViewController.h"

#import "SignUpManageListModel.h"
#import "AdviserList.h"
#import "PopupsViewDelegate.h"

// 备注最多输入20个字
#define kMaxLength 30

@interface ActivityMessageViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,POAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) PopupsViewDelegate *popView;
@end

@implementation ActivityMessageViewController

#pragma LifeMethod
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"报名活动";
    [self addRightItem];
    self.view.backgroundColor = kBackgroundColor;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageNum += 1;
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 添加navBar右侧的编辑按钮
- (void)addRightItem {
    
    // 设置导航栏最右侧的按钮
    UIButton *settingBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    settingBtn.frame = CGRectMake(0, 0, 44, 44);
    [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
    [settingBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    settingBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    settingBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    settingBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [settingBtn addTarget:self action:@selector(didClickSettingBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [NSObject promptWithControllerName:@"ActivityMessageViewController"];
}

#pragma mark - NormalMethod
- (void)getData {
    [[UIApplication sharedApplication].keyWindow hudShow];
    
    NSString *pageNumStr = [NSString stringWithFormat:@"%ld", (long)self.pageNum];

    UserInfoModel *userInfoModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *agencyIdStr = [NSString stringWithFormat:@"%ld", (long)userInfoModel.agencyId];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"signupMessage/getByAgencyId.do"];

    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];

    [paramDic setObject:agencyIdStr forKeyedSubscript:@"agencyId"];
    [paramDic setObject:pageNumStr forKeyedSubscript:@"page"];
    [paramDic setObject:@"20" forKeyedSubscript:@"pageSize"];
     [paramDic setObject:@"" forKeyedSubscript:@"serchContent"];
     [paramDic setObject:@"0" forKeyedSubscript:@"origin"];
   

    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow  hiddleHud];
        // 加载成功
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];

        if (code == 1000) {
            NSDictionary *dataDict = [responseObj objectForKey:@"data"];
            NSArray *listArray = [dataDict objectForKey:@"list"];
            if (self.pageNum == 1) {
                [self.listArray removeAllObjects];
                for (NSDictionary *dict in listArray) {
                    SignUpManageListModel *sysMessageModel = [SignUpManageListModel yy_modelWithJSON:dict];
                    [self.listArray addObject:sysMessageModel];
                }
            } else {
                for (NSDictionary *dict in listArray) {
                    SignUpManageListModel *applyModel = [SignUpManageListModel yy_modelWithJSON:dict];
                    [self.listArray addObject:applyModel];
                }
            }
            [self.tableView reloadData];
        }
        
        if (self.pageNum == 1) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }

    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
        if (self.pageNum == 1) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)deleteActivityByModel:(SignUpManageListModel *)model indexPath:(NSIndexPath *)indexPath {

    UserInfoModel *userInfoModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@(model.messageId) forKeyedSubscript:@"messageId"];
    [paramDic setObject:@(userInfoModel.agencyId) forKeyedSubscript:@"agencyId"];
    NSString *apiStr = [BASEURL stringByAppendingString:@"signupMessage/getDeleteByMessageId.do"];

    YSNLog(@"%@", paramDic);
    [NetManager afPostRequest:apiStr parms:paramDic finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                [[PublicTool defaultTool] publicToolsHUDStr:@"删除成功" controller:self sleep:1.0];
                [self.listArray removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            }
                break;

            default:
                [[PublicTool defaultTool] publicToolsHUDStr:@"删除失败" controller:self sleep:1.0];
                [self.tableView setEditing:NO animated:YES];
                break;
        }
    } failed:^(NSString *errorMsg) {

    }];
}

#pragma mark - textViewDelegate
// textview 高度变化
- (void)textViewDidChange:(UITextView *)textView {
    NSIndexPath *indexP = [NSIndexPath indexPathForRow:textView.tag inSection:0];
    ActivityMessageCell *cell = [self.tableView cellForRowAtIndexPath:indexP];
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), CGFLOAT_MAX)];
    CGFloat height = size.height;
    if (height < 32) {
        cell.beizhuTVHeightCon.constant = 32;
    }else{
        cell.beizhuTVHeightCon.constant = height;
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    
    if (textView.text.length) {
        cell.placeHolderLabel.hidden = YES;
    } else {
        cell.placeHolderLabel.hidden = NO;
    }
}



// 限制提示文字长度
-(void)textViewEditChanged:(NSNotification *)obj{
    UITextView *textView = (UITextView *)obj.object;
    NSIndexPath *indexP = [NSIndexPath indexPathForRow:textView.tag inSection:0];
    ActivityMessageCell *cell = [self.tableView cellForRowAtIndexPath:indexP];
    
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
                //                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"字数长度不要超过20字哦！"];
                // 刷新界面
                CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), CGFLOAT_MAX)];
                CGFloat height = size.height;
                if (height < 30) {
                    cell.beizhuTVHeightCon.constant = 30;
                }else{
                    cell.beizhuTVHeightCon.constant = height;
                }
                [self.tableView beginUpdates];
                [self.tableView endUpdates];
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
            // 超长保存前30个字
            //            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"字数长度不要超过20字哦！"];
            // 刷新界面
            CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), CGFLOAT_MAX)];
            CGFloat height = size.height;
            if (height < 30) {
                cell.beizhuTVHeightCon.constant = 30;
            }else{
                cell.beizhuTVHeightCon.constant = height;
            }
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    SignUpManageListModel *calModel = self.listArray[textView.tag];
    // 备注
    [self remarkCalculatSecondeByModel:calModel remark:textView.text];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        return NO;
    } else {
        return YES;
    }
    return YES;
}



// 添加备注
- (void)remarkCalculatSecondeByModel:(SignUpManageListModel *)model remark:(NSString *)remark {
    NSString *defaultApi = [BASEURL stringByAppendingString:@"signupMessage/updateById.do"];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@(model.messageId) forKey:@"messageId"];
    [paramDic setObject:remark forKey:@"remarks"];
    // 备注和星标分隔开了 备注时不管星标  星标时不管备注
//    [paramDic setObject:@(-1) forKey:@"topFlag"];
    
    YSNLog(@"------%@", paramDic);
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"备注成功"];
                model.remarks = remark;
            }
                break;
            default:
                
                break;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}


#pragma mark -  添加或取消星标
- (void)starBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    SignUpManageListModel *model = self.listArray[sender.tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSString *remarkStr;
    if (model.remarks == nil || [model.remarks isEqualToString:@""]) {
        remarkStr = @"";
    } else {
        remarkStr = model.remarks;
    }
    if (model.topFlag) {
        [self remarkCalculateByModel:model indexPath:indexPath isStar:NO remark:remarkStr];
    } else {
        [self remarkCalculateByModel:model indexPath:indexPath isStar:YES remark:remarkStr];
    }
}

// 添加星标或取消星标
- (void)remarkCalculateByModel:(SignUpManageListModel *)model indexPath:(NSIndexPath *)indexPath isStar:(BOOL)isStar remark:(NSString *)remark {
    NSString *defaultApi = [BASEURL stringByAppendingString:@"signupMessage/updateById.do"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@(model.messageId) forKey:@"messageId"];
//    [paramDic setObject:remark forKey:@"remarks"];
    [paramDic setObject: isStar ? @(1): @(0) forKey:@"topFlag"];

    YSNLog(@"------%@", paramDic);
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                self.pageNum = 1;
                [self getData];
            }
                break;
            default:
                [[PublicTool defaultTool] publicToolsHUDStr:@"操作失败" controller:self sleep:1.0];
                [self.tableView setEditing:NO animated:YES];
                break;
        }
    } failed:^(NSString *errorMsg) {

    }];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SignUpManageListModel *model = self.listArray[indexPath.row];
    ActivityMessageCell *cell;
    if (model.type ==2 ) {
        // 美文活动
        cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityMessageCellSecond"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ActivityMessageCell" owner:nil options:nil][1];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityMessageCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ActivityMessageCell" owner:nil options:nil][0];
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    
    cell.beizhuTextView.delegate = self;
    cell.beizhuTextView.tag = indexPath.row;
    cell.tableView = self.tableView;
    // 判断文字是否超长
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:)name:@"UITextViewTextDidChangeNotification"
                                              object:cell.beizhuTextView];
    
    // 星标操作
    cell.starImageBtn.tag = indexPath.row;
    [cell.starImageBtn addTarget:self action:@selector(starBtnAction:) forControlEvents:UIControlEventTouchUpInside];


    cell.toviewBlock = ^(NSString *companyId)
    {
        [self popshowalert:companyId];
    };
    
    MJWeakSelf;
    cell.callBlock = ^(NSString *phoneNum) {
        
       // SignUpManageListModel *model = weakSelf.listArray[indexPath.row];
        
        if ([phoneNum containsString:@"****"]) {
            //[self popshowalert:[NSString stringWithFormat:@"%ld",(long)model.companyId]];
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"拨打电话" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@",phoneNum] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNum];
                UIWebView *callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
                
            }];
            
            [alert addAction:action];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:cancel];
            
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
       
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SignUpManageListModel *model = self.listArray[indexPath.row];
    EventdetailsVC *vc = [EventdetailsVC new];
    vc.state = Mytypemessage;

    vc.smodel = model;
    [self.navigationController pushViewController:vc animated:YES];
}
//是否允许编辑，默认值是YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignUpManageListModel *model = self.listArray[indexPath.row];
    //删除
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除提示" message:@"删除后不可恢复，请慎重！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [tableView setEditing:NO animated:YES];
        }];
        [alertC addAction:cancleAction];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteActivityByModel:model indexPath:indexPath];
            YSNLog(@"删除 了");
        }];
        [alertC addAction:sureAction];
        [self presentViewController:alertC animated:YES completion:nil];
        
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    //置顶
    // 星标 0没加星标，1加星标
//    @property (nonatomic, assign) NSInteger topFlag;
    NSString *title = (model.topFlag == 1) ? @"取消加星" : @"加星标";
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSString *remarkStr;
        if (model.remarks == nil || [model.remarks isEqualToString:@""]) {
            remarkStr = @"";
        } else {
            remarkStr = model.remarks;
        }
        if (model.topFlag) {
            [self remarkCalculateByModel:model indexPath:indexPath isStar:NO remark:remarkStr];
        } else {
            [self remarkCalculateByModel:model indexPath:indexPath isStar:YES remark:remarkStr];
        }
    }];
    topRowAction.backgroundColor = [UIColor lightGrayColor];
    
    
    
    return @[deleteRowAction, topRowAction];
}

#pragma mark - 设置按钮的点击事件
- (void)didClickSettingBtn:(UIButton *)btn {
    
    ZCHVoiceReportSettingController *settingVC = [UIStoryboard storyboardWithName:@"ZCHVoiceReportSettingController" bundle:nil].instantiateInitialViewController;
    settingVC.type = @"3";
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma LazyMethod
-(NSMutableArray*)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = Bottom_Color;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(PopupsViewDelegate *)popView
{
    if(!_popView)
    {
        _popView = [[PopupsViewDelegate alloc] initWithImage:@""];
        _popView.delegate = self;
        _popView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableSingleTap)];
        [_popView addGestureRecognizer:singleTap];
    }
    return _popView;
}

-(void)tableSingleTap
{
    [self.popView dismissAlertView];
}

#pragma mark - 协议方法

-(void)phoneclick:(NSInteger )index
{
    AdviserList *model = self.popView.dataSource[index];
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",model.adviserPhone];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
}
-(void)wxclick:(NSInteger )index
{
    [[PublicTool defaultTool] publicToolsHUDStr:@"复制成功" controller:self sleep:1.5];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    AdviserList *model = self.popView.dataSource[index];
    pasteboard.string = model.adviserWx;
    
}
-(void)qqclick:(NSInteger )index
{
    [[PublicTool defaultTool] publicToolsHUDStr:@"复制成功" controller:self sleep:1.5];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    AdviserList *model = self.popView.dataSource[index];
    pasteboard.string = model.adviserQq;
    
}

- (void)didSelectedCancel:(PopupsViewDelegate *)popView withImageName:(NSString *)imageName { 
    
}


-(void)popshowalert:(NSString *)companyId
{
    NSDictionary *para = @{@"companyId":companyId};
    self.popView.dataSource = [NSMutableArray array] ;
    NSString *url = [BASEURL stringByAppendingString:GET_ZHUANGXIUGUWEN];
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[AdviserList class] json:responseObj[@"adviserList"]]];
            [self.popView.dataSource addObjectsFromArray:data];
            [self.popView.collectionView reloadData];
            [self.popView showView];
        }else{
            SHOWMESSAGE(@"暂无专属顾问");
        }
        
    } failed:^(NSString *errorMsg) {
        
    }];
}



@end
