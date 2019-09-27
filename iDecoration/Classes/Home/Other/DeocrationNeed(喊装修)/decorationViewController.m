//
//  decorationViewController.m
//  iDecoration
//
//  Created by 涂晓雨 on 2017/8/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "decorationViewController.h"
#import "decorationTextField.h"
#import "RegionView.h"
#import "PModel.h"
#import "CModel.h"
#import "DModel.h"

#import "WWPickerView.h"

#define textFieldHeigh  50
@interface decorationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UITableView *table;

@property (nonatomic, strong) RegionView *regionView;
@property (nonatomic, strong) PModel *pmodel;
@property (nonatomic, strong) CModel *cmodel;
@property (nonatomic, strong) DModel *dmodel;
@property (nonatomic, copy) NSString *addressStr;//地址

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIPickerView *pickView;

@property(nonatomic,strong)NSArray *itemArray;


//记录选择的cell
@property(nonatomic,assign)NSInteger  index;

//记录选择的item
@property(nonatomic,copy)NSString *itemStr;


//手机号
@property(nonatomic,strong)decorationTextField *phone;
//备用手机号
@property(nonatomic,strong)decorationTextField *phone1;

//存放参数的字典
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@end

@implementation decorationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"免费发布装修需求";
    
    [self creatTable];

    
}

-(void)creatTable{

    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, kSCREEN_WIDTH, kSCREEN_HEIGHT + 20) style:UITableViewStyleGrouped];
    
    self.table.backgroundColor = [UIColor whiteColor];
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.table.delegate = self;
    
    self.table.dataSource = self;
    
    [self.view addSubview:self.table];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 8) {
        return 100;
    }
    return 54;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 35;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH - 20, 44)];
    label.text = @"信息提交成功后，由本公司客服与您对接";
    label.font = NB_FONTSEIZ_NOR;
    label.textColor = [UIColor lightGrayColor];
    
    [v addSubview:label];
    return v;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 9;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSArray *arr = @[@"请输入您的姓名",@"",@"请输入您要装修房屋的类型",@"请选择您的装修地区",@"请输入您要装修房屋的面积",@"请选择不包括家具、电器的预算",@"请选择您要装修房屋的时间",@"",@""];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
   
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 8) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in self.areaList) {
            NSArray *strArr = [dic[@"retion"]  componentsSeparatedByString:@" "];
            [arr addObject:strArr[1]];
        }
        
        cell.textLabel.font = NB_FONTSEIZ_NOR;
        cell.textLabel.numberOfLines = 0;
    
        cell.textLabel.textColor = [UIColor lightGrayColor];
        if (arr.count != 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"公司的接单区域:\n北京市 %@",[arr componentsJoinedByString:@"、"]];  
        }
   
    }

    
    if (indexPath.row != 1 && indexPath.row != 7 && indexPath.row != 8) {
        
        decorationTextField *text = [[decorationTextField alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, textFieldHeigh)];
        text.textField.placeholder = arr[indexPath.row];
        text.textField.delegate = self;
        [cell.contentView addSubview:text];
    
        if (indexPath.row == 0 || indexPath.row == 4) {
            
            text.rightButton.hidden = YES;
            
        }else{
        
            text.textField.enabled = NO;
        }
        
        if (indexPath.row == 4) {
            text.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
      
    }
    
    
  //手机号
    if (indexPath.row == 1) {
       
        [cell addSubview:[self TextView]];
        
    }
    
    //提交按钮
    if (indexPath.row == 7) {
        
        [cell.contentView addSubview:[self submitButton]];
    }
    
    return cell;
}


#pragma mark 输入电话
-(UIView *)TextView{

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, textFieldHeigh)];
    
    decorationTextField *textFiled1 = [[decorationTextField alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH/2, bgView.height)];
    textFiled1.textField.delegate = self;
    textFiled1.textField.placeholder = @"请输入手机号";
    textFiled1.textField.keyboardType = UIKeyboardTypeNumberPad;
    textFiled1.rightButton.hidden = YES;
    self.phone = textFiled1;
    [bgView addSubview:textFiled1];
    
    
    decorationTextField *textField2 = [[decorationTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textFiled1.frame), 0, textFiled1.width, bgView.height)];
    textField2.textField.delegate = self;
    textField2.textField.keyboardType = UIKeyboardTypeNumberPad;
    textField2.textField.placeholder = @"备用联系方式";
    
    textField2.rightButton.hidden = YES;
    self.phone1 = textField2;
    [bgView addSubview:textField2];

    return bgView;

}

