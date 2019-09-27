//
//  SubsidiaryModel.m
//  iDecoration
//
//  Created by Apple on 2017/5/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SubsidiaryModel.h"

@implementation SubsidiaryModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"footImgs" : [SubsidiaryModel class],
             @"headImgs" : [SubsidiaryModel class]};
}

- (NSMutableArray *)areaList {
    if (!_areaList) {
        _areaList = @[].mutableCopy;
    }
    return _areaList;
}

- (NSString *)typeName {
    NSInteger type = [self.companyType integerValue];
    if (_typeName.length == 0) {
        _typeName = [HomeClassificationDetailModel getTitleWithType:@(type).stringValue];
    }
    return _typeName;
}

- (NSMutableArray *)arrayBasicTitle {
    if (!_arrayBasicTitle) {
//        if (self.isCompany) {
//            _arrayBasicTitle = @[@"品牌LOGO", @"品牌名称", @"类别", @"装修区域", @"服务范围", @"座机", @"地址", @"详细地址", @"业务经理电话", @"邮箱", @"网址", @"简介"].mutableCopy;
//        }else
            _arrayBasicTitle = @[@"品牌LOGO", @"品牌名称", @"类别", @"服务范围", @"座机", @"地址", @"详细地址", @"业务经理电话", @"邮箱", @"网址", @"简介"].mutableCopy;
    }
    return _arrayBasicTitle;
}

- (NSMutableArray *)arrayBasicTitleInShow {
    if (!_arrayBasicTitleInShow) {
        if (self.isCompany) {
            _arrayBasicTitleInShow = @[@"手 机", @"邮 箱", @"网 址", @"地 址"].mutableCopy;
        }else
            _arrayBasicTitleInShow = @[@"手 机", @"邮 箱", @"网 址", @"地 址"].mutableCopy;
    }
    return _arrayBasicTitleInShow;
}

- (NSMutableArray *)arrayBasic {
    if (self.isCompany) {
        _arrayBasic = @[self.companyLogo?:@"", self.companyName?:@"", self.typeName?:@"", self.areaListString?:@"", self.serviceScope?:@"", self.companyLandline?:@"", self.companyAddress?:@"", self.detailedAddress?:@"", self.companyPhone?:@"", self.companyEmail?:@"", self.companyUrl?:@"", self.companyIntroduction?:@""].mutableCopy;
    }else
        _arrayBasic = @[self.companyLogo?:@"", self.companyName?:@"", self.typeName?:@"", self.serviceScope?:@"", self.companyLandline?:@"", self.companyAddress?:@"", self.detailedAddress?:@"", self.companyPhone?:@"", self.companyEmail?:@"", self.companyUrl?:@"", self.companyIntroduction?:@""].mutableCopy;
    return _arrayBasic;
}

- (NSMutableArray *)arrayBasicInShow {//self.model.detailedAddress
    if (self.isCompany) {
        _arrayBasicInShow = @[self.companyPhone?:@"", self.companyEmail?:@"", self.companyUrl?:@"", self.detailedAddress?:@""].mutableCopy;
    }else
        _arrayBasicInShow = @[self.companyPhone?:@"", self.companyEmail?:@"", self.companyUrl?:@"", self.detailedAddress?:@""].mutableCopy;
    return _arrayBasicInShow;
}

- (NSString *)areaListString {
    __block NSString *string = @"";
    NSArray *array = [self.areaList valueForKeyPath:@"retion"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (string.length == 0) {
            string = obj;
        }else
            string = [NSString stringWithFormat:@"%@, %@",string,obj];
    }];
    return string;
}

@end
