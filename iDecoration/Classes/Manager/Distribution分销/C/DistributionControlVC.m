//
//  DistributionControlVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DistributionControlVC.h"
#import "DistributioncontrolCell.h"
#import "DistributionbindingVC.h"
#import "DistributionrecordVC.h"
#import "DistriburionpromoteVC.h"
#import "DistributionheadView.h"
#import "distributionCell.h"
#import "distributionchangeuserinfoVC.h"
#import "DistributionwithdrawalVC.h"
#import "rapidpromotionVC.h"
#import "incomedetailsVC.h"
#import "myteamVC.h"
#import "withdrawalrecordVC.h"
#import "changeshareVC.h"
#import "DistributionViewController.h"
#import "destributionreportedVC.h"
#import "ApplyDistributionVC.h"
#import "DistributionaboutVC.h"
#import "teammanagementVC.h"
#import "WFSuspendButton.h"
#import "ZCHPublicWebViewController.h"
#import "zhuanxiangVC.h"
#import "incomedetailsVC1.h"
#import "disbroadcastVC.h"
#import "SpreadNewsList.h"
#import "newapplylistVC.h"
#import "nonmembersVC.h"
#import "distributionenvelopeVC.h"

@interface DistributionControlVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,WFSuspendedButtonDelegate>
{
    BOOL isshow;
}
@property (nonatomic,strong)  UICollectionView *collectionView;
@property (nonatomic,strong)  NSArray *imgArray;
@property (nonatomic,strong)  NSArray *textArray;
@property (nonatomic,strong)  NSDictionary *personCenter;
@property (nonatomic,copy)    NSString *checkStatus;
@property (nonatomic,strong)  UIAlertView *phoneAlert;
@property (strong, nonatomic) UILabel *labelBottom;//
@property (nonatomic,strong) WFSuspendButton *suspendedBtn;
@property (nonatomic,copy) NSString *sumTotal;
@property (nonatomic,strong)  NSMutableArray *SpreadArray;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *reportSum;
@end

static NSString *DistributionControlVCidentfid0 = @"DistributionControlVCidentfid0";

static float AD_height = 270;//头部高度

@implementation DistributionControlVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的分销";
    isshow = NO;
    self.imgArray = [NSArray array];
    self.textArray = [NSArray array];
    self.personCenter = [NSDictionary dictionary];
    self.sumTotal = [NSString new];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.labelBottom];
    [self addSuspendedButton];
    [self getbobao];
}

-(void)addSuspendedButton
{
    _suspendedBtn=[WFSuspendButton suspendedButtonWithCGPoint:CGPointMake(self.view.frame.size.width-80, 200) inView:self.view];
    _suspendedBtn.sendDelegate=self;
    [_suspendedBtn setImage:[UIImage imageNamed:@"Instruction_sus"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 delay:0.3 options:0 animations:^{
        
    } completion:nil];
    [self.view addSubview:_suspendedBtn];
}

-(void)isButtonTouched
{
    ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
    VC.titleStr = @"我的分销使用说明";
    VC.webUrl = @"http://api.bilinerju.com/api/designs/11463/10094.htm";
    VC.isAddBaseUrl = YES;
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loaddata];
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    for (UIView *view in backgroundView.subviews) {
        if (CGRectGetHeight([view frame]) <= 1) {

            view.hidden = YES;
        }
    }
}

-(void)loaddata
{
    //0.不是分销员,1.审核通过(分销员),2.被拒绝,3.审核中,4.对接人
    NSString* agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    NSDictionary *para = @{@"agencyId":agencyId};
    NSString *url = [BASEURL stringByAppendingString:POST_spreadCenterInfo];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            self.personCenter = [responseObj objectForKey:@"personCenter"];
            self.checkStatus = [responseObj objectForKey:@"checkStatus"];

            self.sumTotal = [responseObj objectForKey:@"sumTotal"];
            self.token = [responseObj objectForKey:@"token"];
            [self setdata:self.checkStatus];
        }
        [self.collectionView reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
}

/**
 分销播报
 */

