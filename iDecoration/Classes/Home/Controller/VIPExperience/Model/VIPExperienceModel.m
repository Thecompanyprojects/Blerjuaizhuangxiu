//
//  VIPExperienceModel.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/22.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "VIPExperienceModel.h"
#import "WorkTypeModel.h"
#import "HomeClassificationDetailModel.h"

@implementation VIPExperienceModel

+ (void)getCompanyAddressWithModel:(VIPExperienceModel *)model {
    //根据城市id获取城市地址
    NSString *pidStr;
    NSString *cidStr;
    NSString *didStr;

    PModel *temppmodel;
    CModel *tempcmodel;
    DModel *tempdmodel;

    NSMutableArray *tempPidArray = [NSMutableArray array];
    NSMutableArray *tempCidArray = [NSMutableArray array];
    NSMutableArray *tempDidArray = [NSMutableArray array];

    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"city_blej_tree" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    if (model.companyProvince) {
        for (NSDictionary *dict in jsonArr) {
            PModel *pmodel = [PModel yy_modelWithJSON:dict];
            [tempPidArray addObject:pmodel];
        }
        for (PModel *pmodel in tempPidArray) {
            if ([pmodel.regionId integerValue]==[model.companyProvince integerValue]) {
                pidStr = pmodel.name;
                temppmodel = pmodel;
                break;
            }
        }
        NSInteger regionId = [model.companyProvince integerValue];
        if (regionId == 110000||regionId == 120000||regionId == 500000||regionId == 310000){
            NSInteger temInt = [model.companyCounty integerValue];
            if (temInt == -1 || temInt == 0) {
                for (NSDictionary *dict in temppmodel.cities) {
                    CModel *cmodel = [CModel yy_modelWithJSON:dict];
                    [tempCidArray addObject:cmodel];
                }
                for (CModel *cmodel in tempCidArray) {
                    if ([cmodel.regionId integerValue]==[model.companyProvince integerValue]) {
                        cidStr = @"";
                        tempcmodel = cmodel;
                        break;
                    }
                }
                for (NSDictionary *dict in tempcmodel.counties) {
                    DModel *dmodel = [DModel yy_modelWithJSON:dict];
                    [tempDidArray addObject:dmodel];
                }
                for (DModel *dmodel in tempDidArray) {
                    if ([dmodel.regionId integerValue]==[model.companyCity integerValue]) {
                        didStr = dmodel.name;
                        tempdmodel = dmodel;
                        break;
                    }
                }
            }else{
                for (NSDictionary *dict in temppmodel.cities) {

                    CModel *cmodel = [CModel yy_modelWithJSON:dict];
                    [tempCidArray addObject:cmodel];
                }
                for (CModel *cmodel in tempCidArray) {
                    if ([cmodel.regionId integerValue]==[model.companyCity integerValue]) {
                        cidStr = cmodel.name;
                        tempcmodel = cmodel;
                        break;
                    }
                }
                for (NSDictionary *dict in tempcmodel.counties) {
                    DModel *dmodel = [DModel yy_modelWithJSON:dict];
                    [tempDidArray addObject:dmodel];
                }
                for (DModel *dmodel in tempDidArray) {
                    if ([dmodel.regionId integerValue]==[model.companyCounty integerValue]) {
                        didStr = dmodel.name;
                        tempdmodel = dmodel;
                        break;
                    }
                }
            }
        }else{
            for (NSDictionary *dict in temppmodel.cities) {
                CModel *cmodel = [CModel yy_modelWithJSON:dict];
                [tempCidArray addObject:cmodel];
            }
            for (CModel *cmodel in tempCidArray) {
                if ([cmodel.regionId integerValue]==[model.companyCity integerValue]) {
                    cidStr = cmodel.name;
                    tempcmodel = cmodel;
                    break;
                }
            }
            for (NSDictionary *dict in tempcmodel.counties) {
                DModel *dmodel = [DModel yy_modelWithJSON:dict];
                [tempDidArray addObject:dmodel];
            }
            for (DModel *dmodel in tempDidArray) {
                if ([dmodel.regionId integerValue]==[model.companyCounty integerValue]) {
                    didStr = dmodel.name;
                    tempdmodel = dmodel;
                    break;
                }
            }
        }
        if (!pidStr) {
            pidStr = @"";
        }
        if (!cidStr) {
            cidStr = @"";
        }
        if (!didStr) {
            didStr = @"";
        }
        model.companyAddress = [NSString stringWithFormat:@"%@ %@ %@",pidStr,cidStr,didStr];
    }else{
        model.companyAddress = @"";
    }
}

