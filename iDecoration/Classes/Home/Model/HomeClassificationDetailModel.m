//
//  HomeClassificationDetailModel.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/9.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "HomeClassificationDetailModel.h"
#import "HomeClassificationDetailCollectionViewCell.h"

static NSArray *_arrayTitle;
static NSArray *_arrayDetail;
static NSArray *_arrayDetailShop;
static NSArray *_newarrayDetailShop;
static NSArray *_arrayDetailIcon;
static NSMutableArray *_arrayIsSelected;

@implementation HomeClassificationDetailModel

- (void)setLinesWithIndex:(NSInteger)index AndIsBottom:(BOOL)isBottom {
    self.viewLineRightHidden = false;
    self.viewLineBottomHidden = false;

    if (index < 2) {
        self.viewLineRightToTop = IphoneX?40:40 * Yrang;
    }
    if (index%2 != 0) {
        self.viewLineRightHidden = true;
        self.viewLineBottomToLeft = 0;
        self.viewLineBottomToRight = 20 * Yrang;
    }else{
        self.viewLineBottomToLeft = 20 * Yrang;
        self.viewLineBottomToRight = 0;
    }
    if (isBottom) {
        self.viewLineBottomHidden = true;
        self.viewLineRightToBottom = IphoneX?35:35 * Yrang;
    }
}

+ (NSMutableArray *)arrayIsSelected {
    if (!_arrayIsSelected) {
        _arrayIsSelected = @[@(0), @(0), @(0), @(0), @(0)].mutableCopy;
    }
    return _arrayIsSelected;
}

+ (NSArray *)arrayTitle {
    if (!_arrayTitle) {
        _arrayTitle = @[@"硬装软装", @"主材辅材", @"家具电器", @"配套/服务", @"家居生活"];
    }
    return _arrayTitle;
}

+ (NSArray *)arrayDetail {
    if (!_arrayDetail) {
        _arrayDetail = @[@[@"装修公司", @"整装公司", @"软装馆", @"设计工作室", @"新型装修", @"家纺布艺", @"互联网+", @"其他"], @[@"瓷砖", @"卫浴洁具", @"品牌橱柜", @"品牌衣柜", @"五金日杂", @"墙布墙纸", @"门窗", @"地板", @"灯具开关", @"石材", @"吊顶", @"成品定制", @"环保材料", @"装饰辅材", @"隔断背景墙", @"橡胶材料", @"竹木材料", @"楼梯", @"冷暖净水", @"暖通管道", @"金属材料", @"艺术玻璃", @"油漆涂料", @"新型材料", @"互联网+", @"其他"], @[@"办公家具", @"电器", @"家具沙发", @"智能家居", @"机电工具", @"灯具开关", @"互联网+", @"其他"], @[@"监理公司", @"空气治理", @"广告传媒", @"搬家运输", @"家政保洁", @"软包纱窗", @"家居风水", @"瓷砖美缝", @"房屋中介", @"消防器材", @"互联网+", @"其他"], @[@"家居用品", @"晾衣架", @"绿植花卉", @"新风系统", @"家纺布艺", @"名人名画", @"艺术字画", @"机器人", @"钟表摆件", @"互联网+", @"其他"]];
    }
    return _arrayDetail;
}

+ (NSArray *)arrayDetailShop {
    if (!_arrayDetailShop) {
        _arrayDetailShop = @[@[@"软装馆", @"设计工作室", @"家纺布艺", @"互联网+", @"其他"], @[@"瓷砖", @"卫浴洁具", @"品牌橱柜", @"品牌衣柜", @"五金日杂", @"墙布墙纸", @"门窗", @"地板", @"灯具开关", @"石材", @"吊顶", @"成品定制", @"环保材料", @"装饰辅材", @"隔断背景墙", @"橡胶材料", @"竹木材料", @"楼梯", @"冷暖净水", @"暖通管道", @"金属材料", @"艺术玻璃", @"油漆涂料", @"新型材料", @"互联网+", @"其他"], @[@"办公家具", @"电器", @"家具沙发", @"智能家居", @"机电工具", @"灯具开关", @"互联网+", @"其他"], @[@"监理公司", @"空气治理", @"广告传媒", @"搬家运输", @"家政保洁", @"软包纱窗", @"家居风水", @"瓷砖美缝", @"房屋中介", @"消防器材", @"互联网+", @"其他"], @[@"家居用品", @"晾衣架", @"绿植花卉", @"新风系统", @"家纺布艺", @"名人名画", @"艺术字画", @"机器人", @"钟表摆件", @"互联网+", @"其他"]];
    }
    return _arrayDetailShop;
}


+ (NSArray *)newarrayDetailShop {
    if (!_newarrayDetailShop) {
        _newarrayDetailShop = @[@[@"软装馆", @"设计工作室", @"家纺布艺", @"互联网+", @"其他",@"装修公司",@"整装公司",@"新型装修"], @[@"瓷砖", @"卫浴洁具", @"品牌橱柜", @"品牌衣柜", @"五金日杂", @"墙布墙纸", @"门窗", @"地板", @"灯具开关", @"石材", @"吊顶", @"成品定制", @"环保材料", @"装饰辅材", @"隔断背景墙", @"橡胶材料", @"竹木材料", @"楼梯", @"冷暖净水", @"暖通管道", @"金属材料", @"艺术玻璃", @"油漆涂料", @"新型材料", @"互联网+", @"其他"], @[@"办公家具", @"电器", @"家具沙发", @"智能家居", @"机电工具", @"灯具开关", @"互联网+", @"其他"], @[@"监理公司", @"空气治理", @"广告传媒", @"搬家运输", @"家政保洁", @"软包纱窗", @"家居风水", @"瓷砖美缝", @"房屋中介", @"消防器材", @"互联网+", @"其他"], @[@"家居用品", @"晾衣架", @"绿植花卉", @"新风系统", @"家纺布艺", @"名人名画", @"艺术字画", @"机器人", @"钟表摆件", @"互联网+", @"其他"]];
    }
    return _newarrayDetailShop;
}


