//
//  ZCHNewLocationController.m
//  iDecoration
//
//  Created by 赵春浩 on 17/9/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHNewLocationController.h"
#import "JFCityTableViewCell.h"
#import "JFCityHeaderView.h"
#import "JFSearchView.h"
#import <CoreLocation/CoreLocation.h>
#import "ZCHCitiesModel.h"
#import "ZCHCityModel.h"
#import "WMSearchBar.h"

extern ZCHCityModel *cityModel;
extern ZCHCityModel *countyModel;
@interface ZCHNewLocationController ()<UITableViewDelegate, UITableViewDataSource, JFCityHeaderViewDelegate,
JFSearchViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate> {
    
//    NSMutableArray   *_indexMutableArray;           //存字母索引下标数组
    NSMutableArray   *_sectionMutableArray;         //存处理过以后的数组
    NSInteger        _HeaderSectionTotal;           //头section的个数
    CGFloat          _cellHeight;
    CLLocationManager *_locationManager;
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;//添加的(显示区县名称)cell的高度
}

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) JFCityTableViewCell *cell;
@property (nonatomic, strong) JFCityHeaderView *headerView;
@property (nonatomic, strong) JFSearchView *searchView;
/** 最近访问的城市*/
@property (nonatomic, strong) NSMutableArray *historyCityMutableArray;
/** 热门城市*/
@property (nonatomic, strong) NSMutableArray *hotCityArray;
/** 字母索引*/
@property (nonatomic, strong) NSMutableArray *characterMutableArray;

@property (nonatomic, strong) NSMutableArray *cityMutableArray;
/** 根据cityNumber在数据库中查到的区县*/
@property (nonatomic, strong) NSMutableArray *areaMutableArray;
// 定位的市
@property (strong, nonatomic) ZCHCityModel *currentLocation;
// 当前所处的市
@property (strong, nonatomic) ZCHCityModel *currentCity;
/** 所有“市”级城市名称*/
@property (strong, nonatomic) NSMutableArray *cityArr;

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *searchResultArr;

@property (strong, nonatomic) NSMutableArray *beSavedHistoryArr;

@property (assign, nonatomic) BOOL isOpen;

@property (nonatomic,assign) BOOL isShow;

@end

@implementation ZCHNewLocationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 50)];
    self.cityArr = [NSMutableArray array];
    self.hotCityArray = [NSMutableArray array];
    self.areaMutableArray = [NSMutableArray array];
    self.characterMutableArray = [NSMutableArray array];
    self.isOpen = NO;
    _sectionMutableArray = [NSMutableArray array];
    self.searchResultArr = [NSMutableArray array];
    
    // 最近访问的城市
    self.historyCityMutableArray = [NSMutableArray array];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"HistoryCity"]) {
        //    取
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"HistoryCity"];
        
        self.beSavedHistoryArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (int i = 0; i < self.beSavedHistoryArr.count; i ++) {
            
            if ([[self.beSavedHistoryArr[i] objectForKey:@"type"] isEqualToString:@"1"]) {
                [self.historyCityMutableArray addObject:[self.beSavedHistoryArr[i] objectForKey:@"cityModel"]];
            } else {
                [self.historyCityMutableArray addObject:[self.beSavedHistoryArr[i] objectForKey:@"model"]];
            }
        }
    }
    
    [self setUpUI];
    [self getLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeTopCity:) name:JFCityTableViewCellDidChangeCityNotification object:nil];
}


- (void)setUpUI {
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion floatValue] >= 11.0) {
        
        self.definesPresentationContext = YES;
        
        WMSearchBar *searchBar = [[WMSearchBar alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH - 60 - 44 - 2 * 15, 44)];
        searchBar.delegate = self;
        searchBar.placeholder = @"搜索城市或区县名";
        searchBar.backgroundImage = [UIImage new];
        searchBar.backgroundColor = [UIColor clearColor];
        searchBar.tintColor = kDisabledColor;
        searchBar.userInteractionEnabled = YES;
        
        CGFloat height = searchBar.bounds.size.height;
        CGFloat top = (height - 30.0) / 2.0;
        CGFloat bottom = top;
        searchBar.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
        self.searchBar = searchBar;
        
        UIView *wrapView = [[UIView alloc] initWithFrame:searchBar.frame];
        [wrapView addSubview:searchBar];
        self.navigationItem.titleView = wrapView;
        
    } else {
        
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(80, 0, 50, 44)];
        self.searchBar.placeholder = @"搜索城市或区县名";
        self.searchBar.delegate = self;
        self.searchBar.userInteractionEnabled = YES;
        self.searchBar.backgroundImage = [UIImage new];
        self.searchBar.backgroundColor = [UIColor clearColor];
        self.searchBar.tintColor = kDisabledColor;
        self.navigationItem.titleView = self.searchBar;
    }
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
}

