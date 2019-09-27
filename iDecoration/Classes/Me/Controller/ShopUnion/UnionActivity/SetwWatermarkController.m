//
//  SetwWatermarkController.m
//  iDecoration
//  设置水印
//  Created by sty on 2017/11/21.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SetwWatermarkController.h"
#import "DesignCaseListModel.h"
#import "DesignCaseListController.h"
#import <CoreLocation/CoreLocation.h>

#import "CreatActivityController.h"
#import "EditMyBeatArtController.h"
#import "EditNewsActivityController.h"

#define IMGH  60
@interface SetwWatermarkController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>{
    BOOL isAddWater;//是否添加水印
    BOOL isAddUpTime;//是否添加时间
    BOOL isAddCompanyName;//是否公司名称
    BOOL isAddAgency;//是否添加作者
    BOOL isAddCompanyLogo;//是否添加公司logo
    
    NSString *coverStr;
    
    CLLocationManager *_locationManager;//定位服务管理类
    CLGeocoder *_geocoder;//初始化地理编码器
}
@property (nonatomic, strong) UIImageView *imgV;

@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UIButton *isAddWaterBtn;
@property (nonatomic, strong) UIButton *upTimeBtn;
@property (nonatomic, strong) UIButton *companyNameBtn;
@property (nonatomic, strong) UIButton *agencyBtn;
@property (nonatomic, strong) UIButton *defaultlogoBtn;
@property (nonatomic, strong) UIImageView *logoImg;


@property (nonatomic, strong) UIImage *companyImg;
@property (nonatomic, strong) UIButton *addressBtn;
@property (nonatomic, copy) NSString *locatoinStr;//位置信息
//@property (nonatomic, copy) NSString *comanyLogoStr;

@property (nonatomic, strong) NSMutableArray *temArray;
@end

@implementation SetwWatermarkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置水印";
    // Do any additional setup after loading the view.
    
    [self initLocationService];
    self.temArray = [NSMutableArray array];
    isAddWater = NO;
    isAddUpTime = YES;
    isAddCompanyName = YES;
    if (self.fromTag==5||self.fromTag==7) {
        isAddCompanyName = NO;
    }
    isAddAgency = YES;
    isAddCompanyLogo = YES;
//    self.comanyLogoStr = @"";
    
    
    [self setUI];
    
    
    
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

