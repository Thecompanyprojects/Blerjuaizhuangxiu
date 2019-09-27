//
//  MyShopViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/3/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "MyShopViewController.h"
#import "ShopLogoTableViewCell.h"
#import "ShopInfoTableViewCell.h"
#import "BrandIntroTableViewCell.h"
#import "IntrolHeaderView.h"
#import "EditShopViewController.h"
#import "GetShopInfoByIDApi.h"
#import "ShopModel.h"

@interface MyShopViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *shopTableView;
@property (nonatomic, strong) ShopModel *shop;
@end

@implementation MyShopViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createUI];
    [self createTableView];
}

-(void)createUI{
    
    self.title = @"我的店铺";
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
}

-(void)editClick:(UIBarButtonItem*)sender{
    
    EditShopViewController *editVC = [[EditShopViewController alloc]init];
    editVC.isExist = YES;
    [self.navigationController pushViewController:editVC animated:YES];
}

-(void)createTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = Bottom_Color;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"ShopLogoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopLogoTableViewCell"];
    [tableView registerNib:[UINib nibWithNibName:@"ShopInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopInfoTableViewCell"];
    [tableView registerNib:[UINib nibWithNibName:@"BrandIntroTableViewCell" bundle:nil] forCellReuseIdentifier:@"BrandIntroTableViewCell"];
    [tableView registerClass:[IntrolHeaderView class] forHeaderFooterViewReuseIdentifier:@"IntrolHeaderView"];

    [self.shopTableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 7;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 40.0f;
    }
    return 0.0000000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }
    return 0.0000000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 75;
    }else if (indexPath.section == 1){
        return 44;
    }else{
        return 100;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        IntrolHeaderView *headerView = (IntrolHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"IntrolHeaderView"];
        
        return headerView;
    }
    return [[UITableViewHeaderFooterView alloc]init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        ShopLogoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopLogoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.brandLabel.text = self.shop.merchantName;
        cell.areaLabel.text = self.shop.location;
        
        NSURL *url = [NSURL URLWithString:self.shop.merchantLogo];
        [cell.logoImageView sd_setImageWithURL:url placeholderImage:nil];
        
        return cell;
        
    }else if (indexPath.section == 1){
        
        NSArray *titleArr = @[@"类别",@"电话",@"手机号",@"微信",@"地址",@"合作企业",@"商品展示"];
        
        ShopInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopInfoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.titleLabel.text = titleArr[indexPath.row];
        
        switch (indexPath.row) {
            case 0:
                cell.contentLabel.text = self.shop.typeName;
                break;
                
            case 1:
                cell.contentLabel.text = self.shop.merchantPhone;
                break;
                
            case 2:
                cell.contentLabel.text = self.shop.merchantPhone;
                break;
                
            case 3:
                cell.contentLabel.text = self.shop.merchantWx;
                break;
                
            case 4:
                cell.contentLabel.text = self.shop.address;
                break;
                
//            case 5:
//                cell.contentLabel.text = self.shop.typeName;
//                break;
//                
//            case 6:
//                cell.contentLabel.text = self.shop.typeName;
//                break;
                
            default:
                break;
        }
        
        if (indexPath.row == 5) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 6) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
        return cell;
        
    }else{
        
        BrandIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandIntroTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.IntroLabel.text = self.shop.detail;
        
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (indexPath.row == 5) {
            
        }else if (indexPath.row == 6){
            
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    UserInfoModel *user = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
    
    GetShopInfoByIDApi *getApi = [[GetShopInfoByIDApi alloc]initWithMerchantId:user.merchantId];

    [getApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSInteger code = [[request.responseJSONObject objectForKey:@"code"] integerValue];
        if (code == 1000) {
            
            NSDictionary *dict = [request.responseJSONObject objectForKey:@"merchant"];
            
            self.shop = [ShopModel yy_modelWithJSON:dict];
            
            [self.shopTableView reloadData];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