#pragma mark - 定位相关
- (void)getLocation {
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager requestWhenInUseAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [_locationManager startUpdatingLocation];
    }
    if (status == kCLAuthorizationStatusDenied) {
        
        
        _longitude = -10000;
        _latitude = -10000;
        [self getCityList];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation) {
        
        _latitude = currentLocation.coordinate.latitude;
        _longitude = currentLocation.coordinate.longitude;
        [_locationManager stopUpdatingLocation];
        [self getCityList];
    } else {
        
        _longitude = -10000;
        _latitude = -10000;
        [self getCityList];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    _longitude = -10000;
    _latitude = -10000;
    [self getCityList];
}


// 选择城市时调用通知函数（前提是点击cell的section < 3）

- (void)didChangeTopCity:(NSNotification *)noc {
 
    NSString *countyIds = [NSString new];
    NSString *cityIds = [NSString new];
    
    NSDictionary *dic = noc.userInfo;
    NSIndexPath *indexPath = dic[@"tableView"];
    NSIndexPath *index = dic[@"collectionView"];
    ZCHCityModel *model = dic[@"model"];
    
    NSMutableArray *cityId = [NSMutableArray array];
    for (int i = 0; i < self.historyCityMutableArray.count; i ++) {
        [cityId addObject:((ZCHCityModel *)(self.historyCityMutableArray[i])).cityId];
    }
    if (_HeaderSectionTotal == 4 && indexPath.section == 0) {// 当前城市的区县
        
        if (self.beSavedHistoryArr.count < 3) {
            
            if (![model.pid isEqualToString:@"0"]||model.pid.length==0) {
                NSDictionary *dic = @{// 区县
                                      @"type" : @"2",
                                      @"model" : model,
                                      @"cityModel" : self.currentCity
                                      };
                if ([cityId containsObject:model.cityId]) {
                    [self.beSavedHistoryArr exchangeObjectAtIndex:0 withObjectAtIndex:[cityId indexOfObject:model.cityId]];
                } else {
                    [self.beSavedHistoryArr insertObject:dic atIndex:0];
                }
                
                cityIds = model.pid;
                countyIds = model.cityId;
                
            }else
            {
                cityIds = model.cityId;
                
            }
            
            
        } else {
            NSDictionary *dic = @{
                                  @"type" : @"2",
                                  @"model" : model,
                                  @"cityModel" : self.currentCity
                                  };
            if ([cityId containsObject:model.cityId]) {
                
                [self.beSavedHistoryArr exchangeObjectAtIndex:0 withObjectAtIndex:[cityId indexOfObject:model.cityId]];
            } else {
                [self.beSavedHistoryArr insertObject:dic atIndex:0];
                [self.beSavedHistoryArr removeObjectAtIndex:3];
            }
            countyIds = countyModel.cityId;
            cityIds = countyModel.pid;
        }
        countyModel = model;
        cityModel = self.currentCity;
       
    } else {
        
        if (indexPath.section == _HeaderSectionTotal - 3) {// 定位的地级市
            if (self.beSavedHistoryArr.count < 3) {
                NSDictionary *dic = @{// 地级
                                      @"type" : @"1",
                                      @"cityModel" : model
                                      };
                if ([cityId containsObject:model.cityId]) {
                    
                    [self.beSavedHistoryArr exchangeObjectAtIndex:0 withObjectAtIndex:[cityId indexOfObject:model.cityId]];
                } else {
                    [self.beSavedHistoryArr insertObject:dic atIndex:0];
                }
            } else {
                NSDictionary *dic = @{
                                      @"type" : @"1",
                                      @"cityModel" : model
                                      };
                if ([cityId containsObject:model.cityId]) {
                    
                    [self.beSavedHistoryArr exchangeObjectAtIndex:0 withObjectAtIndex:[cityId indexOfObject:model.cityId]];
                } else {
                    [self.beSavedHistoryArr insertObject:dic atIndex:0];
                    [self.beSavedHistoryArr removeObjectAtIndex:3];
                }
            }
            cityModel = model;
            countyModel = nil;
        }
        if (indexPath.section == _HeaderSectionTotal - 2) {// 最近访问的城市
            
            NSDictionary *dic = self.beSavedHistoryArr[index.item];
            if ([dic[@"type"] isEqualToString:@"1"]) {// 地级
                cityModel = model;
                countyModel = nil;
                NSDictionary *dic = @{
                                      @"type" : @"1",
                                      @"cityModel" : model
                                      };
                [self.beSavedHistoryArr removeObjectAtIndex:index.row];
                [self.beSavedHistoryArr insertObject:dic atIndex:0];
                cityIds = model.cityId;
                
            } else {// 区县
                cityModel = dic[@"cityModel"];
                countyModel = model;
                
                NSDictionary *dic = @{
                                      @"type" : @"2",
                                      @"model" : model,
                                      @"cityModel" : cityModel
                                      };
                [self.beSavedHistoryArr removeObjectAtIndex:index.row];
                [self.beSavedHistoryArr insertObject:dic atIndex:0];
                cityIds = model.pid;
                countyIds = model.cityId;
            }
        }
        
        if (indexPath.section == _HeaderSectionTotal - 1) {// 热门城市
            if (self.beSavedHistoryArr.count < 3) {
                NSDictionary *dic = @{// 地级
                                      @"type" : @"1",
                                      @"cityModel" : model
                                      };
                if ([cityId containsObject:model.cityId]) {
                    
                    [self.beSavedHistoryArr exchangeObjectAtIndex:0 withObjectAtIndex:[cityId indexOfObject:model.cityId]];
                } else {
                    [self.beSavedHistoryArr insertObject:dic atIndex:0];
                }
                cityIds = model.cityId;
            } else {
                NSDictionary *dic = @{
                                      @"type" : @"1",
                                      @"cityModel" : model
                                      };
                if ([cityId containsObject:model.cityId]) {
                    [self.beSavedHistoryArr exchangeObjectAtIndex:0 withObjectAtIndex:[cityId indexOfObject:model.cityId]];
                } else {
                    [self.beSavedHistoryArr insertObject:dic atIndex:0];
                    [self.beSavedHistoryArr removeObjectAtIndex:3];
                }
                cityIds = model.pid;
                countyIds = model.cityId;
            }
            
            cityModel = model;
            countyModel = nil;
    
        }
    }

    NSDictionary *newDic = @{@"name":model.name?:@"",@"cityId":cityIds?:@"0",@"countyId":countyIds?:@"0"};
    
    if (self.refreshBlock) {
        self.refreshBlock(newDic);
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.beSavedHistoryArr];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"HistoryCity"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //创建通知对象
    NSNotification *notification = [NSNotification notificationWithName:@"tongchengdingwei" object:cityModel];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _characterMutableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_HeaderSectionTotal == 3) {
        
        return section < _HeaderSectionTotal ? 1 : [((ZCHCitiesModel *)self.cityArr[section - 3]).citys count];
    } else {
        
        return section < _HeaderSectionTotal ? 1 : [((ZCHCitiesModel *)self.cityArr[section - 4]).citys count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section < _HeaderSectionTotal) {
        self.cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
        self.cell.indexPath = indexPath;
        if (_HeaderSectionTotal == 4 && indexPath.section == 0) {
            _cell.cityNameArray = _areaMutableArray;
        }
        if (indexPath.section == _HeaderSectionTotal - 3) {
            
            _cell.cityNameArray = @[self.currentLocation];
        }
        if (indexPath.section == _HeaderSectionTotal - 2) {
            _cell.cityNameArray = self.historyCityMutableArray;
        }
        if (indexPath.section == _HeaderSectionTotal - 1) {
            _cell.cityNameArray = self.hotCityArray;
        }
        return _cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityNameCell" forIndexPath:indexPath];
        if (_HeaderSectionTotal == 4) {
            NSArray *currentArray = ((ZCHCitiesModel *)self.cityArr[indexPath.section - 4]).citys;
            cell.textLabel.text = ((ZCHCityModel *)currentArray[indexPath.row]).name;
        } else {
            NSArray *currentArray = ((ZCHCitiesModel *)self.cityArr[indexPath.section - 3]).citys;
            cell.textLabel.text = ((ZCHCityModel *)currentArray[indexPath.row]).name;
        }
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_HeaderSectionTotal == 4 && indexPath.section == 0) {
        
        return _cellHeight;
    } else if (indexPath.section == _HeaderSectionTotal - 3) {
        
        return 50;
    } else if (indexPath.section == _HeaderSectionTotal - 2) {
        
        return (self.historyCityMutableArray.count / 3 + ((self.historyCityMutableArray.count % 3) > 0 ? 1 : 0)) * 50;
    } else if (indexPath.section == _HeaderSectionTotal - 1) {
        
        return (self.hotCityArray.count / 3 + ((self.hotCityArray.count % 3) > 0 ? 1 : 0)) * 50;
    } else {
        
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (_HeaderSectionTotal == 4 && section == 0) {
        
        return 5;
    } else {
        
        return 40;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 40)];
    bgView.backgroundColor = kCOLOR(247);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, BLEJWidth - 20, 40)];
    label.textColor = Black_Color;
    label.font = [UIFont systemFontOfSize:16];
    if (_HeaderSectionTotal == 3) {
        switch (section) {
            case 0:
                label.text = @"定位城市";
                break;
            case 1:
                label.text = @"最近访问的城市";
                break;
            case 2:
                label.text = @"热门城市";
                break;
            default:
                label.text = _characterMutableArray[section];
                break;
        }
    } else {
        switch (section) {
            case 0:
                label.text = @"";
                break;
            case 1:
                label.text = @"定位城市";
                break;
            case 2:
                label.text = @"最近访问的城市";
                break;
            case 3:
                label.text = @"热门城市";
                break;
            default:
                label.text = _characterMutableArray[section];
                break;
        }
    }
    [bgView addSubview:label];
    return bgView;
}