-(void)getbobao
{
    NSString *url = [BASEURL stringByAppendingString:GET_FENXIAOBOBAO];
    [self.SpreadArray  removeAllObjects];
    [NetManager afGetRequest:url parms:nil finished:^(id responseObj) {
        isshow = YES;
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            self.reportSum = [responseObj objectForKey:@"reportSum"];
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[SpreadNewsList class] json:responseObj[@"data"][@"spreadNewsList"]]];
            [self.SpreadArray addObjectsFromArray:data];
        }
        [self.collectionView reloadData];
    } failed:^(NSString *errorMsg) {
        isshow = YES;
    }];
}

    
-(void)setdata:(NSString *)type
{
    if ([type isEqualToString:@"4"]||[type isEqualToString:@"5"]||[type isEqualToString:@"6"]) {
        self.imgArray = @[@"二维码",@"绑定账号",@"团队1",@"钱袋",@"关于我们"];
        self.textArray = @[@"加入我们",@"绑定账号",@"我的团队",@"收入明细",@"关于我们"];
    }
    else
    {
        self.textArray = @[@"加入我们",@"开会员报单",@"我的团队",@"收入明细",@"非会员报单",@"绑定账号",@"关于我们",@"奖励机制",@"红包管理"];
        self.imgArray = @[@"二维码",@"推荐商家",@"团队1",@"钱袋",@"icon_feihuiyuan",@"绑定账号",@"关于我们",@"律师会员服务",@"hongbaoguanlifenx"];
    }
    [self.collectionView reloadData];
}

#pragma mark - getters


-(NSMutableArray *)SpreadArray
{
    if(!_SpreadArray)
    {
        _SpreadArray = [NSMutableArray array];
        
    }
    return _SpreadArray;
}

- (UILabel *)labelBottom {
    if (!_labelBottom) {
        _labelBottom = [[UILabel alloc] initWithFrame:(CGRect){0, kSCREEN_HEIGHT - 40, kSCREEN_WIDTH, 40}];
        _labelBottom.text = @"客服QQ:3379607351";
        _labelBottom.font = [UIFont systemFontOfSize:13];
        _labelBottom.width = kSCREEN_WIDTH;
        _labelBottom.textAlignment = NSTextAlignmentCenter;
        [_labelBottom setBackgroundColor:[UIColor whiteColor]];
        _labelBottom.userInteractionEnabled=YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contactcustomerService)];
        [_labelBottom addGestureRecognizer:labelTapGestureRecognizer];
    }
    return _labelBottom;
}

#pragma mark - 创建collectionView并设置代理

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH, AD_height);//头部大小
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_WIDTH, naviBottom - 50) collectionViewLayout:flowLayout];
        _collectionView.scrollEnabled = NO;

        flowLayout.itemSize = CGSizeMake(92*WIDTH_SCALE, 90*WIDTH_SCALE);
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 2;
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 2;
        //定义每个UICollectionView 的边距距
        //flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);//上左下右
        //注册cell和ReusableView（相当于头部）
        [_collectionView registerClass:[distributionCell class] forCellWithReuseIdentifier:DistributionControlVCidentfid0];
        [_collectionView registerClass:[DistributionheadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
        _collectionView.backgroundColor = [UIColor whiteColor];
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgArray.count;
}

#pragma mark 每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    distributionCell *cell = (distributionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:DistributionControlVCidentfid0 forIndexPath:indexPath];
    [cell sizeToFit];
    [cell setdata:self.imgArray[indexPath.item] andtext:self.textArray[indexPath.item]];
    return cell;
}

