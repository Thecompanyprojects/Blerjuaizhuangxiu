//
//  LocationViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/9/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "LocationViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CLLocation+YCLocation.h"
#import "Annotation.h"

@interface LocationViewController ()<UINavigationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) Annotation *annotation;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UILabel *nameLabel;


@end

@implementation LocationViewController{
    NSInteger DidUpdataLocationCount;
    CLLocation *Selflocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DidUpdataLocationCount =0;
    Selflocation =[[CLLocation alloc]init];
    self.navigationController.delegate = self;
    self.view.backgroundColor = kBackgroundColor;
    [self creatMap];
  
    [self setUpBackButton];
    [self centerView];
    [self selfLocation];
    
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
#pragma mark - 定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:settingURL];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
      self.nameLabel.hidden = NO;
    //这里的代码是为了判断didUpdateLocations调用了几次 有可能会出现多次调用 为了避免不必要的麻烦 在这里加个if判断 如果大于1.0就return
//    DidUpdataLocationCount ++;
//    if (DidUpdataLocationCount >0) {
//        return;
//    }
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //当前的经纬度
    NSLog(@"当前的经纬度 %f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
        MKCoordinateRegion region =MKCoordinateRegionMake(currentLocation.coordinate, MKCoordinateSpanMake(0.1,0.1));
        [self.mapView setRegion:region animated:YES];
    
   

    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error!=nil || placemarks.count==0) {
          //  location = [location locationBaiduFromMars];
            self.nameLabel.text = @"未命名地址";
            CGFloat latitude = currentLocation.coordinate.latitude;
            CGFloat longitude = currentLocation.coordinate.longitude;
            self.locationBlock(@"",latitude , longitude);
            return ;
        }
        if (placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
          
            //看需求定义一个全局变量来接收赋值
            NSLog(@"当前国家 - %@",placeMark.country);//当前国家
            NSLog(@"当前城市 - %@",placeMark.locality);//当前城市
            NSLog(@"当前位置 - %@",placeMark.subLocality);//当前位置
            NSLog(@"当前街道 - %@",placeMark.thoroughfare);//当前街道
            NSLog(@"具体地址 - %@",placeMark.name);//具体地址
            NSString *message = [NSString stringWithFormat:@"%@,%@,%@",placeMark.subLocality,placeMark.thoroughfare,placeMark.name];

          
            self.nameLabel.text =message;
            Selflocation =currentLocation;
//                self.locationBlock(message, currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
       
        }else if (error == nil && placemarks.count){
            
            NSLog(@"NO location and error return");
        }else if (error){
            
            NSLog(@"loction error:%@",error);
        }
    }];
}


#pragma mark CLLocationManagerDelegate

//定位后的返回结果
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
//     [self.locationManager stopUpdatingLocation];
//    CLLocation *location =[locations firstObject];
////    地球坐标 转到 火星坐标
//    location=[location locationMarsFromEarth];
//
//    if (self.latitude == 0 || self.longitude == 0 || self.latitude == self.longitude) {
//
//        CLGeocoder *geocoder=[[CLGeocoder alloc]init];
//        NSString *addressStr = self.address;//位置信息
//        MJWeakSelf;
//        [geocoder geocodeAddressString:addressStr completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//            if (error!=nil || placemarks.count==0) {
//                MKCoordinateRegion region =MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.1,0.1));
//                [self.mapView setRegion:region animated:YES];
//                return ;
//            }
//            //创建placemark对象
//            CLPlacemark *placemark=[placemarks firstObject];
//            weakSelf.longitude = placemark.location.coordinate.longitude;
//            weakSelf.latitude = placemark.location.coordinate.latitude;
//            // 获得店铺坐标
//            CLLocation *location = [[CLLocation alloc] initWithLatitude:weakSelf.latitude longitude:weakSelf.longitude];
//
//            MKCoordinateRegion region =MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.1,0.1));
//            [weakSelf.mapView setRegion:region animated:YES];
//            }];
//
//    } else {
//        CLLocation *location = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
//        // 百度坐标转高德坐标
//        location = [location locationMarsFromBaidu];
//        MKCoordinateRegion region =MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.1,0.1));
//        [self.mapView setRegion:region animated:YES];
//    }
//  //  [self.locationManager stopUpdatingLocation];
//}

