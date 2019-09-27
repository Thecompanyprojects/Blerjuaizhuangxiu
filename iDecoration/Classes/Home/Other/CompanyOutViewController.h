//
//  CompanyOutViewController.h
//  iDecoration
//
//  Created by Apple on 2017/4/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "ZCHCityModel.h"
@interface CompanyOutViewController : SNViewController
@property (nonatomic ,copy) NSString *longitudety;
@property (nonatomic ,copy) NSString *latitudety;


@property (nonatomic ,strong) ZCHCityModel* cityModel;
@property (nonatomic ,strong) ZCHCityModel* countyModel;

@property (nonatomic ,copy) NSString *serachContent;
//@property (nonatomic ,copy) NSString *cityName;
@property (nonatomic ,copy) NSString *titlestr;
@property (assign, nonatomic) NSInteger type;
@property (nonatomic, copy) NSString *origin;
@end
