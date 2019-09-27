//
//  VIPExperienceViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/22.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "VIPExperienceViewController.h"
#import "DecorationAreaViewController.h"
#import "CreatShopController.h"
#import "NetManager.h"
#import "EaseEmoji.h"
#import "VIPExperienceShowViewController.h"


@interface VIPExperienceViewController ()<UITextViewDelegate>
//@property (strong, nonatomic) NSString *areaString;
@property (nonatomic, strong) RegionView *regionView;
@property (strong, nonatomic) NSMutableString *paramString;
@property (strong, nonatomic) NSString *jsonStringArea;

/**
 删除图片存放的数组
 */
@property (strong, nonatomic) NSMutableArray *arrayDelete;
@property (assign, nonatomic) BOOL isFirstGetLocation;


@end

@implementation VIPExperienceViewController{
    NSIndexPath* selfIndexPath;
}

#pragma mark lazy
- (NSMutableArray *)arrayDelete {
    if (!_arrayDelete) {
        _arrayDelete = @[].mutableCopy;
    }
    return _arrayDelete;
}

- (NSMutableString *)paramString {
    if (!_paramString) {
        _paramString = [[NSMutableString alloc] init];
    }
    return _paramString;
}

- (UIImagePickerController *)picker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        _picker.allowsEditing = YES;
    }
    return _picker;
}

- (RegionView *)regionView {
    if (!_regionView) {
        _regionView = [[RegionView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-305, kSCREEN_WIDTH, 305)];
        _regionView.closeBtn.hidden = NO;
        _regionView.hidden = false;
        _regionView.line.hidden = YES;
        _regionView.backgroundColor = [White_Color colorWithAlphaComponent:0];
    }
    return _regionView;
}

- (VIPExperienceModel *)model {
    if (!_model) {
        _model = [VIPExperienceModel new];
    }
    return _model;
}

#pragma mark Network
- (void)NetworkOfUploadImage {
    if (!self.model.serviceScope.length) {
        SHOWMESSAGE(@"请输入服务范围！")
        return;
    }
    ShowMB
    NSMutableArray *arrayADTop = [self getImageWithArray:self.model.arrayADTop];
    NSMutableArray *arrayADBottom = [self getImageWithArray:self.model.arrayADBottom];
    NSMutableArray *arrayTmp = [NSMutableArray arrayWithArray:arrayADTop];
    NSMutableArray *arrayImage = @[].mutableCopy;
    [arrayTmp addObjectsFromArray:arrayADBottom];
    if (arrayTmp.count > 0) {
        arrayImage = [[arrayTmp valueForKeyPath:@"image"] mutableCopy];
        if (self.model.imageLogo) {
            [arrayImage addObject:self.model.imageLogo];
        }
    }else{
        if (self.model.imageLogo) {
            [arrayImage addObject:self.model.imageLogo];
        }else{
            [self makeImageData];
            [self NetworkOfSave];
            return;
        }
    }
    NSMutableArray *arrayChanged = @[].mutableCopy;
    [arrayADTop enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj class] == [SubsidiaryModel class]) {
            SubsidiaryModel *model = obj;
            if (model.isImageChanged) {
                [arrayChanged addObject:model];
            }
        }
    }];
    [arrayADBottom enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj class] == [SubsidiaryModel class]) {
            SubsidiaryModel *model = obj;
            if (model.isImageChanged) {
                [arrayChanged addObject:model];
            }
        }
    }];
    [NetWorkRequest PostImages:@"file/uploadFiles.do" post:nil dicImages:arrayImage amrFilePath:nil name:@"file" success:^(id result) {
        if ([result[@"code"] integerValue] == 1000) {
            NSMutableArray *imgList = [result[@"imgList"] mutableCopy];
            if (self.model.imageLogo) {
                NSDictionary *dic = imgList.lastObject;
                self.model.companyLogo = dic[@"imgUrl"];
                [imgList removeLastObject];
            }
            [imgList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                NSLog(@"%@",arrayADTop);
                SubsidiaryModel *model = arrayChanged[idx];
                model.picUrl = dic[@"imgUrl"];
            }];
            NSLog(@"%@",result);
            [self makeImageData];
            [self NetworkOfSave];
        }else{
            HiddenMB
            SHOWMESSAGE(@"图片上传失败")
        }
    } fail:^(id error) {
        HiddenMB
        SHOWMESSAGE(@"图片上传失败")
    }];
}