//设置右侧索引的标题，这里返回的是一个数组哦！
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return _characterMutableArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHCitiesModel *citiesModel = self.cityArr[indexPath.section - _HeaderSectionTotal];
    ZCHCityModel *model = citiesModel.citys[indexPath.row];
    
    NSMutableArray *cityId = [NSMutableArray array];
    for (int i = 0; i < self.historyCityMutableArray.count; i ++) {
        
        [cityId addObject:((ZCHCityModel *)(self.historyCityMutableArray[i])).cityId];
    }
    if (self.beSavedHistoryArr.count < 3) {
        NSDictionary *dic = @{// 地级
                              @"type" : @"1",
                              @"cityModel" : model
                              };
        if ([cityId containsObject:model.cityId]) {
            
            [self.beSavedHistoryArr exchangeObjectAtIndex:0 withObjectAtIndex:[cityId indexOfObject:model.cityId]];
        } else {
            [self.beSavedHistoryArr insertObject:dic atIndex:0];
        }
        
    } else {
        NSDictionary *dic = @{
                              @"type" : @"1",
                              @"cityModel" : model
                              };
        if ([cityId containsObject:model.cityId]) {
            
            [self.beSavedHistoryArr exchangeObjectAtIndex:0 withObjectAtIndex:[cityId indexOfObject:model.cityId]];
        } else {
            [self.beSavedHistoryArr insertObject:dic atIndex:0];
            [self.beSavedHistoryArr removeObjectAtIndex:3];
        }
    }
    
    cityModel = model;
    countyModel = nil;
    
    NSDictionary *newDic = @{@"name":model.name?:@"",@"cityId":model.cityId?:@"0",@"countyId":model.countyId?:@"0"};
    if (self.refreshBlock) {
        self.refreshBlock(newDic);
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.beSavedHistoryArr];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"HistoryCity"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //创建通知对象
    NSNotification *notification = [NSNotification notificationWithName:@"tongchengdingwei" object:cityModel];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- JFCityHeaderViewDelegate

