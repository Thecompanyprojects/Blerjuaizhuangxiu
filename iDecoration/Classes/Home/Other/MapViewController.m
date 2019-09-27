//
//  MapViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/9/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CLLocation+YCLocation.h"
#import "MapTool.h"
#import "MyCustomAnnotation.h"
#import "MyCustomAnnotationView.h"

@interface MapViewController ()<UINavigationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UIButton *navButton;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationController.delegate = self;
    self.view.backgroundColor = kBackgroundColor;
    
    [self creatMap];
    [self selfLocation];
    [self setUpBackButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectOtherMapNavitation) name:@"kSelectOtherMapFormNavigation" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- 调用外部地图导航
- (void)selectOtherMapNavitation {
    CLLocationCoordinate2D coordinate =  CLLocationCoordinate2DMake(self.latitude, self.longitude);
    // 传入高德坐标
    [[MapTool sharedMapTool] navigationActionWithCoordinate:coordinate WithENDName:self.companyAddress tager:self];
    
}
- (void)setUpBackButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 40, 40, 40);
    [self.view addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"mapBack"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"mapBack"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark创建地图

-(void)creatMap{
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate=self;
    [self.view addSubview:self.mapView];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    
    // 添加店铺大头针
    // 经或纬度为 0  使用地理编码
    if (self.latitude == 0 || self.longitude == 0) {
        CLGeocoder *geocoder=[[CLGeocoder alloc]init];
        NSString *addressStr = self.companyAddress;//位置信息
        MJWeakSelf;
        [geocoder geocodeAddressString:addressStr completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error!=nil || placemarks.count==0) {
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"未找到商家位置"];
                return ;
            }
            //创建placemark对象
            CLPlacemark *placemark=[placemarks firstObject];
            weakSelf.longitude = placemark.location.coordinate.longitude;
            weakSelf.latitude = placemark.location.coordinate.latitude;
            // 获得店铺坐标
            CLLocation *location = [[CLLocation alloc] initWithLatitude:weakSelf.latitude longitude:weakSelf.longitude];
            MKCoordinateRegion region =MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.1,0.1));
            [weakSelf.mapView setRegion:region animated:YES];
            
            MyCustomAnnotation *annotation = [[MyCustomAnnotation alloc] initWithLocation:location.coordinate];
            annotation.companyName = self.companyName;
            annotation.companyAddress = self.companyAddress;
            annotation.imageName = @"shopLocation";
            [self.mapView addAnnotation:annotation];
            
        }];
    } else {
        // 获得店铺坐标
        CLLocation *location = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
        YSNLog(@"从后台获取的百度坐标位置：%.16f -- %.16f", self.latitude, self.longitude);
        // 百度坐标转高德坐标
        location = [location locationMarsFromBaidu];
        YSNLog(@"从后台获取的高德坐标位置：%.16f -- %.16f", location.coordinate.latitude, location.coordinate.longitude);
        self.latitude = location.coordinate.latitude;
        self.longitude = location.coordinate.longitude;
        MKCoordinateRegion region =MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.1,0.1));
        [self.mapView setRegion:region animated:YES];
        
        
        MyCustomAnnotation *annotation = [[MyCustomAnnotation alloc] initWithLocation:location.coordinate];
        annotation.companyName = self.companyName;
        annotation.companyAddress = self.companyAddress;
        annotation.imageName = @"shopLocation";
        [self.mapView addAnnotation:annotation];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}
#pragma mark定位自己

-(void)selfLocation{
    self.locationManager =[[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy =kCLLocationAccuracyBest;
    self.locationManager.distanceFilter=10.0;
    self.locationManager.delegate=self;
    CLAuthorizationStatus status =[CLLocationManager authorizationStatus];
    if(status==kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark CLLocationManagerDelegate

//定位后的返回结果
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location =[locations firstObject];
    //地球坐标 转到 火星坐标
    location=[location locationMarsFromEarth];
    
}

//大头针的回调方法（与cell的复用机制很相似）
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation{
    
//    if ([annotation isKindOfClass:[Annotation class]]) {
//        static NSString *identifier = @"annotation";
//        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//        if (annotationView == nil) {
//            annotationView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:identifier];
//            annotationView.canShowCallout = YES;
//            annotationView.centerOffset = CGPointMake(0, -20);
//
//            UIView *rightView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 56)];
//            rightView.backgroundColor = [UIColor orangeColor];
//            rightView.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navAction)];
//            [rightView addGestureRecognizer:tapGR];
//
//            UILabel *navLabel = [UILabel new];
//            [rightView addSubview:navLabel];
//            [navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(0);
//                make.left.equalTo(rightView.mas_right).equalTo(-45);
//            }];
//            navLabel.text = @"导航";
//            navLabel.font = [UIFont systemFontOfSize:15];
//            navLabel.textColor = [UIColor whiteColor];
//
//            UIImageView *navImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav"]];
//            [rightView addSubview:navImageV];
//            [navImageV mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(0);
//                make.right.equalTo(navLabel.mas_left).equalTo(-5);
//                make.size.equalTo(CGSizeMake(18, 18));
//            }];
//
//            annotationView.rightCalloutAccessoryView = rightView;
//
//        };
//
//        annotationView.annotation = annotation;
//        Annotation *anno = annotation;
//        annotationView.image = [UIImage imageNamed:anno.imageName];
//        return annotationView;
//
//    }
//    return nil;
    
    if ([annotation isKindOfClass:[MyCustomAnnotation class]]){
        MyCustomAnnotationView *annotationView = (MyCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MyCustomAnnotationView"];
        if (!annotationView) {
            annotationView = [[MyCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyCustomAnnotationView"];
            annotationView.centerOffset = CGPointMake(0, -20);
        }
        annotationView.annotation = annotation;
        MyCustomAnnotation *anno = annotation;
        annotationView.image = [UIImage imageNamed:anno.imageName];
        return annotationView;
    }
    return nil;
}


#pragma 返回Actioin
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//#pragma  调用外部地图导航
//
//- (void)navAction {
//    YSNLog(@"导航");
//    CLLocationCoordinate2D coordinate =  CLLocationCoordinate2DMake(self.latitude, self.longitude);
//    // 传入高德坐标
//    [[MapTool sharedMapTool] navigationActionWithCoordinate:coordinate WithENDName:self.companyAddress tager:self];
//}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}
@end