- (void)NetworkOfSave {
//    if (self.model.isCompany) {
//        [self NetworkOfArea];
//    }
    if (self.paramString.length > 5) {
        NSRange deleteRange = {([self.paramString length] - 2), 1};
        [self.paramString deleteCharactersInRange:deleteRange];
    }
    if (self.jsonStringArea.length == 0) {
        self.jsonStringArea = [self.model.areaList yy_modelToJSONString];
//        NSData *data = [NSJSONSerialization dataWithJSONObject:self.model.areaList options:NSJSONWritingPrettyPrinted error:nil];
//        self.jsonStringArea = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    NSString *URL;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"longitude"] = self.model.longitude?:@"";
    parameters[@"latitude"] = self.model.latitude?:@"";
    parameters[@"companyName"] = self.model.companyName?:@"";
    parameters[@"areaList"] = @"[]";
    parameters[@"companyProvince"] = self.model.companyProvince?:@"";
    parameters[@"companyCity"] = self.model.companyCity?:@"";
    parameters[@"companyCounty"] = self.model.companyCounty?:@"";
    parameters[@"companyLandline"] = self.model.companyLandline?:@"";
    parameters[@"companyAddress"] = [NSString stringWithFormat:@"%@%@",self.model.companyAddress,self.model.detailedAddress]?:@"";
    parameters[@"companyPhone"] = self.model.companyPhone?:@"";
    parameters[@"companyIntroduction"] = self.model.companyIntroduction?:@"";
    parameters[@"companyWx"] = self.model.companyWx?:@"";
    parameters[@"companyId"] = self.model.companyId?:@"";
    parameters[@"companyType"] = self.model.companyType?:@"";
    parameters[@"seeFlag"] = self.model.seeFlag?:@"";
    parameters[@"companyLogo"] = self.model.companyLogo?:@"";
    parameters[@"companyEmail"] = self.model.companyEmail?:@"";
    parameters[@"companyUrl"] = self.model.companyUrl?:@"";
    parameters[@"serviceScope"] = self.model.serviceScope?:@"";
    parameters[@"dealImgs"] = @(1);
    parameters[@"pid"] = self.model.companyId?:@"";
    parameters[@"createPerson"] = GETAgencyId?:@"";
    [parameters setObject:self.paramString forKeyedSubscript:@"imgList"];
    if (self.isNew) {
        URL = @"company/saveHeadquarters.do";
        parameters[@"headQuarters"] = @(!self.isHaveMainCompany);
        //注册时创建公司传
        if (self.islogup) {
           [parameters setObject:@"1" forKey:@"type"];
            [parameters setObject:self.companyNumber?:@"" forKey:@"companyNumber"];
        }
        if (!self.isHaveMainCompany) {
            
        }
    }else
        URL = @"area/saveArea.do";
    [NetWorkRequest postJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        HiddenMB
        if ([result[@"code"] integerValue] == 1000) {
            SHOWMESSAGE(@"提交成功")
            if (self.blockFreshBack) {
                self.blockFreshBack();
            }
            NSString *companyId = [result objectForKey:@"companyId"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (self.islogup) {

                    VIPExperienceShowViewController *vc = [VIPExperienceShowViewController new];
                    vc.isfromLogup = YES;
                    vc.companyId = companyId;
                    [self.navigationController pushViewController:vc animated:YES];
                   
                }
                else
                {
                    [self.navigationController popViewControllerAnimated:true];
                }

            });
        }else
            SHOWMESSAGE(@"提交失败")
    } fail:^(NSError *error) {
        HiddenMB
        SHOWMESSAGE(@"提交失败")
    }];
}

- (void)NetworkOfArea {
    NSString *URL = @"area/upArea.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"companyId"] = self.model.companyId;
    parameters[@"areaList"] = self.jsonStringArea;
    [NetWorkRequest getJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        if ([result[@"code"] integerValue] == 1000) {

        }else{
           // HiddenMB
            //SHOWMESSAGE(@"装修区域修改失败")
        }
    } fail:^(id error) {
//        HiddenMB
//        SHOWMESSAGE(@"装修区域修改失败")
    }];
}

