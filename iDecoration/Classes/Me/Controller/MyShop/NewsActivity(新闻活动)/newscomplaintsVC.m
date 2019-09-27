//
//  newscomplaintsVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "newscomplaintsVC.h"
#import "SinglePickerView.h"
#import "newstousuCell0.h"
#import "newstousuCell1.h"
#import "newstousuCell2.h"
#import "CGXPickerView.h"


@interface newscomplaintsVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,copy) NSString *complainType;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *complainDescribe;
@end

static NSString *newscomplaintidentfid0 = @"newscomplaintidentfid0";
static NSString *newscomplaintidentfid1 = @"newscomplaintidentfid1";
static NSString *newscomplaintidentfid2 = @"newscomplaintidentfid2";

@implementation newscomplaintsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"投诉";
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.table];
    self.table.tableFooterView = [UIView new];
    
    self.complainType = [NSString new];
    self.phone = [NSString new];
    self.complainDescribe = [NSString new];
    self.complainType = @"请选择投诉类型";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom) style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.backgroundColor = kBackgroundColor;
    }
    return _table;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        newstousuCell0 *cell = [tableView dequeueReusableCellWithIdentifier:newscomplaintidentfid0];
        if (!cell) {
            cell = [[newstousuCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newscomplaintidentfid0];
        }
        cell.contentLab.tag = 201;
        cell.contentLab.text = self.complainType;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row==1) {
        newstousuCell1 *cell = [tableView dequeueReusableCellWithIdentifier:newscomplaintidentfid1];
        if (!cell) {
            cell = [[newstousuCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newscomplaintidentfid1];
        }
        cell.phoneText.tag = 202;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row==2) {
        newstousuCell2 *cell = [tableView dequeueReusableCellWithIdentifier:newscomplaintidentfid2];
        if (!cell) {
            cell = [[newstousuCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newscomplaintidentfid2];
        }
        cell.contentText.tag = 203;
        [cell.submitBtn addTarget:self action:@selector(submitbtnclick) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [CGXPickerView showStringPickerWithTitle:@"类型" DataSource:@[@"欺诈", @"色情", @"违法犯罪", @"骚扰", @"违规声明原创", @"其他",@"侵权（冒充他人，侵犯名誉等）"] DefaultSelValue:@"欺诈" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue);
            __weak typeof (self) weakSelf = self;
            weakSelf.complainType = selectValue;
            [weakSelf.table reloadData];
        }];
    }
}

#pragma mark - 投诉实现方法

-(void)submitbtnclick
{
    NSString *complainFrom = @"8";
    
    UITextField *text1 = [self.table viewWithTag:202];
    UITextView *text2 = [self.table viewWithTag:203];
    self.phone = text1.text;
    self.complainDescribe = text2.text;
    
    if (IsNilString(self.complainType)||[self.complainType isEqualToString:@"请选择投诉类型"]) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请选择投诉类型" controller:self sleep:1.5];
        return;
    }
    if (IsNilString(self.phone)||![[PublicTool defaultTool] publicToolsCheckTelNumber:self.phone]) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入正确的手机号" controller:self sleep:1.5];
        return;
    }

    else
    {
            
            if (IsNilString(self.complainDescribe)) {
                 [[PublicTool defaultTool] publicToolsHUDStr:@"请输入描述内容" controller:self sleep:1.5];
            }
            else
            {
                NSDictionary *para = @{@"companyId":self.companyId,@"complainType":self.complainType,@"phone":self.phone,@"complainDescribe":self.complainDescribe,@"complainFrom":complainFrom};
                NSString *url = [BASEURL stringByAppendingString:@"complaint/save.do"];

                [NetManager afGetRequest:url parms:para finished:^(id responseObj) {
                    
                    [[PublicTool defaultTool] publicToolsHUDStr:@"您的投诉信息已提交，如有问题请与客服联系" controller:self.navigationController sleep:1.5];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } failed:^(NSString *errorMsg) {
                    
                }];
                
            }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 35;
    }
    if (indexPath.row==1) {
        return 35;
    }
    if (indexPath.row==2) {
        return 300;
    }
    return 0.01f;
}

@end
