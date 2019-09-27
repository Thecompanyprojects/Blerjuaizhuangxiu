//
//  ApplyDistributionVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ApplyDistributionVC.h"
#import "ApplydistributionCell.h"
#import "XYQRegexPatternHelper.h"
#import "ApplydistributionCell1.h"
#import "CGXPickerView.h"
#import "ApplydistributionCell2.h"
#import "ApplydistributionCell3.h"
#import "ApplydistributionCell4.h"
#import "dockingchooseVC.h"
#import "RegionView.h"
#import "PModel.h"
#import "CModel.h"
#import "DModel.h"
#import "TZImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "STPhotoKitController.h"
#import "UIImagePickerController+ST.h"
#import "STConfig.h"

typedef NS_ENUM(NSInteger, PhotoType)
{
    PhotoTypeleft,
    PhotoTyperight
};

typedef NS_ENUM(NSInteger, codeType)
{
    codeTypedocking,
    codeTypedistribution,
    codeTypenone
};

@interface ApplyDistributionVC ()<UITableViewDataSource,UITableViewDelegate,myTabVdelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, STPhotoKitDelegate,myapplydelegate>
{
    BOOL isshowleft;
    BOOL isshowright;
}
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,copy) NSString *idCard;//身份证号
@property (nonatomic,copy) NSString *phone;//联系方式
@property (nonatomic,copy) NSString *wechat;//微信号码
@property (nonatomic,copy) NSString *province;//省
@property (nonatomic,copy) NSString *city;//市
@property (nonatomic,copy) NSString *county;//县
@property (nonatomic,copy) NSString *agencyId;//id
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *middleCode;//对接人邀请码
@property (nonatomic,copy) NSString *trueName2;//对接人姓名
@property (nonatomic,strong) RegionView *regionView;
@property (nonatomic,copy) NSString *cityId;//城市id
@property (nonatomic,copy) NSString *provinceId;//省id
@property (nonatomic,copy) NSString *countyId;//区县id
@property (nonatomic,copy) NSString *idCardImg;
@property (nonatomic,copy) NSString *idCardPhoto;
@property (nonatomic,assign) PhotoType type;
@property (nonatomic,assign) codeType codetype;
@end

static NSString *applydistriutionidentfid0 = @"applydistriutionidentfid0";
static NSString *applydistriutionidentfid1 = @"applydistriutionidentfid1";
static NSString *applydistriutionidentfid2 = @"applydistriutionidentfid2";
static NSString *applydistriutionidentfid3 = @"applydistriutionidentfid3";
static NSString *applydistriutionidentfid4 = @"applydistriutionidentfid4";
static NSString *applydistriutionidentfid5 = @"applydistriutionidentfid5";