-(void)setUI{
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, 100)];
    imgV.userInteractionEnabled = YES;
    imgV.layer.masksToBounds= YES;
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *img = self.imgArray[0];
    imgV.image = img;
    [imgV sizeToFit];
    
    CGFloat imgOrigW = imgV.width;
    CGFloat imgOrigH = imgV.height;
    CGFloat imgNewW = kSCREEN_WIDTH;
    CGFloat imgNewH = imgOrigH*imgNewW/imgOrigW;
    
    CGFloat bottomH = 0;
    if (self.fromTag==5||self.fromTag==7) {
        bottomH = kSCREEN_HEIGHT-64-150;
    }
    else{
        bottomH = kSCREEN_HEIGHT-64-200;
    }
    if (imgNewH>=bottomH) {
        imgNewH = bottomH;
    }
    imgV.frame = CGRectMake(0, 64, kSCREEN_WIDTH, imgNewH);
    
    self.imgV = imgV;
    [self.view addSubview:self.imgV];
    
    
    
    CGFloat hhh = 0;
    if (self.fromTag==5||self.fromTag==7){
        hhh = 150;
    }else{
        hhh = 200;
    }
    
    UIView *bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, self.imgV.bottom, kSCREEN_WIDTH, hhh)];
    bottomV.backgroundColor = White_Color;
    self.bottomV = bottomV;
    
    [self.view addSubview:self.bottomV];
    CGFloat viewH = 0;
    
    //个人美文和别的布局不一样，去掉公司和logo信息
    if (self.fromTag==5||self.fromTag==7) {
        for (int i = 0; i<3; i++) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, viewH, self.bottomV.width, self.bottomV.height/3)];
            [self.bottomV addSubview:view];
            
            if (i==0) {
                UIButton *successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                successBtn.frame = CGRectMake(28,0,120,view.height-1);
                successBtn.backgroundColor = White_Color;
                [successBtn setTitle:@"是否添加水印" forState:UIControlStateNormal];
                successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [successBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                successBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                
                
                self.isAddWaterBtn = successBtn;
                [view addSubview:self.isAddWaterBtn];
                
                UIButton *temWaterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                temWaterBtn.frame = CGRectMake(successBtn.right,10,view.height-20,view.height-20);
                [temWaterBtn setImage:[UIImage imageNamed:@"water_square"] forState:UIControlStateNormal];
                [temWaterBtn addTarget:self action:@selector(temWaterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:temWaterBtn];
                //            successBtn.layer.masksToBounds = YES;
                //            successBtn.layer.cornerRadius = 5;
            }
            else if (i==1){
                UIButton *successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                successBtn.frame = CGRectMake(10,0,view.width-10,view.height-1);
                successBtn.backgroundColor = White_Color;
                NSString *currentStr = [self getCurrentTimes];
                NSString *temStr = [NSString stringWithFormat:@"上传时间:(%@)",currentStr];
                [successBtn setTitle:temStr forState:UIControlStateNormal];
                successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [successBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                successBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                [successBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
                [successBtn addTarget:self action:@selector(upTimeClick) forControlEvents:UIControlEventTouchUpInside];
                [successBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
                
                //            [successBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, -100)];
                self.upTimeBtn = successBtn;
                [view addSubview:self.upTimeBtn];
            }
            else if (i==2){
//                UIButton *successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                successBtn.frame = CGRectMake(10,0,120,view.height-1);
//                successBtn.backgroundColor = White_Color;
//                [successBtn setTitle:@"公司名称" forState:UIControlStateNormal];
//                successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                [successBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
//                successBtn.titleLabel.font = NB_FONTSEIZ_NOR;
//                [successBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
//                [successBtn addTarget:self action:@selector(companyClick) forControlEvents:UIControlEventTouchUpInside];
//
//                [successBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
//                //            [successBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, -100)];
//                self.companyNameBtn = successBtn;
//                [view addSubview:self.companyNameBtn];
                
                UIButton *autorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                autorBtn.frame = CGRectMake(10,0,120,view.height-1);
                autorBtn.backgroundColor = White_Color;
                [autorBtn setTitle:@"作者" forState:UIControlStateNormal];
                autorBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [autorBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                autorBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                [autorBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
                [autorBtn addTarget:self action:@selector(agencyClick) forControlEvents:UIControlEventTouchUpInside];
                
                [autorBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
                //            [successBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, -100)];
                self.agencyBtn = autorBtn;
                [view addSubview:self.agencyBtn];
            }
            else{
//                UIButton *successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                successBtn.frame = CGRectMake(10,0,90,view.height-1);
//                successBtn.backgroundColor = White_Color;
//                [successBtn setTitle:@"LOGO: " forState:UIControlStateNormal];
//                successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                [successBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
//                successBtn.titleLabel.font = NB_FONTSEIZ_NOR;
//                [successBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
//                [successBtn addTarget:self action:@selector(companyLogoClick) forControlEvents:UIControlEventTouchUpInside];
//                [successBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
//                //            [successBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, -100)];
//                self.defaultlogoBtn = successBtn;
//                [view addSubview:self.defaultlogoBtn];
//
//
//                UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(successBtn.right+10,10,view.height-20,view.height-20)];
//                imgV.userInteractionEnabled = YES;
//                imgV.layer.masksToBounds= YES;
//                imgV.contentMode = UIViewContentModeScaleAspectFill;
//                __weak typeof(self) weakSelf = self;
//                [imgV sd_setImageWithURL:[NSURL URLWithString:self.comanyLogoStr] placeholderImage:[UIImage imageNamed:@"jia_kuang"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    if (image) {
//                        weakSelf.companyImg = image;
//                    }
//                }];
//                UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagePicker)];
//                [imgV addGestureRecognizer:ges];
//                //            UIButton *logoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                //            logoBtn.frame = CGRectMake(successBtn.right+10,10,view.height-20,view.height-20);
//                //            [logoBtn setImage:[UIImage imageNamed:@"jia_kuang"] forState:UIControlStateNormal];
//                //            [logoBtn addTarget:self action:@selector(imagePicker) forControlEvents:UIControlEventTouchUpInside];
//                //            [logoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
//                //            [successBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, -100)];
//                self.logoImg = imgV;
//                [view addSubview:self.logoImg];
            }
            
            
            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, view.height-1, view.width, 1)];
            lineV.backgroundColor = kSepLineColor;
            [view addSubview:lineV];
            viewH = viewH+self.bottomV.height/3;
        }
    }
    else{
        for (int i = 0; i<4; i++) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, viewH, self.bottomV.width, self.bottomV.height/4)];
            [self.bottomV addSubview:view];
            
            if (i==0) {
                UIButton *successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                successBtn.frame = CGRectMake(28,0,120,view.height-1);
                successBtn.backgroundColor = White_Color;
                [successBtn setTitle:@"是否添加水印" forState:UIControlStateNormal];
                successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [successBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                successBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                
                
                self.isAddWaterBtn = successBtn;
                [view addSubview:self.isAddWaterBtn];
                
                UIButton *temWaterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                temWaterBtn.frame = CGRectMake(successBtn.right,10,view.height-20,view.height-20);
                [temWaterBtn setImage:[UIImage imageNamed:@"water_square"] forState:UIControlStateNormal];
                [temWaterBtn addTarget:self action:@selector(temWaterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:temWaterBtn];
                //            successBtn.layer.masksToBounds = YES;
                //            successBtn.layer.cornerRadius = 5;
            }
            else if (i==1){
                UIButton *successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                successBtn.frame = CGRectMake(10,0,view.width-10,view.height-1);
                successBtn.backgroundColor = White_Color;
                NSString *currentStr = [self getCurrentTimes];
                NSString *temStr = [NSString stringWithFormat:@"上传时间:(%@)",currentStr];
                [successBtn setTitle:temStr forState:UIControlStateNormal];
                successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [successBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                successBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                [successBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
                [successBtn addTarget:self action:@selector(upTimeClick) forControlEvents:UIControlEventTouchUpInside];
                [successBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
                
                //            [successBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, -100)];
                self.upTimeBtn = successBtn;
                [view addSubview:self.upTimeBtn];
            }
            else if (i==2){
                UIButton *successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                successBtn.frame = CGRectMake(10,0,120,view.height-1);
                successBtn.backgroundColor = White_Color;
                [successBtn setTitle:@"公司名称" forState:UIControlStateNormal];
                successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [successBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                successBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                [successBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
                [successBtn addTarget:self action:@selector(companyClick) forControlEvents:UIControlEventTouchUpInside];
                
                [successBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
                //            [successBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, -100)];
                self.companyNameBtn = successBtn;
                [view addSubview:self.companyNameBtn];
                
                UIButton *autorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                autorBtn.frame = CGRectMake(view.width/2+10,0,80,view.height-1);
                autorBtn.backgroundColor = White_Color;
                [autorBtn setTitle:@"作者" forState:UIControlStateNormal];
                autorBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [autorBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                autorBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                [autorBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
                [autorBtn addTarget:self action:@selector(agencyClick) forControlEvents:UIControlEventTouchUpInside];
                
                [autorBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
                //            [successBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, -100)];
                self.agencyBtn = autorBtn;
                [view addSubview:self.agencyBtn];
            }
            else{
                UIButton *successBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                successBtn.frame = CGRectMake(10,0,90,view.height-1);
                successBtn.backgroundColor = White_Color;
                [successBtn setTitle:@"LOGO: " forState:UIControlStateNormal];
                successBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [successBtn setTitleColor:COLOR_BLACK_CLASS_3 forState:UIControlStateNormal];
                successBtn.titleLabel.font = NB_FONTSEIZ_NOR;
                [successBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
                [successBtn addTarget:self action:@selector(companyLogoClick) forControlEvents:UIControlEventTouchUpInside];
                [successBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
                //            [successBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, -100)];
                self.defaultlogoBtn = successBtn;
                [view addSubview:self.defaultlogoBtn];
                
                
                UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(successBtn.right+10,10,view.height-20,view.height-20)];
                imgV.userInteractionEnabled = YES;
                imgV.layer.masksToBounds= YES;
                imgV.contentMode = UIViewContentModeScaleAspectFill;
                __weak typeof(self) weakSelf = self;
                [imgV sd_setImageWithURL:[NSURL URLWithString:self.comanyLogoStr] placeholderImage:[UIImage imageNamed:@"jia_kuang"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image) {
                        weakSelf.companyImg = image;
                    }
                }];
                UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagePicker)];
                [imgV addGestureRecognizer:ges];
                //            UIButton *logoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                //            logoBtn.frame = CGRectMake(successBtn.right+10,10,view.height-20,view.height-20);
                //            [logoBtn setImage:[UIImage imageNamed:@"jia_kuang"] forState:UIControlStateNormal];
                //            [logoBtn addTarget:self action:@selector(imagePicker) forControlEvents:UIControlEventTouchUpInside];
                //            [logoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
                //            [successBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, -100)];
                self.logoImg = imgV;
                [view addSubview:self.logoImg];
            }
            
            
            UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, view.height-1, view.width, 1)];
            lineV.backgroundColor = kSepLineColor;
            [view addSubview:lineV];
            viewH = viewH+self.bottomV.height/4;
        }
    }
    
    
    
    
//    [self addWaterWithCompanyLogo:nil CompanyName:@"转换发生地方" UpTime:nil UpDetailTime:nil AgencyNamePhoto:nil agencyNameStr:nil AddressPhoto:nil AddressStr:nil toImage:img];
    
    [self resetImgV];
    
}

#pragma mark - 初始化定位
-(void)initLocationService{
    
    _locationManager = [[CLLocationManager alloc]init];
    [_locationManager requestWhenInUseAuthorization];
//    [_locationManager requestAlwaysAuthorization];//iOS8必须，这两行必须有一行执行，否则无法获取位置信息，和定位
    _locationManager.delegate = self;
    //设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //开始定位之后会不断的执行代理方法更新位置会比较费电所以建议获取完位置即时关闭更新位置服务
    [_locationManager startUpdatingLocation];
    
    _geocoder = [[CLGeocoder alloc]init];
}

#pragma mark - 定位的代理方法

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    YSNLog(@"%lu",(unsigned long)locations.count);
    CLLocation *location = locations.lastObject;
   //纬度
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    
    YSNLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",location.coordinate.longitude,location.coordinate.latitude,location.altitude,location.course,location.speed);
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count>0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            YSNLog(@"%@",placemark.name);
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            //位置名
            YSNLog(@"name,%@",placemark.name);
            //街道
            YSNLog(@"thoroughfare,%@",placemark.thoroughfare);
            //子街道
            YSNLog(@"subThoroughfare,%@",placemark.subThoroughfare);
            //市
            YSNLog(@"locality,%@",placemark.location);
            //区
            YSNLog(@"subLocality,%@",placemark.subLocality);
            //国家
            YSNLog(@"county,%@",placemark.country);
            self.locatoinStr = placemark.name;
            
            
        }
        else if(error==nil&&[placemarks count]==0){
            YSNLog(@"No results were returned.");
            self.locatoinStr = @"";
            [[PublicTool defaultTool] publicToolsHUDStr:@"暂未定位到具体地址" controller:self sleep:1.5];
        }
        else if (error==nil){
            YSNLog(@"An error occurred=%@",error);
            self.locatoinStr = @"";
            [[PublicTool defaultTool] publicToolsHUDStr:@"定位失败" controller:self sleep:1.5];
        }
        else{
            self.locatoinStr = @"";
            YSNLog(@"error");
            [[PublicTool defaultTool] publicToolsHUDStr:@"定位失败" controller:self sleep:1.5];
        }
        [self.addressBtn setTitle:self.locatoinStr forState:UIControlStateNormal];
        
    }];
    [manager stopUpdatingLocation];//不用的时候关闭更新位置服务
}

#pragma mark - 重置imgV的布局
-(void)resetImgV{
    [self.imgV removeAllSubViews];
    
    NSString *yyyyStr = [self getCurrentTimesOfyyyy];
    NSString *xingQin = [self weekdayStringFromDate:[NSDate date]];
    NSString *temTimeStr = [NSString stringWithFormat:@"%@ %@",yyyyStr,xingQin];
    
    NSString *hhStr = [self getCurrentTimesOfhh];
    if (isAddWater) {
        if (isAddCompanyLogo&&(self.companyImg||self.comanyLogoStr.length>0)) {
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, IMGH, IMGH)];
            imgV.userInteractionEnabled = YES;
            imgV.layer.masksToBounds= YES;
            imgV.contentMode = UIViewContentModeScaleAspectFill;
            if (self.companyImg) {
                imgV.image = self.companyImg;
            }
            else{
                [imgV sd_setImageWithURL:[NSURL URLWithString:self.comanyLogoStr] placeholderImage:[UIImage imageNamed:@"jia_kuang"]];
            }
//            imgV.image = self.companyImg;
            [self.imgV addSubview:imgV];
            
            
            if (isAddCompanyName&&isAddUpTime) {
                UILabel *companyName = [[UILabel alloc]initWithFrame:CGRectMake(imgV.right+10, imgV.top-2, kSCREEN_WIDTH-10-(imgV.right+10), 20)];
                companyName.text = self.companyName;
                companyName.textColor = White_Color;
                companyName.font = NB_FONTSEIZ_WATRE;
                companyName.textAlignment = NSTextAlignmentLeft;
                [self.imgV addSubview:companyName];
                
                UILabel *sundayL = [[UILabel alloc]initWithFrame:CGRectMake(companyName.left, companyName.bottom+3, companyName.width, 20)];
                sundayL.text = temTimeStr;
                sundayL.textColor = White_Color;
                sundayL.font = NB_FONTSEIZ_WATRE;
                sundayL.textAlignment = NSTextAlignmentLeft;
                [self.imgV addSubview:sundayL];
                
                UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(companyName.left, sundayL.bottom+2, companyName.width, 20)];
                timeL.text = hhStr;
                timeL.textColor = White_Color;
                timeL.font = NB_FONTSEIZ_WATRE;
                timeL.textAlignment = NSTextAlignmentLeft;
                [self.imgV addSubview:timeL];
            }
            else if (isAddCompanyName&&!isAddUpTime){
                
                UILabel *companyName = [[UILabel alloc]initWithFrame:CGRectMake(imgV.right+10, imgV.top, kSCREEN_WIDTH-10-(imgV.right+10), imgV.height)];
                companyName.text = self.companyName;
                companyName.textColor = White_Color;
                companyName.font = NB_FONTSEIZ_WATRE;
                companyName.textAlignment = NSTextAlignmentLeft;
                [self.imgV addSubview:companyName];
                
            }
            else if (!isAddCompanyName&&isAddUpTime){
                UILabel *sundayL = [[UILabel alloc]initWithFrame:CGRectMake(imgV.right+10, imgV.top-2, kSCREEN_WIDTH-10-(imgV.right+10), 20)];
                sundayL.text = temTimeStr;
                sundayL.textColor = White_Color;
                sundayL.font = NB_FONTSEIZ_WATRE;
                sundayL.textAlignment = NSTextAlignmentLeft;
                [self.imgV addSubview:sundayL];
                
                UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(sundayL.left, sundayL.bottom+25, sundayL.width, sundayL.height)];
                timeL.text = hhStr;
                timeL.textColor = White_Color;
                timeL.font = NB_FONTSEIZ_WATRE;
                timeL.textAlignment = NSTextAlignmentLeft;
                [self.imgV addSubview:timeL];
            }
            else{
                
            }
        }
        else{
            if (isAddCompanyName&&isAddUpTime) {
                UILabel *companyName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kSCREEN_WIDTH-10, 20)];
                companyName.text = self.companyName;
                companyName.textColor = White_Color;
                companyName.font = NB_FONTSEIZ_WATRE;
                companyName.textAlignment = NSTextAlignmentLeft;
                [self.imgV addSubview:companyName];
                
                UILabel *sundayL = [[UILabel alloc]initWithFrame:CGRectMake(companyName.left, companyName.bottom, kSCREEN_WIDTH-10, 20)];
                sundayL.text = temTimeStr;
                sundayL.textColor = White_Color;
                sundayL.font = NB_FONTSEIZ_WATRE;
                sundayL.textAlignment = NSTextAlignmentLeft;
                [self.imgV addSubview:sundayL];
                
                UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(companyName.left, sundayL.bottom, kSCREEN_WIDTH-10, 20)];
                timeL.text = hhStr;
                timeL.textColor = White_Color;
                timeL.font = NB_FONTSEIZ_WATRE;
                timeL.textAlignment = NSTextAlignmentLeft;
                [self.imgV addSubview:timeL];
            }
            else if (isAddCompanyName&&!isAddUpTime){
                
                UILabel *companyName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kSCREEN_WIDTH-10, 50)];
                companyName.text = self.companyName;
                companyName.textColor = White_Color;
                companyName.font = NB_FONTSEIZ_WATRE;
                companyName.textAlignment = NSTextAlignmentLeft;
                [self.imgV addSubview:companyName];
                
            }
            else if (!isAddCompanyName&&isAddUpTime){
                UILabel *sundayL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kSCREEN_WIDTH-10, 25)];
                sundayL.text = temTimeStr;
                sundayL.textColor = White_Color;
                sundayL.font = NB_FONTSEIZ_WATRE;
                sundayL.textAlignment = NSTextAlignmentLeft;
                [self.imgV addSubview:sundayL];
                
                UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(sundayL.left, sundayL.bottom, kSCREEN_WIDTH-10, 25)];
                timeL.text = hhStr;
                timeL.textColor = White_Color;
                timeL.font = NB_FONTSEIZ_WATRE;
                timeL.textAlignment = NSTextAlignmentLeft;
                [self.imgV addSubview:timeL];
            }
            else{
                
            }
        }
        
        UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addressBtn.frame = CGRectMake(0,self.imgV.height-40,kSCREEN_WIDTH-15,30);
