//
//  HomeClassificationDetailViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/9.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "HomeClassificationDetailViewController.h"
#import "CollectionViewCell.h"

@interface HomeClassificationDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation HomeClassificationDetailViewController

- (NSMutableArray *)arrayDataID {
    if (!_arrayDataID) {
        _arrayDataID = @[@[@"1066", @"1067"], @[@"1069", @"1070"], @[@"1071", @"1072"], @[@"1073", @"1074"], @[@"1080", @"1081"]].mutableCopy;
    }
    return _arrayDataID;
}

- (NSMutableArray *)arrayViewLineData {
    if (!_arrayViewLineData) {
        _arrayViewLineData = @[].mutableCopy;
    }
    return _arrayViewLineData;
}

- (HomeClassificationDetailModel *)modelTableView {
    if (!_modelTableView) {
        _modelTableView = [HomeClassificationDetailModel new];
    }
    return _modelTableView;
}

#pragma mark - 调用装修公司接口
- (void)JudgepersonWithType:(NSInteger)type {
    if (!self.cityModel) {
        return;
    }
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT];
    NSInteger roletypeid= [[dict objectForKey:@"roleTypeId"] integerValue];
    if (!roletypeid||roletypeid == 0) {
        roletypeid = 0;
    }

    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/signInPersonJudge.do"];
    NSDictionary *paramDic = @{
                               @"currentPersionId":@(agencyid),
                               @"currentPersonJob":@(roletypeid)
                               };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            switch (statusCode) {
                case 10000:
                    if (responseObj[@"innerOrOuterFlag"]) {
                        id a = responseObj[@"innerOrOuterFlag"];
                        NSString *tempstr;
                        if ([a isKindOfClass:[NSString class]]) {
                            tempstr = a;
                            if ([tempstr isEqualToString:@"outerIntent"]) {
                                //外网 进入公司列表页面
                                [MobClick event:@"ZhuangXiuGongSi"];
                                CompanyOutViewController *companyOut = [[CompanyOutViewController alloc] init];
                               
                                if (type == 1018) {
                                    companyOut.titlestr = @"装修公司";
                                }else if (type == 1062) {
                                    companyOut.titlestr = @"家纺布艺";
                                }else if (type == 1065) {
                                    companyOut.titlestr = @"新型装修";
                                }else if (type == 1064) {
                                    companyOut.titlestr = @"整装公司";
                                }else if (type == 1066) {
                                    companyOut.titlestr = @"互联网";
                                }else if (type == 1067) {
                                    companyOut.titlestr = @"其他";
                                }else if (type == 1022) {
                                    companyOut.titlestr = @"设计工作室";
                                }else if (type == 1001) {
                                    companyOut.titlestr = @"软装馆";
                                }
                                companyOut.origin = @"0";
                                companyOut.latitudety = [NSString stringWithFormat:@"%f",_latitude];
                                companyOut.longitudety = [NSString stringWithFormat:@"%f",_longitude];
                                companyOut.type = type;
                                companyOut.cityModel=self.cityModel;
                                
                              
                                [self.navigationController pushViewController:companyOut animated:YES];
                            } else if ([tempstr isEqualToString:@"innerIntent"]){
                                //内网 进入公司详情页面
                                NSInteger companyID = ((NSNumber *)responseObj[@"companyId"]).integerValue;
                                NSString *companyName = responseObj[@"companyName"];
                                CompanyDetailViewController *vc = [[CompanyDetailViewController alloc] init];
                                vc.companyID = [NSString stringWithFormat:@"%ld",companyID];
                                vc.companyName = companyName;
                                [self.navigationController pushViewController:vc animated:YES];
                            } else if ([tempstr isEqualToString:@"noOperatingAuthority"]){
                                //没有操作权限
                            } else {

                            }
                        }
                    }
                    break;
                default:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"无法连接到网络，请检查网络设置"];
                    break;
            }
        }
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createTableView];
    [self createCollectionView];
}