#pragma mark UI
- (void)viewDidLoad {
    [super viewDidLoad];
    self.model.isCompany = false;
    self.isFirstGetLocation = true;
//    if (!self.isNew) {
//        self.model.isCompany = KIsCompany(self.model.companyType);
//    }
    if (self.model.companyType.length == 0) {
        if (self.islogup) {
             self.title = @"商家注册";
        }else{
             self.title = @"创建店面";
        }
        
        if ([self.model.typeName isEqualToString:@"装修公司"]) {
            self.model.companyType = @"1018";
            self.model.isCompany = true;
        }else if ([self.model.typeName isEqualToString:@"新型装修"]) {
            self.model.companyType = @"1064";
            self.model.isCompany = true;
        }else if ([self.model.typeName isEqualToString:@"整装公司"]) {
            self.model.companyType = @"1065";
            self.model.isCompany = true;
        }
    }else{
        if (KIsCompany(self.model.companyType)) {
            self.title = @"编辑公司";
            self.model.isCompany = true;
        }else
            self.title = @"编辑商铺";
    }
    [self setupRightButton];
    [VIPExperienceModel getCompanyAddressWithModel:self.model];
    self.model.arrayADTop = self.model.headImgs.count?[self.model.headImgs mutableCopy]:@[].mutableCopy;
    self.model.arrayADBottom = self.model.footImgs.count?[self.model.footImgs mutableCopy]:@[].mutableCopy;
    [self makeADArrayWith:self.model.arrayADTop];
    [self makeADArrayWith:self.model.arrayADBottom];
    [self createTableView];
    
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(RefreshNameAddress:) name:@"krefreshNameAddressLabel" object:nil];
  
}

-(void)RefreshNameAddress:(NSNotification *)notification{
    NSDictionary *dic =notification.userInfo;
    NSString* addressName =[dic objectForKey:@"addressName"];

    double longitude =[[dic objectForKey:@"longitude"] doubleValue];
    double latitude =[[dic objectForKey:@"latitude"] doubleValue];
  //  NSString *addressName, double lantitude, double longitude
        
//         VIPExperienceTableViewCell *  cell =  [[NSBundle mainBundle] loadNibNamed:@"VIPExperienceTableViewCell" owner:self options:nil][selfIndexPath];
//          VIPExperienceTableViewCell *  cell = [VIPExperienceTableViewCell cellWithTableView:self.tableView AndIndex:selfIndexPath];
//           cell.textField.text =addressName;

                    self.model.longitude = @(longitude).stringValue;
                    self.model.latitude = @(latitude).stringValue;
                    self.model.detailedAddress = addressName;
                    self.isFirstGetLocation = false;
    
 
    
  
//   VIPExperienceTableViewCell*  cell = [VIPExperienceTableViewCell cellWithTableView:self.tableView AndIndex:2];
//
//    cell.textField.text =addressName;
  //  [cell setModel:self.model andIndexPath:selfIndexPath];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
 
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication].keyWindow addSubview:self.regionView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.regionView removeFromSuperview];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStylePlain)];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(0);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
}