//        addressBtn.backgroundColor = White_Color;
        if (!self.locatoinStr||self.locatoinStr.length<=0) {
            self.locatoinStr = @"";
        }
        [addressBtn setTitle:self.locatoinStr forState:UIControlStateNormal];
        addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [addressBtn setTitleColor:White_Color forState:UIControlStateNormal];
        [addressBtn setImage:[UIImage imageNamed:@"water_mark_location"] forState:UIControlStateNormal];
        addressBtn.userInteractionEnabled = NO;
        
        addressBtn.titleLabel.font = NB_FONTSEIZ_WATRE;
        [addressBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
        self.addressBtn = addressBtn;
        [self.imgV addSubview:self.addressBtn];
        
        if (isAddAgency) {
            UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
            UIButton *agencyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            agencyBtn.frame = CGRectMake(0,addressBtn.top-30,kSCREEN_WIDTH-15,30);
            //        addressBtn.backgroundColor = White_Color;
            [agencyBtn setTitle:user.trueName forState:UIControlStateNormal];
            agencyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [agencyBtn setTitleColor:White_Color forState:UIControlStateNormal];
            [agencyBtn setImage:[UIImage imageNamed:@"water_mark_people"] forState:UIControlStateNormal];
            
            agencyBtn.titleLabel.font = NB_FONTSEIZ_WATRE;
            [agencyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
            [self.imgV addSubview:agencyBtn];
        }
    }
    else{
        
    }
    
}

