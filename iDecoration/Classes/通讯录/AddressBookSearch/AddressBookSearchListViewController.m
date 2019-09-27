//
//  AddressBookSearchListViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "AddressBookSearchListViewController.h"

@interface AddressBookSearchListViewController ()

@end

@implementation AddressBookSearchListViewController

- (void)Network {
    NSDictionary *dic = [[CacheData sharedInstance] objectForKey:KDictionaryOfCityIdCountyId];
    NSString *URL;
    switch (self.listType) {
        case SearchListTypeElite:
            URL = @"citywiderecomend/allElite.do";
            break;
        case SearchListTypeCard://名片用人才广场接口
            URL = @"agency/talentSquare.do";
            break;
        default:
            break;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"page"] = @(self.pageNo);
    parameters[@"pageSize"] = @(15);
    parameters[@"cityId"] = dic[@"cityId"]?:@"110000";
    parameters[@"countyId"] = dic[@"countyId"]?:@"0";
    parameters[@"content"] = self.content?:@"";
    [NetWorkRequest postJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        [self endRefresh];
        if ([result[@"code"] integerValue] == 1000) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[GeniusSquareListModel class] json:result[@"data"][@"list"]].mutableCopy;
            if (array.count < 15) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.arrayData addObjectsFromArray:array];
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self endRefresh];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf(self)
    switch (self.listType) {
        case SearchListTypeElite:
            self.title = @"精英推荐";
            break;
        case SearchListTypeCard://名片用人才广场接口
            self.title = @"名片";
            break;
        default:
            break;
    }
//    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
