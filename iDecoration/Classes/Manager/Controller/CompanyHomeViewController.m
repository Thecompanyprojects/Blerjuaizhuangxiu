//
//  CompanyHomeViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/3/24.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CompanyHomeViewController.h"
#import "CompanyLogoTableViewCell.h"
#import "CompanyNumberTableViewCell.h"
#import "CompanyInfoTableViewCell.h"
#import "DecorationAreaViewController.h"
#import "HomeIndexViewController.h"
#import "EditShopViewController.h"

@interface CompanyHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *companyTableView;
@property (nonatomic, strong) NSMutableArray *filialeArr;

@end

@implementation CompanyHomeViewController

-(NSMutableArray*)filialeArr{
    
    if (!_filialeArr) {
        _filialeArr = [NSMutableArray array];
        [_filialeArr addObject:self.ComModel];
    }
    return _filialeArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
    [self createTableView];
}

-(void)createUI{

    self.title = @"我的公司";
    self.view.backgroundColor = Bottom_Color;
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"新店面" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(newShopClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    
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
    
    [tableView registerNib:[UINib nibWithNibName:@"CompanyLogoTableViewCell" bundle:nil] forCellReuseIdentifier:@"CompanyLogoTableViewCell"];
    [tableView registerNib:[UINib nibWithNibName:@"CompanyNumberTableViewCell" bundle:nil] forCellReuseIdentifier:@"CompanyNumberTableViewCell"];
    [tableView registerNib:[UINib nibWithNibName:@"CompanyInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"CompanyInfoTableViewCell"];
    
    self.companyTableView = tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
//    else if (section == 1){
//        return self.filialeArr.count+1;
//    }
    else{
        return self.filialeArr.count+1;;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 100;
    }else{
        return 44;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        CompanyLogoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyLogoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSURL *url = [NSURL URLWithString:self.ComModel.companyLogo];
        [cell.logoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultCompanyLogo"]];
        cell.nameLabel.text = self.ComModel.companyName;
        cell.introLabel.text = self.ComModel.companySlogan;
        cell.modifyBlock = ^(){
            
        };
        
        return cell;
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            CompanyNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyNumberTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"公司架构";
            cell.companyNumberLabel.hidden = YES;
            
            return cell;
            
        }else{
            
            CompanyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyInfoTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.titleImageView.hidden = YES;
            
            for (CompanyModel *company in self.filialeArr) {
                
                cell.titleLabel.text = company.companyName;
            }
            
            return cell;
        }

    }else{
        
        CompanyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompanyInfoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.titleLabel.text = @"总公司装修区域";
        
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        switch (indexPath.row) {
            case 2:
            {
                HomeIndexViewController *indexVC = [[HomeIndexViewController alloc]init];
                [self.navigationController pushViewController:indexVC animated:YES];
            }
                break;
                
            case 3:
            {
                DecorationAreaViewController *areaVC = [[DecorationAreaViewController alloc]init];
                [self.navigationController pushViewController:areaVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)newShopClick:(UIBarButtonItem*)sender{
    
    EditShopViewController *editVC = [[EditShopViewController alloc]init];
    [self.navigationController pushViewController:editVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
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
