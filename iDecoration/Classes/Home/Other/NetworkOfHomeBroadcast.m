//
//  NetworkOfHomeBroadcast.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/8.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "NetworkOfHomeBroadcast.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ZCHCityModel.h"

@implementation NetworkOfHomeBroadcast

+ (instancetype)sharedInstance {
    static NetworkOfHomeBroadcast *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NetworkOfHomeBroadcast new];
    });
    return instance;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"phoneList" : [NetworkOfHomeBroadcast class],
             @"data" : [NetworkOfHomeBroadcast class]};
}

- (NSMutableArray *)list {
    if (!_list) {
        _list = @[].mutableCopy;
    }
    return _list;
}

- (NSArray *)arrayImageName {
    return @[@"icon_yuyue_H", @"icon_baojia", @"icon_huodong_home", @"", @"icon_huodong_home"];
}
//xx员工张xx收到尾号1111业主的报价
//尾号1111的业主报名了xx公司员工张xx发起的活动
/*
 企业播报显示收单信息
 改成：
 活动：尾号xxxx的业主报名参加了xxxxxxx公司发起的线下活动
 尾号xxxx的业主报名参加了xxxxxxx公司发起的线上活动
 报价：xxxxx公司收到尾号xxxx业主的报价信息
 预约：xxxxxxx公司收到xxxx业主的预约信息
 */
- (NSString *)title {
    NSString *string = @"";
    if (self.isCompany) {
        if (self.type == 0) {//0:在线预约
            string = [NSString stringWithFormat:@"%@收到%@业主的预约信息",self.companyName,self.phone];
        }else if (self.type == 1) {//1:计算器
            string = [NSString stringWithFormat:@"%@收到尾号%@业主的报价信息",self.companyName,self.phone];
        }else if (self.type == 2) {//2:活动线下
            string = [NSString stringWithFormat:@"尾号%@的业主报名参加了%@发起的线下活动",self.phone,self.companyName];
        }else if (self.type == 4) {//4:线上活动
            string = [NSString stringWithFormat:@"尾号%@的业主报名参加了%@发起的线上活动",self.phone,self.companyName];
        }
    }else{
        if (self.type == 0) {//0:在线预约
            string = [NSString stringWithFormat:@"%@收到尾号%@业主的预约信息",self.companyName,self.phone];
        }else if (self.type == 1) {//1:计算器
            string = [NSString stringWithFormat:@"%@员工%@收到尾号%@业主的报价",self.companyName,self.trueName, self.phone];
        }else if (self.type == 2) {//2:活动线下
            string = [NSString stringWithFormat:@"尾号%@的业主报名了%@公司发起的线下活动",self.phone,self.companyName];
        }else if (self.type == 4) {//4:线上活动
            string = [NSString stringWithFormat:@"尾号%@的业主报名了%@员工%@发起的活动",self.phone,self.companyName, self.trueName];
        }
    }
    string = [NSString stringWithFormat:@"%@%@",string,self.expression];
    return string;
}

- (NSMutableArray *)arrayString {
    _arrayString = @[].mutableCopy;
    [self.phoneList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NetworkOfHomeBroadcast *model = obj;
        NSString *string = @"";
        model.isCompany = true;
        if (model.trueName.length) {
            model.isCompany = false;
        }
        if (self.isCompany) {
            if (model.type == 0) {//0:在线预约
                string = [NSString stringWithFormat:@"%@收到%@业主的预约信息",model.companyName,model.phone];
            }else if (model.type == 1) {//1:计算器
                string = [NSString stringWithFormat:@"%@收到尾号%@业主的报价信息",model.companyName,model.phone];
            }else if (model.type == 2) {//2:活动线下
                string = [NSString stringWithFormat:@"尾号%@的业主报名参加了%@发起的线下活动",model.phone,model.companyName];
            }else if (model.type == 4) {//4:线上活动
                string = [NSString stringWithFormat:@"尾号%@的业主报名参加了%@发起的线上活动",model.phone,model.companyName];
            }
        }else{
            if (model.type == 0) {//0:在线预约
                string = [NSString stringWithFormat:@"%@收到尾号%@业主的预约信息",model.companyName,model.phone];
            }else if (model.type == 1) {//1:计算器
                string = [NSString stringWithFormat:@"%@员工%@收到尾号%@业主的报价",model.companyName,model.trueName, model.phone];
            }else if (model.type == 2) {//2:活动线下
                string = [NSString stringWithFormat:@"尾号%@的业主报名了%@发起的线下活动",model.phone,model.companyName];
            }else if (model.type == 4) {//4:线上活动
                string = [NSString stringWithFormat:@"尾号%@的业主报名了%@员工%@发起的活动",model.phone,model.companyName, model.trueName];
            }
        }
        string = [NSString stringWithFormat:@"%@%@",string,model.expression];
        if (model.type == 0 || model.type == 1 || model.type == 2 || model.type == 4) {
            [_arrayString addObject:string];
        }
    }];
    return _arrayString;
}

- (void)NetworkOfListType:(ListMode)listmode AndPage:(NSNumber *)page AndSuccess:(void(^)(void))success AndFailed:(void(^)(void))failed {
    ZCHCityModel *cityModel = [ZCHCityModel new];
    ZCHCityModel *countyModel = [ZCHCityModel new];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"HistoryCity"];
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (arr.count > 0) {
        if ([[arr[0] objectForKey:@"type"] isEqualToString:@"1"]) {
            cityModel = [arr[0] objectForKey:@"cityModel"];
        } else {
            cityModel = [arr[0] objectForKey:@"cityModel"];
            countyModel = [arr[0] objectForKey:@"model"];
        }
    }
    NSString *URL = @"citywiderecomend/v2/getPhoneList.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"type"] = @(listmode);
    parameters[@"page"] = page;
    parameters[@"cityId"] = cityModel ? cityModel.cityId : @"0";
    [NetWorkRequest getJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        if ([result[@"code"] integerValue] == 1000) {
            if (page.integerValue == 1) {
                [self.list removeAllObjects];
                self.list = [NSArray yy_modelArrayWithClass:[NetworkOfHomeBroadcast class] json:result[@"data"][@"list"]].mutableCopy;
            }else
                [self.list addObjectsFromArray:[NSArray yy_modelArrayWithClass:[NetworkOfHomeBroadcast class] json:result[@"data"][@"list"]]];
            NetworkOfHomeBroadcast *model = self.list[0];
            model.isOpen = true;
            model.isCompany = !listmode;
            if (success) {
                success();
            }
        }
    } fail:^(id error) {
        if (failed) {
            failed();
        }
    }];
}
@end