#pragma mark 头部显示的内容

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DistributionheadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                            UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor hexStringToColor:@"4ABD87"];
    NSString *morebtnstr = [NSString stringWithFormat:@"%@%@%@",@"今日\n",self.reportSum,@"\n单"];
    [headerView.moreBtn setTitle:morebtnstr forState:normal];
    headerView.iconImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [headerView.iconImg addGestureRecognizer:singleTap];
    
    NSString *createCode = @"";
    NSString *trueName = @"";
    NSString *accountTotal = @"";
    
    trueName = [self.personCenter objectForKey:@"trueName"];
    createCode = [self.personCenter objectForKey:@"createCode"];

    accountTotal = [self.personCenter objectForKey:@"accountTotal"];
    NSString *photo = [self.personCenter objectForKey:@"photo"];
    
    headerView.nameLab.text = trueName;
    if (createCode.length==0) {
        
        headerView.codelab.text = [NSString stringWithFormat:@"%@",@"我的邀请码:未分配"];
    }
    else
    {
         headerView.codelab.text = [NSString stringWithFormat:@"%@%@",@"我的邀请码:",createCode];
    }
    
    headerView.moneylab0.text = accountTotal;

    [headerView.iconImg sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"defaultman"]];
  
    if ([self.checkStatus isEqualToString:@"4"]) {
        headerView.isLevelLab.text = @"对接人";
        [headerView.isLevelLab setHidden:NO];
        [headerView.img setHidden:NO];
    }
    if ([self.checkStatus isEqualToString:@"6"]||[self.checkStatus isEqualToString:@"5"]) {
        headerView.isLevelLab.text = @"代理对接";
        [headerView.isLevelLab setHidden:NO];
        [headerView.img setHidden:NO];
    }
    if ([self.checkStatus isEqualToString:@"1"]) {
        
        NSString *isLevel = @"";
        isLevel = [self.personCenter objectForKey:@"isLevel"];
        if ([isLevel isEqualToString:@"0"]) {
            
            [headerView.isLevelLab setHidden:YES];
            [headerView.img setHidden:YES];
        }
        else if ([isLevel isEqualToString:@"1"]) {
            headerView.isLevelLab.text = @"一级分销";
            [headerView.isLevelLab setHidden:NO];
            [headerView.img setHidden:NO];
        }
        else if ([isLevel isEqualToString:@"2"]) {
            headerView.isLevelLab.text = @"二级分销";
            [headerView.isLevelLab setHidden:NO];
            [headerView.img setHidden:NO];
        }
        else if ([isLevel isEqualToString:@"3"]) {
            headerView.isLevelLab.text = @"三级分销";
            [headerView.isLevelLab setHidden:NO];
            [headerView.img setHidden:NO];
        }
        else
        {
            [headerView.isLevelLab setHidden:YES];
            [headerView.img setHidden:YES];
        }
    }
    if ([self.checkStatus isEqualToString:@"2"]) {
        [headerView.img setHidden:YES];
        [headerView.isLevelLab setHidden:NO];
        headerView.isLevelLab.text = @"已拒绝";
    }
    if ([self.checkStatus isEqualToString:@"3"]) {
        [headerView.img setHidden:YES];
        [headerView.isLevelLab setHidden:NO];
        headerView.isLevelLab.text = @"审核中";
    }
    if ([self.checkStatus isEqualToString:@"0"]) {
        [headerView.isLevelLab setHidden:YES];
        [headerView.img setHidden:YES];
    }
    [headerView.submitbtn addTarget:self action:@selector(drawalVC) forControlEvents:UIControlEventTouchUpInside];
    [headerView.moreBtn addTarget:self action:@selector(bobaomorebtnclick) forControlEvents:UIControlEventTouchUpInside];
    if (isshow) {
        [headerView setdata:self.SpreadArray];
    }
    return headerView;
}