-(void)temWaterBtnClick:(UIButton *)btn{
    isAddWater = !isAddWater;
    if (isAddWater) {
        self.upTimeBtn.userInteractionEnabled = YES;
        self.companyNameBtn.userInteractionEnabled = YES;
        self.agencyBtn.userInteractionEnabled = YES;
        self.defaultlogoBtn.userInteractionEnabled = YES;
        self.logoImg.userInteractionEnabled = YES;
        [btn setImage:[UIImage imageNamed:@"water_selectSquare"] forState:UIControlStateNormal];
    }
    else{
        self.upTimeBtn.userInteractionEnabled = NO;
        self.companyNameBtn.userInteractionEnabled = NO;
        self.agencyBtn.userInteractionEnabled = NO;
        self.defaultlogoBtn.userInteractionEnabled = NO;
        self.logoImg.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"water_square"] forState:UIControlStateNormal];
    }
    
    [self resetImgV];
    
    
}

-(void)upTimeClick{
    isAddUpTime = !isAddUpTime;
    if (isAddUpTime) {
        [self.upTimeBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
    }
    else{
        [self.upTimeBtn setImage:[UIImage imageNamed:@"water_Circle"] forState:UIControlStateNormal];
    }
    
    [self resetImgV];
}

-(void)companyClick{
    isAddCompanyName = !isAddCompanyName;
    if (isAddCompanyName) {
        [self.companyNameBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
    }
    else{
        [self.companyNameBtn setImage:[UIImage imageNamed:@"water_Circle"] forState:UIControlStateNormal];
    }
    
    [self resetImgV];
}

-(void)agencyClick{
    isAddAgency = !isAddAgency;
    if (isAddAgency) {
        [self.agencyBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
    }
    else{
        [self.agencyBtn setImage:[UIImage imageNamed:@"water_Circle"] forState:UIControlStateNormal];
    }
    
    [self resetImgV];
}

-(void)companyLogoClick{
    isAddCompanyLogo = !isAddCompanyLogo;
    if (isAddCompanyLogo) {
        [self.defaultlogoBtn setImage:[UIImage imageNamed:@"water_selectCircle"] forState:UIControlStateNormal];
    }
    else{
        [self.defaultlogoBtn setImage:[UIImage imageNamed:@"water_Circle"] forState:UIControlStateNormal];
    }
    
    [self resetImgV];
}

-(void)successBtnClick:(UIButton *)btn{
//    UIImage *img = self.imgArray[0];
    UIImage *imgTwo = [UIImage imageNamed:@"water_mark_people"];
    UIImage *imgThree = [UIImage imageNamed:@"water_mark_location"];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    
    NSString *yyyyStr = [self getCurrentTimesOfyyyy];
    NSString *xingQin = [self weekdayStringFromDate:[NSDate date]];
    NSString *temTimeStr = [NSString stringWithFormat:@"%@ %@",yyyyStr,xingQin];
    
    NSString *hhStr = [self getCurrentTimesOfhh];
    
    NSMutableArray *temArray = [NSMutableArray array];
    for (UIImage *img in self.imgArray) {
        if (!self.locatoinStr||self.locatoinStr.length<=0) {
            self.locatoinStr = @"";
        }
        UIImage *tempImg = [self addWaterWithCompanyLogo:self.companyImg CompanyName:self.companyName UpTime:temTimeStr UpDetailTime:hhStr AgencyNamePhoto:imgTwo agencyNameStr:user.trueName AddressPhoto:imgThree AddressStr:self.locatoinStr toImage:img];
        
//        UIImageWriteToSavedPhotosAlbum(tempImg,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
        [temArray addObject:tempImg];
    }
    [self.temArray removeAllObjects];
    [self.temArray addObjectsFromArray:temArray];
    if (self.fromTag==1||self.fromTag==8) {
        [self uploadImg:self.imgArray[0]];
        
//        [self uploadImgWith:[temArray copy]];
    }
    else if (self.fromTag==2||self.fromTag==7){
        [self uploadImgWith:[temArray copy]];
    }
    
    else if (self.fromTag==3){
        if (self.setWaterBlock) {
            self.setWaterBlock(temArray,self.editTag);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.fromTag==4){
        [self uploadImg:self.imgArray[0]];
//        [self uploadImgWith:[temArray copy]];
    }
    else if (self.fromTag==5){
        [self uploadImg:self.imgArray[0]];
//        [self uploadImgWith:[temArray copy]];
    }
    else if (self.fromTag==6){
        [self uploadImg:self.imgArray[0]];
    }
    else if (self.fromTag==9){
        [self uploadImg:self.imgArray[0]];
    }
    else{
        
        
    
//    [self uploadImgWith:[temArray copy]];
    }
    
//    [self.imgV removeAllSubViews];
//    self.imgV.image = tempImg;
//
//    [self.imgV sizeToFit];
//
//    CGFloat imgOrigW = self.imgV.width;
//    CGFloat imgOrigH = self.imgV.height;
//    CGFloat imgNewW = kSCREEN_WIDTH;
//    CGFloat imgNewH = imgOrigH*imgNewW/imgOrigW;
//
//    if (imgNewH>=(kSCREEN_HEIGHT-64-200)) {
//        imgNewH = kSCREEN_HEIGHT-64-200;
//    }
//    self.imgV.frame = CGRectMake(0, 64, kSCREEN_WIDTH, imgNewH);
//
//    UIImageWriteToSavedPhotosAlbum(tempImg,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
}

#pragma mark - 选择图片

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
    self.companyImg = chooseImage;
    self.logoImg.image = self.companyImg;
    
    [self resetImgV];
    //    NSData *imageData = UIImageJPEGRepresentation(chooseImage, PHOTO_COMPRESS);
//    NSData *imageData = [NSObject imageData:chooseImage];
//
//    if ([imageData length] >0) {
//        imageData = [GTMBase64 encodeData:imageData];
//    }
//    NSString *imageStr = [[NSString alloc]initWithData:imageData encoding:NSUTF8StringEncoding];
//
//    [self uploadImageWithBase64Str:imageStr];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 图片上传
- (void)uploadImgWith:(NSArray *)imgArray{
    //    NSLog(@"名字:%@ 和身份证号:%@", name, idNum);
    // －－－－－－－－－－－－－－－－－－－－－－－－－－－－上传图片－－－－
    /*
     此段代码如果需要修改，可以调整的位置
     1. 把upload.php改成网站开发人员告知的地址
     2. 把name改成网站开发人员告知的字段名
     */
    // 查询条件
    //    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", idNum, @"idNumber", nil];
    
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"file/uploadFiles.do"];
    
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    
    // 在parameters里存放照片以外的对象
    [manager POST:defaultApi parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < imgArray.count; i++) {
            
            UIImage *image = imgArray[i];
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
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        YSNLog(@"---上传进度--- %@",uploadProgress);
        YSNLog(@"%f",uploadProgress.fractionCompleted);
        
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        NSArray *arr = [responseObject objectForKey:@"imgList"];
        
        NSMutableArray *dataArray = [NSMutableArray array];
        
        
        //1:新增本案设计 2:编辑本案设计（店长手记） 4:联盟活动 8:新增店长手记 9:礼品券
        if (self.fromTag==1||self.fromTag==8) {
            for (NSDictionary *dict in arr) {
                //            [imgArr addObject:[dict objectForKey:@"imgUrl"]];
                
                DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
                model.imgUrl = [dict objectForKey:@"imgUrl"];
                model.detailsId = 0;
                model.content = @"";
                model.htmlContent = @"";
                [dataArray addObject:model];
                
            }
            
            
            DesignCaseListController *designVC = [[DesignCaseListController alloc]init];
            designVC.consID = self.consID;
            designVC.isPower = self.isDesiger;
            designVC.dataArray = dataArray;
            
            if (self.fromTag==1) {
                designVC.fromIndex=1;
            }
            if (self.fromTag==8) {
                designVC.fromIndex=2;
            }
            //        DesignCaseListModel *temModel = dataArray.firstObject;
            designVC.coverImgUrl = coverStr;
            designVC.isFistr = YES;
            designVC.companyLogo = self.comanyLogoStr;
            designVC.companyName = self.companyName;
            designVC.companyId = [NSString stringWithFormat:@"%ld",self.companyId];
            
            designVC.isComplate = self.isComplate;
            [self.navigationController pushViewController:designVC animated:YES];
        }
        else if (self.fromTag==2||self.fromTag==7||self.fromTag==9){
            for (NSDictionary *dict in arr) {
                [dataArray addObject:[dict objectForKey:@"imgUrl"]];
            }
            if (self.setWaterBlock) {
                self.setWaterBlock(dataArray,self.editTag);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        else if (self.fromTag==4) {
            for (NSDictionary *dict in arr) {
                //            [imgArr addObject:[dict objectForKey:@"imgUrl"]];
                
                DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
                model.imgUrl = [dict objectForKey:@"imgUrl"];
                model.detailsId = 0;
                model.content = @"";
                model.htmlContent = @"";
                [dataArray addObject:model];
                
            }
            
            
            CreatActivityController *designVC = [[CreatActivityController alloc]init];
            designVC.unionId = self.unionId;
            designVC.consID = self.unionId;
            designVC.isPower = YES;
            designVC.dataArray = dataArray;
            
//            DesignCaseListModel *temModel = dataArray.firstObject;
            designVC.coverImgUrl = coverStr;
            designVC.isFistr = YES;
            designVC.companyLogo = self.comanyLogoStr;
            designVC.companyName = self.companyName;
            designVC.companyId = self.companyId;
            
            designVC.isComplate = NO;
//            designVC.reloadBlock = ^{
//                //刷新列表信息
//                [self requestActivityListInfo];
//            };
            [self.navigationController pushViewController:designVC animated:YES];
        }
        
        else if (self.fromTag==5){
            for (NSDictionary *dict in arr) {
                //            [imgArr addObject:[dict objectForKey:@"imgUrl"]];
                
                DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
                model.imgUrl = [dict objectForKey:@"imgUrl"];
                model.detailsId = 0;
                model.content = @"";
                model.htmlContent = @"";
                [dataArray addObject:model];
                
            }
            
            
            EditMyBeatArtController *designVC = [[EditMyBeatArtController alloc]init];
            
            designVC.isPower = YES;
            designVC.dataArray = dataArray;
            
            //            DesignCaseListModel *temModel = dataArray.firstObject;
            designVC.coverImgUrl = coverStr;
            designVC.isFistr = YES;
//            designVC.companyLogo = self.comanyLogoStr;
//            designVC.companyName = self.companyName;
//            designVC.companyId = self.companyId;
            
            designVC.isComplate = NO;
            //            designVC.reloadBlock = ^{
            //                //刷新列表信息
            //                [self requestActivityListInfo];
            //            };
            [self.navigationController pushViewController:designVC animated:YES];
        }
        
        else if (self.fromTag==6){
            for (NSDictionary *dict in arr) {
                //            [imgArr addObject:[dict objectForKey:@"imgUrl"]];
                
                DesignCaseListModel *model = [[DesignCaseListModel alloc]init];
                model.imgUrl = [dict objectForKey:@"imgUrl"];
                model.detailsId = 0;
                model.content = @"";
                model.htmlContent = @"";
                [dataArray addObject:model];
                
            }
            
            
            EditNewsActivityController *designVC = [[EditNewsActivityController alloc]init];
            
            designVC.isPower = YES;
            designVC.dataArray = dataArray;
            
            //            DesignCaseListModel *temModel = dataArray.firstObject;
            designVC.coverImgUrl = coverStr;
            designVC.isFistr = YES;
            designVC.companyLogo = self.comanyLogoStr;
            designVC.companyName = self.companyName;
            designVC.companyId = self.companyId;
            designVC.jobTag = self.jobTag;
            
            designVC.isComplate = NO;
            //            designVC.reloadBlock = ^{
            //                //刷新列表信息
            //                [self requestActivityListInfo];
            //            };
            [self.navigationController pushViewController:designVC animated:YES];
        }
        
        else{
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YSNLog(@"xxx上传失败xxx %@", error);
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        
    }];
}

//单独上传封面
- (void)uploadImg:(UIImage *)img{
    //    NSLog(@"名字:%@ 和身份证号:%@", name, idNum);
    // －－－－－－－－－－－－－－－－－－－－－－－－－－－－上传图片－－－－
    /*
     此段代码如果需要修改，可以调整的位置
     1. 把upload.php改成网站开发人员告知的地址
     2. 把name改成网站开发人员告知的字段名
     */
    // 查询条件
    //    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", idNum, @"idNumber", nil];
    
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"file/uploadFiles.do"];
    
    
//    [[UIApplication sharedApplication].keyWindow hudShow];
    
    // 在parameters里存放照片以外的对象
    [manager POST:defaultApi parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        NSData *imageData = [NSObject imageData:img];
        
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
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        YSNLog(@"---上传进度--- %@",uploadProgress);
        YSNLog(@"%f",uploadProgress.fractionCompleted);
        
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        NSArray *arr = [responseObject objectForKey:@"imgList"];
        NSDictionary *dict = arr.firstObject;
        coverStr = [dict objectForKey:@"imgUrl"];
        
        [self uploadImgWith:[self.temArray copy]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        YSNLog(@"xxx上传失败xxx %@", error);
        
//        [[UIApplication sharedApplication].keyWindow hiddleHud];
//
//        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        
    }];
}


-(UIImage *)addWaterWithCompanyLogo:(UIImage *)companyLogo CompanyName:(NSString *)CompanyName UpTime:(NSString *)upTime UpDetailTime:(NSString *)upDetailTime AgencyNamePhoto:(UIImage *)agencyNamePhoto agencyNameStr:(NSString *)agencyNameStr AddressPhoto:(UIImage *)addressPhoto AddressStr:(NSString *)addressStr toImage:(UIImage *)img{
    CGSize imgSize = img.size;
    if (isAddWater) {
        CGFloat height = img.size.height;
        CGFloat width = img.size.width;
        //开启一个图形上下文
        UIGraphicsBeginImageContext(img.size);
        
        //在图片上下文中绘制图片
        [img drawInRect:CGRectMake(0, 0,width,height)];
        
        NSDictionary* dicOne = [NSDictionary dictionaryWithObjectsAndKeys:NB_FONTSEIZ_WATRE, NSFontAttributeName,White_Color ,NSForegroundColorAttributeName,nil];
        NSDictionary* dicTwo = [NSDictionary dictionaryWithObjectsAndKeys:NB_FONTSEIZ_WATRE, NSFontAttributeName,White_Color ,NSForegroundColorAttributeName,nil];
        //在图片的指定位置绘制文字   -- 7.0以后才有这个方法
//        [CompanyName drawInRect:CGRectMake(10, 10, 100, 30) withAttributes:dicOne];
        
        CGFloat startLeft = 10;
        if (isAddCompanyLogo&&companyLogo) {
            [companyLogo drawInRect:CGRectMake(10, 10, IMGH, IMGH)];
            startLeft = 80;
        }
        CGFloat rectWidth = kSCREEN_WIDTH-startLeft-10;
        if (isAddCompanyName&&isAddUpTime){
            [CompanyName drawInRect:CGRectMake(startLeft, 8, rectWidth, 20) withAttributes:dicOne];
            [upTime drawInRect:CGRectMake(startLeft, 31, rectWidth, 20) withAttributes:dicTwo];
            [upDetailTime drawInRect:CGRectMake(startLeft, 53, rectWidth, 20) withAttributes:dicTwo];
        }
        else if (isAddCompanyName&&!isAddUpTime){
            [CompanyName drawInRect:CGRectMake(startLeft, 8+IMGH/2-10, rectWidth, 20) withAttributes:dicOne];
        }
        else if (!isAddCompanyName&&isAddUpTime){
            [upTime drawInRect:CGRectMake(startLeft, 8, rectWidth, 20) withAttributes:dicTwo];
            [upDetailTime drawInRect:CGRectMake(startLeft, 53, rectWidth, 20) withAttributes:dicTwo];
        }
        else{
            
        }
        
        CGSize addrect = [addressStr boundingRectWithSize:CGSizeMake(imgSize.width-15-30, 20) withFont:NB_FONTSEIZ_WATRE];
        [addressStr drawInRect:CGRectMake(imgSize.width-15-addrect.width, imgSize.height-20-10, addrect.width, 20) withAttributes:dicOne];
        [addressPhoto drawInRect:CGRectMake(imgSize.width-15-addrect.width-30, imgSize.height-25-8, 20, 25)];
        
        if (isAddAgency){
            CGSize addrectTwo = [agencyNameStr boundingRectWithSize:CGSizeMake(imgSize.width-15-30, 20) withFont:NB_FONTSEIZ_WATRE];
            [agencyNameStr drawInRect:CGRectMake(imgSize.width-15-addrectTwo.width, imgSize.height-20-30-10, addrectTwo.width, 20) withAttributes:dicOne];
            [agencyNamePhoto drawInRect:CGRectMake(imgSize.width-15-addrectTwo.width-30, imgSize.height-25-30-8, 20, 25)];
        }
        
        //从图形上下文拿到最终的图片
        UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
        
        //关闭图片上下文
        UIGraphicsEndImageContext();
        return newImg;
    }
    else{
        return img;
    }
    
}

//添加文字水印到指定图片上
+(UIImage *)addWaterText:(NSString *)text Attributes:(NSDictionary*)atts toImage:(UIImage *)img rect:(CGRect)rect{
    
    CGFloat height = img.size.height;
    CGFloat width = img.size.width;
    //开启一个图形上下文
    UIGraphicsBeginImageContext(img.size);
    
    //在图片上下文中绘制图片
    [img drawInRect:CGRectMake(0, 0,width,height)];
    
    
    //在图片的指定位置绘制文字   -- 7.0以后才有这个方法
    [text drawInRect:rect withAttributes:atts];
    
    
    
    //从图形上下文拿到最终的图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图片上下文
    UIGraphicsEndImageContext();
    
    return newImg;
}

+(UIImage *)addWaterImage:(UIImage *)waterImg toImage:(UIImage *)img rect:(CGRect)rect{
    
    CGFloat height = img.size.height;
    CGFloat width = img.size.width;
    //开启一个图形上下文
    UIGraphicsBeginImageContext(img.size);
    
    //在图片上下文中绘制图片
    [img drawInRect:CGRectMake(0, 0,width,height)];
    
    //在图片指定位置绘制图片
    [waterImg drawInRect:rect];
    
    //从图形上下文拿到最终的图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图片上下文
    UIGraphicsEndImageContext();
    
    return newImg;
}


- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    
    if(!error) {
        
        NSLog(@"成功图片保存到相册");
        
    }else{
        
        NSLog(@"%@",error.localizedDescription);
        
    }
    
}



//获取当前的时间 YYYY-MM-dd HH:mm:ss

-(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    YSNLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

//获取当前的时间 YYYY.MM.dd

-(NSString*)getCurrentTimesOfyyyy{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY.MM.dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    YSNLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

//获取当前的时间 YYYY.MM.dd

-(NSString*)getCurrentTimesOfhh{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"HH:mm"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    YSNLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

//获取星期
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
