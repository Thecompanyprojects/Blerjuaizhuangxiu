//
//  BLEJUrlHeader.h
//  Calculator
//
//  Created by 赵春浩 on 17/4/27.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#ifndef BLEJUrlHeader_h
#define BLEJUrlHeader_h

//// 本地测试环境
//#define BASEURL @"http://192.168.0.175:9999/blej-api-blej/api/"
//#define BASEHTML @"http://192.168.0.175:9999/blej-api-blej/"

////测试URL
//#define BASEURL @"http://testapi.bilinerju.com/api/"
//// 测试HTML
//#define BASEHTML @"http://testapi.bilinerju.com/"
////测试(微信)
//#define BASEURLWX @"http://testapi.bilinerju.com/wx/"

// 正式URL
#define BASEURL @"http://api.bilinerju.com/api/"
// 正式HTML
#define BASEHTML @"http://api.bilinerju.com/"
//正式(微信)
#define BASEURLWX @"http://api.bilinerju.com/wx/"

// 使用说明HTML
#define INSTRCTIONHTML @"http://mp.weixin.qq.com/s/vwOpE78OA1uiK0eT0sdCFg"
// 商品编辑页面的说明书
#define kEditGoodsExplainURL @"http://api.bilinerju.com/api/designs/5185/10094.htm"

// 计算器模板升级提示版本号， 4.2.0上线之前要修改
#define kCalculateVersionUp @"0"

//极光推送配置
#warning 测试正式数据库用1   平常和上线使用debug的
//#define kJPUSHFlag 1

#if DEBUG
#define kJPUSHFlag 0
#else
#define kJPUSHFlag 1
#endif

#if DEBUG
#define kReferer @"http://testapi.bilinerju.com"
#else
#define kReferer @"http://api.bilinerju.com"
#endif


// 是否有使用说明更新要提示  有使用更新值为1    没有使用更新值为0
#warning 有使用说明更新提示  有使用更新值为1    没有使用更新值为0 上线前需要注意
#define kHasUseExpalinUpdate 1

// 使用说明是否已读
#define kuseExplainFlag @"kuseExplainFlag"

// 同时登录的通知   更改通知： 现在使用环信的登录状态判断是否有账号在多台设备登录登录， 不再用接口返会状态码 88591 来发送通知实现
//#define sameTimeLogin @"sametimeLogin"


#define WeChatAPPID @"wxe0bf6a2c479e448c"
#define WeChatAPPSECRET @"7de1e35f768d510ebd380c135afa0dbf"
#define QQAPPID @"1105596224"
#define QQAPPKey @"A743ZcIQ0F7M8iT1"

#define EMSDKAppKey @"bilinerju#chaojiguanliyuan"

#define EMSDKDevCert @"dev"

#define EMSDKDisCert @"dis"


#define JPushAppKey @"4bbc4983f0e50965a7ea562d"
#define ALiPayAppid @"alipay2017011905225303"
// 友盟APPKEY
#define kUMKey @"57ccdde6e0f55a5ab4001059"


// 环信本地推送表示
#define kHXLocalNotificationIdentify @"kHXLocalNotificationIdentify"
// 环信来新消息后更新消息数量通知
#define kHXUpdateMessageNumberWhenRevievedMessage @"kHXUpdateMessageNumberWhenRevievedMessage"

// 注释掉环信 1 为注释掉   0 为打开  注释掉的有 环信接收到消息的代理 本地推动  和  聊天的入口  获取消息数量
#define DELETEHUANXIN 1

// 改变商品列表布局的通知
#define kChangeGoodsListLayoutNotificationIdentify @"kChangeGoodsListLayoutNotificationIdentify"

// 改变商品价格排序
#define kChangeGoodsPriceSort @"kChangeGoodsPriceSort"

#define kEditingGoodsCompletionNotificationIdentify @"kEditingGoodsCompletionNotificationIdentify"

#endif