#pragma mark UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择%ld",(long)indexPath.item);
    //0.不是分销员,1.审核通过(分销员),2.被拒绝,3.审核中,4.对接人  5 代理对接人||对接人  6 代理对接人
    if ([self.checkStatus isEqualToString:@"0"]||[self.checkStatus isEqualToString:@"3"]||[self.checkStatus isEqualToString:@"2"]) {
        if (indexPath.item==6) {
            DistributionaboutVC *vc = [DistributionaboutVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.item==7)
        {
            DistributionViewController *vc = [DistributionViewController new];
            vc.InActionType = ENUM_ViewController895_ActionTypejiangli;
            vc.type = self.checkStatus;
            vc.trueName = [self.personCenter objectForKey:@"trueName"];
            [self.navigationController pushViewController:vc animated:YES];

        }
        else if (indexPath.item==4)
        {
            [self showalert];
        }
        else
        {
            
            if ([self.checkStatus isEqualToString:@"0"]||[self.checkStatus isEqualToString:@"2"]) {
                [self showalert];
            }
            
            if ([self.checkStatus isEqualToString:@"3"]) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"您的信息正在审核，请耐心等待" controller:self sleep:1.5];
            }
        }
    }
    else
    {
        if (indexPath.item==0) {
            if ([self.checkStatus isEqualToString:@"4"]||[self.checkStatus isEqualToString:@"5"]||[self.checkStatus isEqualToString:@"6"]) {
                rapidpromotionVC *vc = [rapidpromotionVC new];
                NSString *createCode = [self.personCenter objectForKey:@"createCode"];
                NSString *trueName = [self.personCenter objectForKey:@"trueName"];
                vc.trueName = trueName;
                vc.createCode = createCode;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                rapidpromotionVC *vc = [rapidpromotionVC new];
                NSString *createCode = [self.personCenter objectForKey:@"createCode"];
                NSString *trueName = [self.personCenter objectForKey:@"trueName"];
                vc.trueName = trueName;
                vc.createCode = createCode;
                [self.navigationController pushViewController:vc animated:YES];

            }
            
        }
        if (indexPath.item==1) {
            if ([self.checkStatus isEqualToString:@"4"]||[self.checkStatus isEqualToString:@"5"]||[self.checkStatus isEqualToString:@"6"]) {
                [self bindingBtnclick];
            }
            else
            {
                destributionreportedVC *vc = [destributionreportedVC new];
                vc.spreadId = [self.personCenter objectForKey:@"agencyId"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        if (indexPath.item==2) {
            
            if ([self.checkStatus isEqualToString:@"4"]||[self.checkStatus isEqualToString:@"5"]||[self.checkStatus isEqualToString:@"6"]) {
                
                teammanagementVC *vc = [teammanagementVC new];
                vc.createCode = [self.personCenter objectForKey:@"createCode"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            else
            {
                myteamVC *vc = [myteamVC new];
                vc.createCode = [self.personCenter objectForKey:@"createCode"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
        if (indexPath.item==3) {
            
            //收入明细

            if ([self.checkStatus isEqualToString:@"4"]||[self.checkStatus isEqualToString:@"5"]||[self.checkStatus isEqualToString:@"6"]) {
               incomedetailsVC *vc = [incomedetailsVC new];
               [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                incomedetailsVC1 *vc = [incomedetailsVC1 new];
                [self.navigationController pushViewController:vc animated:YES];
            }
 
        }
        if (indexPath.item==4) {
            if ([self.checkStatus isEqualToString:@"4"]||[self.checkStatus isEqualToString:@"5"]||[self.checkStatus isEqualToString:@"6"]) {
                DistributionaboutVC *vc = [DistributionaboutVC new];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {

                nonmembersVC *vc = [nonmembersVC new];
                vc.spreadId = [self.personCenter objectForKey:@"agencyId"];
                vc.userinfoPhoto = [self.personCenter objectForKey:@"photo"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        if (indexPath.item==5) {

            [self bindingBtnclick];
        }
        if (indexPath.item==6) {
            DistributionaboutVC *vc = [DistributionaboutVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.item==7) {
            DistributionViewController *vc = [DistributionViewController new];
            vc.InActionType = ENUM_ViewController895_ActionTypeliaojie;
            vc.type = self.checkStatus;
            vc.trueName = [self.personCenter objectForKey:@"trueName"];;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.item==8) {
            
            distributionenvelopeVC *vc = [distributionenvelopeVC new];
            vc.userName = [self.personCenter objectForKey:@"trueName"];
            [self.navigationController pushViewController:vc animated:YES];
        }

    }
}

#pragma mark - 实现方法
//绑定
-(void)bindingBtnclick
{
    DistributionbindingVC *vc = [DistributionbindingVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

//提现
-(void)drawalVC
{
    //0.不是分销员,1.审核通过(分销员),2.被拒绝,3.审核中,4.对接人
    if ([self.checkStatus isEqualToString:@"0"]||[self.checkStatus isEqualToString:@"2"]) {
        [self showalert];
    }
    else
    {
        if ([[self.personCenter objectForKey:@"accountTotal"] isEqualToString:@"0.00"]||[self.checkStatus isEqualToString:@"3"]) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"您没有提现金额" controller:self sleep:1.5];
            return;
        }
        DistributionwithdrawalVC *vc = [DistributionwithdrawalVC new];
//        vc.trueName = [self.personCenter objectForKey:@"trueName"];
        vc.trueName = [NSString new];
        vc.userName = [self.personCenter objectForKey:@"trueName"];
        vc.accountTotal = [self.personCenter objectForKey:@"accountTotal"];
        vc.checkStatus = self.checkStatus;
        vc.type = @"0";
        vc.token = self.token;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded){
        CGPoint location = [tap locationInView:nil];
        if (![_phoneAlert pointInside:[_phoneAlert convertPoint:location fromView:_phoneAlert.window] withEvent:nil]){
            [_phoneAlert.window removeGestureRecognizer:tap];
            [_phoneAlert dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}

//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
    if (buttonIndex==0) {
        DistributionViewController *vc = [DistributionViewController new];
        vc.InActionType = ENUM_ViewController895_ActionTypeliaojie;
        vc.type = self.checkStatus;
        vc.trueName = [self.personCenter objectForKey:@"trueName"];;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (buttonIndex==1) {
        ApplyDistributionVC *vc = [ApplyDistributionVC new];
        vc.trueName = [self.personCenter objectForKey:@"trueName"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)showalert
{
    NSString *title = [NSString new];
    if ([self.checkStatus isEqualToString:@"2"]) {
        title = @"您的申请被拒绝，请重新申请";
    }
    else
    {
        title = @"你还不是分销员";
    }

    self.phoneAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:nil otherButtonTitles:@"了解分销员",@"申请分销员", nil];
    self.phoneAlert.delegate = self;
    [self.phoneAlert show];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    tap.cancelsTouchesInView = NO;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:tap];
}

-(void)bobaomorebtnclick
{
    disbroadcastVC *vc = [disbroadcastVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)handleSingleTap
{
    
}

-(void)contactcustomerService
{

    NSString *qqstr = @"3379607351";
    NSString *qq=[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqstr];
    NSURL *url = [NSURL URLWithString:qq];
    [[UIApplication sharedApplication] openURL:url];
}

@end
