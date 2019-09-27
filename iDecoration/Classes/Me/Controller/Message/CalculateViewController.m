//
//  CalculateViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/6/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CalculateViewController.h"
#import "CalculateCell.h"
#import "CalculateModel.h"
#import "NSObject+CompressImage.h"
#import "ZCHVoiceReportSettingController.h"
#import "ZCHCalculatorPayController.h"
#import "VipGroupViewController.h"
#import "AdviserList.h"
#import "PopupsViewDelegate.h"

// 备注最多输入30个字
#define kMaxLength 30


@interface CalculateViewController ()<UITableViewDelegate, UITableViewDataSource, CalculateCellDelegate, UITextViewDelegate,POAlertViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
// 列表数组
@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) PopupsViewDelegate *popView;
@end

@implementation CalculateViewController
#pragma LifeMethod

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSObject promptWithControllerName:@"CalculateViewController"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self addRightItem];
    // 收到通知刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:kReciveRemoteNotification object:nil];
    
    [self createUI];
    
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshData:(NSNotification *)noti {
    if ([noti.userInfo[@"messageType"] integerValue] == 4) {
        [self getData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NormalMethod

-(void)createUI{
    
    self.title = @"计算报价";
}

// 获取数据列表
- (void)getData {
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    NSString *defaultApi = [BASEURL stringByAppendingString:@"calculatorCustomer/getListByAgencyId.do"];
    NSString *pageNumstr = [NSString stringWithFormat:@"%ld", self.pageNum];
    NSDictionary *paramDic = @{
                               @"agencyId":@(agencyid),
                               @"pageSize":@"10",
                               @"pageNo": pageNumstr
                               };
    
    MJWeakSelf
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(NSDictionary *responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        // 加载成功
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        
        if (code == 1000) {
            NSDictionary *dataDict = [responseObj objectForKey:@"data"];
            NSArray *listArray = [dataDict objectForKey:@"list"];
            if (weakSelf.pageNum == 1) {
                [weakSelf.listArray removeAllObjects];
                for (NSDictionary *dict in listArray) {
                    CalculateModel *calculateModel = [CalculateModel yy_modelWithJSON:dict];
                    if (![weakSelf.listArray containsObject:calculateModel]) {
                        [weakSelf.listArray addObject:calculateModel];
                    }
                }
            } else {
                if (listArray.count > 0) {
                    for (NSDictionary *dict in listArray) {
                        CalculateModel *calculateModel = [CalculateModel yy_modelWithJSON:dict];
                        if (![weakSelf.listArray containsObject:calculateModel]) {
                            [weakSelf.listArray addObject:calculateModel];
                        }
                    }
                }
            }
            
            [weakSelf.tableView reloadData];
            
        } else {
            
        }
        
        if (weakSelf.pageNum == 1) {
            [weakSelf.tableView.mj_header endRefreshing];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
        YSNLog(@"%@", NETERROR);
        //加载失败
    }];
}

- (void)deleteCalculateByModel:(CalculateModel *)model indexPath:(NSIndexPath *)indexPath {
    NSString *defaultApi = [BASEURL stringByAppendingString:@"calculatorCustomer/getDelete.do"];
    NSDictionary *paramDic = @{
                               @"customerId":model.customerId,
                               };
    YSNLog(@"------%@", paramDic);
    MJWeakSelf;
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"删除成功"];
                [weakSelf.listArray removeObjectAtIndex:indexPath.row];
                [weakSelf.tableView reloadData];
            }
                break;
                
            default:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"删除失败"];
                [weakSelf.tableView setEditing:NO animated:YES];
                break;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}


#pragma mark - textViewDelegate
// textview 高度变化
- (void)textViewDidChange:(UITextView *)textView {
    NSIndexPath *indexP = [NSIndexPath indexPathForRow:textView.tag inSection:0];
    CalculateCell *cell = [self.tableView cellForRowAtIndexPath:indexP];
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), CGFLOAT_MAX)];
    CGFloat height = size.height;
    if (height < 30) {
        cell.beizhuTVHeightCon.constant = 30;
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
    CalculateCell *cell = [self.tableView cellForRowAtIndexPath:indexP];
    
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

    CalculateModel *calModel = self.listArray[textView.tag];
    // 备注
    [self remarkCalculatSecondeByModel:calModel remark:textView.text];

}

