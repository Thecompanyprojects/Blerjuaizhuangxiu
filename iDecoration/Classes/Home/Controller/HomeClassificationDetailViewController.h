//
//  HomeClassificationDetailViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/9.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeClassificationDetailTableViewCell.h"//tableViewCell
#import "HomeClassificationDetailModel.h"//model
#import "HomeClassificationDetailCollectionViewCell.h"
#import "CompanyDetailViewController.h"
#import "CompanyOutViewController.h"
#import "ShopListViewController.h"
#import "ZCHCityModel.h"

@interface HomeClassificationDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) CLLocationDegrees latitude;
@property (assign, nonatomic) CLLocationDegrees longitude;
@property (strong, nonatomic) ZCHCityModel *cityModel;
@property (strong, nonatomic) HomeClassificationDetailModel *modelTableView;
@property (strong, nonatomic) NSMutableArray *arrayViewLineData;
@property (strong, nonatomic) NSMutableArray *arrayDataID;
@property (nonatomic,copy) NSString *origin;
@end