- (void)cityNameWithSelected:(BOOL)selected {
    
    //获取当前城市的所有辖区
    if (selected) {

        if (0 == (self.areaMutableArray.count % 3)) {
            _cellHeight = self.areaMutableArray.count / 3 * 50;
        }else {
            _cellHeight = (self.areaMutableArray.count / 3 + 1) * 50;
        }

        //添加一行cell
        [self.tableView beginUpdates];
        [_characterMutableArray insertObject:@"区" atIndex:0];
        _HeaderSectionTotal = 4;
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }else {

        //删除一行cell
        [self.tableView beginUpdates];
        [_characterMutableArray removeObjectAtIndex:0];
        _HeaderSectionTotal = 3;
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
        [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

- (void)beginSearch {
    [self.view addSubview:self.searchView];
}

- (void)endSearch {
    [self deleteSearchView];
}

- (void)searchResult:(ZCHCityModel *)model {
    
    NSLog(@"%@", model.name);
}

#pragma mark - JFSearchViewDelegate
- (void)searchResults:(ZCHCityModel *)model {
    
    NSMutableArray *cityId = [NSMutableArray array];
    for (int i = 0; i < self.historyCityMutableArray.count; i ++) {
        
        [cityId addObject:((ZCHCityModel *)(self.historyCityMutableArray[i])).cityId];
    }
    if (model.countyId) {
        
        ZCHCityModel *citymodel = [[ZCHCityModel alloc] init];
        citymodel.cityId = model.cityId;
        citymodel.pid = model.pid;
        model.cityId = model.countyId;
        if (self.beSavedHistoryArr.count < 3) {
            NSDictionary *dic = @{// 区县
                                  @"type" : @"2",
                                  @"model" : model,
                                  @"cityModel" : citymodel
                                  };
            if ([cityId containsObject:model.cityId]) {
                [self.beSavedHistoryArr exchangeObjectAtIndex:0 withObjectAtIndex:[cityId indexOfObject:model.cityId]];
            } else {
                [self.beSavedHistoryArr insertObject:dic atIndex:0];
            }
            
        } else {
            NSDictionary *dic = @{
                                  @"type" : @"2",
                                  @"model" : model,
                                  @"cityModel" : citymodel
                                  };
            if ([cityId containsObject:model.cityId]) {
                
                [self.beSavedHistoryArr exchangeObjectAtIndex:0 withObjectAtIndex:[cityId indexOfObject:model.cityId]];
            } else {
                [self.beSavedHistoryArr insertObject:dic atIndex:0];
                [self.beSavedHistoryArr removeObjectAtIndex:3];
            }
            
        }
        countyModel = model;
        cityModel = citymodel;
    } else {
        
        if (self.beSavedHistoryArr.count < 3) {
            NSDictionary *dic = @{// 地级
                                  @"type" : @"1",
                                  @"cityModel" : model
                                  };
            if ([cityId containsObject:model.cityId]) {
                
                [self.beSavedHistoryArr exchangeObjectAtIndex:0 withObjectAtIndex:[cityId indexOfObject:model.cityId]];
            } else {
                [self.beSavedHistoryArr insertObject:dic atIndex:0];
            }
        } else {
            
            NSDictionary *dic = @{
                                  @"type" : @"1",
                                  @"cityModel" : model
                                  };
            if ([cityId containsObject:model.cityId]) {
                
                [self.beSavedHistoryArr exchangeObjectAtIndex:0 withObjectAtIndex:[cityId indexOfObject:model.cityId]];
            } else {
                [self.beSavedHistoryArr insertObject:dic atIndex:0];
                [self.beSavedHistoryArr removeObjectAtIndex:3];
            }
        }
        
        cityModel = model;
        countyModel = nil;
    }
    
    NSDictionary *newDic = @{@"name":model.name?:@"",@"cityId":model.cityId?:@"0",@"countyId":model.countyId?:@"0"};
    
    if (self.refreshBlock) {
        self.refreshBlock(newDic);
    }
     
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.beSavedHistoryArr];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"HistoryCity"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    //创建通知对象
    NSNotification *notification = [NSNotification notificationWithName:@"tongchengdingwei" object:cityModel];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self endSearch];
    
}

- (void)touchViewToExit {
    
    [_headerView cancelSearch];
}

- (JFCityHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[JFCityHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        _headerView.delegate = self;
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.buttonTitle = @"选择区县";
        _headerView.cityName = @"";
    }
    return _headerView;
}

- (JFSearchView *)searchView {
    if (!_searchView) {
        CGRect frame = [UIScreen mainScreen].bounds;
        _searchView = [[JFSearchView alloc] initWithFrame:CGRectMake(0, 64, frame.size.width, frame.size.height  - 64)];
        _searchView.backgroundColor = [UIColor colorWithRed:155 / 255.0 green:155 / 255.0 blue:155 / 255.0 alpha:0.5];
        _searchView.delegate = self;
    }
    return _searchView;
}

/// 移除搜索界面
- (void)deleteSearchView {
    [_searchView removeFromSuperview];
    _searchView = nil;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, BLEJWidth, BLEJHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionIndexColor = [UIColor colorWithRed:0/255.0f green:132/255.0f blue:255/255.0f alpha:1];
        [_tableView registerClass:[JFCityTableViewCell class] forCellReuseIdentifier:@"cityCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cityNameCell"];
    }
    return _tableView;
}