// 添加备注
- (void)remarkCalculatSecondeByModel:(CalculateModel *)model remark:(NSString *)remark {
    NSString *defaultApi = [BASEURL stringByAppendingString:@"cblejcalculatorcustomermanagers/setMark.do"];
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *agecyId = [NSString stringWithFormat:@"%ld", userModel.agencyId];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:model.customerManagerId forKey:@"customerManagerId"];
    [paramDic setObject:agecyId forKey:@"agencyId"];
    if ([model.customerId isEqualToString:@""] || model.customerId == nil) {
        [paramDic setObject:@"" forKey:@"customerId"];
    } else {
        [paramDic setObject:model.customerId forKey:@"customerId"];
    }
    [paramDic setObject:remark forKey:@"remark"];
    [paramDic setObject:@"1" forKey:@"isRead"];
    [paramDic setObject:model.isStar forKey:@"isStar"];
    
    YSNLog(@"------%@", paramDic);
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
            {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"备注成功"];
                model.remark = remark;
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
    CalculateModel *model = self.listArray[sender.tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSString *remarkStr;
    if (model.remark == nil || [model.remark isEqualToString:@""]) {
        remarkStr = @"";
    } else {
        remarkStr = model.remark;
    }
    if (model.isStar.integerValue) {
        [self remarkCalculateByModel:model indexPath:indexPath isStar:NO remark:remarkStr];
    } else {
        [self remarkCalculateByModel:model indexPath:indexPath isStar:YES remark:remarkStr];
    }
}

// 添加星标或取消星标
- (void)remarkCalculateByModel:(CalculateModel *)model indexPath:(NSIndexPath *)indexPath isStar:(BOOL)isStar remark:(NSString *)remark {
    NSString *defaultApi = [BASEURL stringByAppendingString:@"cblejcalculatorcustomermanagers/setMark.do"];
    UserInfoModel *userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *agecyId = [NSString stringWithFormat:@"%ld", userModel.agencyId];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:model.customerManagerId forKey:@"customerManagerId"];
    [paramDic setObject:agecyId forKey:@"agencyId"];
    if ([model.customerId isEqualToString:@""] || model.customerId == nil) {
        [paramDic setObject:@"" forKey:@"customerId"];
    } else {
        [paramDic setObject:model.customerId forKey:@"customerId"];
    }
    [paramDic setObject:remark forKey:@"remark"];
    [paramDic setObject:@"1" forKey:@"isRead"];
    [paramDic setObject:[NSString stringWithFormat:@"%@", isStar? @"1": @"0"] forKey:@"isStar"];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CalculateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalculateCell" forIndexPath:indexPath];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    

    cell.beizhuTextView.delegate = self;
    cell.beizhuTextView.tag = indexPath.row;
    
    
    CalculateModel *cModel = self.listArray[indexPath.row];
    cell.model = cModel;
    cell.delegate = self;
    cell.tableView = self.tableView;

    
    // 判断文字是否超长
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:)name:@"UITextViewTextDidChangeNotification"
                                              object:cell.beizhuTextView];
    
    // 星标操作
    cell.starImageBtn.tag = indexPath.row;
    [cell.starImageBtn addTarget:self action:@selector(starBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

//是否允许编辑，默认值是YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalculateModel *model = self.listArray[indexPath.row];
    //删除
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除提示" message:@"删除后不可恢复，请慎重！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [tableView setEditing:NO animated:YES];
        }];
        [alertC addAction:cancleAction];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteCalculateByModel:model indexPath:indexPath];
            YSNLog(@"删除 了");
        }];
        [alertC addAction:sureAction];
        [self presentViewController:alertC animated:YES completion:nil];
        
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    //置顶
    NSString *title = model.isStar.integerValue ? @"取消加星" : @"加星标";
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSString *remarkStr;
        if (model.remark == nil || [model.remark isEqualToString:@""]) {
            remarkStr = @"";
        } else {
            remarkStr = model.remark;
        }
        if (model.isStar.integerValue) {
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
    settingVC.type = @"1";
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - CalculateCellDelegate
- (void)calculateCell:(CalculateCell *)cell callButtton:(UIButton *)callBtn phoneNumber:(NSString *)phoneNum {
    NSIndexPath *indexP = [self.tableView indexPathForCell:cell];
    CalculateModel *model = self.listArray[indexP.row];
    
    if ([model.customerPhone containsString:@"****"])
    {
        // [self popshowalert:model.companyId];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"拨打电话" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:phoneNum?:@"" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNum];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            
        }];
        
        [alert addAction:action];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"CalculateCell" bundle:nil] forCellReuseIdentifier:@"CalculateCell"];
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

#pragma mark - newDelegate

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

-(void)popshowalert:(NSString *)companyId
{
    NSDictionary *para = @{@"companyId":companyId};
    self.popView.dataSource = [NSMutableArray array] ;
    NSString *url = [BASEURL stringByAppendingString:GET_ZHUANGXIUGUWEN];
    [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[AdviserList class] json:responseObj[@"adviserList"]]];
            [self.popView.dataSource addObjectsFromArray:data];
        }
        [self.popView showView];
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)myTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *indexP = [self.tableView indexPathForCell:cell];
    CalculateModel *model = self.listArray[indexP.row];
    [self popshowalert:model.companyId];
}

@end