- (NSString *)getAddress {
    __block NSString *string;
    MKCoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = self.mapView.region.center;
    region.center= centerCoordinate;
    __block CLLocation *location = [[CLLocation alloc]initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error!=nil || placemarks.count==0) {
            location = [location locationBaiduFromMars];
            self.nameLabel.text = @"未命名地址";
            CGFloat latitude = location.coordinate.latitude;
            CGFloat longitude = location.coordinate.longitude;
            self.locationBlock(@"",latitude , longitude);
            return ;
        }

        for (CLPlacemark *place in placemarks) {
            YSNLog(@"要上传的高德位置：longitude: %.16f, lantitue: %.16f", location.coordinate.longitude, location.coordinate.latitude);
            location = [location locationBaiduFromMars];
            NSString *nameStr = place.name.length> 0? place.name : @"";
           
            CGFloat latitude = location.coordinate.latitude;
            CGFloat longitude = location.coordinate.longitude;
            YSNLog(@"要上传的百度位置：longitude: %.16f, lantitue: %.16f", longitude, latitude);
         //   self.locationBlock(self.nameLabel.text,latitude , longitude);
    
             self.nameLabel.text = [NSString stringWithFormat:@"%@", nameStr];
            string =nameStr;
           
        }
    }];
    return string;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
  //  self.nameLabel.hidden = YES;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    self.nameLabel.hidden = NO;
    MKCoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center= centerCoordinate;
    __block CLLocation *location = [[CLLocation alloc]initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error!=nil || placemarks.count==0) {
            location = [location locationBaiduFromMars];
            self.nameLabel.text = @"未命名地址";
            CGFloat latitude = location.coordinate.latitude;
            CGFloat longitude = location.coordinate.longitude;
            self.locationBlock(@"",latitude , longitude);
            return ;
        }

        for (CLPlacemark *place in placemarks) {
//            NSDictionary *locationDict =[place addressDictionary];
//            NSLog(@"国家：%@",[locationDict objectForKey:@"Country"]);
//            NSLog(@"城市：%@",[locationDict objectForKey:@"State"]);
//            NSLog(@"区：%@",[locationDict objectForKey:@"SubLocality"]);
//            NSLog(@"位置：%@", place.name);
//            NSLog(@"国家：%@", place.country);
//            NSLog(@"城市：%@", place.locality);
//            NSLog(@"区：%@", place.subLocality);
//            NSLog(@"街道：%@", place.thoroughfare);
//            NSLog(@"子街道：%@", place.subThoroughfare);

            YSNLog(@"要上传的高德位置：longitude: %.16f, lantitue: %.16f", location.coordinate.longitude, location.coordinate.latitude);
          //  location = [location locationBaiduFromMars];
            NSString *nameStr = place.name.length> 0? place.name : @"";
            self.nameLabel.text = [NSString stringWithFormat:@"%@", nameStr];
            CGFloat latitude = location.coordinate.latitude;
            CGFloat longitude = location.coordinate.longitude;
            YSNLog(@"要上传的百度位置：longitude: %.16f, lantitue: %.16f", longitude, latitude);
              Selflocation =location;
//            if (self.locationBlock) {
//                 self.locationBlock(self.nameLabel.text,latitude , longitude);
//            }
           
        }
    }];

}
#pragma mark 返回Actioin
- (void)backAction {
   
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"krefreshNameAddressLabel" object:nil userInfo:@{ @"addressName":self.nameLabel.text,
                                                                                                                  @"longitude":@(Selflocation.coordinate.longitude),
                                                                                                                  @"latitude":@(Selflocation.coordinate.latitude)                             }];
    sleep(2);
     [self.navigationController popViewControllerAnimated:YES];
 //   NSDictionary *dic =notification.userInfo;
//    NSString* addressName =[dic objectForKey:@"addressName"];
//
//    NSInteger longitude =(NSInteger)[dic objectForKey:@"longitude"];
//    NSInteger latitude =(NSInteger)[dic objectForKey:@"latitude"];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}


#pragma mark - lazy Method
- (UIView *)centerView {
    if (_centerView == nil) {
        _centerView = [[UIView alloc] init];
        [self.view addSubview:_centerView];
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.centerY.equalTo(-20);
            make.size.equalTo(CGSizeMake(40, 40));
        }];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shopLocation"]];
        imageView.frame = CGRectMake(0, 0, 40, 40);
        [_centerView addSubview:imageView];
        
        UILabel *label = [UILabel new];
        self.nameLabel = label;
        [_centerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.bottom.equalTo(imageView.mas_top).equalTo(0);
            make.size.equalTo(CGSizeMake(220, 40));
        }];
        label.backgroundColor = [UIColor orangeColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.layer.cornerRadius = 4;
        label.numberOfLines = 2;
        label.layer.masksToBounds = YES;
        label.hidden = YES;
        
    }
    return _centerView;
}

@end