#pragma mark - 获取城市列表

- (void)getCityList {
    
    if (self.isOpen) {
        return;
    }
    NSString *api = [BASEURL stringByAppendingString:@"china/getCityLists.do"];
    NSDictionary *param = @{
                            @"longitude" : @(_longitude),
                            @"latitude" : @(_latitude),
                            @"cityId" : cityModel ? cityModel.cityId : @"0",
                            @"isFirst" : @"1"
                            };
    self.isOpen = YES;
    [NetManager afPostRequest:api parms:param finished:^(id responseObj) {
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            self.characterMutableArray = [NSMutableArray arrayWithObjects:@"定", @"近", @"热", nil];
            if ([responseObj[@"data"][@"cityLists"] count] > 0) {
                for (int i = 0; i < [responseObj[@"data"][@"cityLists"] count]; i ++ ) {
                    
                    [self.cityArr addObject:[ZCHCitiesModel yy_modelWithJSON:responseObj[@"data"][@"cityLists"][i]]];
                }
            }
            if ([responseObj[@"data"][@"hotList"] count] > 0) {
                for (int i = 0; i < [responseObj[@"data"][@"hotList"] count]; i ++ ) {
                    
                    [self.hotCityArray addObject:[ZCHCityModel yy_modelWithJSON:responseObj[@"data"][@"hotList"][i]]];
                }
            }
            
            if ([responseObj[@"data"][@"countyList"] count] > 0) {
                for (int i = 0; i < [responseObj[@"data"][@"countyList"] count]; i ++ ) {
                    
                    [self.areaMutableArray addObject:[ZCHCityModel yy_modelWithJSON:responseObj[@"data"][@"countyList"][i]]];
                }
            }
            
            if (responseObj[@"data"][@"city"]) {
                
                self.currentCity = [ZCHCityModel yy_modelWithJSON:responseObj[@"data"][@"city"]];
                _headerView.cityName = self.currentCity.name;
            }
            
            if (responseObj[@"data"][@"location"]) {
                
                self.currentLocation = [ZCHCityModel yy_modelWithJSON:responseObj[@"data"][@"location"][@"city"]];

                if (self.historyCityMutableArray.count == 0) {
                    
                    [self.historyCityMutableArray addObject:self.currentLocation];
                    
                    NSDictionary *dic = @{
                                          @"type" : @"1",// 1: 地级市 2: 区县
                                          @"cityModel" : self.currentLocation
                                          };
                    self.beSavedHistoryArr = [NSMutableArray arrayWithObject:dic];
                    
                    //    存
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.beSavedHistoryArr];
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"HistoryCity"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            
            for (int i = 0; i < self.cityArr.count; i ++) {
                
                ZCHCitiesModel *model = self.cityArr[i];
                [self.characterMutableArray addObject:model.firstChar];
            }
            
        } else {
            
            self.isOpen = NO;
           [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
        }
        
        _HeaderSectionTotal = 3;
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
        self.isOpen = NO;
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
    
}

#pragma mark - 获取搜索结果
- (void)getSearchResult {
    
    // china/searchCitysByName.do
    NSString *apiStr = [BASEURL stringByAppendingString:@"china/searchRegionsByName.do"];
    NSDictionary *param = @{
                            @"name" : self.searchBar.text
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.searchResultArr removeAllObjects];
            
            if ([responseObj[@"data"][@"list"] count] == 0) {
                
                [self endSearch];
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"抱歉，未找到相关信息"];
                return;
            }
            for (int i = 0; i < [responseObj[@"data"][@"list"] count]; i ++) {
                
                ZCHCityModel *model = [ZCHCityModel yy_modelWithJSON:responseObj[@"data"][@"list"][i]];
                [self.searchResultArr addObject:model];
                
                self.searchView.resultMutableArray = self.searchResultArr;
            }
        } else {
           
            [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
        }
        
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    [self beginSearch];
    return YES;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self getSearchResult];
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