- (void)setupRightButton {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setTitle:@"完成" forState:(UIControlStateNormal)];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFixedSpace) target:nil action:nil];
    item.width = -7;
    self.navigationItem.rightBarButtonItems = @[item,rightItem];
    [rightButton addTarget:self  action:@selector(didTouchRightButton) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark tableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    UITextField *text = [[UITextField alloc] init];
    text.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 34);
    text.backgroundColor = [UIColor clearColor];
    text.textColor = [UIColor darkGrayColor];
    text.font = [UIFont boldSystemFontOfSize:16];
    text.text = sectionTitle;
    text.textAlignment = NSTextAlignmentCenter;
    text.userInteractionEnabled = NO;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 34)];
    view.backgroundColor = [UIColor hexStringToColor:@"f2f2f2"];
    [view addSubview:text];
    text.centerY = view.centerY;
    return view;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    switch (section) {
        case 1:
            title = @"店铺/公司企业广告位（上）";
            break;
        case 2:
            title = @"店铺/公司企业广告位（下）";
            break;
        default:
            break;
    }
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001;
    }else
        return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            NSLog(@"%ld",(long)self.model.arrayBasicTitle.count);
            return self.model.arrayBasicTitle.count;
            break;
        case 1:
            if (self.model.arrayADTop.count > 7) {
                return self.model.arrayADTop.count - 1;
            }else
                return self.model.arrayADTop.count;
            break;
        case 2:
            if (self.model.arrayADBottom.count > 7) {
                return self.model.arrayADBottom.count - 1;
            }else
                return self.model.arrayADBottom.count;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VIPExperienceTableViewCell *cell = [VIPExperienceTableViewCell cellWithTableView:tableView AndIndex:1];
    self.model.isCompany = NO;
    NSArray *row = self.model.isCompany?@[@"4", @"11"]:@[@"3", @"10"];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [VIPExperienceTableViewCell cellWithTableView:tableView AndIndex:0];
        }else if ([row containsObject:@(indexPath.row).stringValue]) {
            cell = [VIPExperienceTableViewCell cellWithTableView:tableView AndIndex:2];
        }
        [cell setModel:self.model andIndexPath:indexPath];
        cell.blockDidTouchButtonLogo = ^{
            self.imageMode = VIPExperienceImageModeLogo;
            [self getPicWithIndex:1];
        };
        return cell;
    }else{
        UploadAdvertisementCell *cellAD = [UploadAdvertisementCell cellWithTableView:tableView];
        cellAD.placeHolderTV.delegate = self;
        NSMutableArray *arrayTmp = indexPath.section == 1?self.model.arrayADTop:self.model.arrayADBottom;
        if (indexPath.row <= arrayTmp.count - 1) {
            id obj = arrayTmp[indexPath.row];
            if ([obj class] == [UIImage class]) {
                [cellAD.imageV setImage:arrayTmp[indexPath.row]];
            }else
                [cellAD.imageV setImage:[UIImage imageNamed:@"jia_kuang"]];
        }
        if (indexPath.section == 1) {
            cellAD.placeHolderTV.tag = indexPath.row + 10;
            cellAD.placeHolderTV.placeHolder = @"请输入链接";
            SubsidiaryModel *model = self.model.arrayADTop[indexPath.row];
            if ([model class] == [SubsidiaryModel class]) {
                if (model.picUrl.length) {
                    [cellAD.imageV sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
                }
                if (model.image) {
                    [cellAD.imageV setImage:model.image];
                }
                cellAD.placeHolderTV.text = model.picHref;
            }
        }else if (indexPath.section == 2) {
            cellAD.placeHolderTV.tag = indexPath.row + 20;
            id obj = self.model.arrayADBottom[indexPath.row];
            cellAD.placeHolderTV.placeHolder = @"请输入文字(0~100)";
            cellAD.promptLabel.text = @"";
            if ([obj class] == [SubsidiaryModel class]) {
                SubsidiaryModel *model = self.model.arrayADBottom[indexPath.row];
                if (model.picUrl.length) {
                    [cellAD.imageV sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
                }
                if (model.image) {
                    [cellAD.imageV setImage:model.image];
                }
                cellAD.placeHolderTV.text = model.picTitle;
            }else
                cellAD.placeHolderTV.text = @"";
        }
        if (indexPath.row == arrayTmp.count - 1 && indexPath.row > 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [addBtn setTitle:@"继续添加" forState:UIControlStateNormal];
            [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:addBtn];
            [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(-16);
                make.top.equalTo(0);
                make.bottom.equalTo(0);
                make.height.equalTo(44);
            }];
            addBtn.tag = indexPath.section;
            [addBtn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
            if (indexPath.section == 6) {
                addBtn.hidden = YES;
            } else {
                addBtn.hidden = NO;
            }
            return cell;
        }
        return cellAD;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.regionView.hidden = true;
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            if (self.model.isCompany) {
                return;
            }
            if (self.islogup) {
                newShopClassificationDetailViewController *vc = [[newShopClassificationDetailViewController alloc] initWithNibName:@"HomeClassificationDetailViewController" bundle:nil];
                [vc.view setBackgroundColor:[UIColor whiteColor]];
                WorkTypeModel *m = [WorkTypeModel new];
                m.name = self.model.typeName;
                [vc getModelWithTitle:m];
                [CacheData sharedInstance];
                vc.blockDidTouchItem = ^(WorkTypeModel *model) {
                    self.model.typeName = model.name;
                    self.model.companyType = model.jobId;
                    [tableView reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                ShopClassificationDetailViewController *vc = [[ShopClassificationDetailViewController alloc] initWithNibName:@"HomeClassificationDetailViewController" bundle:nil];
                [vc.view setBackgroundColor:[UIColor whiteColor]];
                WorkTypeModel *m = [WorkTypeModel new];
                m.name = self.model.typeName;
                [vc getModelWithTitle:m];
                [CacheData sharedInstance];
                vc.blockDidTouchItem = ^(WorkTypeModel *model) {
                    self.model.typeName = model.name;
                    self.model.companyType = model.jobId;
                    [tableView reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
           
        }
    else if (indexPath.row == (self.model.isCompany?7:6)) {
        selfIndexPath =indexPath;
            [self localionButtonAction];
        }else if (indexPath.row == (self.model.isCompany?6:5)) {
            [self getRegion];
        }
    }else{
        NSMutableArray *arrayTmp;
        if (indexPath.section == 1) {
            arrayTmp = [self.model.arrayADTop mutableCopy];
        }else if (indexPath.section == 2) {
            arrayTmp = [self.model.arrayADBottom mutableCopy];
        }
        if (indexPath.row != arrayTmp.count - 1) {
            [ZYCTool actionSheetWithTitleArray:@[@"拍照", @"相册"].mutableCopy target:self notarizeAction:^(NSInteger idx) {
                self.imageMode = indexPath.section;
                self.indexPath = indexPath;
                [self getPicWithIndex:idx];
            }];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        NSMutableArray *arrayTmp;
        if (indexPath.section == 1) {
            arrayTmp = self.model.arrayADTop;
        }else if (indexPath.section == 2) {
            arrayTmp = self.model.arrayADBottom;
        }
        if ([arrayTmp[indexPath.row] class] == [SubsidiaryModel class]) {
            SubsidiaryModel *model = arrayTmp[indexPath.row];
            if (model.image || model.picUrl.length) {
                return UITableViewCellEditingStyleDelete;
            }else
                return UITableViewCellEditingStyleNone;
        }else
            return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *arrayTmp;
    if (indexPath.section == 1) {
        arrayTmp = self.model.arrayADTop;
    }else if (indexPath.section == 2) {
        arrayTmp = self.model.arrayADBottom;
    }
    SubsidiaryModel *model = arrayTmp[indexPath.row];
    if (model.picUrl.length) {
        model.picUrl = @"";
        model.picTitle = @"";
        model.picHref = @"";
        model.type = @"22";
        if (indexPath.section == 1) {
            model.type = @"8";
        }
        [self.arrayDelete addObject:model];
    }
    [arrayTmp removeObject:model];
    if (arrayTmp.count == 1) {
        [arrayTmp addObject:@""];
    }
    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:indexPath.section];
    [self.tableView reloadSections:set withRowAnimation:(UITableViewRowAnimationNone)];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

#pragma mark pic
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
    NSMutableArray *arrayTmp;
    switch (self.imageMode) {
        case VIPExperienceImageModeLogo:
            self.model.imageLogo = image;
            break;
        case VIPExperienceImageModeADTop:
            arrayTmp = self.model.arrayADTop;
            break;
        case VIPExperienceImageModeADBottom:
            arrayTmp = self.model.arrayADBottom;
            break;
        default:
            break;
    }
    SubsidiaryModel *model;
    id obj = arrayTmp[self.indexPath.row];
    if ([NSStringFromClass([obj class]) isEqualToString:@"__NSCFConstantString"]) {
        model = [SubsidiaryModel new];
    }else
        model = arrayTmp[self.indexPath.row];
    model.image = image;
    if (self.imageMode == VIPExperienceImageModeADTop) {
        model.type = @"8";
    }else if (self.imageMode == VIPExperienceImageModeADBottom) {
        model.type = @"22";
    }
    model.isImageChanged = true;
    [arrayTmp replaceObjectAtIndex:self.indexPath.row withObject:model];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
//        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:self.imageMode];
//        [self.tableView reloadSections:set withRowAnimation:(UITableViewRowAnimationNone)];
        [self.tableView reloadData];
        self.indexPath = nil;
    }];
}

// section的值为tag值， 对应的cell 加1  然后刷新这个section
- (void)addImage:(UIButton *) sender {
    [self.view endEditing:YES];
    NSMutableArray *arrayTmp;
    if (sender.tag == 1) {
        arrayTmp = self.model.arrayADTop;
    }else if (sender.tag == 2) {
        arrayTmp = self.model.arrayADBottom;
    }

    if ([arrayTmp[arrayTmp.count - 2] class] != [SubsidiaryModel class]) {
        return;
    }
    if (arrayTmp.count >= 7) {
        [self.view hudShowWithText:@"最多添加6张照片"];
        return;
    }
    [arrayTmp addObject:@""];
    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:sender.tag];
    [self.tableView reloadSections:set withRowAnimation:(UITableViewRowAnimationNone)];
}

- (void)getPicWithIndex:(NSInteger)index {
    NSInteger idx = index;
    if (idx == 0) {
        [ZYCTool controller:self CameraIsAvailable:^{
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.picker animated:YES completion:^{}];
        } OrNotAvailable:^{}];
    }else{
        [ZYCTool controller:self AlbumIsAvailable:^{
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.picker animated:YES completion:^{}];
        } OrNotAvailable:^{}];
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if(!error) {
        NSLog(@"成功图片保存到相册");
    }else{
        NSLog(@"%@",error.localizedDescription);
    }
}

#pragma mark - 定位获取地址
- (void)localionButtonAction {
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        //定位功能可用
        LocationViewController *locationVC = [[LocationViewController alloc] init];
        if (!self.isFirstGetLocation) {
            NSString *addressDetailStr = self.model.detailedAddress.length > 0 ? self.model.detailedAddress:@"";
            NSString *addressStr = self.model.companyAddress.length > 0 ? self.model.companyAddress:@"";
            locationVC.address = [NSString stringWithFormat:@"%@%@", addressStr, addressDetailStr];
            locationVC.longitude = [self.model.longitude doubleValue];
            locationVC.latitude  = [self.model.latitude doubleValue];
        }
//        MJWeakSelf;
//        locationVC.locationBlock = ^(NSString *addressName, double lantitude, double longitude){
//
//           // VIPExperienceTableViewCell *  cell =  [[NSBundle mainBundle] loadNibNamed:@"VIPExperienceTableViewCell" owner:self options:nil][selfIndexPath];
//         //  VIPExperienceTableViewCell *  cell = [VIPExperienceTableViewCell cellWithTableView:self.tableView AndIndex:selfIndexPath];
//            //   cell.textField.text =addressName;
//            self.title =addressName;
////            weakSelf.model.longitude = @(longitude).stringValue;
////            weakSelf.model.latitude = @(lantitude).stringValue;
////            weakSelf.model.detailedAddress = addressName;
////            weakSelf.isFirstGetLocation = false;
// //           [weakSelf.tableView reloadData];
//        };
        [self.navigationController pushViewController:locationVC animated:YES];
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {//定位不可用
        [ZYCTool alertControllerTwoButtonWithTitle:@"没有定位权限" message:@"点击确定前往设置打开定位权限" target:self notarizeButtonTitle:nil cancelButtonTitle:nil notarizeAction:^{
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        } cancelAction:^{}];
    }
}

- (void)makeADArrayWith:(NSMutableArray *)array {
    if (array.count == 0) {
        [array addObjectsFromArray:@[@"", @""]];
    }else if (array.count < 6) {
        [array addObject:@""];
    }
}

- (void)didTouchRightButton {
    [self.view endEditing:YES];
    if (!self.model.companyLogo && !self.model.imageLogo) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"公司logo不能为空" controller:self sleep:1.5];
        return;
    }
    if (self.model.companyName.length == 0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"品牌名称不能为空" controller:self sleep:1.5];
        return;
    }
    if (self.model.companyType.length == 0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"类别不能为空" controller:self sleep:1.5];
        return;
    }

    if (self.model.typeName.integerValue == 1018 || self.model.typeName.integerValue == 1064 || self.model.typeName.integerValue == 1065) {
        if (self.model.areaList.count <= 0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"装修区域不能为空" controller:self sleep:1.5];
            return;
        }
    }
    NSString *temDmodelR = @"";
    if (self.pmodel.name == nil && self.model != nil) {
        NSInteger regionId = [self.pmodel.regionId integerValue];
        if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000){//四个直辖市只传省和市
            if (![self.dmodel.regionId isEqualToString:@"-1"]) {
                self.cmodel.regionId = self.dmodel.regionId;
            }
            temDmodelR = @"-1";
        }else{
            self.cmodel.regionId = self.cmodel.regionId;
            temDmodelR = self.dmodel.regionId;
        }
        if (self.model.companyAddress.length == 0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"地址不能为空" controller:self sleep:1.5];
            return;
        }
        if (self.model.detailedAddress.length == 0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"详细地址不能为空" controller:self sleep:1.5];
            return;
        }
    }else{
        NSInteger regionId = [self.pmodel.regionId integerValue];
        if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000){////四个直辖市只传省和市
            if (![self.dmodel.regionId isEqualToString:@"-1"]) {
                self.cmodel.regionId = self.dmodel.regionId;
            }
            temDmodelR = @"-1";
            self.model.companyAddress = [NSString stringWithFormat:@"%@ %@",[self.pmodel.name isEqual:[NSNull null]] || self.pmodel.name == nil ? @"" : self.pmodel.name,[self.dmodel.name isEqual:[NSNull null]] || self.dmodel.name == nil ? @"" : self.dmodel.name];
        }else{
            self.cmodel.regionId = self.cmodel.regionId;
            temDmodelR = self.dmodel.regionId;
        }
        if (self.model.companyAddress.length == 0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"地址不能为空" controller:self sleep:1.5];
            return;
        }
        if (self.model.detailedAddress.length == 0) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"详细地址不能为空" controller:self sleep:1.5];
            return;
        }
    }

    if (self.model.companyPhone.length) {
        if (![self.model.companyPhone ew_justCheckPhone]|| self.model.companyPhone.length>11) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"业务经理电话格式不正确" controller:self sleep:1.5];
            return;
        }
    }
    if (self.model.companyEmail.length>0) {
        if (![self.model.companyEmail ew_checkEmail]) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"请输入正确的邮箱" controller:self sleep:1.5];
            return;
        }
    }
    if (self.model.companyIntroduction.length == 0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"公司简介不能为空" controller:self sleep:1.5];
        return;
    }
    [self NetworkOfUploadImage];
}