@implementation ApplyDistributionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请成为分销员";
    self.city = @"";
    self.address = @"请选择地址";
    self.middleCode = @"";
    self.trueName2 = @"选择对接人";
    self.cityId = @"";
    self.idCardImg = [NSString new];
    self.idCardPhoto = [NSString new];
    self.phone = [NSString new];
    isshowleft = NO;
    isshowright = NO;
    self.codetype = codeTypedocking;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:@"duijieren1" object:nil];
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitbtnclick)];
    self.navigationItem.rightBarButtonItem = myButton;
    
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.tableFooterView = [UIView new];
    
    [self.view addSubview:self.table];
    
    self.idCard = @"";
    self.wechat = @"";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)notice:(NSNotification *)sender{
    NSLog(@"%@",sender.object);
    
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, BLEJWidth, naviBottom) style:UITableViewStyleGrouped];
        _table.dataSource = self;
        _table.delegate = self;
    }
    return _table;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else if (section==1) {
        return 1;
    }else if (section==2) {
        return 1;
    }
    else if (section==3)
    {
        return 3;
    }
    else if (section==4)
    {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:applydistriutionidentfid0];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:applydistriutionidentfid0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"请填写您的基本信息，选择想要在哪个城市推广（会有所在城市对接人和您联系），如果您知道对接人或上级分销员的邀请码，可以选填";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 0;
        return cell;
    }
    if (indexPath.section==1) {
        ApplydistributionCell *cell = [tableView dequeueReusableCellWithIdentifier:applydistriutionidentfid1];
        if (!cell) {
            cell = [[ApplydistributionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:applydistriutionidentfid1];
        }
        if (indexPath.row==0) {
            cell.applyText.text = self.trueName;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setdata:indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section==2) {
        
        //别删 - 说不定什么时候就加回来了呢 - 留给有缘人
//        if (indexPath.row==0) {
//            ApplydistributionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"applydistriutionidentfid11"];
//            if (!cell) {
//                cell = [[ApplydistributionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"applydistriutionidentfid11"];
//            }
//            cell.leftLab.text = @"证件照认证";
//            [cell.contentLab setHidden:NO];
//            [cell.applyText setHidden:YES];
//            cell.separatorInset = UIEdgeInsetsMake(0, kSCREEN_WIDTH, 0, 0);
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            return cell;
//        }
//        if (indexPath.row==0) {
//            ApplydistributionCell3 *cell = [tableView dequeueReusableCellWithIdentifier:applydistriutionidentfid5];
//            if (!cell) {
//                cell = [[ApplydistributionCell3 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:applydistriutionidentfid5];
//                cell.leftImg.tag = 2001;
//                cell.rightImg.tag = 2002;
//            }
//            cell.backgroundColor = kBackgroundColor;
//            cell.img0.userInteractionEnabled = YES;
//            cell.img1.userInteractionEnabled = YES;
//            UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftchooseclick)];
//            [cell.img0 addGestureRecognizer:singleTap1];
//            UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightchooseclick)];
//            [cell.img1 addGestureRecognizer:singleTap2];
//            [cell.leftBtn addTarget:self action:@selector(leftchooseclick) forControlEvents:UIControlEventTouchUpInside];
//            [cell.rightBtn addTarget:self
//                              action:@selector(rightchooseclick) forControlEvents:UIControlEventTouchUpInside];
//            if (isshowleft) {
//                [cell.img0 setHidden:YES];
//                [cell.imgBtn0 setHidden:YES];
//                [cell.leftBtn setHidden:NO];
//            }
//            else
//            {
//                [cell.img0 setHidden:NO];
//                [cell.imgBtn0 setHidden:NO];
//                [cell.leftBtn setHidden:YES];
//            }
//            if (isshowright) {
//                [cell.img1 setHidden:YES];
//                [cell.imgBtn1 setHidden:YES];
//                [cell.rightBtn setHidden:NO];
//            }
//            else
//            {
//                [cell.img1 setHidden:NO];
//                [cell.imgBtn1 setHidden:NO];
//                [cell.rightBtn setHidden:YES];
//            }
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            return cell;
//        }
        if (indexPath.row==0) {
            ApplydistributionCell *cell = [tableView dequeueReusableCellWithIdentifier:applydistriutionidentfid1];
            if (!cell) {
                cell = [[ApplydistributionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:applydistriutionidentfid1];
            }
            cell.leftLab.text = @"微信号";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
    
    }
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            ApplydistributionCell1 *cell = [tableView dequeueReusableCellWithIdentifier:applydistriutionidentfid2];
            if (!cell) {
                cell = [[ApplydistributionCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:applydistriutionidentfid2];
            }
            cell.leftLab.text = @"所在城市";
            cell.contentlab.text = self.address;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        if (indexPath.row==1) {
            
            ApplydistributionCell4 *cell = [tableView dequeueReusableCellWithIdentifier:applydistriutionidentfid3];
            if (!cell) {
                cell = [[ApplydistributionCell4 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:applydistriutionidentfid3];
                //cell.codeText.tag = 201;
            }
            //cell.leftLab.text = @"对接人邀请码（选填）";
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        if (indexPath.row==2) {
            ApplydistributionCell2 *cell = [tableView dequeueReusableCellWithIdentifier:applydistriutionidentfid4];
            if (!cell) {
                cell = [[ApplydistributionCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:applydistriutionidentfid4];
                cell.codeText.tag = 202;
            }
             cell.leftLab.text = @"填写邀请码";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if(indexPath.section == 4){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:applydistriutionidentfid0];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:applydistriutionidentfid0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"1.请选择您要在哪个城市推广，该城市的对接人收受到您信息，第一时间与您联系\n2.如果您知道对接人或者上级分销员的的邀请码，可以直接输入（非必填）\n3.如果您有任何疑问，请联系客服QQ：3379607351";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 0;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 100;
    }else if (indexPath.section==2) {
        if (indexPath.row==1) {
            return 184.f;
        }
        else
        {
            return 60.0f;
        }
        return 204.f;
    }else if (indexPath.section==3)
    {
        return 60.0f;
    }
    else if (indexPath.section==4)
    {
        return 100.0f;
    }
    else{
        return 60.0f;
    }
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    return nil;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }
    return 0.01f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            __weak typeof(self) weakSelf = self;

            [weakSelf getNative];
        }
    }
}

#pragma mark - 地区选择
-(void)getNative{
    
    __weak ApplyDistributionVC *weakSelf = self;
    
    self.regionView = [[RegionView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-305, kSCREEN_WIDTH, 305)];
    self.regionView.closeBtn.hidden = NO;
    [self.view addSubview:self.regionView];
    
    self.regionView.selectBlock = ^(NSMutableArray *array){
        [weakSelf.regionView removeFromSuperview];
        PModel *pmodel = [array objectAtIndex:0];
        CModel *cmodel = [array objectAtIndex:1];
        DModel *dmodel = [array objectAtIndex:2];
        NSString *str1 = pmodel.name;
        NSString *str2 = cmodel.name;
        NSString *str3 = dmodel.name;
        
        weakSelf.province = str1;
        weakSelf.city = str2;
        weakSelf.county = str3;
        
        weakSelf.cityId = cmodel.regionId;
        weakSelf.provinceId = pmodel.regionId;
        weakSelf.countyId = dmodel.regionId;
        weakSelf.address = [NSString stringWithFormat:@"%@%@%@",weakSelf.province,weakSelf.city,weakSelf.county];
        [weakSelf.table reloadData];
    };
}

#pragma mark - 图片选择上传

-(void)leftchooseclick
{
    self.type = PhotoTypeleft;
    //[self addimgwithtype:@"0"];
    [self editImageSelected];
}

-(void)rightchooseclick
{
    self.type = PhotoTyperight;
    //[self addimgwithtype:@"1"];
    [self editImageSelected];
}

#pragma mark - --- event response 事件相应 ---
- (void)editImageSelected
{
    UIAlertController *alertController = [[UIAlertController alloc]init];
    
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([controller isAvailableCamera] && [controller isSupportTakingPhotos]) {
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
        }else {
            NSLog(@"%s %@", __FUNCTION__, @"相机权限受限");
        }
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [controller setDelegate:self];
        if ([controller isAvailablePhotoLibrary]) {
            [self presentViewController:controller animated:YES completion:nil];
        }    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:action0];
    [alertController addAction:action1];
    [alertController addAction:action2];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - 1.STPhotoKitDelegate的委托

- (void)photoKitController:(STPhotoKitController *)photoKitController resultImage:(UIImage *)resultImage
{
    UIImageView *img0 = [self.table viewWithTag:2001];
    UIImageView *img1 = [self.table viewWithTag:2002];
    switch (self.type) {
        case PhotoTypeleft:
            img0.image = resultImage;
            isshowleft = YES;
            [self.table reloadData];
            [self uploaddata:resultImage withtype:@"0"];
            break;
        case PhotoTyperight:
            img1.image = resultImage;
            isshowright = YES;
            [self.table reloadData];
            [self uploaddata:resultImage withtype:@"1"];
            break;

        default:
            break;
    }
}

#pragma mark - 2.UIImagePickerController的委托

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImageView *img0 = [self.table viewWithTag:2001];
    UIImageView *img1 = [self.table viewWithTag:2002];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
        STPhotoKitController *photoVC = [STPhotoKitController new];
        [photoVC setDelegate:self];
        [photoVC setImageOriginal:imageOriginal];
        switch (self.type) {
            case PhotoTypeleft:

                [photoVC setSizeClip:CGSizeMake(img0.width*2, img0.height*2)];
                break;
            case PhotoTyperight:

                [photoVC setSizeClip:CGSizeMake(img1.width*2, img1.height*2)];
                break;

            default:
                break;
        }
        
        
        [self presentViewController:photoVC animated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}


-(void)addimgwithtype:(NSString *)type
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UIImage *img = [photos firstObject];

        
        UIImageView *img0 = [self.table viewWithTag:2001];
        UIImageView *img1 = [self.table viewWithTag:2002];
        
        if ([type isEqualToString:@"0"]) {
            img0.image = img;
            isshowleft = YES;
        }
        if ([type isEqualToString:@"1"]) {
            img1.image = img;
            isshowright = YES;
        }
        [self.table reloadData];
        [self uploaddata:img withtype:type];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - 实现方法

-(void)uploaddata:(UIImage *)img withtype:(NSString *)type
{
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"file/uploadFiles.do"];
    
    // 在parameters里存放照片以外的对象
    [manager POST:defaultApi parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        UIImage *image = img;
        //            NSData *imageData = UIImageJPEGRepresentation(image, PHOTO_COMPRESS);
        NSData *imageData = [NSObject imageData:image];
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
        /*
         *该方法的参数
         1. appendPartWithFileData：要上传的照片[二进制流]
         2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
         3. fileName：要保存在服务器上的文件名
         4. mimeType：上传的文件的类型
         */
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"]; //
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        YSNLog(@"---上传进度--- %@",uploadProgress);
        YSNLog(@"%f",uploadProgress.fractionCompleted);
        // NSString *temStr = [NSString stringWithFormat:@"%.2f",uploadProgress.fractionCompleted];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // [self.progress setProgress:progress animated:YES];
            
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        YSNLog(@"```上传成功``` %@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue]==1000) {
            NSArray *arr = [responseObject objectForKey:@"imgList"];
            NSDictionary *dic = [arr firstObject];
            
            
            if ([type isEqualToString:@"0"]) {
                self.idCardImg = [dic objectForKey:@"imgUrl"];

            }
            if ([type isEqualToString:@"1"]) {
                self.idCardPhoto = [dic objectForKey:@"imgUrl"];
            }
            

            [self.table reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YSNLog(@"xxx上传失败xxx %@", error);
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - 实现方法

-(void)myTabVClick:(UITableViewCell *)cell andtextstr:(NSString *)textstr
{
    NSIndexPath *index = [_table indexPathForCell:cell];
    NSLog(@"333===%ld",index.section);
    
    if (index.section==1) {
        switch (index.row) {
            case 0:
                self.trueName = textstr;
                break;
                
            case 1:
                

                self.idCard = textstr;
                break;
            default:
                break;
        }
    }
    if (index.section==2) {
        if (index.row==0) {
            self.wechat = textstr;
        }
      
       
    }
    
 
}

-(void)submitbtnclick
{

    if (self.trueName.length==0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入姓名" controller:self sleep:1.5];
        return;
    }
    if (self.trueName.length>4) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"真实姓名不可超过4个字" controller:self sleep:1.5];
        return;
    }

    if (self.wechat.length==0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请填写微信号" controller:self sleep:1.5];
        return;
    }
    else
    {
        NSString *middleCode = @"";//对接人邀请码
        NSString *inviteCode = @"";//上级分销员邀请码
        

        NSString *hometownProvinceId = [NSString new];
        NSString *hometownCityId = [NSString new];
        NSString *hometownCountyId = [NSString new];
        
        
        if (IsNilString(self.provinceId)) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"请选择城市" controller:self sleep:1.5];
        }
        else
        {
            if ([self.provinceId isEqualToString:@"110000"]||[self.provinceId isEqualToString:@"120000"]||[self.provinceId isEqualToString:@"500000"]||[self.provinceId isEqualToString:@"310000"]) {
                hometownProvinceId = self.cityId;
                hometownCityId = self.countyId;
                hometownCountyId = @"-1";
            }
            else
            {
                hometownProvinceId = self.provinceId;
                hometownCityId = self.cityId;
                hometownCountyId = self.countyId;
            }
            
            if ([hometownProvinceId isEqualToString:@"-1"]&&[hometownCityId isEqualToString:@"-1"]) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请选择城市" controller:self sleep:1.5];
                return;
            }
            

            UITextField *textfiled1 = [self.table viewWithTag:202];
            
            if (self.codetype==codeTypedocking) {
                middleCode = textfiled1.text;
                inviteCode = @"";
            }
            if (self.codetype==codeTypedistribution) {
                inviteCode = textfiled1.text;
                middleCode = @"";
            }
            if (self.codetype==codeTypenone) {
                middleCode = @"";
                inviteCode = @"";
            }
            
            
            self.agencyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
            
            NSDictionary *para = @{@"agencyId":self.agencyId,@"trueName":self.trueName,@"weixin":self.wechat,@"middleCode":middleCode,@"inviteCode":inviteCode,@"hometownProvinceId":hometownProvinceId,@"hometownCityId":hometownCityId,@"hometownCountyId":hometownCountyId};
            NSString *url = [BASEURL stringByAppendingString:POST_applySpread];
            [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        
                if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                    
                   // [[PublicTool defaultTool] publicToolsHUDStr:@"您的资料已提交，所在城市的对接人会及时和您联系，如有疑问请联系客服QQ：3379607351" controller:self.navigationController sleep:1.4];
                    
                    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的资料已提交，所在城市的对接人会及时和您联系，如有疑问请联系客服QQ：3379607351" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [control addAction:action0];
                    [control addAction:action1];
                    [self presentViewController:control animated:YES completion:^{
                        
                    }];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                else if ([[responseObj objectForKey:@"code"] intValue]==1004)
                {
                     [[PublicTool defaultTool] publicToolsHUDStr:@"身份证号码已存在，请重新填写" controller:self sleep:1.5];
                }
                else
                {
                    NSString *msg = [responseObj objectForKey:@"msg"];
                    [[PublicTool defaultTool] publicToolsHUDStr:msg controller:self sleep:1.5];
                }
                
            } failed:^(NSString *errorMsg) {
                
            }];
            
        }
        }
     
}

- (void)dealloc {
    //删除根据name和对象，如果object对象设置为nil，则删除所有叫name的，否则便删除对应的
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"duijieren1" object:nil];
}

#pragma mark - myapplydelegate

-(void)choosecodetypebtn0
{
    self.codetype = codeTypedocking;
}

-(void)choosecodetypebtn1
{
    self.codetype = codeTypedistribution;
}

-(void)choosecodetypebtn2
{
    self.codetype = codeTypenone;
}

@end
