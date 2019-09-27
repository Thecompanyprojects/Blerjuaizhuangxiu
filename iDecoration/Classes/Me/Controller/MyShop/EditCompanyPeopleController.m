//
//  EditCompanyPeopleController.m
//  iDecoration
//
//  Created by Apple on 2017/5/24.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "EditCompanyPeopleController.h"
#import "CategoryViewController.h"

@interface EditCompanyPeopleController ()
{
    NSDictionary *_jobDict;
}
@property (nonatomic, strong) UIImageView *photoV;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *jobL;
@property (nonatomic, strong) UIView *lineV;
@property (nonatomic, strong) UIButton *jobSelectBtn;
@end

@implementation EditCompanyPeopleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(success) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
}

-(void)creatUI{

    self.title = @"编辑人员";
    self.view.backgroundColor = White_Color;
    [self.view addSubview:self.photoV];
    [self nameL];
    [self jobL];
    [self.view addSubview:self.lineV];
    [self jobSelectBtn];
    [self datawithModel];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetBtnTitle:) name:@"companyPeopleAddNoti" object:nil];
}

-(void)datawithModel{
    [self.photoV sd_setImageWithURL:[NSURL URLWithString:self.model.photo] placeholderImage:[UIImage imageNamed:DefaultManPic]];
    self.nameL.text = self.model.agencysName;
    self.jobL.text = self.model.jobName;
}

#pragma mark - setter

-(UIImageView *)photoV{
    if (!_photoV) {
        _photoV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 64+5, 50, 50)];
    }
    return _photoV;
}

-(UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]initWithFrame:CGRectMake(self.photoV.right+10, self.photoV.top, kSCREEN_WIDTH-self.photoV.right-10-100-15, self.photoV.height)];
        _nameL.textColor = COLOR_BLACK_CLASS_3;
        _nameL.font = [UIFont systemFontOfSize
                         :17];
        //        companyJob.backgroundColor = Red_Color;
        _nameL.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_nameL];
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.photoV);
            make.left.equalTo(self.photoV.mas_right).equalTo(10);
        }];
    }
    return _nameL;
}

-(UILabel *)jobL{
    if (!_jobL) {
        _jobL = [[UILabel alloc]initWithFrame:CGRectMake(self.nameL.right, self.photoV.top, 100, self.photoV.height)];
        _jobL.textColor = COLOR_BLACK_CLASS_3;
        _jobL.font = [UIFont systemFontOfSize
                       :17];
        _jobL.userInteractionEnabled = YES;
//        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jobClick:)];
//        [_jobL addGestureRecognizer:ges];
        
        //        companyJob.backgroundColor = Red_Color;
        _jobL.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_jobL];
        [_jobL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameL);
            make.left.equalTo(self.nameL.mas_right).equalTo(8);
            make.right.equalTo(-12);
        }];
    }
    return _jobL;
}

- (UIButton *)jobSelectBtn {
    if (_jobSelectBtn == nil) {
        _jobSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_jobSelectBtn];
        [_jobSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(0);
            make.bottom.equalTo(self.lineV.mas_bottom);
        }];
        _jobSelectBtn.backgroundColor = [UIColor clearColor];
        [_jobSelectBtn addTarget:self action:@selector(jobClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jobSelectBtn;
}

-(UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]initWithFrame:CGRectMake(0, self.photoV.bottom+5, kSCREEN_WIDTH, 0.5)];
        _lineV.backgroundColor = COLOR_BLACK_CLASS_0;
    }
    return _lineV;
}

-(void)jobClick:(UIButton *)sender{
    CategoryViewController *vc = [[CategoryViewController alloc]init];
    vc.index = 1;
    
    NSInteger jobId = 0;
    if(!_jobDict||![_jobDict objectForKey:@"idJob"]){
        jobId = [self.model.agencysJob integerValue];
    }
    else{
        jobId = [[_jobDict objectForKey:@"idJob"] integerValue];
    }
    
    if (self.comPanyOrShop == 1) {
        vc.comOrShop = 1;
    }
    else{
        vc.comOrShop = 2;
    }
    vc.defaultJobId = jobId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)success{
    NSInteger jobId = 0;
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    if(!_jobDict||![_jobDict objectForKey:@"idJob"]){
        jobId = [self.model.agencysJob integerValue];
    }
    else{
        jobId = [[_jobDict objectForKey:@"idJob"] integerValue];
    }
    NSString *defaultApi = [BASEURL stringByAppendingString:@"companyAgencys/getUpdate.do"];
    NSDictionary *paramDic = @{@"id":@(self.model.id),
                               @"agencysJob":@(jobId),
                               @"agencyId":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"修改成功" controller:self sleep:1.5];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"companyAgencysNot" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                    break;
                    
                case 1001:
                    
                {
                    
                }
                    break;
                    
                case 1004:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"对不起，你没有权限" controller:self sleep:1.5];
                }
                    break;
                    
                case 2000:
                    
                {
                    
                }
                    break;
                default:
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        
    }];
}


-(void)resetBtnTitle:(NSNotification *)notf{
    NSDictionary *dic = notf.userInfo;
    _jobDict = dic;
    self.jobL.text = [dic objectForKey:@"job"];
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