- (void)getRegion {
    WeakSelf(self)
    [self.view endEditing:YES];
    [self.view bringSubviewToFront:self.regionView];
    self.regionView.hidden = false;
    self.regionView.selectBlock = ^(NSMutableArray *array){
        weakself.regionView.hidden = YES;
        weakself.pmodel = [array objectAtIndex:0];
        weakself.cmodel = [array objectAtIndex:1];
        weakself.dmodel = [array objectAtIndex:2];
        weakself.model.companyAddress = [NSString stringWithFormat:@"%@ %@ %@",weakself.pmodel.name,weakself.cmodel.name,weakself.dmodel.name];
        weakself.model.companyProvince = weakself.pmodel.regionId;
        weakself.model.companyCounty = weakself.dmodel.regionId;
        weakself.model.companyCity = weakself.cmodel.regionId;
        NSInteger regionId = [weakself.pmodel.regionId integerValue];
        if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000) {
            weakself.model.companyAddress = [NSString stringWithFormat:@"%@ %@",weakself.pmodel.name,weakself.dmodel.name];
            
            weakself.model.companyProvince = weakself.cmodel.regionId;
            weakself.model.companyCity = weakself.dmodel.regionId;
            weakself.model.companyCounty = @"-1";
            
        }
        [weakself.tableView reloadData];
    };
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.regionView.hidden = YES;
}