#pragma mark 提交按钮
-(UIButton *)submitButton{

    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, kSCREEN_WIDTH - 20, 40)];
    
    btn.backgroundColor = [UIColor colorWithRed:68/255.0 green:190/255.0 blue:134/255.0 alpha:1.0];
    btn.titleLabel.font = NB_FONTSEIZ_NOR;
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn setTitle:@"立即提交" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(submitData:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    self.index = indexPath.row + 1000;
    
    self.regionView.hidden = YES;
    //装修的房屋类型
    if (indexPath.row == 2) {
        
        self.itemArray = @[@"旧房翻新",@"新房装修",@"店铺装修",@"办公司装修",@"餐厅装修",@"其他"];
       
        [self chooseItem];
    }
    
    //装修地区
    if (indexPath.row == 3) {
      
        [self getRegion];
        
    }
    
    //预算
    if (indexPath.row == 5) {
      
        self.itemArray = @[@"3万以下",@"3-5万",@"5-8万",@"8-12万",@"12-18万",@"18-25万",@"25-30万",@"30万以上"];
        
        [self chooseItem];
        
      
    }
    
    //选择装修房屋的时间
    if (indexPath.row == 6) {
        
        self.itemArray = [self chooseTime];
        [self chooseItem];
    }
    


}



-(RegionView *)regionView{
    
    if (!_regionView) {
        _regionView = [[RegionView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-305, kSCREEN_WIDTH, 305)];
        _regionView.closeBtn.hidden = NO;

        _regionView.hidden = YES;
        
        [self.view addSubview:_regionView];
    }
    return _regionView;
}

#pragma mark 地区的选择
-(void)getRegion{
    
    self.regionView.hidden = NO;
    self.bgView.hidden = YES;
    __weak decorationViewController  *weakSelf = self;
    
    self.regionView.selectBlock = ^(NSMutableArray *array){
        
        weakSelf.regionView.hidden = YES;
        weakSelf.pmodel = [array objectAtIndex:0];
        weakSelf.cmodel = [array objectAtIndex:1];
        weakSelf.dmodel = [array objectAtIndex:2];
        
        weakSelf.addressStr = [NSString stringWithFormat:@"%@ %@ %@",weakSelf.pmodel.name,weakSelf.cmodel.name,weakSelf.dmodel.name];
        NSInteger regionId = [weakSelf.pmodel.regionId integerValue];
        
        [weakSelf.dataDic  setObject:weakSelf.pmodel.name forKey:@"sheng"];
        [weakSelf.dataDic  setObject:weakSelf.cmodel.name forKey:@"shi"];
        [weakSelf.dataDic  setObject:weakSelf.dmodel.name forKey:@"qu"];
        
        
        if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000)//四个直辖市只传省和市
        {
            weakSelf.addressStr = [NSString stringWithFormat:@"%@ %@",weakSelf.pmodel.name,weakSelf.dmodel.name];
            [weakSelf.dataDic  setObject:@"" forKey:@"sheng"];
        }
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:3 inSection:0];
     
        UITableViewCell *cell = [weakSelf.table cellForRowAtIndexPath:path];
        
        for (decorationTextField *textView in cell.contentView.subviews) {
    
                textView.textField.text = weakSelf.addressStr;
            
        }
        
        //地址最后一级的编号
        [weakSelf.dataDic  setObject:weakSelf.dmodel.regionId forKey:@"cityNumber"];
        
    };
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{

    self.regionView.hidden = YES;

    self.bgView.hidden = YES;
}



-(UIPickerView*)pickView{

    if (!_pickView) {
        _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,44, kSCREEN_WIDTH, _bgView.height - 44)];
        _pickView.dataSource = self;
        _pickView.delegate = self;
        [self.bgView addSubview:_pickView];
    }
    return _pickView;
    

}

