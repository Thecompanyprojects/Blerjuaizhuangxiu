//
//  DirectionModel.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DirectionModel.h"

static NSArray *_arrayTitle;
static NSArray *_arrayTitleVideo;
static NSArray *_arrayTitleVideoURL;
static NSArray *_arrayTitleIntroducFunction;
static NSArray *_arrayTitleIntroducFunctionURL;

@implementation DirectionModel

+ (NSArray *)arrayTitle {
    if (isCustomMadeHidden) {
        return @[@"功能介绍", @"操作视频", @"装修百科"];
    }else
        return @[@"功能介绍", @"操作视频", @"定制版使用攻略", @"装修百科"];
}

+ (NSArray *)arrayTitleVideo {
    /*
     【APP】1.注册流程
     【APP】2.爱装修企业网
     【APP】3.施工日志介绍
     【APP】4.家装计算器创建
     【APP】5.商户联盟
     【APP】6.合作企业

     【小程序】1.小程序用户信息登记
     【小程序】2.完善小程序信息
     【小程序】3.小程序后台

     【公众号】编辑公众菜单

     【PC网】后台编辑PC端设置
     */
    return @[@"【APP】1.注册流程", @"【APP】2.爱装修企业网", @"【APP】3.施工日志介绍", @"【APP】4.家装计算器创建", @"【APP】5.商户联盟", @"【APP】6.合作企业",
             @"【小程序】1.小程序用户信息登记", @"【小程序】2.完善小程序信息", @"【小程序】3.小程序后台", @"【小程序】4.小程序开发制作流程",
             @"【公众号】编辑公众菜单",
             @"【PC网】后台编辑PC端设置"];
//    return @[@"家装计算器创建视频", @"爱装修企业网", @"施工日志介绍", @"合作企业", @"商户联盟",@"爱装修注册流程", @"小程序后台", @"小程序用户信息登记", @"完善小程序信息", @"公众号菜单添加爱装修页面", @"后台编辑PC设置"];
}

+ (NSArray *)arrayTitleVideoURL {
    return @[@"http://api.bilinerju.com/api/designs/14200/10094.htm", @"resources/html/huangyewang.html", @"resources/html/shigongshipin.html", @"resources/html/jisuanqishipin.html", @"resources/html/shangjialianmengshipin.html", @"resources/html/hezuoqiyeshipin.html",
             @"resources/html/xiaochengxudengji_shipin.html", @"resources/html/xiaochengxu_shipin.html", @"resources/html/xiaochengxuhoutai_shipin.html", @"resources/html/xiaochengxukaifashipin.html",
             @"resources/html/gongzhonghao_shipin.html",
             @"http://open.iqiyi.com/developer/player_js/coopPlayerIndex.html?vid=4bd5673b6009d438076b91ae5a4739eb&tvId=21253154809&accessToken=2.f22860a2479ad60d8da7697274de9346&appKey=3955c3425820435e86d0f4cdfe56f5e7&appId=1368&height=100%&width=100%"
             ];
    /*
    return @[@"resources/html/jisuanqishipin.html",
     @"resources/html/huangyewang.html",
     @"resources/html/shigongshipin.html",
     @"resources/html/hezuoqiyeshipin.html",
     @"resources/html/shangjialianmengshipin.html",
     @"api/designs/14200/10094.htm",
     @"resources/html/xiaochengxuhoutai_shipin.html",
     @"resources/html/xiaochengxudengji_shipin.html",
     @"resources/html/xiaochengxu_shipin.html",
     @"resources/html/gongzhonghao_shipin.html",
     @"http://open.iqiyi.com/developer/player_js/coopPlayerIndex.html?vid=4bd5673b6009d438076b91ae5a4739eb&tvId=21253154809&accessToken=2.f22860a2479ad60d8da7697274de9346&appKey=3955c3425820435e86d0f4cdfe56f5e7&appId=1368&height=100%&width=100%"];
     */
}

+ (NSArray *)arrayTitleIntroducFunction {
    return @[@"注册与登录", @"创建/加入公司", @"创建总公司", @"创建分公司", @"创建工地", @"我的分销", @"个人资料", @"消息中心", @"其他"];
}

+ (NSArray *)arrayTitleIntroducFunctionURL {
    return @[@"resources/html/shuomingshu_dengluyuzhuce.html", @"resources/html/shuomingshu_chuanjianjiarugongsi.html", @"resources/html/shuomingshu_chuanjianzonggongsi.html ", @"resources/html/shuomingshu_chuanjianfengongsi.html", @"resources/html/shuomingshu_chuanjiangongdi.html", @"resources/html/shuomingshu_wodefenxiao.html", @"resources/html/shuomingshu_gerenziliao.html", @"resources/html/shuomingshu_xiaoxizhongxin.html", @"resources/html/shuomingshu_qita.html"];
}

@end
