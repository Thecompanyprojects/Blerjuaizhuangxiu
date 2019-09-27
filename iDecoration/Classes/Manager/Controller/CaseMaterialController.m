//
//  CaseMaterialController.m
//  iDecoration
//
//  Created by Apple on 2017/5/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CaseMaterialController.h"
#import "ShopDetailBottomCell.h"
#import "CaseMaterialModel.h"
#import "SearchCaseMaterialCell.h"

@interface CaseMaterialController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation CaseMaterialController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    [self creatUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChangeddddd:)name:@"UITextFieldTextDidChangeNotification"
                                              object:self.searchTF];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)creatUI{
    
    if (self.fromIndex==1) {
        self.title = @"添加主材商家";
    }
    else{
        self.title = @"添加施工日志";
    }
    self.view.backgroundColor = White_Color;
    
    [self.view addSubview:self.searchTF];
    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    if (indexPath.section == 0) {
    //        return 100;
    //    }else{
    return 61;
    //    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCaseMaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCaseMaterialCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configData:self.dataArray[indexPath.row]];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self addCaseMaterialWith:indexPath.row];
}



-(void)textFieldEditChangeddddd:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = self.searchTF.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage ; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            toBeString = [toBeString stringByReplacingOccurrencesOfString:@" " withString:@""];
            toBeString = [toBeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (toBeString.length == 10) {
//                textField.text = [toBeString substringToIndex:kMaxLength];
                [self.view endEditing:YES];
                [self searchClick];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        toBeString = [toBeString stringByReplacingOccurrencesOfString:@" " withString:@""];
        toBeString = [toBeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (toBeString.length == 10) {
//            textField.text = [toBeString substringToIndex:kMaxLength];
            [self.view endEditing:YES];
            [self searchClick];
        }
    }
}




#pragma mark - 添加本案主材或施工日志

-(void)addCaseMaterialWith:(NSInteger)tag{
    [self.view hudShow];
    CaseMaterialModel *model = self.dataArray[tag];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"journalMaterial/save.do"];
    NSDictionary *paramDic = @{@"companyId":model.companyId,
                               @"constructionId":@(self.consID),
                               @"materialConstructionId":model.constructionId,
                               @"agencysId":@(user.agencyId),
                               @"jobType":@(self.cJobTypeId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"添加成功" controller:self sleep:1.5];
                    if (self.fromIndex==1) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCaseMSucess" object:nil];
                    }
                    else{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddShopMCaseMSucess" object:nil];
                    }
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                    break;
                    
                case 1002:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"当前工地已经关联过该商家" controller:self sleep:1.5];
                }
                    break;
                    
                default:
                    [[PublicTool defaultTool] publicToolsHUDStr:@"添加失败" controller:self sleep:1.5];
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - 根据工单号搜索主材日志
-(void)searchClick{
    [self.dataArray removeAllObjects];
    [self.view endEditing:YES];
    [self.view hudShow];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/serchConstructionNo.do"];
    NSDictionary *paramDic = @{@"constructionNo":self.searchTF.text
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                    if ([[responseObj[@"data"] objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                        NSArray *array = [responseObj[@"data"] objectForKey:@"list"];
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialModel class] json:array];
                        [self.dataArray addObjectsFromArray:arr];
                        //
                        //                        NSArray *arr2 = [NSArray yy_modelArrayWithClass:[AreaListModel class] json:[dic objectForKey:@"areaList"]];
                        //                        [self.areaArray addObjectsFromArray:arr2];
                        //
                        //                        //刷新数据
                        [self.tableView reloadData];
                    
                    };
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                case 1002:
                    
                    [[PublicTool defaultTool] publicToolsHUDStr:@"该工地编号不存在" controller:self sleep:1.5];
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                default:
                    [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - setter

-(UITextField *)searchTF{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(10, self.navigationController.navigationBar.bottom+6, kSCREEN_WIDTH-20, 36)];
        _searchTF.delegate = self;
        _searchTF.backgroundColor = White_Color;
        _searchTF.layer.borderColor = Bottom_Color.CGColor;
        _searchTF.layer.cornerRadius = 5;
        _searchTF.layer.borderWidth = 1;
        _searchTF.font = [UIFont systemFontOfSize:14];
        //    self.searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.placeholder = @"请输入工单号搜索";
        
    }
    return _searchTF;
}

-(UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(kSCREEN_WIDTH-30-10-10, self.searchTF.top+(6), 24, 24);
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.searchTF.bottom+10,kSCREEN_WIDTH,kSCREEN_HEIGHT-self.searchTF.bottom-10) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"SearchCaseMaterialCell" bundle:nil] forCellReuseIdentifier:@"SearchCaseMaterialCell"];
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