-(UIView *)bgView{

    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 305, kSCREEN_WIDTH, 305)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self creatHeadView];
        [self.view addSubview:_bgView];
    }

    return _bgView;
}

-(void)creatHeadView{

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    headerView.backgroundColor = [UIColor colorWithRed:68/255.0 green:190/255.0 blue:134/255.0 alpha:1.0];
    [self.bgView addSubview:headerView];

    //取消
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH/4, 44)];
    [cancelBtn  setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancelBtn];
    
    //确定
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH* 3/4, 0, kSCREEN_WIDTH/4, 44)];
    [sureBtn  setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];

    [headerView addSubview:sureBtn];
}
#pragma mark  其他选项
-(void)chooseItem{

    self.bgView.hidden = NO;
    self.regionView.hidden = YES;
    
    [self.pickView reloadAllComponents];
}

#pragma mark UIPickViewController   dataSorce   delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return self.itemArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    self.itemStr = self.itemArray[row];
    return self.itemArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    self.itemStr = self.itemArray[row];

}


#pragma mark pickView   取消按钮监听事件
-(void)cancel{

    self.bgView.hidden = YES;

}

#pragma mark pickView   确定按钮监听事件
-(void)sure:(UIButton *)sender{

    NSInteger row = self.index - 1000;
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
    
    UITableViewCell *cell = [self.table cellForRowAtIndexPath:path];
    
    for (decorationTextField *textView in cell.contentView.subviews) {
        
        textView.textField.text = self.itemStr;
        
    }
    self.bgView.hidden = YES;

}



#pragma mark  数据获取
-(NSArray *)getAllData{
  
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i = 0; i <= 6; i++) {
        
        if (i == 1) {
            continue;
        }
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        
        UITableViewCell *cell = [self.table cellForRowAtIndexPath:path];
        
        for (decorationTextField *textView in cell.contentView.subviews) {
            
            [arr addObject:textView.textField.text];
            
        }
        
    }
    return arr;
 


}


#pragma mark  网络请求
-(void)submitData:(UIButton *)sender{

    
    NSArray  *dataArray = [self getAllData];
    NSArray *keyArray = @[@"name",@"houseType",@"",@"areaHouse",@"pay",@"houseDate"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i = 0; i < dataArray.count; i ++) {
        
        if ([dataArray[i] length] == 0) {
            [self tips:i];
            return;
        }
        if (i != 2) {
            
            [self.dataDic  setObject:dataArray[i] forKey:keyArray[i]];
        }
       
    }
    
    if (self.phone.textField.text.length >0) {
        
        if (![self checkTelNumber:self.phone.textField.text]) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的手机号"];
            return;
        }
        
        [self.dataDic  setObject:self.phone.textField.text forKey:@"phone"];
        
    }else{
    
       [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入手机号"];
        return;
    }
    
    if (self.phone1.textField.text.length > 0 && ![self checkTelNumber:self.phone1.textField.text]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的备用手机号"];
        return;
    }
    
    if (self.phone1.textField.text.length > 0) {
        [self.dataDic  setObject:self.phone1.textField.text forKey:@"elephone"];
    }else{
    
       [self.dataDic  setObject:@"" forKey:@"elephone"];
    }
    
    [self.dataDic  setObject:self.companyID forKey:@"companyId"];
    //第一次提交
    [self.dataDic setObject:@(0) forKey:@"type"];
    
    //获取当前的时间
    NSDate *date = [NSDate  date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:date];
    [self.dataDic setObject:currentTime forKey:@"dingdate"];
    //数据提交   网络请求
    [self.view hudShow];
    [self upDataRequest:self.dataDic];

}

#pragma mark 提示语
-(void)tips:(NSInteger)index{

    switch (index) {
        case 0:
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入姓名"];
            break;
        case 1:
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择装修房屋的类型"];
            break;
        case 2:
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择装修的区域"];
            break;
        case 3:
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入装修的面积"];
            break;
        case 4:
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择装修的预算"];
            break;
        case 5:
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请选择装修的时间"];
            break;
        default:
            break;
    }
}

