//
//  EditShopViewController.m
//  iDecoration
//
//  Created by RealSeven on 2017/3/31.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "EditShopViewController.h"
#import "EditShopLogoTableViewCell.h"
#import "EditShopInfoTableViewCell.h"
#import "RemarkTableViewCell.h"
#import "CategoryViewController.h"
#import "CreateShopApi.h"
#import "GTMBase64.h"
#import "UploadImageApi.h"
#import "ShopModel.h"
#import "CategoryModel.h"
#import "RegionView.h"
#import "PModel.h"
#import "CModel.h"
#import "DModel.h"
#import "MyShopViewController.h"
#import "NSObject+CompressImage.h"
#import "ShopClassificationDetailViewController.h"

@interface EditShopViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CategoryModel *_category;
}
@property (nonatomic, strong) UITableView *editTableView;
@property (nonatomic, assign) NSInteger seeFlag;
@property (nonatomic, copy) NSString *companyLogoUrl;
@property (nonatomic, copy) NSString *addressStr;
@property (nonatomic, strong) RegionView *regionView;
@property (nonatomic, strong) PModel *pmodel;
@property (nonatomic, strong) CModel *cmodel;
@property (nonatomic, strong) DModel *dmodel;

@end

@implementation EditShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"编辑店铺";
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    self.seeFlag = 0;
    [self createTableView];
    
    [self.view addSubview:self.regionView];
    self.regionView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCategory:) name:@"categoryNoti" object:nil];
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
    [tableView registerNib:[UINib nibWithNibName:@"EditShopLogoTableViewCell" bundle:nil] forCellReuseIdentifier:@"EditShopLogoTableViewCell"];
    [tableView registerNib:[UINib nibWithNibName:@"EditShopInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"EditShopInfoTableViewCell"];
    [tableView registerNib:[UINib nibWithNibName:@"RemarkTableViewCell" bundle:nil] forCellReuseIdentifier:@"RemarkTableViewCell"];

    
    self.editTableView = tableView;
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
    
    if (section == 0) {
        return 5;
    }
    return 0.0000000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000000000000001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 150;
    }else if (indexPath.section == 1){
        return 44;
    }else{
        return 150;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        EditShopLogoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditShopLogoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        点击头像
        cell.tapBlock = ^{
            
            [self imagePicker];
        };
        
        return cell;
    }
    
    if (indexPath.section == 1) {
        
        NSArray *titleArr = @[@"品牌名称",@"类别",@"座机",@"地址",@"详细地址",@"手机号",@"微信"];
        NSArray *placeHolder = @[@"请输入品牌名称",@"请输入类别",@"请输入区号+号码",@"请选择地址",@"请填写详细地址",@"请输入手机号",@"请输入微信号"];
        
        EditShopInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditShopInfoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.titleLabel.text = titleArr[indexPath.row];
        cell.contentTF.placeholder = placeHolder[indexPath.row];
//        cell.selectBtn.hidden = YES;
//        cell.quiryLabel.hidden = YES;
        
        if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.contentTF.enabled = NO;
        }
        
        if (indexPath.row == 2) {
            
            __weak EditShopViewController *weakSelf = self;
            
            cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
//            cell.selectBtn.hidden = NO;
//            cell.quiryLabel.hidden = NO;
//
//            cell.selectBlock = ^(NSInteger flag){
//
//                weakSelf.seeFlag = flag;
//            };
        }
        
        if (indexPath.row == 3) {
            cell.contentTF.enabled = NO;
            cell.contentTF.text = self.addressStr;
        }
        
        if (indexPath.row == 5) {
            cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        return cell;
    }
    
    if (indexPath.section == 2) {
        
        RemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemarkTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"品牌详情";
        
        return cell;
    }
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {

            ShopClassificationDetailViewController *vc = [[ShopClassificationDetailViewController alloc] initWithNibName:@"HomeClassificationDetailViewController" bundle:nil];
            [vc.view setBackgroundColor:[UIColor whiteColor]];
            WorkTypeModel *m = [WorkTypeModel new];
            m.name = _category.typeName;
            m.jobId = _category.typeId;
            [vc getModelWithTitle:m];
            vc.blockDidTouchItem = ^(WorkTypeModel *model) {
                _category.typeName = model.name;
                _category.typeId = model.jobId;
                EditShopInfoTableViewCell *cell = (EditShopInfoTableViewCell*)[self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                cell.contentTF.text = _category.typeName;
            };
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if (indexPath.row == 3) {
            [self getRegion];
        }
    }
}

-(void)getCategory:(NSNotification*)sender{
 
    EditShopInfoTableViewCell *cell = (EditShopInfoTableViewCell*)[self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    
    _category = [CategoryModel yy_modelWithJSON:sender.userInfo];
    
    cell.contentTF.text = _category.typeName;
}

-(void)imagePicker{
    
    UIImagePickerController * photoAlbum = [[UIImagePickerController alloc]init];
    photoAlbum.delegate = self;
    photoAlbum.allowsEditing = YES;
    photoAlbum.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:photoAlbum animated:YES completion:^{}];
}

//图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage * chooseImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
//    NSData *imageData = UIImageJPEGRepresentation(chooseImage, PHOTO_COMPRESS);
    NSData *imageData = [NSObject imageData:chooseImage];
    
    if ([imageData length] >0) {
        imageData = [GTMBase64 encodeData:imageData];
    }
    NSString *imageStr = [[NSString alloc]initWithData:imageData encoding:NSUTF8StringEncoding];
    
    [self uploadImageWithBase64Str:imageStr];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)uploadImageWithBase64Str:(NSString*)base64Str{
    
    UploadImageApi *uploadApi = [[UploadImageApi alloc]initWithImgStr:base64Str type:@"png"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [uploadApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSDictionary *dic = request.responseJSONObject;
        NSString *code = [dic objectForKey:@"code"];
        
        if ([code isEqualToString:@"1000"]) {
            self.companyLogoUrl = [dic objectForKey:@"imageUrl"];
            
            NSURL *url = [NSURL URLWithString:self.companyLogoUrl];
            
            EditShopLogoTableViewCell *cell = [self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [cell.logoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"jia"]];
            
            [self.editTableView reloadData];
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

-(void)finishClick:(UIBarButtonItem*)sender{
//    
//    MyShopViewController *shopVC = [[MyShopViewController alloc]init];
//    [self.navigationController pushViewController:shopVC animated:YES];

    EditShopInfoTableViewCell *nameCell = [self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    EditShopInfoTableViewCell *telCell = [self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    EditShopInfoTableViewCell *addCell = [self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    EditShopInfoTableViewCell *deAddCell = [self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
    EditShopInfoTableViewCell *mobileCell = [self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:1]];
    EditShopInfoTableViewCell *wxCell = [self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:1]];
    RemarkTableViewCell *remarkCell = [self.editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
    if (nameCell.contentTF.text.length == 0 || telCell.contentTF.text.length == 0 || addCell.contentTF.text.length == 0 || deAddCell.contentTF.text.length == 0 || mobileCell.contentTF.text.length == 0 ||wxCell.contentTF.text.length == 0 || remarkCell.remarkTextView.text.length == 0) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"请填写相关信息" controller:self sleep:1.5];
        
        return;
    }
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
//    没有店铺
    if (_isExist == NO) {
        
        CreateShopApi *createApi = [[CreateShopApi alloc]initWithMerchantId:-1 merchantLogo:self.companyLogoUrl merchantName:nameCell.contentTF.text typeNo:_category.typeNo merchantlandline:telCell.contentTF.text address:[NSString stringWithFormat:@"%@%@",addCell.contentTF.text,deAddCell.contentTF.text] merchantPhone:mobileCell.contentTF.text merchantWx:wxCell.contentTF.text detail:remarkCell.remarkTextView.text createPersonId:user.agencyId relType:0 relId:user.agencyId provinceId:self.pmodel.regionId cityId:self.cmodel.regionId countyId:self.dmodel.regionId seeFlag:self.seeFlag];
        
        [createApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            NSInteger code = [[request.responseJSONObject objectForKey:@"code"] integerValue];
            
            switch (code) {
                case 1000:
                {
                    [[PublicTool defaultTool]publicToolsHUDStr:@"恭喜您，店铺创建成功！" controller:self sleep:1.5];
                    
                    NSString *merchantId = [request.responseJSONObject objectForKey:@"merchantId"];
                    
                    
                    NSDictionary *shopDict = [NSDictionary dictionary];
//                    shopDict setValue:<#(nullable id)#> forKey:<#(nonnull NSString *)#>
                    
                    NSDictionary *dict = [user yy_modelToJSONObject];
                    [dict setValue:merchantId forKey:@"merchantId"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:AGENCYDICT];
                    
                    MyShopViewController *shopVC = [[MyShopViewController alloc]init];
                    [self.navigationController pushViewController:shopVC animated:YES];
                }
                    break;
                    
                    case 2000:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }
    
//    已有店铺
    if (_isExist == YES) {
        
    }
}

-(void)getRegion{
    
    __weak EditShopViewController *weakSelf = self;
    weakSelf.regionView.hidden = NO;
    
    self.regionView.selectBlock = ^(NSMutableArray *array){
        
        weakSelf.pmodel = [array objectAtIndex:0];
        weakSelf.cmodel = [array objectAtIndex:1];
        weakSelf.dmodel = [array objectAtIndex:2];
        
        weakSelf.addressStr = [NSString stringWithFormat:@"%@ %@ %@",weakSelf.pmodel.name,weakSelf.cmodel.name,weakSelf.dmodel.name];
        
        [weakSelf.editTableView reloadData];
        
//        [weakSelf.regionView removeFromSuperview];
        weakSelf.regionView.hidden = YES;
    };
    
}

-(RegionView *)regionView{
    if (!_regionView) {
        _regionView = [[RegionView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-305, kSCREEN_WIDTH, 305)];
        _regionView.closeBtn.hidden = NO;
    }
    return _regionView;
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
