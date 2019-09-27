//
//  ActivitySignUpSettingController.m
//  iDecoration
//
//  Created by sty on 2017/10/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ActivitySignUpSettingController.h"
#import "ActivitySignUpSettingCell.h"

@interface ActivitySignUpSettingController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIAlertViewDelegate>{
    NSInteger deleteTag;
    NSInteger sureTag;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *shadowV;
@property (nonatomic, strong) UIView *addMuchUseAlertV;

@property (nonatomic, strong) UITextView *textView;


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *boolDataArray;
@end

@implementation ActivitySignUpSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"报名设置";
    self.dataArray = [NSMutableArray array];
    self.boolDataArray = [NSMutableArray array];
    if (self.setDataArray.count>0) {
        for (NSMutableDictionary *dict in self.setDataArray) {
            NSString *strOne = [dict objectForKey:@"customName"];
            NSString *strTwo = [dict objectForKey:@"isMust"];
            [self.dataArray addObject:strOne];
            [self.boolDataArray addObject:strTwo];
        }
    }
//    NSArray *array = @[@"家庭住址",@"座机号"];
//    [self.dataArray addObjectsFromArray:array];
    [self.view addSubview:self.tableView];
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(successBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }
    else{
        return self.dataArray.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return 44;
    }
    return 0.1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [[UITableViewHeaderFooterView alloc]init];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        UIView *view = [[UIView alloc]init];
        UIButton *successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        successBtn.frame = CGRectMake(0,0,kSCREEN_WIDTH,44);
        successBtn.backgroundColor = White_Color;
        [successBtn setTitle:@"+添加自定义填写项" forState:UIControlStateNormal];
        successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [successBtn setTitleColor:Red_Color forState:UIControlStateNormal];
        successBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        [successBtn addTarget:self action:@selector(addMuchUseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:successBtn];
        return view;
        
    }
    return [[UITableViewHeaderFooterView alloc]init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        NSString *cellIdendifier = @"sectionOne";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdendifier];
        }
        cell.contentView.backgroundColor = White_Color;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *array = @[@"姓名",@"手机号"];
        cell.textLabel.text = array[indexPath.row];
        cell.textLabel.font = NB_FONTSEIZ_NOR;
        return cell;
    }
    else{
        ActivitySignUpSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivitySignUpSettingCell"];
        cell.contentL.text = self.dataArray[indexPath.row];
        
        cell.deleteBtn.tag = indexPath.row;
        cell.sureBtn.tag = indexPath.row;
        cell.deleteBlock = ^(NSInteger tag) {
            deleteTag = tag;
            [self deleteContent];
        };
        cell.sureBlock = ^(NSInteger tag) {
            sureTag = tag;
            [self changeBtnState];
        };
        NSInteger boolTag = [self.boolDataArray[indexPath.row] integerValue];
        if (!boolTag) {
            cell.sureBtn.layer.borderColor = COLOR_BLACK_CLASS_9.CGColor;
        }
        else{
            cell.sureBtn.layer.borderColor = Red_Color.CGColor;
        }
            return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - action

-(void)successBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    if (self.dataArray.count>0) {
        NSMutableArray *array = [NSMutableArray array];
        
        for (int i = 0; i<self.dataArray.count; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSString *strOne = self.dataArray[i];
            NSString *strTwo = self.boolDataArray[i];
            [dict setObject:strOne forKey:@"customName"];
            [dict setObject:strTwo forKey:@"isMust"];
            [array addObject:dict];
        }
        if (self.SignUpBlock) {
            self.SignUpBlock(array);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSMutableArray *array = [NSMutableArray array];
        if (self.SignUpBlock) {
            self.SignUpBlock(array);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)addMuchUseBtnClick:(UIButton *)btn{
    [self showAlertView];
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

        _addMuchUseAlertV = [[UIView alloc]initWithFrame:CGRectMake(10, kSCREEN_HEIGHT-250-10-200, kSCREEN_WIDTH-20, 200)];
        if (isiPhoneX) {
            _addMuchUseAlertV.frame = CGRectMake(10, kNaviBottom+120, kSCREEN_WIDTH-20, 200);
        }
        _addMuchUseAlertV.backgroundColor = White_Color;
        _addMuchUseAlertV.layer.masksToBounds = YES;
        _addMuchUseAlertV.layer.cornerRadius = 10;
        [[UIApplication sharedApplication].keyWindow addSubview:_addMuchUseAlertV];
        
        UILabel *temAddL = [[UILabel alloc]initWithFrame:CGRectMake(0,0,self.addMuchUseAlertV.width, 60)];
        temAddL.text = @"新建自定义项";
        temAddL.textColor = COLOR_BLACK_CLASS_3;
        temAddL.textAlignment = NSTextAlignmentCenter;
        temAddL.font = NB_FONTSEIZ_NOR;
        [self.addMuchUseAlertV addSubview:temAddL];
        
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
}

-(void)shadowDismiss{
    self.shadowV.hidden = YES;
    self.addMuchUseAlertV.hidden = YES;
    [self.textView endEditing:YES];
}

-(void)cancelBtnClick{
    self.textView.text = @"";
    [self shadowDismiss];
}

-(void)sureBtnClick{
    self.textView.text = [self.textView.text ew_removeSpaces];
    if (self.textView.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"添加项不能为空" controller:self sleep:2.0];
        return;
    }
    
    
    [self.dataArray addObject:self.textView.text];
    [self.boolDataArray addObject:@"1"];
    self.textView.text = @"";
    [self shadowDismiss];
    [self.tableView reloadData];
}

-(void)deleteContent{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否确认删除该项？"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)changeBtnState{
    NSInteger boolTag = [self.boolDataArray[sureTag] integerValue];
    if (!boolTag) {
        boolTag = 1;
    }
    else{
        boolTag = 0;
    }
    NSString *str = [NSString stringWithFormat:@"%ld",(long)boolTag];
    [self.boolDataArray replaceObjectAtIndex:sureTag withObject:str];
    [self.tableView reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self.dataArray removeObjectAtIndex:deleteTag];
        [self.tableView reloadData];
    }
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = kBackgroundColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"ActivitySignUpSettingCell" bundle:nil] forCellReuseIdentifier:@"ActivitySignUpSettingCell"];
        
        //        _tableView.tableFooterView = [[UIView alloc] init];
        //        _tableView.separatorColor = kSepLineColor;
    }
    return _tableView;
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