#pragma 正则匹配手机号
- (BOOL)checkTelNumber:(NSString *) telNumber
{
//    NSString *pattern = @"^1+[3578]+\\d{9}";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    BOOL isMatch = [pred evaluateWithObject:telNumber];
//    return isMatch;
    NSString *str1 = [telNumber substringToIndex:1];//截取掉下标1之前的字符串
    if (telNumber.length==11&&[str1 isEqualToString:@"1"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}


#pragma mark 装修时间的选择
-(NSArray *)chooseTime{

    NSMutableArray *arr = [NSMutableArray array];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //获取当前的月份
    [formatter  setDateFormat:@"MM"];
    int mMonth = [[formatter stringFromDate:date] intValue];
    
    //获取当前的日期
    [formatter  setDateFormat:@"dd"];
    NSInteger mDay = [[formatter stringFromDate:date] integerValue];
    
    int num=0;
    int optionnum=0;
    
    NSString *text;
    
    for(int i = mMonth;i <= mMonth+3;i++){
        num=i;
        if (i>12){
            num-=12;
        }
        
        if (num==mMonth){
            if (mDay<=10){
                text = [NSString stringWithFormat:@"%d月中旬",num];
                optionnum+=1;
                [arr addObject:text];
            }
            if (mDay<=20){
                text=[NSString stringWithFormat:@"%d月下旬",num];
                optionnum+=1;
                [arr addObject:text];
            }
        }else{
            if (optionnum<9){
                text=[NSString stringWithFormat:@"%d月上旬",num];
                optionnum+=1;
                [arr addObject:text];
            }
            if (optionnum<9){
                text=[NSString stringWithFormat:@"%d月中旬",num];
                optionnum+=1;
                [arr addObject:text];
            }
            if (optionnum<9){
                text=[NSString stringWithFormat:@"%d月下旬",num];;
                optionnum+=1;
                [arr addObject:text];
            }
        }
    }


    return arr;
}


-(NSMutableDictionary *)dataDic{

    if (!_dataDic) {
        
        _dataDic = [NSMutableDictionary dictionary];
    }

    return _dataDic;
}

#pragma mark  接口
-(void)upDataRequest:(NSDictionary *)dic{

    NSString *url = [BASEURL stringByAppendingString:@"hanzhuangxiu/hanzhuangxiu.do"];

    __weak typeof(self)  weakSelf = self;
    [NetManager  afGetRequest:url parms:dic finished:^(id responseObj) {
        [weakSelf.view hiddleHud];
        YSNLog(@"%@",responseObj);
        switch ([responseObj[@"code"] integerValue]) {
        //喊装修成功
            case 1000:
               
                [weakSelf  successTips];
                
                break;
            case 1001:
                [weakSelf  replySubmit];
                break;
//            本月已喊过装修
            case 1002:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您本月已经预约过了"];
                break;
//            不在装修区域
            case 1003:
                [self replySubmit];
                break;
//             该区域暂无接单公司
            case 1004:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该区域内无接单的公司"];
                break;
            default:
                break;
        }
        
    } failed:^(NSString *errorMsg) {
    [weakSelf.view hiddleHud];
       [[UIApplication sharedApplication].keyWindow hudShowWithText:@"网络出错"];
    }];
}

#pragma mark 喊装修成功提示语
-(void)successTips{


    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"您喊装修成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [aler addAction:action];
    
    [self presentViewController:aler animated:YES completion:nil];
}

#pragma mark   不在装修区域  是否继续提交
-(void)replySubmit{
//该地区不在装修公司服务区域，继续提交，我们会为您提供本地区优秀公司服务，是否继续提交？
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"该地区不在装修公司服务区域，继续提交，我们会为您提供本地区优秀公司服务，是否继续提交？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
   
    __weak typeof(self)  weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"提交" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.dataDic setObject:@(1) forKey:@"type"];
        
        [weakSelf upDataRequest:self.dataDic];
    }];
    
    
    [aler addAction:action];
    [aler addAction:action1];
    [self presentViewController:aler animated:YES completion:nil];
}
@end