+ (NSInteger)getTypeWithTitle:(NSString *)title {
    NSArray *titleArr = @[@"装修公司", @"成品定制", @"门窗",
                          @"瓷砖", @"品牌橱柜", @"油漆涂料",
                          @"墙布墙纸", @"暖通管道", @"地板",
                          @"软装馆", @"卫浴洁具", @"电器",
                          @"品牌衣柜", @"房屋中介", @"设计工作室",
                          @"家具沙发", @"石材", @"吊顶",
                          @"隔断背景墙", @"环保材料", @"装饰辅材",
                          @"五金日杂", @"冷暖净水", @"灯具开关",
                          @"监理公司", @"家纺布艺", @"智能家居",
                          @"软包纱窗", @"家政保洁", @"搬家运输",
                          @"瓷砖美缝", @"家居风水", @"绿植花卉",
                          @"艺术玻璃", @"机电工具", @"家居用品",
                          @"竹木材料", @"金属材料", @"消防器材",
                          @"办公家具", @"广告传媒", @"橡胶材料",
                          @"楼梯", @"空气治理", @"整装公司", @"新型装修", @"新型材料", @"新风系统", @"艺术字画", @"名人名画", @"钟表摆件", @"机器人", @"晾衣架"];
    NSArray *typeArr = @[@"1018", @"1035", @"1049",
                         @"1003", @"1004", @"1008",
                         @"1053", @"1037", @"1051",
                         @"1001", @"1002", @"1056",
                         @"1024", @"1020", @"1022",
                         @"1025", @"1050", @"1054",
                         @"1026", @"1041", @"1055",
                         @"1027", @"1042", @"1052",
                         @"1063", @"1062", @"1019",
                         @"1017", @"1013", @"1014",
                         @"1016", @"1044", @"1059",
                         @"1031", @"1045", @"1060",
                         @"1032", @"1046", @"1033",
                         @"1047", @"1034", @"1048",
                         @"1043", @"1015", @"1064", @"1065", @"1068", @"1075", @"1076", @"1077", @"1078", @"1079", @"1082"];
    NSInteger type = 0;
    for (int i = 0; i < titleArr.count; i++) {
        NSString *titleArrTitle = titleArr[i];
        if ([title isEqualToString:titleArrTitle]) {
            type = [typeArr[i] integerValue];
            return type;
        }
    }
    return 0;
}

+ (NSString *)imageIconName:(NSString *)string {
    NSString *name = @"";
    name = [NSString stringWithFormat:@"icon_%@",[HomeClassificationDetailModel transform:string]];
    return name;
}

+ (NSString *)transform:(NSString *)chinese {
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [chinese mutableCopy];
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    //返回最近结果
    NSString *final = [pinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
    return final;
}

+ (NSString *)getTitleWithType:(NSString *)type {
    NSInteger index = type.integerValue;
    if (index == 1066 || index == 1069 || index == 1071 || index == 1073 || index == 1080) {
        return @"互联网+";
    }
    if (index == 1067 || index == 1070 || index == 1072 || index == 1074 || index == 1081) {
        return @"其它";
    }
    NSArray *titleArr = @[@"装修公司", @"成品定制", @"门窗",
                          @"瓷砖", @"品牌橱柜", @"油漆涂料",
                          @"墙布墙纸", @"暖通管道", @"地板",
                          @"软装馆", @"卫浴洁具", @"电器",
                          @"品牌衣柜", @"房屋中介", @"设计工作室",
                          @"家具沙发", @"石材", @"吊顶",
                          @"隔断背景墙", @"环保材料", @"装饰辅材",
                          @"五金日杂", @"冷暖净水", @"灯具开关",
                          @"监理公司", @"家纺布艺", @"智能家居",
                          @"软包纱窗", @"家政保洁", @"搬家运输",
                          @"瓷砖美缝", @"家居风水", @"绿植花卉",
                          @"艺术玻璃", @"机电工具", @"家居用品",
                          @"竹木材料", @"金属材料", @"消防器材",
                          @"办公家具", @"广告传媒", @"橡胶材料",
                          @"楼梯", @"空气治理", @"整装公司", @"新型装修", @"新型材料", @"新风系统", @"艺术字画", @"名人名画", @"钟表摆件", @"机器人", @"晾衣架"];
    NSArray *typeArr = @[@"1018", @"1035", @"1049",
                         @"1003", @"1004", @"1008",
                         @"1053", @"1037", @"1051",
                         @"1001", @"1002", @"1056",
                         @"1024", @"1020", @"1022",
                         @"1025", @"1050", @"1054",
                         @"1026", @"1041", @"1055",
                         @"1027", @"1042", @"1052",
                         @"1063", @"1062", @"1019",
                         @"1017", @"1013", @"1014",
                         @"1016", @"1044", @"1059",
                         @"1031", @"1045", @"1060",
                         @"1032", @"1046", @"1033",
                         @"1047", @"1034", @"1048",
                         @"1043", @"1015", @"1064", @"1065", @"1068", @"1075", @"1076", @"1077", @"1078", @"1079", @"1082"];
    NSString *title = @"";
    for (int i = 0; i < typeArr.count; i++) {
        NSString *typeArrType = typeArr[i];
        if ([type isEqualToString:typeArrType]) {
            title = titleArr[i];
            return title;
        }
    }
    return title;
}
@end