//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"headImgs" : @"arrayADTop",
//             @"footImgs" : @"arrayADBottom"};
//}

//- (NSString *)typeName {
//    NSInteger type = [self.companyType integerValue];
//    if (_typeName.length == 0) {
//        _typeName = [HomeClassificationDetailModel getTitleWithType:@(type).stringValue];
//    }
//    return _typeName;
//}

//- (NSMutableArray *)arrayBasicTitle {
//    if (!_arrayBasicTitle) {
//        if (self.isCompany) {
//        _arrayBasicTitle = @[@"品牌LOGO", @"品牌名称", @"类别", @"装修区域", @"服务范围", @"座机", @"地址", @"详细地址", @"业务经理电话", @"邮箱", @"网址", @"简介"].mutableCopy;
//        }else
//        _arrayBasicTitle = @[@"品牌LOGO", @"品牌名称", @"类别", @"服务范围", @"座机", @"地址", @"详细地址", @"业务经理电话", @"邮箱", @"网址", @"简介"].mutableCopy;
//    }
//    return _arrayBasicTitle;
//}
//
//- (NSMutableArray *)arrayBasicTitleInShow {
//    if (!_arrayBasicTitleInShow) {
//        if (self.isCompany) {
//            _arrayBasicTitleInShow = @[@"电 话", @"手 机", @"邮 箱", @"地 址", @"网 址"].mutableCopy;
//        }else
//            _arrayBasicTitleInShow = @[@"电 话", @"手 机", @"邮 箱", @"地 址", @"网 址"].mutableCopy;
//    }
//    return _arrayBasicTitleInShow;
//}
//
//- (NSMutableArray *)arrayBasic {
//    if (self.isCompany) {
//        _arrayBasic = @[self.companyLogo?:@"", self.companyName?:@"", self.typeName?:@"", self.areaList?:@"", self.serviceScope?:@"", self.companyLandline?:@"", self.companyAddress?:@"", self.addressDetail?:@"", self.companyPhone?:@"", self.companyEmail?:@"", self.URL?:@"", self.companyIntroduction?:@""].mutableCopy;
//    }else
//        _arrayBasic = @[self.companyLogo?:@"", self.companyName?:@"", self.typeName?:@"", self.serviceScope?:@"", self.companyLandline?:@"", self.companyAddress?:@"", self.addressDetail?:@"", self.companyPhone?:@"", self.companyEmail?:@"", self.URL?:@"", self.companyIntroduction?:@""].mutableCopy;
//    return _arrayBasic;
//}
//
//- (NSMutableArray *)arrayBasicInShow {
//    if (self.isCompany) {
//        _arrayBasicInShow = @[self.companyLandline?:@"", self.companyPhone?:@"", self.companyEmail?:@"", self.companyAddress?:@"", self.URL?:@""].mutableCopy;
//    }else
//        _arrayBasicInShow = @[self.companyLandline?:@"", self.companyPhone?:@"", self.companyEmail?:@"", self.companyAddress?:@"", self.URL?:@""].mutableCopy;
//    return _arrayBasicInShow;
//}

//- (NSMutableArray *)arrayADTop {
//    if (!_arrayADTop) {
//        _arrayADTop = @[@"", @""].mutableCopy;
//    }
//    return _arrayADTop;
//}
//
//- (NSMutableArray *)arrayADBottom {
//    if (!_arrayADBottom) {
//        _arrayADBottom = @[@"", @""].mutableCopy;
//    }
//    return _arrayADBottom;
//}
@end