- (void)makeImageData {
    NSMutableDictionary *multiDict = [NSMutableDictionary dictionary];
    NSMutableArray *arrayTmpTop = [self.model.arrayADTop mutableCopy];
    NSMutableArray *arrayTmpBottom = [self.model.arrayADBottom mutableCopy];
    [arrayTmpTop enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj class] == [SubsidiaryModel class]) {
            SubsidiaryModel *model = obj;
            if (!model.image && !model.picUrl.length) {
                [arrayTmpTop removeObject:obj];
            }
        }else{
            [arrayTmpTop removeObject:obj];
        }
    }];

    [arrayTmpBottom enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj class] == [SubsidiaryModel class]) {
            SubsidiaryModel *model = obj;
            if (!model.image && !model.picUrl.length) {
                [arrayTmpBottom removeObject:obj];
            }
        }else{
            [arrayTmpBottom removeObject:obj];
        }
    }];

    NSMutableArray *arrayTmp =[NSMutableArray arrayWithArray:arrayTmpTop];
    [arrayTmp addObjectsFromArray:arrayTmpBottom];
    [arrayTmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj class] == [SubsidiaryModel class]) {
            SubsidiaryModel *model = obj;
            if (!model.image && !model.picUrl.length) {
                [arrayTmp removeObject:obj];
            }
        }else{
            [arrayTmp removeObject:obj];
        }
    }];
    [arrayTmp addObjectsFromArray:self.arrayDelete];
    if (!arrayTmp.count) {
        return;
    }
    [self.paramString appendString:@"["];
    for (int i = 0; i < arrayTmp.count; i ++) {
        SubsidiaryModel *model = arrayTmp[i];
        [multiDict setObject:self.model.companyId forKey:@"companyId"];
        [multiDict setObject:model.picUrl?:@"" forKey:@"picUrl"];
        [multiDict setObject:model.picId?:@"0" forKey:@"picId"];
        [multiDict setObject:[NSString stringWithFormat:@"%d", i + 1] forKey:@"sort"];
        [multiDict setObject:model.type forKey:@"type"];
        [multiDict setObject:model.picTitle?:@"" forKey:@"picTitle"];//文字
        [multiDict setObject:model.picHref?:@"" forKey:@"picHref"];//连接
        NSLog(@"%@ ===== %@",model.picTitle, model.picHref);
        NSString *dictStr = [multiDict yy_modelToJSONString];
        [self.paramString appendString:dictStr];
        NSLog(@"%@",self.paramString);
        [self.paramString appendString:@","];
    }
    [self.paramString appendString:@"]"];
}

