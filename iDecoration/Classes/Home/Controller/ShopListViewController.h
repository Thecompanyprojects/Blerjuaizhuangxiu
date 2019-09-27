//
//  ShopListViewController.h
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHCityModel.h"
@interface ShopListViewController : UIViewController

@property (nonatomic, copy) NSString *longititude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic ,strong) ZCHCityModel* cityModel;
@property (nonatomic ,strong) ZCHCityModel* countyModel;

@property (nonatomic, copy) NSString *cityNumber;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic ,copy) NSString *serachContent;
@property (nonatomic ,copy) NSString *origin;



@end
