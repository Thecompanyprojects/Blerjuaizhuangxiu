//
//  BLRJCalculatortempletModelAllCalculatorcompanyData.h
//  iDecoration
//
//  Created by john wall on 2018/8/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"

//"code": "1000",
//"data": {
//    "company": {
//        "calVip": 1,
//        "calVipEndTime": 1542124800000,
//        "calculatorType": 2,
//        "companyAddress": "北京市-东城区 北京市昌平区",
//        "companyId": 1398,
//        "companyLogo": "http://testimage.bilinerju.com/group1/M00/00/99/rBHg0VqmKP-AfkfPAAH4xkmOPbk923.jpg",
//        "companyName": "北京中安瑞公司",
//        "introduction": "温馨提示：尊敬的业主您好，您现在看到的是我公司的预算报价总计，稍后我公司将有客服人员与您联系， 并将详细报价清单发送给您，如有打扰敬请谅解！",
//        "recommend": 0,
//        "templetId": 346
//    },
//    "list": [
//             {
//                 "deal": 0,
//                 "length": 0,
//                 "merchandId": 0,
//                 "needed": 1,
//                 "number": 0,
//                 "spec": "",
//                 "sumMoney": 0,
//                 "supplementId": 20308,
//                 "supplementName": "基础处理（腻子）",
//                 "supplementPrice": 23.5,
//                 "supplementTech": "1、批刮腻子二遍，打磨平整。 2、铲除原墙面亲水性涂层另加2.2元/平米；墙面防开裂处理另计。 3、门窗洞口减半计算。 4、包工料。 5、原墙面水泥基层空鼓或龟裂，须经物业重新处理；如需我方处理空鼓或龟裂，根据实际情况另计价格。",
//                 "supplementUnit": "",
//                 "templeteId": 346,
//                 "templeteTypeNo": 2011,
//                 "width": 0
//             },
//             {},
@interface BLRJCalculatortempletModelAllCalculatorcompanyData : NSObject

/**
 *  字典内模型
 */
//@property (strong, nonatomic) NSMutableArray<BLRJCalculatortempletModelAllCalculatorTypes *> *allCalculatorItems;
/**
 *  公司Id
 */
@property (copy, nonatomic) NSString *companyId;
/**
 *  模板Id
 */
@property (copy, nonatomic) NSString *templetId;

/***   商家说明*/
@property (copy, nonatomic) NSString *introduction;

/**
 *  是否推荐到同城
 */
@property (nonatomic, copy) NSString *recommend;
/**
 *  公司logo
 */
@property (copy, nonatomic) NSString *companyLogo;
/**
 *  公司名称
 */
@property (copy, nonatomic) NSString *companyName;
/**
 *  公司地址
 */
@property (copy, nonatomic) NSString *companyAddress;


/**
 *  vip标识（是否开通统计计算器时间非0开通）
 */
@property (copy, nonatomic) NSString *calVip;
/**
 *  会员结束时间(没有开通的话就是空串)
 */
@property (copy, nonatomic) NSString *calVipEndTime;
/**
 *  计算器类型
 */
@property (copy, nonatomic) NSString *calculatorType;
/**
 *   计算器模板状态0：老模板，1：新模板，2：完成简装或精装设置
 */
//@property (copy, nonatomic) NSString *templetStatus;
@end