- (NSMutableArray *)getImageWithArray:(NSMutableArray *)array {
    NSMutableArray *a = [array mutableCopy];
    if (a.count < 6) {
        [a removeLastObject];
    }
    for (int i = 0; i < 6; i++) {
        [a enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj class] == [SubsidiaryModel class]) {
                SubsidiaryModel *model = obj;
                if (!model.image) {
                    [a removeObjectAtIndex:idx];
                }
            }else
                [a removeObjectAtIndex:idx];
        }];
    }
    return a;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    id model;
    NSInteger index = textView.tag - 20;
    if (textView.tag < 20) {
        model = self.model.arrayADTop[textView.tag - 10];
    }else
        model = self.model.arrayADBottom[textView.tag - 20];
    if ([NSStringFromClass([model class]) isEqualToString:@"__NSCFConstantString"]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请先上传广告图"];
        return  false;
    }else
        return true;
}

- (void)textViewDidChange:(UITextView *)textView {
    SubsidiaryModel *model;
    if (textView.tag < 20) {
        model = self.model.arrayADTop[textView.tag - 10];
        model.picHref = textView.text;
    }else{
        model = self.model.arrayADBottom[textView.tag - 20];
        NSString *s = textView.text;
        if (textView.text.length > 100) {
            s = [textView.text substringToIndex:100];
            textView.text = s;
        }
        model.picTitle = s;
    }
    model.isImageChanged = true;
}


-(void)dealloc{
    //  self.locationManager =nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"krefreshNameAddressLabel" object:nil];
    
}
@end