- (void)createUI {
    [self setSelectedValueWith:self.index];
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

- (void)createTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = 0;
    [self.tableView setBackgroundColor:self.view.backgroundColor];
}

- (void)createCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeClassificationDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeClassificationDetailCollectionViewCell"];
    self.flowLayout.itemSize = CGSizeMake((kSCREEN_WIDTH - 100)/2, (kSCREEN_WIDTH - 100)/2*0.77);
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    [HomeClassificationDetailModel.arrayDetail enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = obj;
        NSMutableArray *arrayNew = @[].mutableCopy;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HomeClassificationDetailModel * model = [HomeClassificationDetailModel new];
            [model setLinesWithIndex:idx AndIsBottom:false];
            if (idx == array.count - 1 || idx == array.count - 2) {
                [model setLinesWithIndex:idx AndIsBottom:true];
            }
            [arrayNew addObject:model];
        }];
        [self.arrayViewLineData addObject:arrayNew];
    }];
}

#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return HomeClassificationDetailModel.arrayTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeClassificationDetailTableViewCell *cell = [HomeClassificationDetailTableViewCell cellWithTableView:tableView];
    cell.labelTitle.text = HomeClassificationDetailModel.arrayTitle[indexPath.row];
    NSNumber *number = HomeClassificationDetailModel.arrayIsSelected[indexPath.row];
    [cell selectedCell:number.boolValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setSelectedValueWith:indexPath.row];
    self.index = indexPath.row;
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

#pragma mark collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *array = HomeClassificationDetailModel.arrayDetail[self.index];
    return array.count;
}

- ( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section {
    return UIEdgeInsetsMake (0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeClassificationDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeClassificationDetailCollectionViewCell" forIndexPath:indexPath];
    NSArray *arrayTitle = HomeClassificationDetailModel.arrayDetail[self.index];
    cell.labelTitle.text = arrayTitle[indexPath.item];
    [cell.imageViewIcon setImage:[UIImage imageNamed:[HomeClassificationDetailModel imageIconName:cell.labelTitle.text]]];
    NSMutableArray *array = self.arrayViewLineData[self.index];
    [cell setModel:array[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arrayTitle = HomeClassificationDetailModel.arrayDetail[self.index];
    NSInteger typeInt = [HomeClassificationDetailModel getTypeWithTitle:arrayTitle[indexPath.item]];
    NSArray *arrayID = self.arrayDataID[self.index];
    if (indexPath.item == arrayTitle.count - 2) {//其它
        typeInt = [arrayID[0] integerValue];
    }else if (indexPath.item == arrayTitle.count - 1) {//互联网+
        typeInt = [arrayID[1] integerValue];
    }
    if (typeInt == 1018 || typeInt == 1064 || typeInt == 1065|| typeInt == 1001|| typeInt == 1022|| typeInt == 1062|| typeInt == 1066|| typeInt == 1067) {
        //装修公司
        [self JudgepersonWithType:typeInt];
    }else{
        ShopListViewController *shopListVC = [[ShopListViewController  alloc] init];
        shopListVC.latitude = [NSString stringWithFormat:@"%f",_latitude];
        shopListVC.longititude = [NSString stringWithFormat:@"%f",_longitude];
        shopListVC.type = typeInt;
        shopListVC.origin = self.origin;
        shopListVC.titleStr= arrayTitle[indexPath.item];
        shopListVC.cityModel=self.cityModel;
        [self.navigationController pushViewController:shopListVC animated:YES];
    }
}

- (void)setSelectedValueWith:(NSInteger) index {
    [HomeClassificationDetailModel.arrayTitle enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [HomeClassificationDetailModel.arrayIsSelected replaceObjectAtIndex:idx withObject:@(0)];
        if (idx == index) {
            [HomeClassificationDetailModel.arrayIsSelected replaceObjectAtIndex:idx withObject:@(1)];
        }
    }];
    self.title = HomeClassificationDetailModel.arrayTitle[index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
